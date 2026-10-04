---
name: social-media-documents
description: >-
  Create a social media document, or check that one has everything its type requires: a social
  media plan, a content calendar, a set of profiles and bios, a client's brand voice guide, or
  campaign and post copy. Holds each type's required sections, the calendar's columns and status
  values, the questions to settle first, the claims rules for posts (advertising, endorsements,
  reviews, evidence) and the pre-issue checklist, and routes to the create workflow and the social
  media standard. Use when the author says 'plan our social media for the quarter', 'write a month
  of posts', 'build a content calendar', 'refresh our bios', 'write a voice guide for the client'
  or 'what should this plan include?'. Never invents a figure, benchmark, review or testimonial.
  Not the business's own voice notes (`learn-voice`); not one section of a document
  (`draft-section`); not a line-edit for voice (`tone`); not a proposal for social media services
  (`business-documents`).
---

# Skill: Social media documents (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

The social media family is the business's public voice in short form, for itself or for a client:
the plan behind the posts, the calendar that schedules them, the profiles that frame them, and the
posts themselves. This skill owns the family's domain: which document types exist, what each must
contain, and the rules that keep a post honest. Its licence is tone, never substance: a figure, a
date, a claim about the business or anything a reader could rely on is held to the same standard
as a contract. The procedure of record is the create workflow. Whenever another skill works on a
document in `library/src/social-media/`, the conventions and checklist here bind it too.

## Governing procedures (route here — do not restate at length)

- `library/workflows/14-create-a-social-media-document/` — the procedure of record for a new social
  media document; this skill is its domain in skill form. Run its `STEPS.md` with `CHECKLIST.md`
  open. Where this file and the procedure disagree, the procedure wins and the disagreement is
  reported to the author. An alias in `00-project.md` `## Workflow aliases`, then a same-named
  folder in `library/workflows/local/`, replaces it (`run-workflow`).
- `library/docs/reference/social-media-standards.md` — the family standard: naming, document
  control rows, platform naming and review cycle. Route there; do not restate it.
- `.claude/rules/syntek-author/00-project.md` — `## Brief` (trading name, voice, audience)
  and `## Paths` (brand folder, client facts, LaTeX skeleton, disclaimers). It outranks every other
  rules file; take those values from it.
- `.claude/rules/syntek-author/03-authorship.md` Section 4 (never fabricate),
  `standards/method/BUSINESS.md` rules 1 and 10 (specificity; the marks of running copy) and
  `standards/risk/BUSINESS.md` rules 1, 3 and 5.

## Document types and required sections

### Social media plan

1. Summary: goals, platforms, measures, budget
2. Goals, primary and secondary, each specific, measurable and dated
3. Audience: one to three personas (role, needs, where they spend time online)
4. Platform strategy, one subsection per platform in scope: why this audience is there, the
   content types, cadence, posting times (to be checked against the account's own analytics),
   hashtags and keywords, and the register on that platform
5. Content pillars: two to five themes, each with example ideas and its share of the mix
6. The calendar summary for the first period agreed (the calendar itself is its own document)
7. Measures (Metric · Target · How tracked), per platform
8. Budget, where there is one: organic against paid, paid spend by platform, hours of community
   management
9. Tools the author already uses or names; none recommended unasked
10. Governance: who approves posts, the crisis-response path and timings, moderation of comments
    and messages
11. Review cadence for the measures, and the plan's review date

### Content calendar

One per platform and period, as the standard names it: a header (Platform · Period · Owner · Last
updated), then a `tabularx` table (`longtable` when it runs past a page) in the columns the
standard gives (Date · Theme · Pillar · Format · Copy outline · Visual direction · Time · Status),
one row per post, then notes on launches and seasonal hooks. Status reads `Draft`, `Scheduled` or
`Published`; copy is written in full wherever the author has given enough to write it, otherwise
outlined; visual direction describes the image or video, never produces it.

### Profile bios

For each platform requested: the platform and the current limits of each field (checked at the
date of drafting, and recorded); the bio written in full within its limit; a headline or tagline
where the platform has one; the call to action and where the link goes; keywords or hashtags
where the platform uses them; and anything particular to that platform.

### Brand voice guide (a client's)

1. The brand in brief: purpose, values, positioning
2. Personality: three to five traits, each with what it means in practice, a do and a don't
3. Tone by context (Context · Tone · Avoid)
4. Writing rules: words to use and avoid, sentence length, emoji, hashtags, calls to action
5. Key messages, three to five
6. Voice per platform
7. Examples, right and wrong, each saying what makes it so
8. A one-page quick reference

### Campaign or post copy

Each post: the platform, the copy in full within its limit, the visual direction, the call to
action and link, any label it must carry, and the evidence for every claim it makes, so the copy
can be moved into a calendar unchanged.

## House conventions

- **Format.** A plan or guide is a LaTeX deliverable from the skeleton `00-project.md` `## Paths`
  names (by default `tooling/latex/skeleton.tex`): the summary first, each platform a
  `\subsection`, every measure and calendar a `tabularx`. Profiles and campaign copy are Markdown
  documents, named as the standard gives.
- **Where it lives.** A client's documents in `library/src/social-media/client-docs/<client-slug>/`;
  the business's own channels at the family root; reusable starting points in `templates/`.
- **Whose voice.** The business's own voice lives in the brand folder `00-project.md` `## Paths`
  names, never in a guide here: a plan for the business's own channels applies it, and a conflict
  goes to the author. A brand voice guide in this family is a client's deliverable, built from what
  the client gives. Never invent a brand value. Platforms are named as they name themselves, as
  the standard lists them.
- **Platforms change.** Character limits, formats, hashtag practice and posting times move;
  every one used is checked at the date of drafting (`research` or `fact-check`) and recorded with
  the date in the internal note. Engagement benchmarks are dated ranges from a named source, never
  a figure from memory.
- **Claims are advertising.** A post that promotes the business is advertising under the CAP Code
  (the UK Code of Non-broadcast Advertising and Direct and Promotional Marketing, enforced by the
  Advertising Standards Authority): every objective claim is substantiated before it is posted; a
  paid partnership, gifted product or affiliate link is labelled as an advertisement. A review or
  testimonial is genuine, attributable and used with permission; fake or concealed-incentive
  reviews are banned by the Digital Markets, Competition and Consumers Act 2024. Check each
  against the current text with `fact-check` when it matters.
- **People.** No personal data, image, story or quotation of a real person, and no client named,
  without the permission recorded in the Approvals path (`00-project.md` `## Paths`; by default
  `planning/src/approvals/`), as `standards/risk/BUSINESS.md` rules 1 and 3 require.
- **Register.** Accessible, specific and practical; matched to the platform; for the business's
  own channels, the voice `00-project.md` `## Brief` records, and for a client's, theirs; no em
  dashes in copy; advice measurable ('two posts a week on each platform'), never 'post great
  content'.
- **No disclaimer.** No social media document carries one, and a post never does.

## How to create a social media document

1. **Fix the type and its home.** Agree with <%AUTHOR_FIRST_NAME%> the type from the lists above,
   whose channels it is for (the business's own or a client's), the platforms and the period.
   Check `planning/src/document-register.md` for the plan or calendar it continues. Name the file
   from `library/docs/reference/social-media-standards.md`. *Complete when:* the type, the
   account, the platforms, the path and the filename are agreed.

2. **Settle the questions first.** Read `00-project.md` `## Brief` and `## Paths`, the brand voice,
   and for a client their facts file (by default
   `library/src/business/client-docs/<client-slug>/CONTEXT.md` under `## Facts`). Ask what is
   still unknown, with a recommended answer each, as `06-global-rules.md` Section 8 says unless
   `00-project.md` `## Overrides` sets another style: the five questions of
   `standards/method/BUSINESS.md` rule 6, then the platforms in scope, the main goal, the audience,
   the frequency, the brand guidance already in place, the topics on and off limits, and who
   approves posts. *Complete when:* every question is answered, or stands as `[AWAITING USER
   INPUT]` or an `AUTHOR TO CONFIRM` flag.

3. **Check the platforms and gather the evidence.** For each platform, check the current limits
   and formats and record them with the date. List every claim the copy will make (a figure, a
   result, a credential, a client's name) and its evidence; a claim without evidence is cut or
   flagged `VERIFY`, never posted. *Complete when:* every platform fact is dated and every claim
   has its evidence or its flag.

4. **Plan and start the document.** A plan or guide is planned through
   `planning/workflows/01-plan-a-unit/` with one section per required section above, then started
   from the skeleton with one `% section:` marker pair per brief section. A calendar, a set of
   profiles or campaign copy starts from the family template, one row or entry per post or platform.
   *Complete when:* the brief is agreed (V1 dated) or the template is in place.

5. **Write through the loop.** One section, or one batch of posts, per request: `draft-section`,
   then `adapt-section` or `improve-section`, then `promote-section` on the author's word. Copy is
   written in full within each limit, never left as a placeholder when the author has given enough
   to write it. *Complete when:* every section or batch is promoted, or the author has paused with
   the rest listed.

6. **Run the family's checks.** The required sections present (`structure-review`); every claim
   checked (`fact-check`); every promise to a customer bounded (`obligation-check`); `tone` for the
   voice. Work the checklist below with `make flags SCOPE=<path>` and `make lint SCOPE=<path>`.
   *Complete when:* every item is ticked or reported open with its location.

7. **Register it and hand back.** Add its row through `planning/workflows/08-update-the-register/`,
   its review date in `planning/src/review-schedule.md`, and its listing in its folder's
   `CONTEXT.md`. Nothing is posted by this skill: hand back the document, every open flag, and
   what the author must approve before scheduling.
   *Complete when:* the register row is written and the author has the hand-back.

## Pre-issue checklist

- [ ] Every required section for the type present; every platform in scope covered.
- [ ] Two to five content pillars, each with ideas and its share of the mix (plans).
- [ ] Every measure with its target and how it is measured.
- [ ] Governance: approval, crisis response and moderation stated (plans).
- [ ] Copy written in full within each platform's limit, the limit checked and dated.
- [ ] Every claim evidenced; every advertisement, gift or affiliate link labelled.
- [ ] Reviews and testimonials genuine, attributed and used with permission.
- [ ] No real person or client named or shown without recorded consent.
- [ ] A do and a don't for each trait (voice guides); no tool named that the author did not name.
- [ ] No `[AWAITING USER INPUT]` or open flag left in copy due to go out.
- [ ] en_GB, DD/MM/YYYY, single quotation marks, no em dashes; register row written.

## Anti-patterns

- **A benchmark from memory.** 'Engagement is typically…' needs a source and a date, or goes.
- **A claim the business cannot evidence.** On social media it is an advertising claim.
- **An unlabelled endorsement.** A gifted, paid or affiliate post says so.
- **Inventing a testimonial, a review or a follower count.**
- **Overriding the business's own voice.** A plan for its channels applies the record in the
  brand folder; it never replaces it.
- **Recommending a tool unasked.** Name only what the author uses or names.
- **Posting.** This skill writes documents; the author schedules and posts.

## Cross-references

- `library/docs/reference/social-media-standards.md` — the family standard.
- `library/workflows/14-create-a-social-media-document/` — the procedure of record.
- `.claude/rules/syntek-author/00-project.md` — the project's values and paths.
- `standards/brand/CONTEXT.md` — the brand voice and brand guide.
- `standards/method/BUSINESS.md`, `standards/risk/BUSINESS.md`.
- `.claude/skills/draft-section/SKILL.md`, `.claude/skills/promote-section/SKILL.md` — the loop.
- `.claude/skills/fact-check/SKILL.md`, `.claude/skills/tone/SKILL.md`,
  `.claude/skills/obligation-check/SKILL.md` — claims, voice and promises.
- `.claude/skills/business-documents/SKILL.md` — a proposal to run a client's channels.
