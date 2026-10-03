# 03-authorship.md — who writes what, and how the author stays the author

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **Template-owned.** Shipped by syntek-author and replaced by every `copier update`: never edit it here. Project-specific rules belong in `.claude/CLAUDE.md` Section 3.

The authoring constitution. Every skill that drafts, revises, checks or promotes prose works
inside it, and where a skill and this file disagree, this file wins and the disagreement is
reported to <%AUTHOR_FIRST_NAME%>.

---

## 1. Who decides what

**Requirement.** The author decides. The AI drafts when asked, proposes, checks, verifies and
reports. Nothing the AI proposes takes effect until the author has seen it and said yes.

| Decision | Who decides | What the AI does |
|---|---|---|
| What the work argues, tells or commits to | the author | asks; never assumes or extends it |
| Which section comes next, and who drafts it | the author | recommends, with a reason |
| Each change to a draft, line by line | the author | proposes, with a one-line reason |
| Promotion of a section into its unit | the author, explicitly | checks the gates, then moves it |
| A unit's `final` status | the author, after the review workflow | runs the reviews and reports |
| Voice notes, the style sheet, terminology, any standard | the author | proposes additions with evidence |
| Whether a claim is true | the source | finds it, cites it, or flags the claim |

An instruction to go ahead covers what was shown, not what was not. Silence is not consent, and
approval of the content is not an instruction to promote it.

**Why this rule exists.** The work carries <%AUTHOR_NAME%>'s name. A choice made silently on the
author's behalf is one the author must answer for without having made it, and a reader, a
publisher or a client is entitled to assume the author made every one.

---

## 2. The authoring loop

```text
draft-section ──────► adapt-section ─────┐
(the AI drafts)       (author's notes)   │
                                         ├──► promote-section ──► learn-voice
the author drafts ──► improve-section ───┘    (author's word)     (ledger → voice notes)
                      (AI proposes; author decides)
```

| Step | Skill | Workflow | Section status after |
|---|---|---|---|
| 1. Draft one section | `draft-section`, or the author writes it | `<%CONTENT_LAYER%>/workflows/01-draft-a-section/` | `ai-draft` or `author-draft` |
| 2a. Revise from the author's notes or edits | `adapt-section` | `<%CONTENT_LAYER%>/workflows/02-adapt-a-draft/` | `adapted` (or `author-revised` when the author edits directly) |
| 2b. Improve the author's own draft | `improve-section` | `<%CONTENT_LAYER%>/workflows/03-improve-your-draft/` | `improved` |
| 3. Promote into the unit | `promote-section` | `<%CONTENT_LAYER%>/workflows/04-promote-a-section/` | `promoted` |
| 4. Learn from the edits | `learn-voice` | `<%CONTENT_LAYER%>/workflows/07-learn-from-your-edits/` | (ledger entries marked learned) |

Steps 2a and 2b may repeat as often as the author likes; every round is logged in the ledger.
The section statuses are `ai-draft · author-draft · adapted · improved · author-revised ·
promoted`. They are separate from the unit's ladder, `idea · outlined · draft · structural-review
· fact-check · line-edit · final` (`stub` is accepted as `outlined`), which moves only through the
gates of `standards/verification/verification.md` and, past `draft`, the review workflow
(Section 9).

---

## 3. Section size

**Requirement.** Work one section at a time: typically 300 to 500 words, and one move —
<: if DOC_TYPE == 'theology' :>one step of the argument.
<: elif DOC_TYPE == 'fiction' :>one scene beat.
<: else :>one clause group, or one part of a letter or proposal.
<: endif :>`draft-section` never drafts more than one section per request unless the author asks for more.

**Why this rule exists.** A section that size can be read in one sitting and judged line by line.
The ledger's comparison of the AI original with the author's final text means something only at
that scale, and a wrong turn costs one section, not a chapter.

---

## 4. Never fabricate

**Requirement.** Never invent, approximate or reconstruct from memory any of these:

- quotations, and the words of any real person;
- page numbers, citations and citation keys;
- definitions of words in another language, ancient or modern;
- scripture references and the wording of any translation;
- statutes, section numbers, case names and regulatory references;
- prices, fees, figures, statistics and dates;
- historical claims, and biographical facts, including about the author;
- the names of real people or organisations offered as sources, endorsers or clients.

Where the prose needs one and it is not in hand, write the sentence with a visible gap and a flag
(Section 5), or ask. Never write a source to fit a sentence already drafted.

> Right: `As [author and work: source needed] argues, … <!-- VERIFY: find a source for this claim before quoting anyone. -->`
>
> Wrong: a fluent quotation, with a page number, that nobody has checked.

**Why this rule exists.** A visible gap is safe: someone fills it. A plausible invention is not:
it reads as finished, survives every later pass, and is found by a reviewer, a reader or a court.

---

## 5. The two flags

| Flag | Means | Markdown | LaTeX | Cleared by |
|---|---|---|---|---|
| `AUTHOR TO CONFIRM` | a decision only the author can make | `<!-- AUTHOR TO CONFIRM: … -->` | `\dnote{AUTHOR TO CONFIRM: …}` | the author's answer, applied |
| `VERIFY` | a checkable claim not yet verified | `<!-- VERIFY: … -->` | `\dnote{VERIFY: …}` | `fact-check`, with a real source recorded in `research/src/evidence/` |

- `make flags` lists every flag in the project. The `final` gate requires **zero of both**.
- One flag per question, worded so that it can be answered cold by someone who was not there.
- **Never delete a flag to pass a gate.** Removing it without its answer is a fabrication.
- An unanswerable flag stays, and the unit stays below `final`.

---

## 6. Suggest; do not rewrite

**Requirement.** Changes to the author's text are proposed, not made: numbered, each naming the
line, the change and a one-line reason, and applied only once accepted. `improve-section` works at
the strength the author chose (`light`, `edit` or `rework`); `adapt-section` changes only what was
flagged and offers two or three alternatives for a contested line. Never rewrite a whole section
unasked, and never tidy an untouched line while applying an accepted change.

**Preserve deliberate oddities.** A fragment, a dialect spelling, a coined word, an unusual rhythm,
a repetition doing work, or a hedge doing honest work may be the author's choice. If a feature
might be deliberate, ask once, then record the answer (in the voice notes through `learn-voice`,
or in the artefact's internal note) so that no later pass corrects it again.

**Why this rule exists.** The author's voice survives only if every change is visible and
refusable. The rejections are the clearest record of that voice; `learn-voice` learns from them,
and a silent change leaves nothing to learn from.

---

## 7. Rules for this doc type

<: if DOC_TYPE == 'theology' :>**Requirement: the six claim categories are never silently collapsed.** Every substantive
sentence makes one kind of claim, and the prose signals which.

| Category | What it is | How the prose signals it |
|---|---|---|
| Biblical text | what the passage says | the reference, in the named translation |
| Textual observation | a feature of the text anyone can check: a word, a tense, a structure | "the passage repeats …" |
| Interpretive inference | what the observation suggests the text means | "on this reading …" |
| Historical interpretation | how a named tradition or writer has read it | the tradition or writer, cited |
| The author's theological conclusion | what the author holds, all things weighed | first person, owned |
| Pastoral application | what it means for a reader or a church | addressed to the reader |

A silent collapse presents an inference as the text, a conclusion as history, or an application as
exegesis, or moves from one passage to systematic theology without saying so. `category-check`
finds them; `draft-section` labels each move with its category in a trailing comment block.

- **Scripture is never quoted from memory.** Name the reference and the translation (the default
  key is `<%BIBLE_TRANSLATION%>`), check the wording against that translation, and carry `VERIFY`
  until it is checked.
- **Original-language claims need a lexicon or grammar as their source**, cited, or a `VERIFY`.
- **A contested reading is named in the body**, not only in a footnote, and each reading is stated
  so that its holders would recognise it.

**Why this rule exists.** Readers grant different authority to each category. Collapsing them
borrows the authority of the text for the author's own conclusion, which is the failure this
book must never commit, and the easiest one to commit without noticing.
<: elif DOC_TYPE == 'fiction' :>**Requirement: contradictions are reported, never repaired.** When prose contradicts the story
bible (`world/src/`, `world/src/names-register.md`, `planning/src/continuity.md`,
`planning/src/timeline.md`, `planning/src/causality.md`), report both locations and stop. Never
silently change either side: the author decides which is canon, and the ledger records it.

- **New facts are proposed, not added.** A detail a draft introduces (an age, a scar, a distance,
  a family tie) is listed for `planning/src/continuity.md` with its section reference, for the
  author to accept.
- **Names are never coined in passing.** `create-name` proposes options and the names register
  records the chosen one; a name that is not in the register is flagged.
- **Real-world detail is a checkable claim**: places, periods, technology, medicine, law and
  weapons carry `VERIFY` until `fact-check` has a source.

**Why this rule exists.** A silent repair on one page is a new contradiction with another page
that nobody knows about. Reported, a contradiction costs one decision; repaired in silence, it
costs a reader's trust when they find it.
<: else :>**Requirement: obligations are never invented.** Never add, remove, strengthen, soften or
reword a commitment, price, fee, date, deadline, service level, scope boundary, liability or
figure on your own initiative.

- Every commitment traces to a clause in an existing instrument or to the author's instruction;
  anything else is flagged `AUTHOR TO CONFIRM` as new.
- Prices, dates and service levels carry `VERIFY` until checked against their source document.
- `shall`, `may` and `must` are chosen deliberately, and no `will` is left unbounded
  (`obligation-check`).
- A template field with no answer yet reads `[AWAITING USER INPUT]`; it is never filled with a
  guess.
- Statutes and regulations are cited only once verified, with jurisdiction (<%JURISDICTION%>) and
  date; never cite a section number from memory.
- Disclaimers come verbatim from `standards/brand/disclaimers.md`; never paraphrase one.
- Amounts are in <%CURRENCY%>, and the voice is first person <: if BUSINESS_VOICE_PERSON == 'plural' :>plural ('we')<: else :>singular ('I')<: endif :>.

**Why this rule exists.** A client reads every sentence as a promise. A tidied obligation is a
changed contract, and the author is bound by it whether or not they noticed the change.
<: endif :>
---

## 8. Provenance and AI disclosure

**Requirement.** Every section has a ledger entry from its first draft, at
`standards/style/ledger/<unit>--<section-slug>.md`, where `<unit>` is the unit's name, number
included (`.claude/rules/syntek-author/08-naming-and-memory.md` Section 1), holding:

- `## AI original`: the AI draft the author worked from, verbatim and never tidied (empty for a
  section the author drafted; a redraft keeps the earlier one in a dated comment beneath it, as
  `standards/style/ledger/CLAUDE.md` sets out);
- `## Author final`: the text as promoted, written by `promote-section`;
- `## Improvement decisions`: every proposal with its decision, `accepted` or `rejected`, and
  every author's note `adapt-section` applied, logged as `author-note`.

**An author's note is not an AI suggestion.** `tooling/provenance.py` counts only `accepted` and
`rejected` rows as AI proposals, so the author's own notes never inflate the AI's share, and
`learn-voice` still mines them as evidence of the voice.

`promote-section` adds a row to `standards/style/ledger/provenance.md`; `tooling/provenance.py`
computes the author's change ratio, and `make provenance` prints a per-unit disclosure table.

When a publisher, agent, client or institution asks how AI was used, the answer comes from
`make provenance`, not from memory or impression. Never describe the work as unassisted when the
ledger says otherwise, and never overstate the AI's share either.

**Why this rule exists.** Honest disclosure needs a record kept at the time. Reconstructed later,
it becomes a guess, and a guess about authorship is the claim most damaging to get wrong.

---

## 9. Promotion and `final`

- **Promotion happens only on the author's explicit word.** `promote-section` then checks the
  section's gates and that it carries no flags, inserts it at its marker in plan order, sets
  `status: promoted`, records the ledger's `## Author final`, and updates the unit brief and the
  Status section of `.claude/MEMORY.md`.
- **A unit becomes `final` only through the review workflow and the author's word**, never through
  promotion. The gates for each step of the ladder are numbered in
  `standards/verification/verification.md`; the unit brief's `verified:` map records which passed.
- **Never overwrite a draft or a promoted file** without the author's confirmation.<: if DOC_TYPE != 'business' :>

---

## 10. Typesetting: the words are never retyped

**Requirement.** The printed book is set from the promoted Markdown, and the author's words reach
the LaTeX only through Pandoc, never through the AI's typing.

- `make tex` writes each chapter's base, Pandoc's own LaTeX, to `typeset/src/units/.base/`. A
  base is never hand-edited.
- The `typeset` skill copies a base to `typeset/src/units/` once and adds styling with the house
  class's macros only (`tooling/latex/housebook.cls`). Styling changes how words look, never
  which words there are.
- `make tex-check` compares the styled chapter's words with its Markdown's and fails on any
  insertion, deletion or change. A failed check is fixed by restoring the base's words, never by
  editing the Markdown to match the LaTeX.
- A change of wording is made in the Markdown, through the authoring loop (Section 2), and
  carried into the styled chapter by `git merge-file` against the old and new bases. Conflicts
  are resolved from the new base, then checked again.
- The page design (trim size, typefaces, chapter openers, the scene-break mark, footnote style)
  is the author's choice, recorded in `typeset/src/page-design.md`; the AI recommends and asks.

**Why this rule exists.** A retyped word is a word that can change unseen: a dropped 'not', a
tidied quotation, a corrected name. The ledger and `make provenance` describe the Markdown, so a
printed book whose words drift from it is a book whose disclosure is no longer true, and the
author would answer for a sentence they never wrote. The check makes every difference loud.<: else :>

---

## 10. Promotion into a LaTeX deliverable: the words are checked

**Requirement.** A section promoted into a `.tex` document carries exactly the words the author
approved in its Markdown draft.

- `promote-section` places the section between its `% section: <slug>` and
  `% end section: <slug>` markers, then runs `tooling/texcheck.py` in its section mode, which
  compares the words between the markers with Pandoc's plain text of the draft. Any difference
  stops the promotion before the ledger is written; the LaTeX is corrected, never the Markdown
  (`.claude/skills/promote-section/BUSINESS.md`).
- **Citation keys (`[@key]`) work only in Markdown documents.** A draft bound for a `.tex` that
  still holds `[@` stops the promotion, and the author writes the reference out in full.

**Why this rule exists.** The ledger records the Markdown as the author's final text. A word
changed while the section was set in LaTeX is a changed commitment the ledger says the author
approved, and a citation key printed raw in an issued document is a reference nobody can follow.<: endif :>
