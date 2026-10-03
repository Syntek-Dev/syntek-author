# CONTEXT.md — manuscript/

The book itself, and the machinery for writing it. This is the production layer every other
layer serves: `planning/` holds each chapter's plan, `research/` its evidence, `standards/` its
rules and `tooling/` its build. A chapter is written here one section at a time: each section is
drafted in the chapter's drafts folder, revised with the author, and promoted into the chapter
file only on the author's word. What does **not** live here: chapter plans (`planning/src/units/`),
evidence and source notes (`research/src/`), and anything generated (`build/`).

## Directory Tree

```text
manuscript/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules for the layer
├── docs/                 ← guides: reference/ (template-owned) and project/ (the author's)
├── src/                  ← the chapters: NN-kebab-title/ holding NN-kebab-title.md + drafts/
└── workflows/            ← ordered procedures: NN-name/ (template-owned) and local/ (the author's)
```

## What's here

- `manuscript/docs/` — short guides that answer the questions which come up mid-draft.
  `manuscript/docs/reference/` is owned by the template and updated by `copier update`;
  `manuscript/docs/project/` belongs to the author, and **a same-named guide there overrides the
  reference one**.
- `manuscript/src/` — the deliverable prose. **A chapter is a folder** `NN-kebab-title/` holding
  `NN-kebab-title.md`, assembled from promoted sections in plan order, and a drafts folder for
  sections still in progress. The two-digit number is the running order; nothing else sequences
  the book.
- `manuscript/workflows/` — the procedures a task starts from: draft, adapt, improve, promote,
  review, build and learn. `manuscript/workflows/local/` holds the author's own; **a local
  procedure with the same folder name wins** over the template's.

## Key concepts

- **Unit and section.** The unit here is the chapter. A section is a small passage inside it,
  typically 300–500 words, that does one job. The chapter is planned whole and written section by
  section, so the author can judge every sentence that reaches the book.
- **Plan and prose never share a file.** The chapter's brief, its list of sections and its status
  live in `planning/src/units/NN-kebab-title.md`; the chapter file holds an H1, one
  `<!-- section: <slug> -->` marker per planned section, and the promoted prose under each marker.
- **Two status vocabularies.** The chapter climbs a ladder from `idea` to `final`; each section
  carries a status saying whose hand last shaped its words. Promotion never makes a chapter
  `final`; only the review procedure and the author's word do.
- **Every section has a record.** Its ledger entry in `standards/style/ledger/` keeps the AI's
  original (when there was one), the author's final text and every suggestion accepted or
  rejected, which is what `make provenance` reports to a publisher.

## Cross-references

- `.claude/rules/syntek-author/03-authorship.md` — who decides what, the authoring loop, never
  fabricating, and the two inline flags.
- `.claude/rules/syntek-author/01-layout-and-routing.md` — every layer, the pair rule and its
  exceptions, and the ownership classes.
- `manuscript/docs/reference/drafting-with-ai.md` — the authoring loop on one page.
- `manuscript/docs/reference/the-status-ladders.md` — both status vocabularies and how they meet.
- `planning/src/units/` — each chapter's brief and the list of its sections.
- `standards/verification/verification.md` — the gates a chapter passes on its way to `final`.
