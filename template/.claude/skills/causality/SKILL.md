---
name: causality
description: >-
  Make every beat of the story cite its cause: 'because' or 'therefore', never 'and then'.
  Charts a chapter's beats into planning/src/causality.md before drafting (each beat with its
  Because, its Therefore, its place in story time and its set-up or payoff), and checks drafted
  prose against the chain at structural review (gate V4.2), flagging coincidence that resolves
  trouble, beats with no cause, payoffs with no set-up and set-ups left dangling. Use when the
  author says 'chart the causality for chapter 5', 'why does this happen?', 'this scene just
  happens', 'check the chain', 'is this a coincidence?', or 'run the causality pass'. Not facts
  and contradictions against the bible (`continuity`), not scene length and tension (`pacing`),
  not how a character changes (`chart-character-arc`), not a whole-book structural review
  (`structure-review`).
---

# Skill: Causality (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

A sequence of events is a chronicle; a chain of causes is a plot. This skill keeps the chain: every
beat in `planning/src/causality.md` names what caused it and what it makes necessary next, so a
scene that merely happens next is seen before it is written, not felt by a reader after it is
published. It works in two modes. **Chart** happens before a chapter is drafted and writes the
agreed rows. **Check** happens at structural review and reads the drafted prose against the chain,
reporting only.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These
are the procedure of record — do not restate them at length here.

- `planning/workflows/03-chart-the-causality/` — chart mode; this skill is that procedure's check in
  skill form.
- `manuscript/workflows/05-review-a-chapter/` — check mode, gate V4.2 at the structural stage (steps
  4 and 5).
- `planning/workflows/04-chart-a-character-arc/` — step 6 ties each arc shift to a beat here; the
  quest procedure, where the worldbuilding kit is installed, does the same for a quest's trigger and
  reversals.
- If a layer's `workflows/local/` holds a folder with the same `NN-name` as a procedure above,
  follow that procedure instead: the author's local procedure replaces the template's
  (`run-workflow`, step 2).
- `standards/method/FICTION.md` — rules 1 (because and therefore), 4 (set-up and payoff) and 7
  (coincidence may make trouble, never resolve it).
- `standards/verification/FICTION.md` — gate V4.2.
- `planning/docs/reference/causality-chains.md` — the columns, IDs and the coincidence rule.

## How to keep the chain

1. **Fix the scope and the mode.** Agree the chapter with the author and whether this is chart (no
   prose yet, or a re-plan) or check (drafted prose at gate V4.2). Read the chapter's brief in
   `planning/src/units/`. *Complete when:* the chapter, the mode and the brief are named back to the
   author.

2. **Read the chain as it stands.** Read `planning/src/causality.md` (the chain and
   `## Open setups`), `planning/src/timeline.md`, `planning/src/continuity.md` and the arcs of the
   characters the chapter turns. Note the last beat ID in use; IDs run on from it. *Complete when:*
   the next free `B` ID and the open set-ups that touch this chapter are listed.

3. **List the beats.** In chart mode, list with the author each beat the chapter carries, one
   sentence each, against the section that will carry it; a section with no beat has no job, and one
   with four is probably two sections. In check mode, extract the beats the prose actually carries,
   section by section in marker order, and set them beside the charted rows. *Complete when:* every
   section in scope has its beats listed in one sentence each.

4. **Give every beat its cause.** `Because` is an earlier beat ID, a named character's decision, or
   a rule of the world with its entry in `world/src/`. Test each link between consecutive beats by
   saying it aloud with 'because', 'therefore' or 'but'; where only 'and then' fits, the beat has no
   cause yet. Ask the author for any cause you cannot find; never invent one to fill the cell.
   *Complete when:* every beat has a real cause, or is flagged with the question for the author.

5. **Give every beat its consequence.** `Therefore` is what the beat makes necessary or possible
   next. A beat with no consequence is either a set-up (step 7) or a candidate for cutting, and the
   author decides which. *Complete when:* every beat has a consequence, or is marked set-up, or is
   put to the author as a cut.

6. **Test for coincidence.** Chance may put a character into trouble; it may never get them out.
   Flag every beat where luck, a timely arrival or a convenient discovery resolves a problem. A
   coincidence the author keeps is recorded in `.claude/MEMORY.md` `## Decisions` with their reason,
   so a later pass does not 'fix' it. *Complete when:* every resolving beat has been tested, and
   each flagged coincidence is decided.

7. **Pair set-ups with payoffs.** Each beat that plants something names its payoff beat, or goes
   under `## Open setups`. Each payoff names a set-up that comes earlier in the telling, not only
   earlier in story time: a payoff whose set-up the reader meets later reads as a cheat.
   *Complete when:* every set-up is paired or listed open, and every payoff has a set-up the reader
   meets first.

8. **In check mode, compare the page with the chain.** Report the beats the prose carries that the
   chain lacks, the charted beats the prose never delivers, and every cause the chain records but
   the page never shows, because a cause the reader cannot see does not work. Report, blocking
   first: `# · Where · Beat · The fault · Question for the author`. Change no prose.
   *Complete when:* the report is delivered and no prose or row has been edited without the author's
   word.

9. **Write the agreed rows and hand back.** On the author's word, write the rows: new IDs in
   sequence, one sentence per cell, a cut beat marked `(cut)` and never deleted; each beat's event
   placed in `planning/src/timeline.md` by story time with `Told in` set; each fact a beat
   establishes proposed under `## Proposed` in `planning/src/continuity.md` and in the brief's
   `## Continuity facts`, never as established. In check mode, gate V4.2 passes when every beat
   cites its cause, no coincidence resolves trouble unrecorded, and every set-up is tracked; report
   the result to the review workflow, which dates the gate. *Complete when:* the agreed rows exist,
   the open flags are reported, and the next procedure is named (drafting a section, or charting an
   arc where a beat turns a character).

## Anti-patterns

- **Accepting 'then' as a cause.** A beat whose only cause is the beat before it in time has not
  been charted.
- **Inventing a cause to fill the cell.** An empty `Because` is a question for the author, not a gap
  for the skill to fill.
- **Letting luck resolve.** A rescue by coincidence tells the reader the author solved the problem;
  flag it, every time, unless the author has recorded keeping it.
- **Confusing story time with telling order.** The chain runs in causal order, the timeline in story
  time; they differ wherever the telling is out of order, and that is allowed.
- **Repairing the prose to fit the chain.** In check mode the author decides whether the page or the
  chain is wrong.
- **Renumbering or deleting beats.** IDs are permanent; a cut beat keeps its row, marked.
- **Entering facts as established.** A beat proposes facts; promotion or the author's decision
  establishes them.

## Cross-references

- `planning/src/causality.md` — the chain and the open set-ups.
- `planning/src/timeline.md` — where each beat's event sits in story time.
- `planning/src/continuity.md` — where the facts a beat establishes are proposed.
- `.claude/skills/continuity/SKILL.md` — the prose against the bible, gate V4.1 beside this one.
- `.claude/skills/chart-character-arc/SKILL.md` — arc shifts, each tied to a beat here.
- `.claude/skills/pacing/SKILL.md` — whether the beats land at the right speed.
- `.claude/skills/structure-review/SKILL.md` — the structural review this gate sits inside.
- `.claude/skills/grill-with-docs/SKILL.md` — settles a cause the author has not yet decided.
