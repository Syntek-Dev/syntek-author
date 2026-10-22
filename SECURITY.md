# Security Policy

## What this repository is

`syntek-author` is a **Copier template** that generates writing repositories. It runs no service,
hosts no data and has no users of its own. It does, however, run code on an author's machine:
Copier runs its tasks and migrations under `--trust` when a project is generated or updated, and the
project it generates holds scripts, hooks and agent configuration that run in the author's
repository and coding sessions.

The risk we most want to hear about is a defect, an unsafe default or a malicious change in that
code, reaching every project generated or updated from the template.

## Supported versions

| Version | Supported |
|---|---|
| The latest release | Yes |
| Any earlier release | No |

The latest release is the newest entry on the
[releases page](https://github.com/Syntek-Dev/syntek-author/releases), and its number is in
[`VERSION`](VERSION) on `main`. A project records the release it was generated or last updated from
as `_commit` in `.copier-answers.syntek-author.yml`. There are no maintained release branches: a
fix ships in a new release, and a project takes it with `copier update` (always with
`-a .copier-answers.syntek-author.yml`, as the README's
[Updating a project](README.md#updating-a-project) shows).

## Reporting a vulnerability

**Never report a vulnerability in a public issue, discussion or pull request.**

Report it only through GitHub's private vulnerability reporting:
[open a private report](https://github.com/Syntek-Dev/syntek-author/security/advisories/new) (or
go to the **Security** tab and choose **Report a vulnerability**). The report is visible only to
you and the maintainers.

Please include:

- the file, script or default at fault, with its path;
- the template version you looked at (a release tag, or `_commit` from the answers file);
- the answers that matter, such as `DOC_TYPE`, `AGENT_CLIENTS`, `DATA_STORE` or `DATA_PROVIDER`;
- what a generated project, or the machine it runs on, ends up doing;
- a concrete way to reach it and what it yields, not only a category name;
- the versions of Copier, the operating system and the coding agent, where they matter.

Reproduce it in an invented project. Never send an author's manuscript, real credentials or
anybody's personal data.

## In scope

Code and configuration from this template that runs on an author's machine or in their
repository:

- **`copier.yml`'s `_tasks` and `_migrations`**, which run under `--trust` on copy and update:
  anything that runs other than as documented, or that an answer can turn into a command.
- **The migration scripts in `migrations/`**, which run in the author's project on copy and update.
- **The adoption scripts in `adopt/`**, which run against an existing repository.
- **The hooks under `template/.claude/hooks/`**, and the data-root guard the seed settings wire.
- **The permissions script and the data-root resolver**
  (`template/.claude/syntek-author-permissions.py` and
  `template/.claude/syntek-author-dataroot.py`): a rule dropped so that a client runs a tool without
  the promised prompt, or a read, write or copy outside what the owner named.
- **The `Makefile` and the scripts in `template/tooling/`.**
- **The shipped MCP and agent-client configuration**: `.mcp.json`, `.agents/mcp_config.json`,
  `.codex/config.toml`, `.gemini/settings.json`, `opencode.json` and the seed
  `.claude/settings.json`, for example a server that is not pinned, a credential with a value, or a
  permission that removes a prompt the documentation promises.
- **The shipped GitHub workflows** in `template/.github/workflows/`: a secret exposed, untrusted
  input reaching a command, or permissions wider than the job needs.

## Out of scope

Report these to the project that maintains them:

- **Copier itself**, and the fact that `--trust` runs the template's tasks. That is by design and
  documented; read `_tasks` in `copier.yml` before you generate, as with any template.
- **Claude Code, Codex, Gemini CLI, Antigravity, OpenCode** and any other coding agent.
- **The MCP servers' own code**: Scrapling and code-review-graph, as distinct from how the template
  configures them, which is in scope; and ElevenLabs, which the template never configures (an
  author adds it at user scope, as the README says).
- **Upstream tools**: uv, Python, git, make, Pandoc, TeX Live, sqlite3, GitHub Actions, and any
  sync service or client you run for the data root (the template never runs one itself).

Also out of scope: a project you generated and then changed, which is yours, and findings from an
automated scanner with no demonstrated effect on the template or on what it generates.

## What to expect

syntek-author is maintained by a small studio alongside client work, so we handle reports on a
best-effort basis. We will acknowledge your report. Beyond that we make no fixed promise of
timescales, but we will look into it, tell you what we conclude (including when we decide
something is not a vulnerability, and why), and keep you informed while a fix is prepared. We do
not offer a bug bounty. GitHub adds you to the advisory's credits when you report; accept or
decline the credit there, or tell us if you would rather not be named.

## Disclosure

A confirmed vulnerability is fixed in a new release and disclosed through a
[GitHub security advisory](https://github.com/Syntek-Dev/syntek-author/security/advisories) on
this repository once that release is out, with an entry in [`CHANGELOG.md`](CHANGELOG.md). Please
keep the details private until the advisory is published.
