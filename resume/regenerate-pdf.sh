#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
HTML_FILE="${1:-$SCRIPT_DIR/Cv - software developer.html}"
PDF_FILE="${2:-$SCRIPT_DIR/Cv - software developer.pdf}"
BROWSER="${BROWSER:-google-chrome}"

if ! command -v "$BROWSER" >/dev/null 2>&1; then
  printf 'Error: browser not found: %s\n' "$BROWSER" >&2
  printf 'Set BROWSER to a Chromium-based browser executable.\n' >&2
  exit 1
fi

if [[ ! -f "$HTML_FILE" ]]; then
  printf 'Error: HTML file not found: %s\n' "$HTML_FILE" >&2
  exit 1
fi

HTML_FILE="$(realpath "$HTML_FILE")"
PDF_FILE="$(realpath -m "$PDF_FILE")"

"$BROWSER" \
  --headless \
  --no-sandbox \
  --disable-gpu \
  --print-to-pdf="$PDF_FILE" \
  "file://$HTML_FILE"

printf 'Generated: %s\n' "$PDF_FILE"
