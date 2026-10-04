---
workflow: 07-learn-from-your-edits
phase: author
skills: [learn-voice]
model: opus
---

# STEPS.md — learn from the author's edits

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for mining the section ledger and proposing the voice notes, style-sheet
rules and terms the author approves.
Each step names the skill and the guide it uses. **Run in order** and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The `learn-voice`
> skill is this procedure in skill form; read its mode file before step 1.

## 1. Gather the unlearned entries

> **Skill:** `learn-voice` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

List the ledger entries in `standards/style/ledger/` with `learned: false`, and mark which carry a
`promoted` date: only a promoted entry has an author final to compare. An entry not yet promoted
may lend its `## Improvement decisions` to step 4, and stays unlearned. If there are none and the
voice notes are empty while `standards/style/samples/` holds writing, go to step 6. If there is
one, say that one section is too little evidence and ask whether to wait. _Mechanical._

## 2. Read the current voice notes and style sheet

> **Skill:** `learn-voice` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Read `standards/style/voice-notes.md` (including what is already under `## Learned`),
`standards/style/style-sheet.md` and `standards/style/terminology.md`, so no proposal repeats an
entry or silently contradicts one. _Substantive._

## 3. Compare each AI original with its author final

> **Skill:** `learn-voice` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

For each promoted, AI-drafted entry, read `## AI original` and `## Author final` side by side.
`make provenance` gives each section's change ratio, which says where to look, not what changed. Note
what the author cut, added, replaced and reordered: openings, sentence length, diction, hedges,
register, punctuation habits, things the AI keeps writing and the author keeps removing.
_Substantive._

## 4. Read the rejections

> **Skill:** `learn-voice` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Read every `## Improvement decisions` table, the author-drafted sections' included. A rejected
suggestion or alternative is the clearest signal there is: the author saw the change and said no.
Note recurring rejections and the author's own words about them. _Substantive._

## 5. Find the patterns worth a note

> **Skill:** `learn-voice` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Keep a pattern only if at least two sections show it. Separate voice (how the author sounds) from
mechanics and terms (style-sheet and terminology matters) and from content (a corrected fact), and
name each pattern's home: `## Learned` in the voice notes, the style sheet or the terminology.
Apply the registers and domain rules the skill's mode file names. _Substantive._

## 6. Seed from samples, when the notes are empty

> **Skill:** `learn-voice` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

When the voice notes hold no marks yet, read the author's writing in `standards/style/samples/` and
draw the marks from it: cadence, register, diction, punctuation habits, how they open and close a
passage. Every mark is quoted from a sample. If there are no samples, ask the author for three or
more pieces of their own writing instead of inventing a voice. _Substantive._

## 7. Propose the additions

> **Skill:** `learn-voice` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

For each candidate: the note in one sentence (do, or do not), its home, the evidence (before and
after, naming the ledger entry or sample), and how many sections show it. List separately any
conflict with the style sheet or an existing note, for the author to settle. Ask the author to
approve, reword or decline each one. _Substantive._

## 8. Write only what the author approves

> **Skill:** `learn-voice` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Append each approved note, in the author's wording where they reworded it, under `## Learned` in
`standards/style/voice-notes.md`, dated DD/MM/YYYY, with one before-and-after example. Write each
approved mechanical rule to `standards/style/style-sheet.md` and each approved term to
`standards/style/terminology.md` the same way. Change nothing else. _Mechanical._

## 9. Mark the promoted entries learned

> **Skill:** `learn-voice` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

Set `learned: true` on every ledger entry read in this run whose section is promoted, including
those that yielded no note: they have been mined. An entry not yet promoted stays
`learned: false`. Change nothing else in any entry. _Mechanical._

## 10. Record and hand back

> **Skill:** `learn-voice` · **Guide:** `manuscript/docs/reference/drafting-with-ai.md`

If an approved note overturns an earlier voice decision, add a dated entry to `.claude/MEMORY.md`
Decisions (mapped in `00-project.md` `## Memory headings`), superseding the old one rather than
deleting it. Report the notes added, the notes
declined and why, the conflicts raised, and the entries marked. _Substantive._
