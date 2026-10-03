# CONTEXT.md — manuscript/src/01-example-chapter/

A worked example, shipped once when the project was generated, so the shape of a chapter is
visible before any real chapter exists. It is not part of the book: its prose is invented
placeholder text. Its plan is `planning/src/units/01-example-chapter.md`<: if DOC_TYPE == 'theology' :>, and its argument map
is `planning/src/arguments/01-example-chapter.md`<: endif :>. Delete this folder, its plan<: if DOC_TYPE == 'theology' :>, its
argument map<: endif :> and its two ledger entries when they have served their purpose (the steps are
in this folder's CLAUDE.md); `copier update` will not bring them back.

## Directory Tree

```text
manuscript/src/01-example-chapter/
├── CONTEXT.md                ← this file
├── CLAUDE.md                 ← operating rules for this chapter
├── 01-example-chapter.md     ← the chapter: an H1 and two section markers, one filled
└── drafts/                   ← sections in progress; README.md and no pair
    ├── README.md             ← what the folder is for
    └── 02-the-turn.md        ← the second section, an AI draft awaiting the author
```

## What's here

- `manuscript/src/01-example-chapter/01-example-chapter.md` — the chapter file. The section
  `opening`, which the author drafted, has been promoted and sits under its marker. The marker
  for `the-turn` is empty, because that section is still a draft.
- `manuscript/src/01-example-chapter/drafts/02-the-turn.md` — an AI draft at `status: ai-draft`,
  with the frontmatter every section draft carries. It cannot be promoted until the author has
  resolved its open questions:
<: if DOC_TYPE == 'theology' :>  an `AUTHOR TO CONFIRM` flag, a `VERIFY` flag and four bracketed placeholders. A trailing
  block labels each claim with one of the six claim categories, and uses all six.
<: else :>  an `AUTHOR TO CONFIRM` flag about the point-of-view character.
<: endif :>- **Two ledger entries**, one per section, as every section has.
  `standards/style/ledger/01-example-chapter--opening.md` records the promoted `opening`: it was
  author-drafted, so it has no AI original and no change ratio, and its `## Author final` is the
  section exactly as it sits under its marker.
  `standards/style/ledger/01-example-chapter--the-turn.md` holds the AI original of `the-turn`
  (the draft's body, verbatim), as `draft-section` writes it; the draft's `ledger:` key points to
  it. The register `standards/style/ledger/provenance.md` ships empty, so neither section has a
  row there until the author adds one.

## The one thing this example shows

The chapter file holds only what the author has approved; everything else waits in drafts. Read
the chapter file and the draft side by side: the first section is in the book, the second is a
proposal with open questions, and nothing moves from one to the other except on the author's word.

## Cross-references

- `manuscript/docs/reference/section-anatomy.md` — the files and markers this example illustrates.
- `manuscript/docs/reference/the-status-ladders.md` — what `ai-draft` and `promoted` mean.
- `manuscript/workflows/02-adapt-a-draft/` — how the author's notes would revise the draft.
- `manuscript/workflows/04-promote-a-section/` — how it would enter the chapter.
