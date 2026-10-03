# FICTION.md — fiction sub-gates

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The gates a unit of fiction must pass in addition to `verification.md`, numbered under the gate
they belong to. V4 (`structural-review → fact-check`) passes only when V4.1 and V4.2 also pass;
V6 (`line-edit → final`) only when V6.1 and V6.2 also pass. Each sub-gate checks a rule of
`standards/method/FICTION.md`, cited by number.

Dates DD/MM/YYYY.

---

## 1. The sub-gates

**Requirement.**

| Gate | Within | Passes when | Run by |
|---|---|---|---|
| **V4.1** | V4 | The prose agrees with the story bible (`world/src/`, `planning/src/timeline.md`, `planning/src/continuity.md` and the names register); every contradiction has been reported and the author has decided which side changes; new facts established in the unit are proposed for the bible with their sections (method rule 6). | `continuity` |
| **V4.2** | V4 | Every beat in the unit cites its cause in `planning/src/causality.md`; no advancement depends on coincidence; every set-up the unit plants is tracked (method rules 1, 4 and 7). | `causality` |
| **V6.1** | V6 | Dialogue and point-of-view narration match each character's voice markers; drift is reported and resolved by the author (method rules 2 and 5). | `character-voice` |
| **V6.2** | V6 | The pacing report (scene length, scene and sequel alternation, tension across the unit) has been read and every item answered by the author (method rule 3). | `pacing` |

**Why this rule exists.** Continuity and causality are structural: fixing them changes scenes, so
they come before the claims are checked. Voice and pacing are judged on finished lines, so they
come last.

---

## 2. Real-world detail is part of V5

**Requirement.** At V5, `fact-check` checks every real-world detail the unit relies on (history,
law, medicine, geography, period detail) under `standards/method/method.md`, exactly as it would
in non-fiction.

**Why this rule exists.** A reader who knows the real detail stops believing the invented ones
the moment the real one is wrong.

---

## 3. Contradictions are reported, never repaired

**Requirement.** V4.1 never passes by a skill silently changing the prose or the bible to make
them agree; each contradiction is put to the author, and the decision is recorded with the
section it concerns.

**Why this rule exists.** The prose may be the author's deliberate change of mind; a silent
repair in either direction can undo it.
