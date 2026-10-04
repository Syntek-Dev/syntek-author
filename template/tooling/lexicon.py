#!/usr/bin/env python3
"""lexicon.py: check, derive and report on the project's constructed languages.

Usage:
    python3 tooling/lexicon.py check [LANG]
    python3 tooling/lexicon.py derive [LANG] [--trace] [--form IPA]
    python3 tooling/lexicon.py surface LANG TEXT [--headword]
    python3 tooling/lexicon.py coverage [LANG] [--strict]
    python3 tooling/lexicon.py family
    python3 tooling/lexicon.py glossary [LANG] [--out FILE | --out-dir DIR] [--force]
    python3 tooling/lexicon.py names [LANG] [--register FILE]
    python3 tooling/lexicon.py density PATH... [--lang LANG] [--max 3] [--strict]
    python3 tooling/lexicon.py --self-test
    (every subcommand also takes --languages DIR; default world/src/languages)

LANG is a language folder's name under the languages folder (its slug), or a path to one.
Where LANG is optional, leaving it out means every language.

check     language.toml (kind, parent, culture, real-world inspirations: a language with
          none is warned); phonology.toml (inventory size outside 20-35 warned; classes;
          syllable templates, one or a list; onset and coda clusters; forbidden sequences;
          stress rule; allophones; romanisation one spelling per sound unless listed in
          [romanisation.exceptions]; apostrophe and diacritic density); sound-changes.toml
          for a daughter; then every word: missing fields, duplicates, the IPA against the
          phonotactics (loanwords included; a root or affix, which need not be a word on
          its own, only against the inventory and the forbidden sequences), stress marks
          against the rule, the headword against its IPA, roots, affixes and compounds that
          must exist, strata and entered_after, loans, irregulars, echoes, and the native
          field against the script's transliteration.
derive    For each daughter: applies sound-changes.toml in order to each word's proto_form
          (a loan starts from its loan_source and undergoes only the rules after
          entered_after), reports every word whose IPA differs unless irregular = true, and
          proposes reflexes for parent words that have none. --form derives one parent form.
surface   Phonemic IPA -> phonetic: allophone rules in order, then the stress mark. With
          --headword, TEXT is romanised words looked up in the lexicon.
coverage  Core concepts and pronoun cells (tooling/data/core-concepts.toml) without a word.
family    Every family tree, with each language's kind, parent and real-world models.
glossary  A Markdown glossary and pronunciation guide (default build/glossary-LANG.md).
names     The names register against each source language's phonotactics and spelling.
density   Restraint on the page: paragraphs with more than --max (3) distinct unglossed
          conlang words, counting [word]{.conlang ...} spans and bare lexicon headwords.
--self-test  Proves the checks still separate, on a small language built in a temporary folder.

Every string read (TOML, the names register, Markdown, the command line) is NFC-normalised
first, so a decomposed symbol typed on an IPA keyboard or a Mac matches its precomposed form.

Formats: world/docs/reference/lexicon-format.md and building-a-language.md.
Standard library only; Python 3.11+ (tomllib).
Exit codes: 0 = clean (warnings and proposals may be printed); 1 = problems found;
2 = usage error, or a file is missing or cannot be parsed.
"""
from __future__ import annotations

import argparse
import datetime
import re
import sys
import unicodedata
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from conlang_common import (DEFAULT_CONCEPTS, DEFAULT_LANGUAGES, DEFAULT_REGISTER,  # noqa: E402
                            ROOT, Fatal, ensure_parent, language_dirs, load_toml, nfc_args,
                            read_text, resolve_language, shown)

STRESS_MARKS = "ˈˌ"
MARKERS = {"ˈ", "ˌ", "."}
STRESS_RULES = {"initial": "the first syllable", "final": "the last syllable",
                "penultimate": "the second-to-last syllable",
                "antepenultimate": "the third-to-last syllable"}
LEXICAL = {"lexical", "free"}
KINDS = ("proto", "daughter", "isolate")
PERIODS = ("ancient", "classical", "medieval", "early-modern", "modern")
WEIGHTS = ("primary", "secondary", "accent")
BORROWS = ("phonology", "phonotactics", "prosody", "morphology", "syntax", "naming", "aesthetic")
WORD_ORDERS = ("SOV", "SVO", "VSO", "VOS", "OVS", "OSV", "free")
MORPHOLOGIES = ("isolating", "agglutinative", "fusional", "polysynthetic")
POS = ("noun", "verb", "adjective", "adverb", "pronoun", "numeral", "particle", "conjunction",
       "adposition", "determiner", "interjection", "affix", "root", "name")
STRATA = ("inherited", "early-loan", "late-loan", "coinage")
WORD_KEYS = ("headword", "ipa", "pos", "senses", "concept", "roots", "affixes", "compound_of",
             "proto_form", "drift", "loan_from", "loan_source", "irregular", "stratum",
             "entered_after", "echo", "derived", "native", "first_used", "notes")
REQUIRED = ("headword", "ipa", "pos", "senses")
DAUGHTER_ONLY = ("proto_form", "entered_after")
LISTS = ("senses", "roots", "affixes", "compound_of", "derived")
SIZE_RANGE = (20, 35)
DIACRITIC_SHARE = 1 / 3      # warn when more than this share of headwords carry a diacritic
APOSTROPHE_SHARE = 0.10      # warn when more than this share of headwords carry an apostrophe
APOSTROPHES = "'’ʼ"


class Report:
    def __init__(self, label: str):
        self.label, self.errors, self.warnings, self.notes = label, [], [], []

    def error(self, where: str, msg: str):
        self.errors.append(f"{where}: {msg}")

    def warn(self, where: str, msg: str):
        self.warnings.append(f"{where}: {msg}")

    def print(self, summary: str) -> int:
        for msg in self.errors:
            print(f"  error   {msg}")
        for msg in self.warnings:
            print(f"  warning {msg}")
        for msg in self.notes:
            print(f"  {msg}")
        e, w = len(self.errors), len(self.warnings)
        print(f"{self.label}: {summary}; {e} error{'s' * (e != 1)}, {w} warning{'s' * (w != 1)}")
        return 1 if e else 0


def clean_ipa(ipa) -> str:
    """Broad IPA without slashes or brackets; stress marks and dots are kept."""
    s = str(ipa or "").strip()
    if len(s) >= 2 and s[0] + s[-1] in ("//", "[]"):
        s = s[1:-1]
    return s.strip()


def bare(ipa) -> str:
    """IPA without slashes, stress marks, syllable dots or spaces: the phonemes alone."""
    return re.sub(r"[.ˈˌ\s]", "", clean_ipa(ipa))


def form_key(text) -> str:
    """A root or affix as written in a reference: no asterisk, hyphen or stress, case-folded."""
    return re.sub(r"[*\-ˈˌ.\s/]", "", str(text or "")).casefold()


def kebab(text: str) -> str:
    return re.sub(r"[^a-z0-9]+", "-", text.casefold()).strip("-")


def as_list(value) -> list:
    if isinstance(value, list):
        return [str(v).strip() for v in value if str(v).strip()]
    return [str(value).strip()] if str(value or "").strip() else []


class Tokens:
    """Greedy longest-match segmentation over a set of symbols."""

    def __init__(self, symbols):
        self.symbols = sorted({s for s in symbols if s}, key=len, reverse=True)

    def split(self, text: str, strict: bool = True) -> list:
        out, i = [], 0
        while i < len(text):
            ch = text[i]
            if ch.isspace():
                i += 1
                continue
            if ch in MARKERS:
                out.append(ch)
                i += 1
                continue
            sym = next((s for s in self.symbols if text.startswith(s, i)), None)
            if not sym:
                if strict:
                    raise ValueError(f"{ch!r} at position {i + 1} is not in the inventory")
                sym = ch
            out.append(sym)
            i += len(sym)
        return out


# ── The rule engine: sound changes and allophones share one notation ───────────────────────
#
# from:  a phoneme sequence, a class letter, or a list of alternatives
# to:    a phoneme sequence ('' or '∅' deletes), a class letter, or a list parallel to from
# env:   '_' marks the target; '#' a word boundary; a single capital letter a class;
#        {a,e,i} a set; anything else a phoneme. A list of envs means any of them.

BOUND = ("#",)


class Rule:
    def __init__(self, n: int, data: dict, toks: Tokens, classes: dict, label: str):
        self.n, self.label = n, label
        self.note = str(data.get("note", "") or "")
        self.problems = []
        self.frm = self._alternatives(data.get("from"), toks, classes, "from")
        if not self.frm:
            self.problems.append("from is missing or empty")
        to = data.get("to", "")
        to_alts = self._alternatives(to, toks, classes, "to", allow_empty=True)
        if len(to_alts) == 1:
            self.to = to_alts * max(1, len(self.frm))
        elif len(to_alts) == len(self.frm):
            self.to = to_alts
        else:
            self.to = [()] * len(self.frm)
            self.problems.append(f"to has {len(to_alts)} alternatives but from has {len(self.frm)}"
                                 f"; give one replacement or a parallel list")
        envs = data.get("env", "")
        envs = envs if isinstance(envs, list) else [envs]
        self.envs = []
        for env in envs:
            try:
                self.envs.append(self._env(str(env or "_"), toks, classes))
            except ValueError as err:
                self.problems.append(f"env {env!r}: {err}")
        self.text = self._describe(data)

    @staticmethod
    def _describe(data):
        def show(v):
            return "[" + ", ".join(map(str, v)) + "]" if isinstance(v, list) else (str(v) or "∅")
        env = data.get("env", "") or "_"
        env = " or ".join(map(str, env)) if isinstance(env, list) else env
        return f"{show(data.get('from', ''))} > {show(data.get('to', ''))} / {env}"

    def _alternatives(self, value, toks, classes, key, allow_empty=False):
        if isinstance(value, list):
            items = [str(v) for v in value]
        elif isinstance(value, str) and value.strip() in classes:
            items = list(classes[value.strip()])
        elif value is None:
            items = []
        else:
            items = [str(value)]
        out = []
        for item in items:
            item = item.strip()
            if item in ("", "∅", "0"):
                if allow_empty:
                    out.append(())
                continue
            try:
                out.append(tuple(t for t in toks.split(item) if t not in MARKERS))
            except ValueError as err:
                self.problems.append(f"{key} {item!r}: {err}")
        return sorted(out, key=len, reverse=True) if key == "from" else out

    @staticmethod
    def _env(env: str, toks: Tokens, classes: dict):
        env = env.replace(" ", "")
        if env.count("_") != 1:
            raise ValueError("needs exactly one '_' marking the target")
        left, right = env.split("_")
        left, right = Rule._elements(left, toks, classes), Rule._elements(right, toks, classes)
        if BOUND in left[1:] or BOUND in right[:-1]:
            raise ValueError("'#' may only stand at the outer edge of the environment")
        return left, right

    @staticmethod
    def _elements(text: str, toks: Tokens, classes: dict):
        out, i = [], 0
        while i < len(text):
            ch = text[i]
            if ch == "#":
                out.append(BOUND)
                i += 1
            elif ch == "{":
                j = text.find("}", i)
                if j < 0:
                    raise ValueError("a '{' set is not closed")
                members = set()
                for m in text[i + 1:j].split(","):
                    m = m.strip()
                    if m in classes:
                        members |= set(classes[m])
                    elif m:
                        members.add("".join(toks.split(m)))
                out.append(frozenset(members))
                i = j + 1
            elif ch.isupper() and ch in classes:
                out.append(frozenset(classes[ch]))
                i += 1
            else:
                sym = next((s for s in toks.symbols if text.startswith(s, i)), None)
                if not sym:
                    raise ValueError(f"{ch!r} is not '#', a class in [classes], a {{set}} or a "
                                     f"phoneme in the inventory")
                out.append(frozenset([sym]))
                i += len(sym)
        return out

    def _env_ok(self, seq, i, n):
        for left, right in self.envs or [([], [])]:
            p, ok = i - 1, True
            for el in reversed(left):
                if el == BOUND:
                    ok = p == -1
                elif p < 0 or seq[p] not in el:
                    ok = False
                else:
                    p -= 1
                if not ok:
                    break
            q = i + n
            for el in right if ok else []:
                if el == BOUND:
                    ok = q == len(seq)
                elif q >= len(seq) or seq[q] not in el:
                    ok = False
                else:
                    q += 1
                if not ok:
                    break
            if ok:
                return True
        return False

    def apply(self, tokens: list) -> list:
        """Apply simultaneously, left to right; markers (ˈ ˌ .) are transparent and kept."""
        where = [i for i, t in enumerate(tokens) if t not in MARKERS]
        seq = [tokens[i] for i in where]
        replace, i = {}, 0
        while i < len(seq):
            for k, alt in enumerate(self.frm):
                n = len(alt)
                if n and tuple(seq[i:i + n]) == alt and self._env_ok(seq, i, n):
                    replace[i] = (n, self.to[k])
                    i += n
                    break
            else:
                i += 1
        if not replace:
            return list(tokens)
        out, skip, s = [], 0, 0
        for idx, tok in enumerate(tokens):
            if tok in MARKERS:
                out.append(tok)
                continue
            if skip:
                skip -= 1
                s += 1
                continue
            if s in replace:
                n, rep = replace[s]
                out.extend(rep)
                skip = n - 1
            else:
                out.append(tok)
            s += 1
        return out


# ── Phonology ─────────────────────────────────────────────────────────────────────────────

class Phonology:
    """The inventory, classes, syllable templates, clusters, stress, allophones, spelling."""

    def __init__(self, data: dict, report: Report, where: str = "phonology.toml"):
        inv = data.get("inventory") or {}
        self.inventory, seen = [], set()
        for key, values in inv.items():
            if not isinstance(values, list):
                report.error(where, f"[inventory] {key} must be a list of IPA symbols")
                continue
            for sym in values:
                if sym in seen:
                    report.warn(where, f"/{sym}/ is listed twice in [inventory]")
                seen.add(sym)
                self.inventory.append(sym)
        if not self.inventory:
            report.error(where, "[inventory] lists no symbols")
        n = len(set(self.inventory))
        if self.inventory and not SIZE_RANGE[0] <= n <= SIZE_RANGE[1]:
            report.warn(where, f"{n} phonemes; {SIZE_RANGE[0]}-{SIZE_RANGE[1]} is the healthy range "
                               f"(fewer sounds thin; more is more than readers can hold)")
        self.toks = Tokens(self.inventory)
        self.classes = {}
        for name, members in (data.get("classes") or {}).items():
            if not re.fullmatch(r"[A-Z]", name):
                report.error(where, f"class {name!r}: class names are single capital letters")
                continue
            members = members if isinstance(members, list) else []
            for sym in members:
                if sym not in seen:
                    report.error(where, f"class {name} lists /{sym}/, which is not in [inventory]")
            self.classes[name] = [m for m in members if m in seen]
        self.vowels = set(inv.get("vowels") or []) or set(self.classes.get("V", []))
        if not self.vowels:
            report.warn(where, "no vowels found ([inventory] vowels or class V); syllables and "
                               "stress cannot be counted")
        tactics = data.get("phonotactics") or {}
        syl = tactics.get("syllable")
        self.patterns = [syl] if isinstance(syl, str) else [str(p) for p in (syl or [])]
        self.syll_re = None
        if not self.patterns:
            report.warn(where, "[phonotactics] has no syllable template; phonotactics not checked")
        else:
            try:
                alt = "|".join(self._pattern_regex(p) for p in self.patterns)
                self.syll_re = re.compile(f"(?:{alt})")
            except ValueError as err:
                report.error(where, str(err))
        self.onsets = self._clusters(tactics.get("onset_clusters"), report, where, "onset_clusters")
        self.codas = self._clusters(tactics.get("coda_clusters"), report, where, "coda_clusters")
        self.forbidden = self._clusters(tactics.get("forbidden"), report, where, "forbidden")
        self.stress = str((data.get("stress") or {}).get("rule", "")).strip().lower()
        if self.stress and self.stress not in STRESS_RULES and self.stress not in LEXICAL:
            report.warn(where, f"stress rule {self.stress!r} is not one of initial, penultimate, "
                               f"final or lexical; stress not checked")
        self.allophones = []
        for n_rule, a in enumerate(data.get("allophone") or [], start=1):
            if not isinstance(a, dict):
                report.error(where, f"[[allophone]] {n_rule} is not a table")
                continue
            sym = str(a.get("phoneme", "")).strip()
            if sym and sym not in seen:
                report.error(where, f"[[allophone]] {n_rule}: /{sym}/ is not in [inventory]")
            surf = Tokens(list(seen) + [str(a.get("surface", ""))])
            rule = Rule(n_rule, {"from": a.get("phoneme", ""), "to": a.get("surface", ""),
                                 "env": a.get("env", "_")}, surf, self.classes, "allophone")
            for msg in rule.problems:
                report.error(where, f"[[allophone]] {n_rule}: {msg}")
            self.allophones.append(rule)
        roman = data.get("romanisation") or {}
        self.exceptions = roman.get("exceptions") if isinstance(roman.get("exceptions"), dict) \
            else {}
        self.romanisation = {k: str(v) for k, v in roman.items() if k != "exceptions"}
        for sym in self.romanisation:
            if sym not in seen:
                report.warn(where, f"[romanisation] maps /{sym}/, which is not in [inventory]")
        for sym in self.exceptions:
            if sym not in seen:
                report.warn(where, f"[romanisation.exceptions] names /{sym}/, which is not in "
                                   f"[inventory]")
        self._check_romanisation(report, where)

    def _clusters(self, value, report, where, key):
        out = set()
        for c in value or []:
            try:
                out.add(tuple(t for t in self.toks.split(str(c)) if t not in MARKERS))
            except ValueError as err:
                report.error(where, f"[phonotactics] {key} {c!r}: {err}")
        return out

    def _code(self, sym: str) -> str:
        return chr(0xE000 + self.inventory.index(sym))

    def _pattern_regex(self, pattern: str) -> str:
        out, i, depth = [], 0, 0
        while i < len(pattern):
            ch = pattern[i]
            if ch.isspace():
                i += 1
            elif ch == "(":
                out.append("(?:")
                depth += 1
                i += 1
            elif ch == ")":
                if depth == 0:
                    raise ValueError(f"syllable template {pattern!r} has an unmatched ')'")
                out.append(")?")
                depth -= 1
                i += 1
            elif ch in self.classes:
                members = self.classes[ch]
                if not members:
                    raise ValueError(f"syllable template {pattern!r} uses class {ch}, which has no "
                                     f"members in the inventory")
                out.append("(?:" + "|".join(re.escape(self._code(m)) for m in members) + ")")
                i += 1
            else:
                sym = next((s for s in self.toks.symbols if pattern.startswith(s, i)), None)
                if not sym:
                    raise ValueError(f"syllable template {pattern!r}: {ch!r} is neither a class in "
                                     f"[classes] nor a symbol in [inventory]")
                out.append(re.escape(self._code(sym)))
                i += len(sym)
        if depth:
            raise ValueError(f"syllable template {pattern!r} has an unclosed '('")
        return "".join(out)

    def roman(self, sym: str) -> str:
        return self.romanisation.get(sym, sym)

    def _check_romanisation(self, report: Report, where: str):
        spellings = {}
        for sym in self.inventory:
            spellings.setdefault(self.roman(sym).casefold(), []).append(sym)
        for spelling, syms in spellings.items():
            if len([s for s in syms if s not in self.exceptions]) > 1:
                report.error(where, f"/{'/, /'.join(syms)}/ all romanise as {spelling!r}: one "
                                    f"spelling per sound, unless [romanisation.exceptions] gives "
                                    f"the reason")
        for sym in self.inventory:
            v = self.roman(sym).casefold()
            others = {s: syms for s, syms in spellings.items() if s != v}
            parts = self._split(v, others)
            if len(v) > 1 and parts and len(parts) > 1 and sym not in self.exceptions:
                reading = " + ".join(f"/{others[p][0]}/" for p in parts)
                report.warn(where, f"/{sym}/ is spelled {v!r}, which could also be read as "
                                   f"{reading}; list it in [romanisation.exceptions] with the "
                                   f"reason readers can still tell them apart")
        apos = [s for s in self.inventory if any(a in self.roman(s) for a in APOSTROPHES)]
        if apos:
            report.warn(where, f"apostrophes in the spelling of /{'/, /'.join(apos)}/: readers "
                               f"skip or stumble on them; use a letter, or keep one only where it "
                               f"separates sounds that would otherwise run together")
        marks = {c for s in self.inventory for c in unicodedata.normalize("NFD", self.roman(s))
                 if unicodedata.combining(c)}
        if len(marks) > 2:
            report.warn(where, f"{len(marks)} different diacritics in the romanisation; use them "
                               f"sparingly (two at most), because readers pronounce with English "
                               f"habits")

    @staticmethod
    def _split(text: str, pieces: dict):
        """One way to spell text from the given pieces, or None."""
        best = {0: []}
        for i in range(len(text)):
            if i not in best:
                continue
            for p in pieces:
                if p and text.startswith(p, i) and i + len(p) not in best:
                    best[i + len(p)] = best[i] + [p]
        return best.get(len(text))

    def segment(self, ipa: str):
        """IPA -> (phoneme tokens, stress token index or None, has syllable dots)."""
        tokens, stress_at, dots = [], None, False
        for t in self.toks.split(ipa):
            if t == "ˈ":
                stress_at = len(tokens)
            elif t == ".":
                dots = True
            elif t != "ˌ":
                tokens.append(t)
        return tokens, stress_at, dots

    def deromanise(self, word: str) -> list:
        """A romanised spelling -> IPA tokens (longest match); raises ValueError."""
        back = {}
        for sym in self.inventory:
            back.setdefault(self.roman(sym).casefold(), sym)
        keys = sorted(back, key=len, reverse=True)
        tokens, i, w = [], 0, word.casefold().replace("-", "")
        while i < len(w):
            key = next((k for k in keys if k and w.startswith(k, i)), None)
            if not key:
                raise ValueError(f"{w[i]!r} at position {i + 1} spells no sound in the language")
            tokens.append(back[key])
            i += len(key)
        return tokens

    def _syllable_ok(self, toks: tuple) -> bool:
        if not self.syll_re.fullmatch("".join(self._code(t) for t in toks)):
            return False
        nuclei = [i for i, t in enumerate(toks) if t in self.vowels]
        if not nuclei:
            return True
        onset, coda = toks[:nuclei[0]], toks[nuclei[-1] + 1:]
        if len(onset) > 1 and self.onsets and onset not in self.onsets:
            return False
        if len(coda) > 1 and self.codas and coda not in self.codas:
            return False
        return True

    def syllables(self, tokens: list):
        """Syllable start indices under the templates (maximal onset), or None."""
        if not self.syll_re or not tokens:
            return None
        n, failed = len(tokens), set()

        def parse(i):
            if i == n:
                return []
            if i in failed:
                return None
            for j in range(i + 1, n + 1):
                if self._syllable_ok(tuple(tokens[i:j])):
                    rest = parse(j)
                    if rest is not None:
                        return [i] + rest
            failed.add(i)
            return None
        return parse(0)

    def fits(self, ipa: str, morpheme: bool = False):
        """Problems with one word's IPA, as (errors, warnings).

        morpheme: a root or affix, which need not be a word on its own (a suffix -n, a
        consonantal root k-t-b), so only the inventory and the forbidden sequences are
        checked, never the syllable templates or the stress."""
        errors, warnings = [], []
        for part in clean_ipa(ipa).split():
            try:
                tokens, stress_at, dots = self.segment(part)
            except ValueError as err:
                errors.append(f"/{part}/: {err}")
                continue
            seq = tuple(tokens)
            for bad in self.forbidden:
                if any(seq[i:i + len(bad)] == bad for i in range(len(seq) - len(bad) + 1)):
                    errors.append(f"/{part}/ contains the forbidden sequence /{''.join(bad)}/")
            if morpheme or not self.syll_re or not tokens:
                continue
            if dots:
                for chunk in [c for c in re.split(r"[.ˈˌ]", part) if c]:
                    if not self._syllable_ok(tuple(self.segment(chunk)[0])):
                        errors.append(f"/{part}/: syllable /{chunk}/ does not fit "
                                      f"{' or '.join(self.patterns)} and the cluster lists")
                continue
            starts = self.syllables(tokens)
            if starts is None:
                errors.append(f"/{part}/ cannot be divided into syllables of the shape "
                              f"{' or '.join(self.patterns)} within the cluster lists")
                continue
            warnings += self._stress(part, starts, stress_at)
        return errors, warnings

    def stressed(self, count: int):
        """The 0-based stressed syllable under the rule, or None (lexical, or unknown)."""
        if count < 1 or self.stress not in STRESS_RULES:
            return None
        back = {"initial": count, "final": 1, "penultimate": 2, "antepenultimate": 3}[self.stress]
        return max(0, count - back)

    def _stress(self, part, starts, stress_at):
        count = len(starts)
        if self.stress in LEXICAL:
            if count > 1 and stress_at is None:
                return [f"/{part}/: the stress rule is lexical, so mark the stressed syllable "
                        f"with ˈ"]
            return []
        if stress_at is None or count < 2:
            return []
        want = self.stressed(count)
        if want is not None and stress_at in starts and starts.index(stress_at) != want:
            return [f"/{part}/ is stressed on syllable {starts.index(stress_at) + 1} of {count}, "
                    f"but the stress rule is {self.stress} (allowed as an exception; say so in "
                    f"its notes)"]
        return []

    def spell(self, ipa: str) -> str:
        out = []
        for part in clean_ipa(ipa).split():
            tokens, _, _ = self.segment(part)
            out.append("".join(self.roman(t) for t in tokens))
        return " ".join(out)

    def surface(self, ipa: str) -> str:
        """Phonemic IPA -> phonetic: the stress mark, then each allophone rule in order."""
        words = []
        for part in clean_ipa(ipa).split():
            tokens, stress_at, _ = self.segment(part)
            starts = self.syllables(tokens) or [0]
            if stress_at is None:
                k = self.stressed(len(starts))
                stress_at = starts[k] if k is not None and len(starts) > 1 else None
            marked = list(tokens)
            if stress_at is not None:
                marked.insert(stress_at, "ˈ")
            for rule in self.allophones:
                marked = rule.apply(marked)
            words.append("".join(marked))
        return " ".join(words)


# ── Languages ─────────────────────────────────────────────────────────────────────────────

class Language:
    def __init__(self, folder: Path, report: Report | None = None):
        self.folder, self.slug = folder, folder.name
        self.report = report or Report(folder.name)
        lang_file = folder / "language.toml"
        self.info = load_toml(lang_file) if lang_file.is_file() else {}
        self.has_info = lang_file.is_file()
        self.kind = str(self.info.get("kind", "") or "").strip()
        self.parent = str(self.info.get("parent", "") or "").strip()
        self.name = str(self.info.get("name", "") or "").strip()
        lex = load_toml(folder / "lexicon.toml")
        self.meta = lex.get("meta") or {}
        self.name = self.name or str(self.meta.get("language", "") or "") or folder.name
        words = lex.get("word") or []
        if not isinstance(words, list):
            raise Fatal(f"{shown(folder / 'lexicon.toml')}: entries must be [[word]] tables")
        self.words = words
        self.phon = Phonology(load_toml(folder / "phonology.toml"), self.report)
        self.inspirations = [i for i in (self.info.get("inspiration") or []) if isinstance(i, dict)]

    def entries(self):
        return [(n, w) for n, w in enumerate(self.words, start=1) if isinstance(w, dict)]


def load_all(languages: Path) -> dict:
    """{slug: Language} for every language with a lexicon and phonology; reports discarded."""
    out = {}
    for d in language_dirs(languages):
        if (d / "lexicon.toml").is_file() and (d / "phonology.toml").is_file():
            out[d.name] = Language(d, Report(d.name))
    return out


def is_complete(folder: Path) -> bool:
    return (folder / "phonology.toml").is_file() and (folder / "lexicon.toml").is_file()


def skip_note(folder: Path, what: str) -> None:
    print(f"{folder.name}: {what} skipped: phonology.toml and lexicon.toml are not both written yet")


def chosen(args, complete: bool = True) -> list:
    """The language folders a command runs on: LANG, or every language (complete: only those
    with both phonology.toml and lexicon.toml)."""
    if args.lang:
        folder = resolve_language(args.lang, args.languages)
        if complete:
            for f in ("phonology.toml", "lexicon.toml"):
                if not (folder / f).is_file():
                    raise Fatal(f"{shown(folder / f)} not found")
        return [folder]
    found = [d for d in language_dirs(args.languages) if not complete or
             ((d / "phonology.toml").is_file() and (d / "lexicon.toml").is_file())]
    if not found:
        print(f"no languages in {shown(args.languages)} yet")
    return found


def ancestors(lang: Language, langs: dict) -> list:
    out, seen, cur = [], {lang.slug}, lang
    while cur.parent and cur.parent in langs and cur.parent not in seen:
        cur = langs[cur.parent]
        seen.add(cur.slug)
        out.append(cur)
    return out


def sound_changes(daughter: Language, parent: Language | None):
    """(rules, tokeniser, problems) for a daughter's sound-changes.toml."""
    path = daughter.folder / "sound-changes.toml"
    if not path.is_file():
        return [], None, [f"{shown(path)} not found; a daughter derives from its parent through "
                          f"ordered sound changes"]
    data = load_toml(path)
    raw = [r for r in (data.get("rule") or []) if isinstance(r, dict)]
    classes = {}
    for source in ([parent.phon.classes] if parent else []) + [daughter.phon.classes]:
        for k, v in source.items():
            classes[k] = list(dict.fromkeys(classes.get(k, []) + list(v)))
    for k, v in (data.get("classes") or {}).items():
        classes[k] = list(v) if isinstance(v, list) else []
    symbols = set(daughter.phon.inventory) | set(parent.phon.inventory if parent else [])
    known = Tokens(symbols)
    for r in raw:
        for key in ("from", "to"):
            v = r.get(key, "")
            for item in v if isinstance(v, list) else [v]:
                item = str(item).strip()
                if item in classes or item in ("", "∅", "0"):
                    continue
                try:
                    known.split(item)
                except ValueError:
                    symbols.add(item)  # a new sound the rule introduces, taken whole
    toks = Tokens(symbols)
    rules, problems = [], []
    for n, r in enumerate(raw, start=1):
        rule = Rule(n, r, toks, classes, "rule")
        problems += [f"[[rule]] {n} ({rule.text}): {m}" for m in rule.problems]
        rules.append(rule)
    return rules, toks, problems


def derive_tokens(tokens: list, rules: list, after: int = 0, trace=None) -> list:
    for rule in rules[after:]:
        new = rule.apply(tokens)
        if trace is not None and new != tokens:
            trace.append(f"{rule.n}: {''.join(new) or '∅'}  ({rule.text})")
        tokens = new
    return tokens


# ── check ─────────────────────────────────────────────────────────────────────────────────

def repo_file(lang: Language, rel: str) -> bool:
    """Does a repository-relative path exist (from this checkout, or the language's own)?"""
    roots = [ROOT] + ([lang.folder.resolve().parents[3]]
                      if len(lang.folder.resolve().parents) > 3 else [])
    return any((r / rel).is_file() for r in roots)


def check_language_file(lang: Language, langs: dict):
    r, where = lang.report, "language.toml"
    if not lang.has_info:
        r.warn(where, "not found: the language's kind, parent, culture and real-world models are "
                      "unrecorded")
        r.warn(where, "no real-world inspiration recorded (every language has models; see "
                      "world/docs/reference/building-a-language.md)")
        return
    info = lang.info
    if not str(info.get("name", "")).strip():
        r.error(where, "name is missing or empty")
    slug = str(info.get("slug", "")).strip()
    if slug != lang.slug:
        r.warn(where, f"slug is {slug!r} but the folder is {lang.slug!r}")
    if lang.kind not in KINDS:
        r.error(where, f"kind is {lang.kind!r}; it must be one of {', '.join(KINDS)}")
    if lang.kind == "daughter":
        if not lang.parent:
            r.error(where, "a daughter names its parent (parent = \"<slug>\")")
        elif lang.parent not in langs:
            r.error(where, f"parent {lang.parent!r} is not a language folder here")
    elif lang.parent:
        r.warn(where, f"a {lang.kind or 'language'} has a parent ({lang.parent!r}); only a "
                      f"daughter should")
    culture = str(info.get("culture", "") or "").strip()
    if not culture:
        r.warn(where, "culture is empty: each language links to the culture of its speakers")
    elif not repo_file(lang, culture):
        r.warn(where, f"culture {culture!r} does not exist")
    for key in ("values", "marks", "ignores"):
        if key in info and not isinstance(info[key], list):
            r.error(where, f"{key} must be a list, for example {key} = []")
    order = str(info.get("word_order", "") or "")
    if order and order not in WORD_ORDERS:
        r.warn(where, f"word_order {order!r} is not one of {', '.join(WORD_ORDERS)}")
    morph = str(info.get("morphology", "") or "")
    if morph and morph not in MORPHOLOGIES:
        r.warn(where, f"morphology {morph!r} is not one of {', '.join(MORPHOLOGIES)}")
    if not lang.inspirations:
        r.warn(where, "no [[inspiration]]: every language has real-world models for how it "
                      "sounds, researched and cited")
    for n, insp in enumerate(lang.inspirations, start=1):
        label = f"{where} [[inspiration]] {n} {insp.get('language', '')!r}"
        if not str(insp.get("language", "")).strip():
            r.error(label, "language is missing")
        period = str(insp.get("period", "") or "")
        if period not in PERIODS:
            r.warn(label, f"period {period!r} is not one of {', '.join(PERIODS)}")
        weight = str(insp.get("weight", "") or "")
        if weight not in WEIGHTS:
            r.warn(label, f"weight {weight!r} is not one of {', '.join(WEIGHTS)}")
        borrows = insp.get("borrows") or []
        if not isinstance(borrows, list) or not borrows:
            r.warn(label, "borrows is empty: say what is taken (sound first)")
        else:
            odd = [b for b in borrows if b not in BORROWS]
            if odd:
                r.warn(label, f"borrows {odd}: expected {', '.join(BORROWS)}")
        sources = insp.get("sources") or []
        if not sources:
            r.warn(label, "no sources: every claim about a real language is researched and cited")
        for s in sources if isinstance(sources, list) else []:
            if str(s).startswith("research/") and not repo_file(lang, str(s)):
                r.warn(label, f"source {s!r} does not exist")
    if lang.kind == "daughter" and lang.parent in langs:
        mine = primary_period(lang)
        theirs = primary_period(langs[lang.parent])
        if mine is not None and theirs is not None and mine < theirs:
            r.warn(where, f"the primary model's period is older than the parent's "
                          f"({PERIODS[mine]} against {PERIODS[theirs]}); a parent leans older "
                          f"than its daughters")


def primary_period(lang: Language):
    for insp in lang.inspirations:
        if insp.get("weight") == "primary" and insp.get("period") in PERIODS:
            return PERIODS.index(insp["period"])
    return None


def transliterator(folder: Path):
    """script.py's transliterate for this language, or None if it has no usable script."""
    if not (folder / "script" / "glyphs.toml").is_file():
        return None
    try:
        import script as script_mod  # same folder; ships with this file
        glyphs = script_mod.load_script(folder)
        return lambda text: script_mod.transliterate(text, glyphs)
    except Exception:  # noqa: BLE001 - a broken script is script.py's to report
        return None


def known_concepts(path: Path) -> set | None:
    if not path.is_file():
        return None
    data = load_toml(path)
    return {str(c.get("key")) for c in (data.get("concept") or []) + (data.get("pronoun") or [])
            if isinstance(c, dict)}


def index_forms(lang: Language, pos=None) -> dict:
    """{form key: headword} for the language's entries (optionally one part of speech)."""
    out = {}
    for _, w in lang.entries():
        if pos and str(w.get("pos", "")) not in pos:
            continue
        for v in (w.get("headword"), w.get("ipa")):
            if str(v or "").strip():
                out.setdefault(form_key(v), str(w.get("headword")))
    return out


def check_words(lang: Language, langs: dict, concepts: set | None, n_rules: int | None):
    r, where, phon = lang.report, "lexicon.toml", lang.phon
    if not lang.meta.get("language"):
        r.warn(where, "[meta] has no language name")
    if lang.meta.get("slug") and lang.meta.get("slug") != lang.slug:
        r.warn(where, f"[meta] slug is {lang.meta.get('slug')!r} but the folder is {lang.slug!r}")
    family = [lang] + ancestors(lang, langs)
    roots = {k: v for l in family for k, v in index_forms(l, ("root",)).items()}
    affixes = {k: v for l in family for k, v in index_forms(l, ("affix",)).items()}
    heads = {k: v for l in family for k, v in index_forms(l).items()}
    native_of = transliterator(lang.folder)
    daughter = lang.kind == "daughter"
    seen_pos, seen_ipa, headwords = {}, {}, set()
    with_marks = with_apos = 0
    for n, w in lang.entries():
        head = str(w.get("headword", "")).strip()
        label = f"{where} word {n} {head!r}"
        missing = [k for k in WORD_KEYS if k not in w and (daughter or k not in DAUGHTER_ONLY)]
        if missing:
            r.error(label, f"missing field{'s' * (len(missing) > 1)} {', '.join(missing)} "
                           f"(write {'them' if len(missing) > 1 else 'it'} empty if unknown)")
        for key in REQUIRED:
            if key in w and not (as_list(w[key]) if key == "senses" else str(w[key]).strip()):
                r.error(label, f"{key} is empty")
        unknown = [k for k in w if k not in WORD_KEYS]
        if unknown:
            r.warn(label, f"unknown field{'s' * (len(unknown) > 1)} {', '.join(unknown)} (not in "
                          f"the lexicon format)")
        for key in LISTS:
            if key in w and not isinstance(w[key], list):
                r.error(label, f"{key} must be a list, for example {key} = []")
        pos = str(w.get("pos", "")).strip()
        if pos and pos not in POS:
            r.warn(label, f"pos {pos!r} is not one of {', '.join(POS)}")
        ipa = clean_ipa(w.get("ipa", ""))
        if head:
            headwords.add(head.casefold())
            key = (head.casefold(), pos)
            if key in seen_pos:
                r.error(label, f"duplicates word {seen_pos[key]} (same headword and part of speech)")
            else:
                same = [m for (h, _), m in seen_pos.items() if h == head.casefold()]
                if same:
                    r.warn(label, f"same headword as word {same[0]} with a different part of "
                                  f"speech: intended?")
                seen_pos[key] = n
            nfd = unicodedata.normalize("NFD", head)
            marks = sum(1 for c in nfd if unicodedata.combining(c))
            with_marks += marks > 0
            with_apos += any(a in head for a in APOSTROPHES)
            if marks > 1:
                r.warn(label, f"{marks} diacritics in one headword: use them sparingly")
            if sum(head.count(a) for a in APOSTROPHES) > 1:
                r.warn(label, "more than one apostrophe: apostrophe soup is hard to read")
        is_loan = bool(str(w.get("loan_from", "")).strip())
        if ipa:
            plain = bare(ipa)
            if plain in seen_ipa and seen_ipa[plain][1] != head.casefold() and pos not in (
                    "root", "affix"):
                r.warn(label, f"sounds the same as word {seen_ipa[plain][0]} "
                              f"{seen_ipa[plain][2]!r}: intended?")
            if pos not in ("root", "affix"):
                seen_ipa.setdefault(plain, (n, head.casefold(), head))
            errs, warns = phon.fits(ipa, morpheme=pos in ("root", "affix"))
            for msg in errs:
                r.error(label, msg + (" (a loanword is adapted to the phonotactics)" if is_loan
                                      else ""))
            for msg in warns:
                r.warn(label, msg)
            if head and not errs and not same_spelling(head, phon.spell(ipa)):
                r.error(label, f"headword does not match its IPA /{ipa}/, which the romanisation "
                               f"map spells {phon.spell(ipa)!r}")
        for ref in as_list(w.get("roots")):
            if form_key(ref) not in roots:
                r.error(label, f"root {ref!r} is not a pos = \"root\" entry in this lexicon"
                               f"{' or an ancestor' if len(family) > 1 else ''}")
        for ref in as_list(w.get("affixes")):
            if form_key(ref) not in affixes:
                r.error(label, f"affix {ref!r} is not a pos = \"affix\" entry in this lexicon"
                               f"{' or an ancestor' if len(family) > 1 else ''}")
        for ref in as_list(w.get("compound_of")):
            if form_key(ref) not in heads:
                r.error(label, f"compound_of {ref!r} is not a headword here"
                               f"{' or in an ancestor' if len(family) > 1 else ''}")
        for c in as_list(w.get("concept")):
            if concepts is not None and c not in concepts:
                r.warn(label, f"concept {c!r} is not a key in tooling/data/core-concepts.toml")
        if "irregular" in w and not isinstance(w["irregular"], bool):
            r.error(label, "irregular must be true or false")
        elif w.get("irregular") is True and not str(w.get("notes", "")).strip():
            r.error(label, "irregular = true needs a note saying why the derivation is not regular")
        stratum = str(w.get("stratum", "") or "").strip()
        if stratum and stratum not in STRATA:
            r.error(label, f"stratum {stratum!r} is not one of {', '.join(STRATA)}")
        elif "stratum" in w and not stratum:
            r.warn(label, "stratum is empty (inherited, early-loan, late-loan or coinage)")
        after = w.get("entered_after", 0)
        if "entered_after" in w:
            if not isinstance(after, int) or isinstance(after, bool) or after < 0:
                r.error(label, "entered_after must be a whole number, 0 or more")
            elif n_rules is not None and after > n_rules:
                r.error(label, f"entered_after is {after}, but sound-changes.toml has only "
                               f"{n_rules} rule{'s' * (n_rules != 1)}")
            elif after > 0 and stratum == "inherited":
                r.warn(label, "an inherited word undergoes every change (entered_after = 0); "
                              "is it a loan or a late coinage?")
        if is_loan:
            if not str(w.get("loan_source", "")).strip():
                r.error(label, "loan_from is set but loan_source (the form borrowed) is empty")
            if str(w["loan_from"]).strip() not in langs:
                r.warn(label, f"loan_from {w['loan_from']!r} is not a language folder here")
            if stratum not in ("early-loan", "late-loan"):
                r.warn(label, f"a loan's stratum is early-loan or late-loan, not {stratum!r}")
        if daughter and stratum == "inherited" and not str(w.get("proto_form", "")).strip() \
                and pos not in ("root", "affix", "name"):
            r.warn(label, "inherited, but proto_form is empty, so make derive cannot check it")
        echo = str(w.get("echo", "") or "")
        if echo and not re.search(r"source|research/", echo, re.I):
            r.warn(label, "echo names no source: a deliberate echo of a real word is verified and "
                          "cited, never from memory")
        native = str(w.get("native", "") or "").strip()
        if native and native_of and head:
            try:
                ids, pua = native_of(head)
                if native not in (ids, pua):
                    r.warn(label, f"native spelling {native!r} differs from the script's "
                                  f"transliteration {ids!r}")
            except ValueError as err:
                r.warn(label, f"native spelling given, but the script cannot write it: {err}")
    for n, w in lang.entries():
        for form in as_list(w.get("derived")):
            if form.casefold() in headwords:
                continue
            label = f"{where} word {n} {w.get('headword', '')!r}"
            try:
                errs, _ = phon.fits("".join(phon.deromanise(form)))
            except ValueError as err:
                errs = [str(err)]
            for msg in errs:
                r.error(label, f"derived form {form!r}: {msg}")
            r.warn(label, f"derived form {form!r} has no entry of its own")
    total = len(headwords)
    if total >= 3 and with_marks / total > DIACRITIC_SHARE:
        r.warn(where, f"{with_marks} of {total} headwords carry a diacritic; keep them sparing")
    if total >= 3 and with_apos / total > APOSTROPHE_SHARE:
        r.warn(where, f"{with_apos} of {total} headwords carry an apostrophe; avoid apostrophe soup")


def same_spelling(headword: str, spelled: str) -> bool:
    a = " ".join(headword.casefold().split())
    return a == spelled.casefold() or a.replace("-", "") == spelled.casefold().replace(" ", "")


def check_one(folder: Path, langs: dict, concepts) -> int:
    absent = [f for f in ("phonology.toml", "lexicon.toml") if not (folder / f).is_file()]
    if absent:
        r = Report(folder.name)
        r.warn(folder.name, f"{' and '.join(absent)} not written yet, so only language.toml is "
                            f"checked")
        if (folder / "language.toml").is_file():
            info = load_toml(folder / "language.toml")
            if str(info.get("kind", "")) not in KINDS:
                r.error("language.toml", f"kind is {info.get('kind', '')!r}; it must be one of "
                                         f"{', '.join(KINDS)}")
            if not [i for i in info.get("inspiration") or [] if isinstance(i, dict)]:
                r.warn("language.toml", "no [[inspiration]]: every language has real-world models")
        return r.print("not yet checkable")
    lang = langs.get(folder.name) or Language(folder)
    langs = dict(langs, **{lang.slug: lang})
    check_language_file(lang, langs)
    n_rules = None
    if lang.kind == "daughter":
        rules, _, problems = sound_changes(lang, langs.get(lang.parent))
        n_rules = len(rules)
        for msg in problems:
            (lang.report.warn if "not found" in msg else lang.report.error)("sound-changes.toml",
                                                                            msg)
    check_words(lang, langs, concepts, n_rules)
    n = len(lang.words)
    return lang.report.print(f"{n} word{'s' * (n != 1)} checked")


def cmd_check(args) -> int:
    folders = chosen(args, complete=False)
    langs = load_all(args.languages)
    concepts = known_concepts(args.concepts)
    status = 0
    for folder in folders:
        status = max(status, check_one(folder, langs, concepts))
    return status


# ── derive ────────────────────────────────────────────────────────────────────────────────

def derive_one(lang: Language, langs: dict, args) -> int:
    r = Report(f"{lang.slug} derive")
    parent = langs.get(lang.parent)
    if not parent:
        r.error("language.toml", f"parent {lang.parent!r} not found, so nothing can be derived")
        return r.print("no derivation")
    rules, toks, problems = sound_changes(lang, parent)
    for msg in problems:
        r.error("sound-changes.toml", msg)
    if toks is None or any("[[rule]]" in m for m in problems):
        return r.print("rules unusable")
    if args.form:
        trace = []
        start = toks.split(bare(args.form), strict=False)
        out = derive_tokens(start, rules, args.after, trace)
        print(f"{lang.slug}: /{bare(args.form)}/ → /{''.join(out)}/ "
              f"(spelled {lang.phon.spell(''.join(out)) if all(t in lang.phon.inventory for t in out) else '?'})")
        for step in trace:
            print(f"    {step}")
        errs, _ = lang.phon.fits("".join(out))
        for msg in errs:
            print(f"  warning {msg}")
        return 0
    checked = mismatched = irregular = 0
    reflexes = set()
    for n, w in lang.entries():
        head = str(w.get("headword", ""))
        proto = bare(w.get("proto_form", ""))
        source = bare(w.get("loan_source", "")) if str(w.get("loan_from", "")).strip() else ""
        start_form = proto or source
        if proto:
            reflexes.add(proto)
        if source and str(w.get("loan_from")).strip() == lang.parent:
            reflexes.add(source)
        if not start_form:
            continue
        after = w.get("entered_after", 0) if isinstance(w.get("entered_after", 0), int) else 0
        trace = []
        try:
            out = derive_tokens(toks.split(start_form, strict=False), rules, after, trace)
        except ValueError as err:
            r.error(f"word {n} {head!r}", str(err))
            continue
        checked += 1
        got, want = "".join(out), bare(w.get("ipa", ""))
        label = f"word {n} {head!r}"
        if proto and parent and proto not in {bare(x.get("ipa", "")) for _, x in parent.entries()}:
            r.warn(label, f"proto_form /{proto}/ is not an entry in {parent.slug}'s lexicon; add "
                          f"it there so its history is on record")
        steps = f"/{start_form}/" + (f" (from rule {after + 1})" if after else "") + \
            "".join(f" → {s.split()[1]}" for s in trace)
        if got == want:
            if args.trace:
                r.notes.append(f"ok      {label}: {steps}")
            continue
        if w.get("irregular") is True:
            irregular += 1
            r.notes.append(f"irregular {label}: regular /{got}/, recorded /{want}/ — "
                           f"{str(w.get('notes', '')).strip()}")
            continue
        mismatched += 1
        r.error(label, f"/{start_form}/ derives as /{got}/, but the entry's IPA is /{want}/ "
                       f"({steps}); fix the entry or the rules, or mark it irregular = true with "
                       f"a note")
        if args.trace:
            for step in trace:
                r.notes.append(f"    {step}")
    proposals = []
    current = {bare(x.get("ipa", "")): str(x.get("headword", "")) for _, x in lang.entries()}
    for _, pw in parent.entries():
        pipa = bare(pw.get("ipa", ""))
        if not pipa or pipa in reflexes or str(pw.get("pos", "")) in ("root", "affix"):
            continue
        out = "".join(derive_tokens(toks.split(pipa, strict=False), rules))
        errs, _ = lang.phon.fits(out)
        spelled = lang.phon.spell(out) if not errs else "?"
        clash = f"; clashes with {current[out]!r}" if out in current else ""
        fit = "" if not errs else f"; does not fit the phonotactics: {errs[0]}"
        senses = "; ".join(as_list(pw.get("senses")))
        proposals.append(f"proposal {pw.get('headword')!r} /{pipa}/ '{senses}' → /{out}/ "
                         f"{spelled!r}{clash}{fit}")
    r.notes += proposals
    return r.print(f"{checked} derivation{'s' * (checked != 1)} checked against {len(rules)} "
                   f"rule{'s' * (len(rules) != 1)}, {mismatched} mismatch"
                   f"{'es' * (mismatched != 1)}, {irregular} irregular, {len(proposals)} parent "
                   f"word{'s' * (len(proposals) != 1)} without a reflex")


def cmd_derive(args) -> int:
    langs = load_all(args.languages)
    if args.lang:
        folder = resolve_language(args.lang, args.languages)
        if not is_complete(folder):
            skip_note(folder, "derive")
            return 0
        lang = langs.get(folder.name) or Language(folder)
        langs[lang.slug] = lang
        if lang.kind != "daughter":
            print(f"{lang.slug}: a {lang.kind or 'language without a kind'}, not a daughter; "
                  f"nothing to derive")
            return 0
        return derive_one(lang, langs, args)
    daughters = [l for l in langs.values() if l.kind == "daughter"]
    if not daughters:
        print("no daughter languages; nothing to derive")
        return 0
    if args.form:
        raise Fatal("--form needs LANG: the daughter whose rules to apply")
    return max(derive_one(l, langs, args) for l in daughters)


# ── surface ───────────────────────────────────────────────────────────────────────────────

def cmd_surface(args) -> int:
    lang = Language(resolve_language(args.lang, args.languages))
    words = []
    for item in args.text.split():
        if args.headword:
            found = [w for _, w in lang.entries()
                     if str(w.get("headword", "")).casefold() == item.casefold()]
            if found:
                words.append(clean_ipa(found[0].get("ipa", "")))
                continue
            try:
                words.append("".join(lang.phon.deromanise(item)))
            except ValueError as err:
                print(f"error: {item!r}: {err}", file=sys.stderr)
                return 1
        else:
            words.append(clean_ipa(item))
    try:
        print(" ".join(lang.phon.surface(w) for w in words))
    except ValueError as err:
        print(f"error: {err}", file=sys.stderr)
        return 1
    return 0


# ── coverage ──────────────────────────────────────────────────────────────────────────────

def cmd_coverage(args) -> int:
    data = load_toml(args.concepts)
    concepts = [c for c in data.get("concept") or [] if isinstance(c, dict)]
    pronouns = [p for p in data.get("pronoun") or [] if isinstance(p, dict)]
    status = 0
    for folder in chosen(args, complete=False):
        info = load_toml(folder / "language.toml") if (folder / "language.toml").is_file() else {}
        lex = load_toml(folder / "lexicon.toml") if (folder / "lexicon.toml").is_file() else {}
        words = [w for w in lex.get("word") or [] if isinstance(w, dict)]
        marks = {str(m) for m in info.get("marks") or []}
        filled = {c for w in words for c in as_list(w.get("concept"))}
        missing = [c for c in concepts if str(c.get("key")) not in filled]
        need = [p for p in pronouns
                if all(req in marks for req in as_list(p.get("requires")))
                and not any(u in marks for u in as_list(p.get("unless")))]
        p_missing = [p for p in need if str(p.get("key")) not in filled]
        have = len(concepts) - len(missing)
        print(f"{folder.name}: {have} of {len(concepts)} core concepts "
              f"({100 * have // max(1, len(concepts))}%), {len(need) - len(p_missing)} of "
              f"{len(need)} pronoun cells")
        by_domain = {}
        for c in missing:
            by_domain.setdefault(str(c.get("domain", "other")), []).append(str(c.get("key")))
        for domain, keys in by_domain.items():
            print(f"  missing {domain}: {', '.join(keys)}")
        if p_missing:
            print(f"  missing pronouns: {', '.join(str(p.get('key')) for p in p_missing)}")
        cells = [str(p.get("key")) for p in pronouns if p not in need]
        if cells:
            print(f"  not required (the grammar does not mark them): {', '.join(cells)}")
        if args.strict and (missing or p_missing):
            status = 1
    return status


# ── family ────────────────────────────────────────────────────────────────────────────────

def cmd_family(args) -> int:
    langs = {}
    for d in language_dirs(args.languages):
        if (d / "language.toml").is_file():
            info = load_toml(d / "language.toml")
        else:
            info = {}
        langs[d.name] = info
    if not langs:
        print(f"no languages in {shown(args.languages)} yet")
        return 0
    report = Report("family")
    children = {}
    for slug, info in langs.items():
        parent = str(info.get("parent", "") or "")
        if parent and parent not in langs:
            report.error(slug, f"parent {parent!r} is not a language folder here")
        children.setdefault(parent if parent in langs else "", []).append(slug)
        if not [i for i in info.get("inspiration") or [] if isinstance(i, dict)]:
            report.warn(slug, "no real-world inspiration recorded")
        if info.get("kind") == "daughter" and not parent:
            report.error(slug, "a daughter with no parent")

    def line(slug):
        info = langs[slug]
        models = "; ".join(f"{i.get('language', '?')} ({i.get('period', '?')}, "
                           f"{i.get('weight', '?')})" for i in info.get("inspiration") or []
                           if isinstance(i, dict)) or "no models"
        return f"{slug} — {info.get('name', slug)} [{info.get('kind', '?')}] · {models}"

    seen = set()

    def walk(slug, prefix, last, top):
        if slug in seen:
            report.error(slug, "is its own ancestor (a cycle in parent)")
            return
        seen.add(slug)
        print(line(slug) if top else f"{prefix}{'└── ' if last else '├── '}{line(slug)}")
        kids = sorted(children.get(slug, []))
        for i, kid in enumerate(kids):
            walk(kid, prefix if top else prefix + ("    " if last else "│   "),
                 i == len(kids) - 1, False)
    for slug in sorted(children.get("", [])):
        walk(slug, "", True, True)
    for slug in sorted(set(langs) - seen):
        report.error(slug, "unreachable from any root (a cycle in parent)")
    return report.print(f"{len(langs)} language{'s' * (len(langs) != 1)}")


# ── glossary ──────────────────────────────────────────────────────────────────────────────

def cell(text) -> str:
    return str(text).replace("|", "\\|").replace("\n", " ").strip()


def glossary_one(folder: Path, langs: dict, concepts, out: Path, force: bool) -> int:
    lang = langs.get(folder.name) or Language(folder)
    langs = dict(langs, **{lang.slug: lang})
    check_language_file(lang, langs)
    check_words(lang, langs, concepts, None)
    report = lang.report
    if report.errors and not force:
        report.print("glossary not written")
        print("Fix the errors above (make lexicon), or pass --force to write it anyway.")
        return 1
    phon = lang.phon
    today = datetime.date.today().strftime("%d/%m/%Y")
    lines = [f"# {lang.name} — glossary and pronunciation guide", "",
             f"<!-- Generated by tooling/lexicon.py from {shown(folder)} on {today}. Never "
             f"hand-edit: change the lexicon, then run make glossary. -->", "",
             "## Pronunciation", "", "| Spelling | Sound (IPA) |", "|---|---|"]
    for sym in phon.inventory:
        lines.append(f"| {cell(phon.roman(sym))} | /{cell(sym)}/ |")
    lines.append("")
    if phon.stress in STRESS_RULES:
        lines.append(f"Stress falls on {STRESS_RULES[phon.stress]}.")
    elif phon.stress:
        lines.append("Stress is lexical: the pronunciation of each word marks it.")
    for a in phon.allophones:
        lines.append(f"Allophone: {a.text}.")
    words = sorted((w for _, w in lang.entries() if w.get("headword")),
                   key=lambda w: str(w["headword"]).casefold())
    lines += ["", "## Glossary", "", "| Word | Pronunciation | Part of speech | Meaning | Origin |",
              "|---|---|---|---|---|"]
    for w in words:
        if str(w.get("pos")) in ("root", "affix"):
            continue
        lines.append(f"| {cell(w['headword'])} | [{cell(safe_surface(phon, w.get('ipa')))}] "
                     f"| {cell(w.get('pos', ''))} | {cell('; '.join(as_list(w.get('senses'))))} "
                     f"| {cell(origin(w))} |")
    bound = [w for w in words if str(w.get("pos")) in ("root", "affix")]
    if bound:
        lines += ["", "## Roots and affixes", "", "| Form | IPA | Kind | Meaning |",
                  "|---|---|---|---|"]
        for w in bound:
            lines.append(f"| {cell(w['headword'])} | /{cell(clean_ipa(w.get('ipa')))}/ | "
                         f"{cell(w.get('pos'))} | {cell('; '.join(as_list(w.get('senses'))))} |")
    ensure_parent(out)
    out.write_text("\n".join(lines) + "\n", encoding="utf-8")
    if report.errors or report.warnings:
        report.print("glossary written anyway" if report.errors else "glossary written")
    print(f"wrote {out} ({len(words)} entr{'ies' if len(words) != 1 else 'y'})")
    return 0


def safe_surface(phon: Phonology, ipa) -> str:
    try:
        return phon.surface(clean_ipa(ipa))
    except ValueError:
        return clean_ipa(ipa)


def origin(w: dict) -> str:
    if str(w.get("loan_from", "")).strip():
        return f"loan from {w['loan_from']} {w.get('loan_source', '')}".strip()
    if str(w.get("proto_form", "")).strip():
        return f"< \\*{bare(w['proto_form'])}"
    parts = as_list(w.get("compound_of")) or as_list(w.get("roots")) + as_list(w.get("affixes"))
    return " + ".join(parts)


def cmd_glossary(args) -> int:
    folders = chosen(args, complete=False)
    if args.out and len(folders) != 1:
        raise Fatal("--out names one file; with several languages use --out-dir")
    langs = load_all(args.languages)
    concepts = known_concepts(args.concepts)
    status = 0
    for folder in folders:
        if not is_complete(folder):
            skip_note(folder, "glossary")
            continue
        out = Path(args.out) if args.out else Path(args.out_dir) / f"glossary-{folder.name}.md"
        status = max(status, glossary_one(folder, langs, concepts, out, args.force))
    return status


# ── names ─────────────────────────────────────────────────────────────────────────────────

def register_rows(path: Path):
    """(row number, {column: value}) for each data row of the register's table."""
    if not path.is_file():
        raise Fatal(f"{shown(path)} not found")
    header, rows = None, []
    for line in read_text(path).splitlines():
        s = line.strip()
        if not s.startswith("|"):
            if header and rows:
                break
            continue
        cells = [c.strip() for c in s.strip("|").split("|")]
        if all(re.fullmatch(r":?-{3,}:?", c) for c in cells if c):
            continue
        if header is None:
            lowered = [c.casefold() for c in cells]
            if "name" in lowered and "language" in lowered:
                header = lowered
            continue
        if any(cells):
            rows.append((len(rows) + 1, dict(zip(header, cells))))
    if header is None:
        raise Fatal(f"{shown(path)}: no table with Name and Language columns")
    return rows


def plain(text: str) -> str:
    text = re.sub(r"\[([^\]]*)\]\([^)]*\)", r"\1", text or "")
    return re.sub(r"[`*_]", "", text).strip()


def edit_distance(a: str, b: str) -> int:
    prev = list(range(len(b) + 1))
    for i, ca in enumerate(a, start=1):
        cur = [i]
        for j, cb in enumerate(b, start=1):
            cur.append(min(prev[j] + 1, cur[j - 1] + 1, prev[j - 1] + (ca != cb)))
        prev = cur
    return prev[-1]


def cmd_names(args) -> int:
    rows = register_rows(args.register)
    report = Report("names")
    if not rows:
        print(f"names: {shown(args.register)} has no entries yet")
        return 0
    langs = {}
    for folder in chosen(args, complete=False):
        if not is_complete(folder):
            skip_note(folder, "names check")
            continue
        lang = Language(folder)
        for alias in {folder.name, lang.name, kebab(lang.name)}:
            if alias:
                langs[alias.casefold()] = (folder.name, lang.phon)
    checked, by_name, by_sound = 0, {}, {}
    for n, row in rows:
        name = plain(row.get("name", ""))
        if not name:
            report.error(f"row {n}", "no name")
            continue
        where = f"row {n} {name!r}"
        if name.casefold() in by_name:
            report.error(where, f"also in row {by_name[name.casefold()]}: names must be unique")
        by_name.setdefault(name.casefold(), n)
        ipa = clean_ipa(plain(row.get("ipa", "")))
        if ipa:
            sound = bare(ipa)
            if sound in by_sound and by_sound[sound][1] != name.casefold():
                report.warn(where, f"sounds the same as row {by_sound[sound][0]}")
            by_sound.setdefault(sound, (n, name.casefold()))
        column = plain(row.get("language", ""))
        lang = langs.get(column.casefold()) or langs.get(kebab(column))
        if not lang:
            continue
        checked += 1
        slug, phon = lang
        if ipa:
            errs, warns = phon.fits(ipa)
            for msg in errs:
                report.error(where, f"{slug}: {msg}")
            for msg in warns:
                report.warn(where, f"{slug}: {msg}")
            if not errs and not same_spelling(name, phon.spell(ipa)):
                report.error(where, f"{slug}: the name does not match its IPA /{ipa}/, which the "
                                    f"romanisation map spells {phon.spell(ipa)!r}")
        else:
            report.warn(where, f"{slug}: no IPA recorded; checked from the spelling only")
            for part in name.split():
                try:
                    errs, _ = phon.fits("".join(phon.deromanise(part)))
                except ValueError as err:
                    errs = [str(err)]
                for msg in errs:
                    report.error(where, f"{slug}: {msg}")
    names = sorted(by_name)
    for i, a in enumerate(names):
        for b in names[i + 1:]:
            if min(len(a), len(b)) >= 4 and edit_distance(a, b) == 1:
                report.warn(f"rows {by_name[a]} and {by_name[b]}",
                            f"{a!r} and {b!r} differ by one letter: easily confused")
    return report.print(f"{len(rows)} row{'s' * (len(rows) != 1)}, {checked} in a constructed "
                        f"language checked")


# ── density ───────────────────────────────────────────────────────────────────────────────

SPAN = re.compile(r"\[([^\]]+)\]\{([^}]*\.conlang(?:-native)?\b[^}]*)\}")
GLOSS_AFTER = re.compile(r"^\s*,?\s*(\(|'|‘|—\s*'|—\s*‘|\"|“)")


def paragraphs(text: str):
    """(first line number, paragraph text) for prose paragraphs: no frontmatter, code,
    HTML comments, headings or tables."""
    lines = text.splitlines()
    i, out, buf, start = 0, [], [], 0
    if lines and lines[0].strip() == "---":
        i = next((k + 1 for k in range(1, len(lines)) if lines[k].strip() == "---"), 0)
    in_code = in_comment = False
    for k in range(i, len(lines)):
        s = lines[k].strip()
        if s.startswith("```") or s.startswith("~~~"):
            in_code = not in_code
            continue
        if in_code:
            continue
        if in_comment or s.startswith("<!--"):
            in_comment = "-->" not in s
            continue
        if not s or s.startswith(("#", "|", ":::")):
            if buf:
                out.append((start, " ".join(buf)))
            buf = []
            continue
        if not buf:
            start = k + 1
        buf.append(s)
    if buf:
        out.append((start, " ".join(buf)))
    return out


def md_files(paths) -> list:
    out = []
    for p in map(Path, paths):
        if p.is_dir():
            out += sorted(f for f in p.rglob("*.md")
                          if f.name not in ("CONTEXT.md", "CLAUDE.md", "README.md")
                          and "drafts" not in f.parts)
        elif p.is_file():
            out.append(p)
        else:
            raise Fatal(f"{p} not found")
    return out


def cmd_density(args) -> int:
    folders = [resolve_language(args.lang, args.languages)] if args.lang else \
        language_dirs(args.languages)
    heads = {}
    for folder in folders:
        if not (folder / "lexicon.toml").is_file():
            continue
        for w in load_toml(folder / "lexicon.toml").get("word") or []:
            if not isinstance(w, dict) or str(w.get("pos")) in ("root", "affix", "name"):
                continue
            head = str(w.get("headword", "")).strip().strip("-")
            if len(head) >= 2:
                heads[head.casefold()] = folder.name
    bare_re = re.compile(r"(?<![\w\-])(" + "|".join(sorted(map(re.escape, heads), key=len,
                                                            reverse=True)) + r")(?![\w\-])",
                         re.I) if heads else None
    found = 0
    for f in md_files(args.paths):
        for line, para in paragraphs(read_text(f)):
            words, spans = {}, []
            for m in SPAN.finditer(para):
                spans.append((m.start(), m.end()))
                glossed = "gloss=" in m.group(2) or bool(GLOSS_AFTER.match(para[m.end():]))
                if not glossed:
                    words.setdefault(m.group(1).casefold(), m.group(1))
            if bare_re:
                for m in bare_re.finditer(para):
                    if any(a <= m.start() < b for a, b in spans):
                        continue
                    if not GLOSS_AFTER.match(para[m.end():]):
                        words.setdefault(m.group(1).casefold(), m.group(1))
            if len(words) > args.max:
                found += 1
                print(f"{shown(f)}:{line}: {len(words)} unglossed conlang words in one paragraph "
                      f"({', '.join(sorted(words.values(), key=str.casefold))}); more than "
                      f"{args.max} asks too much of the reader")
    print(f"density: {found} paragraph{'s' * (found != 1)} over the limit of {args.max}")
    return 1 if found and args.strict else 0


# ── self-test ─────────────────────────────────────────────────────────────────────────────

def self_test() -> int:
    """Build a small language in a temporary folder and prove each check still separates."""
    import contextlib
    import io
    import shutil
    import subprocess
    import tempfile
    print("lexicon.py --self-test")
    failures = []

    def expect(name: str, ok: bool, detail: str = "") -> None:
        print(f"  {'ok  ' if ok else 'FAIL'} {name}" + (f": {detail}" if detail and not ok else ""))
        if not ok:
            failures.append(name)

    def entry(head, ipa, pos):
        w = {k: "" for k in WORD_KEYS}
        w.update({k: [] for k in LISTS})
        w.update(headword=head, ipa=ipa, pos=pos, senses=["test"], irregular=False,
                 stratum="coinage", entered_after=0)
        return w

    def toml(value) -> str:
        if isinstance(value, bool):
            return "true" if value else "false"
        if isinstance(value, int):
            return str(value)
        if isinstance(value, list):
            return "[" + ", ".join(toml(v) for v in value) + "]"
        return '"' + str(value).replace("\\", "\\\\").replace('"', '\\"') + '"'

    decomposed = "pa\u0303"
    phonology = """[inventory]
consonants = ["p", "t", "k", "m", "n", "s", "l"]
vowels = ["a", "e", "i", "o", "u", "\u00e3"]
[classes]
C = ["p", "t", "k", "m", "n", "s", "l"]
V = ["a", "e", "i", "o", "u", "\u00e3"]
[phonotactics]
syllable = "(C)V(C)"
forbidden = ["tl"]
[stress]
rule = "%s"
"""
    words = [entry("kt", "kt", "root"), entry("-n", "n", "affix"), entry("-tl", "tl", "affix"),
             entry("-x", "x", "affix"), entry("kt", "kt", "noun"), entry(decomposed, decomposed, "noun"),
             entry("pata", "pata", "noun")]
    with tempfile.TemporaryDirectory() as tmp:
        langs = Path(tmp)
        for slug, rule in (("t", "penultimate"), ("lex", "lexical")):
            folder = langs / slug
            folder.mkdir()
            (folder / "phonology.toml").write_text(phonology % rule, encoding="utf-8")
            lines = [f'[meta]\nlanguage = "{slug}"\nslug = "{slug}"\n']
            for w in words:
                lines.append("[[word]]\n" + "".join(f"{k} = {toml(v)}\n" for k, v in w.items()))
            (folder / "lexicon.toml").write_text("\n".join(lines), encoding="utf-8")
        found = {}
        for slug in ("t", "lex"):
            lang = Language(langs / slug)
            check_words(lang, {slug: lang}, None, None)
            found[slug] = lang.report

        def about(report, n, kind="errors"):
            return [m for m in getattr(report, kind) if m.startswith(f"lexicon.toml word {n} ")]
        t = found["t"]
        expect("a consonantal root is not held to the syllable shapes", not about(t, 1),
               "; ".join(about(t, 1)))
        expect("a consonant-only affix is not held to the syllable shapes", not about(t, 2),
               "; ".join(about(t, 2)))
        expect("an affix is still held to the forbidden sequences",
               any("forbidden" in m for m in about(t, 3)))
        expect("an affix is still held to the inventory",
               any("not in the inventory" in m for m in about(t, 4)))
        expect("a word is still held to the syllable shapes",
               any("cannot be divided" in m for m in about(t, 5)))
        expect("a decomposed headword and IPA match the precomposed inventory", not about(t, 6),
               "; ".join(about(t, 6)))
        lex = found["lex"]
        expect("lexical stress: an unmarked word is warned",
               any("lexical" in m for m in about(lex, 7, "warnings")))
        expect("lexical stress: a root is not asked for a stress mark",
               not about(lex, 1, "warnings"), "; ".join(about(lex, 1, "warnings")))
        out = io.StringIO()
        with contextlib.redirect_stdout(out):
            code = main(["surface", "--languages", str(langs), "t", decomposed + "ta"])
        expect("surface takes decomposed IPA from the command line",
               code == 0 and "\u00e3" in out.getvalue(), out.getvalue().strip())
        # No tool reads what git ignores: a folder whose own .gitignore holds `*` is not
        # ignored itself, but every file in it is, so it is never found as a language.
        git = shutil.which("git")
        if git:
            hidden = langs / "hidden"
            hidden.mkdir()
            (hidden / "phonology.toml").write_text(phonology % "penultimate", encoding="utf-8")
            (hidden / ".gitignore").write_text("*\n", encoding="utf-8")
            subprocess.run([git, "init", "-q", str(langs)], capture_output=True, check=False)
            listed = [d.name for d in language_dirs(langs)]
            expect("a language folder whose files git ignores is never found",
                   listed == ["lex", "t"], ", ".join(listed))
        else:
            print("  skip a language folder whose files git ignores: git is not installed")
    print(f"lexicon.py --self-test: {'FAILED' if failures else 'passed'}")
    return 1 if failures else 0


# ── main ──────────────────────────────────────────────────────────────────────────────────

def main(argv=None) -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
        sys.stderr.reconfigure(encoding="utf-8")
    if (sys.argv[1:] if argv is None else list(argv)) == ["--self-test"]:
        return self_test()
    common = argparse.ArgumentParser(add_help=False)
    common.add_argument("--languages", type=Path, default=DEFAULT_LANGUAGES,
                        help="the languages folder (default: world/src/languages)")
    common.add_argument("--concepts", type=Path, default=DEFAULT_CONCEPTS,
                        help="the core concepts (default: tooling/data/core-concepts.toml)")
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0],
                                 formatter_class=argparse.RawDescriptionHelpFormatter,
                                 epilog="Run a subcommand with -h for its options.")
    sub = ap.add_subparsers(dest="cmd", required=True)
    c = sub.add_parser("check", parents=[common], help="check one language, or every language")
    c.add_argument("lang", nargs="?")
    d = sub.add_parser("derive", parents=[common], help="check daughters against their sound changes")
    d.add_argument("lang", nargs="?")
    d.add_argument("--trace", action="store_true", help="show every step of every derivation")
    d.add_argument("--form", help="derive this parent IPA form instead (needs LANG)")
    d.add_argument("--after", type=int, default=0,
                   help="with --form: skip rules up to and including this one (entered_after)")
    s = sub.add_parser("surface", parents=[common], help="phonemic IPA -> phonetic, with stress")
    s.add_argument("lang")
    s.add_argument("text", help="phonemic IPA (several words separated by spaces)")
    s.add_argument("--headword", action="store_true", help="TEXT is romanised words instead")
    v = sub.add_parser("coverage", parents=[common], help="core concepts and pronouns without a word")
    v.add_argument("lang", nargs="?")
    v.add_argument("--strict", action="store_true", help="exit 1 when anything is missing")
    sub.add_parser("family", parents=[common], help="print every language family tree")
    g = sub.add_parser("glossary", parents=[common], help="write a glossary and pronunciation guide")
    g.add_argument("lang", nargs="?")
    g.add_argument("--out", help="output file (one language only)")
    g.add_argument("--out-dir", default="build", help="folder for glossary-<slug>.md (build)")
    g.add_argument("--force", action="store_true", help="write it even if check finds errors")
    n = sub.add_parser("names", parents=[common], help="check the names register")
    n.add_argument("lang", nargs="?", help="only names in this language (default: every language)")
    n.add_argument("--register", type=Path, default=DEFAULT_REGISTER,
                   help="the names register (default: world/src/names-register.md)")
    y = sub.add_parser("density", parents=[common], help="paragraphs with too many conlang words")
    y.add_argument("paths", nargs="+", help="Markdown files or folders")
    y.add_argument("--lang", help="only this language's headwords (default: every language)")
    y.add_argument("--max", type=int, default=3, help="unglossed words allowed per paragraph (3)")
    y.add_argument("--strict", action="store_true", help="exit 1 when a paragraph is over")
    args = nfc_args(ap.parse_args(argv), "text", "form")
    commands = {"check": cmd_check, "derive": cmd_derive, "surface": cmd_surface,
                "coverage": cmd_coverage, "family": cmd_family, "glossary": cmd_glossary,
                "names": cmd_names, "density": cmd_density}
    try:
        return commands[args.cmd](args)
    except Fatal as err:
        print(f"error: {err}", file=sys.stderr)
        return 2
    except OSError as err:
        print(f"error: {err}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
