# CONTEXT.md — proposal/

The pitch package: what a publisher, an agent or an endorser receives before anyone has agreed to
the book, and the records of who has been asked and what came back. Its job is to turn a strong
sample and an honest pitch into a *yes*. It serves the writing and must never delay it: when a task
here drifts into drafting chapters, it has gone wrong; fix the chapter in `manuscript/`, then come
back. Chapter prose never lives here: the sample points at `manuscript/src/`.

## Directory Tree

```text
proposal/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules for the layer
├── docs/                 ← guides: reference/ (template-owned) and project/ (yours)
├── src/                  ← the package, its tracker and the sample index
└── workflows/            ← assemble the package · approach a reader · update the tracker
```

## What's here

- `docs/` — the anatomy of this kind of package, comparable titles, and approaching readers.
  `docs/reference/` is template-owned; a same-named guide in `docs/project/` overrides it.
- `src/` — the parts of the package itself, a tracker that is the single source of truth for every
  approach, and an index of the sample units. **`src/CONTEXT.md` names every part** and where it
  lives.
- `workflows/` — three procedures, the same for every book: assemble the package, approach one
  reader, keep the tracker true. The variant detail lives in the anatomy guide, not in the steps.

A *reader*, throughout this layer, is anyone whose yes the book needs before publication: an
endorser for a work of non-fiction, an agent for a novel.

## Cross-references

- `proposal/src/CONTEXT.md` — the parts of this project's package, and where each lives.
- `manuscript/src/` — what is being offered; check what is promoted before offering anything.
- `research/src/evidence/` — the checked claims behind any market or 'why now' statement.
- `standards/style/voice-notes.md` — the pitch sounds like the book.
- `.claude/MEMORY.md` — the author's decisions about the sample and the positioning.
