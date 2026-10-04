---
name: clause-consistency
description: >-
  Check a business document, and the family it belongs to, for consistency of its clauses: every
  defined term defined once, bolded once and then used in exactly that form; near-synonyms that
  could stand for a defined term disambiguated; every cross-reference resolving to a real clause
  label; terms agreeing across the family (agreement, statement of work, service levels, order
  form); and the order of precedence stated in each document, in the same words. Gate V5.1 at fact
  check. Use when the author says 'check the defined terms', 'do the cross-references resolve?',
  'is this consistent with the master agreement?', 'which document wins if they conflict?' or
  'I have renumbered the clauses, check it'. Reports by clause; never renames a term or rewords a
  clause. Not whether an obligation is intended or bounded (`obligation-check`); not voice and
  plain English (`tone`); not whether a figure, entity or statute is right (`fact-check`).
---

# Skill: Clause consistency (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

In an instrument, a second word for the same thing invites the argument that it means a second
thing, and a cross-reference to a clause that has moved points the reader at the wrong promise.
This skill builds an inventory of a document's defined terms and cross-references, holds it
against the rest of the document family, and reports every inconsistency by clause. It **reports**:
renaming a term or rewording a clause can change what the document means, so every fix is the
author's decision.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`.
These are the procedure of record — do not restate them at length here.

- `library/workflows/05-review-a-document/` — step 6, where this skill is gate V5.1
  (`standards/verification/BUSINESS.md`).
- `standards/method/BUSINESS.md` — rules 3 (stated precedence) and 4 (defined terms defined once)
  are the rules this skill enforces.
- `library/docs/reference/latex-deliverables.md` — the house `clause` list, `\label{cl:…}` and
  `clause~\ref{…}`; `library/docs/reference/document-anatomy.md` — definitions first, families of
  documents.
- `planning/src/precedence.md` — the order of precedence each family states, mirrored from the
  instruments.

## How to check the clauses

1. **Fix the scope and the family.** Agree with <%AUTHOR_FIRST_NAME%> which document, by its `.tex`
   path in `library/src/`, and read its unit brief in `planning/src/units/`, especially the terms
   table in `## Obligations and defined terms`. Find the document family it belongs to (the
   instruments that rely on one another for one client, which may sit in more than one library
   folder) from `planning/src/precedence.md`, the brief and the client's facts at the client facts
   path in `00-project.md` `## Paths` (by default
   `library/src/business/client-docs/<client-slug>/CONTEXT.md`), and read every document in it that
   this one relies on or is relied on by. Read the skill of the library family its folder sits in,
   `<family>-documents`, for that family's own conventions. Read `standards/style/terminology.md`
   for terms the whole family must use alike. *Complete when:* the document, its brief, its family
   members and the terminology rows in play are named and read.

2. **Build the term inventory.** List every defined term: where it is defined (the definitions
   clause, or inline as `(\textbf{Term})`), every place it is bolded, and every use. A capitalised
   phrase used as a term but defined nowhere is listed too. *Complete when:* every defined or
   apparently defined term has its definition location, bold locations and uses recorded.

3. **Check each term against the rule.** Each term is defined exactly once; bolded only at its
   definition; capitalised on every use; and used in exactly the defined form, singular or plural
   as defined. Flag a term defined twice or defined differently in two places, a term used but
   never defined, a term defined but never used, and bold on a later use. *Complete when:* every
   term in the inventory is marked consistent or carries its findings with clause locations.

4. **Find the near-synonyms.** Look for ordinary words standing in for a defined term ('the work'
   for **the Services**, 'the customer' for **the Client**), and for two defined terms a reader
   could confuse (two kinds of hours, two kinds of incident). Each confusable pair needs a sentence
   that says how they differ and that neither limits the other. *Complete when:* every stand-in
   word and every confusable pair is listed with its locations and whether a disambiguating
   sentence exists.

5. **Check every cross-reference.** Every `clause~\ref{cl:…}` has exactly one matching
   `\label{cl:…}`; labels are unique; a reference to a schedule or annex points at one that exists;
   the word 'clause' is lower-case; a clause referring to itself says so. Render the document with
   `make pdf FILE=<path>.tex` (it runs twice so references resolve) and read the proof for any `??`.
   Emails, letters and proposals that describe a term reproduce its substance, never its clause
   number. *Complete when:* every reference resolves in the proof, or is listed with the label it
   wants.

6. **Hold the terms against the family.** Every term the document shares with its family is
   defined in the same words, or the difference is listed side by side with both locations. A term
   in `standards/style/terminology.md` used here in another sense, or a family term missing from
   terminology, is a finding. *Complete when:* every shared term is marked matching or divergent,
   with both wordings quoted.

7. **Check the precedence.** The document states its family's order of precedence, in the same
   words as its siblings, and that order matches the rows in `planning/src/precedence.md`. An
   order no instrument states is not invented here: it becomes an `AUTHOR TO CONFIRM` flag in the
   instrument that should state it. *Complete when:* precedence is marked stated and matching,
   divergent (with both wordings), or absent (with the flag proposed).

8. **Report and hand back.** Deliver the report below. Change nothing in the document: the author
   decides each fix, and a reworded clause reopens its section through the library's adapt or
   improve workflow and is promoted again, so its ledger stays true. Run as gate V5.1, hand the
   verdict to the review workflow, which dates the gate in the brief's `verified:` map once every
   blocking finding is resolved. *Complete when:* the report is delivered and, for a gate run, the
   review workflow has the verdict.

## The report

Ordered by clause, **blocking first**. A finding is blocking when a term is defined twice or
differently, a cross-reference fails, a family term diverges, or precedence is absent or
contradictory. For each:

- **Location** — the clause label or number and the line in the `.tex`.
- **Term or reference** — exactly as written.
- **Kind** — defined twice · undefined · unused · bold after definition · stand-in word ·
  confusable pair · unresolved reference · family divergence · precedence absent or divergent.
- **Options** — put as choices for the author (keep the definition in clause 1 and replace the
  stand-in at clause 4.2, or define the second sense as a new term), never as a rewritten clause.

Close with a verdict: **V5.1 pass or fail**, and the count of terms and references checked.

## Anti-patterns

- **Renaming a term silently.** Changing 'Services' to 'Work' in thirty places may change what the
  instrument covers; the author decides, clause by clause.
- **Stripping a word from a defined term.** A word that looks like filler inside a defined term is
  part of the term; leave it.
- **Inventing precedence.** An order the instruments do not state is a question for the author,
  never a sentence this skill supplies.
- **Copying another client's terms.** A family is one client's documents; definitions are never
  carried across clients (`standards/risk/BUSINESS.md` rule 1).
- **Citing clause numbers in an email or a letter.** It describes the substance; the clause lives
  in the instrument.
- **Editing a signed or issued document.** A change after issue is a new version
  (`standards/method/BUSINESS.md` rule 8).

## Cross-references

- `standards/method/BUSINESS.md` — rules 3, 4 and 8.
- `standards/verification/BUSINESS.md` — gate V5.1, beside V5.2.
- `standards/style/terminology.md` — the terms the whole family uses alike.
- `planning/src/precedence.md` — the family's order of precedence.
- `tooling/latex/house-preamble.tex` — the `clause` list and label conventions.
- `.claude/skills/obligation-check/SKILL.md` — the obligations those terms carry (V5.2).
- `.claude/skills/fact-check/SKILL.md` — the figures, entities and statutes behind them (V5).
