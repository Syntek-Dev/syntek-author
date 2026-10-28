# A tour of the project — the layers, the folder pair and your two settings files

This chapter walks round the project's folders, the two files that every folder carries, and the two files that hold your project's settings.
`CONTEXT.md` at the top of the project is the map; this chapter explains what the map shows.
A word you do not know is explained in the glossary, `how-to/src/TEMPLATE-GUIDE/syntek-author/17-glossary.md`.

## The layers

The top-level folders of the project are its layers, and each kind of layer has a different job.

- **Production layers** are where the work is made, through steps you repeat for each chapter or document.
- `planning/` holds the outline, one brief for each unit (a chapter or a document), decision maps and reviews.
- `research/` holds your sources, the evidence you have checked and your research notes.
- The content layer holds the prose itself, one folder for each unit, and `.claude/rules/syntek-author/01-layout-and-routing.md` Section 4 names it for this project.
- Your variant and options may add more production layers, such as the printed book's typesetting, a book proposal, or a novel's story bible.
- **Supporting layers** are consulted rather than worked in: `standards/` holds the rules the prose answers to, such as style, method and checking, and `tooling/` holds the build.
- **Working folders** sit outside every build: `handoffs/` for notes between sessions, `learning/` for practice, and `assets/` for images and other binary files.
- **`.claude/`** is Claude Code's folder: the project brief, the rules, the memory, the settings, the hooks and the skills.
- **`build/`** appears the first time you build anything, holds every proof, and is never edited by hand.
- **`how-to/`** is this guide.

## Inside a layer

Every production layer splits into the same parts, so once you know one you know them all.

- `docs/reference/` holds the guides the template ships, which explain how this kind of work is done; every update replaces them.
- `docs/project/` holds your own guides; one with the same name as a reference guide is read instead of it.
- `src/` holds the work itself: the prose, the plans or the evidence.
- Numbered workflows, such as `planning/workflows/01-plan-a-unit/`, are the template's procedures, each with its steps and a checklist.
- `workflows/local/` holds your own procedures; one with the same name after the number as a template workflow replaces it, whatever its number.

Workflow numbers never change, and a number is never reused, because other files cite them.
So a workflow is always named by its full folder name, never by its number alone.
In a `src/` folder, the text is written one sentence per line, which builds exactly the same and makes each change easy to see.
Work in progress lives in `drafts/` folders, which no build ever includes.

## Every folder has two files

Every folder carries a `CONTEXT.md` and a `CLAUDE.md`, which this guide calls the folder pair.

- `CONTEXT.md` says what is in the folder and why, with a tree of its contents; it is orientation.
- `CLAUDE.md` says how to work there: what to read first, which skill and model to use, what done looks like, and what never to do.

Before Claude works in a folder, it reads in a fixed order.
First come `.claude/CLAUDE.md`, the project brief, and `.claude/MEMORY.md`, the project's memory.
Then come the pair of each folder above the target, from the top down, then the target folder's own pair.
Last comes the routing frontmatter of the file it is about to open.
That is a short block at the top of a guide or a procedure, naming the skill and the AI model the work needs.
You can read the pairs too, and they are the quickest way to learn what a folder is for.
A few folders have no pair: `build/`, `.claude/rules/`, the inside of each skill's folder, and each `drafts/` folder, which holds only a `README.md`.
The top of the project has no `CLAUDE.md` of its own: its operating file is `.claude/CLAUDE.md`.

## Your two settings files

Two files hold everything particular to this project, and both are yours: written once from your answers, and never overwritten by an update.

`.claude/rules/syntek-author/00-project.md` sits with the template's rules, loads at the start of every session, and outranks every other rule in that folder.
The template's rules and skills read this project's values from it, by heading.

- `## Brief` holds your audience, your reader test and your variant's answers.
- `## Paths` says where the project keeps each thing the template names by its role, such as handoffs or research notes.
- `## Memory headings` says which heading of `.claude/MEMORY.md` the template means by each of its own.
- `## Workflow aliases` names a procedure of yours to run instead of one of the template's.
- `## Overrides` records a template rule this project does differently, and any redirect of a template path to your own.

`tooling/project.mk` holds the build settings that the `Makefile` reads first.
It names the project's extra open-item marks for `make flags` to count, in `FLAG_EXTRA_RE`.
It also sets the fonts of a PDF made from Markdown and the folders where a build looks for logos first, with a few more settings in business.
A setting that differs from one project to the next goes there, never in the `Makefile`.
When an answer changes later, change these two files by hand: Copier never rewrites them.
The project brief itself, with the title and the near-term goal, is in `.claude/CLAUDE.md`, and your own rules for the project go there under 'Project-specific rules'.

## Binary files

Scans, signed copies, images and audio are binary files, which Git keeps badly, because every version stays in the repository for good.
A project can keep them outside the repository instead, under a folder on each machine called the data root.
`make root` tells you which way this project keeps them, and checks this machine.
`how-to/src/TEMPLATE-GUIDE/the-data-root.md` explains the data root, and `how-to/workflows/syntek-author/04-set-up-the-data-root/` gives the steps that set one up.

## The guide itself

`how-to/` is the user guide, and it is read-only.
This template's chapters, guides and procedures sit in folders named `syntek-author` under `how-to/src/TEMPLATE-GUIDE/`, `how-to/docs/` and `how-to/workflows/`.
The shared chapters sit beside them, and a companion template's files sit in folders named for that template.
Read it, and never edit it: Claude Code is denied edits under `how-to/`, a hook refuses them, and every update puts the guide's text back.
Only a template's update, its recovery and the commands an update's report prints change a file there.
To work differently from the guide, record it in `.claude/rules/syntek-author/00-project.md`, under `## Overrides` or `## Workflow aliases`.
Keep your own notes and procedures in a layer's `docs/project/` or `workflows/local/`, never in `how-to/`.

## Where the rules live

- `.claude/rules/syntek-author/01-layout-and-routing.md` Sections 1 to 5: the layers, the parts of a layer, the content layer and the folder pair.
- `.claude/rules/syntek-author/01-layout-and-routing.md` Sections 8 and 9: the read order, the settings file and which rule wins.
- `.claude/rules/syntek-author/04-build-pipeline.md` Section 5: the build settings in `tooling/project.mk`.
- `.claude/rules/syntek-author/09-data-root.md`: keeping binary files outside the repository.
- `.claude/rules/syntek-author/06-global-rules.md` Section 3: the guide is read-only.

## Next

- Writing your first section → `how-to/src/TEMPLATE-GUIDE/syntek-author/07-the-writing-loop.md`
- Your own guides, procedures and settings → `how-to/src/TEMPLATE-GUIDE/syntek-author/09-customising.md`
- Keeping binary files outside the repository → `how-to/src/TEMPLATE-GUIDE/the-data-root.md`
