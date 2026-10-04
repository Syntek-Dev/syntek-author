# CONTEXT.md — tooling/latex/

The house LaTeX: one definition of how this project's documents look in print, so the look and the
house macros live in one place and change in one place. <: if DOC_TYPE != 'business' :>For a book that is the house class,
`housebook.cls`, which `make print` uses to set `typeset/src/book.tex` with XeLaTeX: trim, typefaces,
chapter openers, epigraphs, scene breaks, drop capitals, footnotes and the book's divisions, each
page-design choice a class option the author makes.<: endif :><: if DOC_TYPE == 'business' :>For business documents that is the house
preamble: every `.tex` deliverable starts as a copy of `skeleton.tex`, which loads
`house-preamble.tex`, and `make pdf FILE=…` renders it with XeLaTeX, twice, so clause numbers and
cross-references resolve. The brand itself is not here: it lives in the author's own
`house-brand.tex`, so a template update never touches it.<: endif :>

## Directory Tree

```text
tooling/latex/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules
├── symbol-fallback.tex   ← symbols the text font lacks, drawn by an installed font that has them
<: if DOC_TYPE != 'business' :>└── housebook.cls         ← the house book class: page design as options, the house macros
<: endif :><: if DOC_TYPE == 'business' :>├── house-preamble.tex    ← packages, house macros, neutral palette; loads house-brand.tex if present
└── skeleton.tex          ← the starting point for every .tex document
<: endif :>```

## What's here

- `symbol-fallback.tex` — keeps symbols on the page. A check mark, ballot box, warning sign,
  arrow or box-drawing line that the text font cannot draw is drawn by the first installed
  fallback font that has it, where XeLaTeX would otherwise print nothing and say so only in the
  log. The `Makefile` adds it to every PDF Pandoc makes<: if DOC_TYPE == 'business' :>, and `house-preamble.tex` loads it<: endif :>. A
  character or a fallback font is one line each, as its header shows; the project's typefaces
  are set in `tooling/project.mk`, never here.
<: if DOC_TYPE != 'business' :>- `housebook.cls` — read its header for every option. It is named so it never shadows LaTeX's
  standard `book` class, and it builds on `report`, adding the book's divisions itself; `make print`
  puts this folder on the TeX search path, so `\documentclass{housebook}` in `typeset/src/book.tex`
  finds it. Its macros, and when to use each, are in
  `typeset/docs/reference/the-house-class.md`. It also defines what Pandoc's LaTeX writer
  expects of its own template, so a chapter's base needs nothing added to compile.
<: endif :><: if DOC_TYPE == 'business' :>- `house-preamble.tex` — read its header for every macro. The colour names (`housebody`,
  `houseprimary`, `houselink`, `housemuted`, `housedivider`, `housesurface`) are the ones the
  brand guide maps to the brand (in the brand folder `00-project.md` `## Paths` names).
  `\houseclassification{<level>}`, called in a document's preamble, prints the classification
  in the running header and footer of every page, where a family's standard asks for it (an
  msp-scp policy, for example); a document that never calls it keeps LaTeX's own page style.
- `skeleton.tex` — the parts in the order `library/docs/reference/document-anatomy.md` sets:
  the leading `% unit:` block, the preamble (with the classification line, commented out), the
  `% INTERNAL NOTE` comment block, the title block, the disclaimer slot, the control block
  ending with its version history table, and a body of `% section: <slug>` …
  `% end section: <slug>` marker pairs that `promote-section` fills in plan order, proving each
  with `make section-check`. **The two status lines under `% unit:` are the document's writing
  status**; its gate record lives in its unit brief.
- `house-brand.tex` (not shipped) — created here by the author once the brand is settled:
  `\definecolor` lines for the six house colours and the font settings, nothing else.
  `house-preamble.tex` loads it when it exists.
<: endif :>
## Cross-references

<: if DOC_TYPE != 'business' :>- `typeset/docs/reference/the-house-class.md` — every option and macro, and when each is right.
- `typeset/src/page-design.md` — the author's choices that the class options carry.
- `Makefile` — `make print`, and the search path it sets (the `LOGO_DIRS` of
  `tooling/project.mk` first).
<: endif :><: if DOC_TYPE == 'business' :>- The brand guide and the disclaimers file, where `00-project.md` `## Paths` puts them (by default
  `standards/brand/brand-guide.md` and `standards/brand/disclaimers.md`) — what the brand is,
  which this folder renders, and the wording each document's disclaimer block takes.
- `standards/verification/BUSINESS.md` — the issue-readiness gate every rendered document passes.
- `Makefile` — `make pdf FILE=…`, `LATEX_PASSES=3`, `ISSUE=1` (only at a status in
  `ISSUE_STATUSES`, only with no open item left, such as a `\fillme` field, and never over an
  issued copy without `FORCE=1`), and why `make docx` refuses a `.tex` without a lossless
  converter.
- `tooling/project.mk` — the logo folders TeX searches first (`LOGO_DIRS`), the Word converter
  (`DOCX_CONVERTER`) and the issuing statuses (`ISSUE_STATUSES`).
<: endif :>- `tooling/pandoc/house.lua` — the filter that writes the house macros from the Markdown.
