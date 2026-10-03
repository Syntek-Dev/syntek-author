@./CONTEXT.md

# CLAUDE.md — library/workflows/04-promote-a-section/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/workflows/CONTEXT.md` → `library/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

On the author's word, move one approved section into its document between its markers, and record
exactly what was approved.

## How to work here

- **Routing:** the `promote-section` skill (with its `BUSINESS.md` mode file) is this procedure in
  skill form; `build` renders the working proof. Guides: `latex-deliverables.md`,
  `the-status-ladders.md` and `versioning-and-the-register.md` in `library/docs/reference/`.
- **Model:** follow the checklist tags: **Opus** for hearing the word, converting the text and
  reading the proof; the mechanical tier for the gate checks, insertion, records and the build.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.
- **Definition of done:** the approved text sits between the section's markers, converted without
  loss or addition, and `make section-check` proves it; the document still renders; the ledger,
  provenance table, brief and memory all record the promotion; the document's status has not
  moved.

## Guardrails

- **The author's word, in words, naming the section.** Approval of something else, or silence,
  is not promotion.
- **Zero flags in the section.** An `AUTHOR TO CONFIRM`, a `VERIFY` or an `[AWAITING USER INPUT]`
  left in a draft blocks its promotion until the author resolves it. A gap never travels into the
  document hidden in a promoted section.
- **Every approved word arrives; nothing is added.** Conversion to LaTeX is not an edit, and
  `make section-check` proves the words match before the ledger is written.
- **No citation key goes into a `.tex`.** A key (`[@`) resolves only in a Markdown document; the
  author writes the reference in full before the section is promoted into a LaTeX deliverable.
- **Only between the markers.** Never touch text outside the section's own `% section:` pair, and
  never delete, rename or reorder a marker.
- **Never promote into a circulated document.** Open a new version first.
- **Never overwrite promoted text** (a re-promotion) without showing the author what will be
  replaced and getting their confirmation.
- **Promotion never sets `final`.**

## Output & naming

- **Produces:** the section in the document's `.tex` (or `.md`), and the `.tex` itself on first
  promotion, named per `library/docs/reference/versioning-and-the-register.md`.
- **Also writes:** the ledger entry, `standards/style/ledger/provenance.md`, the draft's status,
  the unit brief, `.claude/MEMORY.md` `## Status`.
- **Generated (never hand-edit):** the working proof in `build/`.
- **Does not touch:** any other section, the document's status, or the register.
