---
name: legal-documents
description: >-
  Create a legal document for the business, or check that one has everything its type requires:
  a services contract, an amendment, an NDA, terms and conditions, a privacy policy or notice, a
  data processing agreement, or a formal notice or payment plan served under a contract. Holds
  each type's required sections, the clause, defined-term and execution conventions, the
  governing-law and disclaimer rules and the pre-issue checklist, and routes to the create workflow
  and the legal standard. Use when the author says 'draw up an NDA for…', 'we need a contract
  with…', 'write our terms and conditions', 'what must a DPA contain?', 'serve notice under the
  agreement' or 'does this contract have everything it needs?'. Not one section (`draft-section`,
  `adapt-section`); not defined terms and cross-references (`clause-consistency`); not shall, may
  and must (`obligation-check`); not verifying a statute or entity (`fact-check`); not a proposal
  or statement of work (`business-documents`).
---

# Skill: Legal documents (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

The legal family is the business's instruments: what binds it and its counterparties, and the
notices it serves under them. This skill owns the family's domain: which document types exist,
what each must contain, and the conventions that make an instrument precise. The procedure of
record is the create workflow; the prose is written section by section through the authoring
loop. Whenever another skill works on a document in `library/src/legal/` (drafting, improving,
promoting, reviewing), the conventions and checklist here bind it too. Nothing here is legal
advice: no document is fit to rely on until a qualified professional has reviewed it.

## Governing procedures (route here — do not restate at length)

- `library/workflows/11-create-a-legal-document/` — the procedure of record for a new legal
  document; this skill is its domain in skill form. Run its `STEPS.md` with `CHECKLIST.md` open.
  Where this file and the procedure disagree, the procedure wins and the disagreement is reported to
  the author. An alias in `00-project.md` `## Workflow aliases`, then a same-named folder in
  `library/workflows/local/`, replaces it (`run-workflow`).
- `library/docs/reference/legal-standards.md` — the family standard: naming, document control
  rows, review cycle and status values. Route there; do not restate it.
- `.claude/rules/syntek-author/00-project.md` — `## Brief` (trading name, jurisdiction, currency,
  voice) and `## Paths` (disclaimers, client facts, LaTeX skeleton, brand folder). It
  outranks every other rules file; take those values from it, never from memory.
- `.claude/rules/syntek-author/03-authorship.md` Sections 4 and 7 (never fabricate; obligations
  are never invented), `standards/method/BUSINESS.md` and `standards/risk/BUSINESS.md`.
- `library/docs/reference/document-anatomy.md`, `library/docs/reference/latex-deliverables.md`
  and `library/docs/reference/versioning-and-the-register.md` — the parts in order, the house
  macros and section markers, versioned filenames.

## Document types and required sections

Each list is the body's required sections, in order, after the title block, disclaimer and
Document Control block. A section one document does not need is agreed with the author and
recorded in its brief, never dropped silently. A service level agreement follows the msp-scp
family's sections where the project has that family, and otherwise the parts the standard lists.

### Services contract

1. Parties: full legal names, registered numbers, registered addresses
2. Background (numbered recitals)
3. Definitions and interpretation
4. The services (by reference to a statement of work or schedule where one exists)
5. Term
6. Fees and payment (by reference to the order, quotation or schedule that sets them)
7. Each party's obligations, including the client's dependencies
8. Intellectual property
9. Confidentiality
10. Data protection (and the data processing agreement, where processing is involved)
11. Warranties
12. Limitation of liability, and indemnities where agreed
13. Termination and its consequences
14. Precedence, where the contract heads a family of documents
15. General (entire agreement, variation, assignment, waiver, severability, notices, third-party
    rights)
16. Governing law and jurisdiction
17. Execution block, and the schedules

### Amendment or variation

Parties, and the agreement amended (title, date, reference, version); the amendments, each naming
the clause it replaces, inserts or deletes; everything else unchanged and in force; the effective
date; precedence between the two; governing law as the agreement; the execution block.

### Non-disclosure agreement

1. Parties, and whether it is mutual or one-way (stated in the title too)
2. Background and the purpose for which information is shared
3. Definitions (at least the confidential information, the discloser and the recipient)
4. Obligations of confidentiality
5. Permitted disclosures (advisers, by law or regulator)
6. Exclusions (public, already known, independently developed, received lawfully)
7. Duration of the obligations
8. Return or destruction of information
9. Remedies
10. Governing law and jurisdiction
11. Execution block

### Terms and conditions

1. Who operates the service and how to contact them
2. Definitions
3. How the terms are accepted, and the order of precedence with any order or quotation
4. The services or goods
5. The customer's obligations
6. Fees, payment and refunds
7. Intellectual property
8. Privacy (by reference to the privacy policy)
9. Limitation of liability
10. Suspension and termination
11. Changes to the terms
12. Complaints and disputes
13. Governing law, and contact details

### Privacy policy (published)

1. Who we are, and the controller's contact details (and a data protection officer, if appointed)
2. The personal data collected, and from where
3. The purposes and the lawful basis for each
4. Who it is shared with, and any processors by category
5. International transfers and the safeguard for each
6. How long each kind is kept
7. The individual's rights and how to exercise them
8. Cookies and similar technologies, or a link to the cookie notice
9. Changes to the policy, and how to complain, including to the Information Commissioner's Office

### Privacy notice (at the point of collection)

The information UK GDPR Articles 13 (data collected from the person) and 14 (data obtained
elsewhere) require: the controller's identity and contacts; the purposes and lawful basis, and the
legitimate interests where relied on (Article 6(1)(f)); the recipients; transfers and their
safeguards; retention; the rights, including withdrawing consent; the right to complain to the
ICO; whether providing the data is a statutory or contractual requirement; any automated
decision-making; and, under Article 14, the categories of data and their source.

### Data processing agreement

1. Parties, as controller and processor
2. Background, and the services agreement it supplements
3. Definitions aligned with UK GDPR
4. The subject matter, duration, nature and purpose of the processing, the types of personal data
   and the categories of data subjects (Article 28(3), opening words)
5. Processing only on documented instructions (Article 28(3)(a))
6. Confidentiality of the people who process it (Article 28(3)(b))
7. Security of processing (Article 28(3)(c) and Article 32)
8. Sub-processors: prior authorisation and flow-down (Article 28(2), (3)(d) and (4))
9. Assistance with data subjects' rights (Article 28(3)(e))
10. Assistance with security, breach notification and impact assessments (Article 28(3)(f))
11. Deletion or return at the end of the services (Article 28(3)(g))
12. Information and audits (Article 28(3)(h))
13. International transfers
14. Liability, term and termination
15. Governing law
16. Schedule: details of the processing
17. Schedule: technical and organisational security measures

### Formal notice or letter under a contract

A termination, breach or other notice, or a payment plan the counterparty signs.

1. Letter heading (trading name, date, the recipient's address for notices), and a bold subject
2. The contract relied on (title, date, version) and the clause invoked
3. The notice itself: what is notified and when it takes effect
4. Its effect: outstanding obligations, intellectual property, data, return of property
5. What the recipient must do, and by when
6. A payment plan adds: the invoices by number and amount, the schedule (Instalment · Amount · Due
   date) and the consequence of default, signed by both parties
7. Sign-off by an authorised signatory

## House conventions

- **Format.** A LaTeX deliverable from the skeleton `00-project.md` `## Paths` names (by default
  `tooling/latex/skeleton.tex`) or a template in `library/src/legal/templates/`, never from scratch.
- **Clauses.** The house `clause` list numbers them `1.`, `1.1`, `(a)`; `\ctitle{…}` heads each
  top-level clause; every clause another one cites carries `\label{cl:<slug>}` and is cited as
  `clause~\ref{cl:<slug>}`, with 'clause' in lower case. Never type a clause number by hand.
- **Defined terms.** Bold and in quotation marks at the definition only
  (`\textbf{‘Confidential Information’} means…`), capitalised and in exactly that form ever
  after; the definitions clause comes first.
- **Schedules** sit together at the end, each its own `\section`, placed and numbered as the
  family's other instruments already place and number them.
- **Execution.** A block for every party: name, title, signature, date. A deed, or execution by a
  company under its own formalities, takes the form the author's solicitor confirms.
- **Governing law** is a dedicated clause before the execution block, naming the jurisdiction in
  `00-project.md` `## Brief` unless the author decides otherwise for one instrument and the
  internal note records why.
- **Register.** Formal and precise: 'shall' for an obligation, 'may' for a discretion, 'must' for
  a condition; the party's defined name after first use; UK terms ('solicitor', 'articles of
  association'). Plain English suits terms and policies a consumer reads, never at the cost of
  precision. Brand voice never softens an instrument.
- **Statutes.** Cite an Act, regulation or article only once `fact-check` has verified it applies,
  with jurisdiction and date; until then write 'applicable data protection law' or carry `VERIFY`.
  Consumer terms are checked against the Consumer Rights Act 2015 and the Consumer Contracts
  (Information, Cancellation and Additional Charges) Regulations 2013; privacy documents against UK
  GDPR, the Data Protection Act 2018 and the Privacy and Electronic Communications Regulations
  2003, all as amended (the Data (Use and Access) Act 2025 amends them in stages) on that date.
- **Disclaimer.** The wording for the legal class, copied unchanged from the disclaimers file
  `00-project.md` `## Paths` names, in the skeleton's `housenotice` slot before clause 1. While the
  class has no approved wording, the slot holds `\dnote{AUTHOR TO CONFIRM: …}`; a waiver is the
  author's, recorded in the internal note (`standards/risk/BUSINESS.md` rule 4).

## How to create a legal document

1. **Fix the type and its home.** Agree with <%AUTHOR_FIRST_NAME%> the type from the lists above,
   the counterparty, and whether this is new, a new version of an issued document, an amendment,
   or a template adapted for one client. Check `planning/src/document-register.md` for an existing
   document of that type with that party. A client's document lives in
   `library/src/legal/client-docs/<client-slug>/`, with the same slug the client has everywhere;
   the business's own instruments sit at the family root; reusable starting points in `templates/`.
   Name the file from `library/docs/reference/legal-standards.md`. A type outside this family goes
   to its own family's skill. *Complete when:* the type, the counterparty, the path and the
   versioned filename are agreed.

2. **Settle the facts before a word is drafted.** Read `00-project.md` `## Brief` and `## Paths`,
   the client's facts file (by default `library/src/business/client-docs/<client-slug>/CONTEXT.md`
   under `## Facts`), the instruments this one sits beside, and `planning/src/precedence.md`. Ask
   what is still unknown, with a recommended answer each, as `06-global-rules.md` Section 8 says
   unless `00-project.md` `## Overrides` sets another style: the five questions of
   `standards/method/BUSINESS.md` rule 6, then whether the counterparty is a business or a
   consumer, mutual or one-way, the governing law, and which document prevails. A legal name and
   number are checked on the public register and filed in `research/src/evidence/`, never taken
   from a website. *Complete when:* every fact is answered, or stands as `[AWAITING USER INPUT]` or
   an `AUTHOR TO CONFIRM` flag.

3. **Plan it as a unit.** Through `planning/workflows/01-plan-a-unit/` (`grill-with-docs`), the
   brief in `planning/src/units/` lists one section per required section above, in order, and its
   `## Obligations and defined terms` holds the commitments and the terms to be defined. Record the
   family's precedence in `planning/src/precedence.md`. *Complete when:* the brief is agreed (V1
   dated) and its sections cover every required section.

4. **Start the deliverable.** Copy the skeleton or the family template to the agreed path. Fill
   the leading status block, the title block, the disclaimer slot, the Document Control rows the
   standard gives and one `% section:` marker pair per brief section, in order; parties and the
   execution block come from the facts, never from guesses. *Complete when:* `make pdf
   FILE=<path>.tex` renders it and every marker pair is in place.

5. **Write the body through the loop.** One section per request: `draft-section`, then
   `adapt-section` or `improve-section`, then `promote-section` on the author's word. Every draft
   follows the house conventions above. A template adapted for one client keeps its clause order
   and labels, and every change to a term is listed for `obligation-check` against the template's
   position. *Complete when:* every section is promoted, or the author has paused with the rest
   listed.

6. **Run the family's checks.** Through `library/workflows/05-review-a-document/`: the required
   sections present and in order (`structure-review`); every statute, entity and figure verified
   (`fact-check`); defined terms, cross-references and precedence (`clause-consistency`, V5.1);
   every commitment traced (`obligation-check`, V5.2); `tone` at line edit, keeping the formal
   register. Then work the checklist below with `make flags SCOPE=<path>` and `make lint
   SCOPE=<path>`, scoped to this document. *Complete when:* every item is ticked or reported open
   with its location.

7. **Register it and hand back.** Add or update its row through
   `planning/workflows/08-update-the-register/`, its review date in
   `planning/src/review-schedule.md` and its listing in its folder's `CONTEXT.md`. Issue only on
   the author's word: `make pdf FILE=<path>.tex ISSUE=1` refuses to overwrite an issued PDF. Signing
   and serving are the author's acts; the signed copy is filed beside the `.tex` as the standard
   names it and recorded through `planning/workflows/07-record-an-approval/`, and only then is the
   instrument Executed. *Complete when:* the register and schedule rows are written and the author
   has the hand-back.

## Pre-issue checklist

- [ ] The legal class's disclaimer, verbatim, before clause 1, or the author's waiver recorded.
- [ ] The Document Control block complete, with its version history.
- [ ] Every required section for the type, in order, or its omission recorded in the brief.
- [ ] Parties' legal names, numbers and addresses checked on the public register, dated.
- [ ] Every term defined once, first, and used as defined (V5.1); every modal traced (V5.2).
- [ ] Precedence matching `planning/src/precedence.md`; governing law as `## Brief` records.
- [ ] Every statute and article verified and dated, or written generically.
- [ ] The notices clause honoured: a notice goes by the method and to the address it requires.
- [ ] An execution block for every party, and every schedule the clauses cite.
- [ ] No `\fillme`, `[AWAITING USER INPUT]`, `\dnote` or open flag in the document.
- [ ] en_GB, DD/MM/YYYY, single quotation marks, no em dashes; register row and review date written.

## Anti-patterns

- **Carrying a clause across clients.** A term negotiated with one client never appears in
  another's document; start from the family template (`standards/risk/BUSINESS.md` rule 1).
- **Citing a section number from memory.** An unverified statute is a liability on the page.
- **Taking a legal name from a website or an email signature.** The public register is the source.
- **Softening a clause for plain English.** Shorten the writing, never the obligation.
- **Improvising or paraphrasing a disclaimer**, or dropping one without a recorded waiver.
- **Editing an executed agreement.** A change is an amendment or a new version; the signed file
  stays as it was signed.
- **Filing a formal notice as an email.** A notice served under a contract is an instrument and
  lives in this family, served as its notices clause requires.
- **Creating a client folder here to hold facts.** A client's facts live once, where `00-project.md`
  `## Paths` says.
- **Calling the document legally sound.** The author decides; a professional reviews it.

## Cross-references

- `library/docs/reference/legal-standards.md` — the family standard.
- `library/workflows/11-create-a-legal-document/` — the procedure of record.
- `.claude/rules/syntek-author/00-project.md` — the project's values and paths.
- `standards/method/BUSINESS.md`, `standards/risk/BUSINESS.md` and
  `standards/verification/BUSINESS.md`.
- `tooling/latex/house-preamble.tex` — the house macros; `planning/src/precedence.md`.
- `.claude/skills/draft-section/SKILL.md`, `.claude/skills/promote-section/SKILL.md` — the loop.
- `.claude/skills/clause-consistency/SKILL.md`, `.claude/skills/obligation-check/SKILL.md`,
  `.claude/skills/tone/SKILL.md` — the business gates.
- `.claude/skills/business-documents/SKILL.md` — the proposals and statements of work.
