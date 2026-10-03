@./CONTEXT.md

# CLAUDE.md — library/docs/project/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/docs/CONTEXT.md` → `library/docs/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold the author's project guides for the library, which take precedence over same-named reference
guides.

## How to work here

- **Routing:** write a guide here when the author asks for one, or propose one when the same
  question has come up twice. Use the `grill-with-docs` skill to settle what the guide says before
  writing it.
- **Model:** **Opus**.
- **Concrete steps:**
  1. Confirm no standard already owns the rule, and no guide already answers the question.
  2. Settle the content with the author.
  3. Write the guide in the house guide format (`library/docs/CLAUDE.md`).
  4. Add its tree line to this folder's `CONTEXT.md`.
- **Definition of done:** the guide exists, follows the format, cites its standard, and is listed
  in this folder's `CONTEXT.md`.

## Guardrails

- **Write only what the author has confirmed.** A guide records how this business works; a guess
  written down becomes a rule nobody chose.
- **Never move a rule here from a standard.** Cite the standard; a change to a standard is
  author-confirmed, always.
- **No client data in a guide.** A guide applies to every client; a client's facts belong in that
  client's folder.
- **Never overwrite an existing guide** without the author's confirmation.

## Output & naming

- **Hand-written:** project guides, 54–82 lines each.
- **Naming:** kebab-case, named for the question answered; reuse a reference guide's filename only
  to override it on purpose.
