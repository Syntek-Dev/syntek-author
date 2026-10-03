---
workflow: 07-learn-from-your-edits
phase: author
skills: [learn-voice, grill-with-docs]
model: opus
---

# STEPS.md — learn from the author's edits

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for mining the ledger (or, for a new project, the author's samples) and
turning real edits into voice notes the author approves. Each step names the skill and guide it
uses. **Run in order** — the ordering is load-bearing — and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The `learn-voice`
> skill is this procedure in skill form; read its `BUSINESS.md` mode file too.

## 1. Gather the evidence

> **Skill:** `learn-voice` · **Guide:** `library/docs/reference/drafting-with-ai.md`

List every ledger entry in `standards/style/ledger/` with `learned: false`, grouped by document and
by family, and mark which carry a `promoted` date: an entry not yet promoted lends only its
`## Improvement decisions`, and stays unlearned. When seeding a new project instead, take three or
more of the author's own pieces from `standards/style/samples/`; fewer than three is too little to
find a pattern, so say so and stop. _Mechanical._

## 2. Read the rejections first

> **Skill:** `learn-voice` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Read every rejected proposal in the entries' `## Improvement decisions`, with the author's note
where there is one. A rejection is the author saying 'not like that', which is the clearest signal
the ledger holds. _Substantive._

## 3. Read what the author changed

> **Skill:** `learn-voice` · **Guide:** `library/docs/reference/section-anatomy.md`

For each promoted, AI-drafted section, compare `## AI original` with `## Author final` and list
what the author changed: words cut, words added, sentences reordered, register shifted. Set aside changes
that corrected a fact or a figure: they are about the document, not the voice. _Substantive._

## 4. Find the patterns

> **Skill:** `learn-voice` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Group the changes and rejections into patterns. A pattern needs at least two instances. Describe
each as a rule a writer could follow ('opens a reply with the answer, not a thank-you'), with real
before-and-after pairs quoted from the ledger. _Substantive._

## 5. Sort each pattern by register and by home

> **Skill:** `learn-voice` · **Guide:** `library/docs/reference/document-anatomy.md`

Name the register each pattern belongs to: running copy (proposals, letters, emails, marketing),
instruments and policies, or short functional copy. Then its home: a voice habit goes to
`standards/style/voice-notes.md` `## Learned`; a preferred term to
`standards/style/terminology.md`; a mechanical rule to `standards/style/style-sheet.md`; a change to
`standards/method/` or `standards/brand/` becomes a proposal to the author only; a lesson about one
document stays in that document's brief or internal note. _Substantive._

## 6. Check against what is already written

> **Skill:** `learn-voice` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Read the current voice notes, terminology, style sheet and `standards/brand/brand-voice.md`. Drop
any pattern already recorded; flag any that contradicts a recorded rule, quoting both, so the
author can say which stands. _Substantive._

## 7. Propose

> **Skill:** `learn-voice` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Put a numbered list to the author: each pattern, its register, its examples, its proposed home and
its proposed wording, and any contradiction found in step 6. _Substantive._

## 8. The author approves

> **Skill:** `grill-with-docs` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Take the author's answer on each item: approved, approved as reworded, or rejected. A rejected
pattern is a lesson too; note it so it is not proposed again. Where the author makes a voice call
that passes the memory gate, it goes to `.claude/MEMORY.md` `## Decisions`. The decision is the
author's alone. _Substantive._

## 9. Write and mark learned

> **Skill:** `learn-voice` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Write each approved item to its home as a dated bullet, in the author's words where they gave any,
with one before-and-after example. Mark a contradicted earlier lesson superseded with the date,
never deleting it. Set `learned: true` on every ledger entry read in this run whose section is
promoted, whether or not it yielded a pattern; an entry not yet promoted stays `learned: false`.
_Mechanical._

## 10. Hand back

> **Skill:** `learn-voice` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Report how many entries were read, the patterns approved and where they were written, the patterns
rejected, and any proposal to a standard that now waits on the author. _Substantive._
