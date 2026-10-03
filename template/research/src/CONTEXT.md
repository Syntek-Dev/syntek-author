# CONTEXT.md — research/src/

The material itself: one file per source, per checked claim and per answered question, written for
accuracy rather than readability. Where `research/docs/` explains how we gather and
`research/workflows/` gives the steps, this folder holds what was gathered. This file is the
**routing table**: read it before filing anything, because most research mistakes are filing
mistakes.

## Directory Tree

```text
research/src/
├── CONTEXT.md              ← this file: the routing table
├── CLAUDE.md               ← operating rules for the material
├── evidence/               ← one entry per checked claim, with its verdict
├── notes/                  ← one question-led note per question
<: if DOC_TYPE == 'theology' :>├── contested-readings/     ← one map per passage read more than one way
<: endif :><: if DOC_TYPE == 'fiction' :>├── permissions.md          ← seed: register of quotations, epigraphs and lyrics needing clearance
├── setting/                ← real-world detail the novel depicts
<: endif :><: if DOC_TYPE != 'business' and INCLUDE_SENSITIVE_CONTENT :>├── testimony/              ← first-person material; safeguarding-critical
<: endif :>└── sources/                ← one reading note per work
```

## What's here

| The material gives you… | It goes to… | Through |
|---|---|---|
| A checkable claim: a figure, a date, a study finding, a legal statement | `evidence/` | `research/workflows/02-verify-a-claim/` |
| An argument, a position, a work's case | `sources/` | `research/workflows/01-ingest-a-source/` |
| A question the work needs answered from several sources | `notes/` | the `research` skill |
<: if DOC_TYPE == 'theology' :>| A passage serious Christians read more than one way | `contested-readings/` | `research/workflows/03-map-a-contested-reading/` |
<: endif :><: if DOC_TYPE == 'fiction' :>| Real-world texture the novel depicts: a place, a period, a trade | `setting/` | `research/workflows/01-ingest-a-source/` |
| A quotation, epigraph or lyric the novel reproduces | a row in `permissions.md` | the author, then the publisher |
<: endif :><: if DOC_TYPE != 'business' and INCLUDE_SENSITIVE_CONTENT :>| First-person testimony: the author's own story, or one entrusted to them | `testimony/` | `research/workflows/05-handle-testimony-safely/` |
<: endif :>
A single work can feed two folders: split the note rather than duplicating it.

- **One entry per thing.** A file holding six claims makes five of them invisible when someone
  searches for the sixth.
- **Full provenance, always:** author or organisation, title, year, publisher, URL and accessed
  date, plus the date the fact was established and the date it was checked. Each subfolder's
  `CONTEXT.md` gives the entry format.
- **Keyed as written.** Where the project keeps the citation database, each source is keyed with
  the add-reference skill in the same pass as its note.
- **Nothing here is prose for the reader.** The on-voice writing happens in the content layer.

## Cross-references

- `research/docs/reference/ingesting-sources.md` — routing and reading, at more length.
- `research/docs/reference/vetting-evidence.md` — what a claim must carry; the verdicts.
- `research/workflows/CONTEXT.md` — every procedure that writes here.
- `planning/src/units/` — the unit briefs whose `sources:` lists cite this material.
<: if DOC_TYPE == 'theology' :>- `planning/src/arguments/` — argument maps, which link to the contested-reading maps here.
<: endif :><: if DOC_TYPE == 'fiction' :>- `planning/src/continuity.md` — the book's own record, where deliberate departures from the real
  world are logged.
<: endif :><: if DOC_TYPE != 'business' and INCLUDE_SENSITIVE_CONTENT :>- `standards/risk/sensitive-content.md` — read before opening anything in `testimony/`.
<: endif :>