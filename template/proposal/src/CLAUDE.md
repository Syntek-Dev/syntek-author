@./CONTEXT.md

# CLAUDE.md — proposal/src/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `proposal/CONTEXT.md` →
`proposal/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file → the target part's
`CONTEXT.md` and `CLAUDE.md`, where it is a folder.

## Purpose (one line)

Hold the package a reader receives, the tracker of every approach, and the index of sample units.

## How to work here

- **Routing:** start from the matching procedure in `proposal/workflows/`.
<: if DOC_TYPE == 'theology' :>  - `book-proposal/` → `01-assemble-the-proposal`, guide `book-proposal-anatomy.md`, skill `build`.
  - `endorsements/` → `02-approach-a-reader` (skill `approach-a-reader`), then
    `03-update-the-tracker`.
<: endif :><: if DOC_TYPE == 'fiction' :>  - `query-letter.md`, `synopsis-short.md`, `synopsis-long.md`, `comp-titles.md` →
    `01-assemble-the-proposal`, guide `query-package-anatomy.md`, skill `build`.
  - `submissions/` → `02-approach-a-reader` (skill `approach-a-reader`), then
    `03-update-the-tracker`.
<: endif :>  - `sample/` → `01-assemble-the-proposal`; the selection is the author's.
- **Model:** **Opus** for all pitch writing and judgement; the mechanical tier for exports, tracker
  dates and ticks (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** read the anatomy guide → check `manuscript/src/` for what exists → draft or
  revise the part with the author → source every claim → proofread → build and read the proof →
  hand back.
- **Definition of done:** each part does what the anatomy guide says it must; every claim resolves
  to a checked source; the sample points only at units whose sections are all promoted; the
  tracker matches reality; nothing was sent.

## Guardrails

- **Never invent** a comparable title, a figure, an endorsement, a reader's interest, an offer or a
  deadline.
- **Never offer what does not exist.** The sample can be decided before it can be sent.
- **Draft, never send.** Every email goes to the author, who sends it.
- **The tracker outranks everything else** on who was asked what. If another file disagrees with
  it, the other file is wrong.
- **Point, never copy.** No manuscript prose is duplicated here.
- **Confirm before overwriting** the author's pitch text, a drafted or sent email, a tracker row or
  anything received.

## Output & naming

- **Hand-written:** every part listed in `CONTEXT.md`, kebab-case.
- **Seeds (never overwritten by `copier update`):** the tracker, the sample index and the package's
  section and part files.
- **Generated (never hand-edit):** the `.docx` and `.pdf` exports.
- **Not here:** chapter prose (`manuscript/src/`), evidence (`research/src/`).
