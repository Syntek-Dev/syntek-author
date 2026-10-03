@./CONTEXT.md

# CLAUDE.md — standards/verification/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `standards/CONTEXT.md` →
`standards/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file →
`verification.md`, then the mode file beside it.

## Purpose (one line)

Say, once and by number, what each unit must pass before its status moves, so that every
checklist and skill can cite the gate instead of restating it.

## How to work here

- **Routing:** the review workflow (05) in the content layer runs the gates in order, each by
  the skill `verification.md` names; `promote-section` holds each section to V2's terms as it
  promotes it; `build` produces the proof V3 needs. A workflow cites a gate with its transition,
  as 'V2 (draft → structural-review)' or 'V4.2', never by copying its wording.
- **Model:** **Opus** to judge a gate; the mechanical tier to record a date in the `verified:`
  map once the gate has passed (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps (passing a gate):**
  1. Run the skill the gate names, on the whole unit.
  2. Report its findings to the author; resolve or record each one.
  3. When every condition of the gate and its sub-gates holds, record the date under the gate's
     number in the unit brief's `verified:` map. When every gate for the transition is dated
     (V2 and V3 both, for `draft → structural-review`), move `status:` up one rung.
  4. For `final`, also record the author's explicit word, dated, in `.claude/MEMORY.md`
     `## Status`.
- **Definition of done:** the unit's `status:` and `verified:` map agree with this standard, and
  every date recorded corresponds to a gate that actually passed.

## Guardrails

- **Never skip a gate, and never pass one on the strength of an earlier, partial run.** A gate
  checks the unit as it stands now.
- **`final` is the author's word.** No skill sets `final`; `promote-section` never does.
- **A change reopens the gates it touches** (`verification.md` rule 3). A material change after a
  gate passed (a section rewritten, a claim added, the argument restructured) clears that gate's
  date and every later one, and the status steps back; any other agreed wording change clears no
  date, but its section is promoted again and the stages already passed are run over it again.
- **Proofs are ungated.** `make pdf` and `make docx` may run at any status; a gate is about the
  text, not the build.
- **Never edit this standard to let a unit through.** The unit changes, or the gate changes
  openly with the author.

## Output & naming

- **Hand-written:** `verification.md`, the mode file and this pair; nothing generated.
- **Gate numbers are frozen and append-only.** A retired gate keeps its number and is marked
  retired; checklists elsewhere cite these numbers.
- **The record** lives in each unit brief's frontmatter, for example
  `verified: {V1: 03/10/2026, V4.1: 12/10/2026}`, never in this folder.
