---
name: character-voice
description: >-
  Check dialogue and point-of-view narration against each character's voice markers (the
  '## Voice markers' of their file in world/src/characters/) and the narrator's voice in
  standards/style/voice-notes.md, and report drift: a line a character would not say, two
  characters who sound alike, narration that slips into another head or out of the
  point-of-view character's words. Separates drift from a shift the arc plans. Runs gate V6.1 at
  line edit; report only, the author decides every change. Use when the author says 'does Tam
  sound like Tam here?', 'check the dialogue in chapter 6', 'is the voice drifting?', 'run the
  character-voice pass', or 'I think the POV slips in this scene'. Not facts about the
  character (`continuity`), not how the character changes (`chart-character-arc`), not the
  author's own narrative voice from edits (`learn-voice`), not grammar or dialogue punctuation
  (`grammar`).
---

# Skill: Character voice (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

A reader recognises a character by how they speak long before they remember what they look like.
This skill holds every line of dialogue, and every stretch of point-of-view narration, to the voice
markers the author agreed for that character, and reports where the voice drifts. It never rewrites
a line: drift is shown with the marker it breaks, and the author decides whether the line or the
marker changes.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These
are the procedure of record — do not restate them at length here.

- `manuscript/workflows/05-review-a-chapter/` — the line-edit stage, where this skill runs gate V6.1
  (step 11).
- `world/workflows/01-create-a-character/` — where voice markers are set (step 5); a missing or
  untestable marker goes back there.
- `standards/method/FICTION.md` — rules 2 (want against need, which the voice carries) and 5
  (point-of-view discipline).
- `standards/verification/FICTION.md` — gate V6.1.
- `standards/style/voice-notes.md` — the narrator's voice and how narration shifts with the
  point-of-view character.
- `planning/docs/reference/character-arcs.md` — where a voice is meant to shift.
- `manuscript/docs/reference/scene-craft.md` — one point of view per scene; filtering through it.

## How to check a character's voice

1. **Fix the scope and the point of view.** Agree the chapter or section with the author and the
   occasion (gate V6.1, or an earlier check of a draft). From the brief and the draft notes, name
   the point-of-view character of each scene and every character who speaks. *Complete when:* each
   scene in scope has a named point-of-view character and a list of speakers.

2. **Load the markers.** Read the `## Voice markers` (and the example lines) of each speaker's file
   in `world/src/characters/`, the narrator section of `standards/style/voice-notes.md`, and
   `standards/style/style-sheet.md` for dialogue punctuation and any dialect spellings it allows.
   Read each speaker's arc in `planning/src/arcs/` for the beats that fall in scope, because a
   planned shift is not drift. A speaker with no file, or with markers too vague to test ('speaks
   formally'), is listed; never invent markers to check against. *Complete when:* every speaker has
   testable markers loaded, or is listed as missing them.

3. **Run the dialogue pass.** Attribute each line to its speaker, then test it against that
   speaker's markers: diction and register, sentence length, habits of address, what they never say,
   contractions, dialect forms, verbal tics. Note the cause where a departure might be deliberate
   (anger, disguise, speaking to a child, a planned arc beat). *Complete when:* every line of
   dialogue in scope has been attributed and tested.

4. **Run the narration pass.** Within each scene, the narration may know, perceive and name only
   what the point-of-view character can (method rule 5). Flag a head-hop, an observation the
   character could not make, a word the character would never use in free indirect passages, and
   narration whose register departs from the narrator section of the voice notes. *Complete when:*
   every scene's narration has been read against its point-of-view character.

5. **Test distinctness.** Cover the speech tags and ask whether each speaker could still be told
   apart. Flag pairs who share a register, a rhythm or a habit that neither marker gives them.
   *Complete when:* every pair of speakers who share a scene has been compared.

6. **Report, and change nothing.** One table, point-of-view slips first, with the columns number,
   where, speaker or narrator, the line (a short quotation), the marker it breaks, drift or a
   possible deliberate shift, and the question for the author. Offer a direction for the fix, never
   a rewritten line unless the author asks for alternatives. *Complete when:* the report is
   delivered and no prose has been edited.

7. **Record each answer, then hand the gate back.** For each item the author decides: a line to
   change goes back through the content layer's adapt or improve workflow and is promoted again; a
   marker to change, or a new one, is written into the character's file only on the author's word; a
   deliberate shift the arc did not show is added to the arc's beats with the author. Gate V6.1
   passes when every item has an answer; report the result to the review workflow, which dates the
   gate. *Complete when:* every item carries a dated decision and the review workflow has the
   result.

## Anti-patterns

- **Rewriting the line.** The report names the marker and the drift; the author writes the fix.
- **Checking against an impression.** 'He would not say that' is an opinion until a marker says so.
  If the markers cannot settle it, the finding is that the markers need work.
- **Flattening every voice to the markers.** People speak differently when frightened, drunk, lying
  or tender. Ask whether a departure is drift or the scene doing its job.
- **Missing the planned shift.** A voice that changes where the arc says it should is the arc
  working; flag only the change that comes early, late or never.
- **Judging the author's narration as a character.** The narrator's voice lives in the voice notes;
  a character's markers apply to narration only through the point-of-view filter.
- **Editing the character file in passing.** Markers belong to the author and change on their word
  through the character workflow.

## Cross-references

- `world/src/characters/` — each character's voice markers and example lines.
- `planning/src/arcs/` — where each voice is meant to shift.
- `standards/style/voice-notes.md` — the narrator's voice.
- `.claude/skills/chart-character-arc/SKILL.md` — the arc a shift belongs to.
- `.claude/skills/continuity/SKILL.md` — facts about the character, at gate V4.1.
- `.claude/skills/pacing/SKILL.md` — the other line-edit gate, V6.2.
- `.claude/skills/learn-voice/SKILL.md` — the author's own voice, mined from their edits.
- `.claude/skills/adapt-section/SKILL.md` — where an agreed change to a line is made.
