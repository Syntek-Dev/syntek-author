@./CONTEXT.md

# CLAUDE.md — library/docs/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold the guides Claude reads before writing in `library/src/`, split between the template's
reference guides and the author's project guides.

## How to work here

- **Routing:** to read a guide, look in `project/` first, then `reference/`: a same-named project
  guide wins. To add guidance, write it in `project/`. Each guide's routing frontmatter names the
  skills that apply it; read it first and obey it.
- **Model:** **Opus** for reading and writing guides; they carry judgement, not data.
- **Concrete steps:**
  1. Check whether a standard already owns the rule; if so, cite it and stop.
  2. Check `reference/` and `project/` for a guide on the same question.
  3. Write or extend the guide in `project/`, in the guide format below.
- **Definition of done:** the guide answers one question, cites its governing standard, names the
  skills and workflows that implement it, and restates no rule another file owns.

## Guardrails

- **Never edit `reference/`.** It is template-owned. To change how this project works, write a
  same-named guide in `project/`, or extend it there under `## How we apply it here`.
- **Defer, do not restate.** A guide that copies a standard's rule goes stale the day the standard
  changes. Cite the standard by path and section.
- **A guide never outranks a standard.** Where they disagree, the standard wins and the
  disagreement is reported to the author.
- **No documents here.** A draft or a deliverable belongs in `library/src/`.

## Output & naming

- **Hand-written:** guides in the house guide format: routing frontmatter (`type: guide`,
  `skills: […]`, `model: opus`) → `# Title — gloss` → metadata header → `**What it is.**` → two to
  five topic sections → `## How we apply it here` → `## Who implements it` →
  `## Governing standard`. Between 54 and 82 lines.
- **Naming:** kebab-case, named for the question the guide answers.
