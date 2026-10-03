---
type: guide
skills: [causality, continuity]
model: opus
---

# Causality chains — because and therefore, never 'and then'

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** A story moves when each event causes the next: this happens, *therefore* that;
this happens, *but* that. `planning/src/causality.md` records the chain beat by beat, each beat
citing what caused it, so a scene that merely happens next can be seen before it is written
rather than felt by a reader after it is published.

## A beat and its cause

Each row of the chain is one beat:

| Column | Holds |
|---|---|
| ID | `B001`, `B002` …, in order of entry; never renumbered, never reused |
| Beat | What happens, in one sentence |
| Where | The unit and section that carry it |
| Because | The beat ID, the character's decision or the rule of the world that causes it |
| Therefore | What it makes necessary or possible next |

'Then' is not a cause. A beat whose `Because` names only the previous beat in time has not
been charted.

## Coincidence

Chance may get a character into trouble; it may not get them out. A beat whose only cause is
coincidence, and which resolves a problem, is flagged. A coincidence the author keeps on
purpose is recorded as a decision, with its reason, so a later pass does not 'fix' it.

## Setup and payoff

Every setup names its payoff beat, or is marked open. Every payoff names its setup. At the last
unit, an open setup is either a thread the author leaves open deliberately, and says so, or a
dangling one.

## How we apply it here

- Chart a unit's beats once its brief is agreed and before its first section is drafted.
- The chain runs in causal order; in-story time lives in `planning/src/timeline.md`. They
  differ wherever the telling is out of order, and that is allowed.
- A fact a beat establishes goes to `planning/src/continuity.md` with its section reference.
- A contradiction between the chain and the prose is reported, never silently repaired. The
  author decides which one is wrong.
- One sentence per line in every row and note.

## Who implements it

- **Workflow:** `planning/workflows/03-chart-the-causality/`.
- **Skills:** `causality` checks that every beat cites its cause and flags advancement by
  coincidence; `continuity` checks the prose against the facts the chain establishes.

## Governing standard

`standards/method/FICTION.md` owns the story engine: causality, want against need, scene goal,
conflict and outcome, setup and payoff. The standard owns the requirement; this guide owns how
the chain is written down.
