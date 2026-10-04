---
name: business-documents
description: >-
  Create a business document, or check that one has everything its type requires: a proposal, a
  statement of work, a business plan, an onboarding pack or welcome letter, a client guide or
  implementation plan, an intake questionnaire, meeting notes, or a company document (letterhead,
  agenda, minutes, HR or staff policy, staff notice). Holds each type's required sections,
  conventions and pre-issue checklist, and routes to the create workflow and the business
  standard; a new client's folder and facts start here. Use when the author says 'write a proposal
  for…', 'put together a statement of work', 'we need an onboarding pack', 'update the business
  plan' or 'what must a proposal include?'. Not one section (`draft-section`); not a contract, NDA
  or terms (the legal family's skill, where the project has it; otherwise raise it with the
  author); not an IT or security policy (the msp-scp family's skill, where the project has it);
  not what a promise commits to (`obligation-check`); not a voice pass (`tone`).
---

# Skill: Business documents (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

The business family is the one every business project has: the documents that win, scope and run
an engagement, and the business's own working documents. This skill owns the family's domain:
which document types exist, what each must contain, and the conventions that make them specific
and checkable. The procedure of record is the create workflow; prose is written section by section
through the authoring loop. Whenever another skill works on a document in `library/src/business/`,
the conventions and checklist here bind it too.

## Governing procedures (route here — do not restate at length)

- `library/workflows/10-create-a-business-document/` — the procedure of record for a new business
  document; this skill is its domain in skill form. Run its `STEPS.md` with `CHECKLIST.md` open.
  Where this file and the procedure disagree, the procedure wins and the disagreement is reported to
  the author. An alias in `00-project.md` `## Workflow aliases`, then a same-named folder in
  `library/workflows/local/`, replaces it (`run-workflow`).
- `library/docs/reference/business-standards.md` — the family standard: naming, document control
  rows, review cycle and status values. Route there; do not restate it.
- `.claude/rules/syntek-author/00-project.md` — `## Brief` (trading name, jurisdiction, currency,
  voice, audience, reader test) and `## Paths` (brand folder, disclaimers, client facts,
  LaTeX skeleton). It outranks every other rules file; take those values from it.
- `.claude/rules/syntek-author/03-authorship.md` Sections 4 and 7 (never fabricate; obligations
  are never invented), `standards/method/BUSINESS.md` (above all rules 1, 2, 5, 6 and 10) and
  `standards/risk/BUSINESS.md`.
- `library/docs/reference/document-anatomy.md`, `library/docs/reference/latex-deliverables.md`
  and `library/docs/reference/versioning-and-the-register.md` — the parts in order, the house
  macros and section markers, versioned filenames.

## Document types and required sections

Each list is the body's required sections, in order, after the title block, any disclaimer and
the Document Control block. A section one document does not need is agreed with the author and
recorded in its brief, never dropped silently.

### Proposal

1. Summary: the reader's problem, the proposed answer, its value and its price (one page at most)
2. Understanding of the requirement, in the client's terms
3. Proposed approach: method or phases
4. Deliverables, each specific and measurable
5. Timeline (Milestone · Description · Target date)
6. Scope: In scope and Out of scope, stated explicitly
7. Investment as line items (Item · Description · Price), never one total
8. Payment schedule and milestones
9. Terms summary: validity of the proposal, change requests, the full terms it relies on
10. About us: relevant experience and the people doing the work
11. Next steps, how to accept, and contacts

### Statement of work

1. The agreement it sits under (title, date, version) and the precedence between them
2. Background and objectives
3. Scope: In scope and Out of scope
4. Deliverables, each with its acceptance criteria
5. Milestones and timeline
6. Roles and responsibilities on both sides, by role
7. Assumptions and dependencies
8. Acceptance process
9. Fees and payment schedule (by reference to the quotation or order that sets them)
10. Change control
11. Signatures

### Business plan

1. Summary (written last; it carries the whole plan)
2. The business: trading name, legal structure, purpose, values
3. Products and services, and what sets them apart
4. Market: target customers, trends, competitors (at least three, each named by the author)
5. Marketing and sales: positioning, channels, acquisition, retention
6. Operations: key processes, suppliers, technology
7. People: roles, gaps and the plan to fill them
8. Financial plan: assumptions, revenue, costs, cash flow, break-even, funding needed
9. Risks: the five largest, each with likelihood, impact and mitigation
10. Goals and milestones; appendices

### Onboarding pack or welcome letter

1. Welcome, and the engagement in one paragraph
2. What was agreed: a summary of the statement of work, never new terms
3. Key contacts on both sides, by role
4. How we will work: communication, meetings, response times as the agreement states them
5. The first steps, as a checklist with owners and dates
6. Questions clients usually ask, answered

A welcome letter is the first, fourth and fifth of these, as a letter.

### Client guide or implementation plan

1. What the guide is for, and who it is for
2. Before you start: what the reader needs to hand
3. The steps, numbered, one action each (an implementation plan adds owners and dates)
4. When something goes wrong: the likely problems and what to do
5. Support: how to get help, and the hours or service levels the agreement states
6. Version and review date

A guide never holds a credential: it says where each one is kept.

### Intake questionnaire

1. Purpose: what the answers are for, and how they will be used and kept
2. The questions, grouped by topic, each answerable on its own
3. What to attach
4. How and by when to return it

### Meeting notes

1. Details: date, time, location or platform, subject, attendees by name and role
2. The agenda, numbered
3. Notes and decisions under each item
4. Actions (Action · Owner · Due date)

### Company documents

A letterhead, agenda, minutes, staff notice or internal policy is filled from its template in
`library/src/business/templates/`. An internal policy carries purpose and scope, the rules as
must-statements, roles and responsibilities, compliance, review and approval, and its review date.

An HR or staff-conduct policy is always this family's. An IT or information-security policy, a
client's or the business's own, belongs to the msp-scp family's skill where the project has that
family; otherwise it is written here, as an internal policy.

## House conventions

- **Format.** A business document is a LaTeX deliverable started from the skeleton `00-project.md`
  `## Paths` names (by default `tooling/latex/skeleton.tex`), or from a template in
  `library/src/business/templates/`. Tables are `tabularx`; lists `itemize` or `enumerate`;
  emphasis `\textbf{…}` and `\emph{…}`; LaTeX specials escaped in prose.
- **Where it lives.** A client's documents in `library/src/business/client-docs/<client-slug>/`;
  the business's own (the business plan, its company documents) at the family root; reusable
  starting points in `templates/`.
- **A new client.** Their folder is made here first, with its folder pair, and their facts (legal
  entity, registered number, address for notices, contacts by role) are written once in the facts
  file `00-project.md` `## Paths` names (by default this family's
  `client-docs/<client-slug>/CONTEXT.md`, under `## Facts`). Every other family cites that file.
- **Specific, not superlative.** Every claim of quality carries the fact behind it, or goes.
  Competitors, case studies and figures come from the author; an unknown is `[AWAITING USER
  INPUT]`, never invented.
- **Prices and scope.** Every price is a line item, in the house currency and format
  (`00-project.md` `## Brief`, `standards/style/style-sheet.md`), taken from the author's quotation
  and flagged `VERIFY` until traced; the summary carries every price; In scope and Out of scope are
  stated, never implied.
- **Financial projections.** State the assumptions under every projection (growth, price, volume,
  headcount); label the scenario (pessimistic, base or optimistic) and show all three when the
  reader is an investor or lender; years read 'Year 1', 'Year 2' unless the author gives dates.
  A document carrying projections takes the financial class's disclaimer.
- **Voice.** Running copy (proposals, letters, guides, onboarding) follows the brand voice file in
  the brand folder `00-project.md` `## Paths` names, in the voice `00-project.md` `## Brief`
  records; a letterhead follows the brand guide there. Never invent a brand value.
- **Disclaimer.** The wording for the document's class, copied unchanged from the disclaimers file
  `00-project.md` `## Paths` names; while the class has no wording, `\dnote{AUTHOR TO CONFIRM: …}`
  holds the slot; a waiver is the author's, recorded in the internal note.

## How to create a business document

1. **Fix the type and its home.** Agree with <%AUTHOR_FIRST_NAME%> the type from the lists above,
   who it is for, and whether it is new, a new version of an issued document, or a template
   adapted for one client. Check `planning/src/document-register.md` for an existing one. Name the
   file from `library/docs/reference/business-standards.md`. A type that belongs to another family
   goes to its skill; a family this project has not selected is raised with the author, never
   filed here by default (answers change through Copier, `06-global-rules.md` Section 11). The
   one exception is an IT or security policy, which is this family's when there is no msp-scp
   family (Company documents above).
   *Complete when:* the type, the reader, the path and the filename are agreed.

2. **Settle the facts before a word is drafted.** Read `00-project.md` `## Brief` and `## Paths`,
   the client's facts file (set it up now if the client is new), any earlier document for them,
   and the brand voice. Ask what is still unknown, with a recommended answer each, as
   `06-global-rules.md` Section 8 says unless `00-project.md` `## Overrides` sets another style:
   the five questions of `standards/method/BUSINESS.md` rule 6, then the decision the reader must
   make, the budget or price basis, the dates, and, for a plan, the assumptions. *Complete when:*
   every fact is answered, or stands as `[AWAITING USER INPUT]` or an `AUTHOR TO CONFIRM` flag.

3. **Plan it as a unit.** Through `planning/workflows/01-plan-a-unit/` (`grill-with-docs`), the
   brief in `planning/src/units/` lists one section per required section above, in order, with
   the commitments in `## Obligations and defined terms`. A statement of work records its
   precedence in `planning/src/precedence.md`. *Complete when:* the brief is agreed (V1 dated).

4. **Start the deliverable.** Copy the skeleton or the family template to the agreed path, and
   fill the leading status block, the title block, the disclaimer slot, the Document Control rows
   the standard gives and one `% section:` marker pair per brief section, in order. A form or a
   record (meeting notes, a letterhead, a questionnaire's fixed fields) is filled from its template
   rather than drafted section by section (`library/docs/reference/document-anatomy.md`).
   *Complete when:* `make pdf FILE=<path>.tex` renders it and every marker pair is in place.

5. **Write the body through the loop.** One section per request: `draft-section`, then
   `adapt-section` or `improve-section`, then `promote-section` on the author's word. The summary
   is drafted last, from the promoted sections, so it carries the whole document.
   *Complete when:* every section is promoted, or the author has paused with the rest listed.

6. **Run the family's checks.** Through `library/workflows/05-review-a-document/`: the required
   sections present and in order (`structure-review`); every figure, date and entity verified
   (`fact-check`); terms and precedence for a statement of work (`clause-consistency`); every
   commitment traced (`obligation-check`); `tone` at line edit. Then work the checklist below with
   `make flags SCOPE=<path>` and `make lint SCOPE=<path>`. *Complete when:* every item is ticked or
   reported open with its location.

7. **Register it and hand back.** Add or update its row through
   `planning/workflows/08-update-the-register/`, its review date in
   `planning/src/review-schedule.md` if it has one, and its listing in its folder's `CONTEXT.md`.
   Issue only on the author's word: `make pdf
   FILE=<path>.tex ISSUE=1` writes the PDF beside the source and refuses to overwrite an issued
   one. Hand back what was made, every open flag and the next step. *Complete when:* the register
   row is written and the author has the hand-back.

## Pre-issue checklist

- [ ] Every required section for the type, in order, or its omission recorded in the brief.
- [ ] The summary written last, holding every price and the decision asked for.
- [ ] In scope and Out of scope stated (proposals, statements of work).
- [ ] Every price a line item, traced to the author's quotation, in the house currency.
- [ ] Projections carry their assumptions and scenario label, and the financial disclaimer.
- [ ] Competitors, case studies and testimonials supplied by the author, never invented.
- [ ] Risks with likelihood, impact and mitigation (business plans).
- [ ] The class's disclaimer verbatim, or the author's waiver recorded.
- [ ] No `\fillme`, `[AWAITING USER INPUT]`, `\dnote` or open flag in the document.
- [ ] en_GB, DD/MM/YYYY, single quotation marks, no em dashes, the recorded voice.
- [ ] Register row and review date written.

## Anti-patterns

- **A single total.** The reader cannot see what they are paying for, or what to cut.
- **Scope by implication.** Anything not written in Out of scope will be argued into scope.
- **Projections without assumptions.** A number with no basis cannot be defended or revised.
- **Inventing a competitor, a case study or a client quote.** Ask, or leave the field open.
- **New terms in an onboarding pack or guide.** It summarises what was agreed; a change is a
  variation of the agreement, not a sentence in a welcome letter.
- **Copying one client's document into another's.** Start from the template
  (`standards/risk/BUSINESS.md` rule 1).
- **Writing a client's facts into a second family's folder.** They live once.
- **Rewriting an issued proposal.** A revision is a new version; the issued file stays as sent.

## Cross-references

- `library/docs/reference/business-standards.md` — the family standard.
- `library/workflows/10-create-a-business-document/` — the procedure of record.
- `.claude/rules/syntek-author/00-project.md` — the project's values and paths.
- `standards/method/BUSINESS.md`, `standards/risk/BUSINESS.md` and
  `standards/verification/BUSINESS.md`.
- `standards/brand/CONTEXT.md` — the brand voice, brand guide and disclaimers.
- `tooling/latex/house-preamble.tex` — the house macros; `planning/src/document-register.md`.
- `.claude/skills/draft-section/SKILL.md`, `.claude/skills/promote-section/SKILL.md` — the loop.
- `.claude/skills/obligation-check/SKILL.md`, `.claude/skills/clause-consistency/SKILL.md`,
  `.claude/skills/tone/SKILL.md` — the business gates.
