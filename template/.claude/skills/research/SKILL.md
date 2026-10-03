---
name: research
context: fork
agent: general-purpose
background: true
description: >-
  Answer a question from primary sources and leave a cited note: frame one answerable question,
  check what the project already holds, read every source at its origin, record conflicts rather
  than averaging them, and write a question-led note (Question, Verdict, Claims cited and dated,
  Conflicts, Sources, Feeds) or a reading note on one work. Runs as a background agent, and is
  the delegated-search engine `fact-check` calls. Invoke by typing /research, or when
  <%AUTHOR_FIRST_NAME%> asks 'find out what the sources say about', 'what was this really like
  in the 1850s?', 'how did that language actually sound?', 'what does the regulation require?'
  or 'read this book into the notes'. Not for giving one checkable claim its verdict
  (`fact-check`), and never for settling a decision (`grill-with-docs`).
---

# Skill: Research (<%PROJECT_NAME%>)

Research answers a question the project cannot yet answer, by reading **primary sources** and
leaving a **note** in which every claim carries its citation and the date it was checked. It is
the reading tier beneath the work: the note is the deliverable, and the brief, the evidence entry,
the map node or the decision that consumes it links back.

It runs as a **forked background agent**, so the session that called it carries on while it reads.
A forked agent cannot talk to the author: anything only <%AUTHOR_FIRST_NAME%> can answer goes back
to the caller as a question, never as a guess.

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

## Governing procedures (route here — do not restate at length)

Follow the procedure's `STEPS.md` against its `CHECKLIST.md`; this skill is the reading in it.

- `research/workflows/01-ingest-a-source/` — reading one work into a note: this skill in full.
- `research/workflows/02-verify-a-claim/` — steps 4 and 8, the delegated search `fact-check`
  sends here; `fact-check` keeps the verdict.
- `standards/method/method.md` Sections 2, 3, 5, 6 and 8 — the basis a claim carries, two dates,
  contested evidence kept contested, jurisdiction and date, never fabricate.
- `research/src/CONTEXT.md` — the routing table; `research/src/notes/CONTEXT.md` — the note
  format.
- `research/docs/reference/ingesting-sources.md` · `research/docs/reference/vetting-evidence.md`
  — how sources are read, and what a cited claim must carry.

The mode file adds this project's folders and its primary sources.

## Steps

> **Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they disagree, the procedure wins and the disagreement is reported to the author.

1. **Take one answerable question, and check the project first.** Reduce the ask to a single
   question a note can settle. Search `research/src/` (notes, evidence, sources and the mode's
   folders) and `.claude/MEMORY.md` `Facts`: an answer already held and checked within about
   twelve months is reported, not redone. A question that will not reduce to one sentence goes
   back to the caller with the reframing it needs. *Complete when:* the question is one sentence,
   the project does not already answer it, and it is research rather than a lookup.
2. **Route it before reading.** Use the routing table in `research/src/CONTEXT.md`: a question
   answered from several sources makes a note in `research/src/notes/`; one work's argument makes
   a reading note in `research/src/sources/` by `research/workflows/01-ingest-a-source/`; a single
   checkable claim goes back to `fact-check`, which owns its verdict and its evidence entry.
   *Complete when:* the destination folder and its format are named.
3. **Name what a complete answer needs.** Before searching: what exactly is asked, the kind of
   source that owns such a fact (the mode lists them), and the period, place or jurisdiction it
   must hold for. *Complete when:* the basis is written at the head of the working note.
4. **Read every claim at its primary source.** Follow the chain back to the source that owns the
   fact. A secondary account (a summary, a blog, a popular history, another book's version) is a
   scout that points at the primary; the citation kept is always the primary. **Searching finds;
   reading cites:** a search result, a tool's summary of a page or another model's answer is a
   lead, never a citation, and a quotation, figure or date is taken only from the source's own
   text. A source that cannot be reached is reported as unavailable, not worked round.
   *Complete when:* every claim traces to a primary source actually read, with its page or locator.
5. **Keep going past the convenient source; record every conflict.** When a source agrees with
   the work's interest, keep looking. Agreement among secondary sources is not corroboration:
   they copy one another, and a shared error spreads unchallenged. Where sources disagree, name
   both, say which governs and why; never average them into a confident middle. *Complete when:*
   every conflict is stated with the source that governs, and the search went past the first
   agreeable answer.
6. **Write the note.** A question-led note is `research/src/notes/<topic>.md` in the format in
   that folder's `CONTEXT.md`: `## Question`, `## Verdict`, `## Claims` (each ending in its
   citation and the date checked), `## Conflicts`, `## Sources`, `## Feeds`, `## History`. A
   reading note follows `research/src/sources/CONTEXT.md` and records what the work says, never
   what the project should conclude; where the project keeps a citation database, the work is
   keyed in the same pass (step 9 of the ingest procedure). Never overwrite a note; supersede it
   under `## History`. *Complete when:* the note exists, every claim carries a citation and a
   checked date, and no earlier note was overwritten.
7. **Wire it, then hand back.** Link the note from what it feeds (a brief's `sources:` and
   `## Draws on`, the evidence entry `fact-check` is writing, a map node), and hand back to the
   caller: the verdict, the note's path, the conflicts, what could not be found, and **what tells
   against the work's convenience**. A durable finding becomes a `.claude/MEMORY.md` entry only
   through `grill-with-docs`, on the author's word. *Complete when:* the consumer links to the
   note by path and the caller has the report.

## Anti-patterns

- **Citing the scout.** A summary of a source is not the source.
- **Answering from memory** because the answer feels familiar; familiarity is how an error is
  repeated with confidence.
- **Averaging two sources** into a middle neither supports.
- **Assigning a verdict.** The six verdicts belong to `fact-check`; a note reports what the
  sources say.
- **A note for something one line in a `CONTEXT.md` already records.**
- **Asking the author from inside the fork.** Return the question to the caller.

## Cross-references

- `.claude/skills/fact-check/SKILL.md` — the caller that turns a finding into a verdict.
- `.claude/skills/grill-with-docs/SKILL.md` — where a finding becomes a decision, on the
  author's word.
- `.claude/skills/wayfinder/SKILL.md` — sends research nodes here.
- `research/src/notes/CONTEXT.md` · `research/src/sources/CONTEXT.md` — the two note formats.
