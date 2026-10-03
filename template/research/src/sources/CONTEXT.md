# CONTEXT.md — research/src/sources/

Reading notes: one note per work the project draws on, recording what it argues, what is worth
quoting and where it disagrees with the position the work takes. Empty at generation. This is the
general case; a checkable claim belongs in `research/src/evidence/` and a wider question in
`research/src/notes/`, and the routing table in `research/src/CONTEXT.md` names any specialist
folder that wins over this one.

## Directory Tree

```text
research/src/sources/
├── CONTEXT.md            ← this file: the note format
├── CLAUDE.md             ← operating rules
└── <author-short-title>.md   ← one note per work, or per tight topic
```

## What's here

**Each note carries:** the work and its citation key, where the project keeps the citation database
· full bibliographic details, with the accessed date for anything online · what it argues, in a
sentence or two · which units it serves · quotable passages, copied exactly, **with page
numbers** · **where it disagrees with the position the work takes**, and how it would resist it ·
the date it was ingested.

```markdown
---
work: "Author, Short Title (Year)"
key: ""                  # citation key, where the project keeps the citation database
accessed: DD/MM/YYYY     # online sources only
ingested: DD/MM/YYYY
serves: []               # unit slugs, e.g. [03-the-ford]
---

# <Author> — <short title>

## What it argues
## Quotable passages
## Where it disagrees
## Bibliographic details
## History
```

Under `## Quotable passages`, each passage is a blockquote followed by its page or locator. The
accessed date is written DD/MM/YYYY here; the citation database stores it in ISO 8601.

## Cross-references

- `research/docs/reference/ingesting-sources.md` — the guide: route, read, note, key.
- `research/workflows/01-ingest-a-source/` — the procedure that writes these notes.
- `research/src/CONTEXT.md` — the routing table; check it before filing here.
