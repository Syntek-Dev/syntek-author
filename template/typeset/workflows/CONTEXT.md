# CONTEXT.md — typeset/workflows/

The typesetting layer's ordered procedures: the recipes every printing task starts from. Where
`typeset/docs/` explains how the printed book is made and `typeset/src/` holds it, this folder
holds the steps, in order, each naming its skill, its guide and any `make` command, with a
model-tagged checklist to tick. The numbered procedures are template-owned and updated by
`copier update`; the author's own procedures live in `typeset/workflows/local/`. **Never style a
chapter without starting here.**

## Directory Tree

```text
typeset/workflows/
├── CONTEXT.md                     ← this file
├── CLAUDE.md                      ← operating rules; running and changing a procedure
├── 01-design-the-page/            ← the author's page-design choices, recorded and proofed
├── 02-typeset-a-chapter/          ← Pandoc base, house styling, the check, the print
├── 03-retypeset-after-edits/      ← carry the styling onto a chapter's new words
├── 04-typeset-the-book/           ← every chapter, front and back matter, one print-ready PDF
└── local/                         ← the author's own procedures; a same-named one wins
```

Each procedure folder holds four files: `CONTEXT.md` (when to reach for it), `CLAUDE.md` (how to
run it), `STEPS.md` (the ordered steps) and `CHECKLIST.md` (pre-conditions, execution and done-when,
each item tagged with its model tier).

## What's here

| You want to… | Procedure | Skill(s) |
|---|---|---|
| Choose the trim, typefaces and ornaments of the printed book | `typeset/workflows/01-design-the-page/` | `typeset` |
| Typeset a chapter for print for the first time | `typeset/workflows/02-typeset-a-chapter/` | `typeset` → `make tex-check` → `make print` |
| Bring a typeset chapter up to date after its Markdown changed | `typeset/workflows/03-retypeset-after-edits/` | `typeset` → `make tex-check` |
| Make the whole book ready for the printer | `typeset/workflows/04-typeset-the-book/` | `typeset`, `build` |

**Numbering is frozen and append-only.** A number, once used, keeps its meaning; gaps are normal.
The author's procedures are numbered separately in `typeset/workflows/local/`.

## Cross-references

- `typeset/workflows/local/` — the author's procedures, and same-named overrides of these.
- `typeset/docs/reference/the-typesetting-pipeline.md` — how `02-typeset-a-chapter`,
  `03-retypeset-after-edits` and `04-typeset-the-book` fit together.
- `.claude/rules/syntek-author/05-model-allocation.md` — what the checklist model tags mean.
- `manuscript/workflows/` — the procedures that write and promote the words printed here.
