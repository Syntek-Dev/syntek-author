# CONTEXT.md — typeset/docs/

The typesetting layer's guides: short, practical notes on how the printed book is made, read when
a question comes up mid-task. They sit between `standards/` and the rules files (what must hold)
and `typeset/workflows/` (the ordered procedures), and each defers to the rule that governs it;
where a guide and a rule disagree, the rule is right. Guides have two owners: the template owns
`typeset/docs/reference/`, the author owns `typeset/docs/project/`. No page-design choice lives
here: those are the author's, in `typeset/src/page-design.md`.

## Directory Tree

```text
typeset/docs/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules
├── project/              ← the author's own guides; a same-named one overrides reference/
└── reference/            ← template-owned guides, updated by `copier update`
```

## What's here

- `typeset/docs/reference/` — the template's guides: the pipeline, the house class, the fidelity
  check and the semantic Markdown an author may use. The list, with what each answers, is in that
  folder's `CONTEXT.md`. **Never edit these in place:** `copier update` owns them.
- `typeset/docs/project/` — guides for this book alone, and overrides. **A guide there with the
  same filename as a reference guide overrides it.** An override stops receiving template
  updates, so write one only when this book genuinely diverges.

## Cross-references

- `typeset/workflows/` — the procedures that cite these guides step by step.
- `.claude/rules/syntek-author/03-authorship.md` — the authorship rules the fidelity check serves.
- `.claude/rules/syntek-author/01-layout-and-routing.md` — the reference and project ownership
  split, stated once for every layer.
