/+  smart=zig-sys-smart
::
|%
+$  action
  $%  [%open town-id=id:smart =address:smart]
  ==
::
+$  configure
  $%  [%edit-gas gas=[rate=@ud budget=@ud]]
      [%edit-volume volume=@ud]
      [%put-town town-id=id:smart =town-info]
  ==
::
+$  versioned-state
  $%  state-0
  ==
::
+$  state-0
  $:  %0
      town-infos=(map id:smart town-info)
      gas=[rate=@ud budget=@ud]
      volume=@ud
  ==
::
+$  town-info
  $:  =address:smart
      zigs-rice=id:smart
      zigs-wheat=id:smart
  ==
--
