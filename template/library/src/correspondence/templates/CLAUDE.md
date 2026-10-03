@./CONTEXT.md

# CLAUDE.md — library/src/correspondence/templates/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/src/CONTEXT.md` → `library/src/CLAUDE.md` →
`library/src/correspondence/CONTEXT.md` → `library/src/correspondence/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold the reusable starting points for letter and email documents, free of any client's data.

## How to work here

- **Routing:** a new template is written like any document: plan it, draft its sections, review it
  to `final` (`library/workflows/`). Making a client document from a template is
  `library/workflows/02-adapt-a-draft/`, with the `adapt-section` skill.
- **Model:** **Opus**; template wording is copied into every document made from it.
- **Concrete steps:**
  1. Start from `tooling/latex/skeleton.tex`, leaving the house preamble untouched.
  2. Write the standard wording; leave every client value as a placeholder.
  3. Review it to `final`, register it, and add its tree line to this folder's `CONTEXT.md`.
- **Definition of done:** the template renders cleanly, every client value is a placeholder, it
  carries the parts its family requires, and it is in the register.

## Guardrails

- **No client's data, ever:** no name, number, address, contact or agreed figure.
- **No template carries a recipient.** Names, addresses and salutations are placeholders.
- **Changing a template changes no issued document.** Documents already made from it are records;
  if they need the change too, each gets a new version of its own.
- **Never overwrite a template** without the author's confirmation.

## Output & naming

- **Hand-written:** `template-<doc-type>.tex` (or `.md` for an email), kebab-case, unversioned.
- **Generated (never hand-edit):** any PDF proof of a template.
