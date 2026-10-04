# 08-naming-and-memory.md — what things are called, and what goes in project memory

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **Template-owned.** Shipped by syntek-author and replaced by every `copier update`: never edit it here. This project's settings, paths and overrides are in `00-project.md` beside it, which outranks this file; project rules go where its `## Paths` says.

Names are how files find each other, so they follow one pattern each. Memory is how sessions find
what earlier sessions settled, so it has one home and a gate.

---

## 1. Naming conventions

Files and folders are kebab-case unless a pattern below says otherwise. The examples are
illustrations of the pattern, not files in this project.

**A unit's name** is its folder and brief name, number included (`03-the-ford`; in business, the
brief's filename without `.md`, such as `service-agreement`). It is the `unit:` of a section draft
and of a ledger entry, the first half of a ledger filename, the Unit column of
`standards/style/ledger/provenance.md` and the value of `make provenance UNIT=`. The brief's
`slug:` key is the short name without the number, and is never used in those places.

| Pattern | Example | Used for |
|---|---|---|
<: if DOC_TYPE != 'business' :>| `manuscript/src/NN-kebab-title/NN-kebab-title.md` | 03-the-ford/03-the-ford.md | a chapter and its promoted prose; numbers set the running order |
| `planning/src/units/NN-kebab-title.md` | 03-the-ford.md | the chapter's brief, named as its folder |
| `typeset/src/units/NN-kebab-title.tex` | 03-the-ford.tex | the chapter styled for print; its Pandoc base has the same name in `typeset/src/units/.base/` |
<: else :>| `library/src/<family>/…/<doc-type>-v<major>-<minor>-DD-MM-YYYY.tex` | service-agreement-v1-0-03-10-2026.tex | a versioned deliverable; a revision is a new file, never an edit of the old |
| `<doc-type>-<client-slug>-v<major>-<minor>-DD-MM-YYYY.tex` | proposal-harbour-bakery-v1-0-03-10-2026.tex | a client's copy, under `client-docs/<client-slug>/` |
| `planning/src/units/<document-slug>.md` | service-agreement.md | the document's brief |
| `DOC-NNN` | DOC-014 | a document's identifier in the register |
| `approval-<doc-type>-DD-MM-YYYY.md` | approval-pricing-03-10-2026.md | an approval record, in `planning/src/approvals/` (default) |
<: endif :>| `drafts/<NN>-<section-slug>.md` | drafts/04-crossing-at-night.md | a section draft, beside the unit it will join |
<: if DOC_TYPE != 'business' :>| `<!-- section: <slug> -->` | `<!-- section: crossing-at-night -->` | where a promoted section sits in the unit file |
<: else :>| `% section: <slug>` … `% end section: <slug>` | % section: payment-terms | where a promoted section sits in a `.tex` document |
<: endif :>| `standards/style/ledger/<unit>--<section-slug>.md` | 03-the-ford--crossing-at-night.md | a section's provenance record; `<unit>` is the unit's name, number included |
| `workflows/NN-verb-first-name/` | 01-draft-a-section/ | a template procedure; numbers frozen |
| `workflows/local/NN-verb-first-name/` | 01-prepare-a-reading/ | the author's own procedure |
| `kebab-case.md` in `docs/` | drafting-with-ai.md | a guide, named for the question it answers |
| `SCREAMING-SNAKE-CASE.md` | CONTEXT.md, STEPS.md | structural files, and sub-documents behind a thin index |
| `HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md` | HANDOFF-OPENING-SECTIONS-03-10-2026.md | a session handoff, in `handoffs/` (default) |
| `MAP-<TOPIC>.md` | MAP-PART-TWO.md | a decision map, in `planning/src/maps/` (default) |
| `REVIEW-<scope>-DD-MM-YYYY.md` | REVIEW-whole-work-03-10-2026.md | a structural review (advice only), in `planning/src/reviews/` |
| `SPIKE-<slug>.md` | drafts/SPIKE-second-person.md | a throwaway prototype, deleted once answered |
| `learning/<kebab-topic>/` | learning/dialogue-punctuation/ | a learning topic: `MISSION.md`, `RESOURCES.md`, `PROGRESS.md`, `LESSONS/` |
<: if DOC_TYPE == 'theology' :>| `planning/src/arguments/NN-kebab-title.md` | 03-the-ford.md | a chapter's argument map |
| `research/src/contested-readings/<kebab-passage>.md` | genesis-1-26-28.md | a contested-reading map: exegesis, not a decision map |
<: endif :><: if DOC_TYPE == 'fiction' :>| `world/src/characters/<slug>.md` | ilse-varga.md | a character; places follow the same pattern |
| `planning/src/arcs/<slug>.md` | ilse-varga.md | a character arc, named as its character |
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>| `planning/src/quests/<slug>.md` | the-salt-road.md | a quest |
| `world/src/peoples/<slug>.md` | marsh-folk.md | a people; cultures and creatures follow the same pattern |
| `world/src/history/<slug>.md` | the-long-flood.md | one major event of the world's history, listed under its era in `world/src/history/eras.md` |
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>| `world/src/languages/<lang>/` | hill-tongue/ | a constructed language and its script |
<: endif :><: if INCLUDE_REFERENCES :>| `authorYYYY[a-c]` | example2019, example2019b | a citation key: lower-case, **never renamed** |
<: endif :><: if DOC_TYPE != 'business' :>| `build/<scope with / as __>.<ext>` | `build/manuscript__src.pdf` | generated output; never hand-edited |
<: endif :>
Dates in filenames are DD-MM-YYYY. A name that other files cite (a skill, a workflow number, a
citation key) is never changed without a migration, because every citation of it breaks silently.
Where `00-project.md` `## Paths` gives another folder or filename form for a role (handoffs,
decision maps, research notes<: if DOC_TYPE == 'business' :>, approvals<: endif :>), it wins over the defaults above; any other path
moves only by a redirect line in its `## Overrides` (`01-layout-and-routing.md` Section 9).

---

## 2. What goes in `MEMORY.md`, and what goes elsewhere

`.claude/MEMORY.md` holds what a later session needs and cannot read off the files: facts,
decisions, the author's feedback, status, open questions and sensitivities. Project state lives
there and only there; skills and governance files point to it and never restate it. Write there,
not to any global or automatic memory.

**The headings below are the template's.** `00-project.md` `## Memory headings` maps each one
to the heading this project uses. Wherever a template file names a `MEMORY.md` heading, read
and write under the heading it is mapped to, and never add a template heading that the map
sends elsewhere: a second Decisions list beside the project's own is two records that drift.

| What you learned | Where it goes |
|---|---|
| A fact about the project not visible in the files (target length, delivery date) | `MEMORY.md` Facts |
| A decision that passed the gate (Section 3) | `MEMORY.md` Decisions |
| How the author wants the work done, or a correction they gave | `MEMORY.md` Feedback |
| Where the work stands | `MEMORY.md` Status |
| A question only the author can settle, not yet settled | `MEMORY.md` Open questions |
| A risk to people, privacy or reputation | `MEMORY.md` Sensitivities |
| A project setting: the audience, a path, a memory heading, an override | `.claude/rules/syntek-author/00-project.md`, under its heading |
| A decision about one unit | that unit's brief in `planning/src/units/` |
| What a folder holds | that folder's `CONTEXT.md` |
| A rule for one folder | that folder's `CLAUDE.md` |
| A term and its meaning | `standards/style/terminology.md` |
| A trait of the author's voice | `standards/style/voice-notes.md`, through `learn-voice` |
| The shape of the whole work | `planning/src/outline.md` |
| A review's findings | `planning/src/reviews/`; decisions enter `MEMORY.md` only when the author dates them |

---

## 3. The memory gate

Write to `MEMORY.md` only when all three hold:

1. **It will be needed again**: a later session would otherwise ask the author the same question.
2. **It cannot be read off the files**: if a `CONTEXT.md` or a brief already says it, update that
   instead.
3. **Getting it wrong would cost real work**: a redraft, a wrong fact in print, a broken promise.

A **decision** must also pass the decision gate kept by `grill-with-docs`: it is hard to reverse,
it would surprise someone without the context, and it settled a genuine trade-off. Record only
what the author has confirmed, never what the AI inferred.

---

## 4. Entries: dated, and superseded, never deleted

- One bullet under the right heading:
  `- **DD/MM/YYYY** — **Headline.** Body, including why, and what was rejected.`
- Dates are absolute: "next week" becomes a date before it is written down.
- **Supersede; never delete.** Append `*(Superseded DD/MM/YYYY — see below.)*` to the old bullet
  and add the new one. The history of a decision is part of the decision.
- Past 300 lines, split by topic into `.claude/memory/<topic>.md` and leave `MEMORY.md` as the
  index, unless `00-project.md` `## Overrides` keeps it as one file.
