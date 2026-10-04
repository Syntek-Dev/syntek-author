# CONTEXT.md — research/src/testimony/

> **Safeguarding-critical.** Read `standards/risk/sensitive-content.md` before opening any file in
> this folder.

First-person testimony: the author's own story, or an account someone has entrusted to the author,
held as raw notes, memories, timelines and fragments. It is the most personal material in the
project. It is **not** prose for the reader and **not** a draft, and nothing here reaches the
manuscript, verbatim or paraphrased, without the explicit, considered decision of the person whose
story it is. Treat everything here as private by default. Empty at generation.

## Directory Tree

```text
research/src/testimony/
├── CONTEXT.md            ← this file: what lives here, and the consent record
├── CLAUDE.md             ← operating rules; read both before opening a note
└── <plain-name>.md       ← one note per strand of the story, plainly named
```

## What's here

**Each note carries a consent record in its frontmatter**, so consent is written down rather than
remembered:

```markdown
---
whose: author            # author | entrusted
teller: ""               # entrusted accounts only: a pseudonym the author chooses, never a real name
consent: not-asked       # not-asked | private | shape-only | paraphrase | verbatim
consent_date: ""         # DD/MM/YYYY, when the person decided
hard_lines: []           # what must never be used, in the person's own words
serves: []               # chapter slugs, once consent allows any use
last_updated: DD/MM/YYYY
---
```

- `not-asked` — nothing may leave this folder.
- `private` — asked, and the answer is no; the note stays here.
- `shape-only` — may inform the prose; no identifying detail and none of its wording.
- `paraphrase` — may be retold in the author's words; no wording quoted.
- `verbatim` — named passages may be quoted, and only those.

There are no statistics, sources or claims about others here; the argument's evidence lives in
`research/src/evidence/`.

## Cross-references

- `standards/risk/sensitive-content.md` — the governing standard; read it first, every time.
- `research/docs/reference/handling-testimony.md` — the guide: consent, protecting other people,
  the author's wellbeing.
- `research/workflows/05-handle-testimony-safely/` — the only procedure that works in this folder.
- `.claude/MEMORY.md` — Sensitivities (mapped in `00-project.md` `## Memory headings`): standing
  decisions about what is never used.
