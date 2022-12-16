|%
+$  subscriber-action
  $%  [%sub =ship app=@tas =path]
      [%unsub =ship app=@tas =path]
      [%clear =ship app=@tas =path]
  ==
+$  signs  (map [=ship app=@tas =path] (set sign:agent:gall))
+$  facts  (map [=ship app=@tas =path] (set @t))
--