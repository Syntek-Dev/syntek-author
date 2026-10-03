---
type: guide
skills: [promote-section, build]
model: opus
---

# LaTeX deliverables — the house skeleton, section markers and rendering

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** Every document except Markdown copy (an authored email, web copy) is a LaTeX
`.tex` file rendered to PDF with XeLaTeX. Sections are drafted in Markdown and become LaTeX only on
promotion. The `.tex` is the source of truth; every PDF or Word copy is derived, never hand-edited.

## Starting a deliverable

Copy `tooling/latex/skeleton.tex` to the document's versioned path; it inputs the house preamble,
`tooling/latex/house-preamble.tex`. Write the leading status block (`% unit:` with the unit's
slug, `% status:`, `% last_updated:`) and one marker pair per planned section, in the brief's
order; the `% unit:` line is how a promotion finds its document. Never edit the house preamble for
one document or redefine a house macro in one: report a need the preamble cannot meet.

## Section markers

```latex
% section: scope
…the promoted text of the section 'scope'…
% end section: scope
```

`promote-section` replaces only what lies between a section's two markers. Markers are never
deleted, renamed or reordered by hand; a change of order is a change to the brief first. Text
outside the markers (title block, disclaimer, Document Control, signature block) is filled from
data. In a Markdown deliverable (an authored email, web copy) the same pair is written as HTML
comments: `<!-- section: body -->` and `<!-- end section: body -->`.

## Converting a draft on promotion

| Markdown draft | LaTeX deliverable |
|---|---|
| `## Heading` / `### Heading` | `\section{Heading}` / `\subsection{Heading}` |
| `**bold**` / `*italic*` | `\textbf{bold}` / `\emph{italic}` |
| `- item` / `1. item` | `itemize` / `enumerate`; numbered clauses use the house `clause` list |
| a table | `tabularx` |
| `<!-- AUTHOR TO CONFIRM: … -->` / `<!-- VERIFY: … -->` | `\dnote{AUTHOR TO CONFIRM: …}` / `\dnote{VERIFY: …}` |
| `&  %  #  _  $  {  }` in prose | escaped with a backslash; `£` and en dashes need nothing |
| a citation key, `[@key]` | none: keys resolve only in a Markdown document, so promotion stops and the author writes the reference in full |
| `* * *` (a rule) / 'clause 4.2' written by hand | `\srule` / `clause~\ref{cl:<slug>}`, which the word check matches to the number |

Every word the author approved arrives and nothing is added: `make section-check` compares the
words between the markers with the draft's before anything is recorded. One sentence per line
survives. The draft's frontmatter stays behind; its internal note moves into the `.tex` internal
note only if it concerns the document.

## The house macros

- `\dnote{…}` — a drafting note, visible on a working proof. Every one is gone before issue.
- the `clause` list with `\label{cl:<slug>}` — numbered clauses that renumber themselves; cite
  them as `clause~\ref{cl:<slug>}`; `\ctitle{…}` heads a top-level clause.
- `\fillme` — a field the author must complete by hand; none survives to issue.
- `\ins{…}`, `\del{…}`, `\cmt{…}` — redline marks for a negotiation copy only.

## How we apply it here

- Render with `make pdf FILE=<path>.tex` (XeLaTeX twice, so every `\ref` resolves; a contents page
  needs `LATEX_PASSES=3`). A `??` that survives is a missing or misspelt label.
- A Word copy of a `.tex` comes only from a lossless converter the author has chosen:
  `make docx FILE=<path>.tex DOCX_CONVERTER='<command>'`. Without one, ask the author and send the
  PDF. `make docx FILE=<path>.md` makes a Word copy of Markdown copy.
- Proofs go to `build/`. The issued PDF sits beside its `.tex` under the same basename, as the
  record of what the reader received.

## Who implements it

- **Skills:** `promote-section` converts and inserts; `build` renders and reads the proof.
- **Workflows:** `library/workflows/04-promote-a-section/`, `library/workflows/06-build-a-proof/`.

## Governing standard

`.claude/rules/syntek-author/04-build-pipeline.md` owns the `make` targets and
`standards/style/style-sheet.md` the mechanics; this guide owns how a section becomes LaTeX.
