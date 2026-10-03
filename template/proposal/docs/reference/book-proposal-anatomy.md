---
type: guide
skills: [build, research, fact-check, approach-a-reader]
model: opus
---

# Book-proposal anatomy — the eight sections, and who is asked to vouch

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** What goes in the book proposal, in what order, what each section must achieve,
and how endorsers are chosen and tracked. A commissioning editor reads the first paragraph and the
comparable titles; everything after that is them looking for reasons to say no. Give them fewer.

## The eight sections

One file per section in `proposal/src/book-proposal/`, numbered so the build assembles them in order:

| # | File | What it must achieve |
|---|---|---|
| 1 | `01-overview-and-hook.md` | The book in a paragraph, the hook in a sentence, what makes it different |
| 2 | `02-why-now.md` | Dated evidence that the question is live and unaddressed |
| 3 | `03-audience.md` | Who it is for first, who else will read it, how they will find it |
| 4 | `04-comparable-titles.md` | Three to six comparable titles, each with a one-line differentiator |
| 5 | `05-chapter-outline.md` | 100–200 words a chapter, written for an editor, not lifted from the briefs |
| 6 | `06-about-the-author.md` | The standing to write this book, not a follower count |
| 7 | `07-endorsements-and-reach.md` | Who will vouch for it, framed by the audience each name unlocks |
| 8 | `08-sample-chapters.md` | Which chapters are offered, and why; the index is `proposal/src/sample/sample-index.md` |

## What a theology proposal must carry

- **What kind of claims the book makes.** Say plainly what it argues from the text, what it infers,
  and what it applies; an editor needs to know which shelf of argument this is.
- **A declared stake.** If the author has a stake in the question, say so early. Declared, it is
  credibility; discovered later, it reads as evasion.
- **Contested ground, named.** Where the book takes a side in a contested reading, the proposal
  says so rather than presenting the reading as settled.
- **An objection left standing, if there is one,** framed as a strength: it is why a sceptical
  reader can trust the other answers.

## Endorsers, by reach

Ask whose yes unlocks which audience, and which objection it answers. In approach order: scholars in
the book's field (the book is serious); practitioners who can vouch for its subject-matter claims;
church-institutional voices, always through a named person, never a department; voices beyond the
church, if crossover is pursued, told early that the book is Christian. Early yeses make later asks
easier to write.

**The master text** every approach starts from is `proposal/src/book-proposal/01-overview-and-hook.md`
(the book in a paragraph, the hook in a sentence) with `proposal/src/book-proposal/06-about-the-author.md`
(the author's standing). Each approach tailors it to one person; the master itself is never sent.

## How we apply it here

- **The build assembles it.** `make docx SCOPE=proposal/src/book-proposal` joins the eight files in
  filename order. Never add a separately assembled file to that folder: the build would include it
  as well.
- **Every claim is sourced.** 'Why now', market and platform statements come from
  `research/src/evidence/`; never from memory.
- **Tenses are load-bearing in the author section.** What the author does now is present tense,
  what they did is past; a biography someone could contradict is worse than none.
- **The tracker** is `proposal/src/endorsements/tracker.md`, with statuses `to approach` ·
  `approached` · `chasing` · `yes` · `no` · `lapsed`. Approach emails stay under 250 words, are
  drafted in `proposal/src/endorsements/drafts/`, and are chased once, a fortnight on.
- **After a yes,** the author sends what was promised, by the date promised; the endorsement, when
  it comes, is kept verbatim in `proposal/src/endorsements/received-<reader-slug>.md`.

## Who implements it

- **Skills:** `build` (assembly and proofs), `research` and `fact-check` (comparable titles and
  claims), `approach-a-reader` (endorser approaches). **Workflows:**
  `proposal/workflows/01-assemble-the-proposal/`, `proposal/workflows/02-approach-a-reader/`,
  `proposal/workflows/03-update-the-tracker/`.

## Governing standard

`standards/method/THEOLOGY.md` governs what the book claims about itself, which is what the
proposal and every endorser vouch for; `standards/style/voice-notes.md` governs how it sounds. The
standards own the rules; this guide owns the package.
