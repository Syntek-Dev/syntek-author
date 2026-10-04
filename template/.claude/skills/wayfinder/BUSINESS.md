# BUSINESS.md — wayfinder, business mode

What a document library charts with a map, the order in which document decisions block, and
where settled nodes go.

## Paths and unit

- **Map files:** in the decision maps folder `00-project.md` `## Paths` names (by default
  `planning/src/maps/MAP-<TOPIC>.md`), for example `MAP-EXAMPLE-CLIENT-ONBOARDING.md` or
  `MAP-POLICY-REFRESH.md`.
- **Reads (step 5):** every relevant folder `CONTEXT.md` in `library/src/`, the client's facts at
  the client facts path in `00-project.md` `## Paths` (by default
  `library/src/business/client-docs/<client-slug>/CONTEXT.md`), `planning/src/document-register.md`,
  `planning/src/review-schedule.md`, `planning/src/precedence.md`, and the house standards.
- **Procedures that chart with a map:** `planning/workflows/06-run-a-review-cycle/` when a review
  covers a whole document family.

## Additions to the steps

- **Step 1 — also** read the register for documents past their review date and the review
  schedule for obligations falling due; each is unfinished business.
- **Step 6 — also wire the blocking order documents always follow:** the entity is verified
  before an instrument names it; the master agreement before the schedules under it; the price
  before the proposal; the proposal before the statement of work; who signs before what they sign.
- **Step 11 — also** treat a task node resting on someone else (a signature, a client's
  confirmation, a figure from the author) as staying on the frontier until it is done, and flag
  it in the folder's `CONTEXT.md` if it blocks sending.

## Domain rules

| A settled decision that is… | Graduates to… |
|---|---|
| a producible document | its brief in `planning/src/units/`, then the document, and its row in `planning/src/document-register.md` |
| a client fact | the client's `## Facts`, at the client facts path |
| a dated obligation: a review, a renewal, a sign-off | `planning/src/review-schedule.md` |
| which document governs when two conflict | `planning/src/precedence.md` |
| an approval | a record in the Approvals path (`00-project.md` `## Paths`; by default `planning/src/approvals/`) |
| a drafting decision confined to one document | that document's internal note |

- **There is no separate blockers file.** A blocker lives on the map as a task node and, where it
  stops something being sent or signed, in the relevant folder's `CONTEXT.md`.
- **Variant anti-pattern:** drafting a document whose blockers are open. Naming an unverified
  entity on an instrument, or quoting a price the author has not confirmed, is exactly the cost
  the map exists to avoid.

## Examples

```text
# MAP-EXAMPLE-CLIENT-ONBOARDING — one entity, three sites, one master agreement

## Frontier
1. [research] Example Client Ltd: exact legal name and number on the official register (blocks 2)
2. [grilling] One master agreement with a schedule per site, or one agreement per site (blocked by 1)
3. [grilling] Support: inside the retainer or a priced schedule (blocked by 2)
4. [task] The author's day rate for the new schedule
5. [grilling] Which document governs a conflict between a site schedule and the master (blocked by 2)
```
