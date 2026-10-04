# CONTEXT.md — library/src/social-media/

The social media family: what the business says to people who have not yet asked, on the
platforms where they are. Social media plans, content calendars, profiles and bios, campaign copy
and client brand voice guides live here, for the business itself at the family root and for
clients in their folders. The business's own voice and visual identity are rules, not documents:
they live in the brand folder `00-project.md ## Paths` names, not here.

## Directory Tree

```text
library/src/social-media/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules
├── templates/              ← reusable plan, calendar and profile starting points
├── client-docs/            ← one <client-slug>/ folder per client plan, calendar or campaign
└── drafts/                 ← section drafts, one <unit-slug>/ folder per piece (README.md only)
```

## What's here

- **Social media plans** — `social-media-plan-<period>-v<major>-<minor>-<DD-MM-YYYY>.tex`,
  versioned and registered, reviewed when the period it covers ends.
- **Content calendars** — `content-calendar-<platform>-<period>.tex`, unversioned: each period's
  calendar supersedes the last.
- **Profiles and bios** — `profiles-<DD-MM-YYYY>.md`, one file holding every platform's copy, ready
  to hand to the platforms.
- **Campaign and post copy** — `<campaign>-<DD-MM-YYYY>.md`, one file per campaign. Its frontmatter
  carries `unit:` and `status:`, kept in step with its brief
  (`library/docs/reference/the-status-ladders.md`).
- **Brand voice guides for clients** —
  `brand-voice-guide-<client-slug>-v<major>-<minor>-<DD-MM-YYYY>.tex` in the client's folder.
- **Types, parts, naming and review cycles** are in
  `library/docs/reference/social-media-standards.md`.

## Cross-references

- `library/docs/reference/social-media-standards.md` — this family's standard.
- `library/workflows/14-create-a-social-media-document/` — the procedure that makes a document
  here.
- `planning/src/approvals/` — the default Approvals path (`00-project.md` `## Paths`), where a
  client's permission to be named is recorded.
- `research/src/evidence/` — the evidence behind every claim the copy makes.
