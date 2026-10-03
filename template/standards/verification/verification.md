# verification.md — the gates a unit passes as its status moves

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The governing standard for the unit status ladder:
`idea · outlined · draft · structural-review · fact-check · line-edit · final` (`stub` is
accepted as an alias of `outlined` and rewritten on first touch). Every rung but one is reached
by passing numbered gates, each run by the skill named with it: V1 gates `idea → outlined`;
`outlined → draft` has no gate of its own; V2 and V3 together gate `draft → structural-review`;
V4, V5 and V6 gate the three review transitions. `promote-section` holds every section it
promotes to V2's terms; the review workflow (05) in the content layer confirms V2 and V3 as it
opens, then runs V4 to V6 in order. The mode file beside this one (exactly one of `THEOLOGY.md`,
`FICTION.md` or `BUSINESS.md` ships here) adds sub-gates numbered under V4, V5 or V6.

Dates DD/MM/YYYY.

---

## 1. The gates

**Requirement.** A unit's `status:` moves up one rung only when every gate for that transition
passes, together with every sub-gate the mode file adds to it.

| Gate | Transition | Passes when | Run by |
|---|---|---|---|
| **V1** | `idea → outlined` | The unit brief in `planning/src/units/` has its scope, what the unit does, a purpose for every section in `sections:`, and the mode's settled-positions slot filled; the author has agreed the brief. | `grill-with-docs`, through `planning/workflows/01-plan-a-unit/` (step 8) |
| — | `outlined → draft` | No gate of its own: V1 still holds. The move happens when the first section of the unit is drafted, by the AI or by the author. | `draft-section` (or the author's own first draft) |
| **V2** | `draft → structural-review` (with V3) | Every planned section in the brief's `sections:` list is `promoted`, each on the author's explicit word, with zero flags in the section and a complete ledger entry; the unit file holds every section at its marker, in plan order. | `promote-section` |
| **V3** | `draft → structural-review` (with V2) | A proof of the whole unit builds and has been read. | `build` |
| **V4** | `structural-review → fact-check` | A structural review of the whole unit is written to `planning/src/reviews/` as advice, and the author has answered every finding (accepted, declined or deferred, each dated). | `structure-review` |
| **V5** | `fact-check → line-edit` | Every checkable claim in the unit has a verdict recorded in `research/src/evidence/` (`standards/method/method.md` rule 7); no `VERIFY` flag remains; anything `cannot-be-dated` or `unsupported` has been cut or rewritten; where references are on, every citation key resolves in a proof. | `fact-check` |
| **V6** | `line-edit → final` | The `comprehension`, `flow`, `grammar` and `spelling` reports have been run and every item resolved by the author; `make flags SCOPE=<the unit>` lists nothing; `make lint` has been read; the author has given their explicit word that the unit is final. | the review workflow (05), and the author |

**Why this rule exists.** A ladder with named gates tells everyone (the author, every skill, a
later session) exactly what 'draft' or 'final' means for this unit, and makes 'nearly done' a
checkable statement rather than a feeling.

---

## 2. Final means the author's word and zero flags

**Requirement.** No unit becomes `final` with any `AUTHOR TO CONFIRM` or `VERIFY` flag anywhere
in it, and no skill sets `final`: the author's explicit word does, recorded with its date in
`.claude/MEMORY.md` `## Status`. `promote-section` moves sections into a unit; it never
finalises the unit.

**Why this rule exists.** Every flag is a decision or a check that has not happened. A unit
called final with one still in it publishes a guess, and only the author can decide that the
work is theirs to release.

---

## 3. A gate is recorded, and reopened by change

**Requirement.** When a gate passes, its date is recorded under its number in the unit brief's
frontmatter, for example `verified: {V1: 03/10/2026, V2: 20/10/2026, V4.1: 24/10/2026}`. A
material change to the unit's text after a gate passed (a section rewritten, a claim added, an
argument restructured) clears that gate's date and every later one, and the status steps back to
the rung the earliest cleared gate leads from: `draft` when V2 or V3 is cleared, `structural-review`
when V4 is, and so on. A correction of spelling or punctuation reopens only V6. Any other agreed
wording change (one that neither rewrites a section, adds a claim nor restructures the argument)
clears no date: the section is reopened and promoted again, and the stages the unit has already
passed are run again over that section before the unit moves on.

**Why this rule exists.** A gate that stays passed after the text it checked has changed is a
record of a different unit. Reopening is cheaper than finding out at proof stage.

---

## 4. Sections and units are checked at different times

**Requirement.** Each section is checked as it is promoted, against V2's terms (the author's word,
zero flags, a complete ledger entry); V2 itself passes when the last planned section is promoted.
The unit is checked as a whole at V3 to V6, because structure, consistency, claims across sections
and voice across sections can only be judged on the assembled unit.

**Why this rule exists.** Sections drafted out of order each pass their own checks and still
contradict one another; only a whole-unit gate sees the seam.

---

## 5. Proofs are ungated; release is not

**Requirement.** `make pdf`, `make docx` and the other proof targets run at any status and never
change it. Sending a unit beyond the author (to an editor, a publisher, a client, a shared
drive) requires it to be `final`, or the author's explicit, recorded decision to send a proof
marked as such.

**Why this rule exists.** The author needs to read a proof at every stage; an outside reader
needs to know which version they are reading.
