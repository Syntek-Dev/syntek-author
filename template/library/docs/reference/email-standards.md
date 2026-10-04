---
type: guide
skills: [email-documents, draft-section, tone, obligation-check]
model: opus
---

# Email standards — the mechanics of correspondence, always paired with a second standard

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** The standard for every email in `library/src/email/`. An email has a form and a
subject matter, governed separately: this guide owns the form (anatomy, filing, subject line,
naming, sending), and the standard of the family named by the email's folder leaf owns the
substance. Load both, always. The anatomy, the naming rules and the checklist are in
`EMAIL-ANATOMY-AND-NAMING.md` beside this guide.

## Two kinds of artefact

| | Authored email | Archived thread |
|---|---|---|
| What it is | an email the business writes to send | a mail-client export of what was sent and received |
| Structure | the four-part anatomy | whatever the mail client printed |
| Name | the subject line in kebab-case, then the date | its export name, unchanged |
| Internal note and Status line | required | never |
| Editable | yes, until sent | never |
| PDF | optional, derived | the evidential copy: never regenerated |

Never apply the authored conventions to an archived thread: it records what was actually sent,
including anything that now reads awkwardly.

## Filing

`client-emails/<client-slug>/<family>/` for clients, `supplier-emails/<matter-slug>/` for
suppliers. The family leaf is decided by the engagement that owns the matter, not by a fresh
reading of the email's subject; where the call is not obvious, the internal note records it. A
formal notice served under a contract is an instrument and is filed with the instruments.

## Subject lines, length and follow-ups

- **Subject:** the matter first, then the one thing changed or asked; 50 characters or fewer, 60
  the ceiling; sentence case; never the attachment's title; never a list. A sent subject is never
  shortened afterwards.
- **Length:** as short as it can be while still answering what the reader would have asked. Lead
  with the decision or the ask; one idea a paragraph; bold what the reader must act on. Length is
  not scope: an ask, a caveat, a figure or a commitment is never cut to save words.
- **A follow-up never accuses.** Cut three moves: reciting what they undertook, counting the time
  elapsed, and denying that you are chasing. Make the reason for writing your own, and make 'no'
  and 'not yet' as easy to give as 'yes'.

## How we apply it here

- First person as `00-project.md ## Brief` sets it; the trading name is a label, never an actor.
- No em dashes in anything client-facing; en dashes only in ranges.
- The register is set by the reader: peer to peer with a specialist, plainly with a lay reader.
- An email never creates an obligation the instruments do not carry, never cites a clause number,
  never invents an entity detail (`[AWAITING USER INPUT]`, flagged in the internal note) and never
  names another client. It carries the correspondence disclaimer only where the disclaimers file
  has one, never a legal or financial one: it points to the instrument that carries that.
- A recipient's recorded preference (`<client-slug>/CLAUDE.md`) outranks the house default for
  that person, and is recorded only on the author's instruction, as the preference alone.
- Before sending: every unsent email to the same correspondent is read together, every placeholder
  is filled, every claim about a third party is true, and the email is registered.

## Who implements it

- **Skills:** `email-documents` holds the mechanics, loaded with the leaf family's skill;
  `draft-section` writes the body; `tone` reads it as its recipient will; `obligation-check`
  traces each commitment to its instrument.
- **Workflows:** `library/workflows/12-write-an-email/`.

## Governing standard

The leaf family's standard owns the substance; `standards/method/BUSINESS.md` and the brand voice
(`00-project.md ## Paths`) own the drafting principles and the voice. This guide and its
sub-document own the email mechanics.
