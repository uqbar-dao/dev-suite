/+  smart=zig-sys-smart
::
|%
+$  action
  $%  [%open town-id=id:smart =address:smart]
      [%confirm me=address:smart]
  ==
::
+$  configure
  $%  [%edit-gas gas=[rate=@ud budget=@ud]]
      [%edit-volume volume=@ud]
      [%edit-timeout-duration timeout-duration=@dr]
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
      on-timeout=(map @p [unlock=@da count=@ud])
      timeout-duration=@dr
      volume=@ud
  ==
::
+$  town-info
  $:  =address:smart
      zigs-rice=id:smart
      zigs-wheat=id:smart
  ==
--
