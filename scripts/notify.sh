#!/bin/bash
# Send macOS notification when Claude Code is waiting for user input.
# With terminal-notifier: shows Claude icon, click focuses originating iTerm2 pane.
# Fallback: basic osascript notification (no icon, no click action).
#
# Usage: notify.sh [message] [title]

MESSAGE="${1:-Claude Code is waiting for your input}"
TITLE="${2:-Claude Code}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ICON_PATH="$SCRIPT_DIR/../assets/claude-icon.png"

# Resolve icon: cached PNG > convert from Claude.app > none
if [[ ! -f "$ICON_PATH" ]]; then
    CLAUDE_ICNS="/Applications/Claude.app/Contents/Resources/electron.icns"
    if [[ -f "$CLAUDE_ICNS" ]]; then
        mkdir -p "$(dirname "$ICON_PATH")"
        sips -s format png --resampleHeightWidth 256 256 "$CLAUDE_ICNS" --out "$ICON_PATH" &>/dev/null
    fi
fi

if command -v terminal-notifier &>/dev/null; then
    args=(
        -title "$TITLE"
        -message "$MESSAGE"
        -sound "Ping"
        -group "claude-code"
    )

    [[ -f "$ICON_PATH" ]] && args+=(-appIcon "$ICON_PATH")

    # Click-to-focus: navigate to the exact iTerm2 window + tab + pane
    SESSION_GUID="${ITERM_SESSION_ID#*:}"
    if [[ -n "${SESSION_GUID:-}" ]]; then
        args+=(-execute "bash '$SCRIPT_DIR/focus-iterm-session.sh' '$SESSION_GUID'")
    else
        args+=(-execute "osascript -e 'tell application \"iTerm2\" to activate'")
    fi

    terminal-notifier "${args[@]}"
else
    # Fallback: basic notification (no icon, no click action)
    osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\" sound name \"Ping\""
fi
