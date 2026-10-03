---
workflow: 01-ingest-a-source
phase: research
skills: [research]
model: opus
---

# STEPS.md — ingest a source

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for reading a work into the evidence base and keying it, in one pass so nobody
has to read it twice. Each step names the skill and guide it uses, and any `make` command. **Run in
order** — the ordering is load-bearing — and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`), then
> `research/docs/reference/ingesting-sources.md`. The `research` skill does the reading.

## 1. Route it — before anything else

> **Skill:** `research` · **Guide:** `research/docs/reference/ingesting-sources.md`

Use the routing table in `research/src/CONTEXT.md`. A checkable claim stops here and goes to
`research/workflows/02-verify-a-claim/`; material the table sends to a specialist folder goes to
that folder's procedure. Continue for an argument, a position or a work's case (`sources/`). A
single work can feed two folders: **split the note; do not duplicate it.** _Substantive._

## 2. Get to the primary source

> **Skill:** `research` · **Guide:** `research/docs/reference/ingesting-sources.md`

Locate the work, then read it at its origin: not the abstract, not another book's account, not the
press release. **Follow the chain back.** If only a secondary account can be had, say so in the
note and treat the source as weaker for it. _Substantive._

## 3. Capture the bibliographic details and the accessed date

> **Skill:** `research` · **Guide:** `research/src/sources/CONTEXT.md`

Author or organisation, year, title, container, edition, publisher, place, volume, issue, pages,
URL, DOI. For anything online, the date you accessed it, written DD/MM/YYYY in the note. _Mechanical._

## 4. Note what it argues

> **Skill:** `research` · **Guide:** `research/docs/reference/ingesting-sources.md`

What it argues, not what it is about, in a sentence or two. The test: could someone who has not
read the source use the note to decide whether they need to? _Substantive._

## 5. Capture quotable passages — with page numbers

> **Skill:** `research` · **Guide:** `research/docs/reference/ingesting-sources.md`

Copy each passage exactly, with its page or locator, now rather than later. A passage you cannot
find again is not quoted. _Substantive._

## 6. Record where it disagrees with the work

> **Skill:** `research` · **Guide:** `research/docs/reference/ingesting-sources.md`

**The most valuable part of most notes.** Where would this source resist the position the work
takes, and how? Write down how, not just that. A source that agrees with everything has probably
not been read carefully. _Substantive._

## 7. Name the units it serves

> **Skill:** `research` · **Guide:** `research/src/sources/CONTEXT.md`

One or more unit slugs from `planning/src/units/`. If you cannot name one, ask the author whether
the source belongs in the repository at all. _Substantive._

## 8. Write the note

> **Skill:** `research` · **Guide:** `research/src/sources/CONTEXT.md`

In the source-note format, written for accuracy rather than readability. **Do not smuggle a
verdict:** record what the source says, not what the work should conclude. **Never overwrite** an
existing note; supersede it with a dated addition under `## History`. _Substantive._

## 9. Key it — now, not later

> **Skill:** add-reference, where present · **Guide:** `research/docs/reference/ingesting-sources.md`

Where the add-reference skill is present, mint the key with it (lower-case `authorYYYY`,
collision-checked, never renamed), put the key in the note's `key:` field, then:

```sh
make dump    # snapshot the database to text; commit it
make refs    # regenerate the citation data the build reads
```

Where it is not, check that the note's bibliographic details are complete enough for a stranger to
find the work again. Minting the key is judgement; the `make` runs are mechanical. _Substantive._

## 10. Hand back

> **Skill:** `research` · **Guide:** `research/docs/reference/ingesting-sources.md`

Report the key, the note's location, the units it serves and, separately, because it is the useful
part, **the disagreement it found**. _Substantive._
