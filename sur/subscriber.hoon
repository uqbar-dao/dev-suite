/+  *mip
|%
+$  subscriber-action
  $%  [%sub =ship agent=@tas =path]
      [%unsub =ship agent=@tas =path]
      [%clear =ship agent=@tas =path]
  ==
::  map of [ship to %agent-name] to subscription path to signs
+$  facts  (mip [ship term] path (qeu sign:agent:gall))
--