# CONTEXT.md — typeset/workflows/03-retypeset-after-edits/

The procedure for bringing a typeset chapter up to date after its Markdown has changed, without
losing the styling already done. `make tex` writes a new base and keeps the old one;
`git merge-file` applies the change between the two bases to the styled chapter; any clash is
resolved by taking the new words and putting the styling back on them; and `make tex-check`
proves the result carries exactly the new Markdown's words.

## Directory Tree

```text
typeset/workflows/03-retypeset-after-edits/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, what it produces, the one thing that matters)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

- A promoted section of an already typeset chapter has been revised and promoted again.
- `make tex` reports `updated` for a chapter that has a styled file.
- `make tex-check` fails on a chapter whose Markdown changed after it was styled.

Reach for a **different** procedure when: the chapter has never been typeset
(`typeset/workflows/02-typeset-a-chapter/`); or only the styling needs changing and the words have
not moved (style in place, then `make tex-check`, as in procedure 02 from step 4).

## What it produces, and where

- **The new base** in `typeset/src/units/.base/NN-kebab-title.tex`.
- **The styled chapter** `typeset/src/units/NN-kebab-title.tex`, carrying the new words and the
  old styling, checked.
- **A proof** of the changed pages in `build/typeset/book.pdf`.
- The previous base, `build/typeset/NN-kebab-title.old-base.tex`, deleted once the merge is
  checked, so the next carry-forward starts from the right ancestor.

## The failure this procedure exists to prevent

**Losing the styling, or losing an edit.** Re-typesetting from a fresh base throws away every drop
capital and page-fitting decision; keeping the old styled file throws away the author's revision.
A three-way merge keeps both, and the check proves the words are the new ones.

## Cross-references

- `typeset/docs/reference/the-typesetting-pipeline.md` — 'After the Markdown changes'.
- `typeset/docs/reference/the-fidelity-check.md` — reading a failure after a merge.
- `typeset/workflows/02-typeset-a-chapter/` — the first typesetting this procedure continues.
