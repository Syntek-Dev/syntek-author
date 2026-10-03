# BUSINESS.md — drafting principles for business documents

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The method particular to business, legal and client documents, read with `method.md`.
`clause-consistency` enforces rules 3 and 4; `obligation-check` enforces rules 2 and 7; `tone`
enforces rules 1, 5 and 10 at line edit; `draft-section` writes to all of them. The parties in
the examples are invented and named only by their defined terms.

Dates DD/MM/YYYY (spelled out in correspondence where house style prefers); 24-hour time.

---

## 1. Specificity over superlatives

**Requirement.** Every claim of quality is substantiated by the specific fact behind it, or cut.
Never write a sentence whose confidence rests on adjectives rather than facts.

> **Wrong:** 'A market-leading, world-class service.'
>
> **Right:** 'Fixed within one working day in each of the last twelve months.' (with the figure
> flagged `VERIFY` until checked)

**Why this rule exists.** Specificity earns trust and superlatives spend it; a reader who has
seen a hundred proposals discounts every adjective and believes every number they can check.

---

## 2. Shorten the writing, never the obligation

**Requirement.** Concision is the house default for every reader, and it is not a licence to
remove substance. Cut softeners, restatements and trailing reassurances first; never cut a
commitment, a condition, a limit, an exclusion or a date to make a document shorter.

**Why this rule exists.** Concise is not thin. A shorter document that has quietly dropped a
limit of liability is not better written; it is a different, worse agreement.

---

## 3. Stated precedence

**Requirement.** Every document family states which document governs when two conflict (for
example a master agreement over an order form, and an order form over a proposal), in each
document, in the same words.

**Why this rule exists.** Conflicts between documents are inevitable over a long engagement;
unstated precedence turns each one into a dispute.

---

## 4. Defined terms defined once

**Requirement.** A defined term is defined exactly once, in bold at its definition, and used in
exactly that form everywhere after. Near-synonyms are never used for a defined term ('the
Services' is never also 'the work'). Terms shared across a document family are listed in
`standards/style/terminology.md`, and every cross-reference resolves.

**Why this rule exists.** In an instrument, a second word for the same thing invites the
argument that it means a second thing.

---

## 5. Lead with the point; end with a way forward

**Requirement.** The first paragraph says what the document is for and what the reader must
decide or do. A long document opens with how to read it and a summary that holds everything
needed to decide, including every price. Every client-facing document ends with the next step.

**Why this rule exists.** The busiest reader reads the first page and the last line; a
document that buries its point makes them hunt for it, and they resent it.

---

## 6. The clarifying questions are the floor

**Requirement.** Before drafting, five facts are known, asked rather than assumed: the
counterparty's exact legal name (and company or charity number); the jurisdiction; whether the
audience is internal or external; what existing content or precedent applies; and the register,
formal or plain. These are the floor; `grilling` sharpens everything above it.

**Why this rule exists.** A guessed legal name voids a signature block, and a guessed register
produces a document that has to be rewritten rather than revised.

---

## 7. Every figure, date and commitment is traceable

**Requirement.** Every price, date, service level and commitment traces to its source (a
quotation, a schedule, an instrument clause) or is flagged `VERIFY` until it does. 'Shall'
imposes an obligation, 'may' grants a discretion, 'must' states a condition; each is chosen
deliberately, and no 'will' is left unbounded.

**Why this rule exists.** A figure nobody can trace is a figure nobody can defend when the
invoice is disputed.

---

## 8. A delivered document is a historical record

**Requirement.** Once a document has been sent or signed, it is never rewritten. A change is a
new version with a new filename and a row in its version-history table; the register row in
`planning/src/document-register.md` moves to the new version (`Version`, `File Path`, dates), and
the earlier file stays exactly as issued. A document replaced by a different document is set to
`Superseded`.

**Why this rule exists.** The version the client signed is the version that binds; editing it in
place destroys the only evidence of what was agreed.

---

## 9. A standard nobody has followed is a defect in the standard

**Requirement.** When a standard and the delivered documents disagree, find out which is the
outlier before 'fixing' anything, and take the disagreement to the author.

**Why this rule exists.** Delivered documents record what was actually agreed and accepted;
bringing them into line with an untested rule can undo decisions that were right.

---

## 10. The marks of running copy

**Requirement.** Running copy (proposals, letters, emails, articles, the explanatory text of a
policy) opens and closes as rule 5 says, and between them carries these marks:

1. **Show the work; do not claim the outcome.** Say what was done and what it showed.
2. **Concrete over abstract.** The thing itself, not 'solutions' or 'transformation' (rule 1).
3. **Active voice and the present tense, in the house person** (`standards/style/voice-notes.md`).
4. **Name the trade-off honestly.** Every option costs something; say what.
5. **Address a peer, not a lead.** No 'unlock', 'supercharge', 'level up' or 'game-changing'.
6. **Verbs over nouns, and no filler intensifiers** ('very', 'really', 'truly', 'simply', 'just').
7. **Short sentences carry the important ideas.**
8. **Plainly British:** 'tailored', not 'customized'; en_GB spelling throughout.

The business's own marks, and any mark here it sets aside, are recorded with their reasons in
`standards/brand/brand-voice.md` Section 3; where the two differ, that record wins for this
business. Legal instruments keep their formal register, and these marks reach into them only as
far as `brand-voice.md` Section 2 records.

> **Wrong:** 'An exciting, transformative solution that will unlock real value for your team.'
>
> **Right:** 'The rewrite cuts the handbook from ninety pages to forty, and each chapter now
> opens with the question it answers.' (with the figures flagged `VERIFY` until checked)

**Why this rule exists.** Marks are checkable where adjectives about a voice are not: `tone` can
report a broken mark by location, and a reader who has seen a hundred proposals hears the
difference at once.
