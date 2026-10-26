# Quickstart — your first hour

This chapter takes you from a freshly made project to your first drafted section.
It assumes the tools in `how-to/src/TEMPLATE-GUIDE/syntek-author/02-prerequisites.md` are installed, and the glossary, `how-to/src/TEMPLATE-GUIDE/syntek-author/17-glossary.md`, explains any word you do not know.

## Where your project came from

Copier made this project from the syntek-author template, and recorded your answers in `.copier-answers.syntek-author.yml` at the top of the project.
That file is the answers file, and every later update reads it, so commit it and never edit it by hand.
Its `_src_path` line names the template's source, the place every update fetches the template from.
The README at that source gives the command that makes a new project, and explains each step of making one.
This guide never gives a web address for it, because the answers file always holds the right one.
If someone else made the project for you, you need nothing from the source to start writing.
After a copy, Copier also prints a few lines about the project, such as where this guide starts.

## Commit the start

A commit is a snapshot of every file, which Git keeps for good, so you can always go back to it.
Copier set the project up as a Git repository, a folder whose history Git records, but it does not commit anything for you.
This command records every file as your first commit, with the message in the quotation marks:

```bash
git add -A && git commit -m 'Start the project'
```

Git prints a short summary of what it recorded.
If Git says it does not know who you are, run the two commands it prints, with your own name and email, then commit again.
Commit again after each piece of work, with a message that says what you did.

## Open your first session

Open a terminal in the project's top folder, and start Claude Code there:

```bash
claude
```

Claude Code starts a session, a conversation with the assistant that lasts until you close it or clear it.
It reads `.claude/CLAUDE.md`, the project brief, and loads the rules in `.claude/rules/syntek-author/`, which tell it how this project works.
It then reads `.claude/MEMORY.md`, where the project's facts, decisions and status are kept between sessions.
Read the project brief in `.claude/CLAUDE.md` yourself first, and make sure it says what you mean: every skill reads it.
The settings Claude reads for your audience and reader are in `.claude/rules/syntek-author/00-project.md`, under `## Brief`.
Then ask Claude 'what's next?'.
The `run-workflow` skill reads where the project stands and recommends the next step, with the procedure that takes it.
If you kept the worked example, a sample chapter or document with its plan and its history, ask Claude to show you round it.
Delete the example when you no longer need it, and it never comes back.

## Your first section

Start by planning one chapter or document, which the project calls a unit.
Ask, in your own words, to plan the first one.
The `grill-with-docs` skill interviews you in short rounds of questions, each with a recommended answer you can accept or change.
What you settle becomes the unit's plan, its brief in `planning/src/units/`, which lists the sections in order.
The procedure it follows is `planning/workflows/01-plan-a-unit/`.
Then ask Claude to draft the first section.
The `draft-section` skill drafts one section, typically 300 to 500 words, into the unit's drafts folder.
Where it needs a decision from you, or a source it does not have, it leaves a flag in the text instead of guessing.
Read the draft, and give your notes in plain words, such as 'the opening is too slow' or 'say who she is first'.
Claude revises only the lines your notes reach, and shows you each change.
You can also edit the draft yourself, and tell Claude you have.
When you are happy with it, say so plainly, such as 'promote this section'.
The `promote-section` skill moves it into the unit and records its history.
Nothing is promoted without your word.

## Before you stop

Before you end a session, ask Claude to record anything decided that should outlast it, then type `/handoff`.
The `handoff` skill writes a short note in `handoffs/` saying where the work stands and what comes next, then stops.
Then type `/clear` to start afresh, and ask Claude to pick up from that note.
As a session fills up, a hook, a small script that runs on its own at set moments, advises a handoff at half full and insists at three-quarters.
The session never compacts on its own, so nothing is quietly summarised away.
If a session is ever too full to write a handoff, Claude says so: type `/compact`, which the project allows, then `/handoff`.
Commit your work before you close the terminal.

## Where the rules live

- `.claude/rules/syntek-author/01-layout-and-routing.md` Section 8: what a session reads first, and in what order.
- `.claude/rules/syntek-author/03-authorship.md` Sections 2 and 3: the writing loop and the size of a section.
- `.claude/rules/syntek-author/07-session-boundaries.md`: when and how a session hands off.
- `planning/workflows/01-plan-a-unit/`: the procedure for planning a unit.

## Next

- What each answer you gave means, and changing one → `how-to/src/TEMPLATE-GUIDE/syntek-author/04-the-answers.md`
- The writing loop in full → `how-to/src/TEMPLATE-GUIDE/syntek-author/07-the-writing-loop.md`
- What Copier made, and what an update does to it → `how-to/src/TEMPLATE-GUIDE/syntek-author/05-what-gets-generated.md`
