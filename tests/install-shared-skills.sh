#!/bin/bash
set -eu
script=$(dirname "$0")/../.local/bin/install-shared-skills
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
export HOME="$tmp/home" CLAUDE_CONFIG_DIR="$tmp/claude"
mkdir -p "$HOME/.config/agents/skills/example" "$HOME/.config/agents/skills/incomplete" "$HOME/.local/agents/skills/private"
touch "$HOME/.config/agents/skills/example/SKILL.md"
touch "$HOME/.local/agents/skills/private/SKILL.md"
"$script"
for link in "$HOME/.agents/skills/example" "$CLAUDE_CONFIG_DIR/skills/example"; do
    test -L "$link"
    test "$link" -ef "$HOME/.config/agents/skills/example"
done
for link in "$HOME/.agents/skills/private" "$CLAUDE_CONFIG_DIR/skills/private"; do
    test -L "$link"
    test "$link" -ef "$HOME/.local/agents/skills/private"
done
test ! -e "$HOME/.agents/skills/incomplete"
ln -s "$HOME/.config/agents/skills/deleted" "$HOME/.agents/skills/deleted"
ln -s "$HOME/.local/agents/skills/deleted" "$CLAUDE_CONFIG_DIR/skills/deleted"
ln -s "$HOME/elsewhere/missing" "$HOME/.agents/skills/unrelated"
rm "$CLAUDE_CONFIG_DIR/skills/private"
ln -s "$HOME/.local/agents/skills/old-private" "$CLAUDE_CONFIG_DIR/skills/private"
"$script"
test ! -L "$HOME/.agents/skills/deleted"
test ! -L "$CLAUDE_CONFIG_DIR/skills/deleted"
test -L "$HOME/.agents/skills/unrelated"
test "$CLAUDE_CONFIG_DIR/skills/private" -ef "$HOME/.local/agents/skills/private"
mkdir -p "$HOME/.config/agents/skills/conflict" "$HOME/.agents/skills/conflict"
touch "$HOME/.config/agents/skills/conflict/SKILL.md"
if "$script"; then
    echo "expected a conflict to fail" >&2
    exit 1
fi
test -d "$HOME/.agents/skills/conflict" && test ! -L "$HOME/.agents/skills/conflict"
