---
type: guide
skills: [create-creature, create-name]
model: opus
---

# Creatures — a bestiary entry the story can keep

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** A creature in a novel is a set of rules the story promises to keep. The reader
learns what it can do, and the plot later depends on what it cannot. A bestiary entry records
those rules once, with the ecology that makes them believable, so that Chapter 3 and Chapter 20
describe the same animal.

## The entry

Each file in `world/src/creatures/` carries frontmatter (`name`, `ipa`, `kind`,
`first_appears`) and these sections, in order:

| Section | What it settles |
|---|---|
| `## Ecology` | Habitat, diet, what hunts it, life cycle, how many there are |
| `## Anatomy` | Body plan, size, senses, how it moves |
| `## Behaviour` | What it does when hungry, threatened, mating, wounded, alone |
| `## Lore and names` | What each culture believes about it, and what each calls it |
| `## Role in the story` | The scenes it serves, and the job it does in them |
| `## Rules and limits` | What it can never do, and what its abilities cost |
| `## Weaknesses` | What can stop it, and where the book sets that up |
| `## Continuity facts` | Details the prose has fixed, with section references |

## Ecology first

Start with what the creature eats and what eats it. A predator the size of a horse needs a
territory, prey and a reason it has not emptied the valley; a creature with no ecology reads
as a plot device, because it is one. Anatomy follows ecology: senses fit how it hunts, the
body fits where it lives. Strangeness is welcome; arbitrariness is not.

## Rules, limits and weaknesses

Abilities make a creature dangerous; limits make it useful to a plot. Write the limits as hard
rules ('cannot cross running water', 'hunts only by scent') and keep them. A weakness the
climax relies on must be planted earlier, on the page, in a way the reader could have noticed;
link it to its set-up in `planning/src/causality.md`. A rule broken for convenience costs the
reader's trust in every other rule.

## Lore against truth

Keep two lists apart: what people believe about the creature, and what is true. A culture may
be wrong, and its error is a resource for scenes. Mark each belief with who holds it, so that a
character never knows more than their people would.

## How we apply it here

- Check every new creature against the established rules of the world: other creatures,
  places, cultures and `planning/src/continuity.md`. Report a contradiction; never repair it.
- Names for the creature, one per culture that knows it, are registered with kind `creature`.
- A creature tied to a quest links to its file in `planning/src/quests/`.
- Write only the depth the book uses; an unused ability is a promise the plot did not make.

## Who implements it

- **Skill:** `create-creature` (the entry, checked against the world); `create-name` for the
  creature's names.
- **Workflow:** `world/workflows/04-create-a-creature/`.

## Governing standard

`standards/method/FICTION.md` owns set-up and payoff and the story bible as the source of
truth; `standards/verification/FICTION.md` owns the continuity gate. The standards own the
requirements; this guide owns what a bestiary entry holds and why limits come first.
