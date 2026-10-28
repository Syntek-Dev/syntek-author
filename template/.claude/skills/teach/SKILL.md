---
name: teach
description: >-
  Open a practice workspace under learning/ where <%AUTHOR_FIRST_NAME%> learns a skill without
  touching the real work: one concept per lesson at the edge of current ability, unaided recall
  before any re-reading, a worked practice piece with invented people and organisations, and a
  spaced review schedule kept in the topic's PROGRESS.md. Reads the project freely as reference;
  writes only inside its own topic folders in learning/. Invoke by typing /teach <topic>, or
  when <%AUTHOR_FIRST_NAME%> says 'teach me', 'I want to get better at', 'help me practise',
  'quiz me on' or 'pick up where my last lesson left off'. Not for re-explaining one reply that
  did not land (`wait-what`), not for drafting the real work (`draft-section`), not for resuming
  the real work (`run-workflow`), and not for a topic another template's teaching skill keeps.
---

# Skill: Teach (<%PROJECT_NAME%>)

Teach opens a **learning workspace** where <%AUTHOR_FIRST_NAME%> practises a skill without
touching the work. The posture is the inverse of a normal task: the goal is not a finished
artefact but a durable skill, built through **lessons** pitched at the learner's **zone of
proximal development**, drilled by **retrieval practice**, and consolidated on a **spaced
repetition** schedule. The project is read freely as reference; every draft, example and note
lands in the topic's own folder in `learning/` only.

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

## Governing procedures (route here — do not restate at length)

**No governing workflow.** This skill is a sandbox, not a step in any layer's procedures. What
governs it:

- `learning/CLAUDE.md` — the folder's operating rules; `learning/CONTEXT.md` — its layout.
- `.claude/rules/syntek-author/06-global-rules.md` Section 7 — supportive proofreading, which
  every recall answer receives; Section 10 — confidentiality.
- `.claude/rules/syntek-author/03-authorship.md` Section 4 — never fabricate, which a lesson does
  not relax: a source not to hand is named as missing, never recalled.

## The one rule: the project is read-only during a lesson

A lesson reads the real work, plans, research and standards as reference, and writes **only**
inside the topic's own folder ('Where a topic lives'). No practice piece is ever promoted, built,
registered, sent or left where it could be mistaken for the real thing.

Each topic is one folder, created at its first lesson (the layout is drawn in
`learning/CONTEXT.md`): `MISSION.md` (why this is being learned, the real goal, the family and
the `Template:` line), `RESOURCES.md` (the primary source and the house standard), `PROGRESS.md`
(the recall log and each lesson's next-review date) and `LESSONS/` (worked practice).

## Where a topic lives

Decide this each time the skill runs, from the answers files at the project root (the folder that
holds `.copier-answers.syntek-author.yml`), and never record the answer anywhere.

- **Alone or shared.** Another template shares the project while any other
  `.copier-answers.<template>.yml` stands at the root. Alone, a new topic is `learning/<topic>/`;
  shared, it is `learning/syntek-author/<topic>/`, in a folder made with its first topic and
  given no `CONTEXT.md` or `CLAUDE.md`: the `learning/` pair is its only manual.
- **What a topic is.** A topic is a folder holding a `MISSION.md` or a `PROGRESS.md`. A folder at
  the top of `learning/` named `syntek-author`, or named for the `<template>` of any answers file
  at the root, is a template's folder, never a topic.
- **Resume a topic where it stands.** Look for it in `learning/syntek-author/<topic>/` first, then
  in `learning/<topic>/`, and resume the first found; never move or copy a topic. Where a folder
  of that name at the top of `learning/` holds neither file (an adopted or hand-made record), ask
  whether it is this topic before starting another. Only a new topic goes into this template's
  folder.
- **Whose a topic is.** Each topic's `MISSION.md` names its template on a line of its own, in
  exactly this form for this skill's topics: `Template: syntek-author`. While another template
  shares the project, a topic at the top of `learning/` without the line is
  <%AUTHOR_FIRST_NAME%>'s to name: take its family as a hint only, ask once, and write the answer
  as its `Template:` line, the one line this skill writes in a topic that may not be its own.
  Never decide by which template was applied first.
- **Another template's topics follow its rules.** Another template's folder, and a topic whose
  `Template:` line names another template, are governed by that template's teaching skill and
  rules, never this one's, and stay <%AUTHOR_FIRST_NAME%>'s work: never resume, list or edit
  them. If <%AUTHOR_FIRST_NAME%> names one, say so and route to that template's teaching skill.
- **No topic is named after a template:** not `syntek-author`, and not the `<template>` of any
  answers file at the root. Where a new topic's folder would take such a name, ask for another.
- A redirect of `learning/` under `00-project.md` `## Overrides` carries all of this with it.

## How to teach

> **Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they disagree, the procedure wins and the disagreement is reported to the author.

1. **Clarify the mission.** Find the topic ('Where a topic lives') and read its `MISSION.md` if
   it exists. If it is missing or thin, ask why <%AUTHOR_FIRST_NAME%> wants this skill and what
   'can do it' looks like, in the grilling posture (`.claude/skills/grilling/SKILL.md` owns the
   shape: a round of questions, each with a recommended answer). Record the goal, the
   **family** from the mode file and, in a new topic, the line `Template: syntek-author`.
   *Complete when:* `MISSION.md` states the goal and the family in the author's own words, and a
   new topic's `MISSION.md` names its template.
2. **Assess the level; set the next lesson.** Read `PROGRESS.md` for what is consolidated, and look
   the real subject up in the project (the standard, the guide, the work that already does it
   well). Pick the **one** next lesson at the edge of the current level: a step that cannot yet be
   done alone but can with support. *Complete when:* the next lesson is named as a single,
   tightly scoped concept.
3. **Gather the resources.** Put in `RESOURCES.md` the **primary source** (through `research`
   where the subject is factual, legal or historical) and the **house source** the mode names for
   the family: the convention the author will practise in its real format. Cite; never
   paraphrase from memory, and if a source is not to hand, say so. *Complete when:*
   `RESOURCES.md` points at a primary source and the house standard for this lesson.
4. **Run the lesson: recall, then build.** Teach the concept, then close the loop:
   - **Retrieval practice:** pose a short recall question, wait for the answer, then confirm or
     correct. Effortful recall builds retention; a re-read only feels like it.
   - **Build to learn:** the author makes a small throwaway piece under `LESSONS/`, in the real
     house format, with **invented people, places and organisations only**.

   *Complete when:* the concept has been recalled unaided and a worked piece sits in `LESSONS/`.
5. **Capture the lesson; schedule the review.** Append to `PROGRESS.md`: what was learned, the
   recall result, any misconception to re-drill, and the next-review date on a widening curve
   (one day, three days, seven days, as DD/MM/YYYY). *Complete when:* `PROGRESS.md` holds a dated
   entry with a next-review date.
6. **Close the session cleanly.** Update `MISSION.md` and `RESOURCES.md` if the goal or sources
   shifted, and leave `PROGRESS.md` naming what is consolidated and what the next session opens
   on. *Complete when:* a fresh session could resume from the files alone, and nothing outside
   the topic's folder has changed but a `Template:` line the author named.

## Lesson design

- **One concept per lesson**, small enough to finish in a sitting.
- **Interleave:** bring recall from earlier lessons into a new one, so retrieval stays effortful.
- **Ground every lesson in the mission.** A lesson that does not move towards the stated goal is
  the wrong lesson; go back to step 2.
- **Quiz cleanly.** Phrase recall so the shape of the question does not give the answer away.
- **Recall is assessed on substance, never on spelling or arithmetic form.** An answer right in
  substance is right; reflect the correct form back naturally, and never comment on how an answer
  was written.
- **Cite the primary source** in the lesson, so the author can go deeper than the lesson does.

A topic can arrive from `wait-what`, through a teaching-detour handoff that already names the
opening lesson: that lesson is step 2's answer, so start there.

## Anti-patterns

- **Writing outside the topic's folder:** a practice section into the content layer, a mock
  entry into a register or a lexicon, a stray change to a standard, or a change to another
  template's lessons.
- **Practising on a real person, a real client or real figures.** A practice piece that names one
  will one day be found and read as real.
- **Asking what the project already answers.** Look it up first (step 2).
- **Re-reading in place of recall.**
- **Teaching ahead of the zone:** a lesson that cannot be attempted is wasted; one already mastered
  is a re-read.
- **A wall of lessons at once.** Teach one, drill it, schedule its review, then the next.
- **Promoting a practice piece.** A good one is a reason to write the real thing properly, through
  the authoring loop.
- **Moving a topic**, into this template's folder or out of it: it is resumed where it was begun.
- **Guessing whose a topic is** from which template came first.

## Cross-references

- `learning/CONTEXT.md` · `learning/CLAUDE.md` — the workspace and its rules.
- `.claude/skills/grilling/SKILL.md` — the questioning posture step 1 borrows.
- `.claude/skills/research/SKILL.md` — how a lesson's primary source is established.
- `.claude/skills/wait-what/SKILL.md` · `.claude/skills/handoff/SKILL.md` — the teaching detour
  a topic can arrive through.
