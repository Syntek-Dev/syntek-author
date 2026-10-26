# Overview — what a syntek-author project is, and how this guide is laid out

This project was made from syntek-author, a template that gives a piece of writing its folders, its rules and a set of AI skills.
This chapter says what kind of project you have, how the work in it is organised, and how to find your way round this guide.

## What a project is

A project is one folder of plain text files, which Git looks after and Claude Code helps you write.
Git is the tool that records every version of your files, so nothing you commit is ever lost, and a folder it looks after is called a repository.
Claude Code is an AI assistant that works inside the folder, as your drafting and checking partner.
The template makes one of three kinds of project, called variants.

- The theology variant is for a Christian non-fiction book.
- The fiction variant is for a novel.
- The business variant is for a library of business, legal and client documents.

The variant was chosen once, when the project was made, with the answer `DOC_TYPE`, and it never changes.
It decides the folders, the rules and the skills you have.
A different variant is a new project, never a change to this one.
Options add to a variant, such as a citation database, a book proposal or the kits for building a fictional world.
`how-to/src/TEMPLATE-GUIDE/syntek-author/04-the-answers.md` lists every answer and what it gave you.

## How the work is organised

The work lives in layers, the top-level folders of the project.
Production layers are where the work is made, through steps you repeat for each chapter or document.

- `planning/` holds the outline, one plan for each chapter or document, decision maps and reviews.
- `research/` holds your sources, the evidence you have checked and your research notes.
- The content layer holds the prose itself, and `.claude/rules/syntek-author/01-layout-and-routing.md` names it for this project.

Some variants and options add production layers of their own, such as one for a book proposal or one for a novel's story bible.
Supporting layers hold what the work answers to: `standards/` for style, method and checking, and `tooling/` for the build that turns your text into proofs.
Working folders sit outside the work: `handoffs/` for notes between sessions, `learning/` for practice, and `assets/` for images.
`how-to/src/TEMPLATE-GUIDE/syntek-author/06-a-tour-of-the-project.md` takes you round each one.

## Skills, not commands

You do not need to learn any commands to write here.
You ask Claude in plain words, such as 'draft the next section' or 'check the spelling in this chapter', and a skill does the job.
A skill is a written procedure that Claude follows for one kind of job, kept in its own folder under `.claude/skills/`.
You can also call a skill by its name, such as `/draft-section`.
When no skill fits what you asked, or you ask 'what's next?', the `run-workflow` skill finds the procedure that does.
A procedure, which the project's files also call a workflow, is a numbered set of steps with a checklist.
`how-to/src/TEMPLATE-GUIDE/syntek-author/13-a-guide-to-skills.md` says which skill does which job.

## The writing loop in one paragraph

The work is written one small section at a time, typically 300 to 500 words.
Claude drafts a section from the plan, or you write it yourself.
Claude then revises it from your notes, or proposes changes to your own draft, each with a reason.
You accept or reject every change, and nothing is applied that you have not seen.
On your word, the section is promoted: it moves into its chapter or document, and its history is recorded.
Claude then learns your voice from what you changed and rejected, and proposes notes about it for you to approve.
`how-to/src/TEMPLATE-GUIDE/syntek-author/07-the-writing-loop.md` follows a section through each step.

## What the template never does

- It never decides for you: Claude drafts, proposes and checks, and you decide what the work says.
- It never invents a quotation, a source, a page number, a figure or a date.
- Where one is missing, it leaves a visible gap and a flag in the text for you to fill.
- It never sends anything: a letter, a document or a query is drafted for you to send yourself.
- It never rewrites its own rules unless you ask for that change.
- It never lets a session compact on its own, which is the AI summarising its own conversation to make room, because a summary loses the reasons behind decisions.
- When a session grows long, Claude writes a handoff, a short note of where the work stands, and stops, and the next session starts afresh from it.

## How this guide is laid out

The guide is the `how-to/` folder, and it holds three kinds of file.

- Chapters, like this one, explain how the project works, in plain English.
- Guides, in `how-to/docs/syntek-author/`, explain one practice each, such as updating, and name the procedure that carries it out.
- Procedures, in `how-to/workflows/syntek-author/`, give the steps and every command, for you or a session to follow.

This template's chapters are in `how-to/src/TEMPLATE-GUIDE/syntek-author/`.
The shared chapters, which every template of the same family carries, sit one folder up, in `how-to/src/TEMPLATE-GUIDE/`, and cover updating, the coding agents and the data root.
The reading order, by what you want to do, is in `how-to/src/TEMPLATE-GUIDE/syntek-author/CONTEXT.md`.
Every technical word is explained where it first appears, or in the glossary at the end of the chapters.
The guide is read-only: read it, and never edit it, because every update of the template puts its text back.
Only a template's update, its recovery and the commands an update's report prints change a file there.
To work differently from something it says, `how-to/src/TEMPLATE-GUIDE/syntek-author/09-customising.md` shows where your own way goes.

## Where the rules live

- `.claude/rules/syntek-author/01-layout-and-routing.md` Sections 1 and 2: the layers, and what each kind of layer is for.
- `.claude/rules/syntek-author/03-authorship.md` Sections 1 to 4: who decides what, the writing loop, section size and never inventing a source.
- `.claude/rules/syntek-author/07-session-boundaries.md`: handing off instead of compacting.
- `.claude/rules/syntek-author/06-global-rules.md` Section 3: the guide is read-only.

## Next

- Your first hour in the project → `how-to/src/TEMPLATE-GUIDE/syntek-author/03-quickstart.md`
- A word this guide uses that you do not know → `how-to/src/TEMPLATE-GUIDE/syntek-author/17-glossary.md`
- How a section is written, step by step → `how-to/src/TEMPLATE-GUIDE/syntek-author/07-the-writing-loop.md`
