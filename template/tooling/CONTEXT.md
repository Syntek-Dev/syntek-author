# CONTEXT.md — tooling/

The supporting layer that holds the machinery: the Pandoc settings, filter and LaTeX that turn the
work into proofs, and the small standard-library Python scripts the `Makefile` runs. It is
deliberately minimal: Pandoc, XeLaTeX and a few scripts with no dependencies<: if INCLUDE_REFERENCES :>, plus one
SQLite file<: endif :>; no server, no web interface, no scheduled jobs. You run it through `make`;
you do not write the work here. The rules it enforces live in `standards/`; if the two
ever disagree, the standard is right and the tooling is broken.

## Directory Tree

```text
tooling/
├── CONTEXT.md          ← this file
├── CLAUDE.md           ← operating rules
├── defaults.yaml       ← Pandoc settings and the work's title and author metadata
├── pandoc/             ← house.lua: semantic Markdown (epigraphs, scene breaks…) to each output
├── latex/              ← the house LaTeX, one file per kind of output
<: if DOC_TYPE != 'business' :>├── book.latex          ← PDF preamble additions: widow, orphan and footnote penalties
<: endif :>├── texcheck.py         ← the fidelity check: a LaTeX file's words against their Markdown
<: if INCLUDE_REFERENCES :>├── schema.sql          ← the refs table: the citation database's one table
├── seed-refs.sql       ← works the project brings with it (seeded empty)
├── export_refs.py      ← references.db → build/references.json (CSL-JSON)
├── harvard.csl         ← Cite Them Right Harvard style (CC BY-SA licence block kept)
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>├── lexicon.py          ← check, derive and gloss a language; coverage, family, density, names
├── script.py           ← transliterate into a language's script; render text as SVG
├── font.py             ← compile a script's glyph SVGs into build/fonts/<slug>.otf (uv run)
├── conlang_common.py   ← what the conlang scripts share: Private Use Area code points above all
├── data/               ← core-concepts.toml: the core concepts and pronouns make coverage reads
<: endif :>└── provenance.py       ← change ratios and the AI-disclosure table from the ledger
```

## What's here

- `defaults.yaml` — the Pandoc defaults every Markdown build shares. **Title and author come
  from the answers given at generation**, and live here and in `.claude/CLAUDE.md` only.
- `tooling/pandoc/house.lua` — the house filter every Pandoc run passes through: it turns what
  the author marked in Markdown into the right thing for each output, and lets the fidelity check
  read the Markdown exactly as the LaTeX was made.
- `tooling/latex/` — the house LaTeX; its `CONTEXT.md` lists what this project's kind of output
  uses.
<: if DOC_TYPE != 'business' :>- `book.latex` — added to PDF builds only, by the `Makefile`.
- `texcheck.py` — the fidelity check: `make tex-check` runs it to prove a typeset chapter in
  `typeset/src/units/` carries exactly its Markdown's words; `--self-test` proves the check
  still separates.
<: endif :><: if DOC_TYPE == 'business' :>- `texcheck.py` — the fidelity check in section mode: `make section-check FILE=….tex
  SECTION=<slug> DRAFT=….md` proves the text between a section's marker pair in a deliverable
  carries exactly the promoted draft's words; `promote-section` runs it before it writes the
  ledger. `--self-test` proves the check still separates.
<: endif :><: if INCLUDE_REFERENCES :>- `schema.sql`, `seed-refs.sql`, `export_refs.py`, `harvard.csl` — the reference pipeline:
  `make init` builds `tooling/references.db` (never shipped; commit it once built), `make refs`
  exports it, Pandoc renders it. `make dump` writes the diffable `references.dump.sql` beside it;
  **commit both after every change**.<: if DOC_TYPE == 'theology' :> `make refs` also writes `build/nocite.yaml`, so
  the default translation is in every reference list.<: endif :>
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>- `lexicon.py` and `script.py` — read each language's `language.toml`, `phonology.toml`,
  `sound-changes.toml`, `lexicon.toml` and `script/glyphs.toml` under `world/src/languages/`; run
  them as `make lexicon`, `make derive`, `make coverage`, `make family`, `make glossary` and
  `make script-sample`. Every string they read is NFC-normalised, so a character typed two ways
  is one character; each has a `--self-test`.
- `font.py` — the one script with a dependency (fontTools), declared inline and run with
  `uv run`, so nothing is installed globally: `make font` builds `build/fonts/<slug>.otf`, which
  native-script words in the printed book use.
- `conlang_common.py` — not run directly: the one copy of what `lexicon.py`, `script.py` and
  `font.py` must agree on, above all how glyphs get their Private Use Area code points, so the
  text `script.py` writes is the text the font draws.
- `data/core-concepts.toml` — the core concepts and the pronoun grid `make coverage` checks a
  language against.
<: endif :>- `provenance.py` — reads `standards/style/ledger/`; `make provenance` prints the table a
  publisher asks for. Every script here is standard-library Python 3.11 or later, with no
  dependencies<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>, except `font.py`<: endif :>.

## Cross-references

- `Makefile` — every target; run `make help`.
- `standards/style/ledger/` — the evidence `provenance.py` reads.<: if INCLUDE_REFERENCES :>
- `standards/referencing/harvard-referencing.md` — the rules the reference pipeline enforces.<: endif :><: if DOC_TYPE == 'business' :>
- `standards/brand/brand-guide.md` — the identity the house preamble renders.<: endif :><: if DOC_TYPE != 'business' :>
- `typeset/docs/reference/the-typesetting-pipeline.md` — how the house filter, the book class and
  the fidelity check make the printed book.<: endif :>
- `.claude/rules/syntek-author/04-build-pipeline.md` — the pipeline diagram for this project.
