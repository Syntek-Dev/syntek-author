@./CONTEXT.md

# CLAUDE.md — library/src/social-media/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/src/CONTEXT.md` → `library/src/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold the business's social media plans, calendars and copy, every claim in them true and every
person in them there by permission.

## How to work here

- **Routing:** the `social-media-documents` skill and
  `library/docs/reference/social-media-standards.md`, through
  `library/workflows/14-create-a-social-media-document/`. The `tone` skill applies the brand voice
  at line edit, and `fact-check` checks every claim. A set of posts or bios can be a one-section
  document.
- **Model:** **Opus** for copy, claims and strategy; the mechanical tier for calendars' dates and
  layout.
- **Concrete steps:**
  1. Name the reader, the platform and the one thing the piece should make them do.
  2. Gather the evidence for every claim before drafting it (`research/src/evidence/`).
  3. Draft, revise and promote; check every name, quotation and figure; hand back for the author
     to publish.
- **Definition of done:** every claim is backed by a number, a source or the author's own
  experience, or it is cut; every named client and every quotation has recorded permission; every
  platform is named as it names itself; the copy reads in the house voice.

## Guardrails

- **Specificity earns trust; superlatives spend it.** No 'leading', 'world-class' or 'seamless'
  without the number that earns it; when there is no number, cut the word.
- **No client is named, quoted or shown without their written permission,** recorded in the
  Approvals path (`00-project.md` `## Paths`; by default `planning/src/approvals/`) before
  publication. A testimonial is quoted verbatim, and edited only with its author's agreement.
- **Platforms are named as they name themselves:** LinkedIn, Instagram, X (not Twitter),
  Facebook, TikTok, YouTube.
- **Emoji live only in example post copy,** never in a document's headings, tables or body.
- **No promise a post cannot keep.** A claim about what a client will get is a commitment;
  `obligation-check` traces it to the business's standard terms, or it is cut.
- **Never publish or schedule a post.** Publishing is the author's act.

## Output & naming

- **Hand-written:** plans, calendars and guides (`.tex`); profiles and campaign copy (`.md`);
  section drafts; named to the patterns in `library/docs/reference/social-media-standards.md`.
- **Generated (never hand-edit):** issued PDFs beside each `.tex`.
