/-  *zig-engine
/+  smart=zig-sys-smart, zink=zink-zink
|%
+$  ship-sig   [p=@ux q=ship r=life]
+$  sequencer  (pair address:smart ship)
::
+$  shard  [=chain =hall]
::
+$  hall
  $:  shard-id=@ux
      batch-num=@ud
      =sequencer
      mode=availability-method
      latest-diff-hash=@ux
      roots=(list @ux)
  ==
::
::  capitol: tracks sequencer and state roots / diffs for all shards
::
+$  capitol  (map @ux hall)
::
::  shard state transition
::
+$  batch
  $:  town-id=id:smart
      num=@ud
      mode=availability-method
      state-diffs=(list state)
      diff-hash=@ux
      new-root=@ux
      new-state=chain
      peer-roots=(map id:smart @ux)  ::  roots for all other towns
      =sig:smart                     ::  sequencer signs new state root
  ==
::
+$  availability-method
  $%  [%full-publish ~]
      [%committee members=(map address:smart [ship (unit sig:smart)])]
  ==
::
+$  town-action
  $%  ::  administration
      $:  %init
          rollup-host=ship
          =address:smart
          private-key=@ux
          shard-id=@ux
          starting-state=(unit chain)
          mode=availability-method
      ==
      [%clear-state ~]
      ::  transactions
      [%receive-assets assets=state]
      [%receive txns=(set transaction:smart)]
      ::  batching
      [%trigger-batch ~]
      [%perform-batch eth-block-height=@ud]
  ==
::
+$  rollup-update
  $%  capitol-update
      shard-update
  ==
+$  capitol-update  [%new-capitol =capitol]
+$  shard-update
  $%  [%new-peer-root shard=id:smart root=@ux timestamp=@da]
      [%new-sequencer shard=id:smart who=ship]
  ==
::
::  indexer must verify root is posted to rollup before verifying new state
::  pair of [transactions town] is batch from sur/indexer.hoon
+$  indexer-update
  [%update root=@ux transactions=(list [@ux transaction:smart]) shard]
--
