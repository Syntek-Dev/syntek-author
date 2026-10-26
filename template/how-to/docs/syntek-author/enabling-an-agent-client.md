---
type: guide
skills: []
model: opus
---

# Enabling an agent client — adding Codex, Gemini CLI, Antigravity or OpenCode to a project that has none of its files

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** A coding agent, or client, is the program a session runs in. Claude Code always
comes with the project; Codex, Gemini CLI, Antigravity and OpenCode come only where the
`AGENT_CLIENTS` answer named them when the project was made. Every client reads the same rules,
skills and memory in `.claude/`: the others through an entrypoint (`AGENTS.md` or `GEMINI.md`),
the bridge `.claude/syntek-author-agents.md` and a settings file of their own. Enabling a client
later means recording it in the answers, then copying its files in by hand from a fresh render
of the template.

## Why an update never adds them

The entrypoints, `.agents` and the clients' settings files are copy-only: Copier writes them
when the project is made and never again, so a file the author has edited, deleted or combined
with their own stays as it is. An update changes one only by adding the two MCP servers, once,
to a file that lacks them. So recording a new client in `AGENT_CLIENTS` changes the model table
in `.claude/rules/syntek-author/05-model-allocation.md`, and nothing else: the client's own
files still have to be brought in.

## The fresh-render route

The files come from a fresh project, made into a temporary folder from the same template source
and version that `.copier-answers.syntek-author.yml` records, with the same answers, the new
client included. Comparing the two shows which client files the project lacks, and only those
are copied in. Where a file already exists, such as an `AGENTS.md` written for another tool, the
two are combined by hand with the author, never overwritten. A copy is never run over the real
project: it would treat the project's files as the template's. Where `.agents` is not a plain
folder (a link to `.claude`, a link outside the project, or a `skills` folder of the author's
own), it is settled by hand, as `how-to/src/TEMPLATE-GUIDE/agent-clients-and-mcp.md` explains.
Last, the permissions script carries the deny and ask rules of `.claude/settings.json` into the
files the new client reads, and the client is restarted.

## How we apply it here

- The bridge's list in 'Enabling a client in an existing project' is the one list of client
  files: the procedure copies what it names, and nothing else.
- An existing `AGENTS.md` or `GEMINI.md` is never replaced; it gains one agreed line sending
  its client to every `.claude/syntek-*-agents.md`.
- The permissions script runs with `--check` first, and `--write` on the author's word.
- Recording the client is an update: the update command carries the five `GIT_CONFIG_*`
  variables, and its report is read like any other.
- The temporary folder is deleted once the files are in, and the added client is recorded in
  `.claude/MEMORY.md`.

## Who implements it

- `how-to/workflows/syntek-author/03-enable-an-agent-client/`: every step, with its commands.
- No skill runs it; follow it by hand, or through `run-workflow`.

## Governing standard

`.claude/rules/syntek-author/05-model-allocation.md` Section 4 owns which model each client
runs; `.claude/syntek-author-agents.md`, 'Enabling a client in an existing project', owns the
client files and the hand steps. The rules own the requirement; this guide owns why the route
runs through a fresh render.
