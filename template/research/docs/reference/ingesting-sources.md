---
type: guide
skills: [research]
model: opus
---

# Ingesting a source — from a passing mention to a note the work can cite

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** How a work gets from 'someone mentioned it' to something the project can cite:
route it, read it at its origin, note what it argues and where it disagrees, and key it, all in
one pass, so nobody has to read it twice.

## Route it before you write

Most ingestion mistakes are filing mistakes. The routing table in `research/src/CONTEXT.md` decides
where material goes. The three folders every project has:

| The source gives you… | It goes to… |
|---|---|
| A checkable claim: a figure, a date, a study finding, a legal statement | `research/src/evidence/`, through `research/workflows/02-verify-a-claim/` |
| An argument, a position, a work's case | `research/src/sources/` |
| An answer to a question the work needs settled | `research/src/notes/` |

Anything the routing table sends to a specialist folder goes there instead. A single work can feed
two folders: split the note rather than duplicating it. Filing a checkable claim in `sources/`
bypasses `02-verify-a-claim`, the only route by which a claim gets a verdict.

## Read the thing

Not the abstract, not the press release, not another book's account of it. **Follow the chain back
to the primary source**: coverage citing a report citing a study is three chances for a claim to
drift, and the drift always runs towards whatever is quotable. If only a secondary account can be
had, say so in the note. For anything online, record the date you accessed it as you go: pages
change without notice, and that date is what makes a later re-check possible.

## Note what it argues, not what it is about

'This book is about grief' is not a note. 'It argues X from Y, and concedes Z' is. The test: could
someone who has not read the source use your note to decide whether they need to? Record the
argument in a sentence or two, the unit it serves, and quotable passages **with page numbers**,
captured now. Going back for them later is miserable enough that it rarely happens, which is how
vague citations get written.

## Record the disagreement

A note that harvests only agreeable quotations produces a work that cites people who would not
endorse its conclusion, and leaves the later review passes nothing to test it against. Where a
source would resist the position the work takes, write down *how*, not just *that*. A source that
agrees with everything has probably not been read carefully.

## How we apply it here

- **Key it as you write it.** Where the project keeps the citation database, the note and its row
  are written together with the add-reference skill, then `make dump` and `make refs`. Where it does not,
  the note carries complete bibliographic details itself. Never 'key it later'.
- **Don't smuggle a verdict.** A note records what a source says, not what the work should
  conclude from it; the conclusion belongs to the unit.
- **Quote exactly or not at all.** A passage you cannot find again is not quoted.
- **Never invent** a source, a page number or a quotation
  (`.claude/rules/syntek-author/03-authorship.md`).
- **Never overwrite a note.** Supersede it with a dated addition.

## Who implements it

- **Skill:** `research` (reading, and delegated search when the source must be found first).
  **Workflow:** `research/workflows/01-ingest-a-source/`.

## Governing standard

`standards/verification/verification.md` owns what evidence a unit needs before it moves on; the
referencing standard, where the project has one, owns the citation contract. The standards own the
rules; this guide owns getting a source into the repository properly.
