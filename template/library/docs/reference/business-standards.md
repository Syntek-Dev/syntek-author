---
type: guide
skills: [business-documents, draft-section, structure-review, obligation-check]
model: opus
---

# Business standards — the business family's documents, parts and names

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** The standard for every document in `library/src/business/`: what the business
offers, agrees in outline and hands over, and its own plan and procedures. It names the document
types, the parts each carries beyond the shared anatomy (`document-anatomy.md`), how each is named
and when it is reviewed. A missing required part is a structural finding, not a style choice.

## Document types

| Type | Versioned | Where | Disclaimer class |
|---|---|---|---|
| Proposal or quote | yes | `client-docs/<client-slug>/` | proposals, when sent |
| Statement of work | yes | `client-docs/<client-slug>/` | proposals |
| Client guide: onboarding pack, setup guide, implementation plan, handover | when sent as a deliverable | `client-docs/<client-slug>/` | none |
| Meeting notes | no | `client-docs/<client-slug>/` | none |
| Intake questionnaire | no | `client-docs/<client-slug>/` | none |
| Company document: letterhead, agenda, minutes, internal HR or staff-conduct policy, staff notice (an IT or security policy is the msp-scp family's, where the project has it) | an internal policy, yes; the rest no | the family root; a letterhead in `templates/` | none |
| Business plan, procedures, handbook | no (living) | the family root | financial documents, where it projects figures |
| Template | no | `templates/` | its documents' class |

## Required parts

- **Proposal:** Document Control (Title, Client, Version, Status, Date, Valid until, Owner); the
  disclaimer when it is sent; summary; scope with In scope and Out of scope; deliverables;
  timeline (Milestone · Description · Target date); investment as line items (Item · Description ·
  Price), never one total; a terms summary that points to the instrument; next steps; contacts.
- **Statement of work:** Document Control; the agreement it sits under and the precedence between
  them; scope with In scope and Out of scope; deliverables with acceptance criteria; milestones;
  fees and payment schedule; assumptions and dependencies; change control; signature block.
- **Client guide:** who it is for and what they will be able to do; what they need first; the steps
  in order; where to get help. Credentials never appear in it: it says where they are kept.
- **Meeting notes:** Date · Time · Attendees · Place · Subject; numbered agenda items with the notes
  and decisions under each; action items (Action · Owner · Due date).
- **Business plan:** summary; the business (trading name, legal structure, sector); products and
  services; market and customers; competition; operating model; financial overview, every
  projection labelled as one; goals and milestones.

## Names and review

| Type | Pattern | Review |
|---|---|---|
| Proposal, quote | `proposal-<client-slug>-v<major>-<minor>-<DD-MM-YYYY>.tex` (or `quote-…`) | none: kept as sent; a revision is a new version |
| Statement of work | `statement-of-work-<client-slug>-v<major>-<minor>-<DD-MM-YYYY>.tex` | per engagement |
| Client guide | `<guide-type>-<client-slug>-<DD-MM-YYYY>.tex` | when the client's set-up changes |
| Meeting notes | `meeting-notes-<client-slug>-<DD-MM-YYYY>.tex` | none |
| Intake questionnaire | `intake-questionnaire-<client-slug>-<DD-MM-YYYY>.tex` | none: kept as sent |
| Company document | `<doc-type>-<DD-MM-YYYY>.tex` (agenda, minutes, staff notice); `<policy-type>-policy-v<major>-<minor>-<DD-MM-YYYY>.tex`; a letterhead is a template | an internal policy yearly, or when the law or the business changes; the rest none |
| Business plan | `business-plan.tex` | on a material change to the business |
| Template | `template-<doc-type>.tex` | yearly, or when the standard terms change |

## How we apply it here

- Every price, date and service level comes from the author; a gap is
  `\dnote{AUTHOR TO CONFIRM: …}`, never an estimate.
- The voice is the brand voice in the business's person (`00-project.md ## Brief`, and the brand
  folder `00-project.md ## Paths` names): written to a real reader, three to five sentences a
  paragraph, no superlative without its number.
- A terms summary describes the instrument; it never restates or numbers a clause.
- A client with more than one document of a type adds a subject after the slug in its name.
- Before `final`: every required part present, the disclaimer where the class carries one, the
  currency `00-project.md` `## Brief` names, in the style sheet's format, and the register row written.

## Who implements it

- **Skills:** `business-documents` holds the types and checks; `draft-section` writes the sections;
  `obligation-check` traces every commitment; `structure-review` checks the parts.
- **Workflows:** `library/workflows/10-create-a-business-document/`, and the loop it drives.

## Governing standard

`standards/method/BUSINESS.md` owns the drafting principles and `standards/verification/BUSINESS.md`
the gates; the disclaimer wording lives in the disclaimers file `00-project.md ## Paths` names. This
guide owns the business family's types, required parts, names and review cycles.
