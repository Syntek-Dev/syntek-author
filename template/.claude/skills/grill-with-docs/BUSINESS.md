# BUSINESS.md — grill-with-docs, business mode

Where a document library's decisions are recorded: the brief, the register, the client's facts,
the document's own internal note and the house standards.

## Paths and unit

- **Brief:** `planning/src/units/<document-slug>.md`; its settled-positions slot is
  `## Obligations and defined terms`.
- **Register and schedule:** `planning/src/document-register.md` (one `DOC-NNN` per document for
  life) and `planning/src/review-schedule.md`.
- **Client facts:** `library/src/contracts/client-docs/<client-slug>/CONTEXT.md` under `## Facts`,
  the one home every other family cites.
- **Precedence and approvals:** `planning/src/precedence.md`; approval records in
  `planning/src/approvals/`, made through `planning/workflows/07-record-an-approval/`.
- **House standards:** `standards/method/BUSINESS.md` and `standards/brand/`.

## Additions to the steps

- **Step 1 — also read the register row, the previous version and the client's facts** before the
  first round, so a document's status and the counterparty's details open as `Settled` lines.
- **Step 3 — also record the library's rows:**

| When a decision… | Record it in |
|---|---|
| settles an obligation, a defined term or a price the document commits to | the brief's `## Obligations and defined terms` |
| fixes a client fact a later document will need | the client's `CONTEXT.md` `## Facts`, once, cited elsewhere |
| versions, supersedes or moves a registered document | its row in `planning/src/document-register.md`, through `planning/workflows/08-update-the-register/` |
| sets a review date, renewal or sign-off | `planning/src/review-schedule.md` |
| fixes which document governs when two conflict | `planning/src/precedence.md` |
| records who approved what, and when | an approval record in `planning/src/approvals/` |
| is a drafting decision or an authorised deviation confined to one document | the document's internal note: a `%` comment block in a `.tex`, `<!-- INTERNAL NOTE: … -->` in Markdown |
| changes the house voice or a disclaimer | `standards/brand/`, **author-confirmed first** |

A new document is registered at the end of its line edit
(`library/workflows/05-review-a-document/`), never when it is created.

- **Step 4 — also apply the gate to client matters with care.** A client fact usually fails the
  `Decisions` gate (it is a fact, not a trade-off) and belongs in the client's `CONTEXT.md`; a
  house rule the author rules on (no em dashes in client copy, the voice person) passes it.

## Domain rules

- **Record a declined change where the next session will meet it.** When the author turns a
  proposal down, put the reason in the brief's `## Draft notes`, or in the folder's `CLAUDE.md` on
  the author's explicit word, so it is not proposed again next month.
- **The internal note names the rule, the reason and the date.** That is what stops a later pass
  'correcting' an authorised deviation back to the house rule.
- **Never write a figure the author has not confirmed.** A price, rate or date that is still
  open stays `[AWAITING USER INPUT]` in the document and `AUTHOR TO CONFIRM` in the brief.
- **Anything that changes a price, a term, a scope boundary, an entity detail or what a document
  may mention** is grilled and recorded before drafting: those decisions are the expensive ones
  to reverse once a document has been sent.

## Examples

```markdown
## Obligations and defined terms

1. **Support Hours** — defined once in the schedule's definitions clause; bolded once.
2. The provider shall respond to a priority one incident within the response time in the
   schedule's table; the figure is AUTHOR TO CONFIRM until the author sets it.
```

An internal note at the head of a `.tex` deliverable:

```text
% INTERNAL NOTE 03/10/2026: the proposal disclaimer is omitted on the author's instruction;
% the master agreement it sits under carries it. Do not restore it.
```
