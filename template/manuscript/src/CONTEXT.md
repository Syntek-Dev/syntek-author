# CONTEXT.md — manuscript/src/

The deliverable prose: the words that reach the reader, an editor and a publisher. Each chapter is
a numbered folder holding the chapter file and a drafts folder for the sections still in
progress. This is what the build consumes, so it holds prose and section markers only. The plan
for each chapter is in `planning/src/units/`, its evidence in `research/src/`, and its record of
who wrote what in `standards/style/ledger/`. A project generated with examples starts with one
worked example chapter, which `copier update` never brings back once it is deleted.

## Directory Tree

```text
manuscript/src/
├── CONTEXT.md                  ← this file
├── CLAUDE.md                   ← operating rules
└── NN-kebab-title/             ← one folder per chapter; NN is the running order
    ├── CONTEXT.md              ← what this chapter is and its job in the book
    ├── CLAUDE.md               ← this chapter's particular traps and definition of done
    ├── NN-kebab-title.md       ← the chapter: an H1, one marker per section, promoted prose
    └── drafts/                 ← sections in progress; no pair, never built
        ├── README.md           ← what the folder is for
        └── <NN>-<section-slug>.md  ← one draft per section, NN being its order
```

## What's here

- `NN-kebab-title/NN-kebab-title.md` — **the chapter file.** An H1 title, then one
  `<!-- section: <slug> -->` marker per section in the chapter's brief, in plan order, with each
  promoted section's prose directly under its marker. No frontmatter: the chapter's status and plan
  live in its brief. One sentence per line.
- `NN-kebab-title/drafts/` — **work in progress.** One file per section, with the frontmatter set
  out in `manuscript/docs/reference/section-anatomy.md`. Everything under a drafts folder is
  excluded from every build, so an unpromoted section can never reach an editor's copy.
- `NN-kebab-title/CONTEXT.md` and `CLAUDE.md` — the chapter's own pair. They carry what is
  particular to this chapter (its job in the book, its traps, what done looks like for its reader)
  and route to its brief rather than restating it.

**How the build reads this folder:** Pandoc renders the chapter files in numeric folder order;
governance files and drafts are excluded. `make pdf SCOPE=manuscript/src/NN-kebab-title` proofs
one chapter; `make book` builds the whole manuscript.

## Cross-references

- `manuscript/docs/reference/section-anatomy.md` — the chapter file, its markers and the draft
  format.
- `manuscript/docs/reference/the-status-ladders.md` — the chapter ladder and the section statuses.
- `manuscript/workflows/` — where every task in this folder starts.
- `planning/src/units/` — the brief for each chapter, including its list of sections.
- `standards/style/ledger/` — the provenance record for every section.
