@./CONTEXT.md

# CLAUDE.md — proposal/src/book-proposal/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `proposal/CONTEXT.md` →
`proposal/CLAUDE.md` → `proposal/src/CONTEXT.md` → `proposal/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Build and keep the proposal that persuades a publisher to take the book on, in the book's own
voice.

## How to work here

- **Routing:** `proposal/workflows/01-assemble-the-proposal/`; guides `book-proposal-anatomy.md` and
  `comp-titles.md` in `proposal/docs/reference/`; skills `build`, `research`, `fact-check`.
- **Model:** **Opus** for every section; the mechanical tier only for the export
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:**
  1. Read `.claude/MEMORY.md` for the author's decisions; name what is still undecided.
  2. Draft or revise a section with the author, in the voice of `standards/style/voice-notes.md`.
  3. Source every claim from `research/src/evidence/`; verify every comparable title at the source.
  4. Rewrite the chapter outline from `planning/src/units/` for an editor, not a drafting session.
  5. Proofread, then `make docx SCOPE=proposal/src/book-proposal` and read the proof.
- **Definition of done:** each section does what the anatomy guide says it must; every claim
  resolves to a checked source; the sample section matches what is promoted; the author has
  confirmed.

## Guardrails

- **Do not promise more certainty than the book delivers.** A proposal that implies a verdict the
  book does not reach will be contradicted by the sample.
- **Never invent** a comparable title, a sales figure, a platform number, an endorsement or a
  publisher's interest; these are the first things an editor checks.
- **Tenses in the author section are load-bearing.** Present for what the author does now, past
  for what they did; never imply a role the author does not hold.
- **Confirm anything naming an employer, a client or a person** with the author before it goes in a
  document that leaves the repository.
- **No assembled copy in this folder,** and no chapter prose: the sample points at the manuscript.
- **Never overwrite** the author's section text without confirming.

## Output & naming

- **Hand-written:** the eight `NN-<section>.md` files, each starting from its seed.
- **Generated (never hand-edit):** the `.docx` and `.pdf` from `make docx|pdf SCOPE=proposal/src/book-proposal`.
- **Not here:** endorsement emails and the tracker (`proposal/src/endorsements/`), chapter prose.
