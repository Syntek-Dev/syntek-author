@./CONTEXT.md

# CLAUDE.md — library/workflows/06-build-a-proof/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/workflows/CONTEXT.md` → `library/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Render a document to a PDF or Word proof and read it, reporting every defect by location.

## How to work here

- **Routing:** the `build` skill is this procedure in skill form. Guide:
  `library/docs/reference/latex-deliverables.md`; the targets are in
  `.claude/rules/syntek-author/04-build-pipeline.md`.
- **Model:** follow the checklist tags: the mechanical tier runs `make`; **Opus** reads the proof
  and writes the report.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.
- **Definition of done:** the proof exists in `build/`, it was built from the file the author meant,
  it has been read end to end, and every defect is reported with its location.

## Guardrails

- **Read the proof.** A successful `make` proves only that LaTeX finished.
- **Never edit a derived file.** A PDF or Word copy is fixed by changing its `.tex` and rebuilding,
  never by hand, and never by a script run over the output.
- **A Word copy that loses text is not a copy.** Stop and report the construct that failed; never
  patch the `.docx`. A `.tex` gets a Word copy only through the author's lossless converter
  (`DOCX_CONVERTER`); without one, the author is asked and the PDF is sent instead.
- **Proofs are not issue copies.** A proof never goes beside the `.tex` and is never sent; the issue
  PDF comes from `library/workflows/05-review-a-document/` at `final`.
- **Never fix a build by editing the house preamble or the `Makefile`.** Report the failure to the
  author: both are template-owned.
- **Drafts are never built.** Files in a drafts folder are excluded on purpose.

## Output & naming

- **Generated (never hand-edit):** the PDF and any Word copy in `build/`, named after the source.
- **Hand-written:** nothing; a defect is fixed in the `.tex` through the procedure that owns it.
