# CONTEXT.md — world/workflows/03-name-something/

The procedure for naming any one thing in the book: a minor character, a ship, an inn, a
festival, a title, a sword, a place mentioned in passing. It produces three to five options with
reasons, checks them for clashes, lets the author choose, and registers the choice with IPA and
a reader respelling. The character and place procedures run the same steps inside themselves.

## Directory Tree

```text
world/workflows/03-name-something/
├── CHECKLIST.md        ← model-tagged checklist; tick it as you go
├── CLAUDE.md           ← operating rules for this procedure
├── CONTEXT.md          ← this file: when to use it, what it produces
└── STEPS.md            ← the ordered steps, each naming its skill and guide
```

## When to use this

- Something needs a name and nothing more: no file, no arc, no history beyond a line.
- An existing name is clashing with another and needs replacing (the old row is retired, not
  deleted).
- The author has a name in mind and wants it checked and registered.

Reach for a **different** procedure when the thing named needs a file of its own: a character
with scenes (`world/workflows/01-create-a-character/`) or a place where scenes are set
(`world/workflows/02-create-a-place/`).

## What it produces, and where

- **A register row** in `world/src/names-register.md`: name, kind, IPA, respelling, language,
  meaning, notes; First appears stays empty until promoted prose uses the name.
- **Where a likely misspelling exists,** the wrong form added to the avoid list in
  `standards/style/terminology.md`.
- **For a renaming,** the old row marked retired with the date, and the sections that used the
  old name listed for the author.

## The failure this procedure exists to prevent

The unregistered name. A name typed straight into a scene is invisible to `spelling`, which
then accepts every misspelling of it, and to `continuity`, which cannot tell that the innkeeper
called Hal in Chapter 2 is called Hap in Chapter 9. Registering costs one row; not registering
costs a reader's trust the first time they notice.

## Cross-references

- `world/docs/reference/naming.md` — sound palettes, clashes, respellings and the register.
- `world/src/names-register.md` — the register and its column rules.
- `standards/style/terminology.md` — words to avoid, including misspelt names.
