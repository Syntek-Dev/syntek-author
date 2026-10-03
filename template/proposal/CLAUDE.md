@./CONTEXT.md

# CLAUDE.md — proposal/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (imported
above) → this file → the procedure in `proposal/workflows/` that matches the task.

## Purpose (one line)

The pitch package (the proposal or query package, the tracker and the sample index) that turns a
strong sample into a *yes*, without ever delaying the writing.

## How to work here

- **Routing:** start from the matching procedure in `proposal/workflows/` (an author procedure in
  `proposal/workflows/local/` wins). Skills: `build` assembles and proofs the package;
  `approach-a-reader` drafts one approach; `research` and `fact-check` source every claim the pitch
  makes; `spelling` and `grammar` proofread before anything leaves.
- **Model:** **Opus** for all substantive work; the mechanical tier only for exports, tracker
  dates and checklist ticks (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:**
  1. Read `.claude/MEMORY.md` for the author's decisions; name anything still undecided.
  2. Check `manuscript/src/` for what is actually promoted.
  3. Run the procedure; content lands in `proposal/src/`.
  4. Proofread, build, read the proof, and hand back. Nothing is sent.
- **Definition of done:** a publisher or agent could say yes on the strength of it; the pitch
  sounds like the book; every claim is sourced; the sample is current promoted text; the tracker
  matches reality; the author has confirmed.

## Guardrails

- **Scope discipline.** The package serves the writing and never delays it. When a task drifts into
  drafting chapters, stop and hand back.
- **The pitch sounds like the book,** and promises no more certainty, drama or reach than the book
  delivers. A pitch the sample contradicts within ten pages loses the reader at once.
- **Never invent** a comparable title, a sales figure, a platform number, an endorsement, a reader's
  interest, an offer or a deadline. These are the first claims a reader checks, and one wrong entry
  discredits the rest.
- **Never offer what does not exist.** Check `manuscript/src/` before naming what will be sent.
- **Draft, never send.** Every email is handed to the author, who sends it. It is their name,
  their relationships and their standing.
- **One source of truth.** The sample points at `manuscript/src/`; the tracker owns approach
  status. Never duplicate chapter prose here.
- **Currency is a positioning risk.** Comparable titles and market claims date quickly; re-check
  them before every submission.
- **Confirm before overwriting** the author's pitch text, a drafted or sent email, a tracker row or
  anything received from a reader.

## Output & naming

- **Hand-written:** everything in `src/`; the parts and their names are listed in
  `proposal/src/CONTEXT.md`.
- **Generated (never hand-edit):** the shippable `.docx` and `.pdf`, built with `make docx` or
  `make pdf` and a `SCOPE=`, from the source files.
- **Not here:** chapter prose (`manuscript/src/`), the evidence behind claims (`research/src/`).
