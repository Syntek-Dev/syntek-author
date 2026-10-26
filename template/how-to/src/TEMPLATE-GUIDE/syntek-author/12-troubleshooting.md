# Troubleshooting — grouped by when it breaks

Find the moment it went wrong, then the symptom.
Each entry says what is happening and what to do, and names the chapter or procedure that owns the fix.
A word you do not know is in `how-to/src/TEMPLATE-GUIDE/syntek-author/17-glossary.md`.

## When generating

**Copier warns `MissingFileWarning` about an answers file.**
This is expected, and harmless.
The template looks for your earlier answers, and for another syntek template's, and on a first copy there are none.

**Copier says the template requires a newer version of Copier.**
This template needs Copier 9.12.0 or later, and `uvx` keeps using the Copier it fetched the first time.
This command fetches the newest Copier and prints its version, and every later Copier command in this guide uses it:

```bash
uvx --python '>=3.14' copier@latest --version
```

Where you installed Copier with `uv tool install` on Python 3.14 or later, `uvx` runs that copy instead, and `uv tool upgrade copier` brings it up to date; a copy installed on an older Python is passed over.
The same refusal can stop an update, and the same command settles it.

**`--defaults` stops with an error about `DOC_TYPE`.**
`DOC_TYPE` has no default on purpose, so a script must pass it with `--data`.
The README at the template's source, which the `_src_path` line of `.copier-answers.syntek-author.yml` names, shows the full command.

**Every later update fails with 'Updating is only supported in git-tracked templates'.**
The project was generated from a relative path to a local copy of the template.
Generate real projects from the published source, or from an absolute path, as the source's README explains.

**A copy prints a message framed in lines of `=` that says `family-update did NOT run`.**
`uvx` ran Copier on a Python older than 3.14 that it already had, because the command did not ask for a newer one.
Every file was written, but the copy recorded nothing for the first update's report, and added nothing to a settings file you already had.
Run every update with `uvx --python '>=3.14'`, as this guide gives it; the first one renders this version again to build its report.
Upgrade the Python your terminal runs to 3.14 or later as well, because the project's own scripts and hooks need it too.

**A step after the copy failed, such as building the citation database.**
The project is still complete.
Install the missing tool, such as `sqlite3` or `make`, and run the step later: `make init` builds the database.

**Copier fails at once, before it asks anything.**
Look at your Copier settings file, if you keep one.
An empty one crashes some versions of Copier, so give it the line `defaults: {}` at least.
A default there that is not one of a question's choices fails every copy, even where that question is never asked.
`how-to/src/TEMPLATE-GUIDE/syntek-author/04-the-answers.md` says which questions never belong there.

## In the first session

**A shared skill behaves differently from the guide, or ignores an update.**
A skill of your own in `~/.claude/skills/` with the same name replaces the project's in Claude Code.
Rename or remove your own to use the project's, as `how-to/src/TEMPLATE-GUIDE/agent-clients-and-mcp.md` explains.

**The session hooks never fire.**
Each hook runs only from its entry in `.claude/settings.json`.
After an additive adoption that kept your own copy of that file, the entries arrive with the first update, which `how-to/workflows/syntek-author/01-update-the-template/` runs.
A hook also runs only where the project is its own repository.
This command prints the top folder of the repository, which should be this project's own folder:

```bash
git rev-parse --show-toplevel
```

**Codex or Gemini CLI ignores the project's settings.**
Both read a project's settings only once you trust it, so trust the project when they ask.

**An MCP server times out the first time it starts.**
The first start downloads the server, which can take longer than a client waits.
`.claude/syntek-author-agents.md` gives the commands that download it ahead of time, for you to run in your own terminal.

**The session warns about its context, or refuses to compact.**
That is by design: the project hands off rather than letting a session summarise itself.
When Claude Code tries to compact a session on its own, a hook stops it, and your next message in that session shows 'Automatic compaction was stopped'.
The note asks you to type `/handoff`, so that Claude writes a handoff to `handoffs/`, then `/clear` to continue from the handoff in a fresh session.
If the session is too full to write a handoff, Claude says so: type `/compact` yourself, which the project allows, then `/handoff`, as the note's last sentence says.
Claude Code can also compact a long session you leave idle, and the project turns that off too, with `"idleCompaction": false` in `.claude/settings.json`.
An update adds that line to an older project's file where it is missing, and keeps a value you set yourself, saying so once.

**A note says the session was compacted by hand.**
You typed `/compact`, and the project lets you: the session goes on from a summary of itself.
A handoff gives a cleaner break, so next time type `/handoff`, then `/clear`.
If you compacted to make room for a handoff, Claude offers to write it now.

**A hook error notice names UserPromptSubmit or PreCompact.**
The entries that run the handoff hooks in `.claude/settings.json` came from an earlier release, in a form that fails when a script is missing or the project is not its own repository.
Nothing is blocked: your message goes ahead, and so does any compaction, because the hook did not run.
New projects get entries that stay silent in that case, but an update never rewrites an entry you already have, so yours keep the older form.
This command shows whether both scripts are there:

```bash
ls -l .claude/hooks/context-threshold-handoff.sh .claude/hooks/pre-compact-handoff.sh
```

A script you deleted by mistake is still in your earlier commits, so ask Claude to restore it.
If the project is not its own repository, the hooks run in neither form, so follow 'The session hooks never fire' above first.
To keep the notice away either way, switch the entries to the silent form by hand.
Open `.claude/settings.json` and find each line starting `"command":` that names one of the two scripts.
Replace each with the line below that ends the same way, keeping the spaces at its start:

```text
"command": "bash -c 'ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0; [ -f \"$ROOT/.claude/hooks/context-threshold-handoff.sh\" ] || exit 0; exec bash \"$ROOT/.claude/hooks/context-threshold-handoff.sh\"'",
"command": "bash -c 'ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0; [ -f \"$ROOT/.claude/hooks/pre-compact-handoff.sh\" ] || exit 0; exec bash \"$ROOT/.claude/hooks/pre-compact-handoff.sh\" auto'",
"command": "bash -c 'ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0; [ -f \"$ROOT/.claude/hooks/pre-compact-handoff.sh\" ] || exit 0; exec bash \"$ROOT/.claude/hooks/pre-compact-handoff.sh\" manual'",
"command": "bash -c 'ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0; [ -f \"$ROOT/.claude/hooks/pre-compact-handoff.sh\" ] || exit 0; exec bash \"$ROOT/.claude/hooks/pre-compact-handoff.sh\" compacted'",
```

Save the file, and the notice goes; if it is still there, start a new session.

**An edit under `how-to/` is refused.**
That is by design: the guide is read-only, and a hook refuses every edit there.
Only a template's update, its recovery and the commands its report prints change a file in `how-to/`.
To work differently from the guide, record the difference as `how-to/src/TEMPLATE-GUIDE/syntek-author/09-customising.md` explains.

**An edit under the data root is refused.**
That is also by design: no session edits a filed copy.
`how-to/src/TEMPLATE-GUIDE/the-data-root.md` explains why.

**A hook warns that it did NOT work because Python is older than 3.14.**
The hook let Claude's action through without checking it, or, for the context-window warning, measured nothing, and it warns again each time it runs until you upgrade.
Upgrade to Python 3.14 or later, as `how-to/src/TEMPLATE-GUIDE/syntek-author/02-prerequisites.md` says, then start a new session.

**A hook error says `python3: not found`.**
Python is not installed, or your terminal cannot find it.
The guard on the data root cannot start without it, so it fails with exit code 127 each time Claude edits or searches files, and lets the action through unchecked.
The two other hooks that need Python say nothing: the settings still keep the guide read-only, but nothing warns you as the context window fills.
Every `make` target that needs Python stops with a framed message that says `python3` was not found, and a script you run on its own does not start.
Install Python 3.14 or later, as `how-to/src/TEMPLATE-GUIDE/syntek-author/02-prerequisites.md` says, then start a new session.

## When building

**`make` reports a missing tool.**
`how-to/src/TEMPLATE-GUIDE/syntek-author/02-prerequisites.md` lists each tool and what it is for.
`make compare` also needs the TeX packages `xcolor`, `ulem`, `paracol` and `array`.

**`make lint` or `make flags` says nothing about the guide.**
That is by design: without a scope, neither reads `how-to/src/`, because the guide is not your work.
Naming the guide's folder checks it, as in `make lint SCOPE=how-to/src`.

**A check says it did not read some files that Git ignores.**
No check reads a file Git ignores, because ignored folders hold local material.
Move a file you want checked out of an ignored folder.

**A script or a `make` target stops with a framed message that says it did NOT run.**
It did nothing, because every script in the project needs Python 3.14 or later, and the message names the Python it found.
Upgrade to Python 3.14 or later, as `how-to/src/TEMPLATE-GUIDE/syntek-author/02-prerequisites.md` says, then run the command again.

**A script stops with a `SyntaxError` instead of a message about Python.**
Your `python3` is probably Python 3.6 or 3.7, so old that it cannot read the script far enough to reach its check of the version.
A `make` target still gives the framed message, because it checks the version before it starts a script, but a script you run on its own may not.
For the same reason, the guard on the data root may show a hook error in a session and let Claude's action through unchecked.
This command prints the version of your Python:

```bash
python3 --version
```

Install Python 3.14 or later, as `how-to/src/TEMPLATE-GUIDE/syntek-author/02-prerequisites.md` says, then run the command again.

**A data command stops with exit code 2.**
The data root is not set on this machine, or its marker file is missing.
Text work needs no data root, so drafting, proofs and checks still run.
Set it up with `how-to/workflows/syntek-author/04-set-up-the-data-root/`.

**The build skill is missing after a commit.**
A line `build/` without a slash in front, in your `.gitignore`, hides the skill's folder too.
Change the line to `/build/`, then commit the skill.

## When updating

**Copier refuses to start.**
Copier refuses to update a project with uncommitted changes, and finds a non-default answers file only when the command names it with `-a`.
Commit everything first, then run the command exactly as `how-to/workflows/syntek-author/01-update-the-template/` gives it.

**The update stopped with `OSError: [Errno 39] Directory not empty`.**
Copier had already written the new version, and nothing that runs after it had run.
Never commit that state: discard it and update again, with `how-to/workflows/syntek-author/02-recover-a-failed-update/`.

**The update stopped with `ForbiddenPathError` naming a path in `.agents`.**
`.agents` is a link that leads outside the project, and the message framed in lines of `=` above the error says `agents-outside-link did NOT run`.
Copier ran on a Python older than 3.14, so the link was not set aside for the update.
Never commit what it left: discard it with `how-to/workflows/syntek-author/02-recover-a-failed-update/`, which runs the update again with `uvx --python '>=3.14'`.

**Copier warns `MissingFileWarning` during an update.**
An update may print the same warning as a first copy, for the same reasons, and it is harmless there too.

**Copier says 'Make sure Git >= 2.24 is installed to improve updates.'**
This is expected with a recent Git, and harmless.
A recent Git refuses a value Copier tries first, so Copier tries another, and the update runs as usual.

**No update report appeared.**
Copier skipped every step after it wrote, as it does when it cannot read a template version.
Run `git status`, and look for conflict markers and `.rej` files yourself.
Where it printed instead a message framed in lines of `=` that says `family-update did NOT run`, `uvx` ran Copier on a Python older than 3.14 that it already had, so nothing was reported, refreshed or put back in `how-to/`.
Once you have checked for conflicts, commit the update, then run the same update again, starting `uvx --python '>=3.14' copier update`.
That second report says the template did not change, because the first run already moved the answers file to the new version.
Upgrade the Python your terminal runs to 3.14 or later as well, because the project's own scripts and hooks need it too.

**An update refuses a new `DOC_TYPE`.**
The kind of project never changes, because your writing lives in folders that only that kind of project has.
A different kind of project is a new project.

**Turning an option off deleted files you had filled in.**
They remain in your Git history, and the report's `restore` command brings back each one you had edited.
Next time, copy out what you need before the update, from the list the update prints before it asks its questions.

**A settings entry you removed came back.**
An update you have not committed counts as not made, so running it again offers everything again.
Remove the entry once more after you commit the update, and later updates leave it out.

**The report lists files under `RESTORED`.**
The guide is read-only, so the update put the template's text back on each file of it that differed.
What you had stays in Git, and the report gives the command that shows it.
To keep a different way of working, record it in your project's settings instead, as `how-to/src/TEMPLATE-GUIDE/syntek-author/09-customising.md` explains.

**The report lists a file under `LEFT AS IT IS`.**
The update could not safely put that guide file back, and the entry gives the reason.
Act on the reason: commit or move a file Git does not hold, make `how-to` a real folder, or wait for another template's update.
`how-to/src/TEMPLATE-GUIDE/updating-and-recovery.md` explains each reason.

**A shared file you deleted came back.**
Another template was applied after you deleted it, and a first copy writes every shared file that is missing.
Outside `how-to/`, delete it again and commit, if you still do not want it.
A file of the guide always comes back, because the guide is read-only.

## With two templates

**The data commands refuse because two answers disagree.**
Every template in a project must record the same data-root layout.
Make the answers agree through an update of the template that differs, as `how-to/src/TEMPLATE-GUIDE/the-data-root.md` explains.

**The report says a file holds the other template's version.**
That file waits for the other template's own update, which replaces it once that template ships a newer version.
Leave it as it is, because this template's version may be the older one.

**An update stopped while `.agents` was held aside.**
Put the link back before anything else, as `how-to/src/TEMPLATE-GUIDE/agent-clients-and-mcp.md` explains.
The steps are the same whichever template's update stopped.

**In a fresh clone, a shared guide file was left as it is.**
The records an update keeps travel only with `git push --mirror`, so a fresh clone has none.
Updating each template in that clone, to a release that writes update records, settles it, and so does working in a copy that holds the records.

## When how-to is not a folder

`how-to` must be a real folder for every copy and update.
This command shows what stands there:

```bash
ls -ld how-to
```

A line starting with `d` is a folder, which is right.
A line starting with `l` is a link, and one starting with `-` is a file.
An update over a file stops with `FileExistsError: [Errno 17]` or `NotADirectoryError` naming `how-to`, after Copier has already written part of the new version.
Never commit what it left.
Discard it, give the file another name, commit, and update again, with `how-to/workflows/syntek-author/02-recover-a-failed-update/`.
A link that leads outside the project also stops an update part way, with `ForbiddenPathError` naming a path in `how-to`, and the same procedure recovers from it.
A link inside the project makes Copier write the guide through it, into the folder it points at, so rename it before you update.
On a disk that ignores letter case, a folder such as `How-To` receives the guide too, so rename it as well.

## Still stuck

The `_src_path` line of `.copier-answers.syntek-author.yml` names the template's source, where its README and its issue tracker live.
A bug report says which template version you run, from the `_commit` line of the same file, and your `DOC_TYPE`.
It also gives the Copier and Git versions, which these commands print:

```bash
uvx --python '>=3.14' copier --version
```

```bash
git --version
```

Add the command you ran and its full output, and never any personal data.
Report a security problem privately, through the source's private vulnerability reporting, never in a public issue.

## Where the rules live

- `.claude/rules/syntek-author/06-global-rules.md` Section 3 makes the guide read-only, and Section 11 says how answers change through Copier.
- `.claude/rules/syntek-author/07-session-boundaries.md` says why a session hands off instead of compacting.
- `.claude/rules/syntek-author/09-data-root.md` holds the rules for the data root and its commands.
- `.claude/rules/syntek-author/04-build-pipeline.md` says what each `make` target needs and reads.
- `how-to/workflows/syntek-author/02-recover-a-failed-update/` gives every step for an update that stopped.

## Next

- What an update does, and its report section by section → `how-to/src/TEMPLATE-GUIDE/updating-and-recovery.md`
- The tools to install → `how-to/src/TEMPLATE-GUIDE/syntek-author/02-prerequisites.md`
- Two templates in one project → `how-to/src/TEMPLATE-GUIDE/syntek-author/10-a-second-template.md`
