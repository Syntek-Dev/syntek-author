@./CONTEXT.md

# CLAUDE.md — standards/style/ledger/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `standards/CONTEXT.md` →
`standards/CLAUDE.md` → `standards/style/CONTEXT.md` → `standards/style/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Record, section by section and verbatim, which words the AI wrote and which the author kept, so
that disclosure is a fact and voice learning has evidence.

## How to work here

- **Routing:** `draft-section` creates the entry with the AI original; `adapt-section` and
  `improve-section` append decision rows; `promote-section` fills `## Author final`,
  `promoted` and `change_ratio`, and adds the row to `provenance.md`; `learn-voice` reads
  entries with `learned: false` and sets `learned: true` only once the section is promoted and
  mined (an unpromoted entry's decisions may be read, but it stays unlearned). A re-promotion,
  after a reopened section is revised again, sets `learned: false`, so `learn-voice` mines the
  new Author final and the new decision rows.
- **Model:** the mechanical tier for recording (copying text verbatim, setting a date, running
  the ratio); **Opus** for `learn-voice`'s reading of an entry
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps (at promotion):**
  1. Paste the section exactly as promoted under `## Author final`, replacing what a re-promotion
     finds there.
  2. Set `promoted` to today's date (DD/MM/YYYY); on a re-promotion, also set `learned: false`.
  3. Run `python3 tooling/provenance.py ratio <entry> --write` to set `change_ratio` (it leaves
     an author-drafted entry's ratio empty).
  4. Add or update the row in `provenance.md`, then run `python3 tooling/provenance.py check`.
- **Definition of done:** the entry has every frontmatter key, its texts are verbatim, its ratio
  was computed by the tool, and `check` reports no disagreement with `provenance.md`.

## Guardrails

- **Verbatim, always.** The AI original is never tidied, corrected or reformatted; a cleaned-up
  original understates the author's work and falsifies the disclosure.
- **Never estimate a change ratio.** It is computed by `tooling/provenance.py` or left empty.
- **Never delete an entry.** A section later cut from the work keeps its entry; add an HTML
  comment under the frontmatter saying when and why it was cut.
- **One entry per section.** A section redrafted from scratch keeps its entry. The previous AI
  original moves into a dated HTML comment at the end of `## AI original`
  (`<!-- superseded AI original, DD/MM/YYYY: … -->`), verbatim except that each `-->` inside it
  is written `--&gt;`, so the comment cannot close early. The new AI draft becomes the live
  `## AI original` text, so the change ratio measures the draft the author actually worked from.
- **Three decisions, and only three.** Every row of `## Improvement decisions` is decided
  `accepted` (an AI proposal the author took), `rejected` (an AI proposal the author declined) or
  `author-note` (a change the author asked for in a note, which `adapt-section` applied). Only
  `accepted` and `rejected` rows count as AI suggestions in `make provenance`; an `author-note`
  row is the author's own change, and `learn-voice` still reads it as evidence of the voice.
  Never log an author's note as `accepted`: that credits the AI with the author's idea.
- **Rejections are recorded as carefully as acceptances.** They are the clearest signal of the
  author's voice.
- **Not for the work.** Nothing here is built, quoted or synchronised.

## Output & naming

- **Written by the skills:** `<unit>--<section-slug>.md`, where the unit is its brief's filename
  without `.md`, number included (`03-the-ford`, never the brief's shorter `slug:`), and the
  section slug is exactly as in the brief's `sections:` list.
- **Seed:** `provenance.md` (seed-if-missing; rows added by `promote-section`).
- **Generated (never saved here):** the disclosure table, printed by `make provenance`.
