# CONTEXT.md — learning/

The learning workspace, where <%AUTHOR_FIRST_NAME%> practises a skill (a craft technique, a
method, a part of the publishing or document process) without changing the real work. The rest of
the repository is read freely as reference; every practice draft, worked example and recall note
lands here. This is the one folder whose contents are deliberately **not** real: nothing here is
ever promoted, built, published or sent.

## Directory Tree

```text
learning/
├── CONTEXT.md          ← this file
├── CLAUDE.md           ← operating rules
└── <topic>/            ← one folder per topic, kebab-case, created at the first lesson
    ├── MISSION.md      ← why this is being learned, the real goal behind it, and its family
    ├── RESOURCES.md    ← the primary source and the house standard the topic practises against
    ├── PROGRESS.md     ← the recall log, and each lesson's next-review date
    └── LESSONS/        ← worked practice: throwaway drafts, examples, recall notes
```

## What's here

- **Topic folders**, written by the `teach` skill. The families a topic belongs to come from the
  skill's mode file for this kind of project.
- **`PROGRESS.md` is the load-bearing file.** It makes a lesson resumable and carries the spaced
  review schedule: one concept per lesson, recalled unaided, then reviewed after one day, three
  days and seven days.
- **Invented people, places and organisations only.** A practice piece that names a real person
  or a real client will one day be found and read as real.
- **This folder is cumulative.** Unlike `handoffs/`, it is never pruned: the review schedule
  depends on its history.
- The folder is empty apart from this pair until the first lesson.

## Cross-references

- `.claude/skills/teach/SKILL.md` — the skill that runs a lesson and owns this folder.
- `.claude/skills/research/SKILL.md` — how a lesson's primary source is established.
- `standards/` — the house rules each lesson practises against.
- `.claude/rules/syntek-author/06-global-rules.md` — the locale and the proofreading discipline
  lessons follow.
