@./CONTEXT.md

# CLAUDE.md — standards/brand/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `standards/CONTEXT.md` →
`standards/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file → the brand file
you need.

## Purpose (one line)

Make every issued document sound and look like the same business, and carry the right disclaimer
in the same words.

## How to work here

- **Routing:** `tone` checks running copy against `brand-voice.md` and the house marks of
  `standards/method/BUSINESS.md` rule 10 at line edit; `draft-section` writes from them and
  inserts the disclaimer for the document's class from `disclaimers.md`; `build` renders with
  the house preamble that `brand-guide.md` describes.
- **Model:** **Opus** for any voice judgement or brand decision; the mechanical tier for
  copying a confirmed hex value into the preamble
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps (resolving a flag here):**
  1. Run `make flags` to list the open `AUTHOR TO CONFIRM` flags in this folder.
  2. Put each question to the author, with the options and what each would change.
  3. On the author's answer, add it as a dated entry under the section's heading, remove the
     flag, and record the decision in `.claude/MEMORY.md` `## Decisions` (mapped in
     `00-project.md` `## Memory headings`). These files are the author's, so the entry is written
     in place.
  4. For a colour or font, set it in the author's own `house-brand.tex` override (see
     `tooling/latex/CONTEXT.md`), then build a proof.
- **Definition of done:** no flag remains in the section touched; the preamble and the guide
  agree; a proof shows the change.

## Guardrails

- **The author decides every brand fact.** A tagline, a colour, a font, a mark or a disclaimer
  wording is never invented, borrowed from another business or 'improved' without the author's
  word.
- **One wording per disclaimer class**, in `disclaimers.md` only, or in the file
  `00-project.md` `## Paths` names instead ('Disclaimers'). Never paraphrase it in a document, a
  skill or a template.
- **A folder named in `00-project.md` `## Paths` replaces this one.** Where 'Brand folder' or
  'Disclaimers' names another place, work there, and leave the unused file here as shipped; set
  `BRAND_DIRS` in `tooling/project.mk` to that folder so `make flags` stops reading the seeds here.
- **The voice never changes the substance.** A tone pass never alters a figure, a date, a scope
  or a commitment (`standards/method/BUSINESS.md` rule 2).
- **Legal instruments keep a formal register.** The brand voice governs running copy; its reach
  into contracts and policies is the entry in `brand-voice.md` Section 2, and until there is
  one, it does not reach them at all.
- **Template updates never reach these files.** They are seeds, written once; the house rules a
  template release keeps current live in `standards/method/BUSINESS.md`, which is
  template-owned. Record the business's own decisions here, and set a house mark aside with an
  entry in `brand-voice.md` Section 3, never by editing the method file.

## Output & naming

- **Hand-written** (by the author, or by a skill with the author's word): the three brand files.
  All three are seed-if-missing: `copier update` recreates a deleted one but never overwrites
  one that exists. This pair is template-owned and merged on update.
- **Entry form:** `- **DD/MM/YYYY** — **<the decision>.** <the reason>` under the section's
  heading (a colour is a row of the table in `brand-guide.md` Section 2); supersede with
  `*(Superseded DD/MM/YYYY — see below.)*`, never delete.
- **Generated:** nothing.
