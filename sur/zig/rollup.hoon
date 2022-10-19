::  testnet rollup
::
::  rollup app: run on ONE ship, receive batches from sequencer apps.
::
/-  *zig-sequencer
/+  smart=zig-sys-smart
|%
+$  action
  $%  [%activate ~]
      [%launch-shard from=address:smart =sig:smart shard]
      [%bridge-assets shard-id=id:smart assets=state]
      [%receive-batch from=address:smart batch]
  ==
--
