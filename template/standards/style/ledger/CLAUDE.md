@./CONTEXT.md

# CLAUDE.md — standards/style/ledger/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `standards/CONTEXT.md` →
`standards/CLAUDE.md` → `standards/style/CONTEXT.md` → `standards/style/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Record, section by section and verbatim, which words the AI wrote, which the author wrote and
every step between, so that disclosure is a fact and voice learning has evidence.

## How to work here

- **Routing:** `draft-section` creates the entry with the AI original and `format: 2`; the first
  skill to revise an author-drafted section writes its Author original (`improve-section` when it
  opens the entry); every skill that changes a draft's words appends its revision and its decision
  rows (`adapt-section`, `improve-section`, `promote-section` for a flag answer, and a checking
  skill such as `spelling`, `grammar` or `fact-check` for a correction the author accepts; a
  checking skill run as a step of another skill's pass leaves the recording to that skill);
  `promote-section` fills `## Author final`, `promoted` and `change_ratio`, and adds the row to
  `provenance.md`; `learn-voice` reads entries with `learned: false` and sets `learned: true`
  only once the section is promoted and mined (an unpromoted entry's decisions may be read, but it
  stays unlearned). A re-promotion, after a reopened section is revised again, sets
  `learned: false`, so `learn-voice` mines the new revisions and the new decision rows.
- **Model:** the mechanical tier for recording (copying text verbatim, setting a date, running
  the ratio); **Opus** for `learn-voice`'s reading of an entry
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps (before a skill changes a draft's words, in an entry with `format: 2`):**
  1. If the entry has `origin: author` and an empty `## Author original`, write the draft's body
     (everything below its frontmatter) there, exactly as found.
  2. If the last recorded state (`CONTEXT.md`) is the Author final (the section was promoted
     and is changing again), append it as an `author` revision whose skill field is
     `promoted DD/MM/YYYY`, the date it was promoted.
  3. Compare the draft's body with the last recorded state, word for word and paragraph for
     paragraph with comments aside. If they differ, the difference is the author's: append the
     body as found as an `author` revision naming this skill, before changing anything.
- **Concrete steps (after the change):** append the draft's body as it now stands as one
  revision: `ai` for AI suggestions the author accepted, `author-note` for the author's notes or
  flag answers, naming the skill (with its strength, if any) and the decision rows logged with
  it. A run that makes both kinds of change writes two revisions, the author's notes first. A run
  that changed no word writes none.
- **Concrete steps (a redraft):** run the first list, so the author's text, interim edits and
  a promoted section's final survive. Then move the AI original (or the Author original of a
  section the author drafted) and every revision, markers included, verbatim into one dated
  comment at the end of `## AI original`, `<!-- superseded original, DD/MM/YYYY: … -->`, writing
  each `-->` inside it as `--&gt;` so the comment cannot close early. The new draft becomes the
  live AI original, with `origin: ai`, `format: 2` and today's `drafted`; `## Author original`
  and `## Revisions` start empty, and every decision row stays. If the section was promoted, its
  final went with the chain: empty `## Author final`, clear `promoted` and `change_ratio`, set
  `learned: false`, remove its row from `provenance.md`, and run `check`.
- **Concrete steps (at promotion):**
  1. On a re-promotion, run step 2 of the first list if no skill has yet, then paste the section
     exactly as promoted under `## Author final`, replacing the previous final, which the chain
     now holds.
  2. Set `promoted` to today's date (DD/MM/YYYY); on a re-promotion, also set `learned: false`.
  3. Run `python3 tooling/provenance.py ratio <entry> --write` to set `change_ratio` (it leaves
     an author-drafted entry's ratio empty).
  4. Add or update the row in `provenance.md`, then run `python3 tooling/provenance.py check`.
- **Concrete steps (a correction after promotion),** the one procedure the review workflows
  and every checking skill follow for a change made in the unit itself:
  1. Run steps 2 and 3 of the first list, comparing the section as found in the unit.
  2. Append the corrected section as its own revision (`ai` for an accepted correction, naming
     the skill and its rows; `spelling`, with both skills' rows, for one proofreading report).
  3. Write the corrected section, exactly as it now stands in the unit, as the new Author
     final, and set `learned: false`.
  4. Run `python3 tooling/provenance.py ratio <entry> --write`, update the section's row in
     `provenance.md`, then run `python3 tooling/provenance.py check`.
  An entry without `format: 2` takes steps 3 and 4 only.
- **Definition of done:** the entry has every frontmatter key, its texts are verbatim, a
  `format: 2` entry's last recorded state matches the draft when a skill finishes, its ratio was
  computed by the tool, and `check` reports no problems.

## Guardrails

- **Verbatim, always.** The AI original, the Author original and every revision are never tidied,
  corrected or reformatted once written; a cleaned-up record understates the author's work and
  falsifies the disclosure.
- **The chain only grows.** Never edit, renumber, reorder or delete a revision; a redraft moves the
  chain into the superseded comment, and a re-promotion appends to it.
- **Never backfill.** An entry without `format: 2` gets no `format` key, no Author original and no
  revision afterwards, until a redraft starts a new chain: a history reconstructed later is a
  guess.
- **Never estimate a change ratio.** It is computed by `tooling/provenance.py` or left empty.
- **Never delete an entry.** A section later cut from the work keeps its entry; add an HTML
  comment under the frontmatter saying when and why it was cut.
- **One entry per section.** A section redrafted from scratch keeps its entry (the redraft steps
  above), so the change ratio measures the draft the author actually worked from.
- **Three decisions, and only three.** Every decided row of `## Improvement decisions` is
  `accepted` (an AI proposal the author took), `rejected` (an AI proposal the author declined) or
  `author-note` (a change the author asked for, in a note or a flag answer, which the AI applied).
  A row still open keeps its decision cell empty, never `pending`. Only `accepted` and `rejected`
  rows count as AI suggestions in `make provenance`; an `author-note` row is the author's own
  change, and `learn-voice` still reads it as evidence of the voice. Never log an author's note
  as `accepted`, or its revision as `ai`: that credits the AI with the author's idea.
- **Rejections are recorded as carefully as acceptances.** They are the clearest signal of the
  author's voice.
- **Not for the work.** Nothing here is built, quoted or synchronised; `make compare` writes its
  PDF under `build/`, never here.

## Output & naming

- **Written by the skills:** `<unit>--<section-slug>.md`, where the unit is its brief's filename
  without `.md`, number included (`03-the-ford`, never the brief's shorter `slug:`), and the
  section slug is exactly as in the brief's `sections:` list.
- **Seed:** `provenance.md` (seed-if-missing; rows added by `promote-section`).
- **Generated (never saved here):** the disclosure table, printed by `make provenance`, and the
  comparison PDF, written by `make compare` under `build/compare/`.
