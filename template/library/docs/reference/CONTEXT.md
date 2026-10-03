# CONTEXT.md — library/docs/reference/

The template's own guides for the business library: six short answers to the questions every
document raises, from 'how big is a section?' to 'when does a change need a new version?'. They
are template-owned and updated by `copier update`. Project-specific guidance does not live here;
it goes in `library/docs/project/`.

## Directory Tree

```text
library/docs/reference/
├── CONTEXT.md                        ← this file
├── CLAUDE.md                         ← operating rules
├── section-anatomy.md                ← what one section is, its draft file, its shape
├── drafting-with-ai.md               ← the loop, who decides what, the five questions, the record
├── the-status-ladders.md             ← section status, document status, register Status
├── document-anatomy.md               ← the parts of a business document, in order, by family
├── latex-deliverables.md             ← house preamble, section markers, promotion, rendering
└── versioning-and-the-register.md    ← vMAJOR.MINOR, new files for new versions, the register
```

## What's here

- `section-anatomy.md` — the small passage the loop works on, the draft file and its frontmatter,
  and the shape of a good business section.
- `drafting-with-ai.md` — the authoring loop in table form, who decides which facts, the five
  questions every document answers first, and the provenance record.
- `the-status-ladders.md` — the three lifecycles kept apart: a section's status, a document's
  status (in the unit brief and the `.tex` comment block) and the register's publication Status.
- `document-anatomy.md` — the parts every deliverable carries and the required parts per family.
- `latex-deliverables.md` — the house preamble and skeleton, the `% section:` markers, converting
  a Markdown draft on promotion, and rendering twice.
- `versioning-and-the-register.md` — version numbers, versioned filenames, superseding a
  circulated document, and what the register records.

## Cross-references

- `library/docs/project/` — your guides; a same-named file there overrides one here.
- `library/workflows/` — the procedures that apply these guides step by step.
- `standards/method/BUSINESS.md` and `standards/verification/BUSINESS.md` — the rules and gates
  these guides serve.
