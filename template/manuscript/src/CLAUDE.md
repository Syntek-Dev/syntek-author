@./CONTEXT.md

# CLAUDE.md — manuscript/src/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `manuscript/CONTEXT.md` →
`manuscript/CLAUDE.md` → this folder's `CONTEXT.md` (the chapter layout, imported above) → this
file → the target chapter's `CONTEXT.md` and `CLAUDE.md`.

## Purpose (one line)

Hold the book's prose, chapter by chapter, so that only what the author has approved is ever in a
chapter file and everything else stays in drafts.

## How to work here

- **Routing:** never start work here. Start from the matching procedure in `manuscript/workflows/`
  (the `run-workflow` skill checks `manuscript/workflows/local/` first), then work inside the
  target chapter's own pair.
- **Model:** **Opus** for every word of prose and every judgement; the mechanical tier for creating
  folders and files and for running the build (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps for a new chapter folder** (normally done by `draft-section` on the chapter's
  first section):
  1. Confirm the brief exists at `planning/src/units/NN-kebab-title.md`; the folder takes the same
     name.
  2. Create `NN-kebab-title/` with its `CONTEXT.md` and `CLAUDE.md`. The `CONTEXT.md` says what the
     chapter is for and its job in the book; the `CLAUDE.md` names its particular traps and a
     definition of done phrased as what the reader can do or feel at the end. Both route to the
     brief instead of restating it.
  3. Create `drafts/README.md` from the four-line pattern every chapter uses.
  4. Leave the chapter file to `promote-section`, which creates it from the brief's `sections:`
     list the first time a section is promoted.
- **Definition of done:** every chapter folder has its pair, its `drafts/README.md` and, once
  anything is promoted, a chapter file whose markers match its brief in order and in name.

## Guardrails

- **Nothing enters a chapter file except by promotion.** No drafting in place, no 'quick fix'
  that bypasses the ledger. An agreed correction found in review is recorded in the section's
  ledger entry (see `manuscript/workflows/05-review-a-chapter/`).
- **Markers are structure, not decoration.** Never delete, rename or reorder a
  `<!-- section: <slug> -->` marker without changing the brief to match, with the author's
  agreement. When the brief and the markers disagree, report it; do not guess.
- **Never defeat the drafts exclusion.** A section missing from a proof is still in drafts, which
  means it is not promoted, which means it should not be in the build.
- **Never fabricate** a quotation, citation, reference, figure or date. Unchecked claims carry
  `<!-- VERIFY: … -->`; decisions for the author carry `<!-- AUTHOR TO CONFIRM: … -->`.
- **One sentence per line**, applied when a paragraph is edited; never mass-reflow a chapter.
- **Never overwrite an existing draft or promoted text** without confirming with the author.

## Output & naming

- **Chapters:** `NN-kebab-title/NN-kebab-title.md`, the filename matching the folder; `NN` is two
  digits and is the running order.
- **Drafts:** `NN-kebab-title/drafts/<NN>-<section-slug>.md`, the number being the section's order
  in the brief.
- **Hand-written:** all chapter prose and inline citations, through the procedures.
- **Generated (never hand-edit):** everything under `build/`, rebuilt from this folder by `make`.
