---
name: prototype
description: >-
  Write a throwaway spike that answers one question about the writing, then delete it: a rough
  passage in a drafts folder that tests whether the substance holds (an argument, a scene's
  turn, a document's structure) or how it should sound or look (three or four genuinely
  different versions side by side). Invoke by typing /prototype, when a decision map sends a
  prototype node, or when <%AUTHOR_FIRST_NAME%> asks 'would this argument survive being written
  out?', 'before I plan it, try the opening three ways', 'does this work as two packages or
  three?', 'let me see it before I commit'. Not a real draft (`draft-section`), not alternatives
  for lines in an existing section draft (`adapt-section`), and not where the verdict is
  recorded (`grill-with-docs`).
---

# Skill: Prototype (<%PROJECT_NAME%>)

A prototype is **throwaway prose that answers one question**, then is deleted. It is a **spike**:
written to be read, judged and discarded, not to become the work. The **one question** decides
its shape; the answer, not the prose, is the deliverable. A spike that shows the plan does not
hold is a successful spike.

House rules relax inside a spike because nothing in it ships. That licence is earned only by the
paired boundary: **a spike never leaves `drafts/`**, is never promoted, quoted or registered, and
is deleted once its question is answered.

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

## Governing procedures (route here — do not restate at length)

**No workflow of its own.** A spike is a technique other procedures reach for; these govern it:

- `planning/docs/reference/decision-maps.md` — the prototype node type, settled by this skill.
- `.claude/rules/syntek-author/08-naming-and-memory.md` Section 1 — `SPIKE-<slug>.md` in a
  `drafts/` folder, deleted once answered.
- `.claude/rules/syntek-author/03-authorship.md` Section 4 — never fabricate, which a spike does
  not relax.
- `.claude/rules/syntek-author/06-global-rules.md` Section 10 — confidentiality, which a spike
  does not relax either.

The mode file names the content layer's guide that describes the unit a spike sits beside.

## Steps

> **Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they disagree, the procedure wins and the disagreement is reported to the author.

1. **Frame the one question.** Write the single question the spike answers, in one sentence, at
   the top of the file. Find the context yourself (the unit's brief, `standards/style/voice-notes.md`,
   the reads the mode names) rather than asking. A spike that chases two questions answers
   neither. *Complete when:* one sentence names one question about the writing ('does this hold?',
   'how should this sound?'), not a research task and not a production task.
2. **Pick the branch.** Every spike is one of two branches, named in the mode file: **A** tests
   the **substance** (does the argument, the scene or the structure hold when written out?); **B**
   tests the **telling** (how should it sound or look?). Ambiguous, and the author not at hand?
   Default by what is uncertain: the reasoning means A, only the telling means B. *Complete when:*
   the branch is named in the spike's header, with the assumption stated if it was defaulted.
3. **Isolate the spike.** Write it as `SPIKE-<slug>.md` (or the mode's other extension) in the
   unit's `drafts/` folder, which every build excludes. No version number, no ledger entry, no
   register row, and no promoted file ever quotes it. *Complete when:* the spike sits in a
   `drafts/` folder under its `SPIKE-` name and nothing outside `drafts/` refers to it.
4. **Write the spike by its branch.** Skip the polish and get to the question fast.
   - **A · substance:** draft the spine at rough full length, and write the **hardest paragraph
     first** (the mode says which it usually is). If it cannot be written honestly, that is the
     answer.
   - **B · telling:** draft three or four **genuinely different** versions of the same short
     passage, not tweaks of one, varying one dimension at a time; label them plainly and put
     them one after another so they read against each other.

   The mode file lists exactly which house rules relax. A source not yet looked up is a
   placeholder, `[@TODO-source]`; a quotation, a figure or a reference is never invented to fill
   one. *Complete when:* the spike exercises the hard case its question turns on (A), or offers
   genuinely different options side by side (B).
5. **Read the answer, then delete the spike.** Read it with <%AUTHOR_FIRST_NAME%> until the question
   has a clear verdict. Record the verdict and the question it settled through `grill-with-docs`,
   which sends it to its home (the brief's `## Draft notes`, its settled-positions slot, or
   `.claude/MEMORY.md` through the gate). Then **delete the spike**: a surviving spike is a draft
   waiting to be mistaken for real. Anything worth keeping is written again, properly, through the
   authoring loop. *Complete when:* the verdict is recorded in a durable home and the `SPIKE-`
   file is gone.

## A spike is not a draft

- A **section draft** in `drafts/` is the real work in progress, with a ledger entry; it will be
  promoted. Alternatives for its lines are `adapt-section`'s work, logged in that entry, never a
  spike.
- A **spike** is neither the work nor a template. It exists to answer one question and is deleted
  when it has.
- A spike's verdict is not recorded in the spike, not only in the conversation, and not in a new
  file opened to hold it. A fact the spike needed goes to `fact-check`; a reading or a source to
  `research`.

## Anti-patterns

- **Two questions in one spike.** Neither gets answered.
- **Polishing a spike.** Polish is the signal it is turning into a draft.
- **Promoting a spike**, or copying its paragraphs into a draft. Validated substance is rewritten
  through `draft-section`, with its own ledger entry.
- **Three tweaks presented as three versions.** A B-branch spike that varies nothing that matters
  proves nothing.
- **Inventing a source, a quotation or a figure** because the spike 'does not count'.
- **Keeping the spike 'just in case'.**

## Cross-references

- `.claude/skills/grill-with-docs/SKILL.md` — records the verdict in its real home.
- `.claude/skills/wayfinder/SKILL.md` — sends prototype nodes here.
- `.claude/skills/draft-section/SKILL.md` — the real drafting procedure validated substance
  graduates into.
- `standards/style/voice-notes.md` — what a B-branch spike is judged against.
