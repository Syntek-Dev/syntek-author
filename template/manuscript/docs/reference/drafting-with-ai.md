---
type: guide
skills: [draft-section, adapt-section, improve-section, promote-section, learn-voice]
model: opus
---

# Drafting with AI — the loop, who decides, and the record

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** This project drafts with an AI, and the author decides. The AI drafts or suggests;
the author reads, edits, accepts, rejects and promotes. Every section keeps a record of who wrote
what, so the author can answer a publisher's disclosure question honestly, and so the AI learns the
author's voice from evidence rather than from guesses.

## The loop

| Step | Skill | What happens | Who decides | Section status after |
|---|---|---|---|---|
| Draft | `draft-section` | the AI drafts one section from the plan | the author, by asking | `ai-draft` |
| (or) Write | — | the author writes the section | the author | `author-draft` |
| Adapt | `adapt-section` | the author's notes drive a targeted revision, with alternatives for contested lines | the author picks | `adapted` |
| Improve | `improve-section` | the author's draft gets a numbered diff, one reason per change | the author accepts or rejects each | `improved` |
| Promote | `promote-section` | the approved section enters the chapter under its marker | the author's explicit word | `promoted` |
| Learn | `learn-voice` | the ledger is mined for what the author changed and refused | the author approves each note | — |

Adapt and improve repeat as often as the author likes, in either order. When the author edits a
draft by hand, its status becomes `author-revised` until the next pass.

## Who decides what

- **The author decides** what each section is for, every word that reaches the chapter, which
  suggestions are kept, when a section is promoted, when a chapter is `final`, and every question
  flagged for them.
- **The AI decides nothing permanent.** It drafts into `drafts/`, proposes, flags and records. It
  prefers a suggested change to a rewrite, and it preserves the author's deliberate oddities.

## The two flags

- `<!-- AUTHOR TO CONFIRM: … -->` marks a decision only the author can make.
- `<!-- VERIFY: … -->` marks a checkable claim not yet checked.

Both sit inline, at the exact spot. `make flags` lists every one in the project. A section with
either flag is not promoted, and a chapter with either is not `final`.

## The record

Every section has a ledger entry at `standards/style/ledger/<unit-slug>--<section-slug>.md`: the
AI's original verbatim (empty when the author drafted), the author's final text at promotion, and
every suggestion with its verdict. `tooling/provenance.py` compares the two texts and records how
much the author changed; `make provenance` prints a per-chapter table for a publisher. The ratio
measures editing, not merit: report it as it stands.

## How we apply it here

- **Voice comes from the author's own writing.** Until `standards/style/samples/` holds real
  samples and `standards/style/voice-notes.md` has marks drawn from them, every AI draft guesses
  at the voice. A voice guide with borrowed examples is a hypothesis, not a standard.
- **Never edit an AI original after the fact.** The ledger is evidence; a tidied original makes
  the disclosure false and teaches `learn-voice` nothing.
- **Rejections are the best teacher.** A rejected suggestion is logged as carefully as an accepted
  one.

## Who implements it

- **Skills:** as in the table; `run-workflow` routes each intent to its procedure.
- **Workflows:** `manuscript/workflows/01-draft-a-section/` to
  `manuscript/workflows/04-promote-a-section/`, and
  `manuscript/workflows/07-learn-from-your-edits/`.

## Governing standard

`.claude/rules/syntek-author/03-authorship.md` owns who decides, the two flags, never fabricating
and provenance. The rules own the requirements; this guide owns the everyday run of the loop.
