---
workflow: 08-design-a-script
phase: produce
skills: [design-script, research]
model: opus
---

# CHECKLIST.md — design a script

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `world/docs/reference/writing-systems.md` and the `design-script` skill. Gates cite
> `standards/verification/verification.md` by number; this list never restates them.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] The script's job in the book agreed with the author; for an extension, the missing units named. · _opus_
- [ ] The language's phonology confirmed as settled; otherwise stopped and said so. · _opus_

## Execution Checklist

**Choosing**

- [ ] Read the language's files, the culture's materials and tools, and the contact events in the world history; any gap named, not guessed. · _opus_
- [ ] Two or three script types offered with their fit; one recommended; the author chose. · _opus_
- [ ] **Inspiration asked as its own question: two or three real script families with period and reasoning from medium, tool and origin, one recommended, the author's choice recorded (or none).** · _opus_
- [ ] The chosen family researched and cited; `[meta.inspiration]` written; structure borrowed, never glyphs. · _opus_
- [ ] Direction, layout, positional forms and the em grid fixed in `[meta]`; any `rtl` or `ttb` print caveat told to the author. · _opus_

**Rules before glyphs**

- [ ] Transliteration rules written in every direction, and every headword worked through them, before any glyph was drawn. · _opus_
- [ ] One `[[glyph]]` per unit, every key present, `codepoint` empty unless pinned. · _opus_
- [ ] Checked no existing SVG would be overwritten; if one would, stopped and asked. · _sonnet_
- [ ] One SVG per glyph, named for its `id`: a filled outline in `currentColor` on the em grid, no strokes; `font.py check` passes. · _opus_
- [ ] Numerals, punctuation and diacritics designed, or interim rules and open decisions recorded. · _opus_
- [ ] History, inspiration and design principles written in `script.md`, tied to the history and the roots. · _opus_

**Building and checking**

- [ ] `make font LANG=<slug>` and `make script-sample LANG=<slug>` run; code points pinned if the author asked. · _sonnet_
- [ ] `script.py check` and `make lexicon LANG=<slug>` run; every headword transliterated; those that cannot be written listed with the units they need. · _sonnet_

## Done When

- [ ] **Every headword transliterates through the glyph table, or the gaps are listed and agreed with the author.** · _opus_
- [ ] Every `svg` path in the table names a filled-outline file that passes the check. · _sonnet_
- [ ] Handed back: type, direction, inspiration, glyphs drawn, font and sample, unwritable headwords, print caveat, open decisions. · _opus_
