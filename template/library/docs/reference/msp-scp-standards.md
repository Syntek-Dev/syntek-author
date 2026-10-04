---
type: guide
skills: [msp-scp-documents, draft-section, obligation-check, fact-check]
model: opus
---

# Managed-service standards — the policy suite and the documents a service runs on

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** The standard for every document in `library/src/msp-scp/`: the technology policies
a business keeps when it runs IT for its clients, the suites it writes for those clients, and the
operational documents the service runs on. A policy here is something the business, or its client,
must be able to show it follows. This guide is the index; the suite's order, the required policy
structure and the operational documents' parts are in `MSP-SCP-POLICY-SUITE.md` beside it.

## Document types

| Kind | Examples | Versioned | Where |
|---|---|---|---|
| Policy suite | information security, password and authentication, acceptable use, incident response, data retention and disposal, change management; with the data processing agreement, sub-processor register, service level agreement and privacy notice that complete it | yes, numbered `NN-` in the suite's order | the family root (the business's own); `client-docs/<client-slug>/` (a client's) |
| Operational documents | client runbook, network topology | yes | `client-docs/<client-slug>/` |
| Reports | monthly service report, incident report, change request | no: dated by period or event | `client-docs/<client-slug>/reports/` |
| Template | any of the above, blank | no | `templates/` |

## Document Control and classification

Every versioned document carries a Document Control block with Title, Owner, Version, Status
(Draft · Active · Superseded), Last reviewed, Next review and Classification (for example
Confidential or Internal). The classification also appears in the running header, set with
`\houseclassification{<level>}` after `\begin{document}`. A policy carries the review-date notice,
whose wording lives in the disclaimers file `00-project.md ## Paths` names; no further disclaimer
is needed unless the class carries one.

## Names and review

| Kind | Pattern | Review |
|---|---|---|
| Policy | `<NN>-<policy-type>-v<major>-<minor>-<DD-MM-YYYY>.tex` | on its cycle (`MSP-SCP-POLICY-SUITE.md`), and on any trigger there |
| Runbook, topology | `<doc-type>-<client-slug>-v<major>-<minor>-<DD-MM-YYYY>.tex` | when the client's systems change |
| Report | `<report-type>-<client-slug>-<DD-MM-YYYY>.tex` | none: kept as written |
| Template | `template-<doc-type>.tex` | yearly |

## How we apply it here

- Policies command: 'must' and 'shall', each one auditable. 'Should consider' is cut or made a
  rule, and a rule the business does not follow is raised with the author, never written down.
- A framework is something a policy is 'aligned with', never 'certified to' unless the certificate
  is filed; every control number and statute carries `VERIFY` until `fact-check` has confirmed it.
- No credential, network address or secret is written into a runbook or a topology: they say where
  the secret is kept.
- A policy becomes Active only once its approval is recorded in the Approvals path
  (`00-project.md` `## Paths`; by default `planning/src/approvals/`).

## Who implements it

- **Skills:** `msp-scp-documents` holds the types, the suite and the checks; `draft-section` writes
  each rule area as a section; `obligation-check` reads every must-statement; `fact-check` verifies
  every framework and legal reference.
- **Workflows:** `library/workflows/15-create-an-msp-scp-document/`; a live policy due its review
  goes through `planning/workflows/06-run-a-review-cycle/`.

## Governing standard

`standards/risk/BUSINESS.md` owns confidentiality and the risks a policy must not create;
`standards/verification/BUSINESS.md` owns the gates; `standards/method/BUSINESS.md` the drafting
principles. This guide and its sub-document own the family's types, structure, names and reviews.
