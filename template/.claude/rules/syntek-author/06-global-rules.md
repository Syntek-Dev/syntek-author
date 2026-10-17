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

**The data root is off-limits too, whatever the store.** A data root is a folder outside every
repository that holds a `.syntek-data-root` marker; this machine's is the one `SYNTEK_DATA_ROOT`
names. Never search, list, edit or write anything under one, by any tool or shell command.
Reach its files only through the data-root commands, and open one only at the path they print
for it (`.claude/rules/syntek-author/09-data-root.md` Section 2); those commands are the one
exception to the paragraph above, listing an ignored binary by its name and size, never its
contents. The guard hook stops edits and writes there, and searches only where the client offers
`Grep` and `Glob`: on macOS, Linux and WSL Claude Code searches through the shell, which the hook
does not read, so there this rule alone keeps a search out of the root.

**Why this rule exists.** Ignored folders are where credentials, client copies and local-only
material are kept, precisely because they must never be committed. A search that reads them
prints their lines into the session, and from there into a handoff, a review or a commit. The
build follows the same rule (`.claude/rules/syntek-author/04-build-pipeline.md` Section 3). The
data root holds the records themselves: a search there prints them too, and an edit in place
breaks the checksum that proves a record unchanged.

---

## 13. Web and code tools

<!-- BEGIN family-shared rules: web and code tools -->
**Requirement.** Every project ships two MCP servers, pinned and keyless: `scrapling`, which
fetches web pages, and `code-review-graph`, a local map of a repository's code. Use them only
as this section says.

- **Ask the author before each of `scrapling`'s six asked browser tools**: `stealthy_fetch`,
  `bulk_stealthy_fetch`, `open_session`, `session_fetch`, `fetch` and `bulk_fetch`. Say which
  site, why, and which tool. Claude Code asks before each of them by itself; in a client that
  does not, ask in the conversation and wait. A configured server, or a tool the client lets you
  run, is not the author's approval. `screenshot` loads a page in a browser session already
  open: use it only on the site the author approved for that session, and ask before taking it
  to any other site.
- **Use the plainest tool that does the job**: the client's own web search or fetch first, then
  `make_request` or `bulk_get`. Even these present a browser's fingerprint and headers to the
  site, and no `scrapling` tool reads `robots.txt` or limits how fast it asks.
- **`make_request`, `bulk_get` and `session_make_request` only read.** Send `make_request` and
  `session_make_request` as a GET with no request body unless the author agrees to that request.
  Never send any of the three to a loopback, private or link-local address (localhost,
  127.0.0.0/8, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 169.254.0.0/16, or a browser's
  DevTools port), and never set `follow_redirects` to true, `verify` to false, or a `proxy`.
  Codex runs these three without asking, because the server marks them read-only.
- **Never set `real_chrome`, `cdp_url` or `executable_path` without the author's word for that
  call**, and never use a stealth tool to get past a sign-in, a paywall, a challenge page or a
  site that refuses automated access: whether that is allowed is the author's decision, not the
  session's.
- **Respect each site's terms of use, its `robots.txt` and the law**, including data protection
  and copyright. This rule is not legal advice: where the position is unclear, stop and ask the
  author. Record what was fetched, from where and when, in the project's record of provenance
  where its rules name one.
- **`code-review-graph`** maps the code of the repository a call names: by default this project,
  whose graph it keeps in a `.code-review-graph` folder at the project root, which Git ignores.
  It indexes the files Git tracks; while Git tracks nothing (a new project before its first
  `git add`) it scans every file on disk, ignored ones included, so never build its graph before
  the project's first commit. Never pass `repo_root`, and never call `list_repos_tool` or
  `cross_repo_search_tool`, without the author's word: they reach other repositories on this
  machine and a registry in the home folder. `apply_refactor_tool` rewrites files and
  `generate_wiki_tool` writes pages, so both ask first; its cloud-embedding tool is never
  offered, and its cloud keys stay blank.
- **Never run `code-review-graph install`, `init` or `uninstall`, or `scrapling install`.** The
  first three rewrite the agent files every template shares, the project's settings, skills and
  Git hooks, and configuration outside the project; `scrapling install` installs system packages
  with administrator rights. The author runs the commands that fetch the servers and their
  browser, in their own terminal.

**Why this rule exists.** `scrapling`'s stealth tools are built to look like a person's browser
and to get through anti-bot protection, so a site cannot tell them from a visitor. Its
`real_chrome` option launches the Chrome installed on this machine, with a fresh profile;
`cdp_url` hands the session control of any browser that exposes DevTools at that address, on
this machine or another; `executable_path` launches whatever program it names. Every request
comes from the machine and network address of the browser that sends it, the author's or the
one `cdp_url` names: what a session fetches is the author's act, not the tool's.
`code-review-graph`'s installer replaces the pinned, keyless entries with an unpinned one that
offers the cloud-embedding tool.
<!-- END family-shared rules: web and code tools -->
