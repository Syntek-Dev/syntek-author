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
└── <skill>/              ← one folder per skill, named as the skill (template-owned)
    ├── SKILL.md          ← the procedure: frontmatter, steps, anti-patterns, cross-references
    ├── THEOLOGY.md | FICTION.md | BUSINESS.md   ← the one mode file, for a moded skill
    └── <SUB-DOCUMENT>.md ← optional, behind SKILL.md when a skill outgrows 300 lines
```

## What's here

- **Template skills** — every folder listed in `.claude/rules/syntek-author/02-skills.md`. They
  are template-owned: `copier update` replaces them, and the inside of a skill folder carries no
  `CONTEXT.md` or `CLAUDE.md`, because a skill is its own manual.
- **Mode files** — a moded skill's `SKILL.md` is the same in every kind of project; the domain
  (paths, the unit, extra reads, domain rules, examples) lives in the single mode file that ships
  beside it. A mode file applies only beside a `SKILL.md` that carries the Mode paragraph: where
  the project keeps its own skill under a template skill's name, that skill ignores the mode file.
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
