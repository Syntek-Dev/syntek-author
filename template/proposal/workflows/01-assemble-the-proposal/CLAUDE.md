@./CONTEXT.md

# CLAUDE.md — proposal/workflows/01-assemble-the-proposal/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `proposal/CONTEXT.md` →
`proposal/CLAUDE.md` → `proposal/workflows/CONTEXT.md` → `proposal/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Draft, source, proofread and build the package, in the book's own voice, into something a reader
could say yes to.

## How to work here

**Follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.** The model tags in the checklist
are authoritative: `opus` items are judgement; `sonnet` items belong to the mechanical tier.

- **Routing:** skills `grill-with-docs` (open decisions), `research` and `fact-check` (comparable
  titles and claims), `spelling` and `grammar` (the proofread), `build` (the proof). Guides: the
  package anatomy and `comp-titles.md`, both in `proposal/docs/reference/`.
- **Model:** **Opus** for every part of the pitch; the mechanical tier only for the build and
  ticks (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** check what is decided → check what exists → read the anatomy → draft the
  pitch → verify the comparable titles → write the book's summary → write the author section →
  source every claim → point at the sample → proofread → build and read the proof → hand back.
- **Definition of done:** each part does what the anatomy guide says it must; every comparable
  title is verified and differentiated; every claim resolves to a checked source; the sample
  points only at units the author chose whose sections are all promoted; a proof has been built
  and read; the author has confirmed; nothing was sent.

## Guardrails

- **Do not make the author's decisions to unblock yourself.** The sample, the positioning and the
  hook are the author's. Draft what can be drafted, and say plainly what is blocked and on whom.
- **The pitch sounds like the book,** and promises no more than the book delivers.
- **Never invent** a comparable title, a sales figure, a platform number, an endorsement, an
  interest or a deadline; verify every comparable title at the source.
- **Write the summary for the reader, not for a drafting session.** Unit briefs are raw material;
  they are rewritten, never pasted.
- **Tenses in the author section are load-bearing,** and anything naming an employer, a client or
  a person is confirmed with the author first.
- **Currency is a positioning risk.** Re-check comparable titles and market claims before every
  submission.
- **Never overwrite** the author's text without confirming.

## Output & naming

- **Produces:** the package's parts in `proposal/src/`, and the sample index.
- **Also writes:** evidence entries in `research/src/evidence/` for the pitch's claims.
- **Generated (never hand-edit):** the `.docx` and `.pdf` proofs.
- **Does not touch:** manuscript prose, the tracker, or any email.
