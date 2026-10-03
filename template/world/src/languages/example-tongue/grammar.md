# grammar.md — Example Tongue

The grammar of Example Tongue, recorded only as far as its eleven entries need.
It is the daughter of Example Proto: its words come from the parent's through the ordered changes in `sound-changes.toml`.
Everything not stated here is undecided; nothing should be assumed from silence.

## Sounds in brief

Sixteen consonants (p b t d k g kʷ f h s m n l r w j) and five vowels (a e i o u): twenty-one phonemes, listed in `phonology.toml`.
The syllable shapes are the parent's: `(C)V(K)` or `CLV(K)`.
Stress falls on the second-to-last syllable: HE-bo, mi-BI-ga, he-BA-do.
Between vowels, b, d and g soften to [β], [ð] and [ɣ]: hebado is said [heˈβaðo].
The romanisation spells kʷ as qu and j as y; every other sound is spelled as its IPA symbol, and h is always sounded.

## How it came from Example Proto

Four changes ran in this order, each on the output of the one before (the shape of each follows the model, medieval Castilian; see `language.toml`):

| # | Change | Example |
|---|---|---|
| 1 | final m is lost | *kʷarom > quaro 'river' |
| 2 | final u becomes o | *kelu > kelo 'fire' |
| 3 | p, t and k become b, d and g between vowels | *mipika > mibiga 'pebble' |
| 4 | f becomes h at the start of a word | *fepom > fepo > febo > hebo 'ford' |

The order is history, and it matters in two ways.
Rule 1 must run before rule 2: a parent word ending in -um would first lose its m and then lower its u (*X-um > X-u > X-o), where the other order would leave it ending in u; no word in this small lexicon tests that yet, but `python3 tooling/lexicon.py derive example-tongue --form <ipa>` shows it for any form.
And a word that entered between two rules undergoes only the later ones, which is how the doublet below came about.
Rule 4 touches only a word-initial f, so mipfebo 'bridge' keeps the f inside it.

Three entries show what regular change leaves behind:

- **An irregular word:** by rule 2, *kʷaru 'water' should have become quaro, the same as 'river'.
  Speakers kept the old final u in this one everyday word, so 'water' is quaru: an irregularity that comes out of a sound change.
- **A doublet:** the rites keep older words, as the culture file says.
  Hepom, 'the Crossing', the rite that sets the dead on the water, was borrowed back from the parent's *fepom after rules 1 to 3 had run, so it keeps its m and its p, and only rule 4 touched it.
  The same parent word, inherited, is hebo 'ford'.
- **A gap:** the parent's *kelom 'hearth' would have become kelo, the same as 'fire', and no reflex of it survives; `make derive` proposes it and shows the clash.

## Word formation

The parent's suffixes -om 'place of' and -u 'a thing' both ended up as -o (rules 1 and 2), so neither can make new words any more: hebo is 'ford' and kelo 'fire' as wholes.
New words are made with suffixes of the daughter's own, such as -ri 'one who keeps or tends': hebo + -ri → hebori 'ford-keeper', also 'a go-between'.

## What it marks and what it ignores

It marks formality: a child speaks to any adult with a polite form, and a ford-keeper is addressed by title and the name of the ford (see the culture file).
The polite forms themselves are undecided, so `make coverage` lists the formal 'you' as a pronoun still to make.
It ignores grammatical gender, case and tense, as its parent did.

## Word order

Subject, object, verb, inherited from the parent; no sentence is written yet.

## Decisions to make next

- The pronouns, starting with the polite 'you' the culture needs.
- A plural, if the book needs one.
- A new suffix for places, now that -om is gone.
