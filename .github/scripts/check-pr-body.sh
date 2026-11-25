#!/usr/bin/env bash
# wp-aidd-version: 0.7.0
# Checks a pull request description against .github/PULL_REQUEST_TEMPLATE.md.
# Run by the PR Checklist workflow and by the git-open-pr skill before `gh pr create`.
#
# Usage: check-pr-body.sh [--local] [--visual] [--ticked] FILE|-
#   --local   a screenshot may be a local path (gh --attach uploads it); it must exist
#   --visual  the change alters the rendering: "Aucun changement visuel." is refused
#   --ticked  every "À tester" box must be ticked (the reviewer ticks them)
# Exit: 0 valid, 1 invalid (one "check-pr-body: …" line per problem on stderr), 2 usage.
set -uf

usage() {
  echo "check-pr-body: $1" >&2
  echo "usage: check-pr-body.sh [--local] [--visual] [--ticked] FILE|-" >&2
  exit 2
}

local_mode=0
visual=0
ticked=0
source_arg=''

for arg in "$@"; do
  case "$arg" in
    --local) local_mode=1 ;;
    --visual) visual=1 ;;
    --ticked) ticked=1 ;;
    -) [ -z "$source_arg" ] || usage "more than one body given"; source_arg='-' ;;
    -*) usage "unknown option: $arg" ;;
    *) [ -z "$source_arg" ] || usage "more than one body given"; source_arg=$arg ;;
  esac
done

[ -n "$source_arg" ] || usage "no body given"

if [ "$source_arg" = '-' ]; then
  body=$(cat)
  base_dir=.
else
  [ -f "$source_arg" ] || usage "no such file: $source_arg"
  body=$(cat -- "$source_arg")
  base_dir=$(dirname -- "$source_arg")
fi

report=$(printf '%s\n' "$body" | tr -d '\r' | awk -v local_mode="$local_mode" -v visual="$visual" -v ticked="$ticked" '
function trim(s) { sub(/^[ \t]+/, "", s); sub(/[ \t]+$/, "", s); return s }
function norm(s) {
  s = tolower(trim(s))
  gsub(/À/, "à", s); gsub(/É/, "é", s); gsub(/’/, "\047", s)
  return s
}
function err(msg) { print "ERR " msg }
function check_image(url) {
  images++
  if (url ~ /\/blob\// || url ~ /\?raw=true/ || url ~ /raw\.githubusercontent\.com/) {
    err("\"Captures d\047écran\": " url " links to a repository file; attach the image with gh pr create --attach instead")
  } else if (url !~ /^https?:\/\//) {
    if (local_mode) print "IMG " url
    else err("\"Captures d\047écran\": " url " is a local path; it must be an uploaded image URL")
  }
}

BEGIN {
  english["verification"] = "Vérification"
  english["screenshots"] = "Captures d\047écran"
  english["manual testing"] = "À tester"
  english["checklist"] = "À tester"
  english["type of change"] = "Type de changement"
  english["related issue"] = "Issue liée"
  english["additional notes"] = "Notes complémentaires"
  section = ""
  in_comment = 0
}

{
  line = $0
  out = ""
  while (length(line) > 0) {
    if (in_comment) {
      i = index(line, "-->")
      if (i) { line = substr(line, i + 3); in_comment = 0 } else line = ""
    } else {
      i = index(line, "<!--")
      if (i) { out = out substr(line, 1, i - 1); line = substr(line, i + 4); in_comment = 1 } else { out = out line; line = "" }
    }
  }
  line = out

  if (trim(line) != "") nonblank++

  if (line ~ /[Cc][Ll][Aa][Uu][Dd][Ee]-[Ss][Ee][Ss][Ss][Ii][Oo][Nn]:/ || line ~ /[Cc][Oo]-[Aa][Uu][Tt][Hh][Oo][Rr][Ee][Dd]-[Bb][Yy]:/)
    err("attribution trailer in the body: " trim(line))
  if (line ~ /claude\.ai\/(code|chat)/)
    err("link to a Claude session in the body")

  if (line ~ /^##[ \t]/) {
    heading = line
    sub(/^##[ \t]+/, "", heading)
    section = norm(heading)
    seen[section] = 1
    if (section in english) err("heading \"## " trim(heading) "\" must be \"## " english[section] "\"")
    next
  }

  content = trim(line)
  if (content == "") next

  if (section == "description") description++
  else if (section == "vérification") verification++
  else if (section == "type de changement") {
    if (content ~ /^[-*][ \t]+\[[xX]\]/) types_ticked++
  }
  else if (section == "à tester") {
    if (index(content, "Action → résultat attendu")) placeholder = 1
    if (content ~ /^([-*]|[0-9]+\.)[ \t]+\[[ xX]\]/) {
      if (index(content, "Aucun secret ni identifiant dans le diff")) secrets_line = 1
      else steps++
      if (ticked && content ~ /^([-*]|[0-9]+\.)[ \t]+\[ \]/) unticked++
    }
  }
  else if (section == "captures d\047écran") {
    if (content == "Aucun changement visuel.") no_visual = 1
    else if (content == "Captures non publiables.") not_publishable = 1
    rest = content
    while (match(rest, /!\[[^]]*\]\([^) ]+/)) {
      token = substr(rest, RSTART, RLENGTH)
      sub(/^!\[[^]]*\]\(/, "", token)
      check_image(token)
      rest = substr(rest, RSTART + RLENGTH)
    }
    rest = content
    while (match(rest, /<img[^>]*src=["\047][^"\047]+/)) {
      token = substr(rest, RSTART, RLENGTH)
      sub(/^<img[^>]*src=["\047]/, "", token)
      check_image(token)
      rest = substr(rest, RSTART + RLENGTH)
    }
  }
}

END {
  if (!nonblank) { err("the body is empty"); exit }

  split("description|type de changement|vérification|à tester|captures d\047écran", required, "|")
  split("Description|Type de changement|Vérification|À tester|Captures d\047écran", labels, "|")
  for (n = 1; n <= 5; n++) {
    if (!(required[n] in seen)) { err("missing heading \"## " labels[n] "\""); missing[required[n]] = 1 }
  }

  if (!("description" in missing) && !description) err("\"Description\" is empty")
  if (!("vérification" in missing) && !verification) err("\"Vérification\" is empty: list the commands run and their result")
  if (!("type de changement" in missing) && !types_ticked) err("\"Type de changement\": tick at least one box")

  if (!("à tester" in missing)) {
    if (!steps) err("\"À tester\": add at least one step (action → expected result) as a task")
    if (placeholder) err("\"À tester\": the template placeholder \"Action → résultat attendu\" is still there")
    if (!secrets_line) err("\"À tester\": the task \"Aucun secret ni identifiant dans le diff\" is missing")
    if (unticked) err("\"À tester\": " unticked " box(es) not ticked yet; the reviewer ticks them")
  }

  if (!("captures d\047écran" in missing)) {
    if (!images && !no_visual && !not_publishable)
      err("\"Captures d\047écran\": attach a screenshot, or write the exact line \"Aucun changement visuel.\" or \"Captures non publiables.\"")
    if (images && no_visual) err("\"Captures d\047écran\": screenshots and \"Aucun changement visuel.\" contradict each other")
    if (visual && no_visual) err("\"Captures d\047écran\": the change alters the rendering, \"Aucun changement visuel.\" is not true")
  }
}
')

status=0
while IFS= read -r entry; do
  case "$entry" in
    'ERR '*)
      echo "check-pr-body: ${entry#ERR }" >&2
      status=1
      ;;
    'IMG '*)
      path=${entry#IMG }
      # Same lookup as gh: relative to the body file, then to the working directory.
      if [ ! -f "$base_dir/$path" ] && [ ! -f "$path" ]; then
        echo "check-pr-body: \"Captures d'écran\": $path does not exist" >&2
        status=1
      fi
      ;;
  esac
done <<EOF
$report
EOF

exit $status
