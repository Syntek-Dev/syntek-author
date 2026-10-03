---
type: guide
skills: [draft-section, promote-section, run-workflow]
model: opus
---

# Section anatomy — the chapter, its sections and the files that hold them

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** A chapter is planned whole and written in sections: passages of 300–500 words that
each do one job (one step of an argument, one beat of a scene), small enough for the author to
judge every sentence. The chapter file is assembled from approved sections, in plan order.

## Three places, one chapter

| What | Where | Holds |
|---|---|---|
| The plan | `planning/src/units/NN-kebab-title.md` | the brief, the `sections:` list (slug, purpose, status), the chapter's status and its `verified:` record |
| The prose | `manuscript/src/NN-kebab-title/NN-kebab-title.md` | an H1 title, one marker per planned section, the promoted text |
| Work in progress | `manuscript/src/NN-kebab-title/drafts/` | `README.md` and one `<NN>-<section-slug>.md` per section in progress, `<NN>` being its `order` |

Plan and prose never share a file. The unit slug (in the ledger, in a draft's `unit:` key) is
the chapter folder's name, number included.

## The chapter file

```markdown
# The Chapter Title

<!-- section: first-section-slug -->

Promoted prose, one sentence per line.

<!-- section: second-section-slug -->
```

- One marker per section in the brief's `sections:` list, in the same order. A section's text runs
  from its marker to the next marker; an empty marker is a section not yet promoted.
- Markers never render. No frontmatter: the chapter's metadata lives in its brief.

## The section draft

```yaml
---
unit: 03-kebab-title        # the chapter folder name
section: section-slug       # kebab-case, unique in the chapter
order: 4                    # its position in the brief's sections list
status: ai-draft            # see the-status-ladders.md
origin: ai                  # ai | author
words_target: 400
ledger: standards/style/ledger/03-kebab-title--section-slug.md
last_updated: DD/MM/YYYY
---
```

The body is the section's prose alone: no heading, one sentence per line, flags inline. An
authorised deviation goes in an `<!-- INTERNAL NOTE: … -->` under the frontmatter, so a later pass
does not 'correct' it. A prose experiment is a `SPIKE-<slug>.md` here; no draft reaches a build.

## How we apply it here

- **One job per section.** A purpose that needs an 'and' is two sections; under 300 words is
  usually a transition that belongs to a neighbour. Split or merge in the brief, then the markers.
- **A slug is fixed once it has a ledger entry.** Renaming one renames its marker, draft, ledger
  entry and brief row together, with the author's agreement.
- **One sentence per line** under `manuscript/src/`, applied when a paragraph is edited.

## Who implements it

- **Skills:** `draft-section` writes drafts (and a missing chapter folder); `promote-section`
  builds the chapter file from the brief and fills each marker; `run-workflow` finds 'the next
  section' in the brief's `sections:` list.
- **Workflows:** `manuscript/workflows/01-draft-a-section/`,
  `manuscript/workflows/04-promote-a-section/`.

## Governing standard

`.claude/rules/syntek-author/03-authorship.md` owns section size and the authoring loop;
`.claude/rules/syntek-author/06-global-rules.md` owns one sentence per line. The rules own the
requirements; this guide owns the shape of the files that carry them.
