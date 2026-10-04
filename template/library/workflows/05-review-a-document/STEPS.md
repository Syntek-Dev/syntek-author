---
workflow: 05-review-a-document
phase: review
skills: [structure-review, fact-check, clause-consistency, obligation-check, comprehension, flow, tone, grammar, spelling, build]
model: opus
---

# STEPS.md — review a document to final

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for taking a fully promoted document through structural review, fact check
and line edit, into the register, and to `final`. Each step names the skill and guide it uses.
**Run in order** — the ordering is load-bearing — and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`), then the gates in
> `standards/verification/verification.md` and the business sub-gates in
> `standards/verification/BUSINESS.md`. At each stage, the status moves in the unit brief and in
> the `.tex` status block (a Markdown deliverable's frontmatter `status:`) in the same edit, and
> each gate's date goes in the brief's `verified:` map.
> **Report first; apply only what is agreed**, as set out under 'Applying agreed fixes' below.

## 1. Confirm the document is ready for review

> **Skill:** `run-workflow` · **Guide:** `library/docs/reference/the-status-ladders.md`

Every planned section in the brief's `sections:` list is `promoted` with zero flags and every
marker pair in the `.tex` holds its text: V2 (draft → structural-review). The document renders
(`make pdf FILE=<path>.tex`) and the proof has been read: V3 (draft → structural-review). If both
pass, date V2 and V3 and move the status to `structural-review`. If not, report what is missing
and stop. _Mechanical._

## 2. Read what the document must agree with

> **Skill:** `structure-review` · **Guide:** `library/docs/reference/document-anatomy.md`

Read the unit brief, the family's standard (`library/docs/reference/<family>-standards.md`), the
client's facts (`## Facts` in `library/src/business/client-docs/<client-slug>/CONTEXT.md`, or where
`00-project.md ## Paths` says), `planning/src/precedence.md`, every document in the family
this one relies on or is relied on by, and, for a new version, the version it replaces and its
register row. _Substantive._

## 3. Structural review

> **Skill:** `structure-review` · **Guide:** `library/docs/reference/document-anatomy.md`

Run `structure-review` in its business mode, forked, with its lenses (the counterparty, a
solicitor, the client reader, the brand). It checks that the document's parts are present and in
order, that each section does the job its brief gave it, and that the document answers the
questions its reader will ask. The synthesis goes to
`planning/src/reviews/REVIEW-<scope>-DD-MM-YYYY.md`, marked advice only. _Substantive._

## 4. The author decides the structural changes

> **Skill:** `structure-review` · **Guide:** `planning/docs/reference/reviews-are-advice.md`

Put the review's findings to the author. Each agreed change reopens its section: through
`library/workflows/02-adapt-a-draft/` or `library/workflows/03-improve-your-draft/`, then
`library/workflows/04-promote-a-section/`, as set out under 'Applying agreed fixes' below. A
decision the author dates goes into `.claude/MEMORY.md` `## Decisions`. When the agreed changes
are in, V4 (structural-review → fact-check) has passed: date it and move the status to
`fact-check`. _Substantive._

## 5. Check every fact

> **Skill:** `fact-check` · **Guide:** `research/docs/reference/vetting-evidence.md`

Sweep the document for checkable claims: every figure, date, price, service level, entity detail,
statute and framework reference. Verify each against its source, record it in
`research/src/evidence/` with its verdict, and flag anything not verified with
`\dnote{VERIFY: …}`. A counterparty is verified against the public register, never its website.
Corrections the author accepts are applied as set out under 'Applying agreed fixes'. _Substantive._

## 6. Check the clauses agree

> **Skill:** `clause-consistency` · **Guide:** `library/docs/reference/latex-deliverables.md`

Every defined term is defined once, bolded once and used as defined; near-synonyms carry a
sentence that tells them apart; every `\ref` resolves; terms match across the family of documents;
the order of precedence is stated. Report findings by clause; the author decides each fix.
_Substantive._

## 7. Check every obligation

> **Skill:** `obligation-check` · **Guide:** `library/docs/reference/document-anatomy.md`

Every 'shall', 'may' and 'must' is intended; every commitment traces to an instrument clause or is
flagged as new; no 'will' is left unbounded; no certification is over-claimed. When the fact
check, clause and obligation findings are resolved, V5 (fact-check → line-edit) has passed with
its sub-gates V5.1 and V5.2: date them and move the status to `line-edit`. _Substantive._

## 8. Read it as its reader

> **Skill:** `comprehension` · **Guide:** `library/docs/reference/document-anatomy.md`

Read the document as the reader the brief names (and the audience and reader test in
`00-project.md ## Brief`): undefined terms, leaps, buried points, a long document without its
reader's map.
Report by location. _Substantive._

## 9. Flow

> **Skill:** `flow` · **Guide:** `library/docs/reference/section-anatomy.md`

Transitions, paragraph order, repetition, and one voice across sections drafted on different days.
Each part leads with its point; the document ends with a way forward. Report by location; apply
only what the author agrees. _Substantive._

## 10. Tone

> **Skill:** `tone` · **Guide:** `library/docs/reference/document-anatomy.md`

The house voice and plain English for running copy; the formal register kept for an instrument or
a policy. A tone pass never changes a figure, a date, a scope boundary or a commitment; anything
that would is raised with the author instead. _Substantive._

## 11. Grammar and spelling

> **Skill:** `grammar` · **Guide:** `library/docs/reference/section-anatomy.md`

Run `grammar` then `spelling` against `standards/style/style-sheet.md` and
`standards/style/terminology.md`: a supportive report, recurring items grouped, the correction
offered for each. Apply the corrections the author accepts. _Substantive._

## 12. Register the document

> **Skill:** — · **Guide:** `library/docs/reference/versioning-and-the-register.md`

The line edit is done, so the document is registered now, before its issue proof: V6.2 needs its
row. Run `planning/workflows/08-update-the-register/`: it issues the `DOC-NNN` and adds the row
with register Status `Draft`, and a review-schedule row where the document has a review cycle. A
new version keeps its identifier; its row moves to the new file instead. Write the `DOC-NNN` into
the Document Control block's Reference and the brief's `number`. _Mechanical._

## 13. Clear every flag and read the issue proof

> **Skill:** `build` · **Guide:** `library/docs/reference/latex-deliverables.md`

`make flags SCOPE=<path>.tex` lists nothing (it counts the project's own open-item markers too,
`FLAG_EXTRA_RE` in `tooling/project.mk`); no `\dnote`, `\fillme`, redline mark or
`[AWAITING USER INPUT]` remains; the disclaimer matches the disclaimers file
`00-project.md ## Paths` names, word for word; the Document Control block, its Reference included,
and the version history are complete; the register row exists. V6.2 can now pass. Render with
`make pdf FILE=<path>.tex` and read the whole proof. _Substantive._

## 14. The author's word: final

> **Skill:** — · **Guide:** `library/docs/reference/the-status-ladders.md`

Ask the author, in words, whether the document is final. On a yes: date V6 (line-edit → final),
V6.1 and V6.2; set `final` in the brief and the `.tex` status block; set the Document Control
Status to the value the author confirms it is issued with; and add the author's word, dated, to
`.claude/MEMORY.md` `## Status`. Render once more with `make pdf FILE=<path>.tex ISSUE=1`, which
places the issue PDF beside the `.tex` under the same basename. It refuses a status outside
`ISSUE_STATUSES` (`tooling/project.mk`) and refuses to overwrite a file already there: an issued
PDF is a record, so `FORCE=1` is passed only on the author's explicit word. An authored email has
no issue PDF; record this render as not applying. On anything else, record what is outstanding
and stop. _Substantive._

## 15. Record the approval

> **Skill:** — · **Guide:** `library/docs/reference/versioning-and-the-register.md`

When the document is formally approved or executed, run `planning/workflows/07-record-an-approval/`.
The register row's Status moves on from `Draft` (issued, approved, executed) only on the
author's word, through `planning/workflows/08-update-the-register/`. _Mechanical._

## 16. Hand back

> **Skill:** `run-workflow` · **Guide:** `library/docs/reference/the-status-ladders.md`

Report the document's status, the issue PDF's path, its register ID, the review file, every
correction applied directly, every section reopened, and any gate waived with the author's reason.
Remind the author that sending, signing or publishing is theirs to do. _Substantive._

## Applying agreed fixes

Each case follows `standards/verification/verification.md` Section 3.

- **A material change** (a section rewritten, a claim or a commitment added, the document
  restructured) clears the date of the gate it reopens and of every later gate in the brief's
  `verified:` map, and steps `status:` back, in the brief and the `.tex` block together, to the
  rung the standard names. The section goes back through `library/workflows/02-adapt-a-draft/` or
  `library/workflows/03-improve-your-draft/` and is promoted again through
  `library/workflows/04-promote-a-section/`; the review resumes from that rung.
- **Any other agreed wording change** goes back through the section the same way and is promoted
  again; the stages the document has already passed are run again over that section before it
  moves on. Whenever a section is reopened, and its ledger entry carries `format: 2`, its previous
  `## Author final` goes into `## Revisions` before the new round's first revision, as
  `standards/style/ledger/CLAUDE.md` sets out.
- **An agreed correction** (a slip, a spelling or punctuation fix, a figure the fact check
  corrected) may be applied in the `.tex` directly. Make the same correction in the section's
  draft, log it as a row in the section's ledger entry, and run
  `make section-check FILE=<path>.tex SECTION=<slug> DRAFT=<draft>.md`, so the draft and the
  document still hold the same words. A spelling or punctuation fix reopens only V6. List each
  correction in the hand-back.
- **The ledger follows the document.** A correction to a promoted section changes its promoted
  text, so its ledger entry is brought up to date in the same pass, following the steps for a
  correction after promotion in `standards/style/ledger/CLAUDE.md`. In an entry carrying
  `format: 2`, the previous `## Author final` goes into `## Revisions` unless the last state in the
  chain already equals it, then the section's draft as found if it differs from the last recorded
  state, then the corrected draft as one `ai` revision with its rows. In every entry, the
  corrected draft's body becomes the `## Author final`, `learned` goes back to `false`, the ratio
  is rewritten, the section's row in `standards/style/ledger/provenance.md` is updated, and
  `python3 tooling/provenance.py check` reports no problems.
