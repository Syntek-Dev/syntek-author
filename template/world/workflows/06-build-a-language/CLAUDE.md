@./CONTEXT.md

# CLAUDE.md — world/workflows/06-build-a-language/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/workflows/CONTEXT.md` → `world/workflows/CLAUDE.md` → this folder's `CONTEXT.md`
(imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Build a language that its speakers' world explains and its real-world models make audible, one
settled subsystem at a time, in files the tooling can check.

## How to work here

- **Routing:** skill `build-language`, with `research` for the models; guides
  `world/docs/reference/building-a-language.md` and `world/docs/reference/lexicon-format.md`;
  checks `make lexicon`, `make derive`, `make coverage` and `make family`, each with
  `LANG=<slug>` where it takes one.
- **Model:** **Opus** for every design decision and every model proposed; the mechanical tier
  for creating the folder and running the checks
  (`.claude/rules/syntek-author/05-model-allocation.md`). The checklist tags are authoritative.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go: what the book
  needs → read the world → propose models and recommend → research and cite → place in the
  family → create the folder → sound changes (daughters) → inventory → phonotactics, stress and
  allophones → romanisation → grammar → core lexicon → check → hand back.
- **Definition of done:** every model is chosen by the author and cited; each subsystem built
  so far was settled before the next began; `make lexicon` passes (and `make derive` for a
  daughter); every undecided point is stated as undecided in the files.

## Guardrails

- **World first.** No sound is proposed before the people, culture and history files are read;
  if they are too thin, say what is missing rather than guess.
- **Options, a recommendation, the author's choice.** Two or three models with their reasons and
  risks, a recommendation stated, and the author deciding. Never one option dressed as a fact.
- **Real languages are researched, never remembered.** Every claim about a model is cited in
  `research/src/setting/`; borrow structure and flavour, never vocabulary.
- **Flag the hostile-people trap every time.** A hostile people's language modelled on a real
  ethnic group's is raised with the author, with alternatives, as `standards/risk/FICTION.md`
  requires.
- **One subsystem at a time, settled before the next.** A sound system changed after the grammar
  is written changes the grammar's examples too.
- **Changes to a language in use are changes to the book.** Run the checks on the proposed
  change first, and list every word that breaks and every section that uses one.
- **Never overwrite an existing language file** without confirming with the author.

## Output & naming

- **Produces:** `world/src/languages/<lang>/` with its pair, `language.toml`, `phonology.toml`,
  `sound-changes.toml` (daughters), `grammar.md`, `lexicon.toml` and `pronunciation.md`; the
  folder name is the language's slug and matches `slug` in `language.toml` and `lexicon.toml`.
- **Also writes:** research notes in `research/src/setting/`.
- **Generated:** nothing; the checks only report.
- **Does not touch:** words already in the lexicon outside this pass (each is changed through
  `world/workflows/07-add-a-word/` with the author's word), the script, or promoted prose.
