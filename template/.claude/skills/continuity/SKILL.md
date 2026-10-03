---
name: continuity
description: >-
  Check fiction prose against the story bible and report every contradiction: the continuity
  ledger (planning/src/continuity.md), the timeline, the world files, the names register and,
  where a constructed language exists, its lexicon. Each finding gives both locations and a
  question for the author; nothing is silently repaired in either direction. New facts the prose
  establishes are proposed for the ledger with their section references. Runs gate V4.1 at
  structural review. Use when the author says 'check continuity on chapter 4', 'does this
  contradict the bible?', 'is the ferryman's eye the same as in chapter 2?', 'run the continuity
  pass', or 'what facts does this chapter establish?'. Not charting why beats happen
  (`causality`), not how a character sounds (`character-voice`), not real-world accuracy
  (`fact-check`), not a whole-book structural review (`structure-review`).
---

# Skill: Continuity (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

The story bible says what is true; the prose shows it. This skill reads the two side by side and
reports every place where they disagree, so the author decides which one is wrong. It is a report,
not a repair: a silent fix in either direction can undo the author's deliberate change of mind and
destroys the record of what the reader has already been told. It also lists the facts the prose has
newly established, so the ledger keeps up with the book.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These
are the procedure of record — do not restate them at length here.

- `manuscript/workflows/05-review-a-chapter/` — the structural stage, where this skill runs gate
  V4.1 (steps 4 and 5).
- `planning/workflows/03-chart-the-causality/` — where proposed facts enter the ledger before a
  chapter is drafted (step 8).
- `standards/method/FICTION.md` — rules 5 (point-of-view knowledge) and 6 (the story bible is the
  source of truth) are the rules this skill enforces.
- `standards/verification/FICTION.md` — gate V4.1 and its rule that contradictions are reported,
  never repaired.
- `world/docs/reference/story-bible.md` — what belongs in which file, and when a fact is frozen.
- `planning/src/continuity.md` — the ledger's own writing rules (IDs, kinds, supersession).

## How to check continuity

1. **Fix the scope and the occasion.** Agree with the author which chapter (its file in the content
   layer) or which section draft is checked, and why: gate V4.1 in the review workflow, or an early
   check of a draft before promotion. Read the chapter's brief in `planning/src/units/`: its
   `## Continuity facts`, its `sections:` list and its `verified:` record. *Complete when:* the
   scope, the occasion and the brief are named back to the author.

2. **Load the record before reading a line of prose.** Read `planning/src/continuity.md`
   (established and proposed rows), `planning/src/timeline.md` (its calendar and rows),
   `world/src/names-register.md`, and the rows of `planning/src/causality.md` whose `Where` falls in
   scope. Then read the world file of every character and place the scope names; where the
   worldbuilding kit is installed, also of every creature, culture and people, and the history files
   for any past event the scope recalls (keeping what happened apart from what each people
   remembers). Where the constructed-language kit is installed, read the `lexicon.toml` of each
   language the scope uses. Read any setting note in `research/src/setting/` that records a
   deliberate departure from the real world. *Complete when:* every entity the scope names has been
   looked up, and those with no file or no register row are listed.

3. **Sweep the prose section by section.** Work through the chapter in marker order
   (`<!-- section: <slug> -->`). Test every stated fact against the record: appearance, age,
   kinship, possessions, injuries, the geography and distances of places, travel times, time of day
   and season, the rules of the world, and who knows what by this point in the story. A
   point-of-view character who knows something the timeline says they cannot yet know is a finding
   too (method rule 5). *Complete when:* every section in scope has been swept, and each finding
   carries the prose location (unit, section and a short quotation) and the record location (file,
   and row ID or heading).

4. **Check every name and invented word.** List each capitalised invented name and each invented
   word in the scope. Each must match a register row exactly, or a lexicon headword where a
   constructed language is in use; flag an unregistered name, a variant spelling, a near-miss of a
   registered name, a retired name, and an invented word used in a sense its entry does not give.
   *Complete when:* every invented name and word in scope is either matched or listed as a finding.

5. **Report, blocking first, and change nothing.** Deliver one table, contradictions first, then
   timeline faults, names and words, knowledge slips and new facts:
   `# · Kind · The prose says (where) · The record says (where) · Question for the author`. Where a
   record fact is already frozen (established by promoted prose), name every section from the ledger
   that relies on it, so the cost of changing it is visible. Offer the two directions for each
   contradiction (change the prose, or change the record) and the procedure that owns each; never
   choose. *Complete when:* the report is delivered and no prose, world file or ledger row has been
   edited.

6. **Record the author's decision on each item.** For each contradiction the author decides: a prose
   change goes back through the content layer's adapt, improve and promote workflows; a record
   change supersedes the ledger row (mark it `(superseded by F0NN)` and add the new row, never edit
   the old one) or edits the world file through its workflow; a deliberate inconsistency (a lie, a
   misremembering, an unreliable narrator) is written into the Notes column of the ledger row it
   touches, so the next pass does not flag it again. *Complete when:* every item in the report
   carries a dated decision and its record exists.

7. **Propose the new facts.** For each fact the scope establishes that the ledger lacks, draft a row
   for `## Proposed` (`Fact · Kind · Proposed from · Notes`, kind one of
   `character · place · object · rule · relationship · time`, proposed from
   `<unit> · <section-slug>`), and the event rows `planning/src/timeline.md` lacks. Write them only
   on the author's word. A proposed fact moves to `## Established facts`, with the next free `F` ID,
   only when its section is promoted or the author decides it. *Complete when:* every new fact is
   either written as a proposed row with its section reference, or declined by the author.

8. **Hand the gate back.** V4.1 passes when every contradiction has been put to the author and
   decided, and every new fact has been proposed. Report the counts (contradictions, decided, facts
   proposed, names to register) to the review workflow, which dates the gate in the brief's
   `verified:` map. Names still unregistered go to `create-name` before the chapter moves on.
   *Complete when:* the review workflow has the result, and anything still open is named with its
   owner.

## Anti-patterns

- **Repairing silently.** Changing a word of prose, a world file or a ledger row to make them agree.
  The author decides which side is wrong; this skill only shows that they disagree.
- **Treating the record as always right.** The prose may hold the author's later, better idea. Ask;
  never assume the bible wins.
- **Checking against memory.** 'Chapter 2 said he had one eye' is a guess until the ledger row or
  the section is cited. A finding with no record location is not a finding.
- **Flagging belief as fact.** A character who believes something false, or lies, is not a
  contradiction. Check whose belief it is before reporting it.
- **Inventing a bridging fact.** If two records can only be reconciled by a fact nobody decided, ask
  for it with `<!-- AUTHOR TO CONFIRM: … -->`; never supply it.
- **Promoting a proposal.** A proposed fact is not established until its section is promoted or the
  author decides it. Never give it an `F` ID early.
- **Editing or renumbering ledger rows.** Rows are superseded, never edited or deleted; IDs are
  never reused.
- **Drifting into style.** Voice, pacing and spelling have their own passes; a continuity report
  that mixes them hides its contradictions.

## Cross-references

- `planning/src/continuity.md` — the ledger: established and proposed facts with their sections.
- `planning/src/timeline.md` — in-story time, travel and ages.
- `world/src/names-register.md` — every invented name, with its spelling and status.
- `world/src/characters/` and `world/src/places/` — the bible entries prose is checked against.
- `.claude/skills/causality/SKILL.md` — the beats and their causes, gate V4.2 beside this one.
- `.claude/skills/character-voice/SKILL.md` — how characters sound, at line edit.
- `.claude/skills/create-name/SKILL.md` — registers a name the sweep found unregistered.
- `.claude/skills/fact-check/SKILL.md` — real-world detail, at gate V5.
- `.claude/skills/structure-review/SKILL.md` — the structural review this gate sits inside.
