---
type: guide
skills: [draft-section, structure-review, clause-consistency]
model: opus
---

# Document anatomy — the parts of a business document, in order

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** Every deliverable in `library/src/` is assembled from the same parts in the same
order, so a reader always knows where to look and a reviewer can check a document part by part.
Some parts come from data and are filled once; the body is written section by section through
the loop. A part missing from a document is a structural finding, not a style preference.

## The parts, in order

1. **The leading status block:** `% unit:`, `% status:` and `% last_updated:` comment lines, first.
2. **The preamble**, taken unchanged from the house skeleton `00-project.md ## Paths` names (by
   default `tooling/latex/skeleton.tex`, which inputs `tooling/latex/house-preamble.tex`).
3. **The internal note:** a `%` comment block under the preamble recording authorised deviations,
   sources checked with their dates, and anything unresolved. It is never rendered.
4. **The title block:** title, the business's trading name, the date.
5. **The disclaimer,** where the document's class carries one, copied verbatim from the
   disclaimers file `00-project.md ## Paths` names (by default `standards/brand/disclaimers.md`).
   Never paraphrased, never improvised; a class with none has none.
6. **The Document Control block** on versioned and external documents, ending with the version
   history table (Version · Date · Author · Change description · Approved by).
7. **The reader's map** for a long document: 'How to read this document' (Where · What), then a
   summary holding everything needed to decide, every price included, then the contents.
8. **The body:** the sections, in the brief's order, each between its `% section:` markers.
9. **The closing parts:** the signature block, the schedules, and in an instrument the governing
   law clause, last.

## Required parts by family

Each family's standard, `library/docs/reference/<family>-standards.md`, names its document types
and what each adds to the parts above: the rows of its Document Control block, the sections its
body must include, and the disclaimer class it carries, if any. Read it before the brief's
`sections:` list is settled, so every required part is planned as a section or filled from data.

| Part | Comes from |
|---|---|
| Document Control rows | the family standard, per document type |
| Required body sections | the family standard, planned as sections in the unit brief |
| Disclaimer | the disclaimers file, for the class the family standard names |
| An authored email's parts | the email anatomy, when this project has the email family |

## Families of documents

Documents that rely on each other (an agreement, its statement of work, its service levels) state
their order of precedence, recorded once in `planning/src/precedence.md` and cited by each. A
letter or email may describe a contractual term in plain English, but the term lives in the
instrument: reproduce the substance, never the clause number.

## How we apply it here

- Forms (an invoice, a timesheet) are filled from their template, not drafted section by section;
  the loop is for prose.
- Fill every field from a fact the author gave or a check recorded in `research/src/evidence/`;
  an unfilled template field stays `[AWAITING USER INPUT]` and blocks `final`.
- The register is set by the reader: an instrument or policy keeps the formal register, and brand
  voice does not soften it; proposals, letters, emails and social copy use the brand voice in the
  brand folder `00-project.md ## Paths` names.

## Who implements it

- **Skills:** `draft-section` writes the body; `structure-review` checks the parts are present and
  in order; `clause-consistency` checks defined terms, cross-references and precedence.
- **Workflows:** `library/workflows/01-draft-a-section/`, `library/workflows/05-review-a-document/`.

## Governing standard

`standards/method/BUSINESS.md` owns the drafting principles (stated precedence, defined terms
defined once); the disclaimers file owns the disclaimer wording; each family standard owns its
types' parts. This guide owns the order the parts appear in.
