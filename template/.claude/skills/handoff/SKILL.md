---
name: handoff
description: >-
  Write a handoff so a fresh session resumes the work cleanly, then stop: the goal, what landed,
  what is in flight with path:line anchors, the part this kind of project must never drop, the
  next action, the skills to load, and every artefact by path. This project's replacement for
  compaction: auto-compaction is off and the PreCompact hook blocks it. Invoke by typing
  /handoff, when the context window is filling, when the compaction hook fires, or when
  <%AUTHOR_FIRST_NAME%> says 'hand this off', 'we'll pick this up tomorrow', 'wrap up the
  session' or 'write a handoff'. Not a memory store: durable decisions are recorded first
  (`grill-with-docs`), and work that spans many sessions by design belongs on a decision map
  (`wayfinder`).
---

# Skill: Handoff (<%PROJECT_NAME%>)

Handoff **compacts the current conversation by hand** into one document, so a **fresh session**
can resume the work across a boundary: a context window filling, a day ending, other work taking
over. It carries the live thread of *this* session only: where the work sits, what is half-done
and the next move. A handoff is a transient bridge, not a memory store; durable knowledge has
other homes and goes to them first.

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

## Governing procedures (route here — do not restate at length)

**No governing workflow.** This skill is a session mechanic, invoked directly, not a step in any
layer's procedures. The rule it carries out:

- `.claude/rules/syntek-author/07-session-boundaries.md` — hand off, never compact: the rule, how
  it is enforced, and what a handoff is not.
- `.claude/rules/syntek-author/06-global-rules.md` Section 10 — confidentiality: a handoff is
  committed, so nothing confidential is pasted into it.
- `.claude/rules/syntek-author/08-naming-and-memory.md` Sections 2 and 3 — where durable
  knowledge goes instead.

## Hand off; never compact

Compaction summarises lossily, without knowing which details were load-bearing; in a writing
project the detail it drops is usually the one that matters (a reading the author chose an hour
ago, a line they rejected and why, which of two drafts is live). **This is enforced, not merely
encouraged.** `.claude/settings.json` sets `autoCompactEnabled` to false, so the harness never
compacts on its own, and the `PreCompact` hook (`.claude/hooks/pre-compact-handoff.sh`) catches
anything that still reaches a compaction: on `auto` it **blocks** it, and on a manual `/compact`
it warns and lets the author's choice through.

Neither the setting nor the hook can write the handoff: a hook has only an exit code and a
message. That part is the model's. Notice the window filling, hand off **before** it is full (a
compaction blocked at the hard limit leaves the current request to fail), and stop.

## Where the handoff lives

The handoffs folder, in the filename form `00-project.md` `## Paths` gives (by default
`handoffs/HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md`, the form used below), committed so it travels with
the repository. The descriptor names **the work, not the session**:
`HANDOFF-OPENING-SECTIONS-03-10-2026.md`, never `HANDOFF-TUESDAY-03-10-2026.md`. Prune a handoff
once its work has resumed and landed.

## How to write a handoff

> **Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they disagree, the procedure wins and the disagreement is reported to the author.

1. **Record durable knowledge in its real home first.** A decision or fact goes to
   `.claude/MEMORY.md` through the gate; a unit's decision to its brief in `planning/src/units/`;
   a folder rule to that folder's `CLAUDE.md` on the author's word; a section's provenance to its
   ledger entry. Use `grill-with-docs` for anything the author has just decided. *Complete when:*
   nothing the handoff is about to mention exists only in the conversation.
2. **State the goal.** One or two sentences naming what the work is trying to achieve, so the
   fresh session orients before any detail. Look facts up rather than recalling them.
   *Complete when:* the goal sits in one or two sentences at the top.
3. **Record what is done.** The work landed this session (files written, sections drafted or
   promoted, decisions recorded, checks passed), each named by its repository path.
   *Complete when:* every finished item is a one-liner with its path.
4. **Pin what is in flight.** For each open thread, the exact `path:line` anchor and its
   mid-change state; say plainly which draft is live and which is superseded. This is the
   load-bearing part: the fresh session resumes here. *Complete when:* every in-flight item has a
   `path:line` anchor and a one-line status.
5. **Carry the part this project must never drop.** The mode file names it and what it lists.
   *Complete when:* every item the mode names is listed with its path, or the handoff says the
   session did not touch it.
6. **Name the next action.** The single next step, concrete enough to start without re-deriving
   it. *Complete when:* the next action is one imperative sentence.
7. **Name the skills to load next.** The skills best suited to continue, from the roster in
   `.claude/rules/syntek-author/02-skills.md`. *Complete when:* the handoff names them, in the
   order the next session loads them.
8. **Reference artefacts by path; never paste them.** Briefs, drafts, ledger entries, notes,
   maps, commits: by path, so the fresh session opens them itself. Anything confidential is named
   and located, never reproduced. *Complete when:* every artefact is a path, and no confidential
   value or quoted passage of the work appears.
9. **Write the file, print the path, then stop.** Write the handoff in the handoffs folder, in
   the filename form `00-project.md` `## Paths` names (by default
   `handoffs/HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md`), print that path for <%AUTHOR_FIRST_NAME%>, and
   **end the turn**, so the author can run `/clear` and resume from the file in a fresh window.
   *Complete when:* the file exists there, its path is printed, and the turn has stopped.

## What the handoff carries

A complete handoff has these parts, top to bottom; treat the list as the final check.

- **Goal** — what the work achieves, in one or two sentences.
- **Done** — landed work, each by path.
- **In flight** — open threads, each with a `path:line` anchor and its status.
- **The mode's part** — what this kind of project must never drop.
- **Next** — the single immediate action.
- **Next skills** — what the next session loads.
- **Artefacts** — everything else the work touches, by path.

Add an **Open questions** line only when the session left a decision genuinely unresolved, and make
sure it is also under the `Open questions` heading of `.claude/MEMORY.md` (mapped in `00-project.md`
`## Memory headings`). A **teaching detour** (the work pauses while a gap is closed with `teach`) is
named in the descriptor, `HANDOFF-TEACH-<TOPIC>-DD-MM-YYYY.md`, with a `Teaching detour` line giving
the topic, the concept that missed and the opening lesson, and `teach` first among the next skills.

## What stays out

- Facts, decisions, feedback, status and sensitivities: each under its heading in
  `.claude/MEMORY.md`.
- What a unit argues, tells or commits to: its brief in `planning/src/units/`.
- What the evidence supports: `research/src/evidence/`; a researched question: the research notes
  folder (by default `research/src/notes/`).
- An unresolved decision blocking a body of work: the `Open questions` heading of
  `.claude/MEMORY.md`, or the frontier of a decision map (by default in `planning/src/maps/`).

## Anti-patterns

- **Carrying on after the handoff.** A handoff followed by more work is stale before it is read.
- **An in-flight item with no anchor.** 'The section is partly drafted' is not a handoff.
- **Pasting the work.** A handoff that quotes half a section has recreated the context it was
  meant to replace.
- **Durable knowledge only in the handoff.** It is pruned; the decision goes with it.
- **Editing an old handoff** to bring it up to date: write a new one and prune the old.
- **Waiting for the hook.** The hook is the backstop; the rule is to hand off before it fires.

## Cross-references

- `.claude/rules/syntek-author/07-session-boundaries.md` — the rule this skill carries out, and
  the file the hook cites.
- `.claude/hooks/pre-compact-handoff.sh` — the `PreCompact` hook; registered in
  `.claude/settings.json`.
- `handoffs/CONTEXT.md` — the folder and its naming.
- `.claude/skills/grill-with-docs/SKILL.md` — how durable decisions are recorded before a handoff.
- `.claude/skills/wayfinder/SKILL.md` — work whose continuity spans many sessions by design.
- `.claude/skills/wait-what/SKILL.md` · `.claude/skills/teach/SKILL.md` — the teaching detour.
- `.claude/MEMORY.md` — the durable memory a handoff deliberately does not duplicate.
