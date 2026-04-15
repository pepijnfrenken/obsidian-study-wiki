#!/bin/bash
# Check for unprocessed sources in raw/ that aren't in wiki/log.md
# Also checks for stale mastery assessments
# Runs on SessionStart to alert the agent about new material and gaps

WIKI_DIR="wiki"
RAW_DIR="raw"
LOG_FILE="$WIKI_DIR/log.md"
MASTERY_FILE="$WIKI_DIR/mastery.md"

# Exit silently if wiki or raw don't exist
[ -d "$WIKI_DIR" ] || exit 0
[ -d "$RAW_DIR" ] || exit 0
[ -f "$LOG_FILE" ] || exit 0

output=""

# Check for unprocessed raw sources
raw_files=$(find "$RAW_DIR" -type f -not -name '.*' -not -path '*/assets/*' | sort)
if [ -n "$raw_files" ]; then
  unprocessed=0
  unprocessed_list=""
  while IFS= read -r file; do
    basename=$(basename "$file")
    if ! grep -q "$basename" "$LOG_FILE" 2>/dev/null; then
      unprocessed=$((unprocessed + 1))
      unprocessed_list="$unprocessed_list  - $file\n"
    fi
  done <<< "$raw_files"

  if [ "$unprocessed" -gt 0 ]; then
    output="${output}Wiki drift detected: $unprocessed unprocessed source(s) in raw/:\n${unprocessed_list}Consider running wiki ingest to process them.\n\n"
  fi
fi

# Check for stale mastery assessments (topics not assessed in >14 days)
if [ -f "$MASTERY_FILE" ]; then
  stale_count=$(grep -c '\[stale\]' "$MASTERY_FILE" 2>/dev/null || echo 0)
  if [ "$stale_count" -gt 0 ]; then
    output="${output}Mastery drift: $stale_count topic(s) marked as stale in mastery.md.\nConsider running a mastery-check to reassess.\n\n"
  fi
fi

# Output results (stdout is added to context for SessionStart)
if [ -n "$output" ]; then
  echo -e "$output" | head -20
fi
