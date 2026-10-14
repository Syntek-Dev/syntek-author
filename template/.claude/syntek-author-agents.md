# Shared writing instructions for coding agents

> **Template-owned.** Shipped by syntek-author and replaced by every `copier update`: never edit
> it here. Project rules belong in `.claude/CLAUDE.md` and project settings in
> `.claude/rules/syntek-author/00-project.md`.

Codex, Gemini CLI, Antigravity and OpenCode read this file through the root `AGENTS.md` or
`GEMINI.md`. Claude Code needs none of it: it loads the same files natively. The `.claude/`
tree is the one source of truth for every client. Nothing here adds a rule; it says how to
reach the rules that already exist.

## Read order and precedence

1. Read `.claude/CLAUDE.md`, then every file it imports with an `@` line (the root
   `CONTEXT.md`). An `@` line is a pointer to read, even when this client does not expand it.
2. Read every Markdown file under `.claude/rules/`, recursively, including each other
   template's folder. Claude Code loads them at launch; no other client does, so read them
   explicitly before working. `.claude/rules/syntek-author/00-project.md` holds this
   project's settings and outranks the other rules files; `.claude/CLAUDE.md`'s project rules
   come next, then the template's rules.
3. Read `.claude/MEMORY.md`, then the `CONTEXT.md` and `CLAUDE.md` of the folder you are about
   to work in, in that order. A folder's `CLAUDE.md` opens with `@./CONTEXT.md`: read that file
   too. Follow its routing to project guides (`docs/project/`) and local workflows
   (`workflows/local/`) before the template's.
4. Before following a skill, read its `SKILL.md` and the one mode file beside it, if any.
   Discover only the skills present in this project: the variant and the options decide which
   ship.

`AGENTS.md`, `GEMINI.md` and any project-specific instruction the author has added stay
authoritative alongside this file. The rules define the authoring loop, who decides what,
provenance, the two flags and never fabricating; nothing in a client's settings changes them.

## Skills

- `.agents` is a relative link to `.claude`, so `.agents/skills/` and `.claude/skills/` are one
  tree with one copy of each skill. Never copy a skill into a client's own folder.
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
  Turn off automatic compaction or summarising where the client allows it.
- **The settings file's denies are rules.** `.claude/settings.json` denies some edits and tools
  in Claude Code (built PDFs, `build/`, and every other path it lists). Treat every deny there
  as a rule in this client too. Where it denies asking the author through a
  dialog, ask in the conversation instead.
- **Permission is not approval.** A client that lets you edit or run a command has not given the
  author's approval. Promotion, standards changes and anything the rules reserve to the author
  still need the author's explicit word.
- **Paid calls.** A skill that spends credits (text-to-speech, for example) states the cost and
  waits for the author, in every client. A configured server is not approval to call it.

## Client setup

| Client | Entrypoint | Project settings | Skills |
|---|---|---|---|
| Codex | `AGENTS.md` | `config.toml` in `.codex`: started in a folder, reads its `CLAUDE.md` chain; loads only once you trust the project | `.agents/skills` |
| Gemini CLI | `GEMINI.md` | `settings.json` in `.gemini`: model and MCP servers | `.agents/skills` |
| Antigravity | `GEMINI.md` | `mcp_config.json` in `.claude` (also seen in `.agents`): MCP servers; model chosen in the app | `.agents/skills` |
| OpenCode 2 or later | `AGENTS.md` | `opencode.json` (OpenCode 2's format): the model, a local server, edit permissions | `.claude/skills` and `.agents/skills` |

- **OpenCode reads no `CLAUDE.md` at all.** Step 3 above is not optional there: open each
  folder's `CONTEXT.md` and `CLAUDE.md` yourself.
- **Codex** reads instruction files once, at the start, and at most 32 KiB of them by default,
  far less than the rules. Read the rules files and each folder's manuals directly. Trust the
  project in Codex, or it may load neither its settings nor `AGENTS.md`.
- **Local models** run through OpenCode: `opencode.json` names the server and its context, which
  must not exceed what the server loads. Ollama loads 4096 tokens unless started with
  `OLLAMA_CONTEXT_LENGTH` (or a model's `num_ctx`) at least as large. Test
  tool calling on a scratch repository before trusting a local model with a draft. Codex can use
  a local model only through your user-level Codex settings, never this project's.
- **MCP servers.** Claude Code reads `.mcp.json`; Codex, Gemini CLI, Antigravity and OpenCode
  each have their own file and format (Antigravity's remote servers take `serverUrl`, not `url`).
  Configure a server in each client you use, from that client's current documentation; preserve existing entries and keep credentials out of Git.

## Another template in this project

A companion template (`syntek-media`, for example) ships its own bridge beside this one, named
`.claude/<template>-agents.md`. Read every such bridge present, and every rules folder
under `.claude/rules/`. Where two templates' rules meet, this project's settings and
`.claude/CLAUDE.md` decide; ask the author when they do not.

## Enabling a client in an existing project

The entrypoints, the `.agents` link and the client settings are written once, when the project
is generated: `copier update` never adds them, changes them or brings back one you deleted. It
does keep this file and the model table in the rules up to date for the clients the answers
name. To add a client later:

1. Record it: `copier update -a .copier-answers.syntek-author.yml` with the client added to
   `AGENT_CLIENTS` (`--data`). That brings this file and the model table, and nothing else.
   Never edit the answers file by hand.
2. Generate a fresh project into a temporary folder from the source and version the answers
   file records, with that answers file as `--data-file`. Never run another copy over the real
   project.
3. Compare the fresh project's `AGENTS.md`, `GEMINI.md`, `.codex`, `.gemini`,
   `opencode.json`, `mcp_config.json` in `.claude`, and `.agents` with the real project's. Copy only
   the files that are missing. Where a file already exists, agree with the author how to
   combine it; never overwrite it.
4. Where `.agents` is absent, create the relative link `.agents -> .claude`. A real `.agents`
   directory, or a link to anywhere else, stays as it is: integrate its skills by hand with the
   author. A `copier copy` over such a project needs `--exclude /.agents`.
5. Where an `AGENTS.md` or `GEMINI.md` already exists, add an agreed line pointing to this file.
   Restart the client and confirm that it reads this file, the rules, the memory and the skills.
6. Record the added client in `.claude/MEMORY.md`. Later updates still need
   `-a .copier-answers.syntek-author.yml`.
