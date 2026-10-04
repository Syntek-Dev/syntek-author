# CONTEXT.md — manuscript/workflows/local/

The author's own procedures for the manuscript layer: work that recurs in this book and no
template procedure covers, and overrides of template procedures. The template ships only this pair;
everything else here is the author's, and `copier update` never touches it. Local procedures have
their own numbering. A local folder with **the same name** as a numbered template folder (for
example a local 03-improve-your-draft) overrides it, and `run-workflow` always looks here first.

## Directory Tree

```text
manuscript/workflows/local/
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

- `manuscript/workflows/` — the template's procedures; read the nearest one before writing a new one.
- `manuscript/workflows/CLAUDE.md` — running and changing procedures.
- `.claude/rules/syntek-author/01-layout-and-routing.md` — the local-first rule, stated for every
  layer.
