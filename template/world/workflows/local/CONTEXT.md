# CONTEXT.md — world/workflows/local/

The author's own world-layer procedures: jobs this book repeats that the template's procedures
do not cover (drawing a map, building a calendar, naming a royal line), or a template procedure
changed to suit this book. The template ships only this pair; everything else here is yours,
and `copier update` never touches it.

## Directory Tree

```text
world/workflows/local/
├── CONTEXT.md              ← this file: your index of local procedures
├── CLAUDE.md               ← operating rules
└── NN-verb-first-name/     ← one procedure: CONTEXT · CLAUDE · STEPS · CHECKLIST
```

## What's here

No local procedures yet. **A folder here with the same slug as a template procedure (for
example 03-name-something) replaces that procedure for this project**; `run-workflow` checks
this folder first. A folder with a new slug adds a procedure.

| Procedure | What it does | Overrides |
|---|---|---|

## Cross-references

- `world/workflows/` — the template's procedures, and the shape to copy.
- `.claude/rules/syntek-author/01-layout-and-routing.md` — the local numbering and override
  rule for every layer.
