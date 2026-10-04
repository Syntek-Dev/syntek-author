---
name: chart-character-arc
description: >-
  Chart how a character changes across the novel and write it to planning/src/arcs/<slug>.md:
  the arc type (positive, negative or flat), the want against the need, the wound and the lie
  it taught, the truth reached, refused or tested, the turn where the lie can no longer be held,
  and every shift mapped to its chapter and section and tied to a causality beat. Also drafts
  the want, need, wound and lie as options when a new character is being created. The author
  chooses at every fork. Use when the author says 'chart Maren's arc', 'how does she change?',
  'what is his lie?', 'where is the turn?', 'is this arc positive or flat?', or 'her change feels
  unearned'. Not naming the character (`create-name`), not how they sound on the page
  (`character-voice`), not the causes of the beats themselves (`causality`), not facts about the
  character against the prose (`continuity`).
---

# Skill: Chart a character arc (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

An arc is the shape of a character's change: what they believe at the start, what the story costs
them, and what they believe at the end. The character's file in `world/src/characters/` records who
they are; the arc in `planning/src/arcs/<slug>.md` records how they move, beat by beat, mapped to
the sections where each shift happens, so the change is planned rather than hoped for. Every fork is
offered as options; the author chooses.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These
are the procedure of record — do not restate them at length here.

- `planning/workflows/04-chart-a-character-arc/` — charting or re-charting an arc; this skill is
  that procedure in skill form.
- `world/workflows/01-create-a-character/` — steps 3 (want, need, wound and the lie) and 9 (open the
  arc file) when a character is new.
- If a layer's `workflows/local/` holds a folder with the same `NN-name` as a procedure above,
  follow that procedure instead: the author's local procedure replaces the template's
  (`run-workflow`, step 2).
- `planning/docs/reference/character-arcs.md` — the three arc types and the arc file's shape.
- `standards/method/FICTION.md` — rule 2 (want against need) is the rule this skill enforces.

## How to chart an arc

1. **Read the character and the story so far.** Read the character's file in `world/src/characters/`
   (want, need, wound and the lie, voice markers, relationships), `planning/src/outline.md` and
   `planning/src/causality.md`. If an arc file already exists, read it and confirm a re-chart with
   the author before changing anything. If the character has no file, the job starts at the
   character procedure, not here. *Complete when:* the character's four drivers (want, need, wound,
   lie) are quoted from the file, or listed as missing.

2. **Settle want, need, wound and lie, if they are missing or weak.** Offer two or three options for
   each: the want (what they consciously pursue), the need (what they actually lack), the wound (the
   past harm) and the lie (the false belief the wound taught them). The want and the need must pull
   against each other; say so when they do not, rather than papering over it. The author chooses,
   and the character's file records the choice through the character procedure. *Complete when:* the
   file holds four drivers the author has agreed, and want and need pull apart.

3. **Choose the arc type with the author.** Positive (the lie given up for the truth, at a cost),
   negative (the truth refused or traded for the lie) or flat (the truth already held and tested;
   the world around the character changes). Offer the types the file supports, with what each would
   cost the story, and a recommendation with its reason. *Complete when:* the author has chosen the
   type.

4. **Name the truth and the gap.** State the truth the character reaches, refuses, or holds and is
   tested by, and the gap between want and need that the arc closes or widens. If the file's want,
   need or lie must change to make the arc work, stop and change the file with the author first.
   *Complete when:* the truth is one sentence and the gap is stated against the file.

5. **Find the turn.** Identify the beat where the lie can no longer be held (or, in a flat arc,
   where the truth is tested hardest), and say why it breaks there and not earlier. A turn that
   could move to any chapter has no cause yet. *Complete when:* the turn is placed at a chapter and
   section, with its reason.

6. **Map every shift to a section.** List, in order, each beat where the character's belief or
   behaviour shifts, each against its chapter and section, with one sentence on what shifts. Leave
   no long stretch in which the character neither moves nor is tested. Note where the voice should
   shift with the belief, so `character-voice` does not flag a planned change as drift.
   *Complete when:* every shift has a chapter, a section and a one-sentence change.

7. **Tie each shift to a cause.** For each shift, name the causality beat in
   `planning/src/causality.md` that forces it. Where none exists, chart it with `causality` through
   `planning/workflows/03-chart-the-causality/` before going on. *Complete when:* every shift cites
   a beat ID.

8. **Write the arc and link the file.** Check whether `planning/src/arcs/<slug>.md` exists; if it
   does, confirm before overwriting. Write it in the guide's shape (frontmatter `character`,
   `arc_type`, `world_entry`; then `## Shape`, `## The truth`, `## Beats`, `## The turn`,
   `## Open`), one sentence per line, citing the character's file rather than copying it, with every
   undecided point under `## Open` as `<!-- AUTHOR TO CONFIRM: … -->`. Set the character file's
   `arc:` to the arc's path. *Complete when:* the arc file exists and the file and the arc point at
   each other.

9. **Hand back.** Report the arc type, the truth, the turn and the open items; name the unit briefs
   whose `## Sections` should now mention the shifts they carry. Decisions that are hard to reverse
   go under the `Decisions` heading of `.claude/MEMORY.md` (mapped in `00-project.md`
   `## Memory headings`) through `grill-with-docs`. *Complete when:* the author has the report and
   the next procedure is named.

## Anti-patterns

- **Want equals need.** A character whose want is their need has no inner conflict; say so.
- **Copying the character file into the arc.** The arc cites want, need, wound and voice; a copy
  drifts from its source.
- **A turn with no cause.** Change that arrives because the plot needs it reads as unearned; every
  shift names its beat.
- **A long silence.** A character who neither moves nor is tested for several chapters has stalled,
  whatever the plot is doing around them.
- **Choosing the arc for the author.** Offer the options and their costs; recommend; let the author
  decide.
- **Overwriting an arc** without the author's confirmation, or re-charting one silently after prose
  relies on it.

## Cross-references

- `planning/src/arcs/` — one arc per character who changes.
- `world/src/characters/` — the character files each arc cites.
- `planning/docs/reference/character-arcs.md` — the arc types and the file shape.
- `.claude/skills/causality/SKILL.md` — the beat behind each shift.
- `.claude/skills/character-voice/SKILL.md` — checks the voice shifts where the arc says.
- `.claude/skills/create-name/SKILL.md` — names the character in the same procedure.
- `.claude/skills/grill-with-docs/SKILL.md` — records the decisions an arc settles.
