#!/usr/bin/env bash
#
# fiction.sh — adopt.sh with --kind fiction (DESIGN.md Section 8 names one script per kind).
# Everything else, including --apply, passes through. See adopt.sh for what it does.
#
# Usage: fiction.sh [--apply] [TARGET]
exec bash "$(dirname "${BASH_SOURCE[0]}")/adopt.sh" --kind fiction "$@"
