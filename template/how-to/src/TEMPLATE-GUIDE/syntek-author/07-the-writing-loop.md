# The writing loop — from a plan to a promoted section

The work is written one small section at a time, and you decide every step.
This chapter follows a section from its plan to its place in the finished chapter or document, then through review.

## Plan before you draft

Each chapter or document, which the project calls a unit, starts as a plan before any of it is drafted.
The plan is the unit's brief, a file in `planning/src/units/` that holds its scope, its sections in order and its status.
Ask Claude to plan the unit, in your own words.
The `grill-with-docs` skill interviews you in short rounds, each question with a recommended answer you can take or change.
It records what you settle in the brief, and lasting decisions in `.claude/MEMORY.md`.
The procedure it follows is `planning/workflows/01-plan-a-unit/`.
A unit's status climbs a ladder: idea, outlined, draft, structural review, fact check, line edit, final.
It moves up a rung only when that rung's checks, called gates, have passed.
Planning first means each section is written to a purpose you have agreed, so a draft rarely goes the wrong way.

## One section at a time

A section is a small passage of the unit, typically 300 to 500 words that make one move.
In a theology book that is one step of the argument, in a novel one scene beat, and in a business document one group of clauses.
Ask Claude to draft the next section, and the `draft-section` skill drafts exactly one, into the unit's drafts folder.
It writes in your voice, as your voice notes describe it, and flags every claim it could not check and every decision only you can make.
It also opens the section's ledger entry, the section's history, with its draft copied word for word.
You can write a section yourself instead: put it in the drafts folder and tell Claude, and the ledger keeps your original.
A section that size can be read in one sitting and judged line by line, and a wrong turn costs one section, not a chapter.
Claude drafts one section at a time unless you ask for more.
In a business project, a document filled in whole from one of its family's templates skips the loop, but keeps its flags and its final checks.

## Revising

There are two ways to revise a draft, and in both you decide every change.

- The `adapt-section` skill revises a draft from your notes or your own edits, changing only the lines your notes reach.
- Where a line is contested, `adapt-section` offers two or three alternatives for you to choose from.
- The `improve-section` skill works on a section you wrote yourself, and proposes numbered changes, each with a one-line reason.
- You choose how strong its proposals are: light, edit or rework.

You accept or reject each change, and nothing is applied that you have not seen.
Claude never rewrites a whole section unasked, and never tidies a line you did not ask about.
Claude asks once about anything odd that may be deliberate, such as a fragment, a dialect spelling or a repetition.
Your answer is recorded, so no later pass corrects it.
Revise as often as you like: every round is recorded in the ledger.

## Promoting

Promoting a section moves it from its drafts folder into the unit itself.
It happens only on your explicit word, such as 'promote this section'.
Approving what a section says is not the same as asking to promote it, and silence is never taken as yes.
The `promote-section` skill checks that the section has no open flags, places it in the unit in plan order, and records your final text in the ledger.
It also updates the unit's brief and the project's status in `.claude/MEMORY.md`.
Promotion never makes a unit final: that takes the reviews below and your word.

## Reviews and gates

Once every section of a unit is promoted, and a proof of it builds, the unit goes through review in stages.

- `structure-review` reads the whole unit for its shape and its argument or story, and writes its findings as advice.
- `fact-check` gives every checkable claim a verdict, with its source recorded in `research/src/evidence/`.
- At the line edit, `comprehension` reads as your stated reader, and `flow`, `grammar` and `spelling` check the prose.

Your variant adds checks of its own at these stages, which your variant's chapter of this guide describes.
Each stage is a numbered gate in `standards/verification/verification.md`, and the unit's brief records which gates have passed.
Every review reports and suggests; you decide every change.
Ask Claude to review a unit, or ask 'what's next?', and `run-workflow` finds the review procedure.

## The ledger and provenance

Every section has its own ledger entry, a file in `standards/style/ledger/`, from its first draft onwards.
It keeps the original text, whether the AI's draft or yours, word for word and never tidied.
It keeps every later revision, marked by who made it: an AI suggestion you accepted, the AI applying your note, or your own edit.
It keeps your final text as promoted, and every proposal with your decision on it.
Your own notes are counted as yours, never as the AI's suggestions.
Provenance means the record of who wrote what, and the ledger is that record, kept at the time rather than remembered later.
`make provenance` prints a table with a row for each unit, showing how the AI was used, for a publisher, a client or anyone else who asks.
`make compare` prints each section's journey as a PDF in `build/compare/`: its original, the AI's edit and your final text, with every change marked by who made it.
Never describe the work as unassisted when the ledger says otherwise.

## The two flags

Where Claude cannot settle something itself, it leaves a flag in the text, written as a comment that you can search for.

- `<!-- AUTHOR TO CONFIRM: … -->` marks a decision only you can make, such as a name, a position or a commitment.
- `<!-- VERIFY: … -->` marks a claim that can be checked but has not been, such as a date, a quotation or a figure.

Each flag asks one question, worded so that someone who was not there can answer it.
`make flags` lists every open flag in the project, by file and line.
Your project may count other open-item marks too, which `tooling/project.mk` names.
Never delete a flag to make a gate pass: answer it, and Claude applies your answer.
A unit becomes final only when no flag is left in it.

## Learning your voice

Your voice notes, in `standards/style/voice-notes.md`, describe how you write, and every draft follows them.
The `learn-voice` skill reads the ledger to see what you changed, what you kept and what you rejected.
It then proposes additions to your voice notes, each with the evidence for it, and you approve each one.
Samples of your own writing in `standards/style/samples/` give it more to learn from.
The style sheet, `standards/style/style-sheet.md`, and the terminology list, `standards/style/terminology.md`, settle words and marks that must stay the same throughout.
Over time, the drafts sound more like you and need fewer changes.

## Where the rules live

- `.claude/rules/syntek-author/03-authorship.md` Sections 1 to 6: who decides what, the loop, section size, never inventing a source, the two flags, and suggesting rather than rewriting.
- `.claude/rules/syntek-author/03-authorship.md` Sections 8 and 9: provenance, promotion and the final status.
- `standards/verification/verification.md`: the gates of each step up the ladder.
- `standards/style/ledger/CONTEXT.md`: what a ledger entry holds.
- `planning/workflows/01-plan-a-unit/`: the procedure for planning a unit.

## Next

- Turning your text into a proof → `how-to/src/TEMPLATE-GUIDE/syntek-author/08-building-proofs.md`
- Which skill does which job → `how-to/src/TEMPLATE-GUIDE/syntek-author/13-a-guide-to-skills.md`
- A word this chapter uses that you do not know → `how-to/src/TEMPLATE-GUIDE/syntek-author/17-glossary.md`
