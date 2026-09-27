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
  mkdir -p "$TMP"
  {
    printf '\\newcommand{\\Company}{%s}\n'    "$(jq -r '.company'    "$json")"
    printf '\\newcommand{\\JobTitle}{%s}\n'   "$(jq -r '.job_title'  "$json")"
    printf '\\newcommand{\\Salutation}{%s}\n' "$(jq -r '.salutation' "$json")"
    printf '\\newcommand{\\JobContent}{%%\n%s\n}\n' "$(jq -r '.content' "$json")"
  } > "$TMP/content.tex"
}

# Render a category slice [from:to) into \abilitysection / \ability macro calls.
# Categories stack sequentially; spacing comes from the macros themselves.
# esc escapes the LaTeX special characters that can appear in names/keywords.
_abilities_slice() {
  local json="$1" from="$2" to="$3"
  jq -r --argjson from "$from" --argjson to "$to" '
    def esc: gsub("&";"\\&") | gsub("%";"\\%") | gsub("#";"\\#") | gsub("_";"\\_");
    .categories[$from:$to][] |
    "\\abilitysection{\(.name|esc)}",
    (.abilities[] |
      "\\ability{\(.name|esc)}{\(.level)}{\((.keywords // []) | map(esc) | join(" · "))}")
  ' "$json"
}

generate_abilities_tex() {
  local json="$1"
  mkdir -p "$TMP"
  local total mid
  # Split the categories across two columns as evenly as possible,
  # never breaking a category apart. We test every possible boundary and
  # keep the one whose left/right ability counts are closest to equal.
  # (The old approach stopped at the first boundary past the halfway mark,
  # which overshot when a big category straddled the middle.)
  mid=$(jq '
    # counts[i] = number of abilities in category i
    [.categories[].abilities | length] as $counts
    | ($counts | add)    as $totalAbilities
    | ($counts | length) as $categoryCount

    # imbalance(k): how lopsided the split is when the first k categories
    # go left and the rest go right. 0 means perfectly even.
    | def imbalance($k):
        ($counts[0:$k] | add) as $left
        | ($left - ($totalAbilities - $left)) | fabs;

    # Consider every boundary k = 1 .. categoryCount-1, pick the evenest.
    [ range(1; $categoryCount) ]
    | (if length == 0 then [1] else . end)   # safety net: single category
    | min_by( imbalance(.) )
  ' "$json")
  total=$(jq '.categories | length' "$json")
  _abilities_slice "$json" 0      "$mid"   > "$TMP/abilities-left.tex"
  _abilities_slice "$json" "$mid" "$total" > "$TMP/abilities-right.tex"
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
abilities_file=""
output_name=""
build_cv=false
build_abilities=false
language="de"

for arg in "$@"; do
  case "$arg" in
    --json=*)           json_file="${arg#--json=}" ;;
    --personal=*)       personal_file="${arg#--personal=}" ;;
    --abilities-json=*) abilities_file="${arg#--abilities-json=}" ;;
    --abilities)        build_abilities=true ;;
    --output=*)         output_name="${arg#--output=}" ;;
    --cv)               build_cv=true ;;
    --lang=*)           language="${arg#--lang=}" ;;
    --de)               language="de" ;;
    --en)               language="en" ;;
    *)                  echo "Unknown argument: $arg" >&2; exit 1 ;;
  esac
done

if [[ -z "$json_file" && "$build_cv" == false && "$build_abilities" == false ]]; then
  echo "Usage: $0 [--json=<path>] [--cv] [--abilities] [--personal=<path>] [--output=<name>] [--lang=de|en]" >&2
  exit 1
fi

case "$language" in
  de|en) ;;
  *) echo "Error: unsupported language '$language' (use de or en)" >&2; exit 1 ;;
esac

# [[ expr ]] && a || b is shorthand for: if [[ expr ]]; then a; else b; fi
# [[ expr ]] || { ... } is shorthand for: if [[ ! expr ]]; then ...; fi
[[ "$personal_file" = /* ]] && personal_path="$personal_file" || personal_path="$ROOT/$personal_file"
[[ -f "$personal_path" ]] || { echo "Error: $personal_path not found" >&2; exit 1; }
# ---------------------------------------------------------------------------

# Personal data feeds the shared header and footer, so it is always generated.
generate_data_tex "$personal_path"

# Pick the language specific source files.
if [[ "$language" == "en" ]]; then
  cv_source="$ROOT/tex/cv-en.tex"
  cover_letter_source="$ROOT/tex/cover-letter-en.tex"
  ability_sheet_source="$ROOT/tex/ability-sheet-en.tex"
  cover_letter_prefix="cover-letter-en"
  ability_sheet_output="ability-sheet-en"
else
  cv_source="$ROOT/tex/cv.tex"
  cover_letter_source="$ROOT/tex/cover-letter.tex"
  ability_sheet_source="$ROOT/tex/ability-sheet.tex"
  cover_letter_prefix="cover-letter"
  ability_sheet_output="ability-sheet"
fi

# Cover letter (only when a company JSON is given).
if [[ -n "$json_file" ]]; then
  [[ "$json_file" = /* ]] && json_path="$json_file" || json_path="$ROOT/$json_file"
  [[ -f "$json_path" ]] || { echo "Error: $json_path not found" >&2; exit 1; }
  slug="${output_name:-$(basename "$json_file" .json)}"
  generate_content_tex "$json_path"
  compile "$cover_letter_source" "$ROOT/gen/cover-letter" "$cover_letter_prefix-$slug"
fi

# CV
$build_cv && compile "$cv_source" "$ROOT/gen/cv"

# Ability sheet (reusable, language specific JSON).
if [[ "$build_abilities" == true ]]; then
  if [[ -z "$abilities_file" ]]; then
    [[ "$language" == "en" ]] && abilities_file="$ROOT/abilities-en.json" || abilities_file="$ROOT/abilities.json"
  fi
  [[ "$abilities_file" = /* ]] && abilities_path="$abilities_file" || abilities_path="$ROOT/$abilities_file"
  [[ -f "$abilities_path" ]] || { echo "Error: $abilities_path not found" >&2; exit 1; }
  generate_abilities_tex "$abilities_path"
  compile "$ability_sheet_source" "$ROOT/gen/ability-sheet" "$ability_sheet_output"
fi
