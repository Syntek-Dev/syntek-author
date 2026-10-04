---
type: guide
skills: [social-media-documents, draft-section, tone, fact-check]
model: opus
---

# Social media standards — plans, calendars, profiles and copy

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** The standard for every document in `library/src/social-media/`: the plans that
set a period's direction, the calendars that schedule it, the profiles that introduce the
business, and the copy that goes out. The documents are professional references; the post copy
inside them may be informal. No social media document carries a disclaimer.

## Document types and their parts

| Type | Versioned | Must include |
|---|---|---|
| Social media plan | yes | Document Control; overview (objectives, audience, platforms, dates); two to five content pillars; a strategy per platform (goals, content types, cadence, posting times); hashtags and keywords; the calendar summary; KPIs (Metric · Target · How tracked); the review date |
| Content calendar | no | a header (Platform · Period · Owner · Last updated); the calendar (Date · Theme · Pillar · Format · Copy outline · Visual direction · Time · Status); notes on launches and seasonal hooks |
| Profiles and bios | no | one block per platform, within the platform's current character limit (`VERIFY` the limit) |
| Campaign or post copy | no | per post: platform, copy, visual direction, link, the claim's evidence |
| Brand voice guide (a client's) | yes | Document Control; three to five personality traits; tone by context (Context · Tone · Avoid); writing rules; three to five key messages; voice per platform; examples, right and wrong |

**Document Control** (plans and guides): Title, Period or Valid from, Version, Status (Draft ·
Active · Superseded), Owner, Next review.

## Platform names

Each platform is named as it names itself, in headings, tables and filenames: LinkedIn,
Instagram, X (never Twitter), Facebook, TikTok, YouTube. No abbreviation, and never a generic
'social' where the platform matters.

## Names and review

| Type | Pattern | Review |
|---|---|---|
| Plan | `social-media-plan-<period>-v<major>-<minor>-<DD-MM-YYYY>.tex` | at the period's end |
| Calendar | `content-calendar-<platform>-<period>.tex` | superseded by the next period's |
| Profiles | `profiles-<DD-MM-YYYY>.md` | on a change of offer or brand |
| Campaign copy | `<campaign>-<DD-MM-YYYY>.md` | none |
| Brand voice guide | `brand-voice-guide-<client-slug>-v<major>-<minor>-<DD-MM-YYYY>.tex` | yearly, or on a rebrand |

## How we apply it here

- Emoji appear only in example post copy, never in a heading, a table or the document's prose.
- Dates in metadata are DD/MM/YYYY; a calendar's heading may name its period ('Q2', a month).
- Every claim carries its evidence (`research/src/evidence/`) or is cut; every named client and
  quotation has its recorded permission in the Approvals path (`00-project.md` `## Paths`; by
  default `planning/src/approvals/`).
- The business's own voice lives in its brand folder (`00-project.md ## Paths`), not in a guide
  here; a brand voice guide in this family is a deliverable for a client.

## Who implements it

- **Skills:** `social-media-documents` holds the types and checks; `draft-section` writes the copy;
  `tone` applies the voice; `fact-check` checks every claim.
- **Workflows:** `library/workflows/14-create-a-social-media-document/`.

## Governing standard

`standards/method/BUSINESS.md` (specificity over superlatives) and the brand voice own the rules;
`standards/verification/BUSINESS.md` owns the gates. This guide owns the social media family's
types, parts, platform names, filenames and reviews.
