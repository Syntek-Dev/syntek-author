---
name: learn-voice
description: >-
  Learn the author's voice: mine the ledger entries marked learned: false for what the author
  changed in AI drafts and, above all, which proposed improvements they rejected; find patterns
  shown in at least two sections; propose voice-note additions with real before-and-after
  examples (and, for a mechanical pattern or a term, style-sheet or terminology entries); write
  each to standards/style/ only after the author approves it; mark an entry learned only once its
  section is promoted and mined. Also seeds empty voice notes from the author's own writing in
  standards/style/samples/. Use when the author says 'learn from my edits', 'what have you noticed
  about how I write?', 'update the voice notes', 'why do I keep changing your drafts?', 'seed the
  voice notes from my samples' or 'make your drafts sound more like me'. Not for drafting in the
  voice (`draft-section`). Not for proposing changes to one section (`improve-section`). Not for
  checking prose against the style sheet (`spelling`).
---

# Skill: Learn Voice (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

The voice notes are what every draft is written from, so they must describe how
<%AUTHOR_FIRST_NAME%> actually writes, not how a model imagines they might. This skill reads the
evidence the authoring loop leaves behind (what the author changed by hand at each stage of a
section, and every suggestion they refused or later undid) and turns repeated patterns into short,
testable notes with the author's own sentences as examples. It proposes; the author decides. A
voice guide built from borrowed examples is a hypothesis, and one written without the author's
approval is not theirs.

## Governing procedures (route here — do not restate at length)

- The content layer's `workflows/07-learn-from-your-edits/` — this skill is that procedure in
  skill form; the mode file names its path.
- If the layer's `workflows/local/` holds a folder with the same `NN-name` as the procedure above,
  follow that procedure instead: the author's local procedure replaces the template's
  (`run-workflow`, step 2).
- `standards/style/voice-notes.md` — what is already recorded, and the format of a `## Learned`
  bullet.
- `standards/style/ledger/CONTEXT.md` — the entries this skill reads and the `learned` key it sets.
- `standards/style/samples/CONTEXT.md` — what counts as a sample, and the three-sample minimum.
- `.claude/rules/syntek-author/06-global-rules.md` Section 3 — never self-edit: a standard
  changes only with the author's approval.
- `.claude/rules/syntek-author/08-naming-and-memory.md` — the memory gate, and superseding a
  decision rather than deleting it.
- The content layer's `docs/reference/drafting-with-ai.md` — the loop the ledger records.

## Steps

> **Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they disagree, the procedure wins and the disagreement is reported to the author.

1. **Gather the unlearned entries.** List the entries in `standards/style/ledger/` with
   `learned: false`, grouped by unit, and mark which carry a `promoted` date. A promoted entry is
   mined whole, unless it is reopened (changed since its promotion and not promoted again,
   `standards/style/ledger/CONTEXT.md`): its `## Author final` is then the previous final, so,
   like an entry whose section is not yet promoted, only its `## Improvement decisions` may be
   mined, and it stays unlearned (step 8). If there are none and
   the voice notes hold no marks while `standards/style/samples/` holds writing, go to step 5. If
   there is only one, say that one section is too little evidence and ask whether to wait.
   *Complete when:* the entries to read are listed, or the run has gone to step 5 or stopped.

2. **Read what is already recorded.** Read `standards/style/voice-notes.md` whole (including
   `## Learned`), `standards/style/style-sheet.md`, `standards/style/terminology.md` and any
   further file the mode file names, so no proposal repeats a note or silently contradicts one.
   *Complete when:* each of these is read, and every existing mark is known.

3. **Read the evidence, rejections first.** Read every `## Improvement decisions` table, the
   author-drafted sections' included: a rejected proposal or alternative is the author seeing a
   change and saying no, the clearest signal there is. Read each against the text it was proposed
   for: the state before the revision whose marker names its row (the state then current, when no
   marker names it). An `author-note` row is the author's own change, asked for in a note: mine
   what the note asks for as voice evidence, but never count it as an AI suggestion accepted. Then
   walk each promoted entry's record, as `standards/style/ledger/CONTEXT.md` describes it. The
   author's evidence is each `author` revision against the state before it, the gap from the last
   revision (or the original, when there is none) to `## Author final`, and, for an author-drafted
   section, the whole `## Author original` when the author wrote it (never wording that came from a
   template or from someone else's document: the mode file says how to tell); the words an `ai` or
   `author-note` revision brought in are the AI's, never the author's, even once accepted. An AI change the author later undoes is
   an implicit rejection: rank it just below the explicit ones. An entry mined in an earlier run
   whose final has been replaced since (its git history shows `learned: true` before its last `promoted …`
   revision) has already given everything up to that revision: read only what came after it (the
   later revisions and rows, and the gap to the new final). An entry without `format: 2` has no
   record: read `## AI original` beside `## Author final` (its `change_ratio` says where the text
   moved most, not who moved it), and mark what it shows as weaker evidence, because accepted AI
   text is mixed into it. Note what the author cut, added, replaced and reordered: openings,
   sentence length, diction, hedges, register, punctuation habits, and the things the AI keeps
   writing and the author keeps removing. Set aside changes that corrected a fact: they are about
   the work.
   *Complete when:* each entry's author changes, author notes, rejections and implicit rejections
   are noted, with the author's own words, and every finding from an entry without `format: 2`
   is marked as weaker evidence.

4. **Find the patterns worth a note.** Keep a pattern only if at least two sections show it.
   Separate voice (how the author sounds) from mechanics (a style-sheet matter) and from content (a
   corrected fact). Sort each by the registers the mode file names, and name its home: a voice
   habit under `## Learned` in `standards/style/voice-notes.md`, a mechanical habit in
   `standards/style/style-sheet.md`, a preferred term in `standards/style/terminology.md`; any
   other home is the mode file's call, and a proposal only.
   *Complete when:* every pattern kept has two or more instances, a register and a home.

5. **Seed from samples, when the notes are empty.** When the voice notes hold no marks yet, read the
   author's own writing in `standards/style/samples/` (three or more pieces for a register) and
   draw the marks from it: cadence, register, diction, punctuation habits, how a passage opens and
   closes. Every mark is quoted from a sample. With fewer than three, ask the author for more of
   their own writing; never invent a voice.
   *Complete when:* each proposed mark quotes a sample, or the author has been asked for samples.

6. **Propose the additions.** Give the author a numbered list. For each: the note in one sentence
   (do, or do not), its register, the evidence (before and after, naming the ledger entry or
   sample), how many sections show it, and its proposed home. List separately every conflict with
   the style sheet or an existing note, quoting both, for the author to settle. Ask the author to
   approve, reword or decline each item, and wait.
   *Complete when:* the author has answered every item.

7. **Write only what the author approves.** Append each approved voice note under `## Learned` in
   `standards/style/voice-notes.md` in the form the file gives: a dated bullet (DD/MM/YYYY), the
   mark in bold, one before-and-after pair, and the entries or samples it came from, in the
   author's wording where they reworded it. Write each approved mechanical rule to
   `standards/style/style-sheet.md` and each approved term to `standards/style/terminology.md` in
   the same way, dated, with its example. Where a new note overturns an earlier one, mark the old
   one superseded with the date; never delete it. Change nothing else, and write nowhere the
   author did not approve. *Complete when:* every approved item is written, and nothing
   unapproved changed.

8. **Mark the promoted entries learned.** Set `learned: true` on every entry read in this run
   whose section is promoted and not reopened, including those that yielded no note: they have
   been mined. An entry not yet promoted, or reopened, stays `learned: false`, even when its
   improvement decisions were read, because its author final is still to come. Change nothing else in any entry.
   *Complete when:* every promoted entry read carries `learned: true`, no unpromoted entry does,
   and every entry's texts are untouched.

9. **Record and hand back.** If an approved note overturns an earlier voice decision, or the author
   makes a voice call that passes the memory gate, add a dated entry under the `Decisions` heading
   of `.claude/MEMORY.md` (mapped in `00-project.md` `## Memory headings`), superseding rather than
   deleting the old one. Report how many entries were read, the notes added and where, the notes
   declined (so they are not proposed again), the conflicts raised, and the entries marked.
   *Complete when:* the author has the report, and `MEMORY.md` holds any voice decision made.

## Anti-patterns

- A note from one edit. One change is a preference about one sentence; a pattern needs two
  sections.
- Examples the author did not write. A borrowed example describes someone else's voice.
- Writing a note before the author approves it, or rewording it after they did.
- Treating a spelling or punctuation habit as voice, or a corrected fact as either.
- Reading only the accepted changes; the rejections say more.
- Reporting an `author-note` row as a suggestion the author accepted: the change was theirs.
- Editing a ledger entry's texts while marking it learned, or marking an unpromoted entry
  learned.
- Deleting or rewriting an earlier note instead of superseding it.
- Learning from a sample the author did not write, or from AI text the author approved.
- Reading an entry's AI original against its final as the author's work when the entry records
  revisions, or weighing a legacy entry's difference as heavily as a recorded `author` revision.

## Cross-references

- `draft-section` — writes from the notes this skill grows.
- `adapt-section` and `improve-section` — record the decisions and revisions this skill mines.
- `promote-section` — fills the `## Author final` each entry's record ends at.
- `grill-with-docs` — the memory gate for a voice decision worth recording.
- `tooling/provenance.py` — computes each entry's `change_ratio`; `make provenance` averages it
  per unit.
- `standards/style/voice-notes.md` · `standards/style/samples/` · `standards/style/ledger/`.
