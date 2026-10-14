# CONTEXT.md — .codex/

Codex's project settings. Written once when the project was generated and the author's from
then on: `copier update` never changes, adds or recreates anything here. The rules, skills and
memory Codex follows live in `.claude/`, which every client shares.

## Directory Tree

```text
.codex/
├── CONTEXT.md     ← this file (yours)
├── CLAUDE.md      ← how to change these settings (yours)
└── config.toml    ← the CLAUDE.md fallback, the model if one was chosen, local MCP servers (yours)
```

## What's here

- `config.toml` — `project_doc_fallback_filenames = ['CLAUDE.md']`, so a Codex session started
  inside a folder reads its `CLAUDE.md` and its parents' where there is no `AGENTS.md`, and
  `model` when one was chosen at generation. Codex loads it only after you trust the project.
  It sets no trust level, permission bypass or credential. Codex ignores a model provider set in
  a project file (with a warning): a local model for Codex belongs in your user-level settings.
- MCP servers for Codex go here as `[mcp_servers.<name>]` tables, in Codex's TOML format.
  Authenticate them locally; never commit a key. A tool the project's `.claude/settings.json`
  asks before using can be set to prompt here (`[mcp_servers.<name>.tools.<tool>]`), by hand or
  with `--write` from any `.claude/syntek-*-permissions.py` (they are the same script).

## Cross-references

- Every `.claude/syntek-*-agents.md` — the read order and setup every client shares, and the
  model each client uses.
- `AGENTS.md` — Codex's entrypoint at the project root.
