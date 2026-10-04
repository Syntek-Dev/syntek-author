# BUSINESS.md — adapt-section, business mode

The domain for revising a section of a business document from the author's notes, for adapting a
template into one client's document, and for bringing an existing document into the house form.

## Paths and unit

- **Unit:** a document. **Section:** one clause group, one part of a proposal or letter, or one
  rule area of a policy.
- **Procedures:** `library/workflows/02-adapt-a-draft/` (notes, hand-edits and template
  adaptations) and `library/workflows/08-ingest-an-existing-document/` (its conversion and
  house-form steps).
- **Draft:** `library/src/<family>/drafts/<unit-slug>/<NN>-<section-slug>.md`, in one of the
  families this project selected (`business`, `legal`, `email`, `accounting`, `social-media`,
  `msp-scp`); its brief is `planning/src/units/<unit-slug>.md`.
- **Family skill:** read the family's skill, `<family>-documents`, as well as this file: the
  family's document types, required sections, conventions and checks.
- **Project paths:** the 'Client facts' and 'Brand folder' rows of `00-project.md` `## Paths` say
  where those live; this file names the template defaults.
- **Templates:** `library/src/<family>/templates/`. **Client facts:** one home per client, by
  default `library/src/business/client-docs/<client-slug>/CONTEXT.md`, under `## Facts`.
- **Kinds of source this project adapts (step 7):** a template turned into one client's document,
  and an existing document (the author's, a client's or a third party's) brought into the house
  form.
- **Guides:** `library/docs/reference/drafting-with-ai.md`,
  `library/docs/reference/section-anatomy.md`,
  `library/docs/reference/versioning-and-the-register.md` and
  `library/docs/reference/document-anatomy.md`.

## Additions to the steps

- **Step 3 — also put commitments back to the author.** A note that asks you to decide a
  commitment, a price, a date, a service level or a scope boundary is returned as a question; it
  is never answered by drafting.
- **Step 5 — also keep the register.** An instrument or a policy stays formal; running copy keeps
  the brand voice (by default `standards/brand/brand-voice.md`); every line keeps the voice person
  in `00-project.md` `## Brief` ('I' or 'we'), and no em dash enters client copy.
- **Step 6 — also the holding line is the most conservative wording.** Until the author chooses,
  the draft carries the alternative with the narrowest commitment, and the hand-back says so.
  That wording is the AI's: it goes into the run's `ai` revision with its open row (step 9), so a
  later comparison never takes it for the author's, and the section is not promoted until the
  row is decided (`promote-section`).
- **Step 7 — also adapt a template for one client.** Write one draft per section of the new
  document from the matching part of the template. Fill each placeholder only from the author or
  the client's facts; leave any other as `[AWAITING USER INPUT]`. Keep the template's clause order
  and labels. List every change the author instructs to a term for `obligation-check` against the
  template's standard position. Record the template's name and review date in each draft's
  internal note. Set `origin: author` and `format: 2`, leave `## AI original` empty, and record
  each draft as first written from the template under `## Author original`: the wording is the
  template's, already approved, and every change made to it after that is a revision, logged in
  step 9.
- **Step 7 — also bring an existing document into the house form.** Follow
  `library/workflows/08-ingest-an-existing-document/`: the original is filed unchanged; the reading
  copy carries an internal note listing every conversion loss, by location, never repaired from
  memory; each planned section's draft is copied word for word from the reading copy
  (`status: author-draft`, `origin: author`, an internal note naming the source and who wrote
  it), the same text under its entry's `## Author original`; only then do the author's
  instructions bring it into the house parts, order and terms, each change a revision.
- **Step 8 — also check what must not change.** Compare the revised draft with the version before
  this pass: every figure, date, price, scope boundary, defined term and obligation is unchanged
  unless a numbered note changed it. Any other difference is reverted, or raised with the author.
  `obligation-check` runs this comparison.

## Domain rules

- **Obligations are never invented, softened or strengthened** by a revision
  (`.claude/rules/syntek-author/03-authorship.md` Section 7).
- **Shorten the writing, never the obligation** (`standards/method/BUSINESS.md` Section 2).
- **A delivered document is a historical record** (Section 8): a circulated document is never
  adapted in place; a new version is opened first
  (`library/docs/reference/versioning-and-the-register.md`).
- **A client's facts are cited from their file**, never retyped from memory or another document.

## Examples

Invented alternatives for a contested commitment (step 6), differing in strength:

```text
Note 4: 'The response time sounds like a promise we can't keep.'
  1. '[I or we] aim to reply within two working days.' (an aim, not a commitment)  ← holding line
  2. '[I or we] reply within two working days, Monday to Friday.' (a bounded commitment)
  3. '[I or we] reply within two working days, and the same day to an urgent issue.' (stronger; needs a service level)
```

An invented template-adaptation internal note (step 7):

```markdown
<!-- INTERNAL NOTE: adapted from the services agreement template (review date as recorded in its file) for one client; clause order kept; fee and term changes listed for obligation-check. -->
```
