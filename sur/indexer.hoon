/-  seq=sequencer
/+  smart=zig-sys-smart
::
|%
+$  query-type
  $?  %batch
      %egg
      %from
      %grain
      :: %grain-eggs
      %holder
      %lord
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
      egg-location
  ==
+$  second-order-location  id:smart
+$  town-location  id:smart
+$  batch-location
  [town-id=id:smart batch-root=id:smart]
+$  egg-location
  [town-id=id:smart batch-root=id:smart egg-num=@ud]
::
+$  location-index
  (map @ux (jar @ux location))
+$  batch-index  ::  used for grains
  (map @ux (jar @ux batch-location))
+$  egg-index  ::  only ever one tx per id; -> (map (map))?
  (map @ux (jar @ux egg-location))
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
  [transactions=(list [@ux egg:smart]) town:seq]
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
  $%  base-state-2
      base-state-1
      base-state-0
  ==
::
+$  base-state-2
  $:  %2
      =batches-by-town
      =capitol:seq
      =sequencer-update-queue
      =town-update-queue
      old-sub-paths=(map path @ux)
      old-sub-updates=(map @ux update)
      catchup-indexer=dock
  ==
+$  base-state-1
  $:  %1
      =batches-by-town
      =capitol:seq
      =sequencer-update-queue
      =town-update-queue
      old-sub-updates=(map path update)
      catchup-indexer=dock
  ==
+$  base-state-0
  $:  %0
      =batches-by-town
      =capitol:seq
      =sequencer-update-queue
      =town-update-queue
      old-sub-updates=(map path update)
  ==
::
+$  indices-0
  $:  =egg-index
      from-index=second-order-index
      grain-index=batch-index
      :: grain-eggs-index=second-order-index
      holder-index=second-order-index
      lord-index=second-order-index
      to-index=second-order-index
      =newest-batch-by-town
  ==
::
+$  inflated-state-2  [base-state-2 indices-0]
+$  inflated-state-1  [base-state-1 indices-0]
+$  inflated-state-0  [base-state-0 indices-0]
::
+$  batch-update-value
  [timestamp=@da location=town-location =batch]
+$  egg-update-value
  [timestamp=@da location=egg-location =egg:smart]
+$  grain-update-value
  [timestamp=@da location=batch-location =grain:smart]
::
+$  update
  $@  ~
  $%  [%path-does-not-exist ~]
      [%batch batches=(map batch-id=id:smart batch-update-value)]
      [%batch-order =batch-order]
      [%egg eggs=(map egg-id=id:smart egg-update-value)]
      [%grain grains=(jar grain-id=id:smart grain-update-value)]
      $:  %hash
          batches=(map batch-id=id:smart batch-update-value)
          eggs=(map egg-id=id:smart egg-update-value)
          grains=(jar grain-id=id:smart grain-update-value)
      ==
      [%newest-batch batch-id=id:smart batch-update-value]
      [%newest-batch-order batch-id=id:smart]
      [%newest-egg egg-id=id:smart egg-update-value]
      [%newest-grain grain-id=id:smart grain-update-value]
      ::  %newest-hash type is just %hash, since can have multiple
      ::  eggs/grains, considering second-order indices
  ==
::
::  TODO: change update interface to below
:: +$  update
::   $@  ~
::   $%  [%path-does-not-exist ~]
::       [%batches (map batch-id=id:smart [timestamp=@da location=town-location =batch])]
::       [%batch-order =batch-order]
::       [%eggs (map egg-id=id:smart [timestamp=@da location=egg-location =egg:smart])]
::       [%grains (jar grain-id=id:smart [timestamp=@da location=batch-location =grain:smart])]
::       $:  %hashes
::           batches=(map batch-id=id:smart [timestamp=@da location=town-location =batch])
::           eggs=(map egg-id=id:smart [timestamp=@da location=egg-location =egg:smart])
::           grains=(jar grain-id=id:smart [timestamp=@da location=batch-location =grain:smart])
::       ==
::       [%batch batch-id=id:smart timestamp=@da location=town-location =batch]
::       [%newest-batch-id batch-id=id:smart]  ::  keep?
::       [%egg egg-id=id:smart timestamp=@da location=egg-location =egg:smart]
::       [%grain grain-id=id:smart timestamp=@da location=batch-location =grain:smart]
::       $:  %hash
::           batch=[batch-id=id:smart timestamp=@da location=town-location =batch]
::           egg=[egg-id=id:smart timestamp=@da location=egg-location =egg:smart]
::           grain=[grain-id=id:smart timestamp=@da location=batch-location =grain:smart]
::       ==
::   ==
--
