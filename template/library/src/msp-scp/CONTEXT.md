# CONTEXT.md — library/src/msp-scp/

The managed-service family: the technology governance a business writes when it runs IT for its
clients, as a managed service provider or a service and cloud provider. Information security,
password and authentication, acceptable use, incident response, data retention and change
management policies; sub-processor registers and privacy notices; and the operational documents
a managed service runs on (runbooks, service reports, incident reports, change requests, network
topologies) live here. The business's own policy suite sits at the family root; suites written for
a client sit in that client's folder. The client's facts are cited from
`library/src/business/client-docs/<client-slug>/CONTEXT.md`, never copied here.

## Directory Tree

```text
library/src/msp-scp/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules
├── templates/              ← runbook, report and change request starting points
├── client-docs/            ← one <client-slug>/ folder per managed-service client
└── drafts/                 ← section drafts, one <unit-slug>/ folder per document (README.md only)
```

## What's here

- **The business's own policy suite** — `<NN>-<policy-type>-v<major>-<minor>-<DD-MM-YYYY>.tex` at
  the family root, the two-digit prefix keeping the suite in its reading order.
- **Client policies** — the same pattern in `client-docs/<client-slug>/`, numbered as the client's
  own suite.
- **Operational documents** — runbooks and network topologies per client, versioned; service and
  incident reports per period or event, dated and never versioned.
- **Classification and review.** Every policy states its classification in its Document Control
  block and its header, and carries its Next review date and the review-date notice; its row in
  `planning/src/review-schedule.md` keeps the date honest.
- **Types, the suite's order, the required structure and review cycles** are in
  `library/docs/reference/msp-scp-standards.md` and its sub-document.

## Cross-references

- `library/docs/reference/msp-scp-standards.md` — this family's standard.
- `library/workflows/15-create-an-msp-scp-document/` — the procedure that makes a document here.
- `planning/workflows/06-run-a-review-cycle/` — the scheduled review of a live policy.
- `planning/workflows/07-record-an-approval/` — a policy becomes Active only once approved.
- `standards/risk/BUSINESS.md` — confidentiality and the risks a policy must not create.
