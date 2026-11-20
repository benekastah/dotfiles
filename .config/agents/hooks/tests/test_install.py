import json, os, subprocess, tempfile, unittest
from pathlib import Path
SCRIPT = Path.home() / 'bin/install-shared-hooks'
class InstallTest(unittest.TestCase):
 def test_preserves_and_is_idempotent(self):
  with tempfile.TemporaryDirectory() as d:
   home=Path(d); cfg=home/'.claude/settings.json'; cfg.parent.mkdir()
   existing={'hooks':{'PreToolUse':[{'matcher':'Bash','hooks':[{'type':'command','command':'existing'}]}]},'model':'example'}
   cfg.write_text(json.dumps(existing)); cfg.chmod(0o644)
   env=dict(os.environ, HOME=d, CODEX_HOME=str(home/'.codex'), CLAUDE_CONFIG_DIR=str(home/'.claude'))
   for _ in range(2): subprocess.run(['python3',str(SCRIPT)],env=env,check=True,capture_output=True)
   result=json.loads(cfg.read_text()); self.assertEqual('example',result['model']); self.assertEqual('existing',result['hooks']['PreToolUse'][0]['hooks'][0]['command'])
   self.assertEqual(2,len(result['hooks']['PreToolUse'])); self.assertEqual(1,len(result['hooks']['UserPromptSubmit']))
   self.assertEqual(1,len(json.loads((home/'.codex/hooks.json').read_text())['hooks']['UserPromptSubmit']))
 def test_refuses_restricted_settings(self):
  with tempfile.TemporaryDirectory() as d:
   home=Path(d); cfg=home/'.claude/settings.json'; cfg.parent.mkdir(); cfg.write_text('{}'); cfg.chmod(0o600)
   env=dict(os.environ,HOME=d,CODEX_HOME=str(home/'.codex'),CLAUDE_CONFIG_DIR=str(home/'.claude'))
   result=subprocess.run(['python3',str(SCRIPT)],env=env,capture_output=True)
   self.assertNotEqual(0,result.returncode); self.assertEqual('{}',cfg.read_text())
if __name__=='__main__': unittest.main()
