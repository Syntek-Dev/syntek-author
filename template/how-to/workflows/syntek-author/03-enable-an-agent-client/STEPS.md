---
workflow: 03-enable-an-agent-client
phase: plan
skills: []
model: opus
---

# STEPS.md — enable an agent client

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for adding Codex, Gemini CLI, Antigravity or OpenCode to a project that
has none of its files. Each step names the guide it uses. **Run in order**, from the top folder
of the project, and tick `CHECKLIST.md` as you go. Every command runs exactly as written, in
bash, zsh or another POSIX shell; steps 2 to 8 run in one terminal, because they share the
temporary folder's path in `$FRESH`.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). No skill runs
> this procedure. Every file copied in, and every existing file combined, waits for the
> author's word.

## 1. Record the client

> **Skill:** none · **Guide:** `how-to/docs/syntek-author/enabling-an-agent-client.md`

Recording the client is an update: follow steps 1 to 3 of
`how-to/workflows/syntek-author/01-update-the-template/` first, run the command below in place
of its step 4, then follow its steps 5 to 8, which commit it. The answer lists every client the
project keeps, the new one included; this example keeps Codex and OpenCode, so put the
project's own list in its place, using `codex`, `gemini-cli`, `antigravity` and `opencode`:

```bash
GIT_CONFIG_COUNT=2 GIT_CONFIG_KEY_0=gc.auto GIT_CONFIG_VALUE_0=0 GIT_CONFIG_KEY_1=maintenance.auto GIT_CONFIG_VALUE_1=false \
  uvx --python '>=3.14' copier update --trust -a .copier-answers.syntek-author.yml --data 'AGENT_CLIENTS=[codex, opencode]'
```

The author runs it in their own terminal, where Copier asks the client's own questions, such as
its model. A session has no terminal for those questions, so it never runs the command above;
where the author asks a session to run it, the session runs this form, which gives each question
the client brings its default:

```bash
GIT_CONFIG_COUNT=2 GIT_CONFIG_KEY_0=gc.auto GIT_CONFIG_VALUE_0=0 GIT_CONFIG_KEY_1=maintenance.auto GIT_CONFIG_VALUE_1=false \
  uvx --python '>=3.14' copier update --trust --defaults -a .copier-answers.syntek-author.yml --data 'AGENT_CLIENTS=[codex, opencode]'
```

It updates the model table in `.claude/rules/syntek-author/05-model-allocation.md`, and writes
none of the client's files. _Mechanical._

## 2. Render a fresh project into a temporary folder

> **Skill:** none · **Guide:** `how-to/docs/syntek-author/enabling-an-agent-client.md`

These commands read the template's source and version from the answers file, make a new empty
temporary folder, render a fresh project into it with the same answers, and print its path:

```bash
SRC=$(sed -n "s/^_src_path: *['\"]\{0,1\}\([^'\"]*\).*/\1/p" .copier-answers.syntek-author.yml)
REF=$(sed -n "s/^_commit: *['\"]\{0,1\}\([^'\"]*\).*/\1/p" .copier-answers.syntek-author.yml)
FRESH=$(mktemp -d)
uvx --python '>=3.14' copier copy --trust --defaults --vcs-ref="$REF" --data-file .copier-answers.syntek-author.yml "$SRC" "$FRESH"
echo "$FRESH"
```

They run as written whether or not the answers file quotes its values. Copier prints the files
it writes and ends with its message after a copy; the last line is the temporary folder's path.
A session that helps from here reads the fresh project at that path. Never run a copy over the
real project. _Mechanical._

## 3. Copy only the missing client files

> **Skill:** none · **Guide:** `how-to/docs/syntek-author/enabling-an-agent-client.md`

This command lists everything at the top of the fresh project that this project lacks:

```bash
if [ -d "$FRESH" ]; then
  for f in $(ls -A "$FRESH"); do [ -e "$f" ] || [ -L "$f" ] || echo "missing here: $f"; done
else
  echo 'No fresh project: run step 2 in this same terminal first.'
fi
```

Each `missing here:` line names one thing. Copy in only the client files that the list in
`.claude/syntek-author-agents.md`, 'Enabling a client in an existing project', names, each on
the author's word, with `cp -R`, the fresh copy first and `.` last, such as
`cp -R "$FRESH/opencode.json" .`; leave `.agents` to step 4, and every other line alone. Where a
client file the list names already exists here, such as an `AGENTS.md` written for another tool,
never copy over it: agree with the author how to combine the two, and combine them by hand.
Where `.codex` or `.gemini` already exists, compare its files with the fresh copy's the same way.
_Substantive._

## 4. Settle .agents

> **Skill:** none · **Guide:** `how-to/docs/syntek-author/enabling-an-agent-client.md`

Codex, Gemini CLI, Antigravity and OpenCode find the skills through `.agents`, a real folder
holding a `skills` link to `.claude/skills`. This command shows what stands there now:

```bash
ls -ld .agents
```

Where it says `No such file or directory`, this command creates the folder and its link:

```bash
mkdir .agents && ln -s ../.claude/skills .agents/skills
```

Afterwards `ls -l .agents` shows `skills -> ../.claude/skills`. Where `.agents` was already a
real folder holding that link, nothing is needed. Where the new client is
Antigravity, also copy its `mcp_config.json` in, on the author's word, with
`cp "$FRESH/.agents/mcp_config.json" .agents/`. The other cases are settled by hand with the
author, as `how-to/src/TEMPLATE-GUIDE/agent-clients-and-mcp.md` explains: where `.agents` is
itself a link to `.claude`, an older layout, agree to remove that link alone with `rm .agents`
(no trailing slash), then create the folder and its link as above, and move any
`mcp_config.json` from `.claude` into it; a real `skills` folder in `.agents`, or a `skills` link
to anywhere else, stays as it is, and its skills are combined with the project's by hand; and an
`.agents` link to a folder outside the project stays a link. _Substantive._

## 5. Send an existing entrypoint to every bridge

> **Skill:** none · **Guide:** `how-to/docs/syntek-author/enabling-an-agent-client.md`

Where the project already had its own `AGENTS.md` (Codex and OpenCode) or `GEMINI.md` (Gemini
CLI and Antigravity), so step 3 did not copy the template's, the client finds the project's
rules only if that file sends it there. Agree with the author one line to add to it, such as
'Read every `.claude/syntek-*-agents.md` present, in full, before any work.', and add it where
they choose. Nothing else in their file changes. _Substantive._

## 6. Carry the permission rules to the client

> **Skill:** none · **Guide:** `how-to/docs/syntek-author/enabling-an-agent-client.md`

The new client never reads `.claude/settings.json`, so its deny and ask rules must be copied
into the client's own file. This command shows the plan and any rule a client file lacks, and
changes nothing:

```bash
python3 .claude/syntek-author-permissions.py --check
```

It names each rule the new client's file lacks, and each rule that client cannot hold. On the
author's word, this command adds the missing rules to the client files that exist, and never
creates one:

```bash
python3 .claude/syntek-author-permissions.py --write
```

Run `--check` again afterwards: it should end `Every expressible rule is in place.` For
Antigravity, which keeps its permissions in the app, it lists what to set there instead.
_Mechanical._

## 7. Restart the client and confirm what it reads

> **Skill:** none · **Guide:** `how-to/docs/syntek-author/enabling-an-agent-client.md`

The author starts the new client from the top folder of the project. Codex and Gemini CLI ask
whether to trust the project: trust it, or they read none of its settings. Ask the client which
files it read before starting work: it should name its entrypoint,
`.claude/syntek-author-agents.md`, the rules in `.claude/rules/syntek-author/`,
`.claude/MEMORY.md` and the skills. Where it names none of them, check step 5, and that the
client was started from the project's top folder. Its first start may be slow while the two MCP
servers download; the commands that download them in advance are in
`.claude/syntek-author-agents.md`, under 'Client setup', for the author to run in their own
terminal. _Mechanical._

## 8. Record the client and clean up

> **Skill:** none · **Guide:** `how-to/docs/syntek-author/enabling-an-agent-client.md`

Record the added client, and the date, in `.claude/MEMORY.md`, with the author. Then the author
deletes the temporary folder, in the same terminal as step 2; a session never deletes it:

```bash
rm -rf "$FRESH"
```

It prints nothing. Then this command commits the client's files and the memory line:

```bash
git add -A && git commit -m 'Enable a coding agent client'
```

Afterwards `git status` should end `nothing to commit, working tree clean`. Later updates still
need `-a .copier-answers.syntek-author.yml` and the five `GIT_CONFIG_*` settings, as
`how-to/workflows/syntek-author/01-update-the-template/` gives them. _Mechanical._
