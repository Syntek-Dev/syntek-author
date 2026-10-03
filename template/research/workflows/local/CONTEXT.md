# CONTEXT.md — research/workflows/local/

The author's own research procedures, empty at generation. A procedure here either covers a task
the template has no procedure for, or replaces a template procedure by sharing its slug. The
template seeds only this pair, once, and never writes here again: the pair is yours to edit, and
`copier update` never touches anything in this folder.

## Directory Tree

```text
research/workflows/local/
├── CONTEXT.md            ← this file: the index of local procedures
├── CLAUDE.md             ← operating rules
└── NN-verb-first-name/   ← one folder per procedure: CONTEXT.md · CLAUDE.md · STEPS.md · CHECKLIST.md
```

## What's here

- **Local procedures** use their own numbering, starting at `01`, independent of the template's.
- **Overrides** share the template procedure's slug exactly (for example `02-verify-a-claim/`);
  `run-workflow` resolves `local/` first, so the local version wins.
- When you add one, add a row to this table:

| Procedure | What it is for | Overrides |
|---|---|---|

## Cross-references

- `research/workflows/CONTEXT.md` — the template's procedures, which these extend or replace.
- `.claude/skills/run-workflow/SKILL.md` — the router that looks here first.
- `.claude/rules/syntek-author/01-layout-and-routing.md` — workflow numbering and ownership.
