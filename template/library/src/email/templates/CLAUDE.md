@./CONTEXT.md

# CLAUDE.md — library/src/email/templates/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/src/CONTEXT.md` → `library/src/CLAUDE.md` →
`library/src/email/CONTEXT.md` → `library/src/email/CLAUDE.md` → this folder's `CONTEXT.md`
(imported above) → this file.

## Purpose (one line)

Hold the reusable starting points for recurring emails, free of any recipient's data.

## How to work here

- **Routing:** a new template is written through `library/workflows/12-write-an-email/` like any
  email, then generalised. Making an email from a template is `library/workflows/02-adapt-a-draft/`,
  with the `adapt-section` skill.
- **Model:** **Opus**; template wording is copied into every email made from it.
- **Concrete steps:**
  1. Start from an email the author has sent and is content to reuse, with their agreement.
  2. Replace every recipient, fact and figure with a placeholder; keep the anatomy whole.
  3. Add its tree line to this folder's `CONTEXT.md` and register it.
- **Definition of done:** the template carries the four-part anatomy, every recipient value is a
  placeholder, its internal note says when to use it, and it is in the register.

## Guardrails

- **No recipient's data, ever:** no name, organisation, address, figure or date.
- **A template is never sent.** Its `**Status:**` line stays `Template, never sent`.
- **Changing a template changes no email already sent.**
- **Never overwrite a template** without the author's confirmation.

## Output & naming

- **Hand-written:** `template-<purpose>.md`, kebab-case, unversioned.
