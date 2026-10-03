# CONTEXT.md — manuscript/docs/reference/

The template's writing guides for the manuscript layer. Each answers one question that comes up
mid-draft, in the same shape (what it is, the practice, how we apply it here, who implements it,
the governing standard), and each defers to a standard or a rules file. They are template-owned:
`copier update` replaces them when the template improves, so nothing written for this book alone
belongs here. Project-specific guides and overrides live in `manuscript/docs/project/`.

## Directory Tree

```text
manuscript/docs/reference/
├── CONTEXT.md                  ← this file
├── CLAUDE.md                   ← operating rules
├── drafting-with-ai.md         ← the authoring loop, who decides what, provenance and disclosure
<: if DOC_TYPE == 'theology' :>├── main-text-and-footnotes.md  ← the two registers, and what never goes in a footnote
<: endif :><: if DOC_TYPE == 'fiction' :>├── scene-craft.md              ← goal, conflict, outcome; point of view; cause and effect
<: endif :>├── section-anatomy.md          ← the chapter, its sections, its markers and its drafts
└── the-status-ladders.md       ← the chapter ladder and the section statuses
```

## What's here

| Guide | The question it answers |
|---|---|
| `manuscript/docs/reference/drafting-with-ai.md` | Who writes what, who decides what, and how is it recorded? |
<: if DOC_TYPE == 'theology' :>| `manuscript/docs/reference/main-text-and-footnotes.md` | Body or footnote? |
<: endif :><: if DOC_TYPE == 'fiction' :>| `manuscript/docs/reference/scene-craft.md` | What makes this beat of the story work on the page? |
<: endif :>| `manuscript/docs/reference/section-anatomy.md` | What is a section, and which file holds what? |
| `manuscript/docs/reference/the-status-ladders.md` | Where is this chapter, and whose hand last shaped this section? |

Three guides are shared by every kind of book and describe the authoring machinery. The fourth
belongs to this project's kind of book and carries the craft its sections most often get wrong.

## Cross-references

- `manuscript/docs/project/` — this book's own guides; a same-named guide there overrides one here.
- `manuscript/workflows/` — the procedures that name these guides on each step.
- `.claude/rules/syntek-author/03-authorship.md` — the authoring rules the shared guides explain.
- `standards/method/method.md` — the method the variant guide applies.
- `standards/verification/verification.md` — the gates behind the status ladder.
