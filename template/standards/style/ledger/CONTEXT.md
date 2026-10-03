# CONTEXT.md — standards/style/ledger/

The provenance ledger: one entry per section of the work, recording where its words came from.
An entry holds the AI original verbatim (when the AI drafted the section), the author's final
text at promotion, and every improvement the AI proposed with the author's decision on it. It
exists for two readers. A publisher who asks how AI was used gets a factual answer from
`make provenance` instead of a recollection; and `learn-voice` learns the author's voice from
what the author changed and, above all, from what they rejected. The template ships only this
pair and the empty `provenance.md` register and, in a project generated with the worked example,
that example's ledger entries (seed-once; delete them with the example).

## Directory Tree

```text
standards/style/ledger/
├── CONTEXT.md                         ← this file
├── CLAUDE.md                          ← operating rules
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
  learned: false          # true once promoted and mined; false again on a re-promotion
  ---

  ## AI original

  ## Author final

  ## Improvement decisions

  | # | Proposal | Reason | Decision | Author's note |
  |---|---|---|---|---|
  ```

  `## AI original` holds the AI draft the author worked from, verbatim (empty for an
  author-drafted section). A section redrafted from scratch keeps its entry: the earlier AI
  original moves into a dated `<!-- superseded AI original, DD/MM/YYYY: … -->` comment at the
  end of that heading (each `-->` inside it written `--&gt;`), and the new draft becomes the live
  text. `## Author final` holds the section exactly as promoted. Each row of the table is one
  proposal or note from `improve-section` or `adapt-section`, and its decision is one of three
  words: `accepted` or `rejected` (an AI proposal the author took or declined, counted as an AI
  suggestion by `make provenance`) or `author-note` (a change the author asked for, which the AI
  applied; not an AI suggestion, but evidence `learn-voice` still reads). An empty section holds
  nothing, or only an HTML comment.
- `provenance.md` — the register `promote-section` keeps: `Unit | Section | Origin | Change ratio
  | Promoted`. **The entries are the source of truth**; `python3 tooling/provenance.py check`
  reports any row that disagrees with its entry.
- **Change ratio** — how far the promoted text differs from the live AI original: 1 minus the
  `difflib` similarity of the two texts, measured in words, with HTML comments removed first (so
  a superseded original never counts). 0.00 means the AI draft was promoted unchanged; 1.00
  means it was entirely rewritten. It does not say who made each change, and the disclosure
  table says so.

## Cross-references

- `tooling/provenance.py` — computes a change ratio, checks the entries, prints the table.
- `.claude/rules/syntek-author/03-authorship.md` — the authoring loop and the provenance rule.
- `standards/style/voice-notes.md` — where `learn-voice` writes what the ledger teaches.
