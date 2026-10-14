# CONTEXT.md — .codex/

Codex's project settings for <%PROJECT_NAME%>. Written once when the project was generated
and the author's from then on: `copier update` never changes, adds or recreates anything here.
The rules, skills and memory Codex follows live in `.claude/`, which every client shares.

## Directory Tree

```text
.codex/
├── CONTEXT.md     ← this file (yours)
├── CLAUDE.md      ← how to change these settings (yours)
└── config.toml    ← the CLAUDE.md fallback, the model if one was chosen, local MCP servers (yours)
```

## What's here

- `config.toml` — `project_doc_fallback_filenames = ['CLAUDE.md']`, so a Codex session started
  inside a folder reads its `CLAUDE.md` and its parents' where there is no `AGENTS.md`, and `model` when one was chosen at generation.
  Codex loads it only after you trust the project. It sets no trust level, permission bypass
  or credential, and it cannot choose a model provider: Codex allows that only in your
  user-level settings, which is where a local model for Codex belongs.
- MCP servers for Codex go here as `[mcp_servers.<name>]` tables, in Codex's TOML format.
  Authenticate them locally; never commit a key.

## Cross-references

- `.claude/syntek-author-agents.md` — the read order and setup every client shares.
- `.claude/rules/syntek-author/05-model-allocation.md` — the tiers, and the model each client uses.
- `AGENTS.md` — Codex's entrypoint at the project root.
