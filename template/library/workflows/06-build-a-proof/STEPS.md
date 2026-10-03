---
workflow: 06-build-a-proof
phase: publish
skills: [build]
model: opus
---

# STEPS.md — build a proof and read it

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for rendering a document to a PDF or Word proof and reading the result.
Each step names the skill and guide it uses. **Run in order** — the ordering is load-bearing —
and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The `build` skill
> is this procedure in skill form.

## 1. Fix the file and the format

> **Skill:** `build` · **Guide:** `library/docs/reference/latex-deliverables.md`

Confirm which document (its `.tex` path) and which format: a PDF to read, or a Word copy for a
reviewer who does not use LaTeX. A section still in its drafts folder cannot be proofed; promote
it first or read the draft itself. An authored email or web copy is read in its `.md`.
_Mechanical._

## 2. Render

> **Skill:** `build` · **Guide:** `library/docs/reference/latex-deliverables.md`

Run `make pdf FILE=<path>.tex`, which renders with XeLaTeX twice so every `\ref` resolves. If it
fails, read the log's first error, not its last; the usual causes are in Troubleshooting below.
_Mechanical._

## 3. Confirm what was built

> **Skill:** `build` · **Guide:** `library/docs/reference/latex-deliverables.md`

Check the file the build echoed is the one the author meant (the right version, not an older file
beside it) and that the output in `build/` is newer than its source. _Mechanical._

## 4. Read the proof

> **Skill:** `build` · **Guide:** `library/docs/reference/document-anatomy.md`

Read it end to end. Check: no `??` or `[?]` where a reference should be; no raw Markdown (`**`,
`##`, `- `); drafting notes visible only where the document is not yet `final`; the disclaimer
present where the class needs one; the Document Control block complete; tables inside the margins;
no heading stranded at the foot of a page; the document's parts in order. _Substantive._

## 5. Make the Word copy, if asked

> **Skill:** `build` · **Guide:** `library/docs/reference/latex-deliverables.md`

A Word copy of a `.tex` comes only from a lossless converter the author has chosen:
`make docx FILE=<path>.tex DOCX_CONVERTER='<command>'`. Without one, `make docx` refuses a `.tex`
on purpose, because a lossy copy is worse than none: ask the author, and send the PDF instead.
Markdown copy needs no converter: `make docx FILE=<path>.md`. Compare any Word copy with the PDF:
clause numbers resolved, tables intact, redline marks kept, no paragraph missing. If anything is
lost, stop and report what failed; never patch the Word file. _Mechanical._

## 6. Report

> **Skill:** `build` · **Guide:** `library/docs/reference/latex-deliverables.md`

Report the proof's path, the source file and its status, what was checked, and every defect with
its page and the section it falls in. Name the procedure that will fix each defect: a wording
problem goes through the loop; a conversion problem is fixed in the promotion. _Substantive._

## Troubleshooting

| Symptom | Likely cause | What to do |
|---|---|---|
| `Undefined control sequence` | a macro the house preamble does not define | use a house macro, or report the need |
| `Missing $ inserted` or a stray symbol | an unescaped `_`, `$`, `&`, `%` or `#` in prose | escape it in the `.tex` |
| `??` where a clause number belongs | a `\label` missing or misspelt | fix the label or the `\ref` |
| a font error | a font the preamble names is not installed | report it; never swap the font in one document |
| `make docx` refuses a `.tex` | no `DOCX_CONVERTER` named | ask the author for a lossless converter, or send the PDF |
| the Word copy drops text | a construct the converter cannot carry | report it; send the PDF instead if the author agrees |
