# 02-skills.md — the skill roster for this project, and the mode-file contract

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **Template-owned.** Shipped by syntek-author and replaced by every `copier update`: never edit it here. This project's settings, paths and overrides are in `00-project.md` beside it, which outranks this file; project rules go where its `## Paths` says.

Skills live in `.claude/skills/<skill>/SKILL.md`. This file is the roster: which skills ship in
this project, what each does, and which carry a mode file. The `.claude/skills/` pair routes here
rather than keeping a second list.

---

## 1. Skills only

**The template ships no commands and no agents.** Every template procedure is a skill. A skill
runs when it is named (`/draft-section`) or when the author describes its job ("draft the next
section of the unit"). A described job that no skill matches, a request such as "what's next?",
"pick up where we left off" or "run the review workflow", goes to `run-workflow`, which resolves
it to a workflow (and reads a handoff newer than `MEMORY.md` first). Every skill that carries out
a workflow runs the project's alias for it (`00-project.md` `## Workflow aliases`) or the
author's procedure of the same slug in `workflows/local/` instead, where one exists. Where work
benefits from a separate context, such as a delegated search or a multi-lens review, the skill
runs itself as a forked subagent (`context: fork`) instead of handing off to an agent file.

A template skill that is not listed here does not ship in this project on purpose. Never recreate
one, and never improvise a substitute under its name: say which skill is missing and why it
matters. Any other folder in `.claude/skills/` is the project's own (Section 7). For the author,
`how-to/src/TEMPLATE-GUIDE/syntek-author/13-a-guide-to-skills.md` explains which skill does
which job.

The paths in these tables are the template's defaults. Where `00-project.md` `## Paths` gives
another path for the same role, a skill uses that one, and where a skill names a heading of
`MEMORY.md`, it means the heading `## Memory headings` maps it to.

---

## 2. Modes

<: if DOC_TYPE == 'theology' :>**The mode file in this project is `THEOLOGY.md`.**
<: elif DOC_TYPE == 'fiction' :>**The mode file in this project is `FICTION.md`.**
<: else :>**The mode file in this project is `BUSINESS.md`.**
<: endif :>A moded skill's `SKILL.md` is the same in every doc type; the domain lives in the one mode file
that ships beside it. Every moded `SKILL.md` that this template alone ships carries this paragraph
before step 1:

> **Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they disagree, the procedure wins and the disagreement is reported to the author.

Every **family-shared** skill (Section 8) carries the neutral form instead, because another
Syntek template in the same project may ship mode files of its own beside it. `grill-me` and
`wait-what` carry it too, and this template ships no mode file beside them; with none there, the
paragraph has nothing to read:

> **Mode.** Before step 1, read the mode files beside this one (the upper-case `.md` files in this folder) that the project's rules route the work at hand to; where they name none, read every one. A mode file owns the domain (paths, the unit of work, extra reads, domain rules, examples); this file owns the procedure. Where they disagree, the procedure wins and the disagreement is reported to the owner.

This is the routing that paragraph means. In a project another Syntek template also built, a
family-shared skill's folder can hold that template's mode files too, under other upper-case
names. They are that template's: apply one only to work in the layers that template's rules
route. For work in this template's layers, read this template's mode file (above), which holds
the domain; where the two disagree, say so to the author rather than choosing silently.

Every mode file has the same four sections, so the split can be checked: `## Paths and unit`,
`## Additions to the steps` (keyed by step number), `## Domain rules` and `## Examples`.

**A mode file applies only when its `SKILL.md` carries one of the Mode paragraphs above.** A project's
own skill kept under a template skill's name (an adopted project,
`.claude/rules/syntek-author/01-layout-and-routing.md` Section 9) does not carry it, so the mode
file beside it is ignored: its steps are keyed to a procedure that is not there, and the
project's `SKILL.md` is the whole skill.

---

## 3. Shared writing skills

| Skill | What it does | Mode |
|---|---|---|
| `run-workflow` | The router for a request no other skill matches, "what's next?" or "resume from the handoff": resolves it to a workflow (`00-project.md` `## Workflow aliases` first, then `workflows/local/`; it lists the workflow folders directly where an index has no 'You want to…' table), loads `STEPS.md` with `CHECKLIST.md` open, obeys the gates, and biases towards producing prose | none |
| `draft-section` | Drafts **one** section of 300 to 500 words from the unit brief, the plan, the voice notes and the samples; opens its ledger entry | moded |
| `adapt-section` | Revises a draft from the author's notes or edits: changes only what was flagged, offers alternatives for contested lines; also adapts source material when asked | moded |
| `improve-section` | The author drafted: proposes improvements as a numbered diff, one reason each, at strength `light`, `edit` or `rework`; applies only what is accepted | moded |
| `promote-section` | On the author's word: checks gates and flags, inserts the section at its marker, records provenance, updates the brief and `MEMORY.md` | moded |
| `learn-voice` | Mines the ledger for what the author changed and rejected; proposes voice-note (and style-sheet or terminology) additions with real examples; writes each only after approval; marks an entry learned only once promoted and mined | moded |
| `fact-check` | Isolates and verifies checkable claims against primary sources; one verdict vocabulary; records evidence entries and `VERIFY` flags | moded |
| `spelling` | en_GB spelling against the style sheet and terminology; a supportive report grouped by recurring item. "Proofread …" runs `grammar` first, then this pass, as one report | moded |
| `grammar` | Grammar and punctuation against the style sheet; respects deliberate fragments and dialect | moded |
| `comprehension` | Reads as the stated reader (`00-project.md` `## Brief`: the audience and the reader test): undefined terms, leaps, buried points, by location | moded |
| `flow` | Transitions, paragraph order, rhythm, repetition, one voice across sections drafted out of order | moded |
| `structure-review` | Multi-lens structural review; writes advice only to `planning/src/reviews/` | moded |
| `build` | Builds a proof with `make`, reads it, and reports | moded |

---

## 4. Working-practice skills

| Skill | What it does | Mode |
|---|---|---|
| `grilling` | The engine: an interview in frontier rounds (every unblocked question in one message, each with a recommended answer) that sharpens a brief, argument, plot or document before any prose is drafted. Loaded by `grill-me` and `grill-with-docs`; "grill me on …" is `grill-me` | moded |
| `grill-me` | Stateless grilling: interview only, records nothing | neutral; no mode file |
| `grill-with-docs` | Grilling that records each decision as it resolves, to an existing artefact or `MEMORY.md` through the gate. **The design-work default** | moded |
| `wayfinder` | Charts work too big for one sitting into a decision map in `planning/src/maps/`, resolved across sessions in batches ordered by what they unblock; hands task nodes off, never does them | moded |
| `research` | Delegated primary-source search and question-led notes in `research/src/notes/`; `fact-check` calls it | moded |
| `prototype` | A throwaway spike in a `drafts/` folder answering one question about the writing, deleted once answered | moded |
| `handoff` | Writes a handoff to `handoffs/` and stops; run instead of compacting, and when either session hook fires (`.claude/rules/syntek-author/07-session-boundaries.md`) | moded |
| `to-questionnaire` | Turns a decision only someone outside the session can answer into a questionnaire in `planning/src/questionnaires/`, records the block, and resolves the decision when the answers return; runs only on the author's word (a grilling pass or a decision map may propose it, never run it unasked), and never sends anything | moded |
| `teach` | A practice workspace under `learning/`; the project is read-only during a lesson | moded |
| `wait-what` | Re-pitches a reply that did not land, in plain language, with the context it assumed | neutral; no mode file |

They compose: `grilling` is the engine `grill-me` and `grill-with-docs` wrap, `wayfinder`
sends each map node to the skill that can resolve it, and `to-questionnaire` takes the decisions
the author cannot answer alone. Seven of them are family-shared (Section 8).

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
| `tone` | House voice and plain English by register, Simplified Technical English for technical text (method rule 11); never changes a figure, date, scope or commitment | none |
| `obligation-check` | shall, may and must used deliberately; every commitment traced to a clause or flagged new; prices, dates and service levels flagged `VERIFY` | none |
| `business-documents` | The business family: proposals, statements of work, client guides and the business's internal policies<: if DOC_TYPE == 'business' and 'msp-scp' in BUSINESS_FAMILIES :> on HR and staff conduct (its IT and information-security policies are `msp-scp-documents`')<: endif :>; their document types, required sections, house conventions and checks; runs `library/workflows/10-create-a-business-document/` | none |
<: endif :><: if DOC_TYPE == 'business' and 'legal' in BUSINESS_FAMILIES :>| `legal-documents` | The legal family: contracts, non-disclosure and data processing agreements, and terms; runs `library/workflows/11-create-a-legal-document/` | none |
<: endif :><: if DOC_TYPE == 'business' and 'email' in BUSINESS_FAMILIES :>| `email-documents` | The email family: client and supplier correspondence; runs `library/workflows/12-write-an-email/` | none |
<: endif :><: if DOC_TYPE == 'business' and 'accounting' in BUSINESS_FAMILIES :>| `accounting-documents` | The accounting family: invoices, expenses and financial reports; runs `library/workflows/13-create-an-accounting-document/` | none |
<: endif :><: if DOC_TYPE == 'business' and 'social-media' in BUSINESS_FAMILIES :>| `social-media-documents` | The social media family: plans, content calendars and profiles; runs `library/workflows/14-create-a-social-media-document/` | none |
<: endif :><: if DOC_TYPE == 'business' and 'msp-scp' in BUSINESS_FAMILIES :>| `msp-scp-documents` | The managed-service family: IT and information-security policies, plans and reports for managed-service clients and for the business itself; runs `library/workflows/15-create-an-msp-scp-document/` | none |
<: endif :><: if DOC_TYPE == 'business' :>
**The family skills** ship one per family in this project
(`.claude/rules/syntek-author/01-layout-and-routing.md` Section 4). Each holds its family's
document types, required sections, house conventions and checks, and routes to the family's
standard, `library/docs/reference/<family>-standards.md`. When a shared skill works on a document
in a family folder, the family skill and its standard hold the conventions that work must keep.
<: endif :>
---

## 6. Option skills

<: if INCLUDE_REFERENCES or (DOC_TYPE != 'business' and INCLUDE_PROPOSAL) or (DOC_TYPE != 'business' and INCLUDE_SENSITIVE_CONTENT) :>| Skill | What it does | Mode |
|---|---|---|
<: if INCLUDE_REFERENCES :>| `add-reference` | Adds a work to `tooling/references.db` under a citation key that is never renamed | none |
<: endif :><: if DOC_TYPE != 'business' and INCLUDE_PROPOSAL :>| `approach-a-reader` | <: if DOC_TYPE == 'theology' :>Prepares an approach to a prospective endorser<: else :>Prepares an approach to a literary agent<: endif :> and records it in the tracker | moded |
<: endif :><: if DOC_TYPE != 'business' and INCLUDE_SENSITIVE_CONTENT :>| `sensitivity-pass` | Checks sensitive material for trauma-aware handling, sourcing, signposting and safeguarding | moded |
<: endif :><: else :>No option skills are switched on in this project. They are added by re-answering the Copier
questions (`how-to/src/TEMPLATE-GUIDE/syntek-author/04-the-answers.md`).
<: endif :>
---

## 7. Working with skills

- **Read the whole `SKILL.md`, then its mode file if it carries the Mode paragraph, before
  step 1.** A skill's steps each end with a completion test; a step is not done until its test
  passes.
- **Skills never edit themselves or each other.** No skill rewrites a skill, standard, rules file
  or `CLAUDE.md` without the author's explicit instruction
  (`.claude/rules/syntek-author/06-global-rules.md` Section 3).
- **A project-specific change to how a skill behaves** is written in `00-project.md`
  `## Overrides` (naming the skill and step it replaces), or as a project rule where its
  `## Paths` says. Editing the skill itself is undone, or turned into a conflict, by the next
  update; editing a family-shared `SKILL.md` (Section 8) freezes it instead, and every later
  update reports it as not updated because it was changed, with the commands to compare it and
  to take the template's copy.
- **A skill of the author's own** goes in a new folder whose name collides with no skill in this
  file. Its frontmatter `name` equals the folder name. It belongs to the author, and Copier never
  touches it. A project that adopted the template may also keep its own skill under a template
  skill's name; that folder is the project's, and Section 2 says how its mode file is treated.

---

## 8. Family-shared skills, and the paths they reach through these rules

Seven working-practice skills are **family-shared**: `grill-me`, `grill-with-docs`, `grilling`,
`handoff`, `wait-what`, `wayfinder` and `to-questionnaire`. Their `SKILL.md` is byte for byte the
one every Syntek template ships, so a project with two templates holds one copy. It is written by
the first copy, refreshed by each update while you have not changed it, and written by the update
of the release that introduces one where you never had it (one you deleted stays deleted); their
mode files stay this template's own. A family-shared `SKILL.md` names no path only one template
ships: it names a **role**, and this table gives the role its path in this project. Where
`00-project.md` `## Paths` gives one of the other roles below another path, that row wins; its
`Project rules` row is where your own extra rules live, and adds to this folder, never replaces it.

| Role, as the shared skills name it | Path in this project |
|---|---|
| The project's rules (this rules folder; not the `Project rules` row of `00-project.md`) | `.claude/rules/syntek-author/`, with `00-project.md` first |
| Mode files | <: if DOC_TYPE == 'theology' :>`THEOLOGY.md`<: elif DOC_TYPE == 'fiction' :>`FICTION.md`<: else :>`BUSINESS.md`<: endif :> beside the `SKILL.md` (Section 2; another template's mode files beside it apply only to its work) |
| Skill rosters | this file |
| Global rules (never self-edit; design opens with grilling; internal notes; confidentiality) | `06-global-rules.md` Sections 3, 8, 9 and 10 |
| Authorship rules (the author decides; the AI recommends) | `03-authorship.md` Section 1 |
| Memory rules (where a decision lives; the memory gate; the entry form) | `08-naming-and-memory.md` Sections 2 to 4 |
| Session-boundaries rule | `07-session-boundaries.md` |
| Memory headings (`Decisions`, `Facts`, `Feedback`, `Status`, `Open questions`, `Sensitivities`) | `00-project.md` `## Memory headings` |
| Handoffs folder and filename | `00-project.md` `## Paths` (by default `handoffs/HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md`) |
| A piece of the work (what one brief covers) | a unit: <: if DOC_TYPE == 'business' :>one document in a family folder of `library/src/`<: else :>one chapter, `manuscript/src/NN-kebab-title/`<: endif :>, as the mode file's `## Paths and unit` says |
| Brief, briefs folder, and the brief guide | `planning/src/units/<unit>.md`; `planning/src/units/`; `planning/docs/reference/unit-briefs.md` (the settled-positions slot: the mode file names it; the draft-notes slot: `## Draft notes`, in the brief guide) |
| Plan files | the mode file names them<: if DOC_TYPE == 'theology' :> (the argument maps in `planning/src/arguments/`)<: elif DOC_TYPE == 'fiction' :> (`planning/src/causality.md`, `planning/src/continuity.md`, `planning/src/timeline.md` and `planning/src/arcs/`)<: else :> (`planning/src/document-register.md`, `planning/src/review-schedule.md` and `planning/src/precedence.md`)<: endif :> |
| Outline | `planning/src/outline.md` |
| Planning procedure | `planning/workflows/01-plan-a-unit/` (reading and questioning: steps 3 to 7; the brief and its first gate, V1: step 8; recording: step 9) |
| Whole-work review procedure | `planning/workflows/09-review-the-whole-work/` (step 6) |
| Reviews folder | `planning/src/reviews/` |
| Decision-maps folder, and its index | `00-project.md` `## Paths` (by default `planning/src/maps/`, indexed in its `CONTEXT.md`) |
| Decision-map guide | `planning/docs/reference/decision-maps.md` |
| Questionnaires folder | `planning/src/questionnaires/`, each `QUESTIONNAIRE-<SLUG>-DD-MM-YYYY.md` |
| Method standard | `standards/method/method.md` (Sections 1 and 8) |
| Terminology file | `standards/style/terminology.md` |
| Voice guide | `standards/style/voice-notes.md`<: if DOC_TYPE == 'business' :>, with the brand folder's `brand-voice.md`<: endif :> |
| Evidence folder | `research/src/evidence/` |
| Research notes folder | `00-project.md` `## Paths` (by default `research/src/notes/`) |
| Record of provenance (where each passage came from) | the ledger, `standards/style/ledger/` (`00-project.md` `## Paths`): one entry per section (`03-authorship.md` Section 8) |
| Record of permissions and approvals | <: if DOC_TYPE == 'fiction' :>the permissions register, `research/src/permissions.md` (a permission to quote); there are no approval records<: elif DOC_TYPE == 'business' :>`planning/src/approvals/` for an approval, as `00-project.md` `## Paths` names each record; a permission has none, and waits under the `Open questions` heading of `MEMORY.md` until it is granted<: else :>none: a permission waits under the `Open questions` heading of `MEMORY.md` until it is granted<: endif :> |
| Open-flags check | `make flags`, with any extra marker `tooling/project.mk` adds |
| Fact-checking, research, prototyping and teaching skills | `fact-check`, `research`, `prototype`, `teach` (Section 4) |
| Learning workspace | `learning/<topic>/`, written by `teach` |
