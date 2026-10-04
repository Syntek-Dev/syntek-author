---
name: obligation-check
description: >-
  Check every obligation a business document creates or describes: 'shall', 'may' and 'must' each
  chosen deliberately; every commitment traced to an instrument clause or the author's recorded
  instruction, or flagged as new; no unbounded 'will'; no 'should' left in a policy rule; no
  certification, guarantee or compliance claim beyond its evidence; every price, date and service
  level flagged VERIFY until it is traced to its source. Gate V5.2 at fact check. Use when the
  author says 'check the obligations', 'what am I committing to here?', 'is this promise in the
  contract?', 'are the shalls and mays right?' or 'check this email against the agreement before
  it goes'. Never adds, removes, strengthens or softens a commitment. Not defined terms or
  cross-references (`clause-consistency`); not voice (`tone`); not verifying a figure, entity or
  statute against its source (`fact-check`).
---

# Skill: Obligation check (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

A client reads every sentence as a promise. This skill finds each one a document makes or
describes, says who is bound to what, by when and under what limit, and traces it to the clause or
instruction it comes from. Anything it cannot trace is flagged for the author as new; anything it
cannot bound is reported as open-ended. It **never changes a commitment**: a tidied obligation is a
changed contract, and the author is bound by it whether or not they noticed the change.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`.
These are the procedure of record — do not restate them at length here.

- `library/workflows/05-review-a-document/` — step 7, where this skill is gate V5.2
  (`standards/verification/BUSINESS.md`).
- `standards/method/BUSINESS.md` — rules 2 (shorten the writing, never the obligation) and 7
  (every figure, date and commitment traceable; the modal verbs) are the rules this skill enforces.
- `standards/risk/BUSINESS.md` — rule 5: regulated and professional claims are earned.
- `.claude/rules/syntek-author/03-authorship.md` — Section 7: obligations are never invented.
- `library/docs/reference/document-anatomy.md` — required parts by family, scope with In scope and
  Out of scope, families of documents; the document's family skill, `<family>-documents`, adds
  its family's own checks.

## How to check the obligations

1. **Fix the scope and the sources of truth.** Agree with <%AUTHOR_FIRST_NAME%> which document, and
   read its unit brief in `planning/src/units/`, above all the commitments table in
   `## Obligations and defined terms`. Read the instruments this document relies on (from
   `planning/src/precedence.md` and the brief), the client's facts at the client facts path in
   `00-project.md` `## Paths` (by default
   `library/src/business/client-docs/<client-slug>/CONTEXT.md`), any quotation or schedule the
   figures come from, and the `Decisions` heading of `.claude/MEMORY.md` (mapped in `00-project.md`
   `## Memory headings`) for instructions the author has given. *Complete when:* the document and
   every source a commitment could trace to are named and read.

2. **Extract every obligation.** List each sentence that binds anyone: the modal verbs ('shall',
   'may', 'must', 'will', 'should'), the commitment words ('agree', 'undertake', 'ensure',
   'guarantee', 'warrant', 'include', 'deliver'), the imperative rules of a policy, and the
   implicit promises ('delivery within ten working days', 'unlimited revisions'). For each: who is
   bound, to what, by when, on what condition. *Complete when:* every obligation is a row with its
   location and its four parts, blanks shown as blanks.

3. **Check each modal verb.** 'Shall' imposes an obligation, 'may' grants a discretion, 'must'
   states a condition or an absolute requirement; each is chosen on purpose. Flag a modal that says
   the wrong thing, two modals for the same duty, a policy rule written as 'should', and a
   permission written as a duty. *Complete when:* every modal in the table is marked intended or
   carries a finding with the reading a counterparty could take.

4. **Bound every 'will'.** A promise in the future tense needs an object, a limit (a time, a
   quantity, a scope, a condition) and an owner. 'Will support you' and 'will respond promptly'
   are unbounded; 'will reply within two working days of receiving each draft' is not.
   *Complete when:* every 'will' that promises is marked bounded, or listed with the missing limit.

5. **Trace every commitment.** Match each row to an instrument clause (by its label), to a row of
   the brief's commitments table, or to the author's recorded instruction. A letter, email or
   proposal describing a contract term must match the instrument's substance. A commitment that
   traces to nothing is **new**: place `<!-- AUTHOR TO CONFIRM: new commitment, … -->` beside it
   (in a `.tex`, `\dnote{AUTHOR TO CONFIRM: …}`), and never alter the sentence itself.
   *Complete when:* every row is traced, mismatched (both wordings quoted) or flagged new.

6. **Flag every price, date and service level.** Each is traced to its source document and matches
   it exactly, currency and format included (`standards/style/style-sheet.md`); one that is not yet
   traced carries `VERIFY` until `fact-check` closes it. A date offered as an estimate is not
   written as a deadline; a service level is measurable. *Complete when:* every figure, date and
   service level is traced or flagged.

7. **Check the claims that must be earned.** A certification, accreditation, guarantee, or
   compliance with a standard or a law appears only with dated evidence ('aligned with' or
   'informed by', never 'certified to', until the certificate exists). Legal, financial and tax
   statements are information, not advice, unless the author has said they are qualified to give
   it. A proposal states In scope and Out of scope explicitly. *Complete when:* every such claim
   is marked evidenced or flagged, and the scope boundary is confirmed present or missing.

8. **Report and hand back.** Deliver the report below; the only edits made are the flags from
   steps 5 and 6, each listed. The author decides every change to wording, and a changed
   commitment reopens its section through the library's adapt or improve workflow. Run as gate
   V5.2, hand the verdict to the review workflow, which dates the gate in the brief's `verified:`
   map once every blocking finding is resolved. *Complete when:* the report is delivered, every
   flag placed is listed, and, for a gate run, the review workflow has the verdict.

## The report

First, **the obligation table**: `# · Location · Words · Bound party · To what · By when · Traced to
· Finding`. Then the **findings, blocking first**. A finding is blocking when a commitment is new,
mismatched with its instrument, unbounded, or a figure, date or service level is untraced. For each
finding: the location, the words quoted, why a counterparty could rely on it, and the options for
the author (confirm it as new, bound it, trace it, or cut it), never a reworded clause.

Close with a verdict: **V5.2 pass or fail**, and the count of commitments, new commitments and open
`VERIFY` flags.

## Anti-patterns

- **Tidying an obligation.** Shortening, softening, strengthening or 'clarifying' a commitment is
  the author's decision; a tone or concision pass that touches one has changed the contract.
- **Filling a gap with a guess.** A missing price, date or limit stays `[AWAITING USER INPUT]` or
  flagged; it is never supplied.
- **Treating the brief as the instrument.** The brief records what was planned; what binds is the
  instrument the client signed.
- **Citing a statute or section from memory.** A legal claim waits for `fact-check`, with its
  jurisdiction and date.
- **Deleting a flag to pass the gate.** A flag leaves only with its answer.
- **Changing a sent document.** A delivered document is a historical record; a change is a new
  version (`standards/method/BUSINESS.md` rule 8).

## Cross-references

- `standards/method/BUSINESS.md` — rules 2, 7 and 8; `standards/risk/BUSINESS.md` — rule 5.
- `standards/verification/BUSINESS.md` — gate V5.2, beside V5.1.
- `planning/src/precedence.md` — which instrument prevails when two disagree.
- `planning/src/document-register.md` — the issued versions a commitment may have been made in.
- `.claude/skills/clause-consistency/SKILL.md` — the defined terms the obligations use (V5.1).
- `.claude/skills/fact-check/SKILL.md` — closes the `VERIFY` flags on figures, dates, entities and
  statutes.
- `.claude/skills/tone/SKILL.md` — the line-edit pass that must leave every obligation untouched.
