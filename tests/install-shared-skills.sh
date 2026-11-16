#!/bin/bash
set -eu
script=$(dirname "$0")/../.local/bin/install-shared-skills
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
export HOME="$tmp/home" CLAUDE_CONFIG_DIR="$tmp/claude"
mkdir -p "$HOME/.config/agents/skills/example" "$HOME/.config/agents/skills/incomplete"
touch "$HOME/.config/agents/skills/example/SKILL.md"
"$script"
for link in "$HOME/.agents/skills/example" "$CLAUDE_CONFIG_DIR/skills/example"; do
    test -L "$link" && test "$link" -ef "$HOME/.config/agents/skills/example"
done
test ! -e "$HOME/.agents/skills/incomplete"
"$script"
mkdir -p "$HOME/.config/agents/skills/conflict" "$HOME/.agents/skills/conflict"
touch "$HOME/.config/agents/skills/conflict/SKILL.md"
if "$script"; then
    echo "expected a conflict to fail" >&2
    exit 1
fi
test -d "$HOME/.agents/skills/conflict" && test ! -L "$HOME/.agents/skills/conflict"
