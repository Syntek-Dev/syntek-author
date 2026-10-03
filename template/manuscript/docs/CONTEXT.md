# CONTEXT.md — manuscript/docs/

The manuscript layer's writing guides: short, practical notes on how the work is done here, read
mid-draft when a question comes up. They sit between `standards/` (the rules) and
`manuscript/workflows/` (the ordered procedures), and each one defers to the standard that governs
it; where a guide and a standard disagree, the standard is right. Guides have two owners: the
template owns `manuscript/docs/reference/`, the author owns `manuscript/docs/project/`. No prose
for the book lives here, and no rule that is not already in a standard or a rules file.

## Directory Tree

```text
manuscript/docs/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules
├── project/              ← the author's own guides; a same-named one overrides reference/
└── reference/            ← template-owned guides, updated by `copier update`
```

## What's here

- `manuscript/docs/reference/` — the template's guides: the anatomy of a section, drafting with
  AI, the two status ladders, and one guide for this project's kind of book. The list, with what
  each answers, is in that folder's `CONTEXT.md`. **Never edit these in place:** `copier update`
  owns them and will merge over local changes.
- `manuscript/docs/project/` — guides written for this book alone, and overrides. **A guide in
  the project folder with the same filename as one in the reference folder overrides it.** An
  override stops receiving template updates, so write one only when the project genuinely
  diverges; to record how this book applies a reference guide without replacing it, write a
  differently named project guide and cite the reference one.

## Cross-references

- `manuscript/workflows/` — the procedures that cite these guides step by step.
- `standards/` — the rules every guide serves; `standards/style/` and `standards/method/` most of
  all.
- `.claude/rules/syntek-author/03-authorship.md` — the authoring rules the shared guides explain.
- `.claude/rules/syntek-author/01-layout-and-routing.md` — the reference and project ownership
  split, stated once for every layer.
