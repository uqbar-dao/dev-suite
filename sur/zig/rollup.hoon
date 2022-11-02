::  testnet rollup
::
::  rollup app: run on ONE ship, receive batches from sequencer apps.
::
/-  *zig-sequencer
/+  smart=zig-sys-smart
|%
+$  action
  $%  [%activate ~]
      [%launch-town from=address:smart =sig:smart town]
      [%bridge-assets town-id=id:smart assets=state]
      [%receive-batch from=address:smart batch]
  ==
--
