---
name: msp-scp-documents
description: >-
  Create an IT policy, plan, register, report or service agreement for a managed-service client or
  the business itself, or check that one is complete: security, password, acceptable use, network,
  data classification, retention and change management policies; incident response and continuity
  plans; incident and vendor reports; sub-processor registers; SLAs. Holds the document-control,
  classification, review-date and alignment rules, each type's required sections and the pre-issue
  checklist, and routes to the create workflow and the msp-scp standard. Use when the author says
  'write an incident response plan for…', 'we need an acceptable use policy', 'draft the SLA' or
  'is this policy complete?'. Not an HR or staff-conduct policy (`business-documents`); not a
  contract, DPA or privacy notice (the legal family's skill, where the project has it; otherwise
  raise it with the author); not one section (`draft-section`); not checking a standard or statute
  (`fact-check`); not modal verbs (`obligation-check`).
---

# Skill: MSP and SCP documents (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

The msp-scp family is the policy suite a managed-service provider writes for its clients and
keeps for itself: the security and compliance policies, the plans for when things go wrong, the
registers and reports that evidence control, and the service levels that bind delivery. This skill
owns the family's domain: which document types exist, the parts every one of them carries, and
the conventions that keep a policy enforceable and its claims earned. The required sections of
each type live in two sub-documents beside this file. The procedure of record is the create
workflow. Whenever another skill works on a document in `library/src/msp-scp/`, the conventions
and checklist here bind it too. Nothing here is security, compliance or legal advice.

## Governing procedures (route here — do not restate at length)

- `library/workflows/15-create-an-msp-scp-document/` — the procedure of record for a new msp-scp
  document; this skill is its domain in skill form. Run its `STEPS.md` with `CHECKLIST.md` open.
  Where this file and the procedure disagree, the procedure wins and the disagreement is reported to
  the author. An alias in `00-project.md` `## Workflow aliases`, then a same-named folder in
  `library/workflows/local/`, replaces it (`run-workflow`).
- `library/docs/reference/msp-scp-standards.md` and its sub-document
  `library/docs/reference/MSP-SCP-POLICY-SUITE.md` — the family standard: the suite's numbering
  and order, the structure every policy follows, Document Control, names, review cycles and the
  triggers for an unscheduled review. Route there; do not restate it.
- `.claude/rules/syntek-author/00-project.md` — `## Brief` (trading name, jurisdiction) and
  `## Paths` (disclaimers, client facts, LaTeX skeleton, brand folder). It outranks every other
  rules file; take those values from it.
- `.claude/rules/syntek-author/03-authorship.md` Sections 4 and 7, `standards/method/BUSINESS.md`
  rules 2, 4, 7 and 8, and `standards/risk/BUSINESS.md` rules 2, 3 and 5.
- `library/docs/reference/versioning-and-the-register.md` — versions and new versions.

## Document types

| Kind | Types | Required sections |
|---|---|---|
| Policies | Information security · Password and authentication · Acceptable use · Network security · Data classification · Data retention and disposal · Change management | `REQUIRED-SECTIONS-POLICIES.md` |
| Plans, reports, registers, agreements | Incident response plan · Business continuity plan · Security incident report · Vendor assessment report · Sub-processor register · Service level agreement | `REQUIRED-SECTIONS-PLANS-AND-REPORTS.md` |
| Operational documents | Client runbook · Network topology · Monthly service report · Change request | the standard's `MSP-SCP-POLICY-SUITE.md` |

Read the sub-document for the type before planning it. The suite's data processing agreement and
privacy notice keep their suite numbers here but are legal instruments: draft them to the legal
family's required sections where the project has that family, and otherwise raise it with the
author before drafting. An IT or information-security policy is this family's whether the suite
is a client's or the business's own; an HR or staff-conduct policy is a company document
(`business-documents`).

## The parts every document carries

1. The title block, then the Document Control block as the skeleton's `housecontrol` rows, in the
   rows and status values the standard gives (Title, Owner, Version, Status, Last reviewed, Next
   review, Classification). Set the running header with `\houseclassification{<level>}`, so the
   classification shows on every page. A policy becomes Active only once its approval is recorded.
2. The version history (Version · Date · Author · Change description · Approved by), placed as
   `MSP-SCP-POLICY-SUITE.md` places it, versions as
   `library/docs/reference/versioning-and-the-register.md` gives them.
3. The review-date notice on every policy, in the wording the disclaimers file `00-project.md`
   `## Paths` names, and any further disclaimer only where that file gives the class one; while a
   wording is missing, `\dnote{AUTHOR TO CONFIRM: …}` holds the slot.
4. The body, in the order the sub-document gives, ending with related documents and the approval
   and sign-off section.

## House conventions

- **Format.** Every document is a LaTeX deliverable from the skeleton `00-project.md` `## Paths`
  names (by default `tooling/latex/skeleton.tex`), or from a template in
  `library/src/msp-scp/templates/`. Numbered rules use the house `clause` list, with
  `\label{cl:<slug>}` and `clause~\ref{cl:<slug>}`; tables are `tabularx` (`longtable` when a
  register runs past a page).
- **Where it lives.** A client's suite in `library/src/msp-scp/client-docs/<client-slug>/`, and
  their reports in `client-docs/<client-slug>/reports/`; the business's own suite at the family
  root; templates in `templates/`. The suite keeps the standard's `NN-` numbers everywhere, with a
  gap where a document is not needed.
- **Rules are imperative.** 'The organisation must…', 'All staff shall…'; never 'should consider'.
  'Organisation' where a rule applies universally; roles, never individuals' names.
- **Defined terms.** Bold at the definition only (`\textbf{Incident}`, `\textbf{Privileged
  Account}`), every technical term defined on first use.
- **Alignment is claimed, never certification.** 'Aligned with' or 'informed by' ISO/IEC
  27001:2022 (controls in its Annex A, guidance in ISO/IEC 27002:2022), Cyber Essentials (the UK
  government-backed scheme some public-sector contracts require) or, where the client works in a
  US-regulated sector, NIST SP 800-53. Never 'certified to' or 'compliant with' unless the
  certificate exists, is current and is dated in `research/src/evidence/`. A control is cited by
  its number and title only from the published standard or the client's statement of
  applicability: 'ISO/IEC 27001:2022, Annex A 8.8, Management of technical vulnerabilities'. A
  section that maps to a control closes with its `\textbf{Alignment:}` note.
- **Personal data.** Every policy that touches personal data names the data protection
  obligations under UK GDPR and the Data Protection Act 2018, as in force on the drafting date
  (`fact-check`).
- **Technical baselines** (minimum key lengths, protocol versions, password lengths) are the
  client's decision, informed by current NCSC guidance checked at the date of drafting; a default
  from a sub-document is offered as a recommendation, never imposed.
- **Response times and service levels** come only from the agreement or the author, never
  invented; they carry `VERIFY` until traced.
- **No vendor product names** in a policy body: a policy names a capability ('a password
  manager'), and the product lives in the client's own records.
- **Register.** Formal, authoritative and unambiguous; brand voice does not soften a policy, but
  the letterhead applies.

## How to create an msp-scp document

1. **Fix the type and its home.** Agree with <%AUTHOR_FIRST_NAME%> the type from the table above,
   whose suite it belongs to (a client's or the business's own), and whether it is new, a scheduled
   review, an unscheduled review after a trigger, or a template adapted for one client. Check
   `planning/src/document-register.md` for the current version; a live policy due its review goes
   through `planning/workflows/06-run-a-review-cycle/` first. Name the file from the standard.
   *Complete when:* the type, the suite, the path, the filename and the reason for the work are
   agreed.

2. **Settle the facts and the environment.** Read `00-project.md` `## Brief` and `## Paths`, the
   client's facts file (by default `library/src/business/client-docs/<client-slug>/CONTEXT.md`
   under `## Facts`), the agreement the suite serves, and the rest of the suite. Ask what is still
   unknown, with a recommended answer each, as `06-global-rules.md` Section 8 says unless
   `00-project.md` `## Overrides` sets another style: the five questions of
   `standards/method/BUSINESS.md` rule 6, then the systems and people in scope, the frameworks the
   client aligns with, the classification scheme, the policy owner and approver by role, the
   review cycle, and what the business or client actually does today: a gap between practice and
   the rule the author wants is raised now, never papered over in the text. Never ask for or record
   a credential (`standards/risk/BUSINESS.md` rule 2).
   *Complete when:* every fact is answered, or stands as `[AWAITING USER INPUT]` or an `AUTHOR TO
   CONFIRM` flag.

3. **Plan a policy, plan or agreement as a unit.** Through `planning/workflows/01-plan-a-unit/`
   (`grill-with-docs`), the brief in `planning/src/units/` lists one section per required section
   in the sub-document, in order, with the duties and service levels in `## Obligations and defined
   terms`. A report (a security incident, vendor assessment or monthly service report, or a change
   request) is filled from its template from the author's records instead: no figure, time or
   cause invented. *Complete when:* the brief is agreed (V1 dated), or the document is confirmed
   to be a report.

4. **Start the deliverable.** Copy the skeleton or the family template to the agreed path. Fill
   the leading status block, the title block, the Document Control rows, the version history, the
   disclaimer slot, the review-date notice and one `% section:` marker pair per brief section.
   *Complete when:* `make pdf FILE=<path>.tex` renders it and every marker pair is in place.

5. **Write the body through the loop.** One section per request: `draft-section`, then
   `adapt-section` or `improve-section`, then `promote-section` on the author's word. A register
   or a severity table is filled from facts, never drafted from imagination. *Complete when:*
   every section is promoted, or the author has paused with the rest listed.

6. **Run the family's checks.** Through `library/workflows/05-review-a-document/`: the required
   sections present and in order (`structure-review`); every standard, statute and control
   verified (`fact-check`); terms and cross-references across the suite (`clause-consistency`);
   every 'must', 'shall' and service level intended and traced (`obligation-check`); `tone` at line
   edit, keeping the formal register. Then work the checklist below with `make flags SCOPE=<path>`
   and `make lint SCOPE=<path>`. *Complete when:* every item is ticked or reported open with its
   location.

7. **Approve, register and hand back.** Record the approval through
   `planning/workflows/07-record-an-approval/` once the approver signs; add or update the register
   row through `planning/workflows/08-update-the-register/`, the next review in
   `planning/src/review-schedule.md`, and the listing in its folder's `CONTEXT.md`. Issue only on
   the author's word: `make pdf FILE=<path>.tex ISSUE=1` refuses to overwrite an issued file.
   Sending it to a client is the author's act. *Complete when:* the approval, register and
   schedule rows are written and the author has the hand-back.

## Pre-issue checklist

- [ ] Document Control block complete; the running header set with `\houseclassification{<level>}`.
- [ ] Version history present, the new row added.
- [ ] The review-date notice, and any disclaimer the disclaimers file gives the class.
- [ ] Every required section from the sub-document, in order, or its omission recorded.
- [ ] Rules in the imperative; roles, never names; every term defined.
- [ ] 'Aligned with', never 'certified to'; every control number verified.
- [ ] Severity table and response times traced to the agreement (incident plans, SLAs).
- [ ] The ICO notification duty stated for personal data breaches (incident plans and reports).
- [ ] Weak authentication methods named as weak (password policies).
- [ ] No vendor product name in the body; no credential anywhere.
- [ ] No `\fillme`, `[AWAITING USER INPUT]`, `\dnote` or open flag in the document.
- [ ] en_GB, DD/MM/YYYY; approval, register and review rows written.

## Anti-patterns

- **Claiming certification.** 'Certified to ISO 27001' without a current certificate is a
  representation a client can rely on and sue on.
- **'Should' in a rule.** A policy that recommends cannot be enforced.
- **Inventing a response time or a credit.** Service levels bind; they come from the agreement.
- **Copying one client's suite into another's.** Start from the template
  (`standards/risk/BUSINESS.md` rule 1).
- **Naming individuals.** People leave; roles stay. Contacts live in the client's facts file.
- **Writing a credential, an IP range or a configuration secret into a document.**
- **Editing an approved policy in place.** A change is a new version, approved again.

## Cross-references

- `REQUIRED-SECTIONS-POLICIES.md` and `REQUIRED-SECTIONS-PLANS-AND-REPORTS.md` — beside this file.
- `library/docs/reference/msp-scp-standards.md` — the family standard.
- `library/workflows/15-create-an-msp-scp-document/` — the procedure of record.
- `.claude/rules/syntek-author/00-project.md` — the project's values and paths.
- `standards/method/BUSINESS.md`, `standards/risk/BUSINESS.md` and
  `standards/verification/BUSINESS.md`.
- `planning/src/approvals/` — approval records, the default Approvals path (`00-project.md`
  `## Paths`); `planning/src/document-register.md`.
- `tooling/latex/house-preamble.tex` — `housecontrol`, `housenotice`, `houseclassification` and
  the `clause` list.
- `.claude/skills/draft-section/SKILL.md`, `.claude/skills/promote-section/SKILL.md` — the loop.
- `.claude/skills/clause-consistency/SKILL.md`, `.claude/skills/obligation-check/SKILL.md`,
  `.claude/skills/tone/SKILL.md` — the business gates.
