# Prerequisites — the tools to install first

A project needs a few free tools on your computer before it can be made, built and updated.
This chapter lists them, shows how to check which ones you already have, and says what each one is for.
A word you do not know is explained in the glossary, `how-to/src/TEMPLATE-GUIDE/syntek-author/17-glossary.md`.

## What you need

| Tool | What it is for | Do you need it? |
|---|---|---|
| uv | Running Copier, the tool that makes and updates the project, on Python 3.14 or later, and running the two MCP servers | Yes |
| Git 2.31 or later | Recording every version of the project; every update relies on it | Yes |
| Python 3.14 or later | The small scripts behind the build, the data-root tool and the hooks | Yes |
| make | Running every build and check | Yes |
| Pandoc and XeLaTeX | Turning your text into PDF and Word proofs, and the comparison of each section | Yes, to build proofs |
| The TeX Live packages xcolor, ulem, paracol and array | Laying out the comparison as a PDF | Yes, for the comparison |
| sqlite3 | The citation database | Only with references |
| espeak-ng | Pronouncing a constructed language without an online service | Optional, only with the constructed-language kit |
| Claude Code | Running the skills, the rules and the procedures | Yes |
| Codex, Gemini CLI, Antigravity or OpenCode 2 or later | Doing the same work in another coding agent | Optional |

Your system may already have some of these.
XeLaTeX and the four packages come with TeX Live, a free distribution of the LaTeX typesetting system; a full installation includes them all.
Copier itself needs no installing, because uv runs it for you.
This template needs Copier 9.12.0 or later.
`uvx` fetches the newest Copier the first time it runs it, then keeps using that copy until you ask for a newer one.
The report every update prints runs on the Python that runs Copier, and it needs Python 3.14 or later.
Left to itself, `uvx` may run Copier on an older Python it already has, and then an update skips its report, the refresh of the shared files and the putting back of the guide, and prints a warning that says so.
So every Copier command in this guide starts `uvx --python '>=3.14'`, which asks uv for Python 3.14 or later and fetches it the first time if your computer has none.
Keep the quotes round `>=3.14`: without them, the shell reads `>` as an instruction to write the command's output to a file.

## Check what you have

Every command in this guide runs in a terminal, the window where you type commands.
Use a POSIX shell, such as bash or zsh: the Terminal app on macOS and Linux, and WSL or Git Bash on Windows.
Run each command below on its own.
A tool that is missing prints 'command not found' or similar; install it with your system's usual installer, then check again.

This one prints the version of Copier that `uvx` runs; the first run downloads Copier, so it takes a little longer:

```bash
uvx --python '>=3.14' copier --version
```

It should be 9.12.0 or later.
Where it is older, this command fetches the newest Copier and prints its version, and every later Copier command in this guide uses it:

```bash
uvx --python '>=3.14' copier@latest --version
```

Where you installed Copier with `uv tool install` on Python 3.14 or later, `uvx` runs that copy instead, and `uv tool upgrade copier` brings it up to date; a copy installed on an older Python is passed over.

This one prints Git's version, which should be 2.31 or later:

```bash
git --version
```

This one prints the version of your own Python, which the project's scripts use and which should be 3.14 or later:

```bash
python3 --version
```

Where it is Python 3.8 to 3.13, every script stops before it does anything, prints a framed message that says it did NOT run, and asks you to upgrade to Python 3.14.
A hook lets Claude's action through instead, with the same warning, because it could not check it.
On Python 3.6 or 3.7, a script may stop with a `SyntaxError` instead of that message, as `how-to/src/TEMPLATE-GUIDE/syntek-author/12-troubleshooting.md` explains.
Install Python 3.14 or later with your system's usual installer, then check again.

This one prints the version of make:

```bash
make --version
```

This one prints the version of Pandoc:

```bash
pandoc --version
```

This one prints the version of XeLaTeX, at the end of a few lines about TeX:

```bash
xelatex --version
```

If your project keeps a citation database, check sqlite3 the same way, with `sqlite3 --version`.

## What each tool is for

- uv is a tool for Python programs, and its `uvx` command runs a program such as Copier without installing it.
- Copier made your project from the template, and it brings in the template's later versions when you update.
- uv also runs the two MCP servers, small helper programs that give Claude tools for reading web pages and for mapping the project's code.
- Git keeps every version of your files, so any change can be seen, compared or undone.
- Every update is a three-way merge, which combines the template's changes with yours through Git, so the project must be a repository, a folder Git looks after.
- Each update command carries five settings that need Git 2.31 or later; `how-to/src/TEMPLATE-GUIDE/updating-and-recovery.md` explains why.
- Python runs the small scripts in `tooling/`, which use nothing but what Python itself ships with, and each of them needs Python 3.14 or later.
- make runs the build: each job has a name, called a target, such as `make flags`, and `make help` lists them all.
- Pandoc turns Markdown, the plain text your work is written in, into Word and PDF files.
- XeLaTeX lays out the pages of a PDF, with proper fonts and hyphenation.
- sqlite3 builds and reads the citation database, where a project keeps the works it cites.
- espeak-ng speaks a constructed language aloud when no online voice service is set up.
- Claude Code is the AI assistant that runs the skills, and it reads the `.claude/` folder when it starts.
- The other coding agents can do the same work from the same rules, and `how-to/src/TEMPLATE-GUIDE/agent-clients-and-mcp.md` explains them.

A missing tool blocks only the jobs that need it.
When a job stops because a tool is missing, the message names the tool, and Claude tells you which job it blocks.

## Where the rules live

- `.claude/rules/syntek-author/04-build-pipeline.md` Section 4: which tool each build target needs.
- `.claude/rules/syntek-author/04-build-pipeline.md` Section 3: the scripts use the Python standard library only.
- `.claude/rules/syntek-author/05-model-allocation.md`: which AI model each kind of work uses, in each coding agent.

## Next

- Your first hour, from a new project to a drafted section → `how-to/src/TEMPLATE-GUIDE/syntek-author/03-quickstart.md`
- What each question Copier asked means → `how-to/src/TEMPLATE-GUIDE/syntek-author/04-the-answers.md`
- The coding agents other than Claude Code → `how-to/src/TEMPLATE-GUIDE/agent-clients-and-mcp.md`
