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
++  get-sent-history
  |=  [=address:smart our=@p now=@da]
  ^-  (map @ux [=egg:smart action=supported-actions])
  =/  txn-history=update:ui
    .^(update:ui %gx /(scot %p our)/indexer/(scot %da now)/from/0x0/(scot %ux address)/noun)
  ?~  txn-history  ~
  ?.  ?=(%egg -.txn-history)  ~
  %-  ~(urn by eggs.txn-history)
  |=  [hash=@ux upd=[@ * =egg:smart]]
  [egg.upd(status.shell (add 200 `@`status.shell.egg.upd)) [%noun yolk.egg.upd]]
::
++  create-id-subs
  |=  [pubkeys=(set @ux) our=@p]
  ^-  (list card)
  %+  turn  ~(tap in pubkeys)
  |=  k=@ux
  =/  w=wire  /id/0x0/(scot %ux k)
  =-  [%pass w %agent [our %uqbar] %watch -]
  /indexer/wallet/id/0x0/(scot %ux k)/history  ::  TODO: remove hardcode; replace %wallet with [dap.bowl]?
::
++  clear-id-sub
  |=  [id=@ux our=@p]
  ^-  (list card)
  =+  /indexer/wallet/id/0x0/(scot %ux id)
  [%pass - %agent [our %uqbar] %leave ~]~
::
++  clear-all-id-subs
  |=  wex=boat:gall
  ^-  (list card)
  %+  murn  ~(tap by wex)
  |=  [[=wire =ship =term] *]
  ^-  (unit card)
  ?.  ?=([%indexer %wallet %id *] wire)  ~
  `[%pass wire %agent [ship term] %leave ~]
::
++  watch-for-batches
  |=  [our=@p town-id=@ux]
  ^-  (list card)
  :~  =-  [%pass /new-batch %agent [our %uqbar] %watch -]
      /indexer/wallet/batch-order/(scot %ux town-id)/history
  ==
::
++  make-tokens
  |=  [addrs=(list address:smart) our=@p now=@da]
  ^-  (map address:smart book)
  =|  new=(map address:smart book)
  |-  ::  scry for each tracked address
  ?~  addrs  new
  =/  upd  .^(update:ui %gx /(scot %p our)/uqbar/(scot %da now)/indexer/newest/holder/0x0/(scot %ux i.addrs)/noun)
  ?~  upd  new
  ?.  ?=(%grain -.upd)
    ::  handle newest-grain update type
    ?>  ?=(%newest-grain -.upd)
    =/  single=asset
      ?.  ?=(%& -.grain.upd)
        ::  handle contract asset
        [%unknown town-id.p.grain.upd lord.p.grain.upd ~]
      ::  determine type token/nft/unknown
      (discover-asset-mold town-id.p.grain.upd lord.p.grain.upd data.p.grain.upd)
      %=  $
        addrs  t.addrs
        new  (~(put by new) i.addrs (malt ~[[id.p.grain.upd single]]))
      ==
  %=  $
    addrs  t.addrs
    new  (~(put by new) i.addrs (indexer-update-to-book upd))
  ==
::
++  indexer-update-to-book
  |=  =update:ui
  ^-  book
  ?>  ?=(%grain -.update)
  =/  grains-list=(list [@da =batch-location:ui =grain:smart])
    (zing ~(val by grains.update))
  =|  new-book=book
  |-  ^-  book
  ?~  grains-list  new-book
  =*  grain  grain.i.grains-list
  =/  =asset
    ?.  ?=(%& -.grain)
      ::  handle contract asset
      [%unknown town-id.p.grain lord.p.grain ~]
    ::  determine type token/nft/unknown and store in book
    (discover-asset-mold town-id.p.grain lord.p.grain data.p.grain)
  %=  $
    grains-list  t.grains-list
    new-book  (~(put by new-book) id.p.grain asset)
  ==
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
  |=  [tokens=(map address:smart book) =metadata-store our=@p now=@da]
  =/  book=(list [=id:smart =asset])
    %-  zing
    %+  turn  ~(val by tokens)
    |=(=book ~(tap by book))
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
