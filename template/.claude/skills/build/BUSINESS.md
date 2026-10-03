# BUSINESS.md — build, business mode

The domain for building proofs of business documents: one document at a time, LaTeX rendered
twice, Word copies only when nothing is lost, and the issued copy only on the author's word.

## Paths and unit

- **Procedure:** `library/workflows/06-build-a-proof/`.
- **Guides:** `library/docs/reference/latex-deliverables.md` (rendering and the house macros) and
  `library/docs/reference/document-anatomy.md` (the parts a document must have).
- **Scope:** one document, named with `FILE=` (a `.tex` deliverable, or a `.md` for an authored
  email or web copy) under `library/src/<family>/`.
- **Targets:**

  | Target | Output | For |
  |---|---|---|
  | `make pdf FILE=<path>.tex` | `build/<file>.pdf` | the proof; XeLaTeX runs twice so every `\ref` resolves |
  | `make pdf FILE=<path>.tex LATEX_PASSES=3` | as above | a contents page or a question map |
  | `make pdf FILE=<path>.tex ISSUE=1` | also a PDF beside its source | the issued copy, committed with it |
  | `make pdf FILE=<path>.md` | `build/<file>.pdf` | an authored email or web copy, through Pandoc |
  | `make docx FILE=<path>.md` | `build/<file>.docx` | a Word copy of Markdown copy |
  | `make docx FILE=<path>.tex DOCX_CONVERTER='…'` | `build/<file>.docx` | a Word copy of a deliverable, only through a lossless converter |

  `<file>` is the path with each `/` turned into `__`. Without `DOCX_CONVERTER`, a `.tex` Word copy
  is refused on purpose: a lossy copy is worse than none.

## Additions to the steps

- **Step 1 — also** confirm the file is the right version (the newest `.tex` whose leading block
  names the unit, not an older file beside it).
- **Step 2 — also issue only on the word.** `ISSUE=1` writes the issued copy beside its source.
  Use it only when the document is `final` and the author has said to issue it; a proof for the
  author never uses it.
- **Step 3 — also** a `.tex` deliverable does not use the references; a Markdown `FILE` build runs
  `make refs` itself where the project keeps references.
- **Step 5 — also check the file echoed** is the one the author meant, and that the output in
  `build/` is newer than its source.
- **Step 6 — also read for a business document:** no `??` or `[?]` where a clause number or
  reference belongs; no raw Markdown (`**`, `##`, `- `); drafting notes and `\fillme` fields
  visible only while the document is below `final`; the disclaimer for the document's class
  present; the Document Control block complete; tables inside the margins; no heading stranded at
  the foot of a page; the document's parts in order.
- **Step 6 — also compare a Word copy with the PDF**, when one was made: clause numbers resolved,
  tables intact, redline marks kept, no paragraph missing. Anything lost stops the hand-over.

## Domain rules

- **Read the log's first error, not its last.** An undefined control sequence is a macro the house
  preamble lacks (use a house macro, or report the need); a missing font is reported, never
  swapped in one document.
- **The issued PDF is a record**: once issued it is never rebuilt over; a change is a new version
  (`library/docs/reference/versioning-and-the-register.md`).
- **A defect in wording goes back through the loop**; a defect in conversion is fixed in the
  promotion, never by editing the approved text.

## Examples

An invented report:

```text
Built: build/library__src__contracts__example-services-agreement.pdf (status line-edit; working proof).
Read: 6 pages. Clause references resolved after the second pass; Document Control complete.
Defects:
1. Page 3, clause 4.2: a table runs past the right margin. Owner: the promotion's conversion.
2. Page 5: two drafting notes still visible; the document is below final, so they are expected.
```
