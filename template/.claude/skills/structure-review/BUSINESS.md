# BUSINESS.md — structural review of business documents

A business document is reviewed by the people it must survive: the counterparty who will rely on
it, a solicitor who would test it, the client reader who must act on it, and the brand it speaks
for. This mode has three scopes: one document before it is made final, one live document whose
scheduled review is due, and the whole library (or one family of it), where the review hunts for
structural friction between documents.

## Paths and unit

- **The unit** is a document in one of the families this project selected, under
  `library/src/<family>/` (`business`, `legal`, `email`, `accounting`, `social-media`, `msp-scp`),
  with its brief in `planning/src/units/`.
- **Family skill:** read the family's skill, `<family>-documents`, as well as this file: the parts
  its documents require and the checks it adds.
- **Project paths:** the 'Client facts', 'Brand folder' and 'Disclaimers' rows of `00-project.md`
  `## Paths` say where those live; this file names the template defaults.
- **One document before `final`:** step 3 of `library/workflows/05-review-a-document/`; scope is the
  unit slug. V5.1 and V5.2 in `standards/verification/BUSINESS.md` follow at fact check.
- **A scheduled review of a live document:** step 4 of `planning/workflows/06-run-a-review-cycle/`;
  scope is the document's slug.
- **The whole library, or one family:** `planning/workflows/09-review-the-whole-work/`; scope is
  `library` or the family's name.
- **Extra reads:** `library/docs/reference/document-anatomy.md` (the parts in order, and the parts
  each family requires) and the family's standard, `library/docs/reference/<family>-standards.md`;
  `standards/method/BUSINESS.md`; `standards/risk/BUSINESS.md`; the brand voice and the
  disclaimers (by default `standards/brand/brand-voice.md` and `standards/brand/disclaimers.md`);
  `planning/src/precedence.md`; `planning/src/document-register.md`;
  `planning/src/review-schedule.md`.

## Additions to the steps

- **Step 2 — also, for one document:** the client's facts (`## Facts` in the client's `CONTEXT.md`,
  by default under `library/src/business/client-docs/`); every document in the family it relies
  on or is relied on by; for a new version, the version it replaces and its register row.
- **Step 2 — also, for a scheduled review:** the register row and the review-schedule row; the
  document's Document Control block and version history; the family's guides in
  `library/docs/reference/` and any override in `library/docs/project/`.
- **Step 4 — the panel, in this order:**
  1. *Counterparty* — what am I committing to, what can I hold the author to, and where is the text
     loose enough to argue about?
  2. *Solicitor* — parties, definitions first, stated precedence, governing law, liability,
     termination: is the instrument sound and complete for its family? Legal points are
     information, listed as claims to verify; the review never gives legal advice.
  3. *Client reader* — the person the brief names: can they find what they must decide, what it
     costs and what to do next?
  4. *Brand* — the house voice in running copy, the formal register in instruments, the house
     person, the trading name exactly as `00-project.md` `## Brief` gives it, the disclaimer for
     the document's class.
- **Step 4 — also, for a scheduled review, a fifth lens, *currency*:** what is no longer true?
  Services, prices, contacts, legislation, entities and suppliers each go to `fact-check` as claims
  to verify.
- **Step 5 — also:** every part the anatomy guide requires is present and in order; precedence is
  stated in the same words as the family's other documents; the disclaimer is present, or its
  waiver recorded; the Document Control block is complete.

The whole-library scope looks for friction between documents rather than within one:

- **Step 2 — also, for the whole library:** scope before scanning. Weight the families that change
  most: recent history in version control, and rows in the register and the review schedule that
  are stale, missing or overdue.
- **Step 4 — also, for the whole library:** each lens hunts for the eight frictions, named in the
  library's vocabulary below: duplicated facts; contradictions; drift; orphans; shallow documents;
  missing leverage (the same document hand-written per client); superseded but still live; unstated
  precedence.
- **Step 5 — also, for the whole library:** apply the deletion test to every document suspected of
  being shallow before proposing it as a candidate.
- **Step 6 — also, for the whole library:** each candidate is a numbered entry in the verdicts: the
  documents and paths involved; the friction, by its name; the consolidation, in plain words; the
  wins, in terms of source of truth, locality and leverage; before and after, as a short table or
  two lines of text; and a recommendation strength of `Strong`, `Worth exploring` or
  `Speculative`. The verdicts end with the top recommendation and the reason for it. A candidate
  that contradicts a recorded decision appears only if the friction is real enough to reopen it,
  and then says so: 'contradicts the decision of DD/MM/YYYY that …, but worth reopening
  because …'.
- **Step 8 — also, for the whole library:** choosing a candidate and working it through (which
  document becomes the source of truth, what the others say instead, which rows change) happens
  after hand-back, with the author, through `grill-with-docs`; never inside the fork.

## Domain rules

- **A delivered document is a historical record.** A review of a sent or signed document never
  proposes editing it; the remedy is a new version (`standards/method/BUSINESS.md` rule 8).
- **The review writes no register, schedule or approval rows;** the planning workflows do, after
  the author decides.
- **Client material is cited by path, never pasted** into the review
  (`.claude/rules/syntek-author/06-global-rules.md` Section 10).
- **Consolidation stops at the outbox.** A sent document is superseded, never rewritten, however
  strong the case for consolidating it.
- **The library's vocabulary.** Use these words exactly, so that a finding can be argued rather
  than felt: *document* (one authored artefact, one owner, one purpose); *source of truth* (the one
  document that owns a fact); *derivation* (a file produced from another and never hand-edited,
  such as a PDF from its `.tex`); *precedence*; *duplication* (one fact written into several
  documents); *contradiction* (two live documents that disagree, with no precedence to settle it);
  *drift* (a reference that no longer resolves, or a derivation older than its source); *orphan* (a
  document with no register row, no folder entry or no next review date); *leverage* (one
  template, many documents); *locality* (everything a decision needs, in one place); *shallow* and
  *deep* (a shallow document restates others and adds no obligation, decision or fact of its own).

## Examples

> **Verdict line (counterparty, blocking).** The example proposal's `scope` excludes legal advice;
> its `investment` section prices 'all advice needed'. A counterparty could read the second as
> including the first.

> **Library candidate 1 (Strong): duplication.** The payment terms are written into the proposal
> template, the statement-of-work template and the invoice template, in three wordings. Source of
> truth: the master terms in the legal family; the others cite it. Wins: one change instead of three;
> no contradiction to settle in a dispute.

> **Claim to verify (currency lens).** The privacy policy names a supplier for data storage that
> the register's most recent approval does not mention; flagged `VERIFY` for `fact-check`.
