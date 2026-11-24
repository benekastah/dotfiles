#!/usr/bin/env python3
"""Remind an agent to reload shared instructions when their contents change."""
import argparse
import fcntl
import hashlib
import json
import os
import sys
from pathlib import Path

MESSAGE = (
    'Global or local agent instructions may have changed. Before continuing, '
    'read ~/.config/agents/AGENTS.md and, if it exists, ~/.local/agents/AGENTS.md. '
    'Their current contents replace earlier versions of those files; retain '
    'applicable repository instructions and higher-priority instructions. '
    'Skill files may also have changed; reread the skills relevant to your current work.'
)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--client', choices=('codex', 'claude'), required=True)
    args = parser.parse_args()
    event = json.load(sys.stdin)
    kind = event.get('hook_event_name')
    if kind not in ('UserPromptSubmit', 'PreToolUse'):
        return
    session = event.get('session_id')
    if not isinstance(session, str) or not session:
        print(json.dumps({'hookSpecificOutput': {'hookEventName': kind, 'additionalContext': MESSAGE}}))
        return
    home = Path.home()
    paths = (home / '.config/agents/AGENTS.md', home / '.local/agents/AGENTS.md')
    digest = hashlib.sha256()
    for path in paths:
        digest.update(str(path).encode())
        try:
            digest.update(b'\0present\0' + path.read_bytes())
        except FileNotFoundError:
            digest.update(b'\0missing\0')
    identity = [args.client, session, event.get('agent_id', '')]
    if args.client == 'codex':
        identity.append(event.get('turn_id', ''))
    key = hashlib.sha256(json.dumps(identity).encode()).hexdigest()
    cache = Path(os.environ.get('XDG_CACHE_HOME', home / '.cache')) / 'agent-instruction-refresh'
    cache.mkdir(parents=True, exist_ok=True)
    state = cache / key
    with state.open('a+') as f:
        fcntl.flock(f, fcntl.LOCK_EX)
        f.seek(0)
        previous = f.read()
        current = digest.hexdigest()
        if previous == current:
            return
        f.seek(0)
        f.truncate()
        f.write(current)
        f.flush()
        output = {'hookEventName': kind, 'additionalContext': MESSAGE}
        if kind == 'PreToolUse':
            output.update(permissionDecision='deny', permissionDecisionReason=MESSAGE)
        print(json.dumps({'hookSpecificOutput': output}))

if __name__ == '__main__':
    main()
