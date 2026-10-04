@./CONTEXT.md

# CLAUDE.md — standards/style/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `standards/CONTEXT.md` →
`standards/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file → the seed you
are reading or proposing to change.

## Purpose (one line)

Hold the work's mechanics, voice and fixed terms as the author's own recorded decisions, so that
every section, whoever drafted it and whenever, is checked against the same calls.

## How to work here

- **Routing:** `spelling` and `grammar` read `style-sheet.md` and `terminology.md` and propose
  entries; `learn-voice` proposes additions to `voice-notes.md`, `style-sheet.md` and
  `terminology.md` from `samples/` and `ledger/`;
  `grill-with-docs` records a settled term in `terminology.md`; `draft-section`,
  `adapt-section` and `improve-section` write **from** `voice-notes.md`.
- **Model:** **Opus** for any voice judgement or proposed entry; the mechanical tier for a
  one-word spelling sweep the author has already agreed
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps (adding an entry):**
  1. Show the author the proposed entry with its evidence: the passages, the ledger entries or
     the samples it comes from.
  2. On the author's approval, add one dated bullet (or one table row in `terminology.md`) under
     the right heading, with the reason.
  3. If it overturns an earlier entry, mark the old one superseded rather than deleting it, and
     record the decision in `.claude/MEMORY.md` `## Decisions` (mapped in `00-project.md`
     `## Memory headings`).
  4. List the promoted sections the entry affects, for a conformity pass.
- **Definition of done:** the entry is approved, dated, evidenced and checkable; no other entry
  contradicts it; the affected sections are listed.

## Guardrails

- **The author's word adds an entry; a skill only proposes.** No skill writes to these files
  without that approval, and `learn-voice` marks a ledger entry learned only once its section
  is promoted and mined.
- **Real examples only.** A voice mark is illustrated with the author's own sentences from
  `samples/` or the ledger, never with invented ones: a voice guide with borrowed examples is a
  hypothesis, not a standard.
- **Proofreading is a report, not a rewrite.** Say what and where, offer the correction, group
  recurring items so one decision fixes many, and keep the tone encouraging. It is the default
  for every author; no health question is ever asked.
- **Do not tidy away a hedge that is doing honest work.** 'The evidence here is thin' looks
  like weak writing and is load-bearing; check `standards/method/` before cutting a
  qualification.
- **Preserve deliberate oddities.** Dialect, fragments and a recorded stylistic choice are the
  voice, not errors; once recorded here, `spelling` and `grammar` stop reporting them.
- **Stay in your lane.** A style pass never alters an argument, a figure, a date, a citation key
  or a commitment.

## Output & naming

- **Hand-written** (by the author, or by a skill with the author's approval): the three seeds.
  They are seed-if-missing: `copier update` recreates a deleted one but never overwrites one
  that exists.
- **Entry form:** `- **DD/MM/YYYY** — **<the decision>.** <reason or evidence>`; supersede with
  `*(Superseded DD/MM/YYYY — see below.)*`, never delete.
- `samples/` and `ledger/` follow the rules in their own `CLAUDE.md`.
