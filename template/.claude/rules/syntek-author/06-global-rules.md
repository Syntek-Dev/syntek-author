# 06-global-rules.md — the rules that apply in every folder and every task

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **Template-owned.** Shipped by syntek-author and replaced by every `copier update`: never edit it here. This project's settings, paths and overrides are in `00-project.md` beside it, which outranks this file; project rules go where its `## Paths` says.

These hold everywhere, whatever the layer or the skill. A folder's `CLAUDE.md` may add to them;
it never relaxes them.

---

## 1. Locale

**Requirement.** Write and check in British English (en_GB) throughout.

| Setting | Rule |
|---|---|
| Spelling | colour, organise, behaviour, programme, recognise; licence (noun) and license (verb); practice (noun) and practise (verb) |
| Quotation marks | single, with double inside single: 'she said "now", and left' |
| Dates in prose | DD/MM/YYYY, such as 03/10/2026 |
| Dates in filenames | DD-MM-YYYY |
| Dates in database columns | ISO 8601 only, and only there |
| Time | 24-hour, in <%TIMEZONE%> |
| Cross-references | "Section 3.2", never the section sign |
<: if DOC_TYPE == 'theology' :>| Bible translation | the default citation key is in `00-project.md` `## Brief`; another translation is named where it is used |
<: endif :><: if DOC_TYPE == 'business' :>| Currency | as `00-project.md` `## Brief` sets, with two decimal places in figures |
| Jurisdiction | as `00-project.md` `## Brief` sets, unless a document states otherwise |
<: endif :>
The style sheet (`standards/style/style-sheet.md`) and terminology (`standards/style/terminology.md`)
win over this table for any word or mark they settle.

**Why this rule exists.** A book or a document set drafted out of order, across many sessions,
reads as one piece only if its mechanics are fixed once and checked every time.

---

## 2. Route; do not restate

**Requirement.** Every rule has one owner file, and everything else cites it by path and section,
or, for a project setting, by its heading in `.claude/rules/syntek-author/00-project.md`. The
audience, the reader test and the variant's answers live only in its `## Brief`; the title, the
brief and the near-term goal only in the project brief its `## Paths` locates; project state only
in `.claude/MEMORY.md`. Never copy any of them into a skill, a guide or a folder file, and never
cite a numbered section of `.claude/CLAUDE.md`: its numbers are the project's to change.

**Why this rule exists.** Two wordings of one rule drift apart, and the stale one is always the one
that gets read. A thesis restated in seven files is out of date in six of them after its first
revision.

---

## 3. Never self-edit

**Requirement.** No skill rewrites a skill, a standard, a rules file or any `CLAUDE.md` without the
author's explicit instruction for that change. A change to a standard is confirmed by the author,
always. When a rule looks wrong, report it with the reason and a proposed wording, and keep
working under the rule as written until the author decides.

**Why this rule exists.** The rules are the author's, not the model's. A system that edits its own
rules to fit the task in hand will, sooner or later, edit away the rule that protected the work.

---

## 4. Never overwrite

**Requirement.** Never overwrite an existing draft, a promoted file, a seed or any file the author
wrote without confirming first. A new draft goes beside the old one, never over it. When a write
would replace something, say what would be lost and ask.

**Why this rule exists.** An overwritten paragraph is often unrecoverable from memory, and the
version Git still holds is the one nobody thinks to look for.

---

## 5. One sentence per line, in `src/` only

**Requirement.** Prose in `src/` artefacts (section files, unit files, planning documents, `.tex`
bodies) keeps one sentence per line. Apply it only to a paragraph you are already editing; never
reflow a whole file. Governance and instructional files (`CONTEXT.md`, `CLAUDE.md`, guides,
workflows, standards, skills) keep their hard wrap. LaTeX table rows and email header lines are
exempt.

**Why this rule exists.** Pandoc and LaTeX both render a single line break as a space, so the
output is unchanged, while a diff, a review comment or a ledger comparison then points at one
sentence. Mass reflow would make every line look changed and destroy `git blame`.

---

## 6. The 300-line cap

**Requirement.** Every instructional Markdown file (guides, workflows, every `CONTEXT.md` and
`CLAUDE.md`, skills, mode files, everything under `.claude/`) stays within 300 lines. A file that
outgrows the cap splits into `SCREAMING-SNAKE-CASE.md` sub-documents behind a thin index. `src/`
artefacts and `README.md` are exempt.

**Why this rule exists.** A long instruction file is read selectively, and the rule that gets
skipped is the one near the end.

---

## 7. Proofreading is supportive, and a report

**Requirement.** Every proofreading pass (`spelling`, `grammar`, and any check that finds
mechanical errors) is a report, not a rewrite:

- say **what** and **where**, and offer the correction;
- group recurring items, so one decision fixes many ("'practise' as a verb, five places, listed");
- check figures and dates against their source with particular care;
- apply corrections only once accepted, and never change meaning while correcting form;
- comment on the text, never on the person who wrote it.

This is the default for every author, with no exceptions and no questions about why.

**Why this rule exists.** Careful, kind proofreading costs nothing, helps everyone, and makes it
safe for any writer to hand over a rough draft. A pass that silently rewrites also silently
destroys the record `learn-voice` learns from.

---

## 8. Design work opens with a grilling pass

**Requirement.** Planning a unit, settling an argument, a plot turn or a document's scope opens
with `grill-with-docs`, not with drafting. Ask in chat prose, in frontier rounds (every question
not blocked by another, in one message), each with a recommended answer, unless
`00-project.md` `## Overrides` sets another questioning style. Look facts up rather than asking for them; put only genuine decisions to the
author, and route empirical questions to `fact-check`. Never soften a recommendation because the
author leaned the other way; say so, then record the author's decision.

**Why this rule exists.** A decision made explicitly before drafting costs a minute; the same
decision discovered three sections later costs the sections.

---

## 9. Internal notes for deliberate deviations

**Requirement.** When the author authorises a departure from a standard in one artefact, record it
in that artefact, so a later pass does not correct it: in Markdown, an
`<!-- INTERNAL NOTE: … -->` comment directly under the frontmatter; in LaTeX, a `%` comment block
under the preamble.

**Why this rule exists.** A deviation that lives only in a conversation is undone by the next
session that has not seen it.

---

## 10. Confidentiality

**Requirement.** Never paste confidential material (credentials, personal contact details, private
correspondence, a third party's figures) into a committed working file such as a handoff, a map,
a lesson or a review. Refer to it by name and location only. Material the author marks as
sensitive is quoted only where the author has placed it.

**Why this rule exists.** These files are committed and pushed. A secret in a handoff written in a
hurry is published with the next push.

---

## 11. Answers change through Copier

**Requirement.** The answers given when this project was generated are recorded in
`.copier-answers.syntek-author.yml`. Never edit that file by hand. A changed answer (a new title, a
different audience) is re-answered through `copier update` (`README.md`, "Updating from the
template"), and the seeded files that quote it, such as `00-project.md` `## Brief` and the
project brief in `.claude/CLAUDE.md`, are then updated by hand, because Copier never rewrites a
seed.

- **`DOC_TYPE` never changes**: the update refuses it. A different variant is a new project.
- **Turning an option off deletes every file it generated, seeds included**, even ones the
  author has filled in. Before such an update, list those files for the author (the README
  section names them for this project), have them copied out and committed, and only then run
  it. After any toggle, the seeds that describe the options (`README.md`, `CONTEXT.md`,
  `.claude/CLAUDE.md`, `00-project.md`, `.claude/settings.json`, `.gitignore`) are edited by hand.
<: if DOC_TYPE == 'business' :>- **Unticking a family in `BUSINESS_FAMILIES` deletes its template files**: its folder's
  signposts (the `CONTEXT.md` and `CLAUDE.md` of the folder and its sub-folders, and
  `drafts/README.md`), its standard `library/docs/reference/<family>-standards.md` and the
  standard's sub-documents, its `<family>-documents` skill and its create workflow, the author's
  edits to any of them included. No family folder ships a seed. The documents the author wrote
  elsewhere in its folder stay.
<: endif :>- **In a repository adopted additively**, the project's own files at template paths are template
  files to Copier. A file the project already had at an option's <: if DOC_TYPE == 'business' :>or a family's <: endif :>template path (its
  skill, its folder pairs) is deleted with it: list those files for the author and have them
  copied out before the update. On any update, a file the project kept at a template path
  comes back with conflict markers whenever the template changed it; keep the project's version
  (`01-layout-and-routing.md` Section 9).

**Why this rule exists.** A hand edit in a rendered file and a stale answer diverge silently, and
the next update turns the difference into a conflict. An option turned off without warning takes
the author's filled-in seeds with it<: if DOC_TYPE == 'business' :>, a family unticked takes the edits to its standard and skill<: endif :>,
and in an adopted project the files it already had.

---

## 12. What Git ignores stays out of the session

**Requirement.** Never search, scan, list or quote a file Git ignores. A search of the project
covers only the files Git tracks or would track
(`git ls-files --cached --others --exclude-standard`, `git grep`, or a list filtered through
`git check-ignore`), never a plain recursive search over everything on disk. An ignored file is
opened only when the author names that file, or when it is output in `build/` that a skill has
just made in order to read it.

**Why this rule exists.** Ignored folders are where credentials, client copies and local-only
material are kept, precisely because they must never be committed. A search that reads them
prints their lines into the session, and from there into a handoff, a review or a commit. The
build follows the same rule (`.claude/rules/syntek-author/04-build-pipeline.md` Section 3).
