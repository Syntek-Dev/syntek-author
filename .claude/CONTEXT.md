# CONTEXT.md — .claude/

The Claude Code configuration for **developing** the template — not the configuration a generated project receives, which lives in `template/.claude/`.
Its job is the opposite of the product's: where `template/.claude/` loads skills and rules into an author's session, this folder keeps them out of the maintainer's.
Nothing here ships (`_subdirectory: template`).

## Directory Tree

```text
.claude/
├── CONTEXT.md        ← this file
├── CLAUDE.md         ← the development manual: contract, dev isolation, token discipline, recipes
└── settings.json     ← dev isolation (Skill denies, claudeMdExcludes) plus the house development settings shared with syntek-base
```

## What's here

- `CLAUDE.md` — how to work on the template. It imports the root `CONTEXT.md` and this file, and routes every design question to `DESIGN.md`.
- `settings.json` — **two layers of isolation, both required** (DESIGN.md Section 7). `permissions.deny` lists `Skill(<name>)` for every skill under `template/.claude/skills/`, because Claude Code loads a nested skills folder as soon as a session reads a file beneath it; `claudeMdExcludes` keeps `template/**/CLAUDE.md` and `template/.claude/**` out of development sessions. Every new template skill needs its deny line here, added or approved by the maintainer.
- `settings.json` also carries the house development settings, matched to syntek-base's as syntek-media's are (maintainer's decision, 15/10/2026): its read-only `permissions.allow` list; its denies on `.env` files and on tools this house does not use here (`AskUserQuestion` among them, so questions are asked in plain text), except `SendMessage`, which the template sessions use to message each other; the code-review-graph deny (`embed_graph_tool`) and asks (`apply_refactor_tool`, `generate_wiki_tool`) for the root `.mcp.json`, which runs that server for this repository only (development; `CLAUDE.md` Section 3); and its top-level keys (model, output style, effort, workflows, disabled bundled skills, connectors and plugins, `autoCompactEnabled: false`). syntek-base's hooks are not taken: their scripts do not exist here. None of it ships.
- Codex, Gemini CLI, Antigravity and OpenCode reach this folder through root `AGENTS.md` and `GEMINI.md`. The root has no `.agents`, so a session started at the root finds no skill at all; their isolation is starting every session there (`CLAUDE.md` Section 3). Root `.codex/config.toml` is the user-config snippet that disables the product's skills in Codex, not a guard (D47).
- There is no `MEMORY.md`, no hook and no skills folder: the template's own decisions live in `DESIGN.md` and `CHANGELOG.md`, where a reviewer can see them.

## Cross-references

- `template/.claude/` — the product's configuration, which this folder isolates.
- `.github/scripts/dev-isolation.sh` — proves every template skill is denied here and that `claudeMdExcludes` is present.
- `DESIGN.md` Section 7 — the dev-isolation decision; D4 and D17 — how the product's own `.claude/` is owned.
