# Glossary — the words this guide uses, in plain English

This glossary explains the words this guide uses, grouped by theme, in alphabetical order within each group.
Each entry says what the word means, then why it matters in this project.

## The AI and the session

**Compaction.** Compaction is a session shrinking its own history into a summary, to free room in its context window.
Why it matters here: a summary keeps the conclusions and drops the reasons, so this project turns automatic compaction off, while a session sits idle as well as when its window fills, and hands off instead.

**Context window.** The context window is everything a model can hold in mind at once during a session, measured in tokens.
Why it matters here: a model grows less reliable as its window fills, so a hook warns at half full and insists on a handoff at three-quarters.

**Hallucination.** A hallucination is a fluent, confident statement from a model that is false, such as an invented quotation or source.
Why it matters here: the rules forbid inventing any quotation, source, figure or date, and a gap carries a flag until a real source fills it.

**Handoff.** A handoff is a short note a session writes for the next one: what was done, what is under way and what comes next.
Why it matters here: it replaces compaction, so a fresh session starts from it with a full context window, and `handoff` writes one to `handoffs/`.

**Knowledge cutoff.** A model's knowledge cutoff is the date after which it learned nothing in its training.
Why it matters here: a model may not know a recent book, law or price, so `fact-check` and `research` read sources rather than trusting memory.

**Model.** A model is the AI program that reads your request and writes the reply, such as Claude's Opus or Sonnet.
Why it matters here: every substantive task, such as drafting or reviewing, uses Opus, and only mechanical chores use the model you chose for them.

**Prompt.** A prompt is what you type to a session: a request, a question, a note or an answer.
Why it matters here: you can ask in plain words, and the project's skills turn the request into the right procedure.

**Session.** A session is one conversation with a coding agent, from opening it to closing or clearing it.
Why it matters here: a session remembers nothing of the last one, except what the project's files and its handoffs hold.

**Subagent.** A subagent is a helper session that a skill starts for one task, with its own context window, which returns only its result.
Why it matters here: some skills, such as `research`, work this way, so a long search never fills your own session.

**Sycophancy.** Sycophancy is a model's habit of agreeing with you or praising your work because that seems to please you.
Why it matters here: the skills recommend with reasons and report findings by location, so weigh the reason and never the compliment.

**Token.** A token is a piece of a word, the unit a model reads and writes in, and the unit its context window is measured in.
Why it matters here: long files and long sessions use more tokens, which is why the project hands off before the window fills.

## How the project steers the AI

**Bridge file.** A bridge file tells a coding agent other than Claude Code where the project's rules are, and the order to read them in.
Why it matters here: this template's bridge is `.claude/syntek-author-agents.md`, and every other agent reads every bridge present.

**`CLAUDE.md`.** A `CLAUDE.md` file holds the instructions Claude Code reads for the folder it sits in.
Why it matters here: almost every folder has one beside its `CONTEXT.md`, and `.claude/CLAUDE.md` holds your project's brief and your own project rules.

**Coding agent.** A coding agent, also called a client, is the program you talk to in a session, such as Claude Code, Codex, Gemini CLI, Antigravity or OpenCode.
Why it matters here: Claude Code always comes with the project, and every other agent reads the same rules and skills through a bridge file.

**Hook.** A hook is a small script that Claude Code runs by itself at a set moment, such as before every prompt or before an edit.
Why it matters here: the hooks warn as the context window fills, block automatic compaction, and refuse edits to the user guide and the data root.

**MCP server.** An MCP server is a separate program that gives a session extra tools, through the Model Context Protocol.
Why it matters here: every project ships two, one for fetching web pages and one for mapping the project's code, each asking you before its riskier tools.

**`MEMORY.md`.** `.claude/MEMORY.md` is the project's memory: its decisions, facts, feedback, status, open questions and sensitivities.
Why it matters here: every session reads it first, and an entry goes there only once it is settled, dated and meant to last.

**Mode file.** A mode file sits beside a skill and holds what is particular to one kind of project, such as a theology book, a novel or a business library.
Why it matters here: one skill serves every kind of project, and its mode file supplies the paths, rules and examples for yours.

**Override.** An override is a line in your project's settings that changes how the template works here, such as a rule you follow differently.
Why it matters here: it is the safe way to depart from a template file, because no update touches your settings, as `how-to/src/TEMPLATE-GUIDE/syntek-author/09-customising.md` explains.

**Permission rule.** A permission rule tells Claude Code whether a tool may run freely (allow), must ask you first (ask) or may never run (deny).
Why it matters here: the project denies edits to built files and to the user guide, and asks you before its riskier web and code tools.

**Procedure.** A procedure, also called a workflow, is a numbered folder of ordered steps for one job, with a checklist to tick as it runs.
Why it matters here: `run-workflow` finds the right one for a request, and a workflow alias in your settings can replace one with your own.

**Rules.** The rules are the instructions every session must follow, kept in `.claude/rules/syntek-author/` with your settings file first.
Why it matters here: where a chapter of this guide and a rule differ, the rule wins.

**Skill.** A skill is a written procedure a session follows for one kind of job, such as drafting a section or checking facts.
Why it matters here: you reach a skill by naming it or describing its job, and `how-to/src/TEMPLATE-GUIDE/syntek-author/13-a-guide-to-skills.md` lists them.

## Words for the writing

**Brief.** A brief says what a unit must do: its scope, its purpose and the job of each planned section.
Why it matters here: every drafting skill reads the brief first, and you agree it before the first section is drafted.

**Draft.** A draft is a section's text before you approve it, written by the AI or by you, in the unit's drafts folder.
Why it matters here: a draft is never part of the work until you promote it, and no build reads a drafts folder.

**Flag.** A flag is a visible note left in the text: `AUTHOR TO CONFIRM` for a decision only you can make, or `VERIFY` for a claim not yet checked.
Why it matters here: `make flags` lists every one, and a unit cannot become final while any remains.

**Gate.** A gate is a numbered check a unit must pass to move up its ladder of statuses, from idea to final.
Why it matters here: 'draft' and 'final' then mean something exact, and `standards/verification/verification.md` numbers every gate.

**Ledger.** The ledger records the history of every section: the AI's original, your original, each revision and the final text.
Why it matters here: it is the record behind any honest statement of how AI was used, and it lives in `standards/style/ledger/`.

**Markdown.** Markdown is plain text with light marks for headings, emphasis and lists, which the project's tools turn into Word files and PDFs.
Why it matters here: you write in Markdown, and your words reach a proof or a printed page without being retyped.

**Promote.** To promote a section is to move it from its draft into the unit, which happens only on your explicit word.
Why it matters here: approving a draft's content is not the same as promoting it, and `promote-section` checks the gates and flags first.

**Proof.** A proof is a built copy of your work, such as a PDF or a Word file, made so you can read it as a reader would.
Why it matters here: a proof is free at any status and changes nothing, and `make help` lists the commands that build one.

**Provenance.** Provenance is the record of where each passage came from, and who changed what.
Why it matters here: `make provenance` prints a table from the ledger for anyone who asks how AI was used.

**Review.** A review is a report on a draft, such as its structure, facts, clarity or grammar, which changes nothing by itself.
Why it matters here: every review is advice, and you answer each finding by accepting, declining or deferring it.

**Section.** A section is one piece of a unit, typically 300 to 500 words: one step of an argument, one scene beat or one clause group.
Why it matters here: the AI drafts and revises one section at a time, so you can judge each change line by line.

**Style sheet.** The style sheet records your house choices of spelling, punctuation and form, such as how you write numbers and dates.
Why it matters here: `grammar` and `spelling` check against it, and it lives in `standards/style/style-sheet.md`.

**Unit.** A unit is one piece of the work with its own brief: a chapter of a book, or one document in a business library.
Why it matters here: a unit climbs its ladder of statuses through the gates, and its sections are promoted into it one by one.

**Voice notes.** The voice notes describe how you write, with real examples, so drafts sound like you.
Why it matters here: `learn-voice` proposes additions from your edits and writes each only once you approve it, in `standards/style/voice-notes.md`.

## Files, Git and the template

**Answers file.** The answers file, `.copier-answers.syntek-author.yml`, records your answers to the template's questions and the template version the project runs.
Why it matters here: every update works from it, so commit it with every update and never edit it by hand.

**Branch.** A branch is a separate line of work in a repository, which you merge back when it is done or throw away.
Why it matters here: update the template on a branch, so your main line stays untouched until you have read the result.

**Commit.** A commit is a snapshot of the project that Git keeps for good, with a message saying what changed.
Why it matters here: commit before every update, because Copier refuses to start while anything is uncommitted.

**Conflict.** A conflict is a place where you and the template changed the same lines, so the file holds both versions between markers.
Why it matters here: you settle each one by keeping the right text and removing the markers, except in `how-to/`, where you take the template's version.

**Copier.** Copier is the tool that made the project from the template, and that brings in the template's later versions.
Why it matters here: you run it through `uvx`, so it needs no installing, and every update names the answers file after `-a`.

**Data root.** The data root is one folder on each machine, outside every repository, where a project keeps its binary files, such as scans and issued copies.
Why it matters here: Git keeps text well and large files badly, as `how-to/src/TEMPLATE-GUIDE/the-data-root.md` explains.

**Environment variable.** An environment variable is a named setting your terminal passes to every program it starts.
Why it matters here: `SYNTEK_DATA_ROOT` names your data root this way, so no file in the project names a folder on your machine.

**Git.** Git is the tool that records every version of the project, so nothing committed is ever lost.
Why it matters here: whatever an update replaces, your edits to the user guide included, stays in Git.

**Layer.** A layer is a top-level folder for one kind of work, such as planning or research, with its own guides, source files and procedures.
Why it matters here: every task belongs to a layer, and `.claude/rules/syntek-author/01-layout-and-routing.md` says which.

**Link.** A link, or symbolic link, is a small file that points at another file or folder.
Why it matters here: `how-to` must be a real folder, never a link, because an update would write the guide through it.

**Merge.** A merge combines two sets of changes to the same files, such as the template's and yours, into one.
Why it matters here: every update merges the template's changes with your edits, and where both changed the same lines it leaves a conflict.

**Migration.** A migration is a small script a release runs once, during the update that reaches it, to move your files where its changes need them or to report what you should do.
Why it matters here: a migration prints its own lines above the update report, and names each change it leaves for you to make by hand.

**Read-only guide.** The read-only guide is this user guide, in `how-to/`, which you read and never edit.
Why it matters here: only an update, its recovery and the commands its report prints change it, so record a different way of working in your settings instead.

**Rejected hunk.** A hunk is one block of changed lines, and a rejected hunk is one of your changes that an update could not fit into the template's new version of a file.
Why it matters here: the file then holds the template's version, your lines are saved beside it in a file ending `.rej`, and the update report lists it under `REJECTED HUNKS`.

**Render.** A render is the set of files the template produces from your answers.
Why it matters here: an update compares the old render with the new one to find what changed, and keeps a record of each render in the `.git` folder.

**Repository.** A repository is a folder whose whole history Git keeps, which here is your whole project.
Why it matters here: the project must be a repository of its own, never a folder inside another one.

**Seed.** A seed is a file the template writes once for you to fill in, such as your settings or `.claude/MEMORY.md`.
Why it matters here: an update never overwrites a seed, and writes a fresh, empty one only where you deleted it.

**Shared file.** A shared file is one that every template of the family ships byte for byte, so a project with two templates holds one copy.
Why it matters here: an update refreshes a shared file only while you have not changed it, and never puts an older version over another template's while that version stands unchanged.

**Template.** A template is the source a project is made from, which here is syntek-author.
Why it matters here: its improvements reach your project through updates, and its own files are never edited by hand.

**Template file.** A template file is one the template owns and updates, such as a rule, a skill or a procedure.
Why it matters here: every update merges the template's changes with an edit to one, and leaves a conflict where you both changed the same lines, so depart from it through your settings instead.

**Terminal.** A terminal is the window where you type commands, such as Terminal on macOS and Linux, or Git Bash on Windows.
Why it matters here: every command in this guide runs there, from the top folder of the project.

**Update.** An update brings a newer version of the template into the project, merged with your work.
Why it matters here: it ends with a report of every file it did not simply deliver, and `how-to/workflows/syntek-author/01-update-the-template/` gives every step.

**Variant.** The variant is the kind of project, chosen once when it was made: a theology book, a novel or business documents.
Why it matters here: it decides the whole layout of the project, and it never changes.

## Where the rules live

- `.claude/rules/syntek-author/03-authorship.md` says who decides what, and defines sections, flags, the ledger and provenance.
- `.claude/rules/syntek-author/07-session-boundaries.md` says why a session hands off instead of compacting.
- `.claude/rules/syntek-author/08-naming-and-memory.md` says what things are called, and what goes in the project's memory.
- `.claude/rules/syntek-author/01-layout-and-routing.md` says which files are the template's and which are yours.

## Next

- What a project is, and how this guide is laid out → `how-to/src/TEMPLATE-GUIDE/syntek-author/01-overview.md`
- The writing loop, where most of these words meet → `how-to/src/TEMPLATE-GUIDE/syntek-author/07-the-writing-loop.md`
- Every skill and its job → `how-to/src/TEMPLATE-GUIDE/syntek-author/13-a-guide-to-skills.md`
