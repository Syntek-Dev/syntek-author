# brand-guide.md — how the business looks

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **This file is a seeded stub, and it is deliberately unfinished.** It ships with the project so
> that the skills which route here point at something real from day one. It is the author's file:
> `copier update` never overwrites it. Every brand fact (a colour, a font, the logo) is the
> author's call, flagged `AUTHOR TO CONFIRM` until it is made; until then documents render in the
> preamble's neutral defaults.

The visual identity for every document the business issues. `build` renders it through
`tooling/latex/house-preamble.tex`, whose colour and font names this guide maps, so a brand
change is made once in the author's `house-brand.tex` override and every document follows.
`draft-section` lays out a new document from `tooling/latex/skeleton.tex`, which follows rule 4.

**How to add an entry.** Record each decision under its heading, dated DD/MM/YYYY, with the
reason; set the matching value in `house-brand.tex` in the same change; record the decision in
`.claude/MEMORY.md` `## Decisions`; then build a proof. Remove the section's flag once its
decision is made, and mark an overturned entry superseded rather than deleting it.

Dates DD/MM/YYYY.

---

## 1. Logo

**Requirement.** The logo files live in `assets/`, in a vector form for print and a
high-resolution raster form for anything that cannot take vectors. A document places the logo
only where rule 4 says, never stretched, recoloured or redrawn.

<!-- AUTHOR TO CONFIRM: the logo files and their names, the minimum size, the clear space around it, and which version goes on light and dark backgrounds. -->

_No entries yet._

**Why this rule exists.** A logo rebuilt by hand for one document is the version a client copies
into their own records.

---

## 2. Colour

**Requirement.** Documents use only the colours the house preamble names, each through its name
and never as a hex value typed into a document: `housebody` (all running text), `houseprimary`
(headings, clause titles), `houselink` (hyperlinks, cross-references), `housemuted` (captions,
drafting notes), `housedivider` (rules, table borders) and `housesurface` (table header fills).
Each value is an entry in the table below. Text and its background meet WCAG 2.2 AA contrast
(4.5:1 for body text).

<!-- AUTHOR TO CONFIRM: a hex value for each of the six preamble colours, recorded below and set in house-brand.tex. -->

| Preamble name | Value | Chosen | Reason |
|---|---|---|---|

_No entries yet._

**Why this rule exists.** A colour typed by hex into one document drifts from the brand the next
time the brand changes; a named colour changes everywhere at once.

---

## 3. Type

**Requirement.** Documents use one body face, one heading face and one monospaced face, each
installed on every machine that renders documents (XeLaTeX finds fonts by name, and fails loudly
when one is missing). Pin the weights by name: a family whose semi-bold registers as bold will
hijack bold text unless its faces are named explicitly.

<!-- AUTHOR TO CONFIRM: the body, heading and monospaced faces, by their installed names, with the weights to pin. -->

_No entries yet._

**Why this rule exists.** A font that renders on one machine and not another produces two
different documents from the same source.

---

## 4. Document layout

**Requirement.** Every issued document follows the same order, set out in
`tooling/latex/skeleton.tex`: the title block (title, trading name, date) → the disclaimer for
its class, where the class has one → the document-control block (title, reference, version,
status, date, owner, next review) → the body. A long document adds, after the control block, a
'how to read this document' table, a summary that holds everything needed to decide, a clickable
contents page and, where useful, a question map linking each likely question to the section that
answers it.

<!-- AUTHOR TO CONFIRM: whether documents carry a letterhead (logo and contact line) and, if so, what it contains; never personal contact details the business does not publish. -->

_No entries yet._

**Why this rule exists.** A reader who has seen one of the business's documents should know where
to look in the next.

---

## 5. Do and don't

**Requirement.**

- **Do** render every document through the house preamble, so the brand lives in one file.
- **Do** keep the logo, palette and fonts in `assets/` and the preamble override, never pasted
  into a document's own source.
- **Don't** add a colour, a font or a decorative element for one document.
- **Don't** use symbols or emoji the body font cannot render; the preamble's fallback covers a
  short list only.

_No entries yet._

**Why this rule exists.** Every exception made for one document becomes the precedent for the
next.
