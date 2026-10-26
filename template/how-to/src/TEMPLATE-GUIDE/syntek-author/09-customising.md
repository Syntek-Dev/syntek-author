# Customising — making the project work your way without breaking updates

The project is yours to shape, but some of its files belong to the template, and every update merges the template's changes into an edit you make to one of those, leaving a conflict where you both changed the same lines.
This chapter shows which files are yours, which are the template's, and where your own way of working goes so that every update keeps it.
A word you do not know is explained in the glossary, `how-to/src/TEMPLATE-GUIDE/syntek-author/17-glossary.md`.

## What is yours

Everything you write is yours, and no update ever touches it.

- Your prose, plans, research and notes, in each layer's `src/` folder, are yours; only `how-to/src/`, this guide, is not.
- The seeds are yours: your settings files, the project brief, the memory, the style sheet, the voice notes, the terminology list, `.claude/settings.json`, `README.md` and `CONTEXT.md`.
- Your folders are yours: each layer's `docs/project/` and `workflows/local/`, and `handoffs/`, `learning/` and `assets/`.

Edit these freely, or ask Claude to.
A seed you delete comes back empty at the next update, because the skills read it by its path.

## What is the template's

The template's files include the rules in `.claude/rules/syntek-author/` other than `00-project.md`, and the skills with their mode files.
They also include the reference guides, the numbered workflows, most of the standards, `tooling/` other than `tooling/project.mk`, and the `Makefile`.
This template's folders in the guide are the template's too.
Never edit one of them.
Every update merges the template's changes with your edit, and where you both changed the same lines it leaves a conflict, with both versions in the file for you to sort out.
In the guide, an update puts the template's text back instead.
Change how the project behaves instead, through one of the routes below, and the template's file stays as it shipped.
If a rule looks wrong to you, ask Claude to report it with a proposed wording.
Claude keeps working under the rule as written until you decide, and never rewrites a rule, a skill or a standard without your instruction for that change.

## Your own guides and procedures

Each production layer has two folders for your own way of working.

- A guide you write in a layer's `docs/project/`, with the same name as a guide in its `docs/reference/`, is read instead of the template's.
- A procedure you write in a layer's `workflows/local/`, with the same folder name as one of the template's workflows, replaces it.
- A new guide or procedure of your own needs no matching name; give your procedures their own numbering.

Add a row for each one to the `CONTEXT.md` and `CLAUDE.md` of its folder, which are seeds and yours to edit.
Ask Claude to write one with you, such as 'write a procedure for how I review a chapter'.

## Settings, aliases, overrides and redirects

`.claude/rules/syntek-author/00-project.md` is where a project departs from the template, and it outranks the template's rules.
Each heading takes one kind of change.

- `## Paths`: if you keep handoffs in another folder, change the path in its row and leave the role's name as it is, because template files cite the role.
- `## Workflow aliases`: a row names a template workflow by its full folder, such as `planning/workflows/01-plan-a-unit/`, and the procedure of yours to run instead.
- `## Overrides`: a dated bullet, led in bold, names the template rule you do not follow, what you do instead, and why.
- A common override is asking Claude to put questions one at a time instead of in rounds.
- `## Memory headings`: if your `.claude/MEMORY.md` uses headings of its own, this table says which of yours each of the template's headings means.

An override changes what Claude does, never a file: the template's file stays as shipped.
A redirect is a special override, one line under `## Overrides`, for a template path with no role in `## Paths`.
Such a path might be the style sheet, a guide or a drafts folder.
It sends every template file that names that path to your own file or folder instead, for reading and writing alike.
For example, a project that keeps its own house style in a notes folder writes this line:

```text
- `standards/style/style-sheet.md` → `notes/house-style.md`
```

A redirect never points into a folder Git ignores.
The build reads fixed paths and ignores redirects, so redirect a drafts folder only to another folder named `drafts`, or outside the content layer.
Build settings, such as fonts and extra open-item marks, are not overrides: they go in `tooling/project.mk`.
Ask Claude to add any of these for you, and check what it wrote.

## The guide is read-only

`how-to/` explains the template version this project runs, so it stays exactly as the template wrote it.
Claude Code is denied edits under `how-to/`, and a hook refuses them, even when you ask.
Every update puts the template's text back on any file of the guide that differs, a deleted file included, and lists each one in its report.
What you had stays in Git, and the report gives the command that shows it.
The only changes to files there come through an update, its recovery, and the commands an update's report prints.
To work differently from a chapter, a guide or a procedure in the guide, add an override, a redirect included, under `## Overrides`.
To replace one of the guide's procedures, add a row under `## Workflow aliases`.
Keep your own notes in a layer's `docs/project/` or `workflows/local/`, or in `learning/`, never in `how-to/`.
There is no switch to remove the guide yet.

## Project rules

A rule of your own that replaces nothing in the template is a project rule.
It goes in `.claude/CLAUDE.md`, under 'Project-specific rules', as a dated bullet, led in bold, with its reason.
It applies on top of the template's rules, and wins where the two conflict.
Only `00-project.md` outranks it, so a change to a setting, a path or one of the template's rules goes there instead.
When two rules conflict, Claude follows the higher one and tells you where both are, so the conflict is settled once.
The order, highest first, is `00-project.md`, then your project rules, then the template's rules, then a folder's `CLAUDE.md`, then a skill, then its mode file.
Never refer to a numbered section of `.claude/CLAUDE.md` from another file: its numbering is yours to change.

## Where the rules live

- `.claude/rules/syntek-author/01-layout-and-routing.md` Section 3: guides and procedures of your own beside the template's.
- `.claude/rules/syntek-author/01-layout-and-routing.md` Section 7: who owns which files.
- `.claude/rules/syntek-author/01-layout-and-routing.md` Section 9: your settings, which rule wins, and redirects.
- `.claude/rules/syntek-author/00-project.md`: what each heading takes, and the examples there.
- `.claude/rules/syntek-author/06-global-rules.md` Section 3: never self-edit, and the read-only guide.

## Next

- Sharing the project with a companion template → `how-to/src/TEMPLATE-GUIDE/syntek-author/10-a-second-template.md`
- After the template was added to an existing repository → `how-to/src/TEMPLATE-GUIDE/syntek-author/11-adopting.md`
- When something goes wrong → `how-to/src/TEMPLATE-GUIDE/syntek-author/12-troubleshooting.md`
