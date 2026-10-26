# What gets generated — the kinds of file, and what an update does to each

Every file Copier wrote into your project belongs to one kind, and its kind decides what a later update does to it.
Knowing a file's kind is the whole of updating safely.
This chapter names the kinds, then says what a copy and an update each do; the glossary, `how-to/src/TEMPLATE-GUIDE/syntek-author/17-glossary.md`, explains any word you do not know.

## Five kinds of file, and the guide

**Template files** belong to the template, and every update brings the template's changes to them.

- They are the rules in `.claude/rules/syntek-author/` (all but `00-project.md`), the skills and their mode files, the reference guides, the numbered workflows, the standards, `tooling/` and the `Makefile`.
- They also include most folders' `CONTEXT.md` and `CLAUDE.md`, the bridge `.claude/syntek-author-agents.md` and the data-root tool `.claude/syntek-author-dataroot.py`.
- An update merges the template's changes with any edits of yours.
- Where you and the template changed the same lines, the update leaves both versions in the file, as a conflict for you to resolve.
- So never edit one: `how-to/src/TEMPLATE-GUIDE/syntek-author/09-customising.md` shows where your own way goes instead.

**Seeds** are written once, from your answers, and are yours from then on.

- They include your two settings files, `.claude/rules/syntek-author/00-project.md` and `tooling/project.mk`.
- They also include `README.md`, `CONTEXT.md`, `.gitignore`, `.mcp.json`, `.claude/CLAUDE.md`, `.claude/MEMORY.md` and `.claude/settings.json`.
- The style sheet, voice notes and terminology in `standards/style/`, the outline in `planning/src/`, and your variant's registers and trackers are seeds too.
- An update never overwrites a seed that exists.
- If you delete one, the next update puts back a fresh, empty copy, because the skills read it by its path.
- An update does add to two seeds, once each and never again.
- It adds the hook entries and permission rules the template lists to `.claude/settings.json`, and the two MCP servers to `.mcp.json`.
- The cost of a seed is that it never receives the template's later improvements.
- A release that must change one ships a migration, a small script that edits your copy only where exactly one change is right, and lists the rest for you.

**Examples** are the worked example: a sample chapter or document, with its plan and its ledger entries.

- They arrive with the first copy, unless you answered `SEED_EXAMPLES` off.
- An update never writes them again: delete them when you are done, and they stay deleted.

**Your folders** are folders the template only signposts.

- The template ships each one's `CONTEXT.md` and `CLAUDE.md`, and nothing else.
- They include each layer's `docs/project/` and `workflows/local/`, the unit briefs in `planning/src/units/`, `handoffs/`, `learning/` and `assets/`, and most folders where your sources, evidence and notes go.
- Nothing you put in one is ever touched.
- The manifests the data-root tool writes, `external.toml` in each filing folder, are yours too.

**Copy-only and shared files** are written by a copy and left alone by an update, with one difference between the two.

- The coding agents' own files, such as `AGENTS.md`, `GEMINI.md` and `opencode.json`, are copy-only: an update never writes, adds or recreates one.
- The one exception is the two MCP servers, which an update adds once to each such file that lacks them.
- Shared files are the ones every template of the family ships byte for byte.
- They include the working-practice skills such as `handoff` and `grill-me`, the hooks in `.claude/hooks/`, the `handoffs/` pair and the guide's shared files.
- Outside the guide, an update replaces a shared file you have not changed, and adds one that is new in that release.
- It keeps a shared file you have edited, and names it in its report.

**The guide**, `how-to/`, is read-only, and every update puts it back.

- Every update puts the template's text back on any file of the guide that differs, your edits and deletions included, and lists each one in its report.
- What you had stays in Git, and the report gives the command that shows it.
- It never touches a file there that no template ships.
- Read it, and never edit it: only a template's update, its recovery and the commands an update's report prints change a file there.

Your prose is never a template file, whichever folder it sits in.
Drafts, promoted sections and ledger entries are yours, in every kind above.

## What a copy does

A copy is the first run of Copier, which makes the project.
It renders the template with your answers, which means it writes every file, filling in your answers where the template asks for them.
It then runs a few small tasks: it starts a Git repository where none exists, makes the hooks runnable, and builds the citation database where the project has one.
That is why the command carries `--trust`: Copier runs no task without your permission.
A copy over a project that already has a `.claude/settings.json` adds the template's settings entries to it, once each, as an update does.
A copy never commits, so your first commit is yours.
When it ends, Copier prints where this guide starts, and, if the project keeps its binary files outside the repository, the steps that set up a machine for them.

## What an update does

An update brings the template's newer version into your project, and treats each kind of file as the section above describes.
This is the command, with the five settings in front that turn Git's background housekeeping off for the run:

```bash
GIT_CONFIG_COUNT=2 GIT_CONFIG_KEY_0=gc.auto GIT_CONFIG_VALUE_0=0 GIT_CONFIG_KEY_1=maintenance.auto GIT_CONFIG_VALUE_1=false \
  uvx --python '>=3.14' copier update --trust -a .copier-answers.syntek-author.yml
```

`-a` names the answers file, which Copier finds only when you name it.
`--trust` lets the template run its own steps after the update, such as the report.
Before you run it, read `how-to/workflows/syntek-author/01-update-the-template/`, which gives every step, from committing your work to reading the report.
After writing the new version, the update runs any migration the release needs, then prints its report.
The report lists each file the template changed that the update did not simply deliver, and why, with commands to compare it or take the template's version.
`how-to/src/TEMPLATE-GUIDE/updating-and-recovery.md` explains the report, section by section, and what to do when an update stops part way.

## What an update never touches

- Your prose, wherever it is.
- Anything you put in a folder the template only signposts.
- A seed that exists, apart from the settings entries and servers it adds once each.
- A copy-only file, apart from the servers it adds once.
- A file that belongs to no template, your own files under `how-to/` included, though no session may edit them there.
- A file Git ignores, which an update never reads.

The one exception that deletes your work is turning an option off, which `how-to/src/TEMPLATE-GUIDE/syntek-author/04-the-answers.md` explains.

## Where the rules live

- `.claude/rules/syntek-author/01-layout-and-routing.md` Section 7: who owns which files, and the full list of seeds for this project.
- `.claude/rules/syntek-author/06-global-rules.md` Section 3: the guide is read-only.
- `.claude/rules/syntek-author/06-global-rules.md` Section 11: answers change through Copier.
- `how-to/docs/syntek-author/updating-the-template.md`: what an update changes, and how this project runs one.
- `how-to/workflows/syntek-author/01-update-the-template/`: the update, with every command.

## Next

- Updating, reading the report, and getting back from an update that stopped → `how-to/src/TEMPLATE-GUIDE/updating-and-recovery.md`
- A tour of the folders you received → `how-to/src/TEMPLATE-GUIDE/syntek-author/06-a-tour-of-the-project.md`
- Making the project your own without conflicts → `how-to/src/TEMPLATE-GUIDE/syntek-author/09-customising.md`
