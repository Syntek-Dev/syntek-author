---
name: wayfinder
description: >-
  Chart work too big for one sitting into a decision map, then settle it across sessions. SUGGEST
  mines open questions, open flags and stalled plans for bodies of work worth mapping; CHART pins
  the destination and maps the frontier of open decisions into a MAP-<TOPIC>.md in the decision maps
  folder (by default planning/src/maps/); RESOLVE settles the next batch of related nodes and
  graduates each answer to its real home. Invoke by typing /wayfinder suggest, /wayfinder chart
  <topic> or /wayfinder resolve <map>, or when <%AUTHOR_FIRST_NAME%> says 'map out part two', 'where
  do we even start with the languages?', 'what is left to decide before drafting?' or 'this is too
  big to settle today'. Not for one surface in one sitting (`grill-with-docs`), and it never drafts
  prose (`draft-section`).
---

# Skill: Wayfinder (<%PROJECT_NAME%>)

Wayfinder takes on work too big to hold in one head (a part of the book, a world and its
languages, a programme of documents) and turns the fog into a **map** of open decisions, settled
in related batches across sessions. Instead of charging at an unclear **destination**, it charts
the route first: surface the decisions, order them, then settle them until the way is clear.

**Scope, against grilling.** Grilling sharpens **one** surface in a sitting. Wayfinder maps a
whole body of work's **frontier** and sends batches of related nodes to grilling. Wayfinder is the
cartographer; grilling is the per-node engine. Reach straight for `grill-with-docs` when the work
is one surface.

**The map is a Markdown index, never a vault:** `MAP-<TOPIC>.md` in the decision maps folder
`00-project.md` `## Paths` names (by default `planning/src/maps/MAP-<TOPIC>.md`), registered in
the index table in that folder's `CONTEXT.md`. Detail lives in the brief, note, plan file or
`.claude/MEMORY.md` entry each node links to. Facts are looked up, never asked; only decisions
with a real trade-off go to <%AUTHOR_FIRST_NAME%>.

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

## Governing procedures (route here — do not restate at length)

- `planning/docs/reference/decision-maps.md` — when a map earns its place, its node types, where
  a settled node goes.
- `planning/src/maps/CONTEXT.md` · `planning/src/maps/CLAUDE.md` — the index and the folder's
  rules.
- `.claude/rules/syntek-author/08-naming-and-memory.md` Sections 2 and 3 — where a decision
  lives, and the memory gate.
- `.claude/skills/grilling/SKILL.md` — the round shape every grilling node is settled in.

The mode file names the doc-type procedures that chart with a map.

## Steps

> **Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they disagree, the procedure wins and the disagreement is reported to the author.

A session runs in one of three modes: **SUGGEST** (optional, before there is a topic), **CHART**
(one session) or **RESOLVE** (each later session). Steps are numbered across all three.

### SUGGEST (steps 1 to 3)

1. **Read the unfinished business.** The `Open questions` heading of `.claude/MEMORY.md` (mapped in
   `00-project.md` `## Memory headings`); the output of `make flags` (every `AUTHOR TO CONFIRM` and
   `VERIFY`, and any extra open-item marker `tooling/project.mk` adds); stalled plans (an outline
   row with no brief, a brief that has not moved status, a review in `planning/src/reviews/` whose
   decisions were deferred). *Complete when:* every open item is in view with where it came from.
2. **Cluster into candidate bodies of work.** Group items that share a cause, a surface or a
   dependency: five flags waiting on one undecided reading are one map, not five. An item that one
   grilling sitting would settle is not a map; say so and route it to `grill-with-docs`.
   *Complete when:* every item is in a cluster or routed elsewhere.
3. **Put the candidates, ranked.** For each: what it would settle, why it hangs together, what
   stays open if it is not taken. Rank by how much each unblocks against its size. **Suggest
   only**: write nothing. *Complete when:* <%AUTHOR_FIRST_NAME%> has picked one, deferred them
   all or redirected.

### CHART (steps 4 to 8)

4. **Pin the destination.** Open a `grill-with-docs` pass to say what 'done' looks like in one
   or two lines, and the bounds: what is in, and what is consciously out. Look the repository up
   before asking. *Complete when:* the destination and the out-of-scope bounds are written and
   confirmed.
5. **Map the frontier, breadth first.** Walk every file the work touches (the outline, the
   briefs, the plan files, the research, the files the mode names) and surface every decision
   that can be stated now. Anything too vague to state goes to **Fog of war**. *Complete when:*
   every knowable decision is a node or is parked in Fog of war.
6. **Wire the blocking edges.** In a second pass, give each node its blockers as prose links to
   the nodes it depends on, so the unblocked edge is visible at a glance. *Complete when:* every
   frontier node names its blockers (or 'none') and at least one is unblocked.
7. **Write the map and register it.** Create `MAP-<TOPIC>.md` in the decision maps folder (by
   default `planning/src/maps/MAP-<TOPIC>.md`) in the shape below, tag each frontier node with its
   type, and add a row to the index table in that folder's `CONTEXT.md` (Map · Destination ·
   Frontier open? · Charted).
   *Complete when:* the map exists, is indexed, and reads as a route rather than a store of answers.
8. **Dispatch the research nodes, then stop.** Send research nodes (facts, not decisions) to
   `research` or `fact-check` now; they need no human. Settle nothing else in a chart session.
   *Complete when:* the research nodes are dispatched and the session ends with the frontier
   drawn but unresolved.

### RESOLVE (steps 9 to 13)

9. **Load the map, then re-check what it asserts.** Read the map; open linked files only as
   needed. Re-check every load-bearing claim the next batch leans on (a cited line, a count, a
   status), because a drifted citation still reads plausibly. *Complete when:* the destination and
   the current frontier are in view and the batch's claims are re-checked.
10. **Take the next batch, not the next node.** Start from the author's pick or the unblocked
    frontier, and gather nodes that belong together: a **shared subject**, **mutual dependence**
    (one's answer changes another's) or **shared evidence**. Split off any node with open blockers
    or of another type; parents before dependants. *Complete when:* the batch is named, every
    member is unblocked, and why they belong together is one line.
11. **Settle the batch by type.** Research legs first, so the grilling round opens with the facts
    in hand. Grilling nodes go to `grill-with-docs` as **one** pass: the batch is its first round.
    A prototype node runs `prototype`; a task node is done, or handed to whoever can do it. Any
    node may first be probed with `prototype`. *Complete when:* every node in the batch has a
    decision, made and confirmed.
12. **Graduate each outcome.** Record every settled decision in its real home through the
    graduation table; never leave an answer only on the map. *Complete when:* each outcome lives
    in its home and each `Resolved decisions` entry links to it.
13. **Redraw the frontier once.** Move the batch to `Resolved decisions`, turn Fog-of-war items the
    outcomes sharpened into nodes, re-wire the edges, and update the index row's `Frontier open?`.
    *Complete when:* the frontier shows the new unblocked edge and no settled node remains on it.

## Reference

### The map

```text
# MAP-<TOPIC> — <title>
## Destination           one or two lines: what this body of work reaches
## Notes                 the layers it touches, skills to load, standing preferences
## Resolved decisions    settled; each links to the brief, note, plan file or MEMORY entry it became
## Frontier              open decisions in dependency order; blocking edges as prose links
## Fog of war            in scope, not yet sharp enough to be a node
## Out of scope          consciously ruled out, and why
```

### Node types

- **Research** — a fact: looked up through `research` or `fact-check`, never asked.
- **Prototype** — a rough throwaway passage that raises fidelity on a foggy node (`prototype`).
- **Grilling** — a decision with a real trade-off, settled with the author in `grill-with-docs`.
- **Task** — manual unblocking work: obtaining a source, a permission, a confirmation, a figure.

### Graduation table (step 12)

| A settled decision that is… | Graduates to… |
|---|---|
| project-wide, hard to reverse, surprising without context, a genuine trade-off | `.claude/MEMORY.md`, the `Decisions` heading, through the gate in `grill-with-docs` |
| about what one unit does, its scope or its sections | the unit's brief in `planning/src/units/` |
| about the shape or order of the whole work | `planning/src/outline.md` |
| a checked fact | an evidence entry in `research/src/evidence/`, through `fact-check` |
| an answered question | a note in the research notes folder (by default `research/src/notes/`), through `research` |
| a term | `standards/style/terminology.md` |
| a rule for the whole work | the standard, **author-confirmed**, then noted in `.claude/MEMORY.md` |
| still open and blocking | `.claude/MEMORY.md`, the `Open questions` heading, naming what it blocks |

The mode file adds this project's rows. `grill-with-docs` owns *which* home a decision lands in;
wayfinder only makes sure it lands.

### When each session is done

A **suggest** session, when every open item is clustered and the candidates are put; a **chart**
session, when every knowable decision is on the map and the frontier is ordered; a **resolve**
session, when the batch is settled, graduated and the frontier redrawn. A **map** is done when
Frontier and Fog of war are both empty; it stays as the record.

## Anti-patterns

- **Resolving during a chart session.** Charting draws the frontier; it settles nothing.
- **Storing decision detail on the map.** The map is a low-resolution index.
- **Drafting prose from a map session.** A map spawns work; it does not do it.
- **Asking what the repository can answer**, or settling an empirical node by asking.
- **Grilling the whole body of work in one sitting.** That is what the frontier is for.
- **A map for one surface.** One sitting's worth of decisions is a `grill-with-docs` pass.

## Cross-references

- `.claude/skills/grilling/SKILL.md` · `.claude/skills/grill-with-docs/SKILL.md` — the engine and
  the recorder a grilling node goes to.
- `.claude/skills/research/SKILL.md` · `.claude/skills/fact-check/SKILL.md` — research nodes.
- `.claude/skills/prototype/SKILL.md` — prototype nodes and probes.
- `planning/src/maps/CONTEXT.md` — the index where a map is registered.
- `.claude/MEMORY.md` — the `Open questions` heading that SUGGEST mines, and the `Decisions`
  heading that nodes graduate to (both mapped in `00-project.md` `## Memory headings`).
