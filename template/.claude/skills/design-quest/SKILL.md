---
name: design-quest
description: >-
  Design a quest before its first scene is drafted and write it to planning/src/quests/<slug>.md:
  the goal, the stakes, the trigger, the obstacles and reversals in the order they are met, the
  cost and the reward, the arcs it moves, the causality beats it rests on, the world entries it
  relies on, and how it ends or why it is deliberately left open, so no quest dangles and no
  reward comes free. Use when the author says 'plan the journey to the mountain', 'design the
  search for the heir', 'what stands in their way?', 'this quest has no cost', 'is the side quest
  worth keeping?', or 'how does the bargain end?'. Not the causes of each beat (`causality`),
  not the character's change itself (`chart-character-arc`), not a creature met on the way
  (`create-creature`), not the structure of the whole book (`structure-review`).
---

# Skill: Design a quest (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

A quest is a sustained pursuit with a goal, a price and an ending: the journey to the mountain, the
search for the lost heir, the bargain that must be kept by midsummer. This skill plans one before
its first beat is drafted, tied to the arcs it moves and the causality beats it rests on, so it
neither wanders off the page unfinished nor pays a reward without a cost. The author decides every
part; the skill offers options and checks them against the world.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These
are the procedure of record — do not restate them at length here.

- `planning/workflows/05-design-a-quest/` — this skill is that procedure in skill form.
- If the layer's `workflows/local/` holds a folder with the same `NN-name` as the procedure above,
  follow that procedure instead: the author's local procedure replaces the template's
  (`run-workflow`, step 2).
- `planning/docs/reference/quest-design.md` — the parts of a quest and the quest file's shape.
- `planning/docs/reference/causality-chains.md` — how the trigger and reversals cite their beats.
- `standards/method/FICTION.md` — rules 1 (because and therefore), 4 (set-up and payoff) and 7
  (coincidence may make trouble, never resolve it).

## How to design a quest

1. **Read what the quest will touch.** Read `planning/src/outline.md`, `planning/src/causality.md`,
   the arcs in `planning/src/arcs/` of the characters involved, and the entries in `world/src/` for
   every creature, culture, people and place the quest will meet. If the quest file already exists,
   read it and confirm a redesign with the author. *Complete when:* the characters, world entries
   and beats the quest touches are listed, each with its file.

2. **Fix the goal and the stakes.** Agree what, concretely, is sought, and what is lost, and by
   whom, if the quest fails. A goal that cannot be pictured, or stakes nobody would mourn, are
   raised with the author before anything else is planned. *Complete when:* the goal is one
   picturable sentence and the stakes name who loses what.

3. **Find the trigger.** Name the beat that sets the quest going and why it happens now. Where no
   such beat exists in the chain, chart it with `causality` before going on. *Complete when:* the
   trigger cites a beat ID.

4. **Lay out the obstacles and the reversals.** List the obstacles in the order they are met, and
   the reversals where the quest turns against the seeker, each against the chapter that carries it
   and the beat that causes it. No obstacle is cleared by luck (method rule 7). *Complete when:*
   every obstacle and reversal has a chapter and a cause.

5. **Check the world's rules.** For each obstacle or aid drawn from the world, confirm it behaves as
   its entry in `world/src/` says. Report each conflict with both locations; the entry or the quest
   changes by the author's decision, never silently. *Complete when:* every world element the quest
   relies on has been compared, and each conflict is decided.

6. **Set the cost and the reward.** State what success, or failure, takes from the seeker, what it
   gives, and whether that is what they wanted. Flag an empty cost to the author. *Complete when:*
   the cost and the reward are each one or two sentences, or the empty cost is flagged.

7. **Tie it to the arcs.** Name each character whose arc the quest moves and the arc beat it
   carries; add any missing beat to the arc with `chart-character-arc` and the author. A quest that
   changes nobody is travel, and is flagged. *Complete when:* every tie names an arc and a beat, or
   the quest is flagged as changing nobody.

8. **Plan the ending.** Offer the author two or three ways the quest can resolve, with what each
   costs the story, and a recommendation with its reason. Record the choice under `## Ending`:
   `status: resolved` once it is drafted, or `left-open` with the reason the author gives.
   *Complete when:* the ending is chosen, or its deliberate openness has a reason.

9. **Write the quest and hand back.** Check that `planning/src/quests/<slug>.md` does not exist, or
   that the author confirmed a redesign. Write it in the guide's shape (frontmatter `title`, `slug`,
   `kind` main or side, `status`; then goal, stakes, trigger, obstacles, reversals, cost, reward,
   ties and ending), one sentence per line, undecided points flagged
   `<!-- AUTHOR TO CONFIRM: … -->`. Report the open items and the beats or arcs still to chart.
   *Complete when:* the quest file exists and the author has the report.

## Anti-patterns

- **A reward with no cost.** Flag it; a quest that takes nothing gives nothing.
- **An obstacle cleared by chance.** Coincidence may make trouble on the road, never end it.
- **Bending a world rule for convenience.** A creature or a place that behaves differently for the
  quest is a continuity fault; report it.
- **A quest that changes nobody.** Without an arc tie, it is a travelogue.
- **Silent loose ends.** A quest still open at the last chapter says why under `## Ending`, and the
  author confirms the reason.
- **Designing on the page.** Plan the quest when it is first planned, not when its first scene is
  being drafted.

## Cross-references

- `planning/src/quests/` — one file per quest.
- `planning/docs/reference/quest-design.md` — the craft this skill applies.
- `.claude/skills/causality/SKILL.md` — the trigger's and every reversal's cause.
- `.claude/skills/chart-character-arc/SKILL.md` — the arc beats a quest carries.
- `.claude/skills/create-creature/SKILL.md` — a creature the quest meets.
- `.claude/skills/continuity/SKILL.md` — checks the drafted quest against the world.
- `.claude/skills/structure-review/SKILL.md` — how the quests sit in the whole book.
