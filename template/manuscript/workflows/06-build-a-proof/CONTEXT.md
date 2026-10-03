# CONTEXT.md — manuscript/workflows/06-build-a-proof/

The recipe for turning the chapter files into something a person can read and check: a `.docx` for
editors and publishers, a `.pdf` proof, or an `.epub` to read on a device. It covers choosing the
scope and format, regenerating the references when the references option is on, running the build,
and (the part that matters most) **reading the proof properly** rather than merely producing it.
Everything runs through `make`; the targets encode the ordering and the exclusions.

## Directory Tree

```text
manuscript/workflows/06-build-a-proof/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, what it produces, the one thing that matters)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

- A section has been promoted, or a chapter reviewed, and the author wants to see it on the page.
- The author asks to build, compile, render, export or produce a chapter or the book.
- A `.docx` is needed for an editor, an early reader or a proposal sample.
- References have changed and you want to confirm they still resolve.

Reach for a **different** procedure when the request is really about whether a claim is true
(`research/workflows/02-verify-a-claim/`), or about the prose (the section procedures, or
`manuscript/workflows/05-review-a-chapter/`).

## What it produces, and where

Outputs land in `build/`, named after the scope (`make help` lists the targets and the naming):

| Command | Output |
|---|---|
| `make docx SCOPE=manuscript/src/NN-kebab-title` | one chapter as `.docx`, for editors |
| `make pdf SCOPE=manuscript/src/NN-kebab-title` | one chapter as a typeset `.pdf` proof |
| `make epub SCOPE=manuscript/src/NN-kebab-title` | one chapter as `.epub`, to read on a device |
| `make book` | the whole manuscript, in chapter order |

**What the build leaves out, by design:** `CONTEXT.md`, `CLAUDE.md` and `README.md` (governance,
not prose) and everything under a drafts folder (unpromoted work). A section that is not in the
proof has not been promoted, and an unpromoted draft reaching an editor's copy is a real failure,
not a cosmetic one.

## Two things this procedure will not do for you

- **It does not check whether claims are true.** Before an export to an editor or a publisher,
  claims last checked more than about twelve months ago are checked again with `fact-check`, and
  anything stale is reported. Whether staleness blocks the export is the author's call; reporting
  it is not optional.
- **It does not tell you the proof is good.** Producing a file is mechanical; reading it is not. A
  build that succeeds can still hold a raw citation key, a footnote in the wrong place, or a
  heading out of order.

## Cross-references

- `.claude/rules/syntek-author/04-build-pipeline.md` — the pipeline and every `make` target.
- `tooling/defaults.yaml` — the Pandoc metadata every build uses.
- `manuscript/src/CONTEXT.md` — how the build reads the chapter folders.
