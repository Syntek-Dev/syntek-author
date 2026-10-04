@./CONTEXT.md

# CLAUDE.md — library/src/email/supplier-emails/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/src/CONTEXT.md` → `library/src/CLAUDE.md` →
`library/src/email/CONTEXT.md` → `library/src/email/CLAUDE.md` → this folder's `CONTEXT.md`
(imported above) → this file.

## Purpose (one line)

Hold correspondence with suppliers, one folder per matter, with the suppliers' verified details.

## How to work here

- **Routing:** emails are written through `library/workflows/12-write-an-email/`, with
  `email-documents` and the skill of the family the matter folder names (usually
  `business-documents`).
- **Model:** the mechanical tier for folders and pairs; **Opus** for every word of an email and
  every supplier fact.
- **Concrete steps:**
  1. Confirm the matter with the author; create its folder with its pair only when the first email
     needs it.
  2. Record each supplier's details under `## Facts` in the matter folder's `CONTEXT.md`, each with
     its date and source; verify the legal entity against the public register.
  3. Where several suppliers receive the same request, write one master email and derive each
     supplier's copy from it, so every supplier is asked the same thing.
- **Definition of done:** every email is in its matter folder, named from its subject line, listed
  in the folder's `CONTEXT.md`, and every supplier fact it relies on is recorded with its source.

## Guardrails

- **Never tell one supplier another's price or name.** A quote round is confidential both ways.
- **Never accept a quote, place an order or agree terms in an email** without the author's word;
  the email asks, the author decides.
- **Never create a per-supplier folder** unless `00-project.md ## Overrides` says the business
  files supplier correspondence that way.
- **No credential, account number or payment detail** is written into any file here.

## Output & naming

- **Hand-written:** matter folders `<matter-slug>/` with their pairs; authored emails
  `<subject-line>-<DD-MM-YYYY>.md`.
- **Kept as received:** archived threads and quotes as received, under their own names.
