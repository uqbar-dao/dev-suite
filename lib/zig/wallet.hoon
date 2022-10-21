/-  *zig-wallet, ui=zig-indexer
/+  ui-lib=zig-indexer
=>  |%
    +$  card  card:agent:gall
    --
|%
++  hash-txn
  |=  [=calldata:smart =shell:smart]
  ::  hash the immutable+unique aspects of a transaction
  `@ux`(sham [shell calldata])
::
++  tx-update-card
  |=  in=[@ux transaction:smart supported-actions]
  ^-  card
  =+  `wallet-update`[%tx-status in]
  [%give %fact ~[/tx-updates] %wallet-update !>(-)]
::
++  get-sent-history
  |=  [=address:smart our=@p now=@da]
  ^-  (map @ux [=transaction:smart action=supported-actions])
  =/  txn-history=update:ui
    ::  TODO scry uqbar not indexer
    .^(update:ui %gx /(scot %p our)/indexer/(scot %da now)/from/0x0/(scot %ux address)/noun)
  ?~  txn-history  ~
  ?.  ?=(%txn -.txn-history)  ~
  %-  ~(urn by txns.txn-history)
  |=  [@ux @ * txn=transaction:smart]
  [txn(status (add 200 `@`status.txn)) [%noun calldata.txn]]
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
  |=  [our=@p shard=@ux]
  ^-  (list card)
  =-  [%pass /new-batch %agent [our %uqbar] %watch -]~
  /indexer/wallet/batch-order/(scot %ux shard)/history
::
++  make-tokens
  |=  [addrs=(list address:smart) our=@p now=@da]
  ^-  (map address:smart book)
  =|  new=(map address:smart book)
  |-  ::  scry for each tracked address
  ?~  addrs  new
  =/  upd  .^(update:ui %gx /(scot %p our)/uqbar/(scot %da now)/indexer/newest/holder/0x0/(scot %ux i.addrs)/noun)
  ?~  upd  new
  ?.  ?=(%item -.upd)
    ::  handle newest-item update type
    ?>  ?=(%newest-item -.upd)
    =/  single=asset
      ?.  ?=(%& -.item.upd)
        ::  handle contract asset
        [%unknown shard.p.item.upd source.p.item.upd ~]
      ::  determine type token/nft/unknown
      (discover-asset-mold shard.p.item.upd source.p.item.upd noun.p.item.upd)
      %=  $
        addrs  t.addrs
        new  (~(put by new) i.addrs (malt ~[[id.p.item.upd single]]))
      ==
  %=  $
    addrs  t.addrs
    new  (~(put by new) i.addrs (indexer-update-to-book upd))
  ==
::
++  indexer-update-to-book
  |=  =update:ui
  ^-  book
  ?>  ?=(%item -.update)
  =/  items-list=(list [@da =batch-location:ui =item:smart])
    (zing ~(val by items.update))
  =|  new-book=book
  |-  ^-  book
  ?~  items-list  new-book
  =*  item  item.i.items-list
  =/  =asset
    ?.  ?=(%& -.item)
      ::  handle contract asset
      [%unknown shard.p.item source.p.item ~]
    ::  determine type token/nft/unknown and store in book
    (discover-asset-mold shard.p.item source.p.item noun.p.item)
  %=  $
    items-list  t.items-list
    new-book  (~(put by new-book) id.p.item asset)
  ==
::
++  discover-asset-mold
  |=  [shard=@ux contract=@ux data=*]
  ^-  asset
  =+  tok=((soft token-account) data)
  ?^  tok
    [%token shard contract metadata.u.tok u.tok]
  =+  nft=((soft nft) data)
  ?^  nft
    [%nft shard contract metadata.u.nft u.nft]
  [%unknown shard contract data]
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
      ::  (sub to indexer for the metadata item id, update our store on update)
      $(book t.book)
    ::  scry indexer for metadata item and store it
    ?~  meta=(fetch-metadata -.asset shard.asset metadata.asset our now)
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
  |=  [token-type=@tas shard=@ux =id:smart our=ship now=time]
  ^-  (unit asset-metadata)
  ::  manually import metadata for a token
  =/  scry-res
    .^(update:ui %gx /(scot %p our)/uqbar/(scot %da now)/indexer/newest/item/(scot %ux shard)/(scot %ux id)/noun)
  =/  g=(unit item:smart)
    ::  TODO remote scry w/ uqbar.hoon
    ?~  scry-res  ~
    ?.  ?=(%newest-item -.scry-res)  ~
    `item.scry-res
  ?~  g
    ~&  >>>  "%wallet: failed to find matching metadata for a item we hold"
    ~
  ?.  ?=(%& -.u.g)  ~
  ?+  token-type  ~
    %token  `[%token shard ;;(token-metadata noun.p.u.g)]
    %nft    `[%nft shard ;;(nft-metadata noun.p.u.g)]
  ==
::
::  JSON parsing utils
::
++  parsing
=,  enjs:format
|%
++  parse-asset
  |=  [=id:smart =asset]
  ^-  [p=@t q=json]
  :-  (scot %ux id)
  %-  pairs
  :~  ['id' [%s (scot %ux id)]]
      ['shard' [%s (scot %ux shard.asset)]]
      ['contract' [%s (scot %ux contract.asset)]]
      ['token_type' [%s (scot %tas -.asset)]]
      :-  'data'
      %-  pairs
      ?-    -.asset
          %token
        :~  ['balance' (numb balance.asset)]
            ['metadata' [%s (scot %ux metadata.asset)]]
        ==
      ::
          %nft
        :~  ['id' (numb id.asset)]
            ['uri' [%s uri.asset]]
            ['metadata' [%s (scot %ux metadata.asset)]]
            ['allowances' (address-set allowances.asset)]
            ['properties' (properties properties.asset)]
            ['transferrable' [%b transferrable.asset]]
        ==
      ::
          %unknown
        ~
      ==
  ==
::
++  parse-metadata
  |=  [=id:smart m=asset-metadata]
  ^-  [p=@t q=json]
  :-  (scot %ux id)
  %-  pairs
  :~  ['id' [%s (scot %ux id)]]
      ['shard' [%s (scot %ux shard.m)]]
      ['token_type' [%s (scot %tas -.m)]]
      :-  'data'
      %-  pairs
      %+  snoc
        ^-  (list [@t json])
        :~  ['name' [%s name.m]]
            ['symbol' [%s symbol.m]]
            ['supply' (numb supply.m)]
            ['cap' ?~(cap.m ~ (numb u.cap.m))]
            ['mintable' [%b mintable.m]]
            ['minters' (address-set minters.m)]
            ['deployer' [%s (scot %ux deployer.m)]]
            ['salt' (numb salt.m)]
        ==
      ?-  -.m
        %token  ['decimals' (numb decimals.m)]
        %nft  ['properties' (properties-set properties.m)]
      ==
  ==
::
++  address-set
  |=  a=(set address:smart)
  ^-  json
  :-  %a
  %+  turn  ~(tap in a)
  |=(a=address:smart [%s (scot %ux a)])
::
++  properties-set
  |=  p=(set @tas)
  ^-  json
  :-  %a
  %+  turn  ~(tap in p)
  |=(prop=@tas [%s (scot %tas prop)])
::
++  properties
  |=  p=(map @tas @t)
  ^-  json
  %-  pairs
  %+  turn  ~(tap by p)
  |=([prop=@tas val=@t] [prop [%s val]])
::
++  parse-transaction
  |=  [hash=@ux t=transaction:smart action=supported-actions]
  ^-  [p=@t q=json]
  :-  (scot %ux hash)
  %-  pairs
  :~  ['from' [%s (scot %ux address.caller.t)]]
      ['nonce' (numb nonce.caller.t)]
      ['contract' [%s (scot %ux contract.t)]]
      ['rate' (numb rate.gas.t)]
      ['budget' (numb bud.gas.t)]
      ['shard' [%s (scot %ux shard.t)]]
      ['status' (numb status.t)]
      :-  'action'
      %-  frond
      :-  (scot %tas -.action)
      %-  pairs
      ?-    -.action
          %give
        :~  ['to' [%s (scot %ux to.action)]]
            ['amount' (numb amount.action)]
            ['item' [%s (scot %ux item.action)]]
        ==
      ::
          %give-nft
        :~  ['to' [%s (scot %ux to.action)]]
            ['item' [%s (scot %ux item.action)]]
        ==
      ::
          %text
        ~[['custom' [%s +.action]]]
      ::
          %noun
        ~[['custom' [%s (crip (noah !>(+.action)))]]]
      ==
  ==
--
--
