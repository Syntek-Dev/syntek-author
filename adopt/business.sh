#!/usr/bin/env bash
#
# business.sh — adopt.sh with --kind business (DESIGN.md Section 8 names one script per kind).
# Everything else, including --apply, passes through. See adopt.sh for what it does.
#
# Usage: business.sh [--apply] [TARGET]
exec bash "$(dirname "${BASH_SOURCE[0]}")/adopt.sh" --kind business "$@"
