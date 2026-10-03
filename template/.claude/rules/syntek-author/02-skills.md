# 02-skills.md — the skill roster for this project, and the mode-file contract

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **Template-owned.** Shipped by syntek-author and replaced by every `copier update`: never edit it here. Project-specific rules belong in `.claude/CLAUDE.md` Section 3.

Skills live in `.claude/skills/<skill>/SKILL.md`. This file is the roster: which skills ship in
this project, what each does, and which carry a mode file. The `.claude/skills/` pair routes here
rather than keeping a second list.

---

## 1. Skills only

**This project has no commands and no agents.** Every procedure is a skill. A skill runs when it
is named (`/draft-section`) or when the author describes its job ("draft the next section of
the unit"). A described job that no skill matches, a request such as "what's next?", "pick up
where we left off" or "run workflow 05", goes to `run-workflow`, which resolves it to a workflow
(and reads a handoff newer than `MEMORY.md` first). Every skill that carries out a workflow runs the
author's procedure of the same name in `workflows/local/` instead, where one exists. Where work
benefits from a separate context, such as a delegated search or a multi-lens review, the skill
runs itself as a forked subagent (`context: fork`) instead of handing off to an agent file.

A skill that is not listed here does not ship in this project on purpose. Never recreate one, and
never improvise a substitute under its name: say which skill is missing and why it matters.

---

## 2. Modes

<: if DOC_TYPE == 'theology' :>**The mode file in this project is `THEOLOGY.md`.**
<: elif DOC_TYPE == 'fiction' :>**The mode file in this project is `FICTION.md`.**
<: else :>**The mode file in this project is `BUSINESS.md`.**
<: endif :>A moded skill's `SKILL.md` is the same in every doc type; the domain lives in the one mode file
that ships beside it. Every moded `SKILL.md` carries this paragraph before step 1:

> **Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they disagree, the procedure wins and the disagreement is reported to the author.

Every mode file has the same four sections, so the split can be checked: `## Paths and unit`,
`## Additions to the steps` (keyed by step number), `## Domain rules` and `## Examples`.

---

## 3. Shared writing skills

| Skill | What it does | Mode |
|---|---|---|
| `run-workflow` | The router for a request no other skill matches, "what's next?" or "resume from the handoff": resolves it to a workflow (`workflows/local/` first), loads `STEPS.md` with `CHECKLIST.md` open, obeys the gates, and biases towards producing prose | none |
| `draft-section` | Drafts **one** section of 300 to 500 words from the unit brief, the plan, the voice notes and the samples; opens its ledger entry | moded |
| `adapt-section` | Revises a draft from the author's notes or edits: changes only what was flagged, offers alternatives for contested lines; also adapts source material when asked | moded |
| `improve-section` | The author drafted: proposes improvements as a numbered diff, one reason each, at strength `light`, `edit` or `rework`; applies only what is accepted | moded |
| `promote-section` | On the author's word: checks gates and flags, inserts the section at its marker, records provenance, updates the brief and `MEMORY.md` | moded |
| `learn-voice` | Mines the ledger for what the author changed and rejected; proposes voice-note (and style-sheet or terminology) additions with real examples; writes each only after approval; marks an entry learned only once promoted and mined | moded |
| `fact-check` | Isolates and verifies checkable claims against primary sources; one verdict vocabulary; records evidence entries and `VERIFY` flags | moded |
| `spelling` | en_GB spelling against the style sheet and terminology; a supportive report grouped by recurring item. "Proofread …" runs `grammar` first, then this pass, as one report | moded |
| `grammar` | Grammar and punctuation against the style sheet; respects deliberate fragments and dialect | moded |
| `comprehension` | Reads as the stated reader (`.claude/CLAUDE.md` Section 1): undefined terms, leaps, buried points, by location | moded |
| `flow` | Transitions, paragraph order, rhythm, repetition, one voice across sections drafted out of order | moded |
| `structure-review` | Multi-lens structural review; writes advice only to `planning/src/reviews/` | moded |
| `build` | Builds a proof with `make`, reads it, and reports | moded |

---

## 4. Working-practice skills

| Skill | What it does | Mode |
|---|---|---|
| `grilling` | The engine: an interview in frontier rounds (every unblocked question in one message, each with a recommended answer) that sharpens a brief, argument, plot or document before any prose is drafted. Loaded by `grill-me` and `grill-with-docs`; "grill me on …" is `grill-me` | moded |
| `grill-me` | Stateless grilling: interview only, records nothing | none |
| `grill-with-docs` | Grilling that records each decision as it resolves, to an existing artefact or `MEMORY.md` through the gate. **The design-work default** | moded |
| `wayfinder` | Charts work too big for one sitting into a decision map in `planning/src/maps/`, resolved across sessions | moded |
| `research` | Delegated primary-source search and question-led notes in `research/src/notes/`; `fact-check` calls it | moded |
| `prototype` | A throwaway spike in a `drafts/` folder answering one question about the writing, deleted once answered | moded |
| `handoff` | Writes a handoff to `handoffs/` and stops; run instead of compacting (`.claude/rules/syntek-author/07-session-boundaries.md`) | moded |
| `teach` | A practice workspace under `learning/`; the project is read-only during a lesson | moded |
| `wait-what` | Re-pitches a reply that did not land, in plain language, with the context it assumed | none |

They compose: `grilling` is the engine `grill-me` and `grill-with-docs` wrap, and `wayfinder`
sends each map node to the skill that can resolve it.

---

## 5. Doc-type skills

These ship only where their job exists. Each ships whole, with no mode file, unless the Mode
column says otherwise.

| Skill | What it does | Mode |
|---|---|---|
<: if DOC_TYPE != 'business' :>| `typeset` | Sets the book for print without retyping a word: Pandoc base, house-class styling, `make tex-check`, a three-way carry-forward after edits, then `make print`; page-design choices are the author's | moded |
<: endif :><: if DOC_TYPE == 'theology' :>| `argument-audit` | Checks prose against the unit's argument map: claim, supporting claims, evidence, objections, concessions; flags unsupported moves and conclusions stated beyond their evidence | none |
| `category-check` | Labels every substantive sentence with one of the six claim categories; flags silent collapses between them | none |
| `tradition-check` | How readers from other traditions would push back; each reading stated so its holders would recognise it, named in the body | none |
| `steelman` | Recognition, ease and missing-objection tests; concession positioned ahead of the response; reports, never rewrites | none |
<: endif :><: if DOC_TYPE == 'fiction' :>| `continuity` | Checks prose against the story bible, timeline and names register; reports contradictions, never silently repairs them | none |
| `character-voice` | Dialogue and point-of-view narration against each character's voice markers; flags drift | none |
| `causality` | Every beat cites its cause in the causality chain; flags coincidence-driven advancement | none |
| `pacing` | Scene length, scene and sequel alternation, tension per chapter; report only | none |
| `create-name` | Three to five name options built from the world files (people, culture, history and, with the language kit, the language and its real-world models), each checked for look-alikes, sound-alikes and false friends and read aloud; registers the chosen name | none |
| `chart-character-arc` | Arc type, want against need, the lie and the truth, the wound, beats mapped to chapters and sections | none |
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>| `create-creature` | A bestiary entry checked against the world's established rules | none |
| `design-quest` | Goal, stakes, obstacles, reversals, cost and reward, tied to arcs and causality so no quest dangles | none |
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>| `build-language` | World first and sound first: the speakers, two or three researched real-world models with a recommendation, proto or daughter, phonology, romanisation, grammar and a core lexicon from roots, each settled before the next | none |
| `add-word` | Coins one word (or a small batch) from roots, affixes or compounds, with its history (stratum, entry point, drift), any cited echo, a false-friend check, IPA and native spelling; validated with `make lexicon` | none |
| `design-script` | The writing system: its own real-world inspiration (medium, tool, origin, script family), type, direction, transliteration rules, one filled-outline SVG per glyph on the em grid, then `make font` and a sample | none |
| `pronounce` | Audio from the surface IPA for a word, name or sentence, in the language's recorded voice; states the character count before any batch, because every call spends credits; never generates unasked | none |
<: endif :><: if DOC_TYPE == 'business' :>| `clause-consistency` | Defined terms defined and bolded once, cross-references resolve, near-synonyms disambiguated, precedence stated | none |
| `tone` | House voice and plain English by register; never changes a figure, date, scope or commitment | none |
| `obligation-check` | shall, may and must used deliberately; every commitment traced to a clause or flagged new; prices, dates and service levels flagged `VERIFY` | none |
<: endif :>
---

## 6. Option skills

<: if INCLUDE_REFERENCES or (DOC_TYPE != 'business' and INCLUDE_PROPOSAL) or (DOC_TYPE != 'business' and INCLUDE_SENSITIVE_CONTENT) :>| Skill | What it does | Mode |
|---|---|---|
<: if INCLUDE_REFERENCES :>| `add-reference` | Adds a work to `tooling/references.db` under a citation key that is never renamed | none |
<: endif :><: if DOC_TYPE != 'business' and INCLUDE_PROPOSAL :>| `approach-a-reader` | <: if DOC_TYPE == 'theology' :>Prepares an approach to a prospective endorser<: else :>Prepares an approach to a literary agent<: endif :> and records it in the tracker | moded |
<: endif :><: if DOC_TYPE != 'business' and INCLUDE_SENSITIVE_CONTENT :>| `sensitivity-pass` | Checks sensitive material for trauma-aware handling, sourcing, signposting and safeguarding | moded |
<: endif :><: else :>No option skills are switched on in this project. They are added by re-answering the Copier
questions (`README.md`, "Updating from the template").
<: endif :>
---

## 7. Working with skills

- **Read the whole `SKILL.md`, then its mode file, before step 1.** A skill's steps each end with
  a completion test; a step is not done until its test passes.
- **Skills never edit themselves or each other.** No skill rewrites a skill, standard, rules file
  or `CLAUDE.md` without the author's explicit instruction
  (`.claude/rules/syntek-author/06-global-rules.md` Section 3).
- **A project-specific change to how a skill behaves** is written as a rule in `.claude/CLAUDE.md`
  Section 3. Editing the skill itself is undone, or turned into a conflict, by the next update.
- **A skill of the author's own** goes in a new folder whose name collides with no skill in this
  file. Its frontmatter `name` equals the folder name. It belongs to the author, and Copier never
  touches it.
