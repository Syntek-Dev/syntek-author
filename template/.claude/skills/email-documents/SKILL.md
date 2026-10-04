---
name: email-documents
description: >-
  Write, file or check an email to a client, supplier or other correspondent: the authored-email
  anatomy (title, To, From, Attachment and Status lines, internal note, rule, subject, body),
  subject lines and filenames, filing by correspondent and family, concision, follow-ups that do
  not keep score, recorded reader needs, and the pre-send checklist. Also the rule every other
  skill obeys under library/src/email/: an archived thread is evidence, never edited, renamed or
  re-rendered. Use when the author says 'draft an email to…', 'reply to their email', 'write a
  follow-up', 'what should the subject line be?', 'is this email ready to send?' or 'file this
  thread'. The substance follows its family's skill. Never sends anything. Not a formal notice
  under a contract (the legal family's skill, where the project has it; otherwise raise it with
  the author); not a line-edit for voice alone (`tone`); not whether a promise matches the
  agreement (`obligation-check`); not one section (`draft-section`).
---

# Skill: Email documents (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

The email family is the business's correspondence, kept in one place because it is one continuous
record of what was asked, what was promised and when. An email has a form and a subject matter,
governed separately: this skill owns the form (anatomy, naming, filing, sending discipline), and
the skill of the family whose substance it carries, `<family>-documents`, owns the substance. Any
other skill working on a file under `library/src/email/` reads this skill first, and no skill
changes an archived thread. The procedure of record is the create workflow.

## Governing procedures (route here — do not restate at length)

- `library/workflows/12-write-an-email/` — the procedure of record for a new email; this skill is
  its domain in skill form. Run its `STEPS.md` with `CHECKLIST.md` open. Where this file and the
  procedure disagree, the procedure wins and the disagreement is reported to the author. An alias
  in `00-project.md` `## Workflow aliases`, then a same-named folder in `library/workflows/local/`,
  replaces it (`run-workflow`).
- `library/docs/reference/email-standards.md` and its sub-document
  `library/docs/reference/EMAIL-ANATOMY-AND-NAMING.md` — the family standard: filing, naming and
  the email checks. Route there; this skill does not change them.
- `.claude/rules/syntek-author/00-project.md` — `## Brief` (trading name, voice, audience) and
  `## Paths` (client facts, brand folder). It outranks every other rules file; take those values
  from it.
- `.claude/rules/syntek-author/03-authorship.md` Sections 4 and 7, `standards/method/BUSINESS.md`
  rules 2, 5, 7 and 10, and `standards/risk/BUSINESS.md` rules 1, 3 and 6.
- `library/docs/reference/latex-deliverables.md` — the Markdown form of the section markers.

## Two kinds of email file

| | Authored email | Archived thread |
|---|---|---|
| What it is | an email the business writes, to send | an export of what was actually sent and received |
| Form | the anatomy below | whatever the mail client produced |
| Name | `<subject-line>-DD-MM-YYYY.md` | its export name, unchanged |
| Internal note and Status line | required | never |
| Editable | until sent | never |
| A PDF of it | a review proof, never sent; made again after any change | the evidential copy: never regenerated |

An archived thread records what was sent, including anything that now reads awkwardly. No pass
runs on it: not `tone`, `spelling`, `grammar` or `make lint`, and nothing is promoted into it. It
is listed as archived in its folder's `CONTEXT.md`, so no later pass mistakes it for an authored
email.

## Anatomy of an authored email

```markdown
---
unit: <unit-slug>
status: draft
last_updated: DD/MM/YYYY
---

# Email: <purpose>, <recipient>, DD/MM/YYYY

**To:** [Name], [Role], [Organisation]. [address]
**From:** [Sender], [Trading name]. [address]
**Attachment:** `[file].pdf` (or: None)
**Status:** Draft, not yet sent

> Internal note, not to be sent.
>
> Decisions and why; every source checked, with its date; any deliberate departure from a house
> rule, stated as such; anything to resolve before sending.

---

**Subject:** <the subject line the recipient sees>

<!-- section: body -->
Hi <first name>,

…
<!-- end section: body -->
```

Each of the four metadata lines ends in two spaces, so they do not run together. The frontmatter
`status:` is the email's writing status (the unit ladder); the `**Status:**` line is the sending
record, and changes only when the author says the email went. Only what follows the rule is ever
sent. The internal note is the most valuable part of the file: a departure recorded there is what
stops a later pass correcting a deliberate choice back to the rule. Be blunt in it.

## Filing and naming

- **Clients.** `library/src/email/client-emails/<client-slug>/<family>/`, with the client's slug
  from their facts file. The `<family>` leaf names the family whose substance the email carries,
  and so the `<family>-documents` skill loaded beside this one; it is decided by the engagement
  that owns the matter, and the internal note records the call when it is not obvious. A client or
  leaf folder is made, with its folder pair, only when its first email needs it and the author
  confirms.
- **Suppliers:** `library/src/email/supplier-emails/<matter-slug>/`, by matter.
- **Templates** for recurring emails in `library/src/email/templates/`.
- **A letter is not an email.** A formal notice served under a contract is an instrument; a letter
  on letterhead is a document of the family whose substance it carries. Neither is filed here.
- **The filename** is the subject line in kebab-case, then the date: lower case, punctuation
  dropped, spaces to hyphens, no `email-` prefix. A stem is exactly as long as its subject. If the
  subject changes before sending, rename the file and every derived copy, and chase every
  reference, the register included. A sent email's subject and filename never change.

## Writing an email

- **Subject line.** The matter first, then the one thing that has changed or is being asked. Aim
  for 50 characters, 60 at most (a phone shows little more); never restate the attachment's title
  or list the contents; no em dashes; sentence case.
- **As short as it can be while still answering what the reader would have asked.** Lead with the
  decision or the ask, the reasoning after; one idea per paragraph; a short list where prose would
  need a long sentence; bold what the reader must act on; cut context they already hold, recaps of
  their own email, and any sentence that only softens the next. Concise is not thin: the
  anticipated answers stay. Length is not scope: an email with five points carries five points.
- **Follow-ups never keep score.** Never recite what the recipient said they would do, count the
  time elapsed, or deny chasing ('no pressure, but'); words like 'circling back', 'gentle nudge'
  and 'still waiting' carry the same charge. Give your own reason for writing; offer a date in the
  underlying document as something the business can move, never as a deadline running out; make
  'no' and 'not yet' as easy to send as 'yes'.
- **Promises.** An email describes a contractual term in plain English, in its substance, never
  by clause number, and never creates a commitment the instruments do not carry.
- **Voice.** The voice `00-project.md` `## Brief` records: in the first person singular, a 'we'
  that reads as a team is a finding; the trading name is a label, never an actor. No em dashes in
  client-facing copy; en dashes only in ranges. Register is set by the reader: peer to peer with a
  specialist, plain with a lay reader.
- **A recorded reader need** (a format, a length) outranks the house default for that person: it
  lives in the client's `client-emails/<client-slug>/CLAUDE.md`, recorded only on the author's
  instruction, as the preference alone and never with its reason or a diagnosis
  (`standards/risk/BUSINESS.md` rule 3). Check it before drafting.
- **No legal or financial disclaimer.** An email is not that kind of deliverable; one with that
  substance points to the document that carries it, and its disclaimer. It carries the
  Correspondence wording only where the disclaimers file gives that class one.
- **Derived copies** are made from the `.md`, never edited by hand, and made again after every
  change. `make pdf FILE=<email>.md` and `make docx FILE=<email>.md` make review proofs: they
  carry the metadata and the internal note, so they are never sent or attached. The sent text is
  the paste copy from the project's converter, which strips everything above the rule. Two
  Markdown traps spoil a paste: a hard line break needs two trailing spaces, and a URL needs
  angle brackets to become a link.

## How to write an email

1. **Fix the correspondent, the matter and the family.** Agree with <%AUTHOR_FIRST_NAME%> whom
   the email is to, what it is about and the one thing it asks or tells. Decide the family leaf by
   the engagement that owns the matter and read that family's `<family>-documents` skill for the
   substance. A formal notice under a contract goes to its own family instead. *Complete when:*
   the correspondent, the ask and the family are agreed.

2. **Read the record.** Read `00-project.md` `## Brief` and `## Paths`, the correspondent's facts
   (a client's by default in `library/src/business/client-docs/<client-slug>/CONTEXT.md` under
   `## Facts`; a supplier's in its matter folder), any recorded reader need, the archived threads
   on the matter (read, never touched), the instruments the email describes, and every other
   unsent email to the same correspondent, together. Ask what is still unknown, with a recommended
   answer each, as `06-global-rules.md` Section 8 says unless `00-project.md` `## Overrides` sets
   another style; a name, title or address is never guessed. *Complete when:* every fact is in
   hand or flagged, and every contradiction with another unsent email is listed for the author.

3. **Settle the folder and plan the one section.** Find the folder under Filing above; a missing
   client, leaf or matter folder is made only with the author's confirmation, with its pair. Then
   run `planning/workflows/01-plan-a-unit/` in its shortest form: one section, `body`, and a brief
   recording the correspondent, the matter, the ask, every fact the email will state with its
   source, and what it must not promise. *Complete when:* the folder exists and the brief is
   agreed (V1 dated).

4. **Write the body through the loop.** `draft-section` drafts `body` (or the author writes it and
   `improve-section` follows), and `adapt-section` works the author's notes, to the rules under
   Writing an email. *Complete when:* the author is content with the draft body.

5. **Settle the subject line and write the fixed parts.** Settle the subject, name the file from
   it, and create the email at its path with the anatomy above: frontmatter, title, metadata with
   `**Status:**` at Draft, the internal note, the rule, the subject and the empty marker pair.
   *Complete when:* the file exists with every part in order and the filename matches the subject.

6. **Promote it and check it.** On the author's word, `promote-section` puts the body between its
   markers. Then run `library/workflows/05-review-a-document/` in its short form: `obligation-check`
   traces every commitment, price and date to its instrument, `tone` reads it as its recipient
   will, the checklist below is worked, with `make lint SCOPE=<email>.md` and `make flags
   SCOPE=<email>.md`, and the email is registered through
   `planning/workflows/08-update-the-register/`. *Complete when:* every item is ticked or reported
   open with its location, and the register row is written.

7. **Hand back.** Read every other unsent email to the same correspondent once more beside this
   one. List the email in its folder's `CONTEXT.md` and make any derived copy again. Report the
   path, the subject, every flag and any contradiction. The email waits at Draft: sending it, and
   setting `**Status:**` to sent with the date, are the author's. *Complete when:* the author has
   the hand-back.

## Pre-send checklist

- [ ] Frontmatter, title, To, From, Attachment and Status lines, internal note, rule, subject, body.
- [ ] `**Status:**` accurate, and changed only on the author's word.
- [ ] Internal note holds decisions, dated sources, deliberate departures and open items.
- [ ] Subject matter first, 50 characters or fewer (60 at most); filename matches it plus the date.
- [ ] The decision or ask first; the reader's likely questions answered; nothing restated.
- [ ] Every commitment described matches its instrument in substance, without a clause number.
- [ ] No invented name, title, address or entity detail; no other client named.
- [ ] Any recorded reader need for the recipient honoured.
- [ ] The recorded voice; en_GB; DD/MM/YYYY; the house currency; no em dashes.
- [ ] Hard breaks with two trailing spaces; URLs in angle brackets.
- [ ] Read beside every other unsent email to the same correspondent.
- [ ] Review proofs and the paste copy made from the final `.md`; no proof sent or attached.
- [ ] Listed in its folder's `CONTEXT.md`; registered.

## Anti-patterns

- **Touching an archived thread.** Tidying, renaming or re-rendering destroys the evidence.
- **Changing a sent subject or filename.** It is part of the record and how the thread is found.
- **Keeping score in a follow-up.** It reads as a complaint, however warmly it is phrased.
- **Citing a clause number to a client,** or describing a term the instrument does not carry.
- **Changing `**Status:**` unasked.** It is the only record of whether the reader has seen it.
- **Hand-editing a derived copy.** Edit the `.md` and make the copy again.
- **Treating a recorded reader need as style.** A later pass that 'corrects' it breaks a
  requirement.
- **Sending.** This skill writes and checks; the author sends.

## Cross-references

- `library/docs/reference/email-standards.md` — the family standard.
- `library/workflows/12-write-an-email/` — the procedure of record.
- `.claude/rules/syntek-author/00-project.md` — the project's values and paths.
- `standards/method/BUSINESS.md`, `standards/risk/BUSINESS.md`.
- `planning/src/document-register.md` — every email registered.
- `.claude/skills/business-documents/SKILL.md` — the substance of business correspondence, and
  each other family's `<family>-documents` skill for theirs.
- `.claude/skills/draft-section/SKILL.md`, `.claude/skills/promote-section/SKILL.md` — the loop.
- `.claude/skills/obligation-check/SKILL.md`, `.claude/skills/tone/SKILL.md` — promises and
  voice.
