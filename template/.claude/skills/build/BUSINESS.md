# BUSINESS.md — build, business mode

The domain for building proofs of business documents: one document at a time, LaTeX rendered
twice, every proof in `build/`, Word copies only when nothing is lost, and the issued copy only on
the author's word, at a status the project allows, with no open item left, and never over an
earlier copy unasked.

## Paths and unit

- **Procedure:** `library/workflows/06-build-a-proof/`.
- **Guides:** `library/docs/reference/latex-deliverables.md` (rendering and the house macros) and
  `library/docs/reference/document-anatomy.md` (the parts a document must have).
- **Scope:** one document, named with `FILE=` (a `.tex` deliverable, or a `.md` for an authored
  email or web copy) under `library/src/<family>/`; its family's skill, `<family>-documents`,
  names the parts the document must have.
- **Build settings:** `tooling/project.mk`, the project's own file, sets `ISSUE_STATUSES` (the
  statuses at which a copy may be issued; `final` unless the author has changed it),
  `FLAG_EXTRA_RE` (the open items beside the two flags; by default an unfilled field,
  `[AWAITING USER INPUT]` or `\fillme`), `DOCX_CONVERTER` (the lossless LaTeX-to-Word command,
  if any) and `LOGO_DIRS` (where logos are found first). This skill reads it and never edits it.
- **Targets:**

  | Target | Output | For |
  |---|---|---|
  | `make pdf FILE=<path>.tex` | `build/<file>.pdf` | the proof; XeLaTeX runs twice so every `\ref` resolves |
  | `make pdf FILE=<path>.tex LATEX_PASSES=3` | as above | a contents page or a question map |
  | `make pdf FILE=<path>.md` | `build/<file>.pdf` | an authored email or web copy, through Pandoc |
  | `make pdf FILE=<path> ISSUE=1` | the proof, and a copy beside the source | the issued copy, committed with its source; refused below an `ISSUE_STATUSES` status, refused while the document holds an open item, and refused when a copy is already there |
  | `make pdf FILE=<path> ISSUE=1 FORCE=1` | as above, over the existing copy | only on the author's explicit word, for that file; it never gets past an open item |
  | `make flags SCOPE=<path>` | a list | every open item that stops the document's issue, by line |
  | `make docx FILE=<path>.md` | `build/<file>.docx` | a Word copy of Markdown copy |
  | `make docx FILE=<path>.tex` | `build/<file>.docx` | a Word copy of a deliverable, only through `DOCX_CONVERTER` |

  `<file>` is the path with each `/` turned into `__`. `ISSUE` and `FORCE` take `1`, `yes` or
  `true` and are off when left out; any other value, `ISSUE=0` among them, is refused, so never
  write one to mean 'no'. Without `DOCX_CONVERTER` (set in `tooling/project.mk`, or given on the
  command line), a `.tex` Word copy is refused on purpose: a lossy copy is worse than none.

## Additions to the steps

- **Step 1 — also** confirm the file is the right version (the newest `.tex` whose leading block
  names the unit, not an older file beside it).
- **Step 2 — also issue only on the word.** A proof goes to `build/` and is never issued.
  `ISSUE=1` writes the issued copy beside its source; use it only when the author has said to
  issue this document, and only at a status `ISSUE_STATUSES` allows (the target checks it and
  refuses otherwise). It also refuses while the document holds any open item: an
  `AUTHOR TO CONFIRM` or `VERIFY` flag, or a `FLAG_EXTRA_RE` match such as a `\fillme` field,
  outside a `%` comment. Report each line it lists and clear the open items first
  (`make flags SCOPE=<file>`): a field is filled or a flag removed only with the author's
  answer, through the loop, never to get the issue through, and `FORCE=1` does not override it.
  If a copy already sits beside the source, the target refuses: report it, and ask whether the
  change is a new version (`library/docs/reference/versioning-and-the-register.md`) or a
  replacement. Add `FORCE=1` only when the author has explicitly said to replace that file,
  never to get past a refusal unasked. Never widen `ISSUE_STATUSES`, narrow `FLAG_EXTRA_RE` or
  edit `tooling/project.mk` to make an issue pass.
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
- **Proofs in `build/`, the record beside its source.** A proof is ignored by git and disposable;
  the issued copy is committed with its source, and it is what a sync of issued documents takes.
- **The issued PDF is a record**: once issued it is never rebuilt over without `FORCE=1` and the
  author's word for that file; a change is a new version
  (`library/docs/reference/versioning-and-the-register.md`).
- **A defect in wording goes back through the loop**; a defect in conversion is fixed in the
  promotion, never by editing the approved text.

## Examples

An invented report:

```text
Built: build/library__src__business__example-statement-of-work.pdf (status line-edit; working proof).
Read: 6 pages. Clause references resolved after the second pass; Document Control complete.
Defects:
1. Page 3, clause 4.2: a table runs past the right margin. Owner: the promotion's conversion.
2. Page 5: two drafting notes still visible; the document is below final, so they are expected.
```

An invented refusal, reported rather than forced:

```text
Not issued: an issued PDF already sits beside example-statement-of-work.tex. It is the record of
what was sent. Open a new version for the change, or say 'replace it' and I will rerun with
FORCE=1 for this file only.
```

An invented refusal for an open item:

```text
Not issued: example-statement-of-work.tex still holds 2 open items (make flags SCOPE=<that file>):
line 48, a \fillme in the Document Control block; line 112, a VERIFY note on the response time.
Both need your answer first. FORCE=1 cannot issue past them.
```
