/-  ui=zig-indexer,
    seq=zig-sequencer
/+  jold=zig-jold,
    smart=zig-sys-smart
::
|_  =bowl:gall
++  get-interface-types-json
  |=  $:  contract-id=id:smart
          return=?(%interface %types)
          label=@tas
          noun=*
      ==
  |^  ^-  json
  ?:  =(*bowl:gall bowl)
    [%s (crip (noah !>(noun)))]
  =/  interface-types=(map @tas json)  get-interface-types
  ?~  interface-type=(~(get by interface-types) label)
    [%s (crip (noah !>(noun)))]
  (jold-full-tuple-to-object:jold u.interface-type noun)
  ::
  ++  get-interface-types
    ^-  (map @tas json)
    =/  =update:ui
      .^  update:ui
          %gx
          %-  zing
          :+  /(scot %p our.bowl)/indexer/(scot %da now.bowl)
            /newest/item/(scot %ux contract-id)/noun
          ~
      ==
    ?~  update                      ~
    ?.  ?=(%newest-item -.update)  ~
    =*  contract  item.update
    ?.  ?=(%| -.contract)  ~
    ?-  return
      %interface  interface.p.contract
      %types      types.p.contract
    ==
  --
::
++  enjs
  =,  enjs:format
  |%
  ++  update
    |=  =update:ui
    ^-  json
    ?~  update  ~
    ?-    -.update
        %path-does-not-exist
      (frond %path-does-not-exist ~)
    ::
        %batch
      (frond %batch (batches batches.update))
    ::
        %batch-order
      (frond %batch-order (batch-order batch-order.update))
    ::
        %txn
      (frond %txn (txns txns.update))
    ::
        %item
      (frond %item (items items.update))
    ::
        %hash
      %+  frond  %hash
      %-  pairs
      :^    [%batches (batches batches.update)]
          [%txns (txns txns.update)]
        [%items (items items.update)]
      ~
    ::
        %newest-batch
      (frond %newest-batch (newest-batch +.update))
    ::
        %newest-batch-order
      %+  frond  %newest-batch-order
      (frond %batch-id %s (scot %ux batch-id.update))
    ::
        %newest-txn
      (frond %newest-txn (newest-txn +.update))
    ::
        %newest-item
      (frond %newest-item (newest-item +.update))
    ==
  ::
  ++  shard-location
    |=  =shard-location:ui
    ^-  json
    %-  pairs
    :-  [%shard-id %s (scot %ux shard-location)]
    ~
  ::
  ++  batch-location
    |=  =batch-location:ui
    ^-  json
    %-  pairs
    :+  [%shard-id %s (scot %ux shard-id.batch-location)]
      [%batch-root %s (scot %ux batch-root.batch-location)]
    ~
  ::
  ++  txn-location
    |=  =txn-location:ui
    ^-  json
    %-  pairs
    :^    [%shard-id %s (scot %ux shard-id.txn-location)]
        [%batch-root %s (scot %ux batch-root.txn-location)]
      [%txn-num (numb txn-num.txn-location)]
    ~
  ::
  ++  batches
    |=  batches=(map batch-id=id:smart [@da shard-location:ui batch:ui])
    ^-  json
    %-  pairs
    %+  turn  ~(tap by batches)
    |=  [=id:smart timestamp=@da location=shard-location:ui b=batch:ui]
    :-  (scot %ux id)
    %-  pairs
    :^    [%timestamp (sect timestamp)]
        [%location (shard-location location)]
      [%batch (batch b)]
    ~
  ::
  ++  newest-batch
    |=  [=id:smart timestamp=@da location=shard-location:ui b=batch:ui]
    ^-  json
    %-  pairs
    :-  [%batch-id %s (scot %ux id)]
    :^    [%timestamp (sect timestamp)]
        [%location (shard-location location)]
      [%batch (batch b)]
    ~
  ::
  ++  batch
    |=  =batch:ui
    ^-  json
    %-  pairs
    :+  [%transactions (transactions transactions.batch)]
      [%shard (shard +.batch)]
    ~
  ::
  ++  transactions
    |=  transactions=(list [@ux transaction:smart])
    ^-  json
    :-  %a
    %+  turn  transactions
    |=  [hash=@ux e=transaction:smart]
    %-  pairs
    :+  [%hash %s (scot %ux hash)]
      [%txn (txn e)]
    ~
  ::
  ++  txns
    |=  txns=(map txn-id=id:smart [@da location=txn-location:ui =transaction:smart])
    ^-  json
    %-  pairs
    %+  turn  ~(tap by txns)
    |=  [=id:smart timestamp=@da location=txn-location:ui e=transaction:smart]
    :-  (scot %ux id)
    %-  pairs
    :^    [%timestamp (sect timestamp)]
        [%location (txn-location location)]
      [%txn (txn e)]
    ~
  ::
  ++  newest-txn
    |=  [=id:smart timestamp=@da location=txn-location:ui e=transaction:smart]
    ^-  json
    %-  pairs
    :-  [%txn-id %s (scot %ux id)]
    :^    [%timestamp (sect timestamp)]
        [%location (txn-location location)]
      [%txn (txn e)]
    ~
  ::
  ++  txn
    |=  txn=transaction:smart
    ^-  json
    %-  pairs
    :^    [%sig (sig sig.txn)]
        [%shell (shell +.+.txn)]
      [%calldata (calldata calldata.txn contract.txn)]
    ~
  ::
  ++  shell
    |=  =shell:smart
    ^-  json
    %-  pairs
    :~  [%caller (caller caller.shell)]
        [%eth-hash (eth-hash eth-hash.shell)]
        [%contract %s (scot %ux contract.shell)]
        [%rate (numb rate.gas.shell)]
        [%budget (numb bud.gas.shell)]
        [%shard-id %s (scot %ux shard.shell)]
        [%status (numb status.shell)]
    ==
  ::
  ++  calldata
    |=  [=calldata:smart contract-id=id:smart]
    ^-  json
    %+  frond  p.calldata
    (get-interface-types-json contract-id %interface calldata)
  ::
  ++  caller
    |=  =caller:smart
    ^-  json
    %-  pairs
    :^    [%id %s (scot %ux address.caller)]
        [%nonce (numb nonce.caller)]
      [%zigs %s (scot %ux zigs.caller)]
    ~
  ::
  :: ++  signature
  ::   |=  =signature:zig
  ::   ^-  json
  ::   %-  pairs
  ::   :^    [%hash %s (scot %ux p.signature)]
  ::       [%ship %s (scot %p q.signature)]
  ::     [%life (numb r.signature)]
  ::   ~
  ::
  ++  eth-hash
    |=  eth-hash=(unit @ux)
    ^-  json
    ?~  eth-hash  ~
    [%s (scot %ux u.eth-hash)]
  ::
  ++  ids
    |=  ids=(set id:smart)
    ^-  json
    :-  %a
    %+  turn  ~(tap in ids)
    |=  =id:smart
    [%s (scot %ux id)]
  ::
  ++  items
    |=  items=(jar item-id=id:smart [@da location=batch-location:ui =item:smart])
    ^-  json
    %-  pairs
    %+  turn  ~(tap by items)
    |=  [=id:smart gs=(list [@da batch-location:ui item:smart])]
    :+  (scot %ux id)
      %a
    %+  turn  gs
    |=  [timestamp=@da location=batch-location:ui g=item:smart]
    %-  pairs
    :^    [%timestamp (sect timestamp)]
        [%location (batch-location location)]
      [%item (item g)]
    ~
  ::
  ++  newest-item
    |=  [=id:smart timestamp=@da location=batch-location:ui g=item:smart]
    ^-  json
    %-  pairs
    :-  [%item-id %s (scot %ux id)]
    :^    [%timestamp (sect timestamp)]
        [%location (batch-location location)]
      [%item (item g)]
    ~
  ::
  ++  item
    |=  =item:smart
    ^-  json
    %-  pairs
    %+  welp
      ?:  ?=(%& -.item)
        ::  data
        :~  [%is-data %b %&]
            [%salt (numb salt.p.item)]
            [%label %s `@ta`label.p.item]
            :-  %noun
            %+  frond  label.p.item
            %:  get-interface-types-json
                source.p.item
                %types
                label.p.item
                noun.p.item
            ==
        ==
      ::  wheat
      :~  [%is-data %b %|]
          [%cont (numb (jam code.p.item))]
          [%interface (tas-to-json interface.p.item)]
          [%types (tas-to-json types.p.item)]
      ==
    :~  [%id %s (scot %ux id.p.item)]
        [%source %s (scot %ux source.p.item)]
        [%holder %s (scot %ux holder.p.item)]
        [%shard %s (scot %ux shard.p.item)]
    ==
  ::
  ++  shard
    |=  =shard:seq
    ^-  json
    %-  pairs
    :+  [%chain (chain chain.shard)]
      [%hall (hall hall.shard)]
    ~
  ::
  ++  chain
    |=  =chain:seq
    ^-  json
    %-  pairs
    :+  [%state (state p.chain)]
      [%nonces (nonces q.chain)]
    ~
  ::
  ++  state
    |=  =state:seq
    ^-  json
    %-  pairs
    %+  turn  ~(tap by state)
    ::  TODO: either print Pedersen hash or don't store it
    |=  [=id:smart pedersen=@ux g=item:smart]
    [(scot %ux id) (item g)]
  ::
  ++  nonces
    |=  =nonces:seq
    ^-  json
    %-  pairs
    %+  turn  ~(tap by nonces)
    ::  TODO: either print Pedersen hash or don't store it
    |=  [=id:smart pedersen=@ux nonce=@ud]
    [(scot %ux id) (numb nonce)]
  ::
  ++  hall
    |=  =hall:seq
    ^-  json
    %-  pairs
    :~  [%shard-id %s (scot %ux shard-id.hall)]
        [%sequencer (sequencer sequencer.hall)]
        [%mode (mode mode.hall)]
        [%latest-diff-hash %s (scot %ux latest-diff-hash.hall)]
        [%roots (roots roots.hall)]
    ==
  ::
  ++  sequencer
    |=  =sequencer:seq
    ^-  json
    %-  pairs
    :+  [%address %s (scot %ux p.sequencer)]
      [%ship %s (scot %p q.sequencer)]
    ~
  ::
  ++  mode
    |=  mode=availability-method:seq
    ^-  json
    ?-    -.mode
        %full-publish
      [%s %full-publish]
    ::
        %committee
      (frond %committee (committee members.mode))
    ==
  ::
  ++  roots
    |=  roots=(list @ux)
    ^-  json
    :-  %a
    %+  turn  roots
    |=  root=@ux
    [%s (scot %ux root)]
  ::
  ++  committee
    |=  committee-members=(map @ux [@p (unit sig:smart)])
    ^-  json
    (frond %members (members committee-members))
  ::
  ++  members
    |=  members=(map @ux [@p (unit sig:smart)])
    ^-  json
    %-  pairs
    %+  turn  ~(tap by members)
    |=  [address=@ux s=@p signature=(unit sig:smart)]
    :-  (scot %ux address)
    %-  pairs
    :+  [%ship %s (scot %p s)]
      [%sig ?~(signature ~ (sig u.signature))]
    ~
  ::
  ++  sig
    |=  =sig:smart
    ^-  json
    %-  pairs
    :^    [%v (numb v.sig)]
        [%r (numb r.sig)]
      [%s (numb s.sig)]
    ~
  ::
  ++  batch-order
    |=  =batch-order:ui
    ^-  json
    :-  %a
    %+  turn  batch-order
    |=  batch-root=id:smart
    [%s (scot %ux batch-root)]
  ::
  ++  tas-to-json
    |=  mapping=(map @tas json)
    ^-  json
    ?:(=(0 ~(wyt by mapping)) ~ [%o mapping])
  --
::  ++  dejs  ::  see https://github.com/uqbar-dao/ziggurat/blob/d395f3bb8100ddbfad10c38cd8e7606545e164d3/lib/indexer.hoon#L295
--
