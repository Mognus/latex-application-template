#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
LOG="$ROOT/log"
TMP="$ROOT/.tmp"

cleanup() {
  rm -rf "$TMP"
}
trap cleanup EXIT

generate_content_tex() {
  local json="$1"
  mkdir -p "$TMP"
  {
    printf '\\newcommand{\\Company}{%s}\n'    "$(jq -r '.company'    "$json")"
    printf '\\newcommand{\\JobTitle}{%s}\n'   "$(jq -r '.job_title'  "$json")"
    printf '\\newcommand{\\Salutation}{%s}\n' "$(jq -r '.salutation' "$json")"
    printf '\\newcommand{\\JobContent}{%%\n%s\n}\n' "$(jq -r '.content' "$json")"
  } > "$TMP/content.tex"
}

compile() {
  local src="$1"
  local out="$2"
  local out_name="${3:-$(basename "$src" .tex)}"
  local dir name
  dir="$(dirname "$src")"
  name="$(basename "$src" .tex)"

  mkdir -p "$TMP" "$out" "$LOG"
  (cd "$dir" && pdflatex -interaction=nonstopmode -output-directory="$TMP" "$name.tex")
  mv "$TMP/$name.pdf" "$out/$out_name.pdf"
  mv "$TMP/$name.log" "$LOG/$out_name.log"
  rm -f "$TMP/$name.aux" "$TMP/$name.out"
  echo "OK  $out/$out_name.pdf"
}

# --- Parse arguments --------------------------------------------------------
json_file=""
build_cv=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --json) json_file="$2"; shift 2 ;;
    --cv)   build_cv=true; shift ;;
    *)      echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

if [[ -z "$json_file" ]]; then
  echo "Usage: $0 --json <path/to/job.json> [--cv]" >&2
  exit 1
fi

[[ "$json_file" = /* ]] && json_path="$json_file" || json_path="$ROOT/$json_file"

if [[ ! -f "$json_path" ]]; then
  echo "Error: $json_path not found" >&2
  exit 1
fi

slug="$(basename "$json_file" .json)"
# ---------------------------------------------------------------------------

generate_content_tex "$json_path"

$build_cv && compile "$ROOT/cv/cv.tex" "$ROOT/cv"

compile "$ROOT/cover-letter/cover-letter.tex" "$ROOT/cover-letter" "cover-letter-$slug"
