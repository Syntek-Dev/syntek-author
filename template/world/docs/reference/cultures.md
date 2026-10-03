---
type: guide
skills: [create-name]
model: opus
---

# Cultures — a people the reader can believe in

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** A culture file records how a people live, what they value and how they name
things, so that every character from that people behaves like someone raised there. A culture
is not a costume: values produce customs, and geography and work shape both. Built in that
order, a culture can answer questions the author has not asked yet.

## The file

Each file in `world/src/cultures/` carries frontmatter (`name`, `ipa`, `people`, `homeland`,
`first_appears`) and these sections, in order. `people` names the file in `world/src/peoples/`
that says what the culture's people are; their bodies and lifespans are recorded there, once.

| Section | What it settles |
|---|---|
| `## Land and livelihood` | Where they live, climate, food, work, trade, tools |
| `## Values and taboos` | What they prize, what shames them, what they fear |
| `## Beliefs and rites` | What they hold true; births, coming of age, marriage, death |
| `## Power and kinship` | Who decides, how families are reckoned, how law is kept |
| `## Customs` | Hospitality, greeting, dress, food, quarrel and reconciliation |
| `## Naming customs` | How people are named, by whom, and when a name changes |
| `## Variety and neighbours` | Factions, classes, dissenters; relations with other peoples |
| `## Role in the story` | The scenes the culture shapes, and how |
| `## Continuity facts` | Details the prose has fixed, with section references |

## From ground to custom

Start with the land and the work. A people who herd move; a people who farm stay and quarrel
over boundaries; a people who trade learn other languages. Values follow from what survival
demanded, and customs are values made habitual. When a custom has no reason behind it, find
one or cut it: the reason is what lets a character break the custom meaningfully.

## What speech and writing take from a culture

Language work reads a culture before it proposes anything. Values show where vocabulary must run
deep; power and kinship show how rank is spoken to (honorifics, polite forms); beliefs and rites
show which words are sacred and what older forms survive in them; the materials and tools of
land and livelihood show what a script would first be written on, and with what. Write these
down plainly, so nobody has to guess them later.

## No monocultures

A people is not one person. Give every culture internal disagreement: the old against the
young, the city against the hills, the devout against the practical. A character who departs
from their culture's values is more interesting than one who embodies them, and the departure
only reads if the norm is clear.

## Real-world borrowing

Most invented cultures borrow from real ones. Borrow with care: a single real people reduced
to one trait, or a sacred practice used as decoration, is a depiction risk. Check the culture
against the risk standard before it reaches the prose, and record what was borrowed and why.

## How we apply it here

- Build the people first, then the culture in the order of the file: land, values, beliefs,
  power, customs, names.
- Draft the naming customs with `create-name`, test them on five sample names, and register
  only the names the book will use.
- Characters from the culture link to its file; their voice markers should show its values.
- Contradictions with existing characters, places or prose are reported, never repaired.

## Who implements it

- **Skill:** `create-name` for the naming customs and sample names; the rest is built with the
  author, step by step.
- **Workflow:** `world/workflows/05-create-a-culture/`.

## Governing standard

`standards/method/FICTION.md` owns the story bible as the source of truth;
`standards/risk/FICTION.md` owns depiction risk. The standards own the requirements; this guide
owns how a culture is built so that its people behave consistently.
