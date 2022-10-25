/-  *zig-wallet, ui=zig-indexer
/+  ui-lib=zig-indexer
=>  |%
    +$  card  card:agent:gall
    --
|%
++  hash-txn
  |=  [=calldata:smart =shell:smart]
  ::  hash the immutable+unique aspects of a transaction
  `@ux`(sham [calldata shell])
::
++  tx-update-card
  |=  in=[@ux transaction:smart supported-actions]
  ^-  card
  =+  `wallet-update`[%tx-status in]
  [%give %fact ~[/tx-updates] %wallet-update !>(-)]
::
++  get-sent-history
  |=  [=address:smart newest=? our=@p now=@da]
  ^-  (map @ux [transaction:smart supported-actions])
  =/  txn-history=update:ui
    .^  update:ui
        %gx
        %+  weld  /(scot %p our)/indexer/(scot %da now)
        %+  weld  ?.  newest  /  /newest
        /from/0x0/(scot %ux address)/noun
    ==
  ?~  txn-history  ~
  ?.  ?=(%txn -.txn-history)  ~
  %-  ~(urn by txns.txn-history)
  |=  [hash=@ux upd=[@ * txn=transaction:smart]]
  [txn.upd(status (add 200 `@`status.txn.upd)) [%noun calldata.txn.upd]]
::
++  watch-for-batches
  |=  [our=@p town=@ux]
  ^-  (list card)
  =-  [%pass /new-batch %agent [our %uqbar] %watch -]~
  /indexer/wallet/batch-order/(scot %ux town)
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
        [%unknown town.p.item.upd source.p.item.upd ~]
      ::  determine type token/nft/unknown
      (discover-asset-mold town.p.item.upd source.p.item.upd noun.p.item.upd)
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
      [%unknown town.p.item source.p.item ~]
    ::  determine type token/nft/unknown and store in book
    (discover-asset-mold town.p.item source.p.item noun.p.item)
  %=  $
    items-list  t.items-list
    new-book  (~(put by new-book) id.p.item asset)
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
      ::  (sub to indexer for the metadata item id, update our store on update)
      $(book t.book)
    ::  scry indexer for metadata item and store it
    ?~  meta=(fetch-metadata -.asset town.asset metadata.asset our now)
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
  |=  [token-type=@tas town=@ux =id:smart our=ship now=time]
  ^-  (unit asset-metadata)
  ::  manually import metadata for a token
  =/  scry-res
    .^(update:ui %gx /(scot %p our)/uqbar/(scot %da now)/indexer/newest/item/(scot %ux town)/(scot %ux id)/noun)
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
    %token  `[%token town ;;(token-metadata noun.p.u.g)]
    %nft    `[%nft town ;;(nft-metadata noun.p.u.g)]
  ==
::
++  get-tracked-account-sent-txs
  |=  [accounts=(list @ux) our=@p now=@da]
  ^-  (map @ux (list [@ux transaction:smart supported-actions]))
  =|  sents=(map @ux (list [@ux transaction:smart supported-actions]))
  |-
  ?~  accounts  sents
  =*  account   i.accounts
  =*  rest      t.accounts
  =/  sent=(map @ux [transaction:smart supported-actions])
    (get-sent-history account %.y our now)
  %=  $
      accounts  rest
      sents     (~(put by sents) account ~(tap by sent))
  ==
::
++  make-cards-update-state-tracked-accounts
  |=  [=transaction-store our=@p now=@da]
  ^-  [(list card) ^transaction-store]
  =/  accounts=(list @ux)  ~(tap in ~(key by transaction-store))
  =/  txs=(map @ux (list [@ux transaction:smart supported-actions]))
    (get-tracked-account-sent-txs accounts our now)
  =^  cardss=(list (list card))  transaction-store
    %^  spin  ~(tap by txs)  transaction-store
    |=  [[account-id=@ux account-txs=(list [tx-id=@ux txn=transaction:smart action=supported-actions])] txs=^transaction-store]
    =|  account-cards=(list card)
    =/  old-account-txs
      (~(gut by txs) account-id [sent=~ received=~])
    =/  processed-account-txs=(map @ux [txn=transaction:smart action=supported-actions])
      sent.old-account-txs
    |-
    ?~   account-txs
      :-  account-cards
      %+  ~(put by txs)  account-id
      %=  old-account-txs
          sent
        (~(uni by sent.old-account-txs) processed-account-txs)
      ==
    =*  tx-id   tx-id.i.account-txs
    =*  txn     txn.i.account-txs
    =*  action  action.i.account-txs
    %=  $
        account-txs  t.account-txs
        processed-account-txs
      ?.  (~(has by processed-account-txs) tx-id)
        processed-account-txs
      (~(put by processed-account-txs) tx-id [txn action])
    ::
        account-cards
      :_  account-cards
      ?~  this-tx=(~(get by processed-account-txs) tx-id)
        %^  tx-update-card   tx-id
          txn(status (sub status.txn 200))
        [%noun (crip (noah !>(calldata.txn)))]
      (tx-update-card tx-id txn action.u.this-tx)
    ==
  [(zing cardss) transaction-store]
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
        ['town' [%s (scot %ux town.asset)]]
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
        ['town' [%s (scot %ux town.m)]]
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
        ['town' [%s (scot %ux town.t)]]
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
