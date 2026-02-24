#!/bin/bash
# Focus a specific iTerm2 session (window + tab + pane) by its unique GUID.
# Usage: focus-iterm-session.sh <session-guid>
#
# The GUID comes from $ITERM_SESSION_ID (format: w0t1p0:GUID).
# We iterate iTerm2's AppleScript object model to find and select the
# exact session, then raise its containing window to the front.

GUID="${1:-}"

if [[ -z "$GUID" ]]; then
    osascript -e 'tell application "iTerm2" to activate'
    exit 0
fi

osascript <<EOF
tell application "iTerm2"
    activate
    repeat with w in windows
        repeat with t in tabs of w
            repeat with s in sessions of t
                if unique id of s contains "$GUID" then
                    -- Select the tab containing our session
                    select t
                    -- Within the tab, focus the specific pane (for splits)
                    tell s to select
                    -- Bring the window to front
                    set index of w to 1
                    return
                end if
            end repeat
        end repeat
    end repeat
end tell
EOF
