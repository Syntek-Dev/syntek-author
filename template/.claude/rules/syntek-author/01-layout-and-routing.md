# 01-layout-and-routing.md — where everything lives, and how work finds its folder

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **Template-owned.** Shipped by syntek-author and replaced by every `copier update`: never edit it here. Project-specific rules belong in `.claude/CLAUDE.md` Section 3.

This file owns the repository's shape: its layers, the sublayers inside them, the folder-pair rule,
routing frontmatter, who owns which files, and the order in which to read before working. Every
other file that needs a path routes here rather than restating it.

---

## 1. Layers

| Layer | Kind | Purpose |
|---|---|---|
| `.claude/` | config | The manual (`CLAUDE.md`), these rules, `MEMORY.md`, settings, hooks and skills |
| `planning/` | production | The plan of the work: the outline, one brief per <%UNIT_NOUN%>, decision maps, reviews (advice only) |
| `research/` | production | The evidence base: sources, verified evidence entries, question-led notes |
<: if DOC_TYPE != 'business' :>| `manuscript/` | production | The book itself: one folder per chapter, each holding its promoted prose and a `drafts/` folder |
<: endif :><: if DOC_TYPE == 'business' :>| `library/` | production | The documents themselves, by family: templates, client documents and drafts |
<: endif :><: if DOC_TYPE != 'business' :>| `typeset/` | production | The printed book: the page design, the master file, front and back matter, and each styled chapter beside its Pandoc base |
<: endif :><: if DOC_TYPE != 'business' and INCLUDE_PROPOSAL :>| `proposal/` | production | The package that sells the book: <: if DOC_TYPE == 'theology' :>book proposal, endorsements, sample<: else :>query letter, synopses, comparable titles, submissions, sample<: endif :> |
<: endif :><: if DOC_TYPE == 'fiction' :>| `world/` | production | The story bible: characters, places, the names register<: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>, peoples, cultures, world history and creatures<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>, constructed languages<: endif :> |
<: endif :>| `standards/` | supporting | The rules the prose answers to: style, method, risk, verification<: if INCLUDE_REFERENCES :>, referencing<: endif :><: if DOC_TYPE == 'business' :>, brand<: endif :> |
| `tooling/` | supporting | The build: Pandoc metadata and the house filter, the LaTeX house files, and the scripts behind `make` |
| `handoffs/` | working | Session bridges written by the `handoff` skill; pruned once the work resumes |
| `learning/` | working | The `teach` workspace; nothing in it is the work |
| `assets/` | working | Images and other binaries the work uses |
<: if DOC_TYPE == 'business' and INCLUDE_DRIVE_SYNC :>| `.github/` | config | The Google Drive push and pull workflows |
<: endif :>| `build/` | generated | Everything `make` produces; git-ignored, never hand-edited |

---

## 2. The kinds of layer

- **Production layers** hold content made through repeatable, multi-step procedures, so each one
  splits into the same sublayers (Section 3). A production layer is where the work happens.
- **Supporting layers** (`standards/`, `tooling/`) are consulted or run, not produced inside.
  They stay flat, with topic subfolders; their procedures live in skills.
- **Working folders** (`handoffs/`, `learning/`, `assets/`) sit at the root, outside every build.
  Nothing in `handoffs/` or `learning/` is the work; anything durable they produce graduates to
  `.claude/MEMORY.md`, a unit brief, `research/src/` or `standards/`, and the copy left behind is a
  link, not the answer.
- **Generated** output (`build/`) is derived from sources and never edited by hand.

---

## 3. Sublayers of a production layer

| Sublayer | Holds | Read it for |
|---|---|---|
| `docs/reference/` | Guides shipped by the template, replaced by `copier update` | how this kind of work is done |
| `docs/project/` | The author's own guides; a same-named file here overrides the reference guide | how this project departs |
| `src/` | The artefact: the prose, the plans, the evidence | the work itself |
| `workflows/NN-name/` | Template procedures: `CONTEXT.md` + `CLAUDE.md` + `STEPS.md` + `CHECKLIST.md` | the steps to follow |
| `workflows/local/NN-name/` | The author's procedures, in their own numbering; a same-slug folder overrides the template's | the author's steps |

Template workflow numbers are **frozen and append-only**: a number is never reused or renumbered,
because other files and the author's habits cite it. Gaps are deliberate. The `run-workflow` skill
resolves an intent to a procedure and looks in `workflows/local/` first, and every skill that
carries out a workflow runs the same-slug local procedure instead, where one exists.

---

## 4. The content layer and the unit

**The content layer in this project is `<%CONTENT_LAYER%>/`, and the unit is a <%UNIT_NOUN%>.**
Shared skills and guides say "the content layer" and "the unit"; this section is what they mean.

<: if DOC_TYPE != 'business' :>- **A chapter** is a folder `manuscript/src/NN-kebab-title/` holding `NN-kebab-title.md` (the
  promoted prose) and a `drafts/` folder (work in progress, excluded from every build). Folder
  numbers set the running order.
- **Sections** are promoted into the chapter file in plan order, each anchored by a
  `<!-- section: <slug> -->` marker.
- **The printed book** is set in `typeset/` from the promoted chapter files: `make tex` writes
  each chapter's Pandoc base to `typeset/src/units/.base/`, and the `typeset` skill styles a copy
  in `typeset/src/units/` without retyping a word (`.claude/rules/syntek-author/03-authorship.md`
  Section 10).
<: else :>- **A document** lives in a family under `library/src/<family>/`, where the families are
  `proposals`, `contracts`, `policies`, `correspondence`, `finance` and `marketing`. Each family
  holds `templates/`, `client-docs/<client-slug>/` and `drafts/`.
- **Deliverables** are LaTeX built on the house preamble; correspondence is Markdown. Sections are
  promoted into a `.tex` document between `% section: <slug>` markers, in plan order.
<: endif :>- **A section** is a small passage inside a unit, typically 300 to 500 words: one argument step, one
  scene beat, one clause group (`.claude/rules/syntek-author/03-authorship.md` Section 3).
- **The unit's plan** is its brief in `planning/src/units/`. The brief holds the scope, the
  sections in plan order, the unit's status and its verified gates; the prose never holds the plan.

---

## 5. The folder pair

**Every directory carries a `CONTEXT.md` and a `CLAUDE.md`.** `CONTEXT.md` is orientation: what
is here and why, as a directory tree with `←` notes, then what's here and cross-references. It
would stay true if nobody worked here again. `CLAUDE.md` is operating rules: it opens with
`@./CONTEXT.md`, then a `Read order:` line naming every ancestor pair, then exactly four sections:
`## Purpose (one line)`, `## How to work here` (**Routing**, **Model**, **Concrete steps**,
**Definition of done**), `## Guardrails` and `## Output & naming`.

The exceptions, and why each is exempt:

- `build/` and `.git/` are generated; nothing in them is read for guidance.
- `.claude/rules/` holds rules only: Claude Code loads every Markdown file there at launch, so a
  `CONTEXT.md` placed there would load as a rule.
- The inside of each `.claude/skills/<skill>/` folder: a skill is its own manual.
- Each `drafts/` folder carries only a `README.md`; its parent's pair governs it.
<: if DOC_TYPE != 'business' :>- `typeset/src/units/.base/` carries only a `README.md`: it holds the Pandoc bases `make tex`
  writes, which are never hand-edited, and its parent's pair governs it.
<: endif :>
The repository root's operating file is `.claude/CLAUDE.md`, not a root `CLAUDE.md`.

---

## 6. Routing frontmatter

Guides and workflow files say which skill and model the work needs, in YAML frontmatter above the
H1. **Read it first and obey it.**

| File | Keys |
|---|---|
| Guide (`docs/**/*.md`) | `type: guide` · `skills: [..]` · `model:` |
| `STEPS.md` and `CHECKLIST.md` | `workflow:` · `phase:` · `skills: [..]` · `model:` |
| `CONTEXT.md` and `CLAUDE.md` | none: the pair is navigation, not routing |

`phase` is one of `plan`, `research`, `produce`, `review`, `publish`, `convert` or `author`. There
is no `agent:` key: this project uses skills only. Section drafts and unit briefs carry no
`model:` key; the model tiers are defined once in `.claude/rules/syntek-author/05-model-allocation.md`.

---

## 7. Who owns which files

| Class | What `copier update` does | Files |
|---|---|---|
| **Template-owned** | merges the template's changes in | `.claude/rules/syntek-author/**`, `.claude/skills/<skill>/**`, `.claude/hooks/*.sh`, every `docs/reference/`, every `workflows/NN-name/`, the governance pairs (except the seeded ones below), `standards/` (except the seeds), `tooling/` (except the seeds), `Makefile`, nested `.gitignore` files |
| **Seed-if-missing** | creates the file only if it is absent, then never touches it | listed below |
| **Seed-once example** | ships at generation only; once deleted, stays deleted | the worked example, when one was generated |
| **Author-owned** | never touches | everything you write: `src/` content, the guides in `docs/project/`, the procedures in `workflows/local/`, `handoffs/`, `learning/`, `assets/` |

**Seeds** (yours from the moment they exist; deleting one brings back the empty seed on the next
update; turning its option off deletes it): `README.md`, `CONTEXT.md`, `.gitignore`, `.mcp.json`,
`.claude/CLAUDE.md`, `.claude/CONTEXT.md`, `.claude/MEMORY.md`, `.claude/settings.json`, the
`.claude/skills/` and `.claude/hooks/` pairs, `standards/style/style-sheet.md`,
`standards/style/voice-notes.md`, `standards/style/terminology.md`,
`standards/style/ledger/provenance.md`, `planning/src/outline.md`, the map index
`planning/src/maps/CONTEXT.md`, the `CONTEXT.md` and `CLAUDE.md` of every layer's `docs/project/`
and `workflows/local/` (you add a row to them)<: if DOC_TYPE == 'fiction' :>, `planning/src/causality.md`,
`planning/src/timeline.md`, `planning/src/continuity.md`, `world/src/names-register.md`,
`research/src/permissions.md`<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>,
`world/src/history/eras.md`<: endif :><: if DOC_TYPE != 'business' :>, `typeset/src/page-design.md`,
`typeset/src/book.tex`<: endif :><: if DOC_TYPE == 'theology' and INCLUDE_PROPOSAL :>, the eight
section stubs in `proposal/src/book-proposal/`, `proposal/src/endorsements/tracker.md`,
`proposal/src/sample/sample-index.md`<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_PROPOSAL :>,
`proposal/src/query-letter.md`, `proposal/src/synopsis-short.md`, `proposal/src/synopsis-long.md`,
`proposal/src/comp-titles.md`, `proposal/src/submissions/tracker.md`,
`proposal/src/sample/sample-index.md`<: endif :><: if DOC_TYPE == 'business' :>,
`planning/src/document-register.md`, `planning/src/review-schedule.md`,
`planning/src/precedence.md`, `standards/brand/disclaimers.md`, `standards/brand/brand-voice.md`,
`standards/brand/brand-guide.md`<: endif :><: if INCLUDE_REFERENCES :>, `tooling/seed-refs.sql`<: endif :>.
Before an update turns an option off, see `README.md`, "Turning an option off deletes its files".

<: if SEED_EXAMPLES :>**The worked example** (seed-once; delete it when you no longer need it):

<: if DOC_TYPE != 'business' :>- the example chapter, `manuscript/src/01-example-chapter/`, and its brief,
  `planning/src/units/01-example-chapter.md`<: if DOC_TYPE == 'theology' :>, with its argument map,
  `planning/src/arguments/01-example-chapter.md`<: endif :>;
- the ledger entries of its two sections: the AI-drafted
  `standards/style/ledger/01-example-chapter--the-turn.md`, and the author-drafted, promoted
  `standards/style/ledger/01-example-chapter--opening.md`<: else :>- the example proposal, `library/src/proposals/drafts/example-proposal/`, and its brief,
  `planning/src/units/example-proposal.md`;
- the ledger entry of its AI-drafted section, `standards/style/ledger/example-proposal--scope.md`<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>;
- the example people and culture, `world/src/peoples/example-people.md` and
  `world/src/cultures/example-culture.md`<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>;
- the example language family, `world/src/languages/example-proto/` and its daughter
  `world/src/languages/example-tongue/`, which is also the tooling's test fixture;
- the research notes on their real-world models,
  `research/src/setting/example-model-classical-latin.md`,
  `research/src/setting/example-model-old-spanish.md` and
  `research/src/setting/example-model-ogham.md`<: endif :>.

<: endif :>**Never edit a template-owned file.** The next update either overwrites the edit or turns it into
a merge conflict. Override instead: a same-named guide in `docs/project/`, a same-slug workflow in
`workflows/local/`, or a rule in `.claude/CLAUDE.md` Section 3.

---

## 8. Read order

Before editing anything, read in this order:

1. `.claude/CLAUDE.md`: the project brief. It imports the root `CONTEXT.md`, and these rules load
   with it.
2. `.claude/MEMORY.md`: facts, decisions, feedback, status, open questions and sensitivities.
3. Each ancestor folder's `CONTEXT.md` then `CLAUDE.md`, from the top down.
4. The target folder's `CONTEXT.md` (imported by its `CLAUDE.md`), then its `CLAUDE.md`.
5. The routing frontmatter of the file you are about to open (Section 6).

Every folder `CLAUDE.md` repeats this chain in its own `Read order:` line, so a session that
starts deep in the tree still climbs it.
