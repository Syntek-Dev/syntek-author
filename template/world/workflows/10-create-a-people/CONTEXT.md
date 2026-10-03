# CONTEXT.md — world/workflows/10-create-a-people/

The procedure for describing a people: a race, species or kind of people in the world. It
settles what they are, what their bodies are like (above all whatever shapes how they speak and
hear), how long they live, how many they are, where they live and came from, and how they stand
with the other peoples, and it runs the depiction check before anything is built on them. It
ends with a people file that cultures, languages and characters can rest on.

## Directory Tree

```text
world/workflows/10-create-a-people/
├── CHECKLIST.md        ← model-tagged checklist; tick it as you go
├── CLAUDE.md           ← operating rules for this procedure
├── CONTEXT.md          ← this file: when to use it, what it produces
└── STEPS.md            ← the ordered steps, each naming its skill and guide
```

## When to use this

- The story has more than one kind of people, or a people whose bodies, lifespans or past
  matter to a scene.
- A culture or a language is about to be built, and the people who hold it have no file yet.
- The story casts a people as hostile, and that choice needs checking before it hardens.

Reach for a **different** procedure when the job is how a people lives
(`world/workflows/05-create-a-culture/`), one person among them
(`world/workflows/01-create-a-character/`), or the events that moved or mixed them
(`world/workflows/11-chart-the-world-history/`).

## What it produces, and where

- **A people file** at `world/src/peoples/<slug>.md`, with frontmatter and the eight sections:
  What they are, Body and speech, Lifespan and generations, Numbers and spread, Homelands and
  movements, Relations to other peoples, Role in the story, Continuity facts.
- **A depiction note**, an `<!-- INTERNAL NOTE: … -->` directly under the frontmatter, recording
  what the people borrows from real peoples, whether the story casts them as hostile, and the
  outcome of the risk check.
- **A register row** in `world/src/names-register.md`: the people's name, with kind `people`.
- **A list of events to chart:** every migration, conquest or contact the file relies on that
  has no event file yet, handed to `world/workflows/11-chart-the-world-history/`.

## The failure this procedure exists to prevent

The people with no body. When nobody writes down what a people's mouths, ears and lifespans are
like, the gap is filled later by guesswork: a language gains sounds its speakers could never
make, a culture changes faster than its long-lived elders would allow, and a hostile people
quietly takes on a real group's features because nothing said otherwise. Settling the body,
the past and the depiction first gives every later layer something true to stand on.

## Cross-references

- `world/docs/reference/peoples.md` — why body and speech come first; peoples against cultures;
  depiction.
- `world/src/peoples/` — where the file lands, and its skeleton.
- `standards/risk/FICTION.md` — depiction risk, including peoples cast as hostile.
- `world/workflows/05-create-a-culture/` — the next layer up.
