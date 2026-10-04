# CONTEXT.md — typeset/workflows/local/

The author's own procedures for the typesetting layer: work that recurs in this book and no
template procedure covers (a printer's own preflight, a special edition), and overrides of
template procedures. The template ships only this pair; everything else here is the author's, and
`copier update` never touches it. Local procedures have their own numbering. A local folder with
**the same slug** as a template folder, whatever its number (for example a local
02-typeset-a-chapter or 09-typeset-a-chapter), overrides it, and `run-workflow` always looks here first.

## Directory Tree

```text
typeset/workflows/local/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules; how to add or override a procedure
└── NN-verb-first-name/   ← one folder per procedure (none yet)
    ├── CHECKLIST.md      ← verification checklist before marking complete
    ├── CLAUDE.md         ← operating rules for this workflow
    ├── CONTEXT.md        ← when to use it, what it produces, the one thing that matters
    └── STEPS.md          ← ordered steps to execute
```

## What's here

| You want to… | Procedure | Overrides |
|---|---|---|
| — | — | — |

Nothing yet. Add a row for every procedure placed here. For an override, name the template
procedure it replaces, and record the date and reason in `.claude/MEMORY.md` Decisions (mapped
in `00-project.md` `## Memory headings`).

## Cross-references

- `typeset/workflows/` — the template's procedures; read the nearest one before writing a new one.
- `typeset/workflows/CLAUDE.md` — running and changing procedures.
- `.claude/rules/syntek-author/01-layout-and-routing.md` — the local-first rule, stated for every
  layer.
