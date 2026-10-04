---
type: guide
skills: [wayfinder, grill-with-docs]
model: opus
---

# Decision maps — charting work too big for one sitting

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** Some bodies of work hold more open decisions than one grilling session can
settle: a part of the book, a programme of documents, a unit's evidence base. A decision map
charts those decisions in dependency order, so each later session takes the next batch of
related, unblocked nodes, settles them, and sends each answer to its real home. The map is an
index, never a vault.

## When a map earns its place

- Several decisions block one another, and the order in which they are settled matters.
- The work will run across sessions, and a fresh session must know where to start.
- One `grill-with-docs` sitting cannot hold it all. When one sitting can, grill instead.

## What a map holds

`planning/src/maps/MAP-<TOPIC>.md`, with at least these sections: `## Destination` (what the
work reaches) · `## Notes` (layers touched, skills to load, standing preferences) ·
`## Resolved decisions` (each linked to the artefact it became) · `## Frontier` (open decisions
in dependency order) · `## Fog of war` (in scope, not yet sharp) · `## Out of scope` (ruled out,
and why). The `wayfinder` skill owns the exact format.

## Node types

| Type | Settled by |
|---|---|
| research | Looking it up — `research` or `fact-check`; never asked of the author |
| prototype | A rough, throwaway passage that raises fidelity — `prototype` |
| grilling | One `grill-with-docs` sitting with the author |
| task | Manual unblocking work the author or a session does |

## Where a settled node goes

A decision goes to `.claude/MEMORY.md` `Decisions` (mapped in `00-project.md`
`## Memory headings`); a unit's plan to its brief; a fact to `research/src/evidence/`; a term to
`standards/style/terminology.md`; a change of order to `planning/src/outline.md`. The map keeps
the link, not the answer; a decision living only on a map will be argued again.

## How we apply it here

- One map per body of work, registered in the index table in `planning/src/maps/CONTEXT.md`.
- Never resolve during a chart session: charting draws the frontier and settles nothing.
- Never draft prose from a map session. A map spawns work; it does not do it.
- Close a map when its Frontier and Fog of war are both empty, and leave it as the record.
- A decision map is a route to deciding the work; a structural plan describes the work itself.

## Who implements it

- **Skill:** `wayfinder` charts and resolves maps, and suggests where one is wanted from MEMORY
  `Open questions` (mapped in `00-project.md` `## Memory headings`) and the open flags.
  `grill-with-docs`, `research` and `prototype` settle the nodes of their type.

## Governing standard

`.claude/skills/wayfinder/SKILL.md` owns the procedure and the map format;
`.claude/rules/syntek-author/08-naming-and-memory.md` owns where decisions are kept. The skill
owns the method; this guide owns when to reach for it.
