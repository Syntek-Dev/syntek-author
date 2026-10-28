# CONTEXT.md — learning/

The learning workspace, where <%AUTHOR_FIRST_NAME%> practises a skill (a craft technique, a
method, a part of the publishing or document process) without changing the real work. The rest of
the repository is read freely as reference; every practice draft, worked example and recall note
lands here. This is the one folder whose contents are deliberately **not** real: nothing here is
ever promoted, built, published or sent.
The folder is shared with any companion template applied to this project: each template's
teaching skill keeps its own topics here, and only syntek-author ships this pair.

## Directory Tree

```text
learning/
├── CONTEXT.md          ← this file
├── CLAUDE.md           ← operating rules
├── <topic>/            ← one folder per topic, kebab-case, created at the first lesson
│   ├── MISSION.md      ← why it is being learned, the real goal, its family and its template
│   ├── RESOURCES.md    ← the primary source and the house standard the topic practises against
│   ├── PROGRESS.md     ← the recall log, and each lesson's next-review date
│   └── LESSONS/        ← worked practice: throwaway drafts, examples, recall notes
└── <template>/         ← only beside another template: one per template, holding its new topics
    └── <topic>/        ← laid out as above
```

## What's here

- **Topic folders**, written by each template's teaching skill (this template's is `teach`). The
  families a topic belongs to come from the teaching skill's mode file for this kind of project.
- **Where a new topic goes.** While this template's answers file is the only
  `.copier-answers.<template>.yml` at the project root, `teach` puts a new topic straight under
  this folder. While another template's answers file stands beside it, a new topic of this
  template's goes in `learning/syntek-author/<topic>/`, and each other template's in a folder
  named for it. The teaching skill decides each time it runs; nothing records the answer.
- **A topic stays where it was begun.** A topic is a folder holding a `MISSION.md` or a
  `PROGRESS.md`; no lesson is ever moved into a template's folder or out of one. A folder at the
  top of this one named for a template is that template's folder, never a topic, and no topic is
  named after a template.
- **Each topic names its template.** Each new topic's `MISSION.md` holds a line of its own,
  `Template: <template>`. Beside another template, a topic at the top of this folder without the
  line is <%AUTHOR_FIRST_NAME%>'s to name: the teaching skill asks once, takes the topic's family
  as a hint only, and writes the answer as the line. Which template was applied first decides
  nothing.
- **Another template's topics follow its rules.** Another template's folder, and a topic whose
  `Template:` line names another template, are governed by that template's teaching skill and
  rules, never this template's. Every topic stays <%AUTHOR_FIRST_NAME%>'s work.
- **`PROGRESS.md` is the load-bearing file.** It makes a lesson resumable and carries the spaced
  review schedule: one concept per lesson, recalled unaided, then reviewed after one day, three
  days and seven days.
- **Invented people, places and organisations only.** A practice piece that names a real person
  or a real client will one day be found and read as real.
- **This folder is cumulative.** Unlike `handoffs/`, it is never pruned: the review schedule
  depends on its history.
- No folder below this one carries a `CONTEXT.md` or `CLAUDE.md`: this pair is the folder's only
  manual. The folder is empty apart from this pair until the first lesson.

## Cross-references

- `.claude/skills/teach/SKILL.md` — this template's teaching skill: it runs a lesson, and keeps
  this template's topics, never the folder.
- `.claude/skills/research/SKILL.md` — how a lesson's primary source is established.
- `standards/` — the house rules each lesson practises against.
- `.claude/rules/syntek-author/06-global-rules.md` — the locale and the proofreading discipline
  lessons follow.
- `.claude/rules/<template>/` — where a companion template names its own teaching skill.
