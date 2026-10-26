# CONTEXT.md — how-to/workflows/syntek-author/03-enable-an-agent-client/

The procedure for adding a coding agent (Codex, Gemini CLI, Antigravity or OpenCode) to a
project that has none of its files. It records the client in the answers through an update,
renders a fresh project into a temporary folder from the same source, version and answers,
copies in only the client files the project lacks, settles `.agents` by hand, sends any existing
entrypoint to every bridge, carries the permission rules to the client, and restarts it.

## Directory Tree

```text
how-to/workflows/syntek-author/03-enable-an-agent-client/
├── CONTEXT.md          ← this file (when to use, what it produces)
├── CLAUDE.md           ← operating rules for this procedure
├── STEPS.md            ← ordered steps to execute, with every command
└── CHECKLIST.md        ← verification checklist before marking complete
```

## When to use this

- The author wants to use a coding agent the project was not made with.
- A client's files were deleted, and the author wants them back.
- The project was made before the template asked which clients to use, and the author now uses
  one.

Reach for a **different** procedure when: the client is already recorded and its files exist,
and only its rules are out of date (step 7 of `01-update-the-template/`, the permissions
script); or the client belongs to a companion template's set-up, which its own procedure
covers.

## What it produces, and where

- The client recorded in `AGENT_CLIENTS` in `.copier-answers.syntek-author.yml`, and its row in
  the model table of `.claude/rules/syntek-author/05-model-allocation.md`.
- The client's entrypoint and settings file copied in where the project lacked them, and
  `.agents` as a real folder with its `skills` link, where the client needs it.
- The deny and ask rules of `.claude/settings.json` carried into the client's file, on the
  author's word.
- A line in `.claude/MEMORY.md` recording the client, committed.

## The failure this procedure exists to prevent

A client added by guesswork. A client file copied from memory or another project names the wrong
model, misses the MCP servers or the permission rules; an existing `AGENTS.md` overwritten loses
the author's own instructions; a copy run over the real project treats every file in it as the
template's. A client that never reaches the bridge works without the project's rules at all.

## Cross-references

- `how-to/docs/syntek-author/enabling-an-agent-client.md`: why the route runs through a fresh
  render.
- `.claude/syntek-author-agents.md`: 'Enabling a client in an existing project', the one list of
  client files, and the client set-up.
- `how-to/src/TEMPLATE-GUIDE/agent-clients-and-mcp.md`: each client's files, every `.agents`
  case and the permissions script.
- `how-to/workflows/syntek-author/01-update-the-template/`: the update step 1 runs.
