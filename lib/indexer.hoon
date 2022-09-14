/-  ui=indexer,
    seq=sequencer
/+  jold,
    smart=zig-sys-smart
::
|_  =bowl:gall
++  get-interface-types-json
  |=  $:  contract-id=id:smart
          return=?(%interface %types)
          label=@tas
          data=*
      ==
  |^  ^-  json
  ?:  =(*bowl:gall bowl)
    [%s (crip (noah !>(data)))]
  =/  interface-types=(map @tas json)  get-interface-types
  ?~  interface-type=(~(get by interface-types) label)
    [%s (crip (noah !>(data)))]
  (jold-full-tuple-to-object:jold u.interface-type data)
  ::
  ++  get-interface-types
    ^-  (map @tas json)
    =/  =update:ui
      .^  update:ui
          %gx
          %-  zing
          :+  /(scot %p our.bowl)/indexer/(scot %da now.bowl)
            /newest/grain/(scot %ux contract-id)/noun
          ~
      ==
    ?~  update                      ~
    ?.  ?=(%newest-grain -.update)  ~
    =*  contract  grain.update
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
        %egg
      (frond %egg (eggs eggs.update))
    ::
        %grain
      (frond %grain (grains grains.update))
    ::
        %hash
      %+  frond  %hash
      %-  pairs
      :^    [%batches (batches batches.update)]
          [%eggs (eggs eggs.update)]
        [%grains (grains grains.update)]
      ~
    ::
        %newest-batch
      (frond %newest-batch (newest-batch +.update))
    ::
        %newest-batch-order
      %+  frond  %newest-batch-order
      (frond %batch-id %s (scot %ux batch-id.update))
    ::
        %newest-egg
      (frond %newest-egg (newest-egg +.update))
    ::
        %newest-grain
      (frond %newest-grain (newest-grain +.update))
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
      [%batch-root %s (scot %ux batch-root.batch-location)]
    ~
  ::
  ++  egg-location
    |=  =egg-location:ui
    ^-  json
    %-  pairs
    :^    [%town-id %s (scot %ux town-id.egg-location)]
        [%batch-root %s (scot %ux batch-root.egg-location)]
      [%egg-num (numb egg-num.egg-location)]
    ~
  ::
  ++  batches
    |=  batches=(map batch-id=id:smart [@da town-location:ui batch:ui])
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
    :+  [%transactions (transactions transactions.batch)]
      [%town (town +.batch)]
    ~
  ::
  ++  transactions
    |=  transactions=(list [@ux egg:smart])
    ^-  json
    :-  %a
    %+  turn  transactions
    |=  [hash=@ux e=egg:smart]
    %-  pairs
    :+  [%hash %s (scot %ux hash)]
      [%egg (egg e)]
    ~
  ::
  ++  eggs
    |=  eggs=(map egg-id=id:smart [@da location=egg-location:ui =egg:smart])
    ^-  json
    %-  pairs
    %+  turn  ~(tap by eggs)
    |=  [=id:smart timestamp=@da location=egg-location:ui e=egg:smart]
    :-  (scot %ux id)
    %-  pairs
    :^    [%timestamp (sect timestamp)]
        [%location (egg-location location)]
      [%egg (egg e)]
    ~
  ::
  ++  newest-egg
    |=  [=id:smart timestamp=@da location=egg-location:ui e=egg:smart]
    ^-  json
    %-  pairs
    :-  [%egg-id %s (scot %ux id)]
    :^    [%timestamp (sect timestamp)]
        [%location (egg-location location)]
      [%egg (egg e)]
    ~
  ::
  ++  egg
    |=  =egg:smart
    ^-  json
    %-  pairs
    :^    [%sig (sig sig.egg)]
        [%shell (shell shell.egg)]
      [%yolk (yolk yolk.egg contract.shell.egg)]
    ~
  ::
  ++  shell
    |=  =shell:smart
    ^-  json
    %-  pairs
    :~  [%from (caller from.shell)]
        [%eth-hash (eth-hash eth-hash.shell)]
        [%contract %s (scot %ux contract.shell)]
        [%rate (numb rate.shell)]
        [%budget (numb budget.shell)]
        [%town-id %s (scot %ux town-id.shell)]
        [%status (numb status.shell)]
    ==
  ::
  ++  yolk
    |=  [=yolk:smart contract-id=id:smart]
    ^-  json
    %+  frond  p.yolk
    (get-interface-types-json contract-id %interface yolk)
  ::
  ++  caller
    |=  =caller:smart
    ^-  json
    %-  pairs
    :^    [%id %s (scot %ux id.caller)]
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
  ++  grains
    |=  grains=(jar grain-id=id:smart [@da location=batch-location:ui =grain:smart])
    ^-  json
    %-  pairs
    %+  turn  ~(tap by grains)
    |=  [=id:smart gs=(list [@da batch-location:ui grain:smart])]
    :+  (scot %ux id)
      %a
    %+  turn  gs
    |=  [timestamp=@da location=batch-location:ui g=grain:smart]
    %-  pairs
    :^    [%timestamp (sect timestamp)]
        [%location (batch-location location)]
      [%grain (grain g)]
    ~
  ::
  ++  newest-grain
    |=  [=id:smart timestamp=@da location=batch-location:ui g=grain:smart]
    ^-  json
    %-  pairs
    :-  [%grain-id %s (scot %ux id)]
    :^    [%timestamp (sect timestamp)]
        [%location (batch-location location)]
      [%grain (grain g)]
    ~
  ::
  ++  grain
    |=  =grain:smart
    ^-  json
    %-  pairs
    %+  welp
      ?:  ?=(%& -.grain)
        ::  rice
        :~  [%is-rice %b %&]
            [%salt (numb salt.p.grain)]
            [%label %s `@ta`label.p.grain]
            :-  %data
            %+  frond  label.p.grain
            %:  get-interface-types-json
                lord.p.grain
                %types
                label.p.grain
                data.p.grain
            ==
        ==
      ::  wheat
      :~  [%is-rice %b %|]
          [%cont (numb (jam cont.p.grain))]
          [%interface (tas-to-json interface.p.grain)]
          [%types (tas-to-json types.p.grain)]
      ==
    :~  [%id %s (scot %ux id.p.grain)]
        [%lord %s (scot %ux lord.p.grain)]
        [%holder %s (scot %ux holder.p.grain)]
        [%town-id %s (scot %ux town-id.p.grain)]
    ==
  ::
  ++  town
    |=  =town:seq
    ^-  json
    %-  pairs
    :+  [%land (land land.town)]
      [%hall (hall hall.town)]
    ~
  ::
  ++  land
    |=  =land:seq
    ^-  json
    %-  pairs
    :+  [%granary (granary p.land)]
      [%populace (populace q.land)]
    ~
  ::
  ++  granary
    |=  =granary:seq
    ^-  json
    %-  pairs
    %+  turn  ~(tap by granary)
    ::  TODO: either print Pedersen hash or don't store it
    |=  [=id:smart pedersen=@ux g=grain:smart]
    [(scot %ux id) (grain g)]
  ::
  ++  populace
    |=  =populace:seq
    ^-  json
    %-  pairs
    %+  turn  ~(tap by populace)
    ::  TODO: either print Pedersen hash or don't store it
    |=  [=id:smart pedersen=@ux nonce=@ud]
    [(scot %ux id) (numb nonce)]
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
