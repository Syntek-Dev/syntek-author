@./CONTEXT.md

# CLAUDE.md — proposal/workflows/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `proposal/CONTEXT.md` →
`proposal/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file → the chosen
procedure's four files.

## Purpose (one line)

Hold the proposal layer's three procedures, so that assembling the package, approaching a reader
and updating the tracker happen the same way every time.

## How to work here

- **Routing:** pick by what you are doing; check `local/` for a same-slug override first.

| You want to… | Procedure |
|---|---|
| Draft, revise, proofread or build the package | `01-assemble-the-proposal/` |
| Approach someone: an endorser, or an agent | `02-approach-a-reader/` |
| Log an approach, a reply, a request, a chase or a lapse | `03-update-the-tracker/` |

- **Model:** **Opus** for every judgement; the mechanical tier for exports, tracker dates and ticks.
  The model tags in each `CHECKLIST.md` are authoritative
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps (running one):** read the procedure's `CONTEXT.md` → `CLAUDE.md` → `STEPS.md`,
  then work the steps in order with `CHECKLIST.md` open.
- **Concrete steps (changing one):** confirm with the author; put the change in `local/` under the
  same slug; change all four files together.
- **Definition of done (running):** every checklist item ticked or explicitly waived with a reason;
  the output is where the procedure says it should be; **nothing was sent**; the tracker reflects
  reality.

## Guardrails

- **Scope discipline.** The package serves the writing and never delays it; if a procedure drifts
  into drafting chapters, stop and hand back.
- **Draft, never send.** Every email is handed to the author. It is a step in
  `02-approach-a-reader` for a reason.
- **Never offer what does not exist,** and never invent a comparable title, a figure, an
  endorsement, an interest, an offer or a deadline.
- **Check the tracker before any approach.** A second first approach is entirely preventable.
- **The tracker outranks every other file** on who was asked what.
- **Decisions stay with the author.** The sample, the positioning and who is approached are the
  author's; do not make one to unblock yourself. Say what is blocked, and on whom.
- **A waived step is recorded, not silent.**

## Output & naming

- **Template-owned:** the three `NN-name/` folders and this pair.
- **Author-owned:** everything in `local/`.
- **Procedures produce nothing here.** Output lands in `proposal/src/` and, for exports, the build
  folder.
