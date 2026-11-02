@./CONTEXT.md

# CLAUDE.md — library/src/email/client-emails/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/src/CONTEXT.md` → `library/src/CLAUDE.md` →
`library/src/email/CONTEXT.md` → `library/src/email/CLAUDE.md` → this folder's `CONTEXT.md`
(imported above) → this file.

## Purpose (one line)

Hold each client's correspondence in that client's folder, split by the family that governs it.

## How to work here

- **Routing:** emails are written through `library/workflows/12-write-an-email/`; this folder
  decides where they are filed. Load `email-documents`, then the skill of the leaf's family.
- **Model:** the mechanical tier for creating folders and their pairs; **Opus** for every word of
  an email.
- **Concrete steps:**
  1. Identify the client and the governing family; read the client folder's pair, then the leaf's.
  2. Read the client's facts in `library/src/business/client-docs/<client-slug>/CONTEXT.md`, and
     every other unsent email to the same client.
  3. Create a client folder or a family leaf only when the first email needs it, with the
     author's confirmation, and give it its pair at once.
  4. Create each new email in its own `<YYYY-MM-DD-HH-MM>-<topic>/` folder in the leaf, without
     asking and without a pair, and list it in the leaf's `CONTEXT.md`.
- **Definition of done:** the email is in its own folder in the right client and family leaf,
  named from its subject line, listed in the leaf's `CONTEXT.md`, and consistent with every other
  unsent email to that client.

## Guardrails

- **The client's business folder is the authority on facts, not this folder.** Cite it; never
  restate an entity detail, a job title or an address here.
- **A blank contact means 'not confirmed'.** Never fill one in from a website.
- **Never pre-create empty leaves.** A folder exists because an email needed it.
- **Never move an email filed flat before v0.10.0,** or edit a record naming its old path. That
  path names the file where it stands; if the author has moved it, it is at
  `<leaf>/<YYYY-MM-DD-HH-MM>-<topic>/<stem>.md` (find the folder ending `-<topic>`).
- **One slug per client, everywhere;** never a second name for a client that already has one.
- **Never edit, rename or re-render an archived thread.**
- **Never name another client in an email,** and never copy content across client folders.

## Output & naming

- **Hand-written:** client folders and family leaves with their pairs; authored emails
  `<YYYY-MM-DD-HH-MM>-<topic>/<subject-line>-<DD-MM-YYYY>.md`, the email folder without a pair.
- **Kept as received:** archived threads, under their export name.
