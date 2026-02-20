#!/bin/bash
# Send macOS notification when Claude Code is waiting for user input
# Usage: notify.sh [message] [title]

MESSAGE="${1:-Claude Code is waiting for your input}"
TITLE="${2:-Claude Code}"

osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\" sound name \"Ping\""
