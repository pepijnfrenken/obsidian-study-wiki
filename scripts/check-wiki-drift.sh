#!/bin/bash
# Check for unprocessed sources in raw/ that aren't recorded in wiki/log.md
# Also checks for topics in mastery.md whose last assessed date is stale
# Runs on SessionStart to alert the agent about new material and gaps

WIKI_DIR="wiki"
RAW_DIR="raw"
LOG_FILE="$WIKI_DIR/log.md"
MASTERY_FILE="$WIKI_DIR/mastery.md"
STALE_AFTER_DAYS=14
MAX_LISTED_ITEMS=8

# Exit silently if wiki or raw don't exist
[ -d "$WIKI_DIR" ] || exit 0
[ -d "$RAW_DIR" ] || exit 0
[ -f "$LOG_FILE" ] || exit 0

output=""

today_epoch=$(date +%s)

append_capped_list() {
  local items="$1"
  local total_count="$2"
  local label="$3"
  local listed_count

  listed_count=$(printf '%s\n' "$items" | sed '/^$/d' | wc -l)
  if [ "$listed_count" -gt 0 ]; then
    output="${output}${label}:\n$(printf '%s\n' "$items")\n"
  fi

  if [ "$total_count" -gt "$listed_count" ]; then
    output="${output}  - ... and $((total_count - listed_count)) more\n"
  fi
}

# Check for unprocessed raw sources by matching exact Source lines in wiki/log.md.
raw_files=$(find "$RAW_DIR" -type f -not -name '.*' -not -path '*/assets/*' | sort)
if [ -n "$raw_files" ]; then
  unprocessed=0
  unprocessed_list=""
  while IFS= read -r file; do
    [ -n "$file" ] || continue
    if ! grep -Fqx -- "- Source: $file" "$LOG_FILE" 2>/dev/null; then
      unprocessed=$((unprocessed + 1))
      if [ "$unprocessed" -le "$MAX_LISTED_ITEMS" ]; then
        unprocessed_list="${unprocessed_list}  - $file\n"
      fi
    fi
  done <<< "$raw_files"

  if [ "$unprocessed" -gt 0 ]; then
    output="${output}Wiki drift detected: $unprocessed unprocessed source(s) in raw/.\n"
    append_capped_list "$unprocessed_list" "$unprocessed" "Unprocessed sources"
    output="${output}Consider running wiki ingest to process them.\n\n"
  fi
fi

# Check for stale mastery assessments using `last assessed: YYYY-MM-DD`.
if [ -f "$MASTERY_FILE" ]; then
  stale_count=0
  stale_list=""

  while IFS= read -r line; do
    topic=$(printf '%s' "$line" | sed -n 's/^- \*\*\([^*][^*]*\)\*\* — .*$/\1/p')
    assessed_on=$(printf '%s' "$line" | sed -n 's/^.*last assessed: \([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\).*$/\1/p')

    [ -n "$topic" ] || continue
    [ -n "$assessed_on" ] || continue

    assessed_epoch=$(date -d "$assessed_on" +%s 2>/dev/null || true)
    [ -n "$assessed_epoch" ] || continue

    age_days=$(( (today_epoch - assessed_epoch) / 86400 ))
    if [ "$age_days" -gt "$STALE_AFTER_DAYS" ]; then
      stale_count=$((stale_count + 1))
      if [ "$stale_count" -le "$MAX_LISTED_ITEMS" ]; then
        stale_list="${stale_list}  - $topic (last assessed $assessed_on, $age_days days ago)\n"
      fi
    fi
  done < "$MASTERY_FILE"

  if [ "$stale_count" -gt 0 ]; then
    output="${output}Mastery drift detected: $stale_count topic(s) have not been assessed in more than $STALE_AFTER_DAYS days.\n"
    append_capped_list "$stale_list" "$stale_count" "Stale topics"
    output="${output}Consider running a mastery-check to reassess them.\n\n"
  fi
fi

# Output results (stdout is added to context for SessionStart)
if [ -n "$output" ]; then
  printf '%b' "$output"
fi
