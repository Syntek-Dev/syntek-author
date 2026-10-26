# A guide to skills — which skill does which job

A skill is a written procedure that a session follows for one kind of job, such as drafting a section or checking facts.
You rarely need a skill's name: say what you want in plain words, and the skill for that job runs.
This chapter lists the skills every project has, grouped by the work they do, with the words that reach each one; the glossary, `how-to/src/TEMPLATE-GUIDE/syntek-author/17-glossary.md`, explains any word you do not know.

## Three ways to reach a skill

You can name a skill, by typing a slash and its name, such as `/draft-section`.
You can describe the job instead, such as 'draft the next section', and the skill whose job it is runs.
You can also ask 'what's next?' or 'pick up where we left off'.
Then `run-workflow` finds the procedure that fits, reading the latest handoff first if one is newer than the project's memory.
A request that no skill matches goes to `run-workflow` as well.
The phrases in the tables below are examples, never passwords: any wording that describes the job will do.

## Skills for writing

These skills carry a section from its first draft into the work, and you decide at every step.

| Skill | What it does | Say something like |
|---|---|---|
| `draft-section` | Drafts one section of 300 to 500 words from the unit's brief, in your voice, with every unchecked claim flagged | 'draft the next section' |
| `adapt-section` | Revises a draft from your notes or your own edits, changing only what you flagged | 'here are my notes on section 2' |
| `improve-section` | Proposes numbered changes to a section you wrote, one reason each, and applies only those you accept | 'suggest improvements to my opening' |
| `promote-section` | Moves an approved section into its unit, on your word only, after checking its gates and flags | 'promote the scope section' |
| `learn-voice` | Learns from what you changed and rejected, and proposes additions to your voice notes for you to approve | 'learn from my edits' |
| `build` | Builds a proof with `make`, reads it, and reports what it found | 'build me a proof of chapter 2' |
| `run-workflow` | Finds the procedure for a request no other skill matches | 'what's next?' |

`how-to/src/TEMPLATE-GUIDE/syntek-author/07-the-writing-loop.md` shows how these skills fit together.

## Skills for thinking and planning

These skills help you decide before anything is written, and keep long work on track across sessions.

| Skill | What it does | Say something like |
|---|---|---|
| `grill-with-docs` | Interviews you to settle a plan, and records each decision where it belongs as it is made | 'let's plan the next part' |
| `grill-me` | Interviews you the same way, and records nothing | 'grill me on this idea' |
| `grilling` | The interview itself, which the two skills above use, asked in rounds with a recommended answer on every question | 'pressure-test the ending' |
| `wayfinder` | Charts work too big for one sitting into a map of open decisions, settled across sessions | 'map out the second half' |
| `research` | Answers a question from primary sources and leaves a cited note | 'find out what the sources say about this' |
| `prototype` | Writes a throwaway test of a passage to answer one question, then deletes it | 'try the opening three ways' |
| `to-questionnaire` | Turns a question only someone else can answer into a questionnaire, and never sends it | 'make a questionnaire for my editor' |
| `handoff` | Writes a handoff so the next session can carry on, then stops | 'hand this off' |
| `teach` | Opens a practice workspace in `learning/`, where you learn a skill without touching the real work | 'teach me how to write a strong ending' |
| `wait-what` | Explains the last reply again, in plain words, with the context it assumed | 'wait, what?' |

A session never decides for you: each of these skills recommends, and you choose.

## Skills for reviewing

These skills report on a draft, and change nothing until you say so.

| Skill | What it does | Say something like |
|---|---|---|
| `structure-review` | Reviews the structure of a unit or the whole work through several lenses, and writes advice to `planning/src/reviews/` | 'review the structure of chapter 4' |
| `fact-check` | Checks each checkable claim against a primary source, and records the evidence | 'check the facts in this section' |
| `comprehension` | Reads as your stated reader, and reports where that reader would stumble | 'will my reader follow this?' |
| `flow` | Reports on transitions, order, rhythm and repetition, and whether it sounds like one writer | 'does this flow?' |
| `grammar` | Reports grammar and punctuation against your style sheet | 'check the grammar' |
| `spelling` | Reports British spelling against your style sheet and terminology | 'check the spelling' |

Asking to 'proofread' a section runs `grammar` and then `spelling`, as one report.
The review procedure of the content layer, the folder that holds your work (see `.claude/rules/syntek-author/01-layout-and-routing.md`), runs them in order.
The gates each review must pass are numbered in `standards/verification/verification.md`.

## When a skill does the wrong thing

Say so, in plain words, and the session stops and asks.
If you did not follow a reply, `wait-what` explains it again.
A skill that keeps doing something you never want is changed in your project's settings, never in the skill itself.
Write the change under `## Overrides` in `.claude/rules/syntek-author/00-project.md`, naming the skill and the step it replaces.
Every update merges the template's changes into a skill's own file you have edited, and leaves a conflict where you both changed the same lines.
An edit to a shared skill freezes it instead, so it never receives the template's later fixes.
A skill of your own in `~/.claude/skills/` with a project skill's name replaces the project's in Claude Code.
A skill of your own with a new name is yours, and no update ever touches it.
`how-to/src/TEMPLATE-GUIDE/syntek-author/09-customising.md` explains overrides in full.

## Skills for your kind of project

A theology book, a novel and a business library each have skills of their own, for the checks that only that kind of work needs.
Some options, chosen when the project was made, add skills too.
Your variant's own chapter in this folder introduces them: chapter 14 for a theology book, chapter 15 for a novel and chapter 16 for business documents.
`.claude/rules/syntek-author/02-skills.md` lists every skill this project has, the options' skills included, with what each does.

## Where the rules live

- `.claude/rules/syntek-author/02-skills.md` is the list of every skill this project ships, and says how a skill may be changed.
- `.claude/rules/syntek-author/03-authorship.md` says who decides what while a skill works.
- `.claude/rules/syntek-author/05-model-allocation.md` says which model each kind of work uses.

## Next

- How the writing skills work together → `how-to/src/TEMPLATE-GUIDE/syntek-author/07-the-writing-loop.md`
- Making a skill behave your way → `how-to/src/TEMPLATE-GUIDE/syntek-author/09-customising.md`
- A word you do not know → `how-to/src/TEMPLATE-GUIDE/syntek-author/17-glossary.md`
