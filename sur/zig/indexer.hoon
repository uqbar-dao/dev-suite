/-  seq=zig-sequencer
/+  smart=zig-sys-smart
::
|%
+$  query-type
  $?  %batch
      %txn
      %from
      %item
      :: %item-txns
      %holder
      %source
      %to
      %shard
      %hash
  ==
::
+$  query-payload
  ?(item-hash=@ux [shard-id=@ux item-hash=@ux] location)
::
+$  location
  $?  second-order-location
      shard-location
      batch-location
      txn-location
  ==
+$  second-order-location  id:smart
+$  shard-location  id:smart
+$  batch-location
  [shard-id=id:smart batch-root=id:smart]
+$  txn-location
  [shard-id=id:smart batch-root=id:smart txn-num=@ud]
::
+$  location-index
  (map @ux (jar @ux location))
+$  batch-index  ::  used for items
  (map @ux (jar @ux batch-location))
+$  txn-index  ::  only ever one tx per id; -> (map (map))?
  (map @ux (jar @ux txn-location))
+$  second-order-index
  (map @ux (jar @ux second-order-location))
::
+$  batches-by-shard
  (map shard-id=id:smart batches-and-order)
+$  batches-and-order
  [=batches =batch-order]
+$  batches
  (map id:smart [timestamp=@da =batch])
+$  batch-order
  (list id:smart)  ::  0-index -> most recent batch
+$  batch
  [transactions=(list [@ux transaction:smart]) shard:seq]
+$  newest-batch-by-shard
  %+  map  shard-id=id:smart
  [batch-id=id:smart timestamp=@da =batch]
::
+$  shard-update-queue
  (map shard-id=@ux (map batch-id=@ux timestamp=@da))
+$  sequencer-update-queue
  (map shard-id=@ux (map batch-id=@ux batch))
::
+$  versioned-state
  $%  base-state-0
  ==
::
+$  base-state-0
  $:  %0
      =batches-by-shard
      =capitol:seq
      =sequencer-update-queue
      =shard-update-queue
      old-sub-paths=(map path @ux)
      old-sub-updates=(map @ux update)
      catchup-indexer=dock
  ==
::
+$  indices-0
  $:  =txn-index
      from-index=second-order-index
      item-index=batch-index
      :: item-txns-index=second-order-index
      holder-index=second-order-index
      source-index=second-order-index
      to-index=second-order-index
      =newest-batch-by-shard
  ==
::
+$  inflated-state-0  [base-state-0 indices-0]
::
+$  batch-update-value
  [timestamp=@da location=shard-location =batch]
+$  txn-update-value
  [timestamp=@da location=txn-location =transaction:smart]
+$  item-update-value
  [timestamp=@da location=batch-location =item:smart]
::
+$  update
  $@  ~
  $%  [%path-does-not-exist ~]
      [%batch batches=(map batch-id=id:smart batch-update-value)]
      [%batch-order =batch-order]
      [%txn txns=(map txn-id=id:smart txn-update-value)]
      [%item items=(jar item-id=id:smart item-update-value)]
      $:  %hash
          batches=(map batch-id=id:smart batch-update-value)
          txns=(map txn-id=id:smart txn-update-value)
          items=(jar item-id=id:smart item-update-value)
      ==
      [%newest-batch batch-id=id:smart batch-update-value]
      [%newest-batch-order batch-id=id:smart]
      [%newest-txn txn-id=id:smart txn-update-value]
      [%newest-item item-id=id:smart item-update-value]
      ::  %newest-hash type is just %hash, since can have multiple
      ::  txns/items, considering second-order indices
  ==
::
::  TODO: change update interface to below
:: +$  update
::   $@  ~
::   $%  [%path-does-not-exist ~]
::       [%batches (map batch-id=id:smart [timestamp=@da location=shard-location =batch])]
::       [%batch-order =batch-order]
::       [%txns (map txn-id=id:smart [timestamp=@da location=txn-location =transaction:smart])]
::       [%items (jar item-id=id:smart [timestamp=@da location=batch-location =item:smart])]
::       $:  %hashes
::           batches=(map batch-id=id:smart [timestamp=@da location=shard-location =batch])
::           txns=(map txn-id=id:smart [timestamp=@da location=txn-location =transaction:smart])
::           items=(jar item-id=id:smart [timestamp=@da location=batch-location =item:smart])
::       ==
::       [%batch batch-id=id:smart timestamp=@da location=shard-location =batch]
::       [%newest-batch-id batch-id=id:smart]  ::  keep?
::       [%txn txn-id=id:smart timestamp=@da location=txn-location =transaction:smart]
::       [%item item-id=id:smart timestamp=@da location=batch-location =item:smart]
::       $:  %hash
::           batch=[batch-id=id:smart timestamp=@da location=shard-location =batch]
::           txn=[txn-id=id:smart timestamp=@da location=txn-location =transaction:smart]
::           item=[item-id=id:smart timestamp=@da location=batch-location =item:smart]
::       ==
::   ==
--
