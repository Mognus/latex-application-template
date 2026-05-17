#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
LOG="$ROOT/log"
TMP="$ROOT/.tmp"

cleanup() {
  rm -rf "$TMP"
}
trap cleanup EXIT

generate_data_tex() {
  local json="$1"
  mkdir -p "$TMP"
  {
    printf '\\newcommand{\\Name}{%s}\n'    "$(jq -r '.name'    "$json")"
    printf '\\newcommand{\\Title}{%s}\n'   "$(jq -r '.title'   "$json")"
    printf '\\newcommand{\\Phone}{%s}\n'   "$(jq -r '.phone'   "$json")"
    printf '\\newcommand{\\Email}{%s}\n'   "$(jq -r '.email'   "$json")"
    printf '\\newcommand{\\Address}{%s}\n' "$(jq -r '.address' "$json")"
    printf '\\newcommand{\\Github}{%s}\n'  "$(jq -r '.github'  "$json")"
    printf '\\newcommand{\\Web}{%s}\n'     "$(jq -r '.web'     "$json")"
    printf '\\newcommand{\\Photo}{%s}\n'   "$(jq -r '.photo'   "$json")"
  } > "$TMP/data.tex"
}

generate_content_tex() {
  local json="$1"
  local language="$2"
  mkdir -p "$TMP"
  {
    printf '\\newcommand{\\Company}{%s}\n'    "$(jq -r '.company' "$json")"
    printf '\\newcommand{\\JobTitle}{%s}\n'   "$(jq -r --arg lang "$language" 'if $lang == "en" then (.job_title_en // .en.job_title // .job_title) else (.job_title_de // .de.job_title // .job_title) end' "$json")"
    printf '\\newcommand{\\Salutation}{%s}\n' "$(jq -r --arg lang "$language" 'if $lang == "en" then (.salutation_en // .en.salutation // .salutation) else (.salutation_de // .de.salutation // .salutation) end' "$json")"
    printf '\\newcommand{\\JobContent}{%%\n%s\n}\n' "$(jq -r --arg lang "$language" 'if $lang == "en" then (.content_en // .en.content // .content) else (.content_de // .de.content // .content) end' "$json")"
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
# Usage: ./build.sh --json=<path> [--personal=<path>] [--output=<name>] [--cv] [--lang=de|en]
json_file=""
personal_file="$ROOT/personal-data.json"
output_name=""
build_cv=false
language="de"

for arg in "$@"; do
  case "$arg" in
    --json=*)     json_file="${arg#--json=}" ;;
    --personal=*) personal_file="${arg#--personal=}" ;;
    --output=*)   output_name="${arg#--output=}" ;;
    --cv)         build_cv=true ;;
    --lang=*)     language="${arg#--lang=}" ;;
    --de)         language="de" ;;
    --en)         language="en" ;;
    *)            echo "Unknown argument: $arg" >&2; exit 1 ;;
  esac
done

if [[ -z "$json_file" ]]; then
  echo "Usage: $0 --json=<path/to/job.json> [--personal=<path>] [--output=<name>] [--cv] [--lang=de|en]" >&2
  exit 1
fi

case "$language" in
  de|en) ;;
  *) echo "Error: unsupported language '$language' (use de or en)" >&2; exit 1 ;;
esac

# [[ expr ]] && a || b is shorthand for: if [[ expr ]]; then a; else b; fi
# [[ expr ]] || { ... } is shorthand for: if [[ ! expr ]]; then ...; fi
[[ "$json_file"     = /* ]] && json_path="$json_file"         || json_path="$ROOT/$json_file"
[[ "$personal_file" = /* ]] && personal_path="$personal_file" || personal_path="$ROOT/$personal_file"

[[ -f "$json_path"     ]] || { echo "Error: $json_path not found" >&2;     exit 1; }
[[ -f "$personal_path" ]] || { echo "Error: $personal_path not found" >&2; exit 1; }

slug="${output_name:-$(basename "$json_file" .json)}"
# ---------------------------------------------------------------------------

generate_data_tex    "$personal_path"
generate_content_tex "$json_path" "$language"

if [[ "$language" == "en" ]]; then
  cv_source="$ROOT/cv/cv-en.tex"
  cover_letter_source="$ROOT/cover-letter/cover-letter-en.tex"
  cover_letter_output="cover-letter-en-$slug"
else
  cv_source="$ROOT/cv/cv.tex"
  cover_letter_source="$ROOT/cover-letter/cover-letter.tex"
  cover_letter_output="cover-letter-$slug"
fi

$build_cv && compile "$cv_source" "$ROOT/cv"

compile "$cover_letter_source" "$ROOT/cover-letter" "$cover_letter_output"
