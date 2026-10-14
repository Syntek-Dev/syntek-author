# CONTEXT.md — .codex/

Codex settings for developing this Copier template. Nothing here ships (`_subdirectory:
template`); the product's own `.codex/` lives in `template/.codex/`.

## Directory Tree

```text
.codex/
├── CONTEXT.md    ← this map
├── CLAUDE.md     ← how to keep development isolation
└── config.toml   ← every product skill, disabled: the maintainer's user-config snippet
```

## What's here

- `config.toml` — one `[[skills.config]]` entry with `enabled = false` for every skill under
  `template/.claude/skills/`, naming its `SKILL.md` by a path relative to this folder. Codex
  reads that list only from your user config (`~/.codex/config.toml`), never from a project
  file, so this file is a snippet, not a guard: copy the entries there with absolute paths if
  you ever start Codex inside `template/`. The isolation that holds is starting every session at
  the repository root, which has no `.agents`, so Codex finds no product skill there. Nor is the
  parse failure of the unrendered `template/.codex/config.toml` a guard: it stops only a trusted
  checkout. It sets no
  `project_doc_fallback_filenames`: the product's `CLAUDE.md` manuals must stay source text,
  and root `AGENTS.md` gives the development read order instead. No model, trust level,
  permission bypass or MCP credential belongs here.

## Cross-references

- `AGENTS.md` — Codex's development entrypoint.
- `.claude/CLAUDE.md` Section 3 — dev isolation in every client.
- `.github/scripts/dev-isolation.sh` — checks the snippet lists every product skill, and that the
  root has no `.agents` and documents the start-at-the-root rule; DESIGN.md D47 and Section 7.
