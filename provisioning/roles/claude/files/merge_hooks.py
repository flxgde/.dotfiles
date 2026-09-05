#!/usr/bin/env python3
"""Merge dotfiles-managed settings into ~/.claude/settings.json.

Usage: merge_hooks.py <hooks.json> <settings.json> [--statusline <command>]

Hooks from <hooks.json> are merged additively: only commands not already
present for their event (compared by the inner "command" string) are
added — every other key and every other hook already in <settings.json>
is left untouched.

When --statusline is given, settings["statusLine"] is set to
{"type": "command", "command": <command>} whenever it differs from the
current value, so the dotfiles-managed statusline command stays in sync
across machines (this one field is overwritten rather than merged, since
there's no meaningful per-machine customization to preserve for it).

Idempotent: re-running never duplicates hook entries and never rewrites
statusLine unless it actually changed. Prints "changed" or "unchanged"
on the last line so the calling Ansible task can set changed_when
correctly.
"""
import json
import sys
from pathlib import Path


def main():
    hooks_path, settings_path = sys.argv[1], sys.argv[2]
    statusline_command = None
    if len(sys.argv) > 3 and sys.argv[3] == "--statusline":
        statusline_command = sys.argv[4]

    with open(hooks_path) as f:
        canonical = json.load(f)

    settings_file = Path(settings_path)
    if settings_file.exists() and settings_file.stat().st_size > 0:
        with open(settings_file) as f:
            settings = json.load(f)
    else:
        settings = {}

    hooks = settings.setdefault("hooks", {})
    changed = False

    for event, commands in canonical.items():
        entries = hooks.setdefault(event, [])
        for command in commands:
            already_present = any(
                h.get("command") == command
                for entry in entries
                for h in entry.get("hooks", [])
            )
            if not already_present:
                entries.append({"hooks": [{"type": "command", "command": command}]})
                changed = True

    if statusline_command is not None:
        desired = {"type": "command", "command": statusline_command}
        if settings.get("statusLine") != desired:
            settings["statusLine"] = desired
            changed = True

    if changed:
        settings_file.parent.mkdir(parents=True, exist_ok=True)
        with open(settings_file, "w") as f:
            json.dump(settings, f, indent=2)
            f.write("\n")

    print("changed" if changed else "unchanged")


if __name__ == "__main__":
    main()
