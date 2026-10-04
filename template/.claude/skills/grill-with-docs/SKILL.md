---
name: grill-with-docs
description: >-
  Grill a design and record what it settles: the grilling interview, in frontier rounds with a
  recommended answer on every question, writing each decision into its existing home the moment
  it resolves (the unit brief, the plan files the mode names, terminology, and
  `.claude/MEMORY.md` through the decision gate). The design-work default: the opening move for
  planning a unit, settling an argument, a plot turn, a world element, a language's real-world
  model or a document's scope. Invoke by typing /grill-with-docs, or when <%AUTHOR_FIRST_NAME%>
  says 'let's plan chapter four', 'settle the scope of this proposal', 'decide what this language
  should sound like', 'work out the ending and write it down'. Not for a conversation that must
  leave no trace (`grill-me`), not for work too big for one sitting (`wayfinder`), and never for
  an empirical question (`fact-check`).
---

# Skill: Grill-with-docs (<%PROJECT_NAME%>)

Run a grilling session that leaves a paper trail. `.claude/skills/grilling/SKILL.md` is the engine
and its mode file is the domain: **they own the round shape, the question format, the
recommendation rule and the surfaces; this file owns only where each answer is written.** As each
decision resolves, record it in the right **existing** artefact. Never invent a new format, and
never a new file where a section of an existing one will do.

This file also keeps the **decision gate** that `.claude/MEMORY.md` points to. Memory headings are
named here as the template names them (`Decisions`, `Facts`, `Open questions`); the project's own
heading for each is mapped in `00-project.md` `## Memory headings`.

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

## Governing procedures (route here — do not restate at length)

Follow the procedure's `STEPS.md` against its `CHECKLIST.md`; this skill is its questioning and
recording in skill form.

- `planning/workflows/01-plan-a-unit/` — steps 3 to 9: the questioning (3 to 7), the brief and
  gate V1 (8), and the recording (9).
- `planning/workflows/09-review-the-whole-work/` — step 6: the author decides; this records it.
- `.claude/rules/syntek-author/08-naming-and-memory.md` Sections 2 to 4 — where a decision lives,
  the memory gate, and the entry form.
- `.claude/rules/syntek-author/06-global-rules.md` Sections 3, 8 and 9 — never self-edit; design
  opens with grilling; internal notes for deliberate deviations.
- `planning/docs/reference/unit-briefs.md` — the brief's frontmatter and body slots.

The mode file adds the doc-type procedures and their records.

## Where each decision goes

| When a decision… | Record it in |
|---|---|
| settles a unit's scope, its job, its sections or what it draws on | the brief, `planning/src/units/<unit>.md`: `## Scope`, `## What this unit does`, `## Sections`, `## Draws on` |
| commits the unit to a position | the brief's settled-positions slot (the mode names it) |
| is a note for whoever drafts the unit, or a change the author declined and why | the brief's `## Draft notes` |
| changes the shape or the order of the whole work | `planning/src/outline.md` |
| is project-wide and passes the decision gate below | `.claude/MEMORY.md`, the `Decisions` heading, dated |
| is a fact a later session needs and cannot read off the files | `.claude/MEMORY.md`, the `Facts` heading |
| is still open, and only the author can settle it | `.claude/MEMORY.md`, the `Open questions` heading, naming what it blocks |
| pins a term: one canonical word per concept | `standards/style/terminology.md`, rejected synonyms under **Avoid** |
| authorises a departure from a standard in one artefact | that artefact's internal note |
| sets a rule for one folder, on the author's explicit word | that folder's `CLAUDE.md` |
| changes a standard | the standard, **author-confirmed first, always**, then noted in `MEMORY.md` |

The mode file adds the rows for this kind of project. A decision settled on a decision map lands
in its home here, and the map's `Resolved decisions` entry links to it.

## The decision gate

A decision enters the `Decisions` heading of `.claude/MEMORY.md` **only when all three hold
together**: it is **hard to reverse**, it would be **surprising without its context**, and it
settled a **genuine trade-off**. It must also pass the memory gate (needed again, not readable off
the files, costly if wrong: `.claude/rules/syntek-author/08-naming-and-memory.md` Section 3). That
keeps the log signal-dense enough to be read. A decision that fails the gate is still written down,
in the narrower home the table gives it; say which.

## Steps

> **Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they disagree, the procedure wins and the disagreement is reported to the author.

1. **Load the engine, and read the homes.** Read `.claude/skills/grilling/SKILL.md` and its mode
   file, run its step 1, and read every home in the tables above that this subject touches, so a
   decision already recorded opens the round as a `Settled` line. *Complete when:* the engine's
   step 1 is done and every relevant home has been read.
2. **Grill in frontier rounds.** Follow the engine exactly; this skill changes nothing about the
   rounds. *Complete when:* each round has gone out in the engine's format and its answers are
   restated and confirmed.
3. **Record each decision the moment it resolves.** Write it inline, in its home, before the next
   round, not batched at the end: a session that stops early should still have left every settled
   decision where it belongs. Write only what <%AUTHOR_FIRST_NAME%> has confirmed; an inferred
   conclusion written down is worse than none, because later sessions treat it as settled.
   *Complete when:* every confirmed decision sits in its home, and nothing unconfirmed was written.
4. **Gate anything bound for `MEMORY.md`.** Apply the decision gate and the memory gate; write a
   passing entry in the house form (`- **DD/MM/YYYY** — **Headline.** Body, including why and
   what was rejected.`), superseding rather than deleting an older one. *Complete when:* every
   `MEMORY.md` entry passed both gates, and every decision that failed went to its narrower home.
5. **Close with the summary and the record.** Summarise the settled design, get the explicit yes,
   then list each file written and the decision it now holds; anything left open is under the
   `Open questions` heading. *Complete when:* the yes is given, the list is reported, and nothing open is
   held only in the conversation.
6. **Agree the brief (a unit being planned).** When the subject is a unit, write or complete its
   brief as `planning/workflows/01-plan-a-unit/` step 8 sets out: the guide's shape,
   `status: idea`, `verified: {}`, every section at `status: ""`, and the six body slots, one
   sentence per line. Read it back to <%AUTHOR_FIRST_NAME%> and apply the corrections. Only on
   the author's agreement has V1 (idea → outlined) passed: set `status: outlined` and record `V1`
   with today's date (DD/MM/YYYY) in `verified`. Any other subject skips this step.
   *Complete when:* the author has agreed the brief and V1 is dated, or the subject is not a unit.

## Guardrails

- **Never record a decision the author has not confirmed.**
- **Never settle an empirical question by grilling.** Route it to `fact-check` or `research` and
  record what comes back, with its verdict.
- **A standards change is author-confirmed, always**, and so is any change to a folder `CLAUDE.md`
  (`.claude/rules/syntek-author/06-global-rules.md` Section 3).
- **The internal note is load-bearing.** A deviation the author authorises is recorded in the
  artefact itself as well as its wider home, naming the rule, the reason and the date, so a later
  pass does not 'correct' it back.
- **Record a declined proposal where the next session will meet it**, so the same suggestion is
  not made again next month.

## Anti-patterns

- **Batching the record at the end.** The session that collapses before the summary loses it all.
- **A new file for one decision** when a section of an existing artefact is its home.
- **Writing everything to `MEMORY.md`.** A log that records every choice is a log nobody reads.
- **Restating the engine's round shape** instead of following it.

## Cross-references

- `.claude/skills/grilling/SKILL.md` — the engine this runs, and its mode file.
- `.claude/skills/grill-me/SKILL.md` — the stateless twin that records nothing.
- `.claude/skills/wayfinder/SKILL.md` — sends map nodes here, and links to where they land.
- `.claude/MEMORY.md` — the log the decision gate protects.
- `standards/style/terminology.md` — the home of every pinned term.
