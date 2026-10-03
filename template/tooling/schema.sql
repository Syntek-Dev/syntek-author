-- schema.sql — the citation database
-- The SQLite database built from this file is the SINGLE SOURCE OF TRUTH for the
-- work's bibliographic references. Edit the database (via the add-reference skill),
-- never the generated build/references.json.
--
-- Apply:  make init    (runs sqlite3 tooling/references.db < tooling/schema.sql, then
--                       every tooling/seed*.sql; refuses to overwrite an existing database)
--
-- One table only. There is deliberately no table recording which unit cites which work:
-- Pandoc decides what a reference list prints by reading the Markdown it is given, so a
-- hand-kept record of where each work is cited could only drift from the truth.
--
-- See standards/referencing/harvard-referencing.md for the rules these columns serve.

PRAGMA foreign_keys = ON;

-- ---------------------------------------------------------------------------
-- refs — bibliographic works (Harvard / CSL-JSON master)
-- Named `refs`, not `references`, to avoid the SQL-reserved keyword.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS refs (
    id              INTEGER PRIMARY KEY,
    citation_key    TEXT NOT NULL UNIQUE,   -- stable, lower-case authorYYYY; NEVER renamed once used.
                                            -- Disambiguate same author+year with a/b/c: okafor2021a, okafor2021b.
    type            TEXT NOT NULL DEFAULT 'book'
                       CHECK (type IN ('book','chapter','article-journal','article-magazine',
                                       'article-newspaper','webpage','report','paper-conference',
                                       'thesis','entry-encyclopedia','legislation','legal_case',
                                       'motion_picture')),
    author          TEXT,                   -- "Family, Given; Family, Given" (semicolon-separated).
                                            -- A corporate author is one part with no comma (exported as a literal).
                                            -- Statutes: NULL — short title, no author.
    editor          TEXT,                   -- same format; for edited volumes and book chapters
    year            TEXT,                   -- issued year as TEXT so 'n.d.' and '2015a' are allowed
    title           TEXT NOT NULL,
    container_title TEXT,                   -- journal / magazine / book title (for chapters)
    publisher       TEXT,
    publisher_place TEXT,
    volume          TEXT,
    issue           TEXT,
    page            TEXT,
    url             TEXT,
    doi             TEXT,
    accessed        TEXT,                   -- ISO 8601 (YYYY-MM-DD). MANDATORY for every online source:
                                            -- pages change without notice, and this date is what makes
                                            -- a later re-verification possible.
    note            TEXT                    -- provenance, edition caveats, verification flags.
                                            -- NOT rendered by the CSL — for humans only.
);
