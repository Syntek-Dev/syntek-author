---
name: tone
description: >-
  Line-edit the voice of a business document: the house voice and plain English in running copy
  (the house marks in standards/method/BUSINESS.md rule 10 and the business's own in
  standards/brand/brand-voice.md; concision with its boundary; what a copy review keeps and what it
  tidies), microcopy terse and action-first, contracts and policies kept in their
  formal register, and the person ('I' or 'we') set in standards/style/voice-notes.md. Never changes
  a figure, date, scope boundary or commitment; anything that would is raised with the author
  instead. Gate V6.1 at line edit. Use when the author says 'tidy the tone', 'make this sound like
  us', 'is this too salesy?', 'de-jargon this', 'plain English pass on the proposal' or 'check this
  email before it goes'. Reports by location, then applies only what the author accepts. Not
  obligations or modal verbs (`obligation-check`); not defined terms (`clause-consistency`); not
  grammar or spelling (`grammar`, `spelling`); not reshaping a section (`improve-section`).
---

# Skill: Tone (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

A reader forms a view of the business from its documents before they meet anyone. This skill reads
a document for the house voice in the register its reader needs, reports each line that breaks a
mark, and proposes the change with a reason. It works only on **how** a sentence says things,
never **what** it commits to: every figure, date, scope boundary and commitment leaves a tone pass
exactly as it entered, and the skill proves it before it hands back.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`.
These are the procedure of record — do not restate them at length here.

- `library/workflows/05-review-a-document/` — step 10, where this skill is gate V6.1
  (`standards/verification/BUSINESS.md`); its guardrails say how an accepted change is applied.
- `standards/brand/brand-voice.md` — the voice standard this skill enforces: registers, the
  business's own marks and any house mark it sets aside, concision, what a review keeps and
  tidies, the highest-stakes copy.
- `standards/method/BUSINESS.md` — rules 1 (specificity over superlatives), 2 (shorten the
  writing, never the obligation), 5 (lead with the point; end with a way forward) and 10 (the
  marks of running copy).
- `standards/style/voice-notes.md` — the person the business writes in, and the marks learned
  from the author's own edits.
- `library/docs/reference/document-anatomy.md` — which families keep the formal register.

## How to run the tone pass

1. **Fix the scope and map the registers.** Agree with <%AUTHOR_FIRST_NAME%> which document, and
   mark each part with its register: **running copy** (proposals, letters, emails, articles),
   **microcopy** (subject lines, labels, short notices) or **formal** (the operative text of a
   contract or policy). Where `standards/brand/brand-voice.md` has not yet settled how far the
   brand voice reaches into instruments, treat every instrument as formal throughout and say so.
   *Complete when:* every part of the document has a register, and any unsettled register decision
   is named.

2. **Read the voice.** Read `standards/brand/brand-voice.md`, `standards/style/voice-notes.md`
   (the person, `## Learned`, what a review preserves), `standards/style/terminology.md` (product
   and trading-name casing, family terms) and the mechanics in `standards/style/style-sheet.md`.
   Note every voice decision still flagged `AUTHOR TO CONFIRM` in those files: the pass applies the
   house principles there and labels any finding that rests on an unconfirmed one.
   *Complete when:* the marks, the person, the casing and the open voice decisions are in hand.

3. **List what the pass must not touch.** Before reading for voice, list every figure, price,
   date, deadline, service level, scope boundary, commitment, defined term, clause reference and
   disclaimer in the document, with its exact wording. A change that would alter any of them is
   outside this skill: it is raised with the author, and the obligation is `obligation-check`'s.
   *Complete when:* the frozen list exists, with a count of each kind.

4. **Run the mechanical checks.** Run `make lint SCOPE=<the document's path>` for em dashes in
   client-facing copy (there must be none; en dashes in ranges are fine), lines holding two
   sentences and en_US spellings. Then search the running copy for filler intensifiers ('very',
   'really', 'truly', 'simply', 'just'), superlatives and buzzwords ('world-class', 'seamless',
   'unlock', 'leverage', 'solutions'), the wrong person ('we' in a singular voice, 'I' in a plural
   one), exclamation marks and wrong casing of the trading or product names. A word that is part of
   a defined term is not filler. *Complete when:* each check has a count and every hit a location.

5. **Read for the marks.** Read the running copy against the house marks of
   `standards/method/BUSINESS.md` rule 10 (show the work, concrete over abstract, active voice, the
   honest trade-off, a peer not a lead, verbs over nouns, short sentences for important ideas,
   plainly British), opening with the point and closing with a way forward (rule 5); then against
   the business's own marks in `standards/brand/brand-voice.md` Section 3, where an entry that sets
   a house mark aside wins. Then concision within its boundary (Section 4) and the highest-stakes
   copy (Section 7: claims and guarantees, pricing, errors and apologies, legal-adjacent copy).
   Read the formal parts only for plain-English slips the formal register allows; the brand voice
   never softens them. *Complete when:* every part has been read and each broken mark is recorded
   with its location and the rule or entry it breaks.

6. **Report.** Deliver the report below: numbered proposals by location, each with the line, the
   mark it breaks, the proposed change and a one-line reason, recurring items grouped, and the
   lines the pass deliberately leaves alone. *Complete when:* the author has the report and has
   accepted or rejected each proposal.

7. **Apply only what is accepted, then prove the frozen list.** Apply each accepted change as the
   review workflow's guardrails set: a slip (a dash, a spelling, a casing) as an agreed correction
   in the document, listed in the hand-back; a reworded sentence back through the library's adapt
   or improve workflow and promotion, so the section's ledger stays true. Log every accept and
   reject in the section's ledger entry. Then compare the frozen list from step 3 with the document:
   every item must be byte-identical. *Complete when:* the accepted changes are in, the frozen list
   is unchanged, and any difference has been reverted and reported.

8. **Hand back.** Report what changed, what was declined, any voice decision still open, and the
   frozen-list result. Run as gate V6.1, hand the verdict to the review workflow, which dates the
   gate in the brief's `verified:` map. *Complete when:* the author and, for a gate run, the review
   workflow have the result.

## The report

`# · Location · The line · Mark broken · Proposed change · Reason`, grouped where one decision
fixes many. Then **what the pass leaves alone** (directness, checkable claims, idiom, calm, an
honest limit, the next step) and **raised, not proposed**: any line where the voice problem sits
inside a figure, date, scope boundary or commitment, put to the author as a question.

Close with a verdict: **V6.1 pass or fail**, with the frozen-list check result.

## Anti-patterns

- **Changing a figure, date, scope boundary or commitment.** Even a 'friendlier' deadline is a
  changed promise; raise it instead.
- **Softening an instrument.** Brand voice does not reach into the operative clauses of a contract
  or the rules of a policy.
- **Cutting substance for concision.** A shorter document that has lost a limit, an exclusion or an
  answer the reader needed is not better written.
- **Rewriting the whole document.** Propose by line; the author's voice survives only if every
  change is visible and refusable.
- **Paraphrasing a disclaimer.** Its wording comes verbatim from `standards/brand/disclaimers.md`.
- **Inventing a voice.** Where the voice standard is still unconfirmed, say so; never fill it with
  a voice the author did not choose.

## Cross-references

- `standards/brand/brand-voice.md` — the voice standard; `standards/brand/disclaimers.md` — the
  trading name and disclaimer wordings.
- `standards/style/voice-notes.md` · `standards/style/terminology.md` ·
  `standards/style/style-sheet.md` — person, casing, mechanics.
- `standards/verification/BUSINESS.md` — gate V6.1, and V6.2 issue readiness after it.
- `.claude/skills/obligation-check/SKILL.md` — every commitment this pass must leave alone.
- `.claude/skills/learn-voice/SKILL.md` — turns the accepts and rejects logged here into voice
  notes.
- `.claude/skills/grammar/SKILL.md` · `.claude/skills/spelling/SKILL.md` — the mechanics after
  this pass.
