# Adopting — after the template was added to an existing repository

Adoption brings the template into a repository that already held work.
There are two kinds, and each leaves you a few things to finish.
This chapter is for the time after the adoption: what it did, what to do now, and what the read-only guide means for files you already had; the glossary, `how-to/src/TEMPLATE-GUIDE/syntek-author/17-glossary.md`, explains any word you do not know.

## What each adoption did

Adoption is a Copier copy into the repository you already had, in one of two modes.
A moving adoption, `copier copy --overwrite`, let the template take over its own paths.
Before it, the adoption script moved your work into the template's layout, but only where a file had exactly one right place.
The script reported everything else for you to decide, and never overwrote or deleted a file.
An additive adoption, `copier copy --skip '*' --skip-tasks`, kept every file you had exactly as it was.
Nothing moved, and the template's files were added beside yours.
Either way, the seeds you already had, such as `.claude/CLAUDE.md`, `.claude/MEMORY.md` and `.claude/settings.json`, were never overwritten.
A kept `.claude/settings.json` gains only the hooks, permission rules and settings the template lists, each added once.
A kept `.mcp.json` gains only the two MCP servers, in the same way.
After a moving adoption the copy added them; after an additive one, the first update does.
The adoption commands answer `SEED_EXAMPLES=false`, so no invented example arrives beside real work.
They also keep your binary files in the repository, with `DATA_STORE=repo`, unless another template there already records a store.

## What to do now

First, fill in your project's settings, `.claude/rules/syntek-author/00-project.md`, which tells the template how your repository works.

- `## Paths` says where your repository keeps each thing the template names by its role.
- `## Memory headings` maps the template's headings to the ones your `.claude/MEMORY.md` uses.
- `## Workflow aliases` names a procedure of yours to run in place of one of the template's.
- `## Overrides` holds a rule you follow differently, and a redirect for each file of yours that shares a name with one of the template's.

Next, compare each seed you kept with the template's version, because your copy never receives the template's improvements.
The adoption report names what a kept `.claude/settings.json`, `.claude/CLAUDE.md`, `.claude/MEMORY.md` or `.gitignore` lacks.
Check your `.gitignore` for a line that reads `build/` or `build` without a slash in front.
Such a line hides every folder called build, the folder of the build skill in `.claude/skills/` included, so that skill would never be committed.
Change the line to `/build/`, which hides only the folder at the top of the project.

After an additive adoption, the copy skipped the template's set-up steps, so make the session hooks runnable yourself:

```bash
chmod +x .claude/hooks/*.sh
```

The command prints nothing when it works.
If you chose the references option, also run `make init`, which builds the citation database.
Where one of your procedures shares a number with one of the template's, cite each by its full folder name from now on.
The first update after an additive adoption takes longer once, because it builds the record that later update reports compare against.

In a repository adopted additively, a file you kept at one of the template's paths counts as a template file to Copier.
Turning an option off, or leaving a document family out, deletes such a file with the option, so copy it out first.
When the template later changes such a file, an update brings it back with conflict markers, and you keep your own version.
The one exception is a file in `how-to/`, which the update puts back to the template's text, as the next section explains.

Last, commit everything, the answers file `.copier-answers.syntek-author.yml` included.
From then on, the project takes the template's changes through updates, as `how-to/workflows/syntek-author/01-update-the-template/` sets out.
To move your binary files out of Git later, follow `how-to/workflows/syntek-author/04-set-up-the-data-root/`.

## Your own files under how-to/

`how-to/` is the user guide the templates ship, and it is read-only: read it, and never edit it.
Only a template's update, its recovery and the commands its report prints change a file there.
Every update puts the guide's files back as the template wrote them, and no session may edit them.
That changes what happens to files you had there before the adoption.

- A file you had at one of the guide's shared paths, such as `how-to/CONTEXT.md`, was kept by the copy, in either mode.
- The first update then puts the template's text there and lists it under `RESTORED` in its report, and your text stays in Git.
- A file you had at one of this template's own paths, in a folder named `syntek-author`, was replaced by a moving adoption and kept by an additive one.
- After an additive adoption, the first update brings conflict markers into it, then puts the template's text back.
- The report's `then:` line gives the `git add` that settles that conflict.
- Your other files under `how-to/` belong to no template, so no update touches them, but no session can edit them either.

Move those files out of `how-to/`, each to where it belongs.
A guide of your own goes in a layer's `docs/project/`, and a procedure of your own in its `workflows/local/`.
The adoption script names each of these files when you run it.

`how-to` must also be a real folder, never a file or a link.
This command shows what stands there:

```bash
ls -ld how-to
```

Its line should start with `d`, for a folder.
An update stops on a file there or on a link that leads outside the project, and writes through any other link, so rename either before you update, as `how-to/src/TEMPLATE-GUIDE/syntek-author/12-troubleshooting.md` explains.

## Running adoption again

The adoption scripts and the copy commands live with the template's source, never in your project.
The `_src_path` line of `.copier-answers.syntek-author.yml` names that source, and its README gives every command.
A project that is already adopted never needs another adoption: it takes the template's changes through updates.
To read the adoption report again, or to adopt another repository, run the scripts from a clone of the source.
A second run of the moving script moves nothing it has already moved.
Preview and copy from the same source and version, or the preview's list is not exact.

## Where the rules live

- `.claude/rules/syntek-author/01-layout-and-routing.md` Section 9 covers your project's settings, redirects and additive adoption.
- `.claude/rules/syntek-author/00-project.md` holds the headings you fill in after an adoption.
- `.claude/rules/syntek-author/06-global-rules.md` Section 3 makes the guide in `how-to/` read-only.
- `how-to/workflows/syntek-author/01-update-the-template/` gives every step of the first update and every one after it.

## Next

- Your settings, overrides and aliases in full → `how-to/src/TEMPLATE-GUIDE/syntek-author/09-customising.md`
- What the first update does to each kind of file → `how-to/src/TEMPLATE-GUIDE/updating-and-recovery.md`
- When something goes wrong → `how-to/src/TEMPLATE-GUIDE/syntek-author/12-troubleshooting.md`
