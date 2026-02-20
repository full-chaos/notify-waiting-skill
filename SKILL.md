---
name: notify-waiting
description: Sends macOS notifications when Claude Code is waiting for user input. Automatically triggers via Stop hook whenever Claude finishes a turn.
---

# macOS Notification — Waiting for Input

## How it works

A `Stop` hook in `settings.json` fires `scripts/notify.sh` every time Claude finishes
a turn and is waiting for the user. This covers:

- Explicit questions (`AskUserQuestion`)
- Permission prompts (tool approval)
- Plan approval (`ExitPlanMode`)
- Task completion (waiting for next instruction)

## Manual notification

To send a custom notification from within a session:

```bash
bash ~/.claude/skills/notify-waiting/scripts/notify.sh "Custom message" "Custom Title"
```

## Configuration

The hook is defined in `~/.claude/settings.json` under `hooks.Stop`.
To disable, remove the `Stop` hook entry from settings.
