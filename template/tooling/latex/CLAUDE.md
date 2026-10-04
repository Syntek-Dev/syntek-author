@./CONTEXT.md

# CLAUDE.md — tooling/latex/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `tooling/CONTEXT.md` →
`tooling/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file.

## Purpose (one line)

<: if DOC_TYPE != 'business' :>Set the printed book through one house class, so page design is a set of options the author chooses
and styling is a small set of macros the fidelity check knows.
<: endif :><: if DOC_TYPE == 'business' :>Render every business document through one preamble, so the house look and the house macros are
defined once and the brand changes in one place.
<: endif :>
## How to work here

<: if DOC_TYPE != 'business' :>- **Routing:** the `typeset` skill uses the class through `typeset/src/book.tex` and
  `make print`; page-design choices go in through `typeset/workflows/01-design-the-page/`.
- **Model:** **Opus** for any change to the class; the mechanical tier for a print
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps (a page-design change):**
  1. Never edit `housebook.cls` for one book's look: set the class option in `typeset/src/book.tex`
     and record it in `typeset/src/page-design.md`.
  2. A look the options cannot give is a change to the class: describe it to the author first,
     because every book generated from the template shares it.
  3. After any change, `make print` and read a chapter opener, a text page and a footnote.
- **Definition of done:** the book prints with no XeLaTeX error, and every option in use is one
  the class header documents.
<: endif :><: if DOC_TYPE == 'business' :>- **Routing:** `draft-section` copies `skeleton.tex` to start a document and fills its fields;
  `promote-section` inserts approved sections between their `% section:` and `% end section:`
  markers and proves their words with `make section-check`; `build` renders with
  `make pdf FILE=…`.
- **Model:** **Opus** for any change to the preamble or the skeleton; the mechanical tier for a
  render (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps (a new document):**
  1. Copy `skeleton.tex` to the document's folder in the content layer; never fill it in here.
  2. Replace each `[BRACKETED]` field; leave `\fillme` where only the author can supply a value.
  3. Take the disclaimer for the document's class from the disclaimers file `00-project.md`
     `## Paths` names (by default `standards/brand/disclaimers.md`); a class with none has none.
  4. Render with `make pdf FILE=…` and read the proof.
- **Definition of done:** the document renders with no XeLaTeX error, every `\ref` resolves, and
  the proof has been read.
<: endif :>
## Guardrails

<: if DOC_TYPE != 'business' :>- **Page design lives in options, not in the class.** One book's typeface or trim in
  `housebook.cls` would reach every book an update touches.
- **A new macro is a change to the fidelity check too.** `tooling/texcheck.py` must know whether
  a macro's arguments are words or layout; add both together, or the check misreads it. The
  `\cmp…` macros of `compare.tex` are the exception: they never enter a chapter, so the check
  never meets them. Keep the prefix, so none can clash with a house macro.
- **Fall back, never fail silently.** A missing typeface, lettrine or script font falls back with a
  warning in the log; keep it that way.
- **`symbol-fallback.tex` reaches every Pandoc PDF.** Add a character or a fallback font there,
  never a typeface for one book: the book's typefaces are class options.
<: endif :><: if DOC_TYPE == 'business' :>- **No brand in the template.** Colours, fonts and logos go in the author's `house-brand.tex` and
  in `assets/`, never into `house-preamble.tex`, which `copier update` merges.
- **No client data here.** The skeleton and preamble stay counterparty-neutral; a filled-in
  document lives only in its client's folder.
- **Never hand-number a clause.** Use `\label{cl:<slug>}` and `clause~\ref{cl:<slug>}`;
  references renumber themselves when a clause moves.
- **A new house macro is a change to the fidelity check too.** `tooling/texcheck.py` must know
  whether its arguments are words or layout, or `make section-check` misreads it. The `\cmp…`
  macros of `compare.tex` never enter a document, so the check never meets them; they never reuse
  `\ins`, `\del` or `\cmt`.
- **Delete every drafting note before issue.** A `\dnote` that survives into a sent document
  publishes an internal thought; the issue-readiness gate checks for them.
- **An issued copy is a record.** `ISSUE=1` refuses below an issuing status or while any open
  item is left (a flag, a `\fillme` field: what `make flags` counts), and never replaces an
  issued PDF; a revision is issued as a new version under its own name, and `FORCE=1` is used
  only on the author's explicit word. Neither switch takes `0`: leave it out instead.
- **Logos by resolution, not by luck.** The folder holding the right size goes in `LOGO_DIRS`
  (`tooling/project.mk`), which TeX searches first; never copy a brand logo beside a document
  to make TeX pick it.
<: endif :>
## Output & naming

<: if DOC_TYPE != 'business' :>- **Template-owned:** `housebook.cls`, `symbol-fallback.tex`, `compare.tex` and this pair.
- **Generated (never hand-edit):** the print PDF and its working files in `build/typeset/`; the
  comparison and its working files in `build/compare/`.
<: endif :><: if DOC_TYPE == 'business' :>- **Hand-written:** `house-preamble.tex`, `skeleton.tex`, `symbol-fallback.tex`, `compare.tex`,
  this pair; the author's `house-brand.tex`.
- **Generated (never hand-edit):** the PDF in `build/`, and the issued copy beside its source when
  `ISSUE=1` is used; the comparison in `build/compare/`, which is never issued.
<: endif :>