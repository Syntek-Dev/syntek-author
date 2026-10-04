# style-sheet.md — the mechanics of this project, as data

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **This file is a seeded stub, and it is deliberately unfinished.** It ships with the project so
> that the skills which route here point at something real from day one. Until the author approves
> an entry (the `spelling`, `grammar` and `learn-voice` skills propose them), every section below
> reads 'No entries yet.' and only the house default stated under each heading applies.

The project's own decisions on spelling, punctuation, numbers, dates and capitals, recorded once
so that every unit makes the same call whoever drafts it and in whatever order. The `spelling`
and `grammar` skills read this file before they report, and an entry here overrides their
defaults. What a word *means* belongs in `terminology.md`; how the work *sounds* belongs in
`voice-notes.md`.

**How to add an entry.** One bullet under the right heading, dated, with the reason, added only
after the author approves it: `- **DD/MM/YYYY** — **'judgement', not 'judgment'.** Except in a
quoted legal citation.` Supersede an entry; never delete one.

---

## Spelling

House default: British English (en_GB): colour, organise, behaviour, recognise, programme;
licence (noun) and license (verb); practice (noun) and practise (verb).

_No entries yet._

## Punctuation

House default: single quotation marks, with double marks for a quotation inside a quotation;
the full stop goes inside the closing mark only when it ends the quoted sentence.

_No entries yet._

## Numbers

House default: none beyond consistency. Record the first decision on words against figures, on
thousands separators and on percentages here, so the second unit does not make a different one.

_No entries yet._

## Dates and times

House default: DD/MM/YYYY in prose; DD-MM-YYYY in filenames; ISO 8601 only in database columns;
24-hour time; 'Section 3.2', never the section sign.

_No entries yet._

## Capitalisation

House default: none beyond consistency. Record each decision with the reason, because
capitalisation choices are the ones a later unit most often reverses by accident.

_No entries yet._

## Project settings

<: if DOC_TYPE == 'fiction' -:>
How the project's own invented words are spelled.

**Invented words.** Names are spelled as in `world/src/names-register.md`, and words of an
invented language as in its lexicon; `spelling` treats both as known words and reports
near-misses of them.
<: else -:>
How the project's settings are written, never what they are. Their values
(<: if DOC_TYPE == 'theology' :>the default Bible translation<: else :>the currency and the jurisdiction<: endif :>) are the answers given
when the project was generated, kept in `.claude/rules/syntek-author/00-project.md` `## Brief`; a
change follows `.claude/rules/syntek-author/06-global-rules.md` Section 11. Where this file and
`00-project.md` differ, `00-project.md` wins.

<: if DOC_TYPE == 'theology' -:>
**Scripture.** Quote the default translation and name it in prose. Another translation is named
at the quotation where it is used.
<: else -:>
**Currency.** Two decimal places, and no space after the symbol.

**Jurisdiction.** Named in every legal document and every legal claim.
<: endif -:>
<: endif -:>
