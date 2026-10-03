# CONTEXT.md — proposal/docs/reference/

The template's proposal guides. One guide sets out the anatomy of this project's package, part by
part; two more cover comparable titles and approaching readers, which work the same way for every
book. Each follows the same shape (what it is · its topics · how we apply it here · who implements
it · governing standard). This folder is **template-owned**: `copier update` replaces it, so a
project-specific version of a guide goes in `proposal/docs/project/` under the same name.

## Directory Tree

```text
proposal/docs/reference/
├── CONTEXT.md                  ← this file
├── CLAUDE.md                   ← operating rules for the guides
├── approaching-readers.md      ← asking for a yes: why them, the ask, the exit, the log
<: if DOC_TYPE == 'theology' :>├── book-proposal-anatomy.md    ← the eight sections of a book proposal, and endorsements
<: endif :><: if DOC_TYPE == 'fiction' :>├── query-package-anatomy.md    ← query letter, synopses, sample and submissions
<: endif :>└── comp-titles.md              ← comparable titles: the shelf and the differentiator
```

## What's here

<: if DOC_TYPE == 'theology' :>- `book-proposal-anatomy.md` — **the package anatomy for this project**: the eight sections and
  what each must achieve, how the proposal is assembled from them, and how endorsers are chosen by
  reach. The procedures defer to it for every variant detail.
<: endif :><: if DOC_TYPE == 'fiction' :>- `query-package-anatomy.md` — **the package anatomy for this project**: the query letter, the
  short and long synopses, the sample, comparable titles, and how agents are chosen and tracked.
  The procedures defer to it for every variant detail.
<: endif :>- `comp-titles.md` — which shelves to search, what each entry carries, and why the differentiator
  is the entry.
- `approaching-readers.md` — reach rather than prestige, the moves of a good approach, drafting
  without sending, and chasing once.

## Cross-references

- `proposal/docs/project/` — the author's guides; a same-named file there overrides one here.
- `proposal/workflows/CONTEXT.md` — the procedures that apply these guides step by step.
- `proposal/src/CONTEXT.md` — where each part of the package lives.
- `standards/style/voice-notes.md` — the voice every part of the pitch is written in.
