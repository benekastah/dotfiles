import json, os, subprocess, tempfile, unittest
from pathlib import Path
SCRIPT = Path.home() / '.config/agents/hooks/refresh-instructions.py'
class RefreshTest(unittest.TestCase):
 def setUp(self):
  self.temp=tempfile.TemporaryDirectory(); self.addCleanup(self.temp.cleanup)
  self.home=Path(self.temp.name)
  for p in ('.config/agents/AGENTS.md','.local/agents/AGENTS.md'):
   f=self.home/p; f.parent.mkdir(parents=True,exist_ok=True); f.write_text('first\n')
 def hook(self,event,session='s1',turn='t1'):
  data={'hook_event_name':event,'session_id':session,'turn_id':turn}
  env=dict(os.environ,HOME=str(self.home),XDG_CACHE_HOME=str(self.home/'cache'))
  p=subprocess.run(['python3',str(SCRIPT),'--client','codex'],input=json.dumps(data),capture_output=True,text=True,env=env,check=True)
  return json.loads(p.stdout) if p.stdout else {}
 def test_change_repeats_per_session_and_blocks_tool(self):
  self.assertIn('additionalContext',self.hook('UserPromptSubmit')['hookSpecificOutput'])
  self.assertEqual({},self.hook('PreToolUse'))
  (self.home/'.local/agents/AGENTS.md').write_text('second\n')
  result=self.hook('PreToolUse')['hookSpecificOutput']
  self.assertEqual('deny',result['permissionDecision'])
  self.assertIn('AGENTS.md',result['permissionDecisionReason'])
  self.assertEqual({},self.hook('PreToolUse'))
  self.assertIn('additionalContext',self.hook('UserPromptSubmit',session='s2')['hookSpecificOutput'])
 def test_missing_and_new_local_file(self):
  (self.home/'.local/agents/AGENTS.md').unlink()
  self.hook('UserPromptSubmit')
  (self.home/'.local/agents/AGENTS.md').write_text('added')
  self.assertIn('additionalContext',self.hook('UserPromptSubmit')['hookSpecificOutput'])
if __name__=='__main__': unittest.main()
