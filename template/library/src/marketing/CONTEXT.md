# CONTEXT.md — library/src/marketing/

The marketing family: what the business says to people who have not yet asked. Marketing plans,
content calendars, website and campaign copy, case studies, social posts and bios live here.
Printed or sent documents are `.tex`; copy handed to a website or a social platform may be
Markdown. The brand rules this copy follows live in `standards/brand/`, not here.

## Directory Tree

```text
library/src/marketing/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules
├── templates/              ← reusable plan, case study and post starting points
├── client-docs/            ← one <client-slug>/ folder per client case study or campaign
└── drafts/                 ← section drafts, one <unit-slug>/ folder per piece (README.md only)
```

## What's here

- **Marketing plans** — `marketing-plan-<period>-v<major>-<minor>-<DD-MM-YYYY>.tex` at the family
  root, versioned and registered, reviewed at the end of the period they cover.
- **Content calendars** — `content-calendar-<channel>-<period>.tex`, unversioned: each period's
  calendar supersedes the last.
- **Website and campaign copy** — `<page-or-campaign>-<DD-MM-YYYY>.md`, one file per page or
  campaign, ready to hand to the platform. Its frontmatter carries `unit:` and `status:`, kept in
  step with its brief (`library/docs/reference/the-status-ladders.md`).
- **Case studies** — `case-study-<client-slug>-v<major>-<minor>-<DD-MM-YYYY>.tex` in the client's
  folder, published only with the client's recorded permission.
- **Registers of voice.** Running copy uses `standards/brand/brand-voice.md`; short functional copy
  (buttons, labels, bios) is terse and action-first.

## Cross-references

- `standards/brand/brand-voice.md` and `standards/brand/brand-guide.md` — voice and visual identity.
- `planning/src/approvals/` — where a client's permission to be named is recorded.
- `research/src/evidence/` — the evidence behind every claim the copy makes.
