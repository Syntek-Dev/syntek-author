# CONTEXT.md — standards/style/ledger/

The provenance ledger: one entry per section of the work, recording where its words came from.
An entry holds the text the section started from (the AI original when the AI drafted it, the
author's original when the author did), every revision between that and the final text with who
made it, the author's final text at promotion, and every improvement the AI proposed with the
author's decision on it. It exists for two readers. A publisher who asks how AI was used gets a
factual answer from `make provenance` and `make compare` instead of a recollection; and
`learn-voice` learns the author's voice from what the author changed and, above all, from what
they rejected. The template ships only this pair and the empty `provenance.md` register and, in a
project generated with the worked example, that example's ledger entries (seed-once; delete them
with the example). This path is fixed (`00-project.md` `## Paths`, 'Ledger'): `make provenance`,
`make compare` and every draft's `ledger:` pointer read it.

## Directory Tree

```text
standards/style/ledger/
├── CONTEXT.md                         ← this file: the format of an entry
├── CLAUDE.md                          ← operating rules: the procedure every skill follows
├── provenance.md                      ← the disclosure register: one row per promoted section (seed)
└── <unit>--<section-slug>.md          ← one ledger entry per section (written by the skills)
```

## What's here

- `<unit>--<section-slug>.md` — one entry. The filename joins the unit's name and the section's
  slug with a double hyphen, for example `03-the-ford--crossing-at-night.md`. The unit's name is
  its brief's filename without `.md`, number included (`03-the-ford`), never the brief's shorter
  `slug:`; it is also the entry's `unit:` and the `Unit` column of `provenance.md`.
  Frontmatter and body:

  ```markdown
  ---
  unit: 03-the-ford
  section: crossing-at-night
  origin: ai              # ai | author
  drafted: DD/MM/YYYY
  promoted:               # DD/MM/YYYY, set by promote-section
  change_ratio:           # 0.00 to 1.00, computed at promotion; empty for author-drafted
  learned: false          # true once promoted and mined; false again when its final is replaced
  format: 2               # the revision record below; absent from an entry that predates it
  ---

  ## AI original

  ## Author original

  ## Revisions

  ## Author final

  ## Improvement decisions

  | # | Proposal | Reason | Decision | Author's note |
  |---|---|---|---|---|
  ```

- **The sections, in this order.** `## AI original` holds the AI draft the author worked from,
  verbatim (empty for an author-drafted section). `## Author original` holds, verbatim, the text
  the loop started from when the AI did not draft the section, written by the first skill to
  revise it (empty for an AI-drafted section). `## Revisions` holds the chain of states below.
  `## Author final` holds the section exactly as promoted. Each row of the decisions table is one
  proposal or note from a skill. An empty section holds nothing, or only an HTML comment.
  `## Author original` and `## Revisions` are optional: an entry without them is still valid, and
  a skill that needs one adds it in its place.
- **The decision words.** `accepted` or `rejected` (an AI proposal the author took or declined,
  counted as an AI suggestion by `make provenance`), or `author-note` (a change the author asked
  for, in a note or a flag answer, which the AI applied; not an AI suggestion, but evidence
  `learn-voice` still reads). A row still open keeps its decision cell empty until the author
  chooses; no fourth word is ever written.
- **A revision** is the section's full text after one change, verbatim, comments kept. It opens
  with one marker on a line of its own and runs to the next marker:

  ```markdown
  ## Revisions

  <!-- revision 1 · ai · 04/10/2026 · improve-section (edit) · rows 1–4 -->
  The section's full text after the accepted proposals.
  <!-- revision 2 · author · 05/10/2026 · adapt-section -->
  The section's full text as the author's own edits left it.
  ```

  The fields are separated by middle dots. Revisions are numbered 1, 2, 3 with no gaps; the date
  is the day it was recorded (DD/MM/YYYY); the skill is the one that recorded it, with its
  strength in brackets when it has one, or `promoted DD/MM/YYYY` for a previous Author final;
  `rows` names the decision rows logged with the change, accepted and rejected alike (a number, or
  a range with an en dash), and is left out when there are none.
- **The three kinds** say who made the change from the state before, in the decision words:
  `ai` (an AI suggestion the author accepted: `improve-section` proposals, the alternatives
  chosen in `adapt-section`, an accepted spelling, grammar or fact-check correction);
  `author-note` (the AI applying the author's own notes, or the author's answer to a flag); and
  `author` (the author's own hand-edits, which every skill finds by comparing the draft with the
  last recorded state before it changes anything; also a previous Author final).
- **The chain.** It starts at the original: the AI original when `origin: ai`, the Author
  original when `origin: author`. Each revision is the next state, and the Author final the last;
  whatever differs between the last revision and the Author final is the author's. Two states are
  equal when they match word for word and paragraph for paragraph, comments aside (a paragraph
  break added or removed is a change); a state equal to the one before it is never written. The
  **last recorded state** is the Author final when it is filled, differs from the last state in
  the chain and the section is not reopened; otherwise the last revision, or the original when
  there is none.
- **A reopened section.** A promoted section that changes again (reopened, or corrected after
  promotion) first takes its Author final into the chain, as an `author` revision whose skill
  field is `promoted DD/MM/YYYY` (its `promoted` date), unless the last state in the chain already
  equals it. From then until it is promoted again it is **reopened**: a revision reads `promoted`
  with its promoted date, or is dated after that date, and `## Author final` still holds the
  previous final, as the unit does. Its record ends at its last revision, so `make compare` shows
  it as reopened and `learn-voice` waits for the new final. A correction after promotion writes
  its corrected text as the new Author final at once, so it never leaves the section reopened.
- **A redraft** keeps its entry and restarts the chain. The first list in `CLAUDE.md` runs
  first, so a promoted section's final is on the chain; then the earlier original (the AI
  original, or the Author original of a section the author drafted) and every revision, markers
  included, move into one dated `<!-- superseded original, DD/MM/YYYY: … -->` comment at the end
  of `## AI original` (each `-->` inside it written `--&gt;`), and the new draft becomes the live
  AI original. A promoted section's final has gone with its chain, so `## Author final`,
  `promoted` and `change_ratio` are emptied and its `provenance.md` row removed: it is a draft
  again until it is promoted.
- **An older entry** has no `format: 2`: it predates the revision record. It is never backfilled,
  so `make compare` shows only the stages it has; its decision rows and Author final are written
  as before. A redraft starts a whole new chain, so a redrafted entry carries `format: 2`.
- `provenance.md` — the register `promote-section` keeps: `Unit | Section | Origin | Change ratio
  | Promoted`. **The entries are the source of truth**; `python3 tooling/provenance.py check`
  reports any row that disagrees with its entry.
- **Change ratio** — how far the promoted text differs from the live AI original: 1 minus the
  `difflib` similarity of the two texts, measured in words, with HTML comments removed first (so
  a superseded original never counts). 0.00 means the AI draft was promoted unchanged; 1.00
  means it was entirely rewritten. It does not say who made each change, and the disclosure
  table says so; the revisions do, and `make compare` prints them.

## Cross-references

- `tooling/provenance.py` — computes a change ratio, checks the entries and their revisions,
  prints the table.
- `.claude/rules/syntek-author/03-authorship.md` — the authoring loop and the provenance rule.
- `.claude/rules/syntek-author/04-build-pipeline.md` — `make provenance` and `make compare`.
- `standards/style/voice-notes.md` — where `learn-voice` writes what the ledger teaches.
