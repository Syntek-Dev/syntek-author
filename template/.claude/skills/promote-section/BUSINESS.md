# BUSINESS.md — promote-section, business mode

The domain for promoting a section into a business document: finding the deliverable by its
`% unit:` line, converting the approved Markdown to house LaTeX, inserting it between its marker
pair, proving every word arrived, and proving the document still renders.

## Paths and unit

- **Unit:** a document. **Procedure:** `library/workflows/04-promote-a-section/`.
- **Draft:** `library/src/<family>/drafts/<unit-slug>/<NN>-<section-slug>.md`, in one of the
  families this project selected (`business`, `legal`, `email`, `accounting`, `social-media`,
  `msp-scp`).
- **Family skill:** read the family's skill, `<family>-documents`, as well as this file: the parts
  the family's documents require and its conventions.
- **Unit file:** the newest `.tex` in the unit's family whose leading block opens
  `% unit: <unit-slug>`, then `% status:` and `% last_updated:`. Each section sits between a
  marker pair, `% section: <slug>` and `% end section: <slug>`, in the brief's order. A Markdown
  deliverable (an authored email or web copy) uses the same pair as HTML comments,
  `<!-- section: <slug> -->` and `<!-- end section: <slug> -->`, and needs no conversion; web copy
  is found by `unit: <unit-slug>` in its frontmatter, which also carries its `status:` and, when
  new, opens with `unit:`, `status:` and `last_updated:` matching the brief.
- **Starting point:** the LaTeX skeleton named in `00-project.md` `## Paths` (by default
  `tooling/latex/skeleton.tex`, which inputs the house preamble).
- **Review procedure (step 9):** `library/workflows/05-review-a-document/`.
- **Guides:** `library/docs/reference/latex-deliverables.md` (the conversion table and the
  markers), `library/docs/reference/versioning-and-the-register.md` and
  `library/docs/reference/the-status-ladders.md`.

## Additions to the steps

- **Step 2 — also stop on an open field.** A draft holding `[AWAITING USER INPUT]` is not promoted:
  the field goes back to the author, and a value they give there and then is applied and recorded
  like a flag answer. `make flags` lists these fields as well as the two flags (`FLAG_EXTRA_RE` in
  `tooling/project.mk`).
- **Step 2 — also stop on an open choice.** A section whose ledger entry still has a decision
  row with an empty cell is not promoted: its draft may carry a holding line, the AI's wording
  kept only until the author chooses (`adapt-section`). The author chooses first, and the choice
  is applied and recorded as `adapt-section` step 9 sets out.
- **Step 2 — also stop on a citation key bound for a `.tex`.** Citation keys (`[@key]`) resolve
  only in Markdown deliverables; in a `.tex` they print raw while the build still succeeds. A
  draft whose unit file is a `.tex` and whose body contains `[@` is not promoted: the author
  writes each reference out in full in the draft, and confirms again.
- **Step 3 — also never promote into a circulated version.** If the document's register row or
  Document Control block shows it has been sent, stop: a new version is opened first
  (`library/docs/reference/versioning-and-the-register.md`). If no `.tex` exists yet, create it
  from the LaTeX skeleton at its versioned path, with the leading block matching the brief and
  one marker pair per planned section, in the brief's order.
- **Step 4 — also convert to house LaTeX.** Convert the draft's body using the table in
  `library/docs/reference/latex-deliverables.md`: headings, emphasis, lists (numbered clauses
  into the house `clause` list, with `\label{cl:<slug>}` where other clauses refer to them),
  tables, escaped specials. One sentence per line survives. An internal note that concerns the
  document moves into the `.tex` internal-note block; one that concerns only the draft stays.
- **Step 5 — also replace only what lies between the pair**, and never delete, rename or reorder a
  marker. Then prove the words: run
  `make section-check FILE=<path>.tex SECTION=<section-slug> DRAFT=<draft path>`, which compares
  the words between the section's marker pair with the draft's prose (through `pandoc -t plain`)
  and fails on any insertion, deletion or change. Then run `make pdf FILE=<path>.tex` and read the
  promoted section in the proof: no LaTeX error, no `??` for a reference this section makes, no
  raw Markdown. A failure of either is fixed in the conversion, never by changing the approved
  text, and both are re-run until they pass. A Markdown deliverable skips the conversion and the
  word-check.
- **Step 6 — also record the approved Markdown, and only after the word-check passes.** Nothing
  is written to the ledger or the provenance register while `make section-check` fails. `## Author final`
  holds the draft's approved Markdown body, not the LaTeX, so the change ratio compares like with
  like.
- **Step 7 — also add one dated line** for the document under the `Status` heading of
  `.claude/MEMORY.md` (mapped in `00-project.md` `## Memory headings`). The register row is
  written at the end of the line edit, in `library/workflows/05-review-a-document/` step 12, never
  at promotion.
- **Step 8 — also** the proof from step 5 is this step's reading; note any seam with the sections
  either side.

## Domain rules

- **Every approved word arrives and nothing is added** in the conversion; a clause number, a
  defined term's bolding or a cross-reference is house markup, never new wording. The
  word-check proves it; a read of the proof alone does not.
- **Citation keys belong to Markdown deliverables only.** A `.tex` deliverable carries each
  reference written out in full; a `[@key]` never reaches it.
- **A delivered document is a historical record** (`standards/method/BUSINESS.md` Section 8):
  promotion never edits a version that has been sent.
- **Disclaimers, the Document Control block and the signature block are not sections**; they sit
  outside the markers and are filled from data, never by promotion.

## Examples

An invented deliverable after one section is promoted:

```latex
% unit: example-services-agreement
% status: draft
% last_updated: DD/MM/YYYY
…
% section: fees
\section{Fees and payment}
\begin{clause}
  \item \ctitle{Invoices}\label{cl:invoices}
  The Client shall pay each invoice within the period stated in the Order.
\end{clause}
% end section: fees
```
