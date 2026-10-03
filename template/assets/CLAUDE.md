@./CONTEXT.md

# CLAUDE.md — assets/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the asset layout, imported above) → this file.

## Purpose (one line)

Keep the work's images and other binaries findable, stable and unaltered.

## How to work here

- **Routing:** no skill writes here; assets are added by <%AUTHOR_FIRST_NAME%>. Describe, locate
  and reference assets; leave editing images to the author's own tools.
- **Model:** the mechanical tier for filing and referencing
  (`.claude/rules/syntek-author/05-model-allocation.md`); **Opus** for anything that decides what
  an image shows or claims.
- **Concrete steps:** find the right kind folder (create it, with its pair, only if none fits) →
  reference the asset by its stable path from the prose or build → record its source and any
  permission it needs.
- **Definition of done:** the asset is referenced by a stable path, its kind folder carries a
  pair, and no existing file has been altered, renamed or deleted.

## Guardrails

- **Never rename, move or delete an asset without the author's confirmation.** The prose, the
  build and outside readers may refer to it by name.
- **Never overwrite an asset.** A new version takes a new name, or replaces the old only once the
  author confirms.
- **Record where an image came from.** An image with no known source or licence is not used in the
  work until it has one; note what is missing as a `VERIFY` flag where the image is used.
- Nothing goes directly in the `assets/` root.

## Output & naming

- **Hand-placed:** binaries only, in kebab-case (`cover-front.png`, `map-the-harbour.svg`), inside
  the matching kind folder.
- **Generated (never here):** proofs and renders, which go to `build/`.
