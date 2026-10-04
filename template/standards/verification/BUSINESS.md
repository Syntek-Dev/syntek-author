# BUSINESS.md — business sub-gates

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The gates a business document must pass in addition to `verification.md`, numbered under the gate
they belong to. V5 (`fact-check → line-edit`) passes only when V5.1 and V5.2 also pass; V6
(`line-edit → final`) only when V6.1 and V6.2 also pass. Each sub-gate checks a rule of
`standards/method/BUSINESS.md` or `standards/risk/BUSINESS.md`, cited by number. After `final`,
the document's register status (in `planning/src/document-register.md`) is a separate, later
lifecycle: issued, executed, superseded.

The gates are the same in every document family the project ships. At V5, `fact-check` checks
every party detail (legal name, company or charity number, registered address) against the
client's facts, read from the file `00-project.md` `## Paths` names ('Client facts'; by default
`## Facts` in `library/src/business/client-docs/<client-slug>/CONTEXT.md`).

Dates DD/MM/YYYY.

---

## 1. The sub-gates

**Requirement.**

| Gate | Within | Passes when | Run by |
|---|---|---|---|
| **V5.1** | V5 | Every defined term is defined once, bolded once and used in that form throughout; every cross-reference resolves; no near-synonym stands in for a defined term; terms agree across related documents, whichever family holds them; precedence is stated (method rules 3 and 4). | `clause-consistency` |
| **V5.2** | V5 | 'Shall', 'may' and 'must' are each intentional; every commitment traces to an instrument clause or is flagged as new; no 'will' is unbounded; every price, date and service level is verified (method rule 7, risk rule 5). | `obligation-check` |
| **V6.1** | V6 | The house voice and plain English hold in running copy, legal text stays formal, and no figure, date, scope or commitment changed in the tone pass (method rules 1, 5 and 10; `standards/brand/brand-voice.md`, or the brand folder `00-project.md` `## Paths` names). | `tone` |
| **V6.2** | V6 | Issue readiness: the disclaimer for the document's class is present, or a recorded waiver (risk rule 4); the document-control block is complete; no drafting note (`\dnote`), `[AWAITING USER INPUT]` field or bracketed placeholder remains; `make lint` reports no em dash in client-facing copy; the document has a row in the register. | `library/workflows/05-review-a-document/` |

**Why this rule exists.** An instrument can read well and still bind its author to something they
never meant; the obligation gates come before the polish because fixing them changes clauses.

---

## 2. A LaTeX document records its gates in its brief

**Requirement.** A `.tex` document carries its writing status in a leading comment block
(`% unit: <unit-slug>`, then `% status: line-edit` and `% last_updated: DD/MM/YYYY`); its
`verified:` map lives in its unit brief in `planning/src/units/`, exactly as for any other unit.

**Why this rule exists.** LaTeX has no frontmatter, and a second place to record gates would
drift from the first.

---

## 3. Issue is not final

**Requirement.** Passing V6 makes the document `final`; sending it is a separate act on the
author's word, recorded in the register with its date and version. A change after issue is a new
version (method rule 8), which starts its own climb from `draft`.

**Why this rule exists.** The version the client received is the version that binds, so the
register must say which one that was.
