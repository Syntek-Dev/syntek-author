# A second template — sharing the project with a companion

Your project can carry a second template from the same family beside this one, such as syntek-media.
Each template keeps its own files, the two share some files byte for byte, and each is updated on its own.
This chapter explains what changes when a companion arrives, and how to keep both in step; the glossary, `how-to/src/TEMPLATE-GUIDE/syntek-author/17-glossary.md`, explains any word you do not know.

## What a companion adds

A companion is applied to your project with its own copy command, from its own source, as its own README says.
Apply it from a clean, committed tree, and commit straight afterwards.
It records its answers in its own answers file at the top of the project, named `.copier-answers.<template>.yml` after it.
This template's answers stay in `.copier-answers.syntek-author.yml`, which the companion never touches.
The companion keeps its rules in its own folder under `.claude/rules/`, beside `.claude/rules/syntek-author/`.
It ships its own bridge for the other coding agents, `.claude/<template>-agents.md`, beside `.claude/syntek-author-agents.md`.
It brings its own skills, workflows and layers, and none of their names collide with this template's.
It ships its own copies of the permissions script and the data-root tool, which hold the same bytes as this template's.
Its user guide sits beside this one, in folders named for it under `how-to/docs/`, `how-to/src/TEMPLATE-GUIDE/` and `how-to/workflows/`.
No template ever updates `.claude/CLAUDE.md`, which stays yours.
The seeds, the files written once for you to fill in, are written by whichever template is applied first, and never overwritten by either; a seed you delete comes back as a fresh copy.

## The shared files

Some files are the same in every template of the family, byte for byte, so the project holds one copy of each.
They are the agent entrypoints and the other clients' settings files, the working-practice skills, the session hooks, the manual of `handoffs/` and the shared files of the guide.
Whichever template is applied first writes them.
After that, each template's update refreshes a shared file only while you have not changed it.
A shared file holding the other template's version waits for that template's own update, and is never put back to an older version while it stands unchanged.
Each template keeps its own mode files beside a shared skill, under names that never collide.
A mode file applies only to the work of the template that ships it.
This template's first copy takes the `AGENT_CLIENTS` answer and model answers a companion has recorded as its defaults, so it records the same coding agents and writes no client file the companion left out.
A companion does the same with this template's answers only from a release that shares these questions with this template, and an older one does not read them.
So when a companion comes second, check the clients and models its copy offers against those `.copier-answers.syntek-author.yml` records, and give it the same answers.
When you change the answer later, give both templates the same one.
The two MCP servers are added to an existing project once, by whichever template's update runs first.
Before they write, both templates' updates set aside an `.agents` link that leads outside the project, under the one name `.agents.syntek-held`.
So the hand fix after a stopped update is the same whichever template stopped, as `how-to/src/TEMPLATE-GUIDE/agent-clients-and-mcp.md` explains.

## Updating both

Update one template at a time, and commit between them.
Copier refuses to update a project with uncommitted changes, so each update starts from a clean, committed tree.
This command updates this template, with Git's background housekeeping turned off for the run:

```bash
GIT_CONFIG_COUNT=2 GIT_CONFIG_KEY_0=gc.auto GIT_CONFIG_VALUE_0=0 GIT_CONFIG_KEY_1=maintenance.auto GIT_CONFIG_VALUE_1=false \
  uvx --python '>=3.14' copier update --trust -a .copier-answers.syntek-author.yml
```

It ends with a report of every file it did not simply deliver, which you read before you commit.
If it stops with an error instead, commit nothing and follow `how-to/workflows/syntek-author/02-recover-a-failed-update/`.
Then commit everything, the answers file included:

```bash
git add -A && git commit -m 'Update from syntek-author'
```

Then update the companion with its own command, which its own procedure for updating gives, in its folder under `how-to/workflows/`.
Commit again once its update is done.
Never run one template's command against the other's answers file, and never follow one template's steps to update the other.
Every step for this template, the report included, is in `how-to/workflows/syntek-author/01-update-the-template/`.

## One data-root layout

The data root is the folder outside the repository where a project keeps its binary files, such as scans and issued copies.
A project keeps one layout under it, however many templates it carries.
Every template records the same answers for the store, the area, the project's folder and the kind folders.
A companion's first answers default to this template's recorded ones, and must equal them.
A later difference is reported after the update, and both templates' data commands refuse until the answers agree again.
The provider answer also defaults to the other template's, but a difference there is only reported.
When you remove a template, remove its answers file too.
An answers file left behind still binds the first data-root answers of any template applied later.
`how-to/src/TEMPLATE-GUIDE/the-data-root.md` explains the layout, and why a project has only one.

## The guide with two templates

Each template's own guide files sit in folders named for it, and the shared chapters and folder manuals sit outside them.
Every update of a template puts back its own guide files and the shared ones wherever they differ, and never touches the other template's folders.
A shared guide file holding the other template's version waits for that template's update, and is never put back to an older version while it stands unchanged.
In a fresh clone, a shared guide file may be left as it is until each template has updated there once.
That is because the records an update keeps travel only with `git push --mirror`, never with an ordinary push or clone.
A shared file you deleted comes back when another template is applied later, because a first copy writes every shared file that is missing.
The guide is read-only in every template's folders alike: read it, and never edit it.
Only a template's update, its recovery and the commands its report prints change a file there.
To work differently from this template's guide, record the difference in `.claude/rules/syntek-author/00-project.md`, as `how-to/src/TEMPLATE-GUIDE/syntek-author/09-customising.md` explains.

## Which version you need

A project that carries a companion's guide needs syntek-author v0.6.0 or later.
Update this template to it before you take the companion's release that adds its guide.
An older syntek-author treats every `src/` folder as your work, so its checks would read the guide's chapters as if they were your text.
It also puts nothing back in `how-to/`, so a change made there would stand until a newer update.
A project that already runs this release or a later one needs nothing more.

## Where the rules live

- `.claude/rules/syntek-author/01-layout-and-routing.md` Section 7 says which files are this template's, which are shared and which are yours.
- `.claude/syntek-author-agents.md` tells the other coding agents to read every template's bridge and rules folder, and who decides where two templates' rules meet.
- `.claude/rules/syntek-author/09-data-root.md` holds the rules for the one data-root layout.
- `how-to/workflows/syntek-author/01-update-the-template/` gives every step and command for updating this template.

## Next

- What an update does, and how it treats another template's files → `how-to/src/TEMPLATE-GUIDE/updating-and-recovery.md`
- One layout under the data root → `how-to/src/TEMPLATE-GUIDE/the-data-root.md`
- When something goes wrong with two templates → `how-to/src/TEMPLATE-GUIDE/syntek-author/12-troubleshooting.md`
