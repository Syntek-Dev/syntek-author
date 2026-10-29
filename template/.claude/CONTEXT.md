# CONTEXT.md — .claude/

Claude Code's configuration for <%PROJECT_NAME%>: the project manual, the template's rules, the
project memory, the settings, the hooks and the skills. Nothing here is the work itself; it is how
the work is done. Some of it belongs to the project and some to the template, and the tree marks
which is which.

## Directory Tree

```text
.claude/
├── CLAUDE.md               ← the project brief, where the rules live, project rules (read first; yours)
├── CONTEXT.md              ← this file (yours)
├── MEMORY.md               ← project memory: facts, decisions, feedback, status (read second; yours)
├── settings.json           ← model, permissions, the session hooks (yours)
├── settings.local.json     ← your machine-only overrides, if any (git-ignored; never committed)
├── syntek-author-agents.md       ← the bridge for Codex, Gemini CLI, Antigravity and OpenCode (template-owned)
├── syntek-author-permissions.py  ← passes settings.json's denies and asks to the other clients' files (template-owned)
├── syntek-author-dataroot.py     ← the data-root resolver and guard: make root and make files-* (template-owned)
├── syntek-author-dataroot.json   ← this template's filing folders and the kind each fixes (template-owned)
├── hooks/                  ← context-threshold-handoff.sh, pre-compact-handoff.sh, how-to-read-only.sh and the pair (all shared)
├── rules/                  ← the rules, one folder per template (no pair here)
│   └── syntek-author/      ← the template's rules: at launch, but 04 and 09 with the files they cover
│       ├── 00-project.md   ← this project's settings: brief, paths, memory headings, aliases, overrides (yours)
│       ├── 01-layout-and-routing.md   ← 01 to 09: template-owned; never edit
│       ├── 02-skills.md
│       ├── 03-authorship.md
│       ├── 04-build-pipeline.md
│       ├── 05-model-allocation.md
│       ├── 06-global-rules.md
│       ├── 07-session-boundaries.md
│       ├── 08-naming-and-memory.md
│       └── 09-data-root.md
└── skills/                 ← one folder per skill (template-owned) and the folder's pair (yours)
```

## What's here

- `CLAUDE.md` — the operating manual for this project: the project brief, a map of the rules,
  and the project's own rules under 'Project-specific rules'. **Those rules win over the
  template's rules files where the two conflict.**
- `rules/syntek-author/00-project.md` — **this project's settings**, read by every template rule
  and skill: the audience and reader test, where the project keeps each thing, its `MEMORY.md`
  headings, workflow aliases and overrides of template rules. Written once from the Copier
  answers and never overwritten; it outranks everything else in the rules folder and
  `CLAUDE.md`'s project rules.
- `rules/syntek-author/` — the template's rules, `01-…` to `09-…`. Claude Code loads every
  Markdown file under `rules/` as a rule with the same weight as `CLAUDE.md`: at launch, or,
  where its frontmatter lists `paths` (`04-…` and `09-…`), once a session reads a file that
  matches. That is why this folder holds no `CONTEXT.md` or `CLAUDE.md` of its own. Another
  template applied to this project would add its own folder beside it.
- `MEMORY.md` — the durable memory every session reads second. Template files name its headings;
  `00-project.md` maps each to the heading this project uses. It splits into `memory/<topic>.md`
  files once it passes 300 lines, unless an override keeps it whole.
- `settings.json` — `"model": "opus"`, `"autoCompactEnabled": false` and `"idleCompaction": false`
  (no compaction on its own, as the window fills or while a session sits idle),
  `"outputStyle": "Concise"` (Claude Code's built-in Concise style; a release older than 2.1.237
  uses Default), the
  `UserPromptSubmit` window hook, the `PreCompact` hook and its `SessionStart` note after a
  `/compact`, the `PreToolUse` data-root guard and guide guard, a short allow and deny list
  (`how-to/` among it), and the asks before the shipped MCP servers' browser and writing tools.
  It is committed and shared; personal overrides (such as `CLAUDE_CONTEXT_WINDOW` under `"env"`,
  for a larger window, or another output style, which `/output-style` and `/config` write there)
  belong in `settings.local.json`, which wins. A copy over an existing file, and every update, may
  add a hook entry, a deny or ask rule, or one of those three settings where the file has no such
  key, that the template lists and has not offered before, into the file's own text, and never
  removes or changes one.
- `hooks/` and `skills/` — see each folder's own `CONTEXT.md`.
- `syntek-author-agents.md` — how the other coding agents reach this folder: the read order
  they must follow by hand, the `skills` link in `.agents`, the model tiers, each client's
  setup and how to add a client later. Template-owned and updated; Claude Code never needs it.
- `syntek-author-permissions.py` — run with `python3` (3.14 or later): `--check` reports which
  of `settings.json`'s denies and asks each other client's file carries, and `--write` adds the
  missing ones to client files that already exist. Template-owned; it never creates a file.
- `syntek-author-dataroot.py` and its map `syntek-author-dataroot.json` — the data-root
  resolver, run as `make root` and `make files-*` (Python 3.14 or later), and the guard the
  `PreToolUse` hook calls. Template-owned. On an older Python each command stops and says why,
  and the guard lets the action through with a warning that it checked nothing.

## Cross-references

- `.claude/rules/syntek-author/00-project.md` — this project's settings.
- `.claude/rules/syntek-author/01-layout-and-routing.md` — the layers, the folder pair, who owns
  which files, and which rule wins (Section 9).
- `.claude/rules/syntek-author/02-skills.md` — the skill roster.
- `.claude/hooks/CONTEXT.md` — the hook registry and the window threshold.
- `.claude/skills/CONTEXT.md` — how skills are laid out.
- `../CONTEXT.md` — the repository overview, imported by `CLAUDE.md`.
