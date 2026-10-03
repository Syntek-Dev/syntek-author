# grammar.md — Example Proto

The reconstructed grammar of Example Proto, recorded only as far as its eighteen entries and its daughter need.
Every form is reconstructed: in prose about the language's history it carries an asterisk (*fepom), and nobody in the book speaks it.
Everything not stated here is undecided; nothing should be assumed from silence.

## Sounds in brief

Fifteen consonants (p b t d k g kʷ f s m n l r w j) and five vowels (a e i o u): twenty phonemes, listed in `phonology.toml`.
A syllable is an optional consonant, a vowel and an optional closing consonant, or a stop or f followed by l or r, a vowel and an optional closing consonant: `(C)V(K)` or `CLV(K)`.
Only p, t, k, s, m, n, l and r close a syllable; w and j never do.
Stress falls on the second-to-last syllable: FE-pom, mi-PI-ka.
Before k, g and kʷ, n is pronounced [ŋ]; no reconstructed word shows it yet.
The romanisation spells kʷ as qu and j as y; every other sound is spelled as its IPA symbol.

The model is Classical Latin's sound, and only its sound (see `language.toml` and the research note it cites): five vowel qualities, kʷ as one sound, and stop-plus-liquid onsets.
Vowel length and the Latin accent rule are deliberately not taken.

## Word formation

Words are built from a root and a suffix, and the suffix decides what kind of word results.

| Suffix | Makes | Example |
|---|---|---|
| -u | a plain noun: the thing itself | kel 'burn' + -u → kelu 'fire' |
| -om | a noun of place: where it happens | fep 'cross' + -om → fepom 'ford' |
| -atu | an adjective of a finished action, or a noun of what it left | fep + -atu → fepatu 'crossed over; the far bank' |
| -ika | a small or dear thing | mip 'stone' + -ika → mipika 'pebble' |

A compound puts the modifier first and the head last: mip 'stone' + fepom 'ford' → mipfepom 'a crossing on stepping stones'.

## What it marks and what it ignores

It marks nothing by inflection that the entries show, so `language.toml` lists no `marks` yet.
It ignores grammatical gender, case and tense: nouns have one form, the order of words shows who does what, and time is left to context.

## Word order

Subject, object, verb, as in its daughter; no sentence is reconstructed yet.

## Pronouns

None are reconstructed; `make coverage` lists the pronoun cells still empty.

## Decisions to make next

- Pronouns, once the daughter's pronouns need a history.
- Whether the proto-language had a plural that the daughter lost.
