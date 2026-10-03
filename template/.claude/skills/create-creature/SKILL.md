---
name: create-creature
description: >-
  Create a creature for the world and write its bestiary entry in world/src/creatures/: its job
  in the story, ecology, anatomy and behaviour, rules and limits, weaknesses (each tied to its
  set-up), lore attributed to the peoples who hold it, its names in each people's tongue, and
  its role in the story, all checked against the world's established rules before anything is
  written. Contradictions are reported, never smoothed over. Use when the author says 'I need a
  creature for the marshes', 'what hunts in the pass?', 'make the river-thing real', 'give the
  wyrm some limits', 'what do the hill folk call it?', or 'does this beast fit the world?'. Not
  naming it alone (`create-name`), not planning the quest it appears in (`design-quest`), not
  checking chapters that mention it against its entry (`continuity`). Not a people, race or
  speaking species, whose file belongs in world/src/peoples/ (world/workflows/10-create-a-people/,
  through `run-workflow`).
---

# Skill: Create a creature (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

A creature in a novel is a set of rules the story promises to keep. The reader learns what it can
do, and the plot later depends on what it cannot. This skill builds the entry in that order: the
job, then the ecology that makes it believable, then the limits that make it useful to a plot, then
the lore people tell about it, and checks every part against the world before the entry is written.
Every fact is offered as options; the author chooses.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These
are the procedure of record — do not restate them at length here.

- `world/workflows/04-create-a-creature/` — this skill is that procedure in skill form.
- If the layer's `workflows/local/` holds a folder with the same `NN-name` as the procedure above,
  follow that procedure instead: the author's local procedure replaces the template's
  (`run-workflow`, step 2).
- `world/docs/reference/creatures.md` — the entry's sections, ecology first, lore against truth.
- `standards/method/FICTION.md` — rules 4 (set-up and payoff) and 6 (the story bible is the source
  of truth).
- `standards/risk/FICTION.md` — rules 4 (representation is researched, not assumed) and 7 (sacred
  terms and holy names are never lifted), for a creature drawn from a living people's beliefs.

## How to create a creature

1. **Fix the creature's job in the story.** Ask the author what it is for (threat, companion,
   resource, omen, wonder, an obstacle in a quest), the scenes it appears in and the plot moments
   that depend on it. *Complete when:* the job, the scenes and the dependent moments are named back
   to the author.

2. **Read the world it must live in.** Read `world/src/names-register.md`, every entry in
   `world/src/creatures/`, the places it would live in (`world/src/places/`), the cultures and
   peoples who know it (`world/src/cultures/`, `world/src/peoples/`), the world's history where its
   range or numbers changed (`world/src/history/`), `planning/src/continuity.md`, and any quest in
   `planning/src/quests/` that involves it. *Complete when:* the established rules it must respect
   are listed, each with its file.

3. **Settle its ecology.** Habitat, diet, what hunts it, how it breeds, how long it lives, how many
   there are and why they have not emptied the valley. Offer options where the author has not
   decided, each checked against the place files it would live in. *Complete when:* every ecology
   question has an agreed answer or a flag.

4. **Settle its anatomy and behaviour.** A body that fits its ecology (size, senses, how it moves),
   then what it does when hungry, threatened, mating, wounded and alone. Strangeness is welcome;
   each strange feature has a reason in how it lives. *Complete when:* every feature has its reason
   and every behaviour its trigger.

5. **Fix its rules, limits and weaknesses.** Write each ability with its cost, and each limit as a
   hard rule the book will keep ('cannot cross running water'). For every weakness the plot will
   use, find its set-up in `planning/src/causality.md`; where none exists, list it for the
   hand-back, because a weakness that appears only when it is needed reads as a cheat.
   *Complete when:* every ability has a cost, every limit is a testable rule, and every plot-used
   weakness has a set-up or is listed.

6. **Record its lore and its names.** What each people believes about it, attributed to that people
   and marked where it is wrong; a character knows only what their people believe. Where the lore
   draws on a real people's beliefs or sacred figures, say so and run the checks of rules 4 and 7 of
   the fiction risk standard. For the names, one per people that knows it, run the steps of
   `create-name`: options with IPA and a respelling, checked against the register, chosen by the
   author. *Complete when:* every belief carries its holder, every name is chosen, and any real
   source of lore has been checked.

7. **Check it against the world.** Compare the finished draft with every rule listed at step 2.
   Report each contradiction with both locations and a question for the author; adjust neither side.
   *Complete when:* every listed rule has been compared and each contradiction is decided by the
   author.

8. **Write the entry.** Check that `world/src/creatures/<slug>.md` does not exist; if it does, stop
   and ask. Write it from the skeleton in `world/src/creatures/CLAUDE.md`, one sentence per line,
   `first_appears` empty, undecided points flagged `<!-- AUTHOR TO CONFIRM: … -->`. *Complete when:*
   the entry exists with every section of the skeleton.

9. **Register the names and hand back.** Add one row per name to `world/src/names-register.md` (kind
   `creature`), then report the entry written, the names registered, every weakness still lacking a
   set-up, any quest that should link to the creature, the contradictions found and the open flags.
   *Complete when:* the rows exist and the author has the report.

## Anti-patterns

- **Powers before ecology.** A creature with no ecology reads as a plot device, because it is one.
- **An ability without a cost, or a limit the plot later breaks.** Every broken rule costs the
  reader's trust in every other rule.
- **A weakness with no set-up.** The climax that relies on it needs it planted where the reader
  could have noticed.
- **Lore stated as fact.** Belief belongs to the people who hold it; the true account sits in the
  other sections.
- **Smoothing a clash with a place or a culture.** Report it; the author decides which side changes.
- **Depth nobody uses.** An unused ability is a promise the plot did not make.
- **Lifting a living people's sacred being as decoration.** Flag it under rule 7 of the fiction risk
  standard and offer an alternative.

## Cross-references

- `world/src/creatures/` — the bestiary, and its entry skeleton in its `CLAUDE.md`.
- `world/docs/reference/creatures.md` — the craft this skill applies.
- `planning/src/causality.md` — where each weakness's set-up and payoff are tied.
- `.claude/skills/create-name/SKILL.md` — the creature's names, one per people.
- `.claude/skills/design-quest/SKILL.md` — the quests a creature stands in.
- `.claude/skills/continuity/SKILL.md` — checks the chapters against the entry.
