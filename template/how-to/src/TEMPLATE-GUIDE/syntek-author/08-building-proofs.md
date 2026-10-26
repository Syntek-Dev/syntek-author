# Building proofs — turning your text into something to read

A proof is your text built into a PDF or a Word file, so you can read it as a reader will.
This chapter shows how to build proofs, run the checks that come with them, and print the record of how the AI was used.
A word you do not know is explained in the glossary, `how-to/src/TEMPLATE-GUIDE/syntek-author/17-glossary.md`.

## Every build starts with make

The project's build runs through make, a tool that runs a named job, called a target, from the `Makefile` at the top of the project.
Run every make command in a terminal open in the project's top folder.
This one lists every target, each with a one-line description:

```bash
make help
```

It prints one line for each target: its name, then what it does.
Where this guide and `make help` disagree, `make help` is right.
Everything a build makes goes into `build/`, which Git ignores and nobody edits by hand.
To change a proof, change its source text and build it again.
You can also ask Claude, such as 'build me a proof of the second chapter'.
The `build` skill then runs the right target, opens what it built and reads it, and reports each problem with the procedure that fixes it.

## Proofs are free

A proof can be built at any stage of the work, and building one changes nothing.
Proofs need no approval and pass no gate: the gates govern promotion and the final status, never a build.
You choose what to build in words that make understands, written after the target.
In a book, `SCOPE=` names a folder, and every chapter file under it is built in order.
In a business project, `FILE=` names one document.
Your variant's chapter of this guide gives the commands for a whole book or a single document.
Anything in a `drafts/` folder is left out of every build, so a proof shows only promoted text.
Building a PDF needs Pandoc and XeLaTeX, which `how-to/src/TEMPLATE-GUIDE/syntek-author/02-prerequisites.md` lists.

## Checks you can run

The checks read your text and report what they find; they change nothing.
This one lists every open flag in the project, by file and line, with any other open-item marks your project counts:

```bash
make flags
```

It prints each kind of flag with its count, then every line that holds one, starting with the file's path and the line's number.
Without a scope it also reads the project brief in `.claude/CLAUDE.md` and your settings in `.claude/rules/syntek-author/00-project.md`, whose open questions count as flags too.
This one reports every line in the work that holds more than one sentence, and every American spelling, with more checks in some variants:

```bash
make lint
```

It prints a count for each kind of finding, then every line it found.
Each check can be narrowed to one folder with `SCOPE=`.
This example checks the flags of the planning layer only; put any folder of the project after `SCOPE=`:

```bash
make flags SCOPE=planning/src
```

A check is a report, not a gate, but `STRICT=1` after it makes it fail when it finds anything.
Neither check reads a file Git ignores, because those files can hold private material.
Neither reads this guide either, unless you name it, as in `make lint SCOPE=how-to/src`.

## Provenance and comparison

The ledger records each section's history, and two targets print it.
This one prints a table with a row for each unit, showing how much of it the AI drafted and how much you changed:

```bash
make provenance
```

It prints the table in the terminal, one row for each unit, with a note on how it is counted.
It counts only the AI's suggestions you accepted or rejected, so your own notes are never counted as the AI's.
Use it whenever a publisher, an agent or a client asks how AI was used.
This one writes a PDF for every unit with ledger entries into `build/compare/`:

```bash
make compare
```

It prints the path of each PDF it wrote.
Each PDF opens with a key and the unit's table, then shows every section twice.
First comes a redline, in which every added word is marked and every removed word struck through, by who changed it.
Then comes a page in three columns: the original, the AI's edit and your final text.
The colours are chosen to stay clear to colour-blind readers, and each has a line style of its own, so it also reads in black and white.
`UNIT=` narrows it to one unit, and `SECTION=` to one section of that unit.
The comparison needs the TeX Live packages that `how-to/src/TEMPLATE-GUIDE/syntek-author/02-prerequisites.md` lists.
A comparison stays in `build/`: it is for you, never issued or committed.

## References

References are an option, on by default in a theology book and available in every variant.
With it, the works you cite live in a small database in the tooling folder, never in a list typed by hand.
You ask Claude to add a work, and its skill gives the work a short key, made of the author's surname and the year, which your text cites.
Before a proof, the build exports the database so that Pandoc can print each reference list in Harvard style.
A key is never renamed once used, because every citation of it would break.
Without the option, none of this is in your project, and turning it on later is a change of answer that `how-to/src/TEMPLATE-GUIDE/syntek-author/04-the-answers.md` explains.

## Where the rules live

- `.claude/rules/syntek-author/04-build-pipeline.md` Section 1: how the text becomes a proof.
- `.claude/rules/syntek-author/04-build-pipeline.md` Section 2: every target, and what it does in this project.
- `.claude/rules/syntek-author/04-build-pipeline.md` Section 3: the rules of the build, such as proofs being free and drafts never built.
- `.claude/rules/syntek-author/03-authorship.md` Sections 5 and 8: the two flags, and provenance.
- `tooling/project.mk`: this project's build settings, such as its extra open-item marks and its fonts.

## Next

- Making the project work your way → `how-to/src/TEMPLATE-GUIDE/syntek-author/09-customising.md`
- Your variant's own chapter, with its whole-book or document commands → `how-to/src/TEMPLATE-GUIDE/syntek-author/CONTEXT.md`
- When a build goes wrong → `how-to/src/TEMPLATE-GUIDE/syntek-author/12-troubleshooting.md`
