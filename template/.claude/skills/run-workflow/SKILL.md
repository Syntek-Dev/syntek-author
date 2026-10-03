---
name: run-workflow
description: >-
  The router: turn what the author asks for into exactly one workflow and run it as written.
  Resolves the request to a procedure, looking in the author's own workflows/local/ first (a
  local folder with the same NN-name replaces the template's), loads its STEPS.md with
  CHECKLIST.md open, obeys every gate, and hands back with the next move. Biased towards
  producing prose: scaffolding is not progress. Use when the author says 'what's next?', 'pick
  up where we left off', 'resume from the handoff', 'review chapter 3', 'run workflow 03',
  'carry on with the proposal', or describes a job without naming a skill and no skill claims
  it. Not for a job a skill claims by name or by its own triggers, which runs that skill
  directly (`draft-section`). Not for planning a unit or settling a design question by
  interview (`grill-with-docs`). Not for writing a new procedure (`workflows/local/` with the
  author's agreement, never improvised mid-run).
---

# Skill: Run Workflow (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

<%AUTHOR_FIRST_NAME%> rarely names a procedure; they say what they want done. This skill turns the
request into **one** workflow, looks in the author's own procedures before the template's, and then
runs that workflow exactly as written: `STEPS.md` in order, `CHECKLIST.md` open and ticked as each
item passes, every gate obeyed. It owns no domain and carries no mode file; the workflows, and the
skills each step names, carry the domain.

Its one bias is towards prose. A session that ends with new folders, maps and trackers but no new
or approved sentences has not moved the work: **scaffolding is not progress**. When two procedures
would both serve, the one that drafts, revises or approves prose is offered first.

## Governing procedures (route here — do not restate at length)

This skill runs procedures; it never replaces one, and it never paraphrases one from memory.

- Each production layer's `workflows/CONTEXT.md` and `workflows/CLAUDE.md` — that layer's index
  of procedures and its 'You want to… | Procedure' table. The layers this project has are listed
  in `.claude/rules/syntek-author/01-layout-and-routing.md` Section 1.
- Each layer's `workflows/local/CONTEXT.md` — the author's own procedures and their overrides,
  read before the template's.
- `.claude/rules/syntek-author/01-layout-and-routing.md` Sections 3 and 6 — local first, frozen
  numbering, and the routing frontmatter every `STEPS.md` and `CHECKLIST.md` carries.
- `.claude/rules/syntek-author/03-authorship.md` — who decides what, and the authoring loop that
  the content layer's procedures 01 to 04 and 07 implement.
- `standards/verification/verification.md` — the gates a procedure cites; never restated here.
- `.claude/rules/syntek-author/05-model-allocation.md` — what the checklist model tags mean.

## Steps

1. **Restate the request as one job.** Read `.claude/MEMORY.md` (Status and Open questions). If
   `handoffs/` holds a handoff newer than the latest `MEMORY.md` Status line, read the newest
   first: its In flight anchors and its Next action outrank the briefs; offer to prune it once
   the work lands. Then name the job, the unit and, where it applies, the section in one
   sentence: 'draft section `the-turn` of chapter 01', 'review the whole of the example
   proposal'. If the request could be two different jobs, ask one question with your
   recommended reading and its reason, and wait.
   *Complete when:* the job is one sentence the author has not contradicted, and any newer
   handoff has been read.

2. **Read the indexes, local first.** For each production layer, read `workflows/local/CONTEXT.md`
   and then `workflows/CONTEXT.md` and `workflows/CLAUDE.md`. List every procedure whose row
   matches the job, with its layer and folder name.
   *Complete when:* every candidate is listed, and the local ones are marked as local.

3. **Resolve to one procedure.** A local folder with the same name as a template folder, number
   included (`workflows/local/03-improve-your-draft/` over `workflows/03-improve-your-draft/`),
   replaces it entirely. A local procedure with a number of its own competes on its row like any
   other. If two still fit, offer the one that produces or approves prose and say why. If none
   fits, say so and stop: never improvise a procedure or stitch two together, and never write a
   new one without the author's agreement (`workflows/local/CLAUDE.md` in the layer says how).
   *Complete when:* one procedure folder is chosen, and you can say whether it is local or the
   template's.

4. **Resolve 'next' from the record, never from memory.** 'The next section' is the first entry in
   the unit brief's `sections:` list (`planning/src/units/`), in order, that is neither promoted
   nor drafted. 'What's next?' is answered from a newer handoff's Next action (step 1), else from
   `.claude/MEMORY.md` Status and the briefs' statuses, and the first move offered is the one
   that brings prose nearer: draft or revise the next section, promote one the author has
   approved, or review a unit whose sections are all promoted. If the brief and the drafts
   disagree, report the disagreement rather than guess.
   *Complete when:* the target is a named unit and section (or unit), read from its brief.

5. **Load the procedure whole.** Read its `CONTEXT.md` and `CLAUDE.md`, then `STEPS.md` with
   `CHECKLIST.md` open beside it. Obey the routing frontmatter: load every skill its `skills:`
   list names, each with its mode file, and note the `model:` tier.
   *Complete when:* all four files are read and every skill named is loaded.

6. **Check the pre-conditions and the gates.** Tick each `## Pre-Conditions` item or stop on it.
   Before any step that moves a status, check the gate it cites in
   `standards/verification/verification.md`; a gate that does not pass stops the run there. A
   gate is waived only on the author's explicit word, recorded where the procedure says (a unit
   brief's `verified:` record) with the date and the reason.
   *Complete when:* every pre-condition is ticked, or the run has stopped and said why.

7. **Work the steps in order.** Run each step with the skill and the guide its `> **Skill:**` line
   names, at the tier its checklist tag gives, and tick the item only when its test passes. Never
   reorder, merge or skip a step to save time; a step that needs the author's decision asks and
   waits. Where a skill's mode file disagrees with the procedure, the procedure wins and the
   disagreement is reported.
   *Complete when:* every step is done, or waived with its reason stated.

8. **Hand back, and point at the prose.** Report the procedure run (local or template), every
   artefact written with its path, every item waived and why, every open flag and question, and
   the next procedure: the one the layer's `workflows/CLAUDE.md` gives under 'Usually followed
   by', or the one the last step names. Offer the move that brings the next sentence nearer.
   *Complete when:* the hand-back names what changed, what is open and the next move, and nothing
   was promoted, finalised or changed in a standard without the author's word.

## Anti-patterns

- **Scaffolding as progress.** Creating folders, briefs, maps, trackers or index rows the
  procedure did not ask for, or re-planning a unit whose brief already passed its gate when the
  next section is waiting to be drafted.
- Running a template procedure when a same-named local one exists, or the reverse.
- Working from a remembered version of `STEPS.md`. A remembered procedure is an old procedure.
- Improvising a procedure when none matches, or quietly merging two because each covers half.
- Treating a gate as advice. A gate that 'nearly passes' has not passed.
- Ticking checklist items in a batch at the end, or before their tests pass.
- Promoting, finalising or editing a standard because the procedure 'obviously' leads there; each
  of those waits for the author's explicit word.
- Answering 'what's next?' from the state of `drafts/` instead of from the handoff, the briefs
  and memory, or leaving a resumed handoff unpruned once its work has landed.

## Cross-references

- `.claude/rules/syntek-author/02-skills.md` — the skills that ship in this project, and which
  carry a mode file.
- `draft-section` · `adapt-section` · `improve-section` · `promote-section` · `learn-voice` ·
  `build` — the skills the content layer's procedures name, each that procedure in skill form.
- `grill-with-docs` — the interview that opens every planning procedure.
- `handoff` — when a procedure has to stop mid-way at a session boundary
  (`.claude/rules/syntek-author/07-session-boundaries.md`); `handoffs/` holds what this skill
  resumes from.
- `.claude/MEMORY.md` — the Status section 'what's next?' reads first.
- `planning/src/units/` — the briefs whose `sections:` lists define 'the next section'.
