# CONTEXT.md — library/src/policies/

The policies family: the rules the business sets for itself and, where it writes them for others,
for its clients. Policies, procedures and public notices live here: information security,
acceptable use, data retention, privacy notices, complaints, and whatever else the business must
be able to show it follows. The business's own suite sits at the family root; suites written for a
client sit in that client's folder. A contract that refers to a policy lives in
`library/src/contracts/`.

## Directory Tree

```text
library/src/policies/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules
├── templates/              ← reusable policy and notice starting points
├── client-docs/            ← one <client-slug>/ folder per client policy suite
└── drafts/                 ← section drafts, one <unit-slug>/ folder per policy (README.md only)
```

## What's here

- **The business's own policies** — `<policy-type>-v<major>-<minor>-<DD-MM-YYYY>.tex` at the
  family root; a suite meant to be read in order may prefix each with a two-digit number.
- **Client policies** — `<policy-type>-<client-slug>-v<major>-<minor>-<DD-MM-YYYY>.tex` in
  `client-docs/<client-slug>/`.
- **Classification.** Every policy states its classification (for example Confidential or Internal)
  in its Document Control block and in its header.
- **Review dates.** Every policy carries a Next review date and the policy class's review notice
  from `standards/brand/disclaimers.md`; its row in `planning/src/review-schedule.md` keeps the
  date honest.
- **Parts.** Purpose and scope, the rules, roles and responsibilities, compliance, review and
  approval, version history: `library/docs/reference/document-anatomy.md`.

## Cross-references

- `planning/workflows/06-run-a-review-cycle/` — the scheduled review of a live policy.
- `planning/workflows/07-record-an-approval/` — a policy becomes Active only once approved.
- `standards/risk/BUSINESS.md` — confidentiality and the risks a policy must not create.
