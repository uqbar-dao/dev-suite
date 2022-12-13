/-  eng=zig-engine,
    seq=zig-sequencer,
    ui=zig-indexer
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
  =/  jold-result
    %-  mule
    |.
    (jold-full-tuple-to-object:jold u.interface-type noun)
  ?:  ?=(%& -.jold-result)  p.jold-result
  [%s (crip (noah !>(noun)))]
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
    ?~  update                     ~
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
        %transaction
      (frond %transaction (transactions transactions.update))
    ::
        %item
      (frond %item (items items.update))
    ::
        %hash
      %+  frond  %hash
      %-  pairs
      :^    [%batches (batches batches.update)]
          [%transactions (transactions transactions.update)]
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
        %newest-transaction
      (frond %newest-transaction (newest-transaction +.update))
    ::
        %newest-item
      (frond %newest-item (newest-item +.update))
    ==
  ::
  ++  town-location
    |=  =town-location:ui
    ^-  json
    %-  pairs
    :-  [%town-id %s (scot %ux town-location)]
    ~
  ::
  ++  batch-location
    |=  =batch-location:ui
    ^-  json
    %-  pairs
    :+  [%town-id %s (scot %ux town-id.batch-location)]
      [%batch-id %s (scot %ux batch-id.batch-location)]
    ~
  ::
  ++  transaction-location
    |=  location=transaction-location:ui
    ^-  json
    %-  pairs
    :^    [%town-id %s (scot %ux town-id.location)]
        [%batch-id %s (scot %ux batch-id.location)]
      [%transaction-num [%s (scot %ud transaction-num.location)]]
    ~
  ::
  ++  batches
    |=  batches=(map batch-id=id:smart batch-update-value:ui)
    ^-  json
    %-  pairs
    %+  turn  ~(tap by batches)
    |=  [=id:smart timestamp=@da location=town-location:ui b=batch:ui]
    :-  (scot %ux id)
    %-  pairs
    :^    [%timestamp (sect timestamp)]
        [%location (town-location location)]
      [%batch (batch b)]
    ~
  ::
  ++  newest-batch
    |=  [=id:smart timestamp=@da location=town-location:ui b=batch:ui]
    ^-  json
    %-  pairs
    :-  [%batch-id %s (scot %ux id)]
    :^    [%timestamp (sect timestamp)]
        [%location (town-location location)]
      [%batch (batch b)]
    ~
  ::
  ++  batch
    |=  =batch:ui
    ^-  json
    %-  pairs
    :+  [%transactions (processed-txs transactions.batch)]
      [%town (town +.batch)]
    ~
  ::
  ++  processed-txs
    |=  =processed-txs:eng
    ^-  json
    :-  %a
    %+  turn  processed-txs
    |=  [hash=@ux t=transaction:smart o=output:eng]
    %-  pairs
    :^    [%hash %s (scot %ux hash)]
        [%transaction (transaction t)]
      [%output (output o)]
    ~
  ::
  ++  transactions
    |=  transactions=(map transaction-id=id:smart transaction-update-value:ui)
    ^-  json
    %-  pairs
    %+  turn  ~(tap by transactions)
    |=  $:  =id:smart
            timestamp=@da
            location=transaction-location:ui
            t=transaction:smart
            o=output:eng
        ==
    :-  (scot %ux id)
    %-  pairs
    :~  [%timestamp (sect timestamp)]
        [%location (transaction-location location)]
        [%transaction (transaction t)]
        [%output (output o)]
    ==
  ::
  ++  newest-transaction
    |=  $:  =id:smart
            timestamp=@da
            location=transaction-location:ui
            t=transaction:smart
            o=output:eng
        ==
    ^-  json
    %-  pairs
    :~  [%transaction-id %s (scot %ux id)]
        [%timestamp (sect timestamp)]
        [%location (transaction-location location)]
        [%transaction (transaction t)]
        [%output (output o)]
    ==
  ::
  ++  transaction
    |=  =transaction:smart
    ^-  json
    %-  pairs
    :^    [%sig (sig sig.transaction)]
        [%shell (shell +.+.transaction)]
      [%calldata (calldata [calldata contract]:transaction)]
    ~
  ::
  ++  output
    |=  =output:eng
    ^-  json
    %-  pairs
    :~  [%gas [%s (scot %ud gas.output)]]
        [%errorcode [%s (scot %ud errorcode.output)]]
        :: [%errorcode %s errorcode.output]
        [%modified (state modified.output)]
        [%burned (state burned.output)]
        [%events (events events.output)]
    ==
  ::
  ++  events
    |=  events=(list contract-event:eng)
    ^-  json
    :-  %a
    %+  turn  events
    |=  e=contract-event:eng
    (event e)
  ::
  ++  event
    |=  event=contract-event:eng
    ^-  json
    %-  pairs
    :^    [%contract %s (scot %ux contract.event)]
        [%label %s label.event]
      [%json json.event]
    ~
  ::
  ++  shell
    |=  =shell:smart
    ^-  json
    %-  pairs
    :~  [%caller (caller caller.shell)]
        [%eth-hash (eth-hash eth-hash.shell)]
        [%contract %s (scot %ux contract.shell)]
        [%rate [%s (scot %ud rate.gas.shell)]]
        [%budget [%s (scot %ud bud.gas.shell)]]
        [%town-id %s (scot %ux town.shell)]
        [%status [%s (scot %ud status.shell)]]
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
        [%nonce [%s (scot %ud nonce.caller)]]
      [%zigs %s (scot %ux zigs.caller)]
    ~
  ::
  :: ++  signature
  ::   |=  =signature:zig
  ::   ^-  json
  ::   %-  pairs
  ::   :^    [%hash %s (scot %ux p.signature)]
  ::       [%ship %s (scot %p q.signature)]
  ::     [%life [%s (scot %ud r.signature)]]
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
            [%salt [%s (scot %ud salt.p.item)]]
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
          [%cont [%s (scot %ud 0)]]
          [%interface (tas-to-json interface.p.item)]
          [%types (tas-to-json types.p.item)]
      ==
    :~  [%id %s (scot %ux id.p.item)]
        [%source %s (scot %ux source.p.item)]
        [%holder %s (scot %ux holder.p.item)]
        [%town %s (scot %ux town.p.item)]
    ==
  ::
  ++  town
    |=  =town:seq
    ^-  json
    %-  pairs
    :+  [%chain (chain chain.town)]
      [%hall (hall hall.town)]
    ~
  ::
  ++  chain
    |=  =chain:eng
    ^-  json
    %-  pairs
    :+  [%state (state p.chain)]
      [%nonces (nonces q.chain)]
    ~
  ::
  ++  state
    |=  =state:eng
    ^-  json
    %-  pairs
    %+  turn  ~(tap by state)
    ::  TODO: either print Pedersen hash or don't store it
    |=  [=id:smart pedersen=@ux i=item:smart]
    [(scot %ux id) (item i)]
  ::
  ++  nonces
    |=  =nonces:seq
    ^-  json
    %-  pairs
    %+  turn  ~(tap by nonces)
    ::  TODO: either print Pedersen hash or don't store it
    |=  [=id:smart pedersen=@ux nonce=@ud]
    [(scot %ux id) [%s (scot %ud nonce)]]
  ::
  ++  hall
    |=  =hall:seq
    ^-  json
    %-  pairs
    :~  [%town-id %s (scot %ux town-id.hall)]
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
    :^    [%v [%s (scot %ud v.sig)]]
        [%r [%s (scot %ud r.sig)]]
      [%s [%s (scot %ud s.sig)]]
    ~
  ::
  ++  batch-order
    |=  =batch-order:ui
    ^-  json
    :-  %a
    %+  turn  batch-order
    |=  batch-id=id:smart
    [%s (scot %ux batch-id)]
  ::
  ++  tas-to-json
    |=  mapping=(map @tas json)
    ^-  json
    ?:(=(0 ~(wyt by mapping)) ~ [%o mapping])
  --
::  ++  dejs  ::  see https://github.com/uqbar-dao/ziggurat/blob/d395f3bb8100ddbfad10c38cd8e7606545e164d3/lib/indexer.hoon#L295
--
