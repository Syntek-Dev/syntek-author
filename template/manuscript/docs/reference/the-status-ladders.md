---
type: guide
skills: [promote-section, structure-review, run-workflow]
model: opus
---

# The status ladders — where a chapter stands, and whose hand last shaped a section

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** Two vocabularies, answering two different questions. The **chapter ladder** says
how far a chapter is from finished; it lives in the `status:` key of the chapter's brief. The
**section status** says whose hand last shaped a section's words; it lives in the draft's
frontmatter and is mirrored in the brief's `sections:` list. Neither ever stands in for the other.

## The chapter ladder

A chapter's status names the stage it is in. It moves on only when the gates for leaving that
stage pass, and each gate is dated in the brief's `verified:` record.

| Status | The chapter is… | Moves on when |
|---|---|---|
| `idea` | named, not yet planned | the author agrees its brief: V1 (idea → outlined) |
| `outlined` | planned, nothing drafted | its first section is drafted (no gate of its own; V1 still holds) |
| `draft` | being written, section by section | every planned section is promoted with zero flags and a proof builds: V2 and V3 (draft → structural-review) |
| `structural-review` | being reviewed for shape and argument | the structural review is answered: V4 (structural-review → fact-check) |
| `fact-check` | having its claims checked | every claim is verified or removed: V5 (fact-check → line-edit) |
| `line-edit` | being read for the reader, flow, grammar and spelling | the passes are answered, no flag remains, and the author says so: V6 (line-edit → final) |
| `final` | finished | — |

`stub` is accepted as another name for `outlined` and is rewritten on first touch.

## The section status

| Status | Meaning | Set by |
|---|---|---|
| `ai-draft` | drafted by the AI, not yet touched by the author | `draft-section` |
| `author-draft` | written by the author | the author, or `improve-section` on first touch |
| `adapted` | revised by the AI from the author's notes | `adapt-section` |
| `improved` | the author's draft with accepted suggestions applied | `improve-section` |
| `author-revised` | the author's own hand-edits are the latest change | whichever skill next finds them |
| `promoted` | in the chapter file, under its marker | `promote-section` |

The statuses record the last hand on the text, not a fixed sequence. A section that goes
`ai-draft`, `adapted`, `author-revised`, `adapted`, `promoted` has an ordinary history.

## Where the ladders meet

- **Promotion never moves the chapter.** A section becomes `promoted`; the chapter stays where it
  is. A chapter becomes `final` only through `manuscript/workflows/05-review-a-chapter/` and the
  author's explicit word.
- **Reopening a promoted section.** Copy the chapter's current text for that section into its
  draft, set `author-revised`, revise it through adapt or improve, and promote it again. What
  follows is set by `standards/verification/verification.md` Section 3. A material change (a
  section rewritten, a claim added, the argument restructured) clears that gate's date and every
  later one in `verified:`, and the chapter's `status:` steps back to the rung the standard names;
  the review resumes from there. Any other agreed wording change in a chapter past `draft` has the
  review stages already passed run again over that section before the chapter moves on.

## How we apply it here

- Read a chapter's status from its brief, never from memory or from the state of `drafts/`.
- Never set a status a gate has not earned. A waived gate is the author's decision, recorded in the
  brief's `verified:` record with the date and the reason.
- Keep the brief's `sections:` list and each draft's `status:` in step; when they disagree, report
  it rather than guessing which is right.

## Who implements it

- **Skills:** `draft-section`, `adapt-section`, `improve-section` and `promote-section` set section
  statuses; `structure-review`, `fact-check` and the line-edit skills run the chapter's gates.
- **Workflows:** `manuscript/workflows/04-promote-a-section/`,
  `manuscript/workflows/05-review-a-chapter/`.

## Governing standard

`standards/verification/verification.md` owns the gates for every move up the chapter ladder.
The standard owns the requirements; this guide owns reading and keeping the two ladders.
