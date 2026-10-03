# CONTEXT.md — planning/src/approvals/

One approval record per approval event: an instrument signed by all parties, a policy approved
as `Active`, or a notice issued. Each record names what was approved, which version, by whom,
when, how and within what scope. The record is evidence that the event happened; the register
row it updates is the summary.

## Directory Tree

```text
planning/src/approvals/
├── CONTEXT.md                               ← this file
├── CLAUDE.md                                ← operating rules
└── approval-<doc-type>-DD-MM-YYYY.md        ← one record per approval event
```

## What's here

- `approval-<doc-type>-DD-MM-YYYY.md` — a record headed
  `# Approval Record — <Document Name or Group>` and `Date: DD/MM/YYYY`, then a
  `Field | Detail` table: Document Name · Document ID · Document Version · Approving
  Professional · Date of Approval · Scope of Approval · Method of Approval · Notes. A batch
  record (several documents, one approver, one occasion) adds a `## Documents Approved` table:
  Document ID · Document Name · Type · Version.
- **No records are made for** templates, drafts, proposals, invoices or reports.

## Cross-references

- `planning/docs/reference/the-document-register.md` — when a record is made, and what follows.
- `planning/workflows/07-record-an-approval/` — the procedure.
- `planning/src/document-register.md` — the row each record updates.
