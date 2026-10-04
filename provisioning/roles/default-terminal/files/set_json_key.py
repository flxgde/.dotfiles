#!/usr/bin/env python3
"""Set one top-level key in a JSON file, leaving everything else untouched.

Usage: set_json_key.py <file.json> <key> <json-value>

Used for ~/.claude/settings.json, which Claude Code rewrites live, so it
can't be symlinked (see the claude role). Creates the file if missing.
Prints "changed" or "unchanged" on the last line for Ansible's
changed_when.
"""
import json
import sys
from pathlib import Path


def main():
    path, key, value = Path(sys.argv[1]), sys.argv[2], json.loads(sys.argv[3])

    data = {}
    if path.exists() and path.stat().st_size > 0:
        with open(path) as f:
            data = json.load(f)

    if data.get(key) == value:
        print("unchanged")
        return

    data[key] = value
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w") as f:
        json.dump(data, f, indent=2)
        f.write("\n")
    print("changed")


if __name__ == "__main__":
    main()
