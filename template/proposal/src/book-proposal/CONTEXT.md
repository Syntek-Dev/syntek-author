# CONTEXT.md — proposal/src/book-proposal/

The book proposal: the document a commissioning editor reads. Eight section files, numbered so that
`make docx SCOPE=proposal/src/book-proposal` assembles them in order; there is no separately
assembled file, because the build is the assembly. The section files ship as empty seeds and are
the author's from then on: `copier update` never overwrites them.

## Directory Tree

```text
proposal/src/book-proposal/
├── CONTEXT.md                      ← this file
├── CLAUDE.md                       ← operating rules
├── 01-overview-and-hook.md         ← the book in a paragraph; the hook; what makes it different
├── 02-why-now.md                   ← dated evidence that the question is live and unaddressed
├── 03-audience.md                  ← who it is for first, who else, how they will find it
├── 04-comparable-titles.md         ← three to six titles, each with a differentiator
├── 05-chapter-outline.md           ← 100–200 words a chapter, written for an editor
├── 06-about-the-author.md          ← the standing to write this book
├── 07-endorsements-and-reach.md    ← who will vouch for it, by the audience each unlocks
└── 08-sample-chapters.md           ← which chapters are offered, and why
```

## What's here

- **Eight sections, one file each,** in the order `proposal/docs/reference/book-proposal-anatomy.md`
  sets. Each opens with a stub banner until it is written; replace the banner with the prose.
- **No assembled copy.** A separately assembled proposal inside this folder would be built twice
  into the export; the build joins the sections itself, in filename order.
- **Work in progress** on a section can sit in a `drafts/` subfolder, which every build excludes.

## Cross-references

- `proposal/docs/reference/book-proposal-anatomy.md` — what each section must achieve.
- `proposal/docs/reference/comp-titles.md` — building section 4.
- `proposal/src/sample/sample-index.md` — the sample that section 8 points at.
- `proposal/workflows/01-assemble-the-proposal/` — the procedure that writes and builds this.
- `planning/src/units/` — the unit briefs that section 5 is rewritten from, for an editor.
