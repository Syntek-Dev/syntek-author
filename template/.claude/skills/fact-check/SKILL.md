---
name: fact-check
description: >-
  Sweep a unit or a section for checkable claims and verify each one against its primary source
  before it reaches a reader: figures, dates, quotations, references, study findings, legal and
  historical statements, descriptions of real people, places and organisations, and claims about
  the author. Returns exactly one verdict per claim (verified · verified-with-caveat · contested ·
  thin · cannot-be-dated · unsupported), writes an evidence entry for each, and leaves a VERIFY
  flag on anything not verified. Use when a draft states something a reader could check, at the
  fact-check stage of a review, before an export, or when the author says 'check this figure',
  'is that still true?', 'verify this quotation', 'fact-check chapter 4', 'can we say this?' or
  'where did this number come from?'. Not answering a wider question from several sources
  (`research`), not judging whether the argument or structure holds (`structure-review`), and not
  rewording the prose to the narrower claim (`adapt-section`).
---

# Skill: Fact-check (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

Establish whether each checkable claim is true, on what basis and as of when, before it reaches
the page. **A claim the work cannot defend is worse than no claim: cut it rather than hedge it.**
This skill reports and records; it never rewords the author's prose, and the only marks it leaves
in a draft or a unit are `VERIFY` flags. It runs on **Opus** throughout: whether a source supports
a claim is never mechanical (`.claude/rules/syntek-author/05-model-allocation.md`).

## Governing procedures (route here — do not restate at length)

Follow the procedure of record for each claim; these files own the rules, and this skill applies
them across a whole sweep.

- `research/workflows/02-verify-a-claim/` — **the procedure of record for one claim** (steps 3 to
  10 below are its steps 1 to 14, run claim by claim across the queue).
- The content layer's review workflow, step 'Fact check' (the mode file names it) — the sweep that
  passes gate V5 (`fact-check → line-edit`).
- `standards/verification/verification.md` V5, and the sub-gates its mode file adds at V5.
- `standards/method/method.md` rules 1 to 8 — evidence before prose, the basis, two dates, studies,
  contested evidence, legal claims, the one verdict vocabulary (rule 7), never fabricate.
- `research/docs/reference/vetting-evidence.md` — the five things a claim carries; the verdicts.
- `research/src/evidence/CONTEXT.md` — the evidence entry format.
- `.claude/rules/syntek-author/03-authorship.md` Sections 4 and 5 — never fabricate; the `VERIFY`
  flag and how it clears.

> **Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of
> `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain
> (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they
> disagree, the procedure wins and the disagreement is reported to the author.

## Steps

1. **Fix the scope and read the rules.** Name what is being checked: one claim, one section draft,
   or a whole unit (the content layer, see `.claude/rules/syntek-author/01-layout-and-routing.md`).
   Read `standards/method/method.md`, `research/docs/reference/vetting-evidence.md`, gate V5 in
   `standards/verification/verification.md` with its mode file, and the `Facts` heading of
   `.claude/MEMORY.md` (mapped in `00-project.md` `## Memory headings`), for claims about the
   author. For a single claim, the queue in step 2 has one item.
   *Complete when:* the scope is named in one line and the governing files have been read.

2. **Build the claim queue.** Read the scope sentence by sentence, footnotes and notes included,
   and list every checkable claim: a figure, a date, a quotation, a reference to a text, a named
   source, a study finding, a legal or regulatory statement, a historical claim, a description of
   a real person, place or organisation, a claim about the author, and the kinds the mode file
   adds. Add every `VERIFY` flag already in scope (`make flags SCOPE=<path>`) and any item under
   'Claims to verify' in the latest review of this unit in `planning/src/reviews/`. Each item
   carries its location (file, section marker, line) and the sentence verbatim. Arguments,
   opinions and the author's own conclusions are not claims to verify: leave them out and say so.
   *Complete when:* every checkable claim in scope is on the queue with its location, and the
   count is stated.

3. **Isolate each claim as one checkable sentence.** Strip the rhetoric until what remains could
   be true or false. **If a claim will not reduce to one checkable sentence, that is the finding:**
   record it and move on. Then search `research/src/evidence/` for an entry on the same claim: one
   checked within roughly twelve months is reused; an older one is re-checked and superseded;
   never start a second entry on the same claim.
   *Complete when:* every queue item is a checkable sentence, matched to a current entry, or
   recorded as not reducible.

4. **Name the basis each claim needs.** Before searching, write down what a complete answer looks
   like: what exactly is claimed · the source that owns the fact · when it was established · how
   it was established · its scope. A claim that cannot carry all five is decoration.
   *Complete when:* each open claim has its five-part basis written down.

5. **Reach the primary source, through `research`.** Dispatch `research`, which runs in a forked
   context, so its brief must carry everything: the claim as one sentence, the basis needed, the
   scope, and the rule that only a primary source that was opened and read counts. Batch claims on
   one subject into one dispatch. Follow every chain back to its origin; a report of a study is
   never cited when the study can be read. A search snippet, a model's answer or a summary nobody
   opened is a lead, not a source, and agreement among secondary sources is one source counted
   many times. A claim about the author goes to the `Facts` heading of `.claude/MEMORY.md`, then to
   the author. Wait for each research result before step 6; never assign a verdict while a
   dispatch is outstanding.
   *Complete when:* every dispatch has returned, and each claim has a primary source that was
   read, with its locator, or a recorded statement that none was found and where the chain ended.

6. **Record the dates, the limits and the conflations.** For each claim: the date the fact was
   established and the date it was checked (and the accessed date of any web page); for a study,
   its population, time span, method, effect size and **what it was not about**; for a legal
   claim, the jurisdiction and the date, with any unsettled point said plainly and no section
   number cited unread. Check the conflations in the guide and the mode file. When the evidence
   starts agreeing with the author, keep going, and note where going on changed the answer.
   *Complete when:* every claim's dates, limits and conflation checks are recorded.

7. **Assign exactly one verdict per claim.** One of `verified` · `verified-with-caveat` ·
   `contested` · `thin` · `cannot-be-dated` · `unsupported`, as `standards/method/method.md` rule 7
   defines them; no other word. **Never `verified` without a real source that was read.** A caveat
   comes with the narrower wording the work may safely use; a contest is summarised, never resolved
   or averaged; the last two verdicts recommend cutting. Where a fact tells against the work's
   argument or interest, say so plainly in the verdict.
   *Complete when:* every claim has one verdict from the six, with its usable wording where it
   narrowed.

8. **Write the evidence entries.** One entry per claim at `research/src/evidence/<topic>.md`,
   named for the claim's subject, in the format in `research/src/evidence/CONTEXT.md`; a claim
   that serves several units has one entry listing them all under `serves`. Never overwrite an
   entry: supersede it with a dated addition under `## History`. Where the project keeps the
   citation database, key the source with the add-reference skill in the same pass, then run
   `make dump` and `make refs`. A claim about the author that matches the `Facts` heading needs no
   entry unless an outside source is cited.
   *Complete when:* every verdict has its entry, no earlier entry was overwritten, and every key
   minted is recorded in its entry.

9. **Flag what the verdict does not cover, and clear what it does.** A claim is clear when its
   verdict permits the prose exactly as written: `verified`; `verified-with-caveat` where the prose
   already uses the usable wording; `thin` or `contested` where the prose already says so. Place
   one `VERIFY` flag at every other claim, in the form
   `.claude/rules/syntek-author/03-authorship.md` Section 5 gives for the file type, worded so that
   someone who was not there can act on it. Remove an existing flag only from a clear claim. Never
   change a word of the prose, and never delete a flag to pass a gate.
   *Complete when:* every claim that is not clear carries one flag at its location, every flag
   removed is listed with its entry, and no wording changed.

10. **Report and hand back.** One report to the author: the scope, the count of claims by
    verdict, then each claim by location (as checked, verdict, source, both dates, usable wording),
    with `unsupported` and `cannot-be-dated` first, then `contested` and `thin`, then
    `verified-with-caveat`. Recommend each cut or narrowing; the author decides, and agreed changes
    to the wording are made as the content layer's review workflow sets out (the mode file says
    how). V5 passes only when the gate's conditions hold; the review workflow, not this skill,
    moves the unit's status.
    *Complete when:* the author has the report, every recommendation names the procedure that would
    carry it out, and the flags that remain are listed.

## Anti-patterns

- **A verdict from plausibility.** Marking a claim `verified` because it sounds right, because a
  model said so, or because several secondary sources repeat it.
- **A figure, quotation, page, key or section number from memory**, or a source found to fit a
  sentence already written.
- **Hedging instead of cutting.** 'Roughly', 'some estimates suggest' and 'it is often said' do not
  repair a claim with no basis.
- **Averaging or resolving a contest**, or rounding a range into a headline.
- **Stopping at the first agreeable source.** That is where the evidence most often turns.
- **Rewording the author's sentence** to fit the evidence. The usable wording is offered, and the
  change is made only once the author accepts it, by the route the review workflow sets out.
- **Deleting a flag to pass a gate**, or inventing a verdict word ('solid', 'probably true').
- **Letting a fact settle a judgement.** A fact can narrow an argument; it never decides what the
  author concludes. Report the facts and where they run out.
- **Overwriting an evidence entry.** The history of a figure is itself evidence.

## Cross-references

- `.claude/skills/research/SKILL.md` — the forked, delegated search behind step 5.
- `research/src/evidence/` — where every verdict is recorded.
- `research/docs/reference/ingesting-sources.md` — reading a whole source rather than checking a
  claim.
- `.claude/skills/structure-review/SKILL.md` — the review stage before this one.
- `.claude/skills/comprehension/SKILL.md` — the line-edit stage that follows the fact gates.
- `.claude/MEMORY.md` — the `Facts` heading (mapped in `00-project.md` `## Memory headings`), the
  record claims about the author are checked against.
- `.claude/rules/syntek-author/06-global-rules.md` — locale, and Section 10 on confidential material.
