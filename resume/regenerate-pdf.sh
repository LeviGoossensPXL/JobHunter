#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

HTML_FILE=""
PDF_FILE=""
BROWSER="${BROWSER:-google-chrome}"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --input|-i)
            if [[ $# -lt 2 ]]; then
                printf 'Error: --input requires a file.\n' >&2
                exit 1
            fi
            HTML_FILE="$2"
            shift 2
            ;;

        --output|-o)
            if [[ $# -lt 2 ]]; then
                printf 'Error: --output requires a file.\n' >&2
                exit 1
            fi
            PDF_FILE="$2"
            shift 2
            ;;

        *)
            printf 'Error: unknown option: %s\n' "$1" >&2
            printf 'Usage: %s -i <html-file> [-o <pdf-file>]\n' "$0" >&2
            exit 1
            ;;
    esac
done

if [[ -z "$HTML_FILE" ]]; then
    printf 'Error: no HTML file specified.\n' >&2
    printf 'Usage: %s -i <html-file> [-o <pdf-file>]\n' "$0" >&2
    exit 1
fi

# Resolve the input path relative to the directory where the command was run.
HTML_FILE="$(realpath "$HTML_FILE")"

if [[ ! -f "$HTML_FILE" ]]; then
    printf 'Error: HTML file not found: %s\n' "$HTML_FILE" >&2
    exit 1
fi

# If no output is specified, create the PDF next to the HTML file.
if [[ -z "$PDF_FILE" ]]; then
    PDF_FILE="${HTML_FILE%.html}.pdf"
else
    PDF_FILE="$(realpath -m "$PDF_FILE")"
fi

if ! command -v "$BROWSER" >/dev/null 2>&1; then
    printf 'Error: browser not found: %s\n' "$BROWSER" >&2
    printf 'Set BROWSER to a Chromium-based browser executable.\n' >&2
    exit 1
fi

"$BROWSER" \
    --headless \
    --no-sandbox \
    --disable-gpu \
    --print-to-pdf="$PDF_FILE" \
    "file://$HTML_FILE"

printf 'Generated: %s\n' "$PDF_FILE"
