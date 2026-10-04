---
type: guide
skills: [structure-review, grill-with-docs]
model: opus
---

# Reviews are advice — how a review becomes a decision, or does not

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** A review is a reading of the work through one or more lenses: a structural pass
over a unit, a panel over the whole work, a scheduled review of a document. It produces advice,
written to `planning/src/reviews/` and marked as advice. It changes nothing. A decision exists
only when the author makes it and dates it, and then it lives in `.claude/MEMORY.md`, not in the
review. The line matters because a confident review reads like a decision, and the next session
acts on it as if it were one.

## Where a review lives

`planning/src/reviews/REVIEW-<scope>-DD-MM-YYYY.md`, written by `structure-review`. The scope
names the work, not the session: `REVIEW-whole-work-…`, `REVIEW-outline-…`, or the unit's name.
A later review never edits an earlier one; it supersedes it by date and says so in its opening
lines. Session transcripts do not survive; the review file is the durable record.

## The shape of a review file

| Part | Holds |
|---|---|
| Header | Subject, scope, date, and the line **Status: Advice only — nothing in the repository was changed** |
| Lenses | Each lens used, with one line on what it reads for |
| Verdicts | Per lens: what works and what does not, by location |
| Open decisions | Numbered; only the author can make these |
| Next steps | In order, each naming the procedure that would carry it out |
| Claims to verify | Anything asserted from outside the repository, flagged `VERIFY` |
| The honest dissent | Where lenses disagreed — kept, never averaged |
| Provenance | Which lenses ran, and when |

## From advice to a decision

1. The author reads the review.
2. Item by item, the author accepts, rejects or defers.
3. Accepted and rejected items that pass the memory gate go to MEMORY `Decisions`, dated, citing
   the review; deferred items go to `Open questions` (both mapped in `00-project.md`
   `## Memory headings`).
4. The change itself is made by the procedure that owns the artefact — the outline, a brief, a
   map, a section — and never by the review or the session that wrote it.

## How we apply it here

- Never cite a review as the reason for a change. Cite the dated decision it led to.
- A review never resolves an `AUTHOR TO CONFIRM` flag; it may only argue for an answer.
- Disagreement between lenses is information. Report it under the honest dissent.
- A review that finds nothing says what it checked; a silent pass is indistinguishable from a
  check that never ran.

## Who implements it

- **Skill:** `structure-review` (forked context) runs the lenses and writes the review;
  `grill-with-docs` records the author's decisions through the memory gate.
- **Workflows:** `planning/workflows/09-review-the-whole-work/` for the whole work; the content
  layer's review workflow for a single unit.

## Governing standard

`.claude/rules/syntek-author/03-authorship.md` owns who decides what;
`.claude/rules/syntek-author/08-naming-and-memory.md` owns the memory gate. The rules own the
requirement; this guide owns the everyday line between advice and a decision.
