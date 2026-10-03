# CONTEXT.md — .claude/

Claude Code's configuration for <%PROJECT_NAME%>: the project manual, the template's rules, the
project memory, the settings, the hooks and the skills. Nothing here is the work itself; it is how
the work is done. Some of it belongs to the project and some to the template, and the tree marks
which is which.

## Directory Tree

```text
.claude/
├── CLAUDE.md               ← the project brief and where the rules live (read first; yours)
├── CONTEXT.md              ← this file (yours)
├── MEMORY.md               ← project memory: facts, decisions, feedback, status (read second; yours)
├── settings.json           ← model, permissions, the PreCompact hook (yours)
├── settings.local.json     ← your machine-only overrides, if any (git-ignored; never committed)
├── hooks/                  ← pre-compact-handoff.sh (template-owned) and its pair (yours)
├── rules/                  ← rules loaded at launch, one folder per template (no pair here)
│   └── syntek-author/      ← the template's rules, loaded at launch (template-owned; never edit)
│       ├── 01-layout-and-routing.md
│       ├── 02-skills.md
│       ├── 03-authorship.md
│       ├── 04-build-pipeline.md
│       ├── 05-model-allocation.md
│       ├── 06-global-rules.md
│       ├── 07-session-boundaries.md
│       └── 08-naming-and-memory.md
└── skills/                 ← one folder per skill (template-owned) and the folder's pair (yours)
```

## What's here

- `CLAUDE.md` — the operating manual for this project: Section 1 is the project brief from the
  Copier answers, Section 3 holds the project's own rules. **It wins over the template's rules
  where the two conflict.**
- `rules/syntek-author/` — the template's rules. Claude Code loads every Markdown file under
  `rules/` at launch with the same weight as `CLAUDE.md`, which is why this folder holds no
  `CONTEXT.md` or `CLAUDE.md` of its own. Another template applied to this project would add its
  own folder beside it.
- `MEMORY.md` — the durable memory every session reads second. It splits into `memory/<topic>.md`
  files once it passes 300 lines.
- `settings.json` — `"model": "opus"`, `"autoCompactEnabled": false`, the `PreCompact` hook, and a
  short allow and deny list. It is committed and shared; personal overrides belong in
  `settings.local.json`.
- `hooks/` and `skills/` — see each folder's own `CONTEXT.md`.

## Cross-references

- `.claude/rules/syntek-author/01-layout-and-routing.md` — the layers, the folder pair and who owns
  which files.
- `.claude/rules/syntek-author/02-skills.md` — the skill roster.
- `.claude/hooks/CONTEXT.md` — the hook registry.
- `.claude/skills/CONTEXT.md` — how skills are laid out.
- `../CONTEXT.md` — the repository overview, imported by `CLAUDE.md`.
