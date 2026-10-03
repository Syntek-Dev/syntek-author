# CONTEXT.md — library/src/proposals/

The proposals family: what the business offers to do, for whom, by when and for how much.
Proposals, quotes and tender responses live here, written to persuade a reader who must decide
and then hold the business to every word. The contract that follows a proposal lives in
`library/src/contracts/`; the email that sends it lives in `library/src/correspondence/`.

## Directory Tree

```text
library/src/proposals/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules
├── templates/              ← reusable proposal and quote starting points
├── client-docs/            ← one <client-slug>/ folder per client
└── drafts/                 ← section drafts, one <unit-slug>/ folder per proposal (README.md only)
```

## What's here

- **Proposals** — `proposal-<client-slug>-v<major>-<minor>-<DD-MM-YYYY>.tex`, with a subject after
  the client slug when a client has more than one, in `client-docs/<client-slug>/`.
- **Quotes** — `quote-<client-slug>-v<major>-<minor>-<DD-MM-YYYY>.tex`: a priced scope without the
  persuasion, for work already agreed in principle.
- **Tender responses** —
  `tender-response-<client-slug>-<subject>-v<major>-<minor>-<DD-MM-YYYY>.tex`, answering the
  buyer's questions in the buyer's order.
- **Status as the reader sees it.** The Document Control block prints Draft, Submitted, Accepted
  or Superseded, matching the register row once there is one.
- **Parts.** Summary, scope (In scope and Out of scope), deliverables, timeline, investment as line
  items, terms summary, next steps: `library/docs/reference/document-anatomy.md`. A long proposal
  opens with 'How to read this proposal' and a summary that holds every price.

## Cross-references

- `library/docs/reference/document-anatomy.md` — the required parts, in order.
- `library/src/contracts/` — where the instrument a proposal leads to is written; its terms win.
- `standards/brand/brand-voice.md` — the voice proposals are written in.
- `planning/src/precedence.md` — the order of governance between a proposal and its contract.
