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
<: if DOC_TYPE != 'business' :>└── housebook.cls         ← the house book class: page design as options, the house macros
<: endif :><: if DOC_TYPE == 'business' :>├── house-preamble.tex    ← packages, house macros, neutral palette; loads house-brand.tex if present
└── skeleton.tex          ← the starting point for every .tex document
<: endif :>```

## What's here

<: if DOC_TYPE != 'business' :>- `housebook.cls` — read its header for every option. It is named so it never shadows LaTeX's
  standard `book` class, and it builds on `report`, adding the book's divisions itself; `make print`
  puts this folder on the TeX search path, so `\documentclass{housebook}` in `typeset/src/book.tex`
  finds it. Its macros, and when to use each, are in
  `typeset/docs/reference/the-house-class.md`. It also defines what Pandoc's LaTeX writer
  expects of its own template, so a chapter's base needs nothing added to compile.
<: endif :><: if DOC_TYPE == 'business' :>- `house-preamble.tex` — read its header for every macro. The colour names (`housebody`,
  `houseprimary`, `houselink`, `housemuted`, `housedivider`, `housesurface`) are the ones
  `standards/brand/brand-guide.md` maps to the brand.
- `skeleton.tex` — the leading `% unit:` line, title block, the disclaimer slot, the control
  block and a body of `% section: <slug>` … `% end section: <slug>` marker pairs that
  `promote-section` fills in plan order, proving each with `make section-check`. **The two
  status lines under `% unit:` are the document's writing status**; its gate record lives in its
  unit brief.
- `house-brand.tex` (not shipped) — created here by the author once the brand is settled:
  `\definecolor` lines for the six house colours and the font settings, nothing else.
  `house-preamble.tex` loads it when it exists.
<: endif :>
## Cross-references

<: if DOC_TYPE != 'business' :>- `typeset/docs/reference/the-house-class.md` — every option and macro, and when each is right.
- `typeset/src/page-design.md` — the author's choices that the class options carry.
- `Makefile` — `make print`, and the search path it sets.
<: endif :><: if DOC_TYPE == 'business' :>- `standards/brand/brand-guide.md` — what the brand is; this folder is how it renders.
- `standards/brand/disclaimers.md` — the wording each document's disclaimer block takes.
- `standards/verification/BUSINESS.md` — the issue-readiness gate every rendered document passes.
- `Makefile` — `make pdf FILE=…`, `ISSUE=1`, `LATEX_PASSES=3`, and why `make docx` refuses a
  `.tex` without a lossless converter.
<: endif :>- `tooling/pandoc/house.lua` — the filter that writes the house macros from the Markdown.
