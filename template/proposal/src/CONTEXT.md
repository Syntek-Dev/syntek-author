# CONTEXT.md — proposal/src/

The package itself: the parts a reader actually receives, the tracker that records every approach,
and the index of sample units. This file names every part this project's package has, so the
shared procedures in `proposal/workflows/` can say 'the tracker' or 'the comparable-titles file'
and mean exactly one path.

## Directory Tree

```text
proposal/src/
├── CONTEXT.md              ← this file: the parts, and where each lives
├── CLAUDE.md               ← operating rules for the package
<: if DOC_TYPE == 'theology' :>├── book-proposal/          ← the eight proposal sections, built in filename order
├── endorsements/           ← tracker.md (seed) · drafts/ · received endorsements
<: endif :><: if DOC_TYPE == 'fiction' :>├── comp-titles.md          ← seed: comparable titles, checked
├── query-letter.md         ← seed: the master query letter
├── submissions/            ← tracker.md (seed) · drafts/ (one tailored query per agent)
├── synopsis-long.md        ← seed: about 1,000–1,500 words
├── synopsis-short.md       ← seed: about 500 words
<: endif :>└── sample/                 ← sample-index.md (seed): pointers into manuscript/src/, never copies
```

## What's here

| Part | Lives at | Built or sent as |
|---|---|---|
<: if DOC_TYPE == 'theology' :>| The proposal | `book-proposal/`, sections 01 to 08 | `make docx SCOPE=proposal/src/book-proposal` |
| Comparable titles | `book-proposal/04-comparable-titles.md` | part of the proposal |
| The tracker | `endorsements/tracker.md` | never sent |
| Approach drafts | `endorsements/drafts/<reader-slug>.md` | handed to the author, who sends them |
| Received endorsements | `endorsements/received-<reader-slug>.md` | kept verbatim |
<: endif :><: if DOC_TYPE == 'fiction' :>| The query letter | `query-letter.md` | the master; tailored copies in `submissions/drafts/` |
| The synopses | `synopsis-short.md`, `synopsis-long.md` | `make docx SCOPE=proposal/src/synopsis-short.md` (or long) |
| Comparable titles | `comp-titles.md` | quoted in the query letter |
| The tracker | `submissions/tracker.md` | never sent |
| Query drafts | `submissions/drafts/<agent-slug>.md` | handed to the author, who sends them |
<: endif :>| The sample | `sample/sample-index.md` | `make docx SCOPE=manuscript/src/<unit>` per unit |

- **The tracker is the single source of truth** for who has been approached and what came back.
- **The sample points at `manuscript/src/`** and holds no prose; only units whose sections are
  all promoted are offered, and only those the author chose.
- **Trackers and the sample index are seeds:** they ship empty and are never overwritten by
  `copier update`.

## Cross-references

<: if DOC_TYPE == 'theology' :>- `proposal/docs/reference/book-proposal-anatomy.md` — what each section must achieve; endorsers by
  reach.
<: endif :><: if DOC_TYPE == 'fiction' :>- `proposal/docs/reference/query-package-anatomy.md` — what each part must achieve; agents and
  their guidelines.
<: endif :>- `proposal/docs/reference/comp-titles.md` — building the comparable-titles list.
- `proposal/workflows/CONTEXT.md` — assemble, approach, update the tracker.
- `manuscript/src/` — what is being offered.
