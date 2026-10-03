---
type: guide
skills: [draft-section, adapt-section, improve-section, promote-section]
model: opus
---

# Section anatomy — the small passage every document is built from

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** A section is one small passage of a document, typically 300–500 words, that does
one job: one clause group, one step in a proposal's case, one rule area of a policy. Documents are
drafted, revised and approved a section at a time, because a passage that size can be read closely
in one sitting and its provenance recorded exactly. The document is the unit; the section is what
the authoring loop works on.

## What counts as one section

| Document | One section is… | Not a section |
|---|---|---|
| Proposal | the scope, the timeline, the investment table with its notes | the whole proposal |
| Contract | one clause group: definitions, fees and payment, liability | one sub-clause |
| Policy | one rule area with its purpose and its must-statements | the Document Control block |
| Letter or email | the body | the address and metadata lines |
| Marketing copy | one page section, or one series of posts | one line of button text |

The parts the skeleton supplies (title block, disclaimer, Document Control block, signature block)
are not sections. They are filled once, from data, and checked at review. A short letter or email
is a one-section document.

## The draft file

A section draft is a Markdown file in its family's drafts folder, one subfolder per document:
`library/src/<family>/drafts/<unit-slug>/<NN>-<section-slug>.md`, where `NN` is the section's
`order` in the unit brief. Its frontmatter carries `unit`, `section`, `order`, `status`, `origin`,
`words_target`, `ledger` and `last_updated`; the ledger entry sits at
`standards/style/ledger/<unit-slug>--<section-slug>.md`.

A draft that starts a new part of the document opens with its heading (`##` becomes a LaTeX
`\section`, `###` a `\subsection`); a draft with no heading continues the part before it. An
authorised deviation goes in an internal note directly under the frontmatter,
`<!-- INTERNAL NOTE: … -->`, so that a later pass does not 'correct' it.

## The shape of a good business section

1. **The point first.** The opening sentence says what the passage commits to, permits or asks.
2. **The detail that makes it checkable:** the figure, the date, the boundary, the defined term.
3. **The limit, stated honestly:** what is excluded, what depends on the reader, what happens if
   it slips.
4. **The way forward,** where there is one: the next action, its owner and its date.

A defined term is used exactly as defined, capitalised every time, and bolded only where it is
defined. Every sentence that carries an obligation survives every edit.

## How we apply it here

- One section per request unless the author asks for more; a batch is where provenance is lost.
- One sentence per line in drafts and in the `.tex`, applied when a paragraph is edited, never by
  mass reflow.
- Size is a guide, not a gate: a definitions clause may run long; next steps may be eighty words.
- Write the section the brief planned. If it wants to split or move, propose the change to the
  brief first.
- A price, a date or a service level the author has not given is flagged, never supplied:
  `<!-- AUTHOR TO CONFIRM: … -->` for a decision, `<!-- VERIFY: … -->` for a checkable claim.

## Who implements it

- **Skills:** `draft-section` writes one section from the brief; `adapt-section` and
  `improve-section` revise it; `promote-section` moves it into the document between its markers
  (`library/docs/reference/latex-deliverables.md`).
- **Workflows:** `library/workflows/01-draft-a-section/` to
  `library/workflows/04-promote-a-section/`.

## Governing standard

`standards/method/method.md` and its `standards/method/BUSINESS.md` own the drafting principles
this shape serves; `standards/style/` owns voice and mechanics. The standards own the rules; this
guide owns the everyday call of where one section ends and the next begins.
