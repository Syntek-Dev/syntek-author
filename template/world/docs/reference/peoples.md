---
type: guide
skills: [grill-with-docs, create-name]
model: opus
---

# Peoples — what the world's peoples are, beneath their cultures

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** A people file records what a race, species or kind of people is: their bodies,
their lifespans, how many they are, where they live and have lived, and how they stand with the
other peoples. It sits beneath culture. A people is what they are; a culture is how a group of
them lives. Built first, it constrains everything above it: which sounds a language may use, how
fast speech and custom change, how far a culture can spread.

## The file

Each file in `world/src/peoples/` carries frontmatter (`name`, `ipa`, `kind`, `homelands`,
`first_appears`), a depiction note, and these sections, in order:

| Section | What it settles |
|---|---|
| `## What they are` | Human or not, and what sets them apart, in a paragraph |
| `## Body and speech` | Mouth, teeth, breath, voice and hearing: the sounds they can and cannot make or hear |
| `## Lifespan and generations` | How long they live, how long a generation is |
| `## Numbers and spread` | How many, and how thinly or densely they live |
| `## Homelands and movements` | Where they live now and where they came from |
| `## Relations to other peoples` | Alliance, trade, rivalry, conquest, intermarriage |
| `## Role in the story` | The scenes the people shapes |
| `## Continuity facts` | Details the prose has fixed, with section references |

## Body and speech come first

A body sets what a mouth can say and an ear can hear. A people without lips has no sounds made
with them; a people who hear higher than humans may use contrasts a human reader cannot. Write
what is absent as well as what is present, and write 'human, no constraint' when that is the
answer, because a blank invites a guess. Lifespan sets the pace of history: a long-lived people
changes its speech slowly, and its eldest may still use words their grandchildren have lost.

## Peoples, cultures and history

- One people may hold several cultures, and one culture may span peoples. A culture file names
  its people; the people file does not list its cultures, so the link has one home.
- Every move or meeting the people file relies on (a migration, a conquest, first contact) is an
  event in `world/src/history/`, named here by its slug rather than narrated twice.
- With the constructed-language kit, a language names its culture, and so reaches its people:
  language work reads this file before it proposes a sound, and says what is missing if it is thin.

## Depiction: real peoples and hostile peoples

A people drawn from a real ethnic group carries its readers' associations with it. Where the
story casts a people as hostile or 'evil', it must not be a real group in disguise: not in its
looks, its customs, its names or its speech. Give an enemy people reasons and internal variety,
and draw any real-world flavour from ancient or extinct sources, or from blends. The check and
its outcome go in the note under the frontmatter.

## How we apply it here

- Build the people before its culture, and the culture before its language.
- Settle each section with the author through `grill-with-docs`, which records it as it resolves.
- If a later step needs a fact this file cannot give, say what is missing rather than guess.
- Register the people's name with kind `people` before promoted prose uses it.

## Who implements it

- **Skills:** `grill-with-docs` (each section), `create-name` (the people's name).
- **Workflow:** `world/workflows/10-create-a-people/`.

## Governing standard

`standards/method/FICTION.md` owns the story bible as the source of truth;
`standards/risk/FICTION.md` owns depiction risk, including peoples cast as hostile. The standards
own the requirements; this guide owns what a people file holds and why the body comes first.
