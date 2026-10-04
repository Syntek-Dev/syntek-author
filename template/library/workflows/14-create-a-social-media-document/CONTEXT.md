# CONTEXT.md — library/workflows/14-create-a-social-media-document/

The front door for a new document in the social media family: a social media plan, a content
calendar, a set of profiles and bios, a campaign's copy, or a brand voice guide for a client. It
settles the type, the period and the platforms; gathers the evidence and the permissions every
claim and every name needs; plans the sections from the parts
`library/docs/reference/social-media-standards.md` requires; then drives the shared loop and the
review to `final`. Publishing stays the author's act.

## Directory Tree

```text
library/workflows/14-create-a-social-media-document/
├── CHECKLIST.md            ← verification checklist before marking complete
├── CLAUDE.md               ← operating rules for this workflow
├── CONTEXT.md              ← this file (when to use, what it produces, the failure it prevents)
└── STEPS.md                ← ordered steps to execute
```

## When to use this

- The author asks for a plan, a calendar, profiles, a campaign or posts: 'plan next quarter on
  LinkedIn', 'write the launch posts', 'refresh our bios'.
- A client has asked for a plan, a calendar or a brand voice guide of their own.

Reach for a **different** procedure when: the business's own voice or brand rules need changing
(those are standards, changed only on the author's instruction); a live plan has reached the end
of its period (a new plan, through this procedure, superseding the last); or the piece is a
proposal to run a client's social media (the business family's create procedure).

## What it produces, and where

- **A unit brief** at `planning/src/units/<unit-slug>.md`: the period, the platforms, the reader,
  the one thing each piece should make them do.
- **Evidence and permissions:** an entry in `research/src/evidence/` for every claim, and a
  recorded permission in the Approvals path (`00-project.md` `## Paths`; by default
  `planning/src/approvals/`) for every client named or quoted.
- **The document** at the family root (the business's own) or
  `library/src/social-media/client-docs/<client-slug>/`, built through the loop, reviewed to
  `final`, registered where the standard says, with its issue PDF beside a `.tex`.

## The failure this procedure exists to prevent

**A public claim nobody can stand behind.** Copy written to sound good reaches for the superlative,
the borrowed testimonial and the round number. Once published it is the business's word in front
of everyone. Gathering the evidence and the permissions before drafting, and naming each platform
as it names itself, keeps every post defensible.

## Cross-references

- `library/docs/reference/social-media-standards.md` — the types, parts, platforms and names.
- `planning/src/approvals/` — the default Approvals path (`00-project.md` `## Paths`), where
  permission to name a client is recorded.
- `research/src/evidence/` — the evidence behind every claim.
