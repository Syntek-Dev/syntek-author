#!/usr/bin/env python3
# /// script
# requires-python = ">=3.11"
# dependencies = ["fonttools>=4.47"]
# ///
"""font.py: compile a constructed script's glyph SVGs into an OpenType font.

Usage (run through uv, which fetches fontTools for this script alone; nothing is installed):
    uv run tooling/font.py build [LANG] [--out build/fonts/LANG.otf]
    uv run tooling/font.py assign LANG [--missing]
    uv run tooling/font.py check [LANG]
    (every subcommand also takes --languages DIR; default world/src/languages)

LANG is a language folder's name under the languages folder (its slug), or a path to one.
Without LANG, build and check run on every language that has script/glyphs.toml.

build   Reads script/glyphs.toml and every glyph SVG, and writes build/fonts/<lang>.otf:
        CFF outlines (fontTools FontBuilder), each SVG path flipped from SVG coordinates
        (y down, baseline at y = ascender) into font units (y up, baseline at 0), with
        each glyph's advance width from [meta] (advance, or default_advance; a positional
        form takes its own viewBox width). Every string in glyphs.toml is read in Unicode
        NFC, as script.py reads it. Every glyph
        is mapped to its Private Use Area code point by the shared assignment in
        conlang_common.py, the same one `script.py transliterate --pua` uses. When glyphs
        carry positional forms, a 'calt' feature chooses the initial, medial, final or
        isolated form from the neighbouring glyphs.
assign  Prints the codepoint line for every glyph (assigned or already pinned), ready to
        paste into glyphs.toml so that the code points never move. --missing: only the
        glyphs not yet pinned. Needs no fontTools.
check   Validates every glyph SVG: exactly one filled path, no strokes, transforms or CSS
        (a <style> element or a class), the em-grid viewBox, and the outline inside the em box (descender to ascender, 0 to
        the advance). Exit 1 on any error.

Limits (v0.1, best effort): positional forms are chosen from the glyphs on either side
within the script's own run (a space, punctuation or a Latin letter ends a word); there is
no mark positioning, no kerning and no ligatures beyond what 'forms' provide; the font has
horizontal metrics only, so a 'ttb' script is set horizontally; and Private Use Area
characters are left-to-right to every text engine, so an 'rtl' script is drawn in logical
order unless the text is reversed or the engine is told the direction.

Exit codes: 0 = done; 1 = problems found; 2 = usage error, a missing file, or fontTools
missing (run it with `uv run`).
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from conlang_common import (DEFAULT_LANGUAGES, POSITIONS, ROOT, Fatal, advance,  # noqa: E402
                            assign_codepoints, ensure_parent, grid, grid_problems,
                            language_dirs, load_glyph_table, load_toml, read_svg,
                            resolve_language, shown, svg_shape_problems)

FEATURE_TAGS = {"initial": "init", "medial": "medi", "final": "fina", "isolated": "isol"}
VERSION = "0.1"


def fonttools():
    try:
        import fontTools  # noqa: F401
    except ImportError:
        raise Fatal("fontTools is not available: run this script with 'uv run tooling/font.py "
                    "...', which supplies it from the script's own metadata") from None


def glyph_name(gid: str, position: str | None = None) -> str:
    name = "g_" + re.sub(r"[^A-Za-z0-9_]", "_", gid)
    return f"{name}.{FEATURE_TAGS[position]}" if position else name


def display_name(folder: Path) -> str:
    for rel, key in (("language.toml", "name"), ("lexicon.toml", None)):
        path = folder / rel
        if path.is_file():
            data = load_toml(path)
            value = data.get(key) if key else (data.get("meta") or {}).get("language")
            if str(value or "").strip():
                return str(value).strip()
    return folder.name.replace("-", " ").title()


def svg_transform(meta: dict, vb):
    """The affine map from a glyph SVG's coordinates to font units (the y-flip)."""
    g = grid(meta)
    min_x, min_y, _, vb_h = vb or (0, 0, 0, g["units_per_em"])
    s = g["units_per_em"] / vb_h
    # x' = s (x - min_x);  y' = ascender - s (y - min_y)
    return (s, 0, 0, -s, -s * min_x, g["ascender"] + s * min_y)


def outline(path: Path, meta: dict):
    """Draw one glyph SVG into a RecordingPen in font units; returns (pen, bounds, area)."""
    from fontTools.pens.areaPen import AreaPen
    from fontTools.pens.boundsPen import BoundsPen
    from fontTools.pens.recordingPen import RecordingPen
    from fontTools.svgLib.path import SVGPath
    _, vb = read_svg(path)
    svg = SVGPath(str(path), transform=svg_transform(meta, vb))
    rec = RecordingPen()
    svg.draw(rec)
    if any(op == "endPath" for op, _ in rec.value):
        raise ValueError("an outline is left open (no closing Z); a glyph is a closed, filled shape")
    bounds, area = BoundsPen(None), AreaPen(None)
    rec.replay(bounds)
    rec.replay(area)
    return rec, bounds.bounds, area.value


def glyph_sources(script_dir: Path, glyphs: list):
    """(glyph, position or None, svg path) for every base glyph and positional form."""
    for g in glyphs:
        yield g, None, script_dir / str(g.get("svg", ""))
        forms = g.get("forms") or {}
        for pos in POSITIONS:
            if isinstance(forms, dict) and forms.get(pos):
                yield g, pos, script_dir / str(forms[pos])


def check_folder(folder: Path, quiet_ok: bool = False) -> int:
    fonttools()
    meta, glyphs = load_glyph_table(folder)
    g = grid(meta)
    errors, warnings = list(grid_problems(meta)), []
    _, cp_problems = assign_codepoints(glyphs)
    errors += cp_problems
    for glyph, pos, path in glyph_sources(folder / "script", glyphs):
        label = f"glyph {glyph.get('id')!r}" + (f" ({pos} form)" if pos else "")
        adv = advance(glyph, meta)
        if not path.is_file():
            errors.append(f"{label}: {shown(path)} not found")
            continue
        errs, warns = svg_shape_problems(path, meta, adv)
        if pos:
            warns = [w for w in warns if "differs from the glyph's advance" not in w]
        errors += [f"{label}: {e}" for e in errs]
        warnings += [f"{label}: {w}" for w in warns]
        if errs:
            continue
        try:
            _, bounds, area = outline(path, meta)
        except ValueError as err:
            errors.append(f"{label}: {shown(path)}: {err}")
            continue
        except Exception as err:  # noqa: BLE001 - any parse failure is the SVG's
            errors.append(f"{label}: {shown(path)}: the path cannot be read "
                          f"({type(err).__name__}: {err})")
            continue
        if bounds is None:
            errors.append(f"{label}: {shown(path)}: the path draws nothing")
            continue
        _, vb = read_svg(path)
        width = (vb[2] * g["units_per_em"] / vb[3]) if vb else adv
        x0, y0, x1, y1 = bounds
        if x0 < -0.5 or x1 > width + 0.5 or y0 < g["descender"] - 0.5 or y1 > g["ascender"] + 0.5:
            errors.append(f"{label}: {shown(path)}: the outline spans x {x0:g} to {x1:g} and y "
                          f"{y0:g} to {y1:g} in font units, outside the em box (x 0 to "
                          f"{width:g}, y {g['descender']} to {g['ascender']})")
        if abs(area) < 1:
            errors.append(f"{label}: {shown(path)}: the outline encloses no area (an open "
                          f"stroke?); glyphs are filled shapes")
    for msg in errors:
        print(f"  error   {msg}")
    for msg in warnings:
        print(f"  warning {msg}")
    e, w = len(errors), len(warnings)
    if not quiet_ok or e or w:
        print(f"{folder.name} glyphs: {len(glyphs)} glyph{'s' * (len(glyphs) != 1)}; "
              f"{e} error{'s' * (e != 1)}, {w} warning{'s' * (w != 1)}")
    return 1 if errors else 0


def features(glyphs: list) -> str:
    """A 'calt' feature choosing positional forms from the neighbouring script glyphs."""
    bases = [glyph_name(str(g["id"])) for g in glyphs]
    forms = {pos: [(glyph_name(str(g["id"])), glyph_name(str(g["id"]), pos))
                   for g in glyphs if isinstance(g.get("forms"), dict) and g["forms"].get(pos)]
             for pos in POSITIONS}
    if not any(forms.values()):
        return ""
    every = bases + [alt for pairs in forms.values() for _, alt in pairs]
    lines = [f"@SCRIPT = [{' '.join(every)}];"]
    for pos, pairs in forms.items():
        if not pairs:
            continue
        tag = FEATURE_TAGS[pos]
        lines.append(f"@{tag}_from = [{' '.join(b for b, _ in pairs)}];")
        lines.append(f"lookup {tag}_single {{")
        lines += [f"    sub {b} by {a};" for b, a in pairs]
        lines.append(f"}} {tag}_single;")
    lines.append("feature calt {")
    contexts = {
        "medial": ["    sub @SCRIPT @medi_from' lookup medi_single @SCRIPT;"],
        "initial": ["    ignore sub @SCRIPT @init_from';",
                    "    sub @init_from' lookup init_single @SCRIPT;"],
        "final": ["    ignore sub @fina_from' @SCRIPT;",
                  "    sub @SCRIPT @fina_from' lookup fina_single;"],
        "isolated": ["    ignore sub @SCRIPT @isol_from';", "    ignore sub @isol_from' @SCRIPT;",
                     "    sub @isol_from' lookup isol_single;"],
    }
    for pos in ("medial", "initial", "final", "isolated"):
        if forms[pos]:
            tag = FEATURE_TAGS[pos]
            lines.append(f"    lookup calt_{tag} {{")
            lines += ["    " + line for line in contexts[pos]]
            lines.append(f"    }} calt_{tag};")
    lines.append("} calt;")
    return "\n".join(lines) + "\n"


def build_folder(folder: Path, out: Path) -> int:
    fonttools()
    from fontTools.feaLib.builder import addOpenTypeFeaturesFromString
    from fontTools.fontBuilder import FontBuilder
    from fontTools.pens.recordingPen import RecordingPen
    from fontTools.pens.reverseContourPen import ReverseContourPen
    from fontTools.pens.t2CharStringPen import T2CharStringPen
    if check_folder(folder, quiet_ok=True):
        print(f"{folder.name}: font not built; fix the errors above (uv run tooling/font.py check)")
        return 1
    meta, glyphs = load_glyph_table(folder)
    g = grid(meta)
    assigned, _ = assign_codepoints(glyphs)
    order, charstrings, metrics, cmap = [".notdef", "space"], {}, {}, {0x20: "space", 0xA0: "space"}
    space = g["default_advance"] // 2

    def charstring(rec, width):
        pen = T2CharStringPen(width, None)
        rec.replay(pen)
        return pen.getCharString()

    notdef = RecordingPen()
    w, m = g["default_advance"], 50
    for x0, y0, x1, y1, rev in ((m, 0, w - m, g["ascender"] - m, False),
                                (m + 60, 60, w - m - 60, g["ascender"] - m - 60, True)):
        pts = [(x0, y0), (x1, y0), (x1, y1), (x0, y1)]
        pts = pts[::-1] if rev else pts
        notdef.moveTo(pts[0])
        for p in pts[1:]:
            notdef.lineTo(p)
        notdef.closePath()
    charstrings[".notdef"] = charstring(notdef, w)
    metrics[".notdef"] = (w, m)
    charstrings["space"] = charstring(RecordingPen(), space)
    metrics["space"] = (space, 0)
    reversed_ = []
    by_id = {str(gl.get("id")): cp for gl, cp, _ in assigned}
    for glyph, pos, path in glyph_sources(folder / "script", glyphs):
        gid = str(glyph.get("id", "")).strip()
        if not gid:
            continue
        name = glyph_name(gid, pos)
        rec, bounds, area = outline(path, meta)
        if area < 0:  # clockwise after the flip: CFF wants counter-clockwise outer contours
            fixed = RecordingPen()
            rec.replay(ReverseContourPen(fixed))
            rec = fixed
            reversed_.append(name)
        _, vb = read_svg(path)
        width = advance(glyph, meta) if not pos or not vb else round(vb[2] * g["units_per_em"]
                                                                       / vb[3])
        order.append(name)
        charstrings[name] = charstring(rec, width)
        metrics[name] = (width, int(bounds[0]) if bounds else 0)
        if not pos:
            cmap[by_id[gid]] = name
    family = display_name(folder)
    ps = re.sub(r"[^A-Za-z0-9]", "", family) or "Conlang"
    fb = FontBuilder(g["units_per_em"], isTTF=False)
    fb.setupGlyphOrder(order)
    fb.setupCharacterMap(cmap)
    fb.setupCFF(f"{ps}-Regular", {"FullName": f"{family} Regular", "FamilyName": family,
                                  "Weight": "Regular"}, charstrings, {})
    fb.setupHorizontalMetrics(metrics)
    fb.setupHorizontalHeader(ascent=g["ascender"], descent=g["descender"])
    fb.setupNameTable({"familyName": family, "styleName": "Regular",
                       "uniqueFontIdentifier": f"{ps}-Regular;{VERSION}",
                       "fullName": f"{family} Regular", "psName": f"{ps}-Regular",
                       "version": f"Version {VERSION}"})
    fb.setupOS2(sTypoAscender=g["ascender"], sTypoDescender=g["descender"], sTypoLineGap=0,
                usWinAscent=g["ascender"], usWinDescent=-g["descender"],
                achVendID="NONE", fsType=0)
    fb.setupPost()
    fea = features(glyphs)
    if fea:
        addOpenTypeFeaturesFromString(fb.font, fea)
    ensure_parent(out)
    fb.save(str(out))
    print(f"wrote {shown(out)}: {len(order) - 2} glyph{'s' * (len(order) != 3)}, family "
          f"{family!r}, U+{min(c for c in cmap if c > 0xFF):04X} to U+{max(cmap):04X}"
          + (", calt positional forms" if fea else ""))
    if reversed_:
        print(f"  note: reversed the contour direction of {', '.join(reversed_)} (clockwise after "
              f"the y-flip); drawing the SVG the other way round avoids this")
    return 0


def cmd_build(args) -> int:
    if args.lang:
        folders = [resolve_language(args.lang, args.languages, "script/glyphs.toml")]
    else:
        folders = language_dirs(args.languages, "script/glyphs.toml")
        if not folders:
            print(f"no language in {shown(args.languages)} has a script yet; nothing to build")
            return 0
    if args.out and len(folders) != 1:
        raise Fatal("--out names one font; give LANG too")
    status = 0
    for folder in folders:
        out = Path(args.out) if args.out else ROOT / "build" / "fonts" / f"{folder.name}.otf"
        status = max(status, build_folder(folder, out))
    return status


def cmd_assign(args) -> int:
    folder = resolve_language(args.lang, args.languages, "script/glyphs.toml")
    _, glyphs = load_glyph_table(folder)
    assigned, problems = assign_codepoints(glyphs)
    for msg in problems:
        print(f"# error: {msg}", file=sys.stderr)
    print(f"# Code points for {folder.name}: paste each codepoint line into its [[glyph]] in")
    print(f"# {shown(folder / 'script' / 'glyphs.toml')} so that they never move.")
    for glyph, cp, explicit in assigned:
        if args.missing and explicit:
            continue
        state = "pinned" if explicit else "assigned"
        print(f'codepoint = "U+{cp:04X}"    # glyph {glyph.get("id")!r} ({state})')
    return 1 if problems else 0


def cmd_check(args) -> int:
    if args.lang:
        folders = [resolve_language(args.lang, args.languages, "script/glyphs.toml")]
    else:
        folders = language_dirs(args.languages, "script/glyphs.toml")
        if not folders:
            print(f"no language in {shown(args.languages)} has a script yet")
            return 0
    return max(check_folder(f) for f in folders)


def main(argv=None) -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
        sys.stderr.reconfigure(encoding="utf-8")
    common = argparse.ArgumentParser(add_help=False)
    common.add_argument("--languages", type=Path, default=DEFAULT_LANGUAGES,
                        help="the languages folder (default: world/src/languages)")
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0],
                                 formatter_class=argparse.RawDescriptionHelpFormatter,
                                 epilog="Run a subcommand with -h for its options.")
    sub = ap.add_subparsers(dest="cmd", required=True)
    b = sub.add_parser("build", parents=[common], help="compile the glyphs into build/fonts/<lang>.otf")
    b.add_argument("lang", nargs="?")
    b.add_argument("--out", help="the font to write (one language only)")
    a = sub.add_parser("assign", parents=[common], help="print the code-point pins")
    a.add_argument("lang")
    a.add_argument("--missing", action="store_true", help="only glyphs not yet pinned")
    c = sub.add_parser("check", parents=[common], help="validate the glyph SVGs")
    c.add_argument("lang", nargs="?")
    args = ap.parse_args(argv)
    try:
        return {"build": cmd_build, "assign": cmd_assign, "check": cmd_check}[args.cmd](args)
    except Fatal as err:
        print(f"error: {err}", file=sys.stderr)
        return 2
    except OSError as err:
        print(f"error: {err}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
