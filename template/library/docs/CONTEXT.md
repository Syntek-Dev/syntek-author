# CONTEXT.md — library/docs/

The guidance sublayer of `library/`: short guides Claude reads before producing or changing a
document in `library/src/`. Nothing here is human-facing and nothing here is a document. Guides
explain how a rule is applied day to day; the rules themselves live in `standards/`, and a guide
never outranks a standard.

## Directory Tree

```text
library/docs/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules
├── reference/              ← template-owned guides, updated by copier update
└── project/                ← your own guides; a same-named file here overrides reference/
```

## What's here

- `reference/` — six guides that ship with the template (what a section is, how the loop with the
  AI runs, the status ladders, the anatomy of a business document, the house LaTeX deliverable,
  and versioning with the register), and the standard of each document family this project uses,
  `<family>-standards.md`. **Template-owned:** an edit here is overwritten or conflicts on the
  next `copier update`.
- `project/` — **author-owned.** Guides specific to this business: house positions, recurring
  document types, lessons that outgrew a single document. A file here with the same name as one
  in `reference/` replaces it for this project; its `## How we apply it here` section is where a
  project guide extends a reference guide instead of replacing it.

## Cross-references

- `library/docs/reference/` — start with `drafting-with-ai.md`, `section-anatomy.md` and
  `business-standards.md`.
- `standards/` — the rules these guides serve.
- `library/workflows/` — the procedures that cite these guides step by step.
