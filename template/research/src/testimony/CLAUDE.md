@./CONTEXT.md

# CLAUDE.md — research/src/testimony/

Read order: **`standards/risk/sensitive-content.md`** → `.claude/CLAUDE.md` → `.claude/MEMORY.md`
(Sensitivities, mapped in `00-project.md` `## Memory headings`) → `research/CONTEXT.md` →
`research/CLAUDE.md` → `research/src/CONTEXT.md` → `research/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Safeguard first-person testimony and help shape it, with the author, only as far as the person whose
story it is chooses.

## How to work here

- **Routing:** only through `research/workflows/05-handle-testimony-safely/`; skill
  `sensitivity-pass` before anything from here shapes a chapter; guide
  `research/docs/reference/handling-testimony.md`. No other procedure and no research skill works in
  this folder: this is testimony, not evidence.
- **Model:** **Opus** for all work here; nothing in this folder counts as mechanical
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:**
  1. Read the standard before opening a note, and confirm the author is willing to work on this
     material now.
  2. Work with the author's own words: capture, order and gently clarify, never over them.
  3. Record consent in the note's frontmatter, in the person's terms, with its date.
  4. Run `sensitivity-pass` before anything moves towards a chapter.
  5. Hand on only what consent allows, and only when the author says so.
- **Definition of done:** the note holds the voice faithfully; consent is recorded, explicit and
  dated; the sensitivity pass is complete; anything that could stir a reader is flagged for a
  signpost. Never 'done' if the author has not chosen it.

## Guardrails

- **Consent is load-bearing.** Nothing is published verbatim, or paraphrased into print, without the
  person's explicit, considered decision. When in doubt, do not use it; ask rather than decide.
- **The voice is theirs.** Do not novelise, dramatise or ventriloquise. Clarify only with agreement.
- **Protect the people named.** Anonymise or generalise third parties by default; no child is ever
  identifiable; flag anything identifying or legally sensitive for the author's decision.
- **Hold the author's wellbeing in view.** Pace hard material gently; pause, flag and defer rather
  than push through.
- **Testimony is not a citable source.** No statistics, no claims about others.
- **Private by default.** This folder is committed to git; write nothing here the author would not
  want in the repository's history.
- **Never overwrite a note** without confirming with the author; supersede with a dated addition.

## Output & naming

- **Hand-written, by or with the author:** plainly named kebab-case notes, one per strand of the
  story (for example `the-winter-move.md`).
- **Not here:** prose for the reader, which is drafted in the manuscript only with consent;
  evidence (`research/src/evidence/`); anything generated. Nothing here is a build input.
