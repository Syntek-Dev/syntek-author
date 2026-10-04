# CONTEXT.md — research/src/notes/

Question-led notes: one note per question the work needs settled, written by the `research` skill
from primary sources and cited claim by claim. Empty at generation. A note answers a question that
no single source answers ('what did a parish clerk's week look like in the 1840s?', 'what must a
retention notice contain?'); a reading note on one work lives in `research/src/sources/`, and a
single checkable claim in `research/src/evidence/`. This is the default home: a project whose
`00-project.md` `## Paths` names another ('Research notes') keeps its notes there.

## Directory Tree

```text
research/src/notes/
├── CONTEXT.md            ← this file: the note format
├── CLAUDE.md             ← operating rules
└── <topic>.md            ← one note per question, named for its subject
```

## What's here

**Each note carries:** the question, in one sentence · the answer in two or three sentences · each
claim on its own line, ending in its primary-source citation and the date it was checked · any
conflict between sources, stated rather than averaged · the sources consulted, listed once · the
units or decisions the note feeds.

```markdown
---
question: "One answerable question, verbatim."
checked: DD/MM/YYYY
feeds: []                # unit slugs, or the MEMORY decision it grounds
---

# <The question's subject>

## Question
## Verdict
## Claims
## Conflicts
## Sources
## Feeds
## History
```

`## Verdict` is the answer to the question. Any single claim the answer rests on, and that the work
will state, also goes through `research/workflows/02-verify-a-claim/` and carries one of the six
fact-check verdicts in its own evidence entry.

## Cross-references

- `.claude/skills/research/SKILL.md` — the skill that frames the question and writes the note.
- `research/docs/reference/vetting-evidence.md` — what a cited claim must carry.
- `.claude/MEMORY.md` — where a durable finding goes once the author confirms it.
