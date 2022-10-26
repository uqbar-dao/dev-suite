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
      %town
      %hash
  ==
::
+$  query-payload
  ?(item-hash=@ux [town-id=@ux item-hash=@ux] location)
::
+$  location
  $?  second-order-location
      town-location
      batch-location
      txn-location
  ==
+$  second-order-location  id:smart
+$  town-location  id:smart
+$  batch-location
  [town-id=id:smart batch-root=id:smart]
+$  txn-location
  [town-id=id:smart batch-root=id:smart txn-num=@ud]
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
+$  batches-by-town
  (map town-id=id:smart batches-and-order)
+$  batches-and-order
  [=batches =batch-order]
+$  batches
  (map id:smart [timestamp=@da =batch])
+$  batch-order
  (list id:smart)  ::  0-index -> most recent batch
+$  batch
  [transactions=(list [@ux transaction:smart]) town:seq]
+$  newest-batch-by-town
  %+  map  town-id=id:smart
  [batch-id=id:smart timestamp=@da =batch]
::
+$  town-update-queue
  (map town-id=@ux (map batch-id=@ux timestamp=@da))
+$  sequencer-update-queue
  (map town-id=@ux (map batch-id=@ux batch))
::
+$  versioned-state
  $%  base-state-0
  ==
::
+$  base-state-0
  $:  %0
      =batches-by-town
      =capitol:seq
      =sequencer-update-queue
      =town-update-queue
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
      =newest-batch-by-town
  ==
::
+$  inflated-state-0  [base-state-0 indices-0]
::
+$  batch-update-value
  [timestamp=@da location=town-location =batch]
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
::       [%batches (map batch-id=id:smart [timestamp=@da location=town-location =batch])]
::       [%batch-order =batch-order]
::       [%txns (map txn-id=id:smart [timestamp=@da location=txn-location =transaction:smart])]
::       [%items (jar item-id=id:smart [timestamp=@da location=batch-location =item:smart])]
::       $:  %hashes
::           batches=(map batch-id=id:smart [timestamp=@da location=town-location =batch])
::           txns=(map txn-id=id:smart [timestamp=@da location=txn-location =transaction:smart])
::           items=(jar item-id=id:smart [timestamp=@da location=batch-location =item:smart])
::       ==
::       [%batch batch-id=id:smart timestamp=@da location=town-location =batch]
::       [%newest-batch-id batch-id=id:smart]  ::  keep?
::       [%txn txn-id=id:smart timestamp=@da location=txn-location =transaction:smart]
::       [%item item-id=id:smart timestamp=@da location=batch-location =item:smart]
::       $:  %hash
::           batch=[batch-id=id:smart timestamp=@da location=town-location =batch]
::           txn=[txn-id=id:smart timestamp=@da location=txn-location =transaction:smart]
::           item=[item-id=id:smart timestamp=@da location=batch-location =item:smart]
::       ==
::   ==
--
