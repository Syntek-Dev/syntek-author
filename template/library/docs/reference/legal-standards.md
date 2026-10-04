---
type: guide
skills: [legal-documents, draft-section, clause-consistency, obligation-check]
model: opus
---

# Legal standards — the instruments, their clauses and their names

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** The standard for every document in `library/src/legal/`: the instruments that bind
the business and its counterparties, and the letters served under them. Every one is a starting
point for professional review, never legal advice, and says so. This guide names the types, the
parts each must carry, the clause conventions, the names and the review cycles.

## Document types and their parts

| Type | Versioned | Must include, after the disclaimer and Document Control |
|---|---|---|
| Agreement (master services, service, licence) | yes | parties; numbered recitals; definitions and interpretation; clauses for services, duration, fees and payment, confidentiality, intellectual property, data protection, limitation of liability, termination, precedence, governing law; signature block; schedules |
| Non-disclosure agreement | yes | parties (one-way or mutual, stated in the title); definitions (Confidential Information, Disclosing Party, Receiving Party); obligations; exclusions; duration; return or destruction; governing law; signature block |
| Data processing agreement | yes | subject matter, duration, nature and purpose; the personal data and data subjects; each party's obligations; sub-processors; transfers; security measures (a schedule); breach notification; return or deletion; audit; every legal reference `VERIFY` until checked |
| Service level agreement | yes | the agreement it serves; services in scope; hours; severity levels; response and resolution targets; service credits; exclusions; reporting (where the project has the msp-scp family, an SLA follows that family's sections) |
| Terms, privacy notice (the business's own) | yes | as the type requires; the business's own instruments sit at the family root |
| Amendment or variation | yes | the parent by title, version and date; each changed clause in full; a statement that the rest is unchanged; signature block |
| Letter under an instrument (notice, payment plan) | no | heading, date and recipient; subject in bold; the instrument and the clause relied on; the reasons; the effect; a payment plan's invoices by number, schedule (Instalment · Amount · Due date) and consequence of default; sign-off |

**Document Control** (formal instruments, not letters): Title, Parties, Version, Status (Draft ·
Active · Executed · Superseded · Terminated), Effective date, Owner, Next review.

## Clause conventions

- Clauses are numbered 1, 1.1, 1.1.1 with the house `clause` list, and cited as
  `clause~\ref{cl:<slug>}`, never by a typed number.
- A defined term is bold and in quotation marks where it is defined, capitalised every time after,
  and defined once; definitions come first.
- 'Shall' for an obligation, 'may' for a permission, 'must' for an absolute requirement.
- Governing law names the jurisdiction in `00-project.md ## Brief`, unless the author decides
  otherwise for one instrument and records why in its internal note.

## Names and review

| Type | Pattern | Review |
|---|---|---|
| Client instrument | `<doc-type>-<client-slug>-v<major>-<minor>-<DD-MM-YYYY>.tex` | per engagement; on a change in the law |
| Negotiation copy | `<doc-type>-<client-slug>-redline-v<major>-<minor>-<DD-MM-YYYY>.tex` | none |
| Signed copy | the issued basename with `-signed` before `.pdf` | none: kept as the record |
| Letter | `<letter-type>-<client-slug>-<DD-MM-YYYY>.tex` | none |
| Own instrument | `<doc-type>-v<major>-<minor>-<DD-MM-YYYY>.tex` | yearly |
| Template | `template-<doc-type>.tex` | yearly, or on a change in the law |

## How we apply it here

- The counterparty is verified against the public register for the jurisdiction, never its own
  website, and recorded in the client's `## Facts` with the date checked.
- The disclaimer for legal instruments sits at the top of every instrument and letter, copied
  unchanged from the disclaimers file `00-project.md ## Paths` names.
- When a standard and the delivered documents disagree, find which one is the outlier before
  'fixing' anything: a rule nobody has followed is a defect in the rule, and issued documents are
  never re-rendered to match a new one.

## Who implements it

- **Skills:** `legal-documents` holds the types and checks; `clause-consistency` and
  `obligation-check` run at fact check; `draft-section` writes clause groups as sections.
- **Workflows:** `library/workflows/11-create-a-legal-document/`, and the loop it drives.

## Governing standard

`standards/method/BUSINESS.md` (stated precedence, defined terms defined once) and
`standards/risk/BUSINESS.md` own the rules; `standards/verification/BUSINESS.md` owns the gates.
This guide owns the legal family's types, required parts, clause conventions, names and reviews.
