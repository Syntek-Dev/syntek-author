@./CONTEXT.md

# CLAUDE.md — learning/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the topic layout, imported above) → this file → the topic's `MISSION.md` and `PROGRESS.md`.

## Purpose (one line)

A safe practice workspace where a skill is built across sessions without touching the real work.

## How to work here

- **Routing:** the `teach` skill owns the session's shape. Load whatever skill or standard is
  being practised, so the practice happens in the real house format.
- **Model:** **Opus**: pitching a lesson at the right level is judgement, and pitching it wrong
  wastes the session.
- **Concrete steps:** read `<topic>/MISSION.md` and `PROGRESS.md` → choose the one next lesson at
  the edge of the current level → put the primary source and the house standard in
  `RESOURCES.md` → teach, then ask for an unaided recall answer → have <%AUTHOR_FIRST_NAME%> build
  a worked piece in `LESSONS/` → log the lesson, the recall result and the next-review date in
  `PROGRESS.md`.
- **Definition of done:** `PROGRESS.md` holds a dated entry with a recall result and a next-review
  date, a worked piece sits in `LESSONS/`, and nothing outside `learning/` has changed.

## Guardrails

- **The rest of the repository is read-only during a lesson.** Read the real work freely as
  reference; write only inside `learning/`.
- **Invented people, places and organisations only.** Never practise on a live client matter, a
  real person's story or real figures.
- **Recall is assessed on substance, never on spelling or arithmetic form.** An answer that is
  right in substance is right; reflect the correct form back naturally, and never comment on how
  an answer was written.
- **Recall before re-reading.** Effortful recall builds the skill; re-reading only feels like it.
  Wait for the answer before confirming it.
- **One concept per lesson**, pitched just beyond what can already be done alone. A lesson that
  cannot be attempted is wasted, and one already mastered is a re-read.
- **Cite the primary source.** Never teach from memory; if a source is not to hand, say so.
- **Practice never graduates into the work.** A practice piece that turns out well is a reason to
  write the real one properly through the authoring loop, never to promote the practice.
- **Never prune this folder.** The review schedule depends on its history.

## Output & naming

- **Hand-written:** practice material only, all under `learning/<topic>/`.
- Topic folders are kebab-case; each holds `MISSION.md`, `RESOURCES.md`, `PROGRESS.md` and
  `LESSONS/`; worked pieces in `LESSONS/` take descriptive kebab-case names and carry **no version
  number**, so none is ever mistaken for a real draft.
