#!/usr/bin/env python3
"""Export the `refs` table from the SQLite master to CSL-JSON for Pandoc --citeproc.

Usage:
    python3 tooling/export_refs.py [--db tooling/references.db] [--out build/references.json]

Pandoc includes only the works actually cited in the Markdown being built, so this
exports the *whole* library; unit and section scoping falls out of which files you
build together. Edit the database, never this output.

Standard library only, on the Python PYTHON_MIN names (below); an older Python is refused,
loudly, before anything runs.
Exit codes: 0 = written; 1 = database missing or unreadable; 2 = a Python older than PYTHON_MIN.
"""
from __future__ import annotations

import argparse
import json
import os
import re
import sqlite3
import sys

# ── The Python this script needs ──────────────────────────────────────────────────────────
# PYTHON_MIN is this script's one Python minimum, the same as the Makefile's PYTHON_MIN and every
# other script's in tooling/ (search for PYTHON_MIN to move them together). The file keeps to
# Python 3.8's grammar, so an older Python still reaches this check, which runs before anything
# that needs the newer one, and says loudly that nothing ran instead of failing on a SyntaxError.
PYTHON_MIN = (3, 14)
if sys.version_info < PYTHON_MIN:
    _RULE, _NEED = "=" * 78, "Python %d.%d or later" % PYTHON_MIN
    sys.stderr.write("\n%s\nERROR: tooling/export_refs.py did NOT run.\n"
                     "It needs %s, and this is Python %d.%d.%d (%s).\n"
                     "Nothing was read or written. Upgrade to %s, then run it again.\n%s\n\n"
                     % ((_RULE, _NEED) + tuple(sys.version_info[:3])
                        + (sys.executable or "python3", _NEED, _RULE)))
    sys.exit(2)

# Database column -> CSL-JSON key, where they differ.
FIELD_MAP = {
    "container_title": "container-title",
    "publisher_place": "publisher-place",
    "doi": "DOI",
    "url": "URL",
}
PLAIN_FIELDS = ("title", "container_title", "publisher", "publisher_place",
                "volume", "issue", "page", "url", "doi", "note")


def parse_names(field: str):
    """'Family, Given; Other, A.' -> [{'family','given'}]; a comma-less part -> {'literal'}."""
    names = []
    for part in (field or "").split(";"):
        part = part.strip()
        if not part:
            continue
        if "," in part:
            family, given = part.split(",", 1)
            names.append({"family": family.strip(), "given": given.strip()})
        else:
            names.append({"literal": part})
    return names


def year_dateparts(year: str):
    if not year:
        return None
    m = re.search(r"\d{4}", year)
    return {"date-parts": [[int(m.group())]]} if m else {"literal": year}


def iso_dateparts(d: str):
    if not d:
        return None
    m = re.match(r"(\d{4})-(\d{2})-(\d{2})", d)
    return {"date-parts": [[int(m[1]), int(m[2]), int(m[3])]]} if m else {"raw": d}


def row_to_csl(row: sqlite3.Row) -> dict:
    item = {"id": row["citation_key"], "type": row["type"]}
    if row["author"]:
        item["author"] = parse_names(row["author"])
    if row["editor"]:
        item["editor"] = parse_names(row["editor"])
    if (issued := year_dateparts(row["year"])):
        item["issued"] = issued
    if (accessed := iso_dateparts(row["accessed"])):
        item["accessed"] = accessed
    for col in PLAIN_FIELDS:
        if row[col]:
            item[FIELD_MAP.get(col, col)] = row[col]
    return item


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--db", default="tooling/references.db")
    ap.add_argument("--out", default="build/references.json")
    args = ap.parse_args()

    if not os.path.exists(args.db):
        sys.exit(f"error: database not found: {args.db}\n"
                 f"       run: make init")

    conn = sqlite3.connect(args.db)
    conn.row_factory = sqlite3.Row
    try:
        rows = conn.execute("SELECT * FROM refs ORDER BY citation_key").fetchall()
    except sqlite3.DatabaseError as err:
        sys.exit(f"error: cannot read the refs table in {args.db}: {err}")
    csl = [row_to_csl(r) for r in rows]

    os.makedirs(os.path.dirname(args.out) or ".", exist_ok=True)
    with open(args.out, "w", encoding="utf-8") as fh:
        json.dump(csl, fh, ensure_ascii=False, indent=2)
    print(f"wrote {len(csl)} references -> {args.out}")


if __name__ == "__main__":
    main()
