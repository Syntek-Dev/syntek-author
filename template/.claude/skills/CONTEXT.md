# CONTEXT.md — .claude/skills/

The project's skills: one folder per skill, each the procedure for one kind of job, from drafting a
section to handing off a session. This file describes how the folder is laid out. The roster
itself (which skills ship in this project, what each does and which carry a mode file) lives in
one place only, `.claude/rules/syntek-author/02-skills.md`, so that it cannot drift from a copy
kept here.

## Directory Tree

```text
.claude/skills/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules for this folder
└── <skill>/              ← one folder per skill, named as the skill (template-owned; see below)
    ├── SKILL.md          ← the procedure: frontmatter, steps, anti-patterns, cross-references
    ├── THEOLOGY.md | FICTION.md | BUSINESS.md   ← this template's one mode file, for a moded skill
    └── <SUB-DOCUMENT>.md ← optional, behind SKILL.md when a skill outgrows 300 lines
```

## What's here

- **Template skills** — every folder listed in `.claude/rules/syntek-author/02-skills.md`. They
  are template-owned: `copier update` replaces them, and the inside of a skill folder carries no
  `CONTEXT.md` or `CLAUDE.md`, because a skill is its own manual.
- **Family-shared skills** — seven of them (`grill-me`, `grill-with-docs`, `grilling`, `handoff`,
  `wait-what`, `wayfinder`, `to-questionnaire`) have a `SKILL.md` that every Syntek template ships
  byte for byte, so a project with two templates keeps one copy. Each update refreshes it while
  it is unchanged; once it is edited, the update leaves it alone and reports it, with the commands
  to compare it and to take the template's copy. It names folders by role, and
  `.claude/rules/syntek-author/02-skills.md` Section 8 gives each role its path here. All seven
  carry the neutral Mode paragraph; `grill-me` and `wait-what` ship no mode file of this template.
- **Mode files** — a moded skill's `SKILL.md` is the same in every kind of project; the domain
  (paths, the unit, extra reads, domain rules, examples) lives in the mode file that ships beside
  it (one per template, beside a family-shared skill: another template's mode files there apply
  only to that template's work, `.claude/rules/syntek-author/02-skills.md` Section 2). A mode file
  applies only beside a `SKILL.md` that carries a Mode paragraph: where the project keeps its own
  skill under a template skill's name, that skill ignores the mode file.
- **The author's own skills** — any folder whose name is not in the roster. They belong to the
  project, and Copier never touches them.
- **Project values** — no skill holds a project's settings. Each reads them, by heading, from
  `.claude/rules/syntek-author/00-project.md`: the reader, the paths, the memory headings, the
  workflow aliases and the overrides.

## Cross-references

- `.claude/rules/syntek-author/02-skills.md` — the roster and the mode-file contract.
- `.claude/rules/syntek-author/06-global-rules.md` — never self-edit (Section 3).
- `.claude/rules/syntek-author/00-project.md` — `## Overrides`, where a project-specific change to
  a skill's behaviour is written, and `## Paths`, which says where project rules live.
