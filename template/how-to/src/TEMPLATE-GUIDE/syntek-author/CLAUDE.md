@./CONTEXT.md

# CLAUDE.md — how-to/src/TEMPLATE-GUIDE/syntek-author/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `how-to/CONTEXT.md` →
`how-to/CLAUDE.md` → `how-to/src/CONTEXT.md` → `how-to/src/CLAUDE.md` →
`how-to/src/TEMPLATE-GUIDE/CONTEXT.md` → `how-to/src/TEMPLATE-GUIDE/CLAUDE.md` → this folder's
`CONTEXT.md` (the chapters and the order to read them in, imported above) → this file.

## Purpose (one line)

Answer how this project works from the chapter that owns the answer, and route to the rule that
decides.

## How to work here

- **Routing:** the table in this folder's `CONTEXT.md` names the chapter for each kind of
  question. Each chapter's 'Where the rules live' names the rules in
  `.claude/rules/syntek-author/`, the guides in `how-to/docs/syntek-author/` and the procedures
  in `how-to/workflows/syntek-author/` behind what it explains, and its 'Next' what to read
  after it. A job a procedure covers is run as the project's rules say a workflow is run, by
  `run-workflow`.
- **Model:** **Opus**: matching a question to the chapter and the rule that own it is judgement,
  and a wrong answer is acted on with full confidence.
- **Concrete steps:** read the table → read the chapter → read the rule it routes to → answer
  from the rule, citing the chapter for the explanation → where the answer is a job, run the
  procedure the chapter names.
- **Definition of done:** the question is answered, the deciding rule is cited, and nothing
  under `how-to/` changed except through the template's update, its recovery and the commands
  its update report prints.

## Guardrails

- **Read-only.** Never edit, write, move or delete a chapter here, even when asked, except
  through syntek-author's update, its recovery and the commands its update report prints for a
  file here (taking the template's version, `git add`, removing a `.rej` file). Claude Code
  denies it, the guide guard (`.claude/hooks/how-to-read-only.sh`) refuses it, and the next
  update puts the file back.
- **The rules win over a chapter.** Where a chapter and a rule in `.claude/rules/syntek-author/`
  differ, follow the rule, with `00-project.md` first, and tell the author both locations.
- **Never quote a chapter as a rule.** Cite the rule as the reason for an action; a chapter only
  explains it.
- **Record a departure in `.claude/rules/syntek-author/00-project.md`**, under `## Overrides`
  (a redirect included) or `## Workflow aliases`, never in a chapter.
- **Never add a chapter here.** The author's own guides and notes go in a layer's
  `docs/project/`, and procedures in its `workflows/local/`.

## Output & naming

- **Writes nothing.** Every chapter here is the template's.
- **Names:** `NN-kebab-title.md`, numbered from 01. Numbers are frozen and append-only, and
  unique across variants, so a variant's chapter keeps its number in every project.
- **Shape:** each chapter opens with its title and a short gloss, carries no header and no
  frontmatter, holds one sentence per line, and ends with 'Where the rules live' and then
  'Next'.
