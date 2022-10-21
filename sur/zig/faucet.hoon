/+  smart=zig-sys-smart
::
|%
+$  action
  $%  [%open shard-id=id:smart =address:smart]
      [%confirm me=address:smart]
  ==
::
+$  configure
  $%  [%edit-gas gas=[rate=@ud budget=@ud]]
      [%edit-volume volume=@ud]
      [%edit-timeout-duration timeout-duration=@dr]
      [%put-shard shard-id=id:smart =shard-info]
  ==
::
+$  versioned-state
  $%  state-0
  ==
::
+$  state-0
  $:  %0
      shard-infos=(map id:smart shard-info)
      gas=[rate=@ud budget=@ud]
      on-timeout=(map @p [unlock=@da count=@ud])
      timeout-duration=@dr
      volume=@ud
  ==
::
+$  shard-info
  $:  =address:smart
      zigs-account=id:smart
      zigs-contract=id:smart
  ==
--
