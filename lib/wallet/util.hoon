/-  *wallet, ui=indexer
=>  |%
    +$  card  card:agent:gall
    --
|%
++  hash-egg
  |=  [=shell:smart =yolk:smart]
  ^-  @ux
  ::  hash the immutable+unique aspects of a transaction
  `@ux`(sham [shell yolk])
::
++  tx-update-card
  |=  [hash=@ux =egg:smart args=(unit supported-args)]
  ^-  card
  =+  [%tx-status hash egg args]
  [%give %fact ~[/tx-updates] %zig-wallet-update !>(-)]
::
++  create-holder-and-id-subs
  |=  [pubkeys=(set @ux) our=@p]
  ^-  (list card)
  %+  weld
    %+  turn
      ~(tap in pubkeys)
    |=  k=@ux
    =-  [%pass - %agent [our %uqbar] %watch -]
    :: /id/(scot %ux k)
    /id/0x0/(scot %ux k)
  %+  turn
    ~(tap in pubkeys)
  |=  k=@ux
  =-  [%pass - %agent [our %uqbar] %watch -]
  :: /holder/(scot %ux k)
  /holder/0x0/(scot %ux k)
::
++  clear-holder-and-id-sub
  |=  [id=@ux wex=boat:gall]
  ^-  (list card)
  %+  murn  ~(tap by wex)
  |=  [[=wire =ship =term] *]
  ^-  (unit card)
  ?.  |(=([%id id] wire) =([%holder id] wire))  ~
  `[%pass wire %agent [ship term] %leave ~]
::
++  clear-all-holder-and-id-subs
  |=  wex=boat:gall
  ^-  (list card)
  %+  murn  ~(tap by wex)
  |=  [[=wire =ship =term] *]
  ^-  (unit card)
  ?.  |(?=([%id *] wire) ?=([%holder *] wire))  ~
  `[%pass wire %agent [ship term] %leave ~]
::
++  indexer-update-to-books
  |=  [=update:ui our=@ux =metadata-store]
  ^-  book
  =|  new-book=book
  ?.  ?=(%grain -.update)  ~
  =/  grains-list=(list [@da =batch-location:ui =grain:smart])
    (zing ~(val by grains.update))
  |-  ^-  book
  ?~  grains-list  new-book
  =*  grain  grain.i.grains-list
  ?.  ?=(%& -.grain)
    ::  if grain isn't data, just skip
    $(grains-list t.grains-list)
  ::  determine type token/nft/unknown and store in book
  =/  =asset  (discover-asset-mold town-id.p.grain data.p.grain)
  %=  $
    grains-list  t.grains-list
    new-book  (~(put by new-book) id.p.grain asset)
  ==
::
++  discover-asset-mold
  |=  [town=@ux data=*]
  ^-  asset
  =+  tok=(mule |.(;;(token-account data)))
  ?:  ?=(%& -.tok)
    [%token town metadata.p.tok p.tok]
  =+  nft=(mule |.(;;(nft-account data)))
  ?:  ?=(%& -.nft)
    [%nft town metadata.p.nft p.nft]
  [%unknown town data]
::
++  update-metadata-store
  |=  [=book our=ship =metadata-store our=ship now=time]
  =/  book=(list [=id:smart =asset])  ~(tap by book)
  |-  ^-  ^metadata-store
  ?~  book  metadata-store
  =*  asset  asset.i.book
  ?-    -.asset
      ?(%token %nft)
    ?:  (~(has by metadata-store) metadata.asset)
      ::  already got metadata
      ::  TODO: determine schedule for updating asset metadata
      ::  (sub to indexer for the metadata grain id, update our store on update)
      $(book t.book)
    ::  scry indexer for metadata grain and store it
    ?~  meta=(fetch-metadata -.asset town-id.asset metadata.asset our now)
      ::  couldn't find it
      $(book t.book)
    %=  $
      book  t.book
      metadata-store  (~(put by metadata-store) metadata.asset u.meta)
    ==
  ::
      %unknown
    ::  can't find metadata if asset type is unknown
    $(book t.book)
  ==
::
++  fetch-metadata
  |=  [token-type=@tas town-id=@ux =id:smart our=ship now=time]
  ^-  (unit asset-metadata)
  ::  manually import metadata for a token
  =/  g=(unit grain:smart)
    ::  TODO remote scry w/ uqbar.hoon
    .^((unit grain:smart) %gx /(scot %p our)/uqbar/(scot %da now)/grain/(scot %ux town-id)/(scot %ux id)/noun)
  ?~  g
    ~&  >>>  "%wallet: failed to find matching metadata for a grain we hold"
    ~
  ?.  ?=(%& -.u.g)  ~
  ?+  token-type  ~
    %token  `[%token town-id ;;(token-metadata data.p.u.g)]
    %nft    `[%nft town-id ;;(nft-metadata data.p.u.g)]
  ==
--
