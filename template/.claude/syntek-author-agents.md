# Shared writing instructions for coding agents

> **Template-owned.** Shipped by syntek-author and replaced by every `copier update`: never edit
> it here. Project rules belong in `.claude/CLAUDE.md` and project settings in
> `.claude/rules/syntek-author/00-project.md`.

If no other client is set up yet, this file's last section says how to add one.

Codex, Gemini CLI, Antigravity and OpenCode reach this file through the root `AGENTS.md` or
`GEMINI.md`, which send them to every `.claude/syntek-*-agents.md` present. Claude Code needs
none of it: it loads the same files natively. The `.claude/` tree is the one source of truth for
every client. Nothing here adds a rule; it says how to reach the rules that already exist.

## Read order and precedence

1. Read every other `.claude/syntek-*-agents.md` present as well: each template applied to this
   project ships its own bridge.
2. Read `.claude/CLAUDE.md`, then every file it imports with an `@` line (the root
   `CONTEXT.md`). An `@` line is a pointer to read, even when this client does not expand it;
   Codex and OpenCode pass it through as plain text.
3. Read every Markdown file under `.claude/rules/`, recursively, including each other
   template's folder. Claude Code loads them at launch; no other client does, so read them
   explicitly before working.
4. Read `.claude/MEMORY.md`, then the `CONTEXT.md` and `CLAUDE.md` of the folder you are about
   to work in, in that order. A folder's `CLAUDE.md` opens with `@./CONTEXT.md`: read that file
   too. Follow its routing to project guides (`docs/project/`) and local workflows
   (`workflows/local/`) before the template's.
5. Before following a skill, read its `SKILL.md` and the one mode file beside it, if any.
   Discover only the skills present in this project: the variant and the options decide which
   ship.

**Precedence.** `.claude/rules/syntek-author/00-project.md` holds this project's settings and
outranks every other rules file; the project rules in `.claude/CLAUDE.md` come next, then the
template's rules. `AGENTS.md`, `GEMINI.md` and any instruction the author has added to them stay
authoritative alongside this file. The rules define the authoring loop, who decides what,
provenance, the two flags and never fabricating; nothing in a client's settings changes them.

## Skills

- `.claude/skills/` is the one skill tree. `.agents` is a real folder for the clients that look
  there; the `skills` in it is a relative link to `../.claude/skills`, so both paths hold one
  copy of each skill. `.agents` has no `CONTEXT.md` or `CLAUDE.md`: it is a discovery folder,
  not a working one. Never copy a skill into a client's own folder,
  and never make `.agents` itself a link to `.claude` (Codex's sandbox on Linux refuses it).
- **On Windows**, Git may check the link out as a small text file holding `../.claude/skills`
  (`core.symlinks` off). Turn on symbolic links (Developer Mode, then
  `git config core.symlinks true` and `git checkout -- .agents/skills`), or recreate the link
  by hand. Never replace it with a copy of the skills.
- **An `.agents` link to a folder outside the project.** Copier refuses to render anything
  beneath it, `--exclude` included, so the link alone is moved aside and put back; its target is
  never touched. Every update does this itself: it renames the link to `.agents.syntek-held`
  before the render and back afterwards. If an update stops before it ends (a refused answer,
  Ctrl-C at a question), the link stays held and the next update refuses the changed tree: run
  `mv .agents.syntek-held .agents` from the project root, then update again. A copy runs no
  migration, so before a `copier copy` run `mv .agents .agents.syntek-held`, copy with
  `--exclude /.agents`, then run `mv .agents.syntek-held .agents`.
- Where a file says to run a skill (`the handoff skill`, `Skill(draft-section)`), use this
  client's skill mechanism with the same name; if it has none, read the `SKILL.md` and follow it.
  A skill marked to run as a background or forked agent runs inline where the client has none.
- A skill's tools are named for Claude Code. Map each to this client's tool by capability (read,
  edit, search, run a command, fetch a web page). If a capability is missing, say so and use the
  skill's manual route; never report a call that did not happen.

## Models

`.claude/rules/syntek-author/05-model-allocation.md` defines two tiers, substantive and
mechanical, and names the model each client uses here. Elsewhere, `opus` and `sonnet` in
frontmatter and checklist tags are tier labels, not model names. Use the substantive model for
anything that decides meaning; when in doubt, the work is substantive.

## What Claude Code enforces and other clients must follow

- **Hand off, never compact.** Claude Code blocks automatic compaction with a hook. No other
  client runs it. Follow `.claude/rules/syntek-author/07-session-boundaries.md` by hand: write a
  handoff with the `handoff` skill before the context runs low, and start a new session from it.
  Turn off automatic compaction or summarising where the client allows it (`opencode.json` does).
- **The settings file's denies are rules.** `.claude/settings.json` denies some edits and tools
  in Claude Code (built PDFs, `build/`, and every other path it lists). Treat every deny there
  as a rule in this client too. Where it denies asking the author through a dialog, ask in the
  conversation instead.
- **Passing the settings to each client.** `python3 .claude/syntek-author-permissions.py --check`
  (Python 3.11 or later) prints which of those denies and asks each client's file already
  carries, which it cannot express and why, and exits 1 if one it can express is missing.
  `--write` adds the missing ones to the client files that already exist, changing only their
  permission keys; it never creates a file. Run it after changing `.claude/settings.json` or
  adding a client, with the author's agreement. Allow rules stay with each client.
- **The data root stays out of the session.** A data root is a folder outside every repository
  that holds a `.syntek-data-root` marker; this machine's is the one `SYNTEK_DATA_ROOT` names.
  Claude Code's `PreToolUse` hook (where `.claude/settings.json` wires it) blocks its file tools'
  edits and writes there, and its searches where it offers `Grep` and `Glob`; no other client
  runs it. Never browse, search, list or edit anything under a data root, by any tool or shell
  command. Reach its files only through the project's data-root commands: `make root` (the
  root, the store, this project's layout and the provider's checklist), `make files-add`,
  `make files-status`, `make files-verify`, `make files-pull` and `make files-plan`, which run
  `python3 .claude/syntek-author-dataroot.py` (Python 3.11 or later). Open a file there only at
  the path that tool's `path` subcommand prints. `.claude/rules/syntek-author/09-data-root.md`
  says when each is used and what each refusal means; never work round one.
- **Permission is not approval.** A client that lets you edit or run a command has not given the
  author's approval. Promotion, standards changes and anything the rules reserve to the author
  still need the author's explicit word.
- **Paid calls.** A skill that spends credits (text-to-speech, for example) states the cost and
  waits for the author, in every client. A configured server is not approval to call it.

## Client setup

| Client | Entrypoint | Project settings | Skills |
|---|---|---|---|
| Codex | `AGENTS.md` | `config.toml` in `.codex`: the `CLAUDE.md` fallback, the model, the MCP servers and their prompts | `skills` in `.agents` |
| Gemini CLI | `GEMINI.md` | `settings.json` in `.gemini`: model, MCP servers, excluded tools | `skills` in `.agents` |
| Antigravity | `GEMINI.md` (and `AGENTS.md` where present) | `mcp_config.json` in `.agents`: MCP servers; model chosen in the app | `skills` in `.agents` |
| OpenCode 2 or later | `AGENTS.md` | `opencode.json` (OpenCode 2's format): model, local server, the MCP servers and their asks, permissions, no auto-compaction | `.claude/skills` and `skills` in `.agents` |

- **Codex** loads this project's settings and its `CLAUDE.md` fallback only once you trust the
  project; a project marked untrusted loads no `AGENTS.md` at all. In each folder an
  `AGENTS.override.md` beats `AGENTS.md`. Codex reads instruction files once, at the start, and
  at most 32 KiB of them by default, far less than the rules: read the rules files and each
  folder's manuals directly. It never reads `GEMINI.md`.
- **Gemini CLI** loads this project's settings, its MCP servers and the `.agents` skills only
  once the folder is trusted, and folder trust is on by default: trust the project when asked.
  It warns at every start that `tools.exclude` is deprecated; that key is the only project-level
  way to hide `ask_user` while workspace policies are disabled, so leave it.
- **Antigravity** reads both entrypoints where both exist; they carry the same pointer. Its remote MCP servers
  take `serverUrl`, not `url`.
- **OpenCode reads no `CLAUDE.md` at all.** Step 4 above is not optional there: open each
  folder's `CONTEXT.md` and `CLAUDE.md` yourself. Start it at the project root: its permission
  paths are relative to the folder it starts in, and the last matching rule wins. A global skill
  with the same name as a project skill wins over it; rename or remove the global one. OpenCode
  also lists `CONTEXT.md` and `CLAUDE.md` in `.claude/skills/` as two skills, `CONTEXT` and
  `CLAUDE`: they are the folder's map, not procedures, so never run them.
- **Local models** run through OpenCode: `opencode.json` names the server and its context, which
  must not exceed what the server loads. Ollama's default context depends on the machine's video
  memory (4k, 32k or 256k tokens) unless `OLLAMA_CONTEXT_LENGTH` or a model's `num_ctx` sets it;
  raise the server's setting and the number in `opencode.json` together. Test tool calling on a
  scratch repository before trusting a local model with a draft. Codex can use a local model
  only through your user-level Codex settings, never this project's.
- **MCP servers.** Every project ships two, pinned and keyless, in `.mcp.json` and in each
  client's own file: `scrapling` (web pages) and `code-review-graph` (a local map of the code).
  Use them as `.claude/rules/syntek-author/06-global-rules.md` Section 13 says: ask the author
  before each of the six asked browser tools, and never run `code-review-graph install` or
  `scrapling install`. Codex and Gemini CLI start them only in a trusted project; OpenCode
  starts them when it opens the project. The first start downloads them through `uvx`, and a
  client may give up waiting once. The author runs these in their own terminal; a session never
  runs them. They warm the cache and download the Chromium that Scrapling drives, without
  administrator rights:

  ```bash
  uvx --from 'scrapling[ai]==0.4.15' --with 'playwright==1.63.0' --with 'patchright==1.63.0' scrapling --version
  uvx code-review-graph==2.3.9 --version
  uvx --from 'playwright==1.63.0' playwright install chromium
  ```

  Where that Chromium then fails to start for missing system libraries, Playwright's
  `install-deps chromium` installs them with administrator rights: the author runs it, never a
  session. An update offers the two servers once to each of these files that lacks them and
  never adds back one you removed. Add any other server from that client's current
  documentation; preserve existing entries and keep credentials out of Git.

## Another template in this project

A companion template (`syntek-media`, for example) ships its own bridge beside this one, named
`.claude/<template>-agents.md`, and may share the entrypoints, `.agents` and the client
settings. Read every such bridge present, and every rules folder under `.claude/rules/`. Where
two templates' rules meet, this project's settings and `.claude/CLAUDE.md` decide; ask the
author when they do not.

## Enabling a client in an existing project

The entrypoints, `.agents` and the client settings are written once, when the project is
generated: `copier update` never adds them or brings back one you deleted, and changes them only
by adding each of the two shipped MCP servers once to a client file that lacks it. It does keep
this file and the model table in the rules up to date for the clients the answers
name. On the update that first asks which clients you use, the answer defaults to none. To add
a client later:

1. Record it: `copier update -a .copier-answers.syntek-author.yml --data 'AGENT_CLIENTS=[…]'`,
   listing every client you keep as well as the new one. That brings the model table and
   nothing else. Never edit the answers file by hand.
2. Generate a fresh project into a temporary folder from the source and version the answers
   file records, with that answers file as `--data-file`. Never run another copy over the real
   project.
3. Compare the fresh project's `AGENTS.md`, `GEMINI.md`, `.codex`, `.gemini`, `opencode.json`,
   and the `mcp_config.json` and `skills` link in `.agents`, with the real project's. Copy only the files
   that are missing. Where a file already exists, agree with the author how to combine it;
   never overwrite it.
4. Where `.agents` is absent, create the real folder and its link from the project root:
   `mkdir .agents && ln -s ../.claude/skills .agents/skills`. Where `.agents` is itself a link
   to `.claude` (an older layout), agree with the author to remove that link (`rm .agents`, with
   no trailing slash, removes only the link) and create the folder in its place, moving any
   `mcp_config.json` from `.claude` into it. A real `skills` folder in `.agents`, or a link to
   anywhere else, stays as it is: integrate its skills by hand with the author. A `copier copy`
   over a real `skills` folder needs `--exclude /.agents/skills`; a `skills` link of any target
   is skipped. An `.agents` link to a folder outside the project stays a link: hold it aside for
   the copy as the Skills section says.
5. Where an `AGENTS.md` or `GEMINI.md` already exists, add an agreed line telling the client to
   read every `.claude/syntek-*-agents.md` present. Then run
   `python3 .claude/syntek-author-permissions.py --check`, and `--write` if the author agrees.
   Restart the client and confirm that it reads this file, the rules, the memory and the skills.
6. Record the added client in `.claude/MEMORY.md`. Later updates still need
   `-a .copier-answers.syntek-author.yml`.
