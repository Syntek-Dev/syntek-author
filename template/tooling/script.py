#!/usr/bin/env python3
"""script.py: write a constructed language in its own script.

Usage:
    python3 tooling/script.py transliterate LANG "text" [--pua] [--ipa]
    python3 tooling/script.py render LANG ["text"] --out build/x.svg [--sample] [--ipa] [--size 64]
    python3 tooling/script.py check [LANG]
    python3 tooling/script.py --self-test
    (every subcommand also takes --languages DIR; default world/src/languages)

LANG is a language folder's name under the languages folder (its slug), or a path to one.
The script lives in LANG/script/: glyphs.toml ([meta], [meta.inspiration] and [[glyph]]
entries) and one filled-outline SVG per glyph and positional form.

transliterate  Romanised text -> glyphs, by greedy longest match over each glyph's
               romanisation (or its ipa, with --ipa). Prints 'glyphs:' (ids joined by '·'
               within a word) and 'native:' (the Private Use Area text). With --pua it prints
               the Private Use Area text alone, for Pandoc filters and LaTeX. Spaces and
               punctuation with no glyph of their own pass through unchanged.
render         Composes the glyph SVGs into one SVG on the em grid in [meta], honouring the
               direction (ltr, rtl or ttb) and each glyph's positional forms, exactly as the
               font sets them: every outline at its own scale (never stretched to fit), the pen
               moved by the glyph's advance, or by a positional form's own viewBox width. With
               --sample and no text: up to three lexicon words the script can write, or else
               every glyph once.
check          glyphs.toml and every glyph file: the em grid, the script's inspiration, ids,
               romanisations, code points (pinned or assigned), each SVG's shape (one filled
               path, no strokes, transforms or CSS, the em-grid viewBox); and the lexicon words
               the script cannot yet write. Without LANG, every language that has a script.
--self-test    Proves the shape check, the rendering and the normalisation still hold, on a
               small script built in a temporary folder.

Text from the command line is NFC-normalised, as every data file is, so a decomposed letter
matches its precomposed form.

Code points come from the one assignment tooling/font.py also uses (conlang_common.py):
an explicit codepoint wins; the rest follow the highest explicit one in file order, from
U+E000. So the text --pua prints is exactly what the built font draws.

Standard library only; Python 3.11+ (tomllib).
Exit codes: 0 = done (warnings may be printed); 1 = text that cannot be written, or
problems found; 2 = usage error, or a file is missing or cannot be parsed.
"""
from __future__ import annotations

import argparse
import copy
import re
import sys
import unicodedata
import xml.etree.ElementTree as ET
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from conlang_common import (DEFAULT_LANGUAGES, DIRECTIONS, MEDIUMS, POSITIONS,  # noqa: E402
                            SCRIPT_TYPES, SVG_NS, TOOLS, Fatal, advance, assign_codepoints,
                            ensure_parent, grid, grid_problems, language_dirs, load_glyph_table,
                            load_toml, nfc_args, read_svg, resolve_language, shown,
                            svg_shape_problems)

XLINK_NS = "http://www.w3.org/1999/xlink"
ET.register_namespace("", SVG_NS)
ET.register_namespace("xlink", XLINK_NS)


class Script:
    def __init__(self, folder: Path):
        self.folder = folder
        self.dir = folder / "script"
        self.meta, self.glyphs = load_glyph_table(folder)
        self.type = str(self.meta.get("type", "")).strip().lower()
        self.direction = str(self.meta.get("direction", "ltr")).strip().lower()
        self.grid = grid(self.meta)
        self.by_id = {}
        for g in self.glyphs:
            self.by_id.setdefault(str(g.get("id", "")), g)
        assigned, self.cp_problems = assign_codepoints(self.glyphs)
        self.cps = {id(g): cp for g, cp, _ in assigned}

    def table(self, key: str) -> list:
        """(match text, glyph) pairs for longest-match lookup, longest first."""
        pairs = [(str(g.get(key, "")).casefold(), g) for g in self.glyphs if g.get(key)]
        return sorted(pairs, key=lambda p: len(p[0]), reverse=True)

    def codepoint(self, g: dict):
        cp = self.cps.get(id(g))
        return chr(cp) if cp is not None else None

    def advance(self, g: dict) -> int:
        return advance(g, self.meta)


def load_script(folder: Path) -> Script:
    return Script(folder)


def clean_ipa_text(text: str) -> str:
    return re.sub(r"[/\[\]ˈˌ.]", "", text)


def split_words(text: str, script: Script, key: str):
    """Text -> list of words; a word is a list of glyphs or punctuation strings.

    Raises ValueError naming the first character no glyph can write."""
    table = script.table(key)
    words = []
    for raw in text.split():
        word, i, low = [], 0, raw.casefold()
        while i < len(low):
            match = next(((t, g) for t, g in table if low.startswith(t, i)), None)
            if match:
                word.append(match[1])
                i += len(match[0])
            elif unicodedata.category(raw[i])[0] in "PS":
                word.append(raw[i])
                i += 1
            else:
                raise ValueError(f"cannot write {raw[i]!r} at position {i + 1} of {raw!r}: no "
                                 f"glyph's {key} starts there")
        words.append(word)
    return words


def transliterate(text: str, script: Script, key: str = "romanisation"):
    """(glyph ids joined by '·' within words, Private Use Area text); raises ValueError."""
    words = split_words(text, script, key)
    ids = " ".join(_join(w) for w in words)
    native = " ".join("".join(script.codepoint(g) if isinstance(g, dict) else g for g in w)
                      for w in words)
    return ids, native


def _join(word: list) -> str:
    """Glyph ids joined by '·'; punctuation is attached without a separator."""
    out = ""
    for g in word:
        if isinstance(g, dict):
            sep = "·" if out and unicodedata.category(out[-1])[0] not in "PS" else ""
            out += sep + str(g["id"])
        else:
            out += g
    return out


def glyph_file(script: Script, g: dict, position: str):
    """(the SVG to draw at this position, whether it is a positional form)."""
    forms = g.get("forms") or {}
    rel = forms.get(position) if isinstance(forms, dict) else None
    return script.dir / str(rel or g.get("svg", "")), bool(rel)


def qualify(el: ET.Element):
    for node in el.iter():
        if isinstance(node.tag, str) and not node.tag.startswith("{"):
            node.tag = f"{{{SVG_NS}}}{node.tag}"


def prefix_ids(el: ET.Element, prefix: str):
    """Rename every id inside one glyph copy, and the references to it, so copies never clash."""
    ids = {n.get("id") for n in el.iter() if n.get("id")}
    if not ids:
        return
    for node in el.iter():
        if node.get("id"):
            node.set("id", prefix + node.get("id"))
        for attr, value in list(node.attrib.items()):
            new = value
            for old in ids:
                new = new.replace(f"url(#{old})", f"url(#{prefix}{old})")
                if attr in ("href", f"{{{XLINK_NS}}}href") and new == f"#{old}":
                    new = f"#{prefix}{old}"
            if new != value:
                node.set(attr, new)


def position_of(i: int, n: int) -> str:
    return "isolated" if n == 1 else "initial" if i == 0 else "final" if i == n - 1 else "medial"


def render(script: Script, words: list, size: float, title: str) -> ET.Element:
    """Compose the words on the em grid; size is the rendered height of one em, in px.

    Each outline is drawn as font.py builds it: scaled only by units_per_em over its viewBox
    height (1 on the house grid), never stretched to a box, so the sample and the font agree.
    The pen moves by the glyph's advance, or by a positional form's own viewBox width."""
    upm = script.grid["units_per_em"]
    space = script.grid["default_advance"] // 2
    placed, pen = [], 0
    for wi, word in enumerate(words):
        glyphs = [g for g in word if isinstance(g, dict)]
        for gi, g in enumerate(glyphs):
            path, is_form = glyph_file(script, g, position_of(gi, len(glyphs)))
            if not path.is_file():
                raise ValueError(f"glyph {g.get('id')!r}: SVG file {shown(path)} not found")
            root, vb = read_svg(path)
            vb = vb or (0, 0, script.advance(g), upm)
            drawn = vb[2] * upm / vb[3]
            adv = round(drawn) if is_form else script.advance(g)
            placed.append((root, vb, pen, adv, drawn))
            pen += upm if script.direction == "ttb" else adv
        if wi < len(words) - 1:
            pen += space
    if not placed:
        raise ValueError("nothing to render: the text has no glyphs")
    if script.direction == "ttb":
        width, height = max(p[3] for p in placed), pen
    else:
        width, height = pen, upm
    scale = size / upm
    out = ET.Element(f"{{{SVG_NS}}}svg", {"viewBox": f"0 0 {width} {height}",
                                           "width": f"{width * scale:.2f}",
                                           "height": f"{height * scale:.2f}"})
    ET.SubElement(out, f"{{{SVG_NS}}}title").text = title
    keep_out = {"xmlns", "width", "height", "viewBox", "x", "y", "version", "id",
                "preserveAspectRatio"}
    for i, (root, (mx, my, vw, vh), at, adv, drawn) in enumerate(placed):
        if script.direction == "ttb":
            x, y = (width - adv) / 2, at
        elif script.direction == "rtl":
            x, y = width - at - adv, 0
        else:
            x, y = at, 0
        inner = ET.SubElement(out, f"{{{SVG_NS}}}svg", {
            "x": f"{x:g}", "y": f"{y:g}", "width": f"{drawn:g}", "height": f"{upm:g}",
            "viewBox": f"{mx:g} {my:g} {vw:g} {vh:g}", "preserveAspectRatio": "xMinYMin meet",
            "overflow": "visible"})
        for attr, value in root.attrib.items():
            if attr.split("}")[-1] not in keep_out:
                inner.set(attr, value)
        for child in root:
            inner.append(copy.deepcopy(child))
        qualify(inner)
        prefix_ids(inner, f"g{i + 1}-")
    return out


def lexicon_headwords(folder: Path) -> list:
    path = folder / "lexicon.toml"
    if not path.is_file():
        return []
    words = load_toml(path).get("word") or []
    return [str(w.get("headword", "")).strip() for w in words
            if isinstance(w, dict) and str(w.get("headword", "")).strip()
            and str(w.get("pos", "")) not in ("root", "affix")]


def cmd_transliterate(args) -> int:
    script = Script(resolve_language(args.lang, args.languages, "script/glyphs.toml"))
    key = "ipa" if args.ipa else "romanisation"
    text = clean_ipa_text(args.text) if args.ipa else args.text
    try:
        ids, native = transliterate(text, script, key)
    except ValueError as err:
        print(f"error: {err}", file=sys.stderr)
        return 1
    if args.pua:
        print(native)
        return 0
    print(f"glyphs: {ids}")
    print(f"native: {native}")
    return 0


def cmd_render(args) -> int:
    folder = resolve_language(args.lang, args.languages, "script/glyphs.toml")
    script = Script(folder)
    key = "ipa" if args.ipa else "romanisation"
    if args.text:
        text = clean_ipa_text(args.text) if args.ipa else args.text
        try:
            words = split_words(text, script, key)
        except ValueError as err:
            print(f"error: {err}", file=sys.stderr)
            return 1
        title = args.text
    elif args.sample:
        chosen = []
        for head in lexicon_headwords(folder):
            try:
                chosen.append((head, split_words(head, script, "romanisation")))
            except ValueError:
                continue
            if len(chosen) == 3:
                break
        if chosen:
            title = " ".join(h for h, _ in chosen)
            words = [w for _, ws in chosen for w in ws]
            print(f"sample: {title}")
        else:
            words = [[g] for g in script.glyphs]
            title = "every glyph"
            print("sample: no lexicon word can be written yet, so every glyph once")
    else:
        print("error: give the text to render, or --sample", file=sys.stderr)
        return 2
    try:
        svg = render(script, words, args.size, title)
    except ValueError as err:
        print(f"error: {err}", file=sys.stderr)
        return 1
    out = Path(args.out)
    ensure_parent(out)
    ET.ElementTree(svg).write(out, encoding="utf-8", xml_declaration=True)
    n = sum(1 for w in words for g in w if isinstance(g, dict))
    print(f"wrote {out} ({n} glyph{'s' * (n != 1)}, {script.direction})")
    return 0


def check_inspiration(meta: dict, warnings: list):
    insp = meta.get("inspiration")
    if not isinstance(insp, dict):
        warnings.append("no [meta.inspiration]: a script takes real-world inspiration by default "
                        "(medium, tool, origin and a script family's structure, never its glyphs)")
        return
    for key, allowed in (("medium", MEDIUMS), ("tool", TOOLS)):
        value = str(insp.get(key, "") or "")
        if not value:
            warnings.append(f"[meta.inspiration] {key} is empty")
        elif value not in allowed:
            warnings.append(f"[meta.inspiration] {key} {value!r} is not one of {', '.join(allowed)}")
    origin = str(insp.get("origin", "") or "")
    if not origin:
        warnings.append("[meta.inspiration] origin is empty (native, borrowed:<from> or "
                        "adapted:<from>)")
    elif not re.fullmatch(r"native|(borrowed|adapted):.+", origin):
        warnings.append(f"[meta.inspiration] origin {origin!r}: write native, borrowed:<from> or "
                        f"adapted:<from>")
    if str(insp.get("script_family", "") or "") and not insp.get("sources"):
        warnings.append("[meta.inspiration] names a script family but no sources: claims about a "
                        "real script are researched and cited")
    odd = [b for b in insp.get("borrows") or [] if b not in
           ("structure", "direction", "stroke-style", "layout")]
    if odd:
        warnings.append(f"[meta.inspiration] borrows {odd}: expected structure, direction, "
                        f"stroke-style or layout (never the glyphs themselves)")


def check_one(folder: Path) -> int:
    script = Script(folder)
    errors, warnings = [], []
    if script.type not in SCRIPT_TYPES:
        warnings.append(f"[meta] type is {script.type!r}; expected one of {', '.join(SCRIPT_TYPES)}")
    if script.direction not in DIRECTIONS:
        errors.append(f"[meta] direction is {script.direction!r}; it must be ltr, rtl or ttb")
    errors += grid_problems(script.meta)
    check_inspiration(script.meta, warnings)
    errors += script.cp_problems
    seen_ids, seen_rom = {}, {}
    for n, g in enumerate(script.glyphs, start=1):
        gid = str(g.get("id", "")).strip()
        label = f"glyph {n} {gid!r}"
        if not gid:
            errors.append(f"glyph {n}: no id")
        elif not re.fullmatch(r"[a-z0-9][a-z0-9_-]*", gid):
            errors.append(f"{label}: ids are lower case letters, digits, '-' and '_' (the font "
                          f"names its glyphs after them)")
        elif gid in seen_ids:
            errors.append(f"{label}: id already used by glyph {seen_ids[gid]}")
        seen_ids.setdefault(gid, n)
        rom = str(g.get("romanisation", "")).strip().casefold()
        if not rom:
            errors.append(f"{label}: no romanisation")
        elif rom in seen_rom:
            warnings.append(f"{label}: romanisation {rom!r} is shared with glyph {seen_rom[rom]}; "
                            f"transliteration always picks glyph {seen_rom[rom]}")
        seen_rom.setdefault(rom, n)
        adv = script.advance(g)
        if "advance" in g and not isinstance(g["advance"], int):
            errors.append(f"{label}: advance must be a whole number (0 = default_advance)")
        files = [("svg", g.get("svg"))]
        forms = g.get("forms") or {}
        if not isinstance(forms, dict):
            errors.append(f"{label}: forms must be a table, for example forms = {{}}")
            forms = {}
        for pos, rel in forms.items():
            if pos not in POSITIONS:
                errors.append(f"{label}: form {pos!r} is not one of {', '.join(POSITIONS)}")
            files.append((f"form {pos}", rel))
        for what, rel in files:
            if not rel:
                errors.append(f"{label}: no {what} file")
                continue
            path = script.dir / str(rel)
            if not path.is_file():
                errors.append(f"{label}: {what}: {shown(path)} not found")
                continue
            errs, warns = svg_shape_problems(path, script.meta, adv)
            if what != "svg":
                warns = [w for w in warns if "differs from the glyph's advance" not in w]
            errors += [f"{label}: {e}" for e in errs]
            warnings += [f"{label}: {w}" for w in warns]
    unwritable = []
    for head in lexicon_headwords(folder):
        try:
            split_words(head, script, "romanisation")
        except ValueError:
            unwritable.append(head)
    if unwritable:
        listed = ", ".join(repr(h) for h in unwritable[:10])
        more = f" and {len(unwritable) - 10} more" if len(unwritable) > 10 else ""
        warnings.append(f"the script cannot yet write {len(unwritable)} lexicon "
                        f"word{'s' * (len(unwritable) != 1)}: {listed}{more}")
    for msg in errors:
        print(f"  error   script/glyphs.toml: {msg}")
    for msg in warnings:
        print(f"  warning script/glyphs.toml: {msg}")
    e, w = len(errors), len(warnings)
    print(f"{folder.name} script: {len(script.glyphs)} glyph{'s' * (len(script.glyphs) != 1)}; "
          f"{e} error{'s' * (e != 1)}, {w} warning{'s' * (w != 1)}")
    return 1 if errors else 0


def cmd_check(args) -> int:
    if args.lang:
        folders = [resolve_language(args.lang, args.languages, "script/glyphs.toml")]
    else:
        folders = language_dirs(args.languages, "script/glyphs.toml")
        if not folders:
            print(f"no language in {shown(args.languages)} has a script yet")
            return 0
    return max(check_one(f) for f in folders)


def self_test() -> int:
    """Build a small script in a temporary folder and prove each check still separates."""
    import contextlib
    import io
    import tempfile
    print("script.py --self-test")
    failures = []

    def expect(name: str, ok: bool, detail: str = "") -> None:
        print(f"  {'ok  ' if ok else 'FAIL'} {name}" + (f": {detail}" if detail and not ok else ""))
        if not ok:
            failures.append(name)

    def svg(width: int, body: str) -> str:
        return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {width} 1000">{body}'
                f'</svg>')

    box = '<path fill="currentColor" d="M 0 700 L {w} 700 L {w} 500 L 0 500 Z"/>'
    meta = {"units_per_em": 1000, "ascender": 800, "descender": -200, "default_advance": 500}
    with tempfile.TemporaryDirectory() as tmp:
        langs = Path(tmp)
        folder = langs / "t"
        (folder / "script" / "glyphs").mkdir(parents=True)
        (folder / "lexicon.toml").write_text('[meta]\nslug = "t"\n', encoding="utf-8")
        files = {"a.svg": svg(500, box.format(w=500)), "a-medi.svg": svg(300, box.format(w=300)),
                 "b.svg": svg(600, box.format(w=600)),
                 "css.svg": svg(500, "<style>.st0{fill:none;stroke:#000;stroke-width:40}</style>"
                                     '<path class="st0" d="M 0 700 L 500 700 L 500 500 Z"/>'),
                 "class.svg": svg(500, '<path class="ink" fill="currentColor" '
                                       'd="M 0 700 L 500 700 L 500 500 Z"/>')}
        for name, text in files.items():
            (folder / "script" / "glyphs" / name).write_text(text, encoding="utf-8")
        (folder / "script" / "glyphs.toml").write_text(
            "[meta]\n" + "".join(f"{k} = {v}\n" for k, v in meta.items())
            + 'type = "alphabet"\ndirection = "ltr"\n'
            + '[[glyph]]\nid = "a"\nromanisation = "a\u0303"\nsvg = "glyphs/a.svg"\n'
            + 'forms = { medial = "glyphs/a-medi.svg" }\n'
            + '[[glyph]]\nid = "b"\nromanisation = "b"\nsvg = "glyphs/b.svg"\n', encoding="utf-8")
        glyphs = folder / "script" / "glyphs"
        errs, _ = svg_shape_problems(glyphs / "a.svg", meta, 500)
        expect("a filled outline passes the shape check", not errs, "; ".join(errs))
        errs, _ = svg_shape_problems(glyphs / "css.svg", meta, 500)
        expect("a stroke set through a <style> class is refused",
               any("<style>" in e for e in errs) and any("class=" in e for e in errs),
               "; ".join(errs) or "no error")
        errs, _ = svg_shape_problems(glyphs / "class.svg", meta, 500)
        expect("a class on a drawing element is refused", any("class=" in e for e in errs),
               "; ".join(errs) or "no error")
        script = Script(folder)
        try:
            words = split_words("b\u00e3b", script, "romanisation")
        except ValueError as err:
            words = []
            expect("a precomposed letter matches a decomposed romanisation", False, str(err))
        else:
            expect("a precomposed letter matches a decomposed romanisation",
                   [g["id"] for g in words[0]] == ["b", "a", "b"])
        if words:
            out = render(script, words, 64.0, "test")
            inner = [el for el in out if el.tag.endswith("svg")]
            sizes = [(el.get("x"), el.get("width"), el.get("viewBox")) for el in inner]
            expect("a medial form is drawn at its own width and moves the pen by it",
                   sizes[1] == ("500", "300", "0 0 300 1000") and sizes[2][0] == "800",
                   str(sizes))
            expect("a glyph wider than its advance is drawn unstretched",
                   sizes[0] == ("0", "600", "0 0 600 1000"), str(sizes))
            expect("the sample is as wide as the font sets the word",
                   out.get("viewBox") == "0 0 1300 1000", str(out.get("viewBox")))
        text = io.StringIO()
        with contextlib.redirect_stdout(text):
            code = main(["transliterate", "--languages", str(langs), "t", "ba\u0303"])
        expect("transliterate takes decomposed text from the command line",
               code == 0 and "glyphs: b·a" in text.getvalue(), text.getvalue().strip())
    print(f"script.py --self-test: {'FAILED' if failures else 'passed'}")
    return 1 if failures else 0


def main(argv=None) -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
        sys.stderr.reconfigure(encoding="utf-8")
    if (sys.argv[1:] if argv is None else list(argv)) == ["--self-test"]:
        return self_test()
    common = argparse.ArgumentParser(add_help=False)
    common.add_argument("--languages", type=Path, default=DEFAULT_LANGUAGES,
                        help="the languages folder (default: world/src/languages)")
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0],
                                 formatter_class=argparse.RawDescriptionHelpFormatter,
                                 epilog="Run a subcommand with -h for its options.")
    sub = ap.add_subparsers(dest="cmd", required=True)
    t = sub.add_parser("transliterate", parents=[common], help="romanised text -> glyphs")
    t.add_argument("lang")
    t.add_argument("text")
    t.add_argument("--ipa", action="store_true", help="the text is IPA; match glyphs by ipa")
    t.add_argument("--pua", action="store_true",
                   help="print only the Private Use Area text (for the font)")
    r = sub.add_parser("render", parents=[common], help="text -> one composed SVG")
    r.add_argument("lang")
    r.add_argument("text", nargs="?")
    r.add_argument("--out", required=True, help="the SVG to write, for example build/sample.svg")
    r.add_argument("--sample", action="store_true", help="with no text: render lexicon words")
    r.add_argument("--ipa", action="store_true", help="the text is IPA; match glyphs by ipa")
    r.add_argument("--size", type=float, default=64.0, help="height of one em in px (64)")
    c = sub.add_parser("check", parents=[common], help="check glyphs.toml and the glyph files")
    c.add_argument("lang", nargs="?")
    args = nfc_args(ap.parse_args(argv), "text")
    try:
        return {"transliterate": cmd_transliterate, "render": cmd_render,
                "check": cmd_check}[args.cmd](args)
    except Fatal as err:
        print(f"error: {err}", file=sys.stderr)
        return 2
    except OSError as err:
        print(f"error: {err}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
