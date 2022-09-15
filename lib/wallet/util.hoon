/-  *wallet, ui=indexer
/+  ui-lib=indexer
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
  |=  [hash=@ux =egg:smart =supported-actions]
  ^-  card
  =+  `wallet-update`[%tx-status hash egg supported-actions]
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
    :: /indexer/id/(scot %ux k)
    /indexer/wallet/id/0x0/(scot %ux k)  ::  TODO: remove hardcode; replace %wallet with [dap.bowl]?
  %+  turn
    ~(tap in pubkeys)
  |=  k=@ux
  =-  [%pass - %agent [our %uqbar] %watch -]
  :: /indexer/holder/(scot %ux k)
  /indexer/wallet/holder/0x0/(scot %ux k)  ::  TODO: remove hardcode; replace %wallet with [dap.bowl]?
::
++  clear-holder-and-id-sub
  |=  [id=@ux wex=boat:gall]
  ^-  (list card)
  %+  murn  ~(tap by wex)
  |=  [[=wire =ship =term] *]
  ^-  (unit card)
  ?.  =((slav %ux (rear wire)) id)  ~
  `[%pass wire %agent [ship term] %leave ~]
::
++  clear-all-holder-and-id-subs
  |=  wex=boat:gall
  ^-  (list card)
  %+  murn  ~(tap by wex)
  |=  [[=wire =ship =term] *]
  ^-  (unit card)
  ?.  |(?=([%indexer %id *] wire) ?=([%indexer %holder *] wire))  ~
  `[%pass wire %agent [ship term] %leave ~]
::
++  indexer-update-to-books
  |=  =update:ui
  ^-  book
  =|  new-book=book
  ?>  ?=(%grain -.update)
  =/  grains-list=(list [@da =batch-location:ui =grain:smart])
    (zing ~(val by grains.update))
  |-  ^-  book
  ?~  grains-list  new-book
  =*  grain  grain.i.grains-list
  ?.  ?=(%& -.grain)
    ::  if grain isn't data, just skip
    $(grains-list t.grains-list)
  ::  determine type token/nft/unknown and store in book
  =/  =asset  (discover-asset-mold town-id.p.grain lord.p.grain data.p.grain)
  %=  $
    grains-list  t.grains-list
    new-book  (~(put by new-book) id.p.grain asset)
  ==
::
++  indexer-update-to-asset
  |=  =update:ui
  ^-  [id:smart asset]
  =|  new-book=book
  ?>  ?=(%newest-grain -.update)
  :-  grain-id.update
  ?.  ?=(%& -.grain.update)
    ::  handle contract asset
    [%unknown town-id.p.grain.update lord.p.grain.update ~]
  ::  determine type token/nft/unknown
  (discover-asset-mold town-id.p.grain.update lord.p.grain.update data.p.grain.update)
::
++  discover-asset-mold
  |=  [town=@ux contract=@ux data=*]
  ^-  asset
  =+  tok=((soft token-account) data)
  ?^  tok
    [%token town contract metadata.u.tok u.tok]
  =+  nft=((soft nft) data)
  ?^  nft
    [%nft town contract metadata.u.nft u.nft]
  [%unknown town contract data]
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
  =/  scry-res
    .^(update:ui %gx /(scot %p our)/uqbar/(scot %da now)/indexer/newest/grain/(scot %ux town-id)/(scot %ux id)/noun)
  =/  g=(unit grain:smart)
    ::  TODO remote scry w/ uqbar.hoon
    ?~  scry-res  ~
    ?.  ?=(%newest-grain -.scry-res)  ~
    `grain.scry-res
  ?~  g
    ~&  >>>  "%wallet: failed to find matching metadata for a grain we hold"
    ~
  ?.  ?=(%& -.u.g)  ~
  ?+  token-type  ~
    %token  `[%token town-id ;;(token-metadata data.p.u.g)]
    %nft    `[%nft town-id ;;(nft-metadata data.p.u.g)]
  ==
--
