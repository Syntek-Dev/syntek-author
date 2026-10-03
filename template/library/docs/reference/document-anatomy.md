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
2. **The preamble**, taken unchanged from `tooling/latex/skeleton.tex`, which inputs the house
   preamble `tooling/latex/house-preamble.tex`.
3. **The internal note:** a `%` comment block under the preamble recording authorised deviations,
   sources checked with their dates, and anything unresolved. It is never rendered.
4. **The title block:** title, the business's trading name, the date.
5. **The disclaimer,** where the document's class carries one, copied verbatim from
   `standards/brand/disclaimers.md`. Never paraphrased, never improvised; a class with none has
   none.
6. **The Document Control block** on versioned and external documents, ending with the version
   history table (Version · Date · Author · Change description · Approved by).
7. **The reader's map** for a long document: 'How to read this document' (Where · What), then a
   summary holding everything needed to decide, every price included, then the contents.
8. **The body:** the sections, in the brief's order, each between its `% section:` markers.
9. **The closing parts:** the signature block, the schedules, and in an instrument the governing
   law clause, last.

## Required parts by family

| Family | Document Control rows | The body must include |
|---|---|---|
| Proposals | Title, Client, Version, Status, Date, Valid until, Owner | summary; scope with In scope and Out of scope; deliverables; timeline (Milestone · Description · Target date); investment as line items, never one total; terms summary; next steps |
| Contracts | Title, Parties, Version, Status, Effective date, Owner, Next review | parties; background; definitions and interpretation first; numbered clauses (services, duration, fees and payment, confidentiality, intellectual property, liability, termination); precedence where the contract belongs to a family; signature block |
| Policies | Title, Owner, Version, Status, Last reviewed, Next review, Classification | purpose and scope; the rules as must-statements; roles and responsibilities; compliance; review and approval; the review-date notice |
| Correspondence | none | email: H1, To, From, Attachment and Status lines, internal note, rule, Subject, body; letter: heading, date, recipient, subject, body, sign-off |
| Finance | Title, Period, Version, Date produced, Owner (reports) | figures with their basis and period; notes on every estimate; invoices: every field the template carries, none left blank |
| Marketing | Title, Period, Version, Status, Owner, Next review (plans) | audience and purpose; the copy; every claim backed by a number or cut |

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
  voice does not soften it; proposals, letters and marketing copy use
  `standards/brand/brand-voice.md`.

## Who implements it

- **Skills:** `draft-section` writes the body; `structure-review` checks the parts are present and
  in order; `clause-consistency` checks defined terms, cross-references and precedence.
- **Workflows:** `library/workflows/01-draft-a-section/`, `library/workflows/05-review-a-document/`.

## Governing standard

`standards/method/BUSINESS.md` owns the drafting principles (stated precedence, defined terms
defined once); `standards/brand/disclaimers.md` owns the disclaimer wording. This guide owns the
order the parts appear in, and which family needs which.
