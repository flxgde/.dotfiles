#!/usr/bin/env python3
"""Additively merge dotfiles-managed hooks into ~/.claude/settings.json.

Usage: merge_hooks.py <hooks.json> <settings.json>

Only adds hook commands from <hooks.json> that aren't already present
for their event (compared by the inner "command" string) — every other
key and every other hook already in <settings.json> is left untouched.
Idempotent: re-running never duplicates entries. Prints "changed" or
"unchanged" on the last line so the calling Ansible task can set
changed_when correctly.
"""
import json
import sys
from pathlib import Path


def main():
    hooks_path, settings_path = sys.argv[1], sys.argv[2]

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

    if changed:
        settings_file.parent.mkdir(parents=True, exist_ok=True)
        with open(settings_file, "w") as f:
            json.dump(settings, f, indent=2)
            f.write("\n")

    print("changed" if changed else "unchanged")


if __name__ == "__main__":
    main()
