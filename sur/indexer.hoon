/-  r=resource,
    seq=sequencer
/+  smart=zig-sys-smart
::
|%
+$  query-type
  $?  %batch
      %egg
      %from
      %grain
      %grain-eggs
      %holder
      %lord
      %slot
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
  (map town-id=id:smart [=batches =batch-order])
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
  $%  base-state-0
  ==
::
+$  base-state-0
  $:  %0
      =batches-by-town
      =capitol:seq
      =sequencer-update-queue
      =town-update-queue
  ==
+$  indices-0
  $:  =egg-index
      from-index=second-order-index
      grain-index=batch-index
      grain-eggs-index=second-order-index
      holder-index=second-order-index
      lord-index=second-order-index
      to-index=second-order-index
      =newest-batch-by-town
  ==
+$  inflated-state-0  [base-state-0 indices-0]
::
+$  update
  $@  ~
  $%  [%batch batches=(map batch-id=id:smart [timestamp=@da location=town-location =batch])]
      [%batch-order =batch-order]
      [%egg eggs=(map egg-id=id:smart [timestamp=@da location=egg-location =egg:smart])]
      [%grain grains=(jar grain-id=id:smart [timestamp=@da location=batch-location =grain:smart])]
      $:  %hash
          batches=(map batch-id=id:smart [timestamp=@da location=town-location =batch])
          eggs=(map egg-id=id:smart [timestamp=@da location=egg-location =egg:smart])
          grains=(jar grain-id=id:smart [timestamp=@da location=batch-location =grain:smart])
      ==
  ==
--
