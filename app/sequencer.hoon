::  sequencer [UQ| DAO]
::
::  Agent for managing a single UQ| town. Publishes diffs to rollup.hoon
::  Accepts transactions and batches them periodically as moves to town.
::
/-  uqbar=zig-uqbar, w=zig-wallet
/+  default-agent, dbug, verb,
    *zig-sequencer, *zig-rollup,
    zink=zink-zink, sig=zig-sig,
    engine=zig-sys-engine
::  Choose which library smart contracts are executed against here
::
/*  smart-lib-noun  %noun  /lib/zig/sys/smart-lib/noun
/*  zink-cax-noun   %noun  /lib/zig/sys/hash-cache/noun
|%
+$  card  card:agent:gall
+$  state-0
  $:  %0
      rollup=(unit ship)  ::  replace in future with ETH/starknet contract address
      private-key=(unit @ux)
      town=(unit town)  ::  state
      =mempool
      peer-roots=(map town=@ux root=@ux)  ::  track updates from rollup
      proposed-batch=(unit [num=@ud =processed-txs =chain diff-hash=@ux root=@ux])
      status=?(%available %off)
  ==
+$  inflated-state-0  [state-0 =eng smart-lib-vase=vase]
+$  eng  $_  ~(engine engine !>(0) *(map * @) %.y %.n)  ::  sigs on, hints off
--
::
=|  inflated-state-0
=*  state  -
%-  agent:dbug
%+  verb  |
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
::
++  on-init
  =/  smart-lib=vase  ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
  =-  `this(state [[%0 ~ ~ ~ ~ ~ ~ %off] - smart-lib])
  %~  engine  engine
    ::  sigs on, hints off
  [smart-lib ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun))) %.y %.n]
::
++  on-save  !>(-.state)
++  on-load
  |=  =old=vase
  ::  on-load: pre-cue our compiled smart contract library
  =/  smart-lib=vase  ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
  =/  eng
    %~  engine  engine
      ::  sigs on, hints off
    [smart-lib ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun))) %.y %.n]
  `this(state [!<(state-0 old-vase) eng smart-lib])
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?.  ?=([%indexer %updates ~] path)
    ~|("%sequencer: rejecting %watch on bad path" !!)
  ::  handle indexer watches here -- send nothing
  `this
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^
  ?.  ?=(%sequencer-town-action mark)
    ~|("%sequencer: error: got erroneous %poke" !!)
  =^  cards  state
    (handle-poke !<(town-action vase))
  [cards this]
  ::
  ++  handle-poke
    |=  act=town-action
    ^-  (quip card _state)
    ?-    -.act
    ::
    ::  town administration
    ::
        %init
      ?>  =(src.bowl our.bowl)
      ?.  =(%off status.state)
        ~|("%sequencer: already active" !!)
      ::  poke rollup ship with params of new town
      ::  (will be rejected if id is taken)
      =/  =chain  ?~(starting-state.act [~ ~] u.starting-state.act)
      =/  new-root  `@ux`(sham chain)
      =/  =^town
        :-  chain
        :*  town-id.act
            batch-num=0
            [address.act our.bowl]
            mode.act
            0x0
            ~
        ==
      =/  sig
        (ecdsa-raw-sign:secp256k1:secp:crypto `@uvI`new-root private-key.act)
      :_  %=  state
            rollup       `rollup-host.act
            private-key  `private-key.act
            town         `town
            status        %available
            proposed-batch  `[0 ~ chain.town 0x0 new-root]
          ==
      :~  [%pass /sub-rollup %agent [rollup-host.act %rollup] %watch /peer-root-updates]
          =+  [%rollup-action !>([%launch-town address.act sig town])]
          [%pass /batch-submit/(scot %ux new-root) %agent [rollup-host.act %rollup] %poke -]
      ==
    ::
        %clear-state
      ?>  =(src.bowl our.bowl)
      ~&  >>  "sequencer: wiping state"
      `state(rollup ~, private-key ~, town ~, mempool ~, peer-roots ~, status %off)
    ::
    ::  handle bridged assets from rollup
    ::
        %receive-assets
      ::  uncritically absorb assets bridged from rollup
      ?>  =(src.bowl (need rollup.state))
      ?.  =(%available status.state)
        ~|("%sequencer: error: got asset while not active" !!)
      ?~  town.state  !!
      ~&  >>  "%sequencer: received assets from rollup: {<assets.act>}"
      `state(town `u.town(p.chain (uni:big:engine p.chain.u.town.state assets.act)))
    ::
    ::  transactions
    ::
        %receive
      ?.  =(%available status.state)
        ~|("%sequencer: error: got transaction while not active" !!)
      =/  received=^mempool
        %-  ~(run in txs.act)
        |=  t=transaction:smart
        [`@ux`(sham +.t) t]
      ::  give a "receipt" to sender, with signature they can show
      ::  a counterparty for "business finality"
      :_  state(mempool (~(uni in mempool) received))
      %+  turn  ~(tap in received)
      |=  [hash=@ux =transaction:smart]
      ^-  card
      =/  usig  (ecdsa-raw-sign:secp256k1:secp:crypto `@uvI`hash (need private-key.state))
      =+  [%uqbar-write !>(`write:uqbar`[%receipt hash (sign:sig our.bowl now.bowl hash) usig])]
      [%pass /submit-transaction/(scot %ux hash) %agent [src.bowl %uqbar] %poke -]
    ::
    ::  batching
    ::
        %trigger-batch
      ?>  =(src.bowl our.bowl)
      ::  fetch latest ETH block height and perform batch
      =/  tid  `@ta`(cat 3 'thread_' (scot %uv (sham eny.bowl)))
      =/  ta-now  `@ta`(scot %da now.bowl)
      =/  start-args  [~ `tid byk.bowl(r da+now.bowl) %sequencer-get-block-height !>(~)]
      :_  state
      :~
        [%pass /thread/[ta-now] %agent [our.bowl %spider] %watch /thread-result/[tid]]
        [%pass /thread/[ta-now] %agent [our.bowl %spider] %poke %spider-start !>(start-args)]
      ==
    ::
        %perform-batch
      ?>  =(src.bowl our.bowl)
      ?.  =(%available status.state)
        ~|("%sequencer: error: got poke while not active" !!)
      ?~  town.state
        ~|("%sequencer: error: no state" !!)
      ?~  rollup.state
        ~|("%sequencer: error: no known rollup host" !!)
      ?~  mempool.state
        ~|("%sequencer: no transactions to include in batch" !!)
      =*  town  u.town.state
      ?:  ?=(%committee -.mode.hall.town)
        ::  TODO data-availability committee
        ::
        ~|("%sequencer: error: DAC not implemented" !!)
      ::  publish full diff data
      ::
      ::  1. produce diff and new state with engine
      =/  batch-num  batch-num.hall.town
      =/  addr  p.sequencer.hall.town
      =/  =wallet-update:w
        .^  wallet-update:w  %gx
            %+  weld  /(scot %p our.bowl)/wallet/(scot %da now.bowl)
            /account/(scot %ux addr)/(scot %ux town-id.hall.town)/noun
        ==
      ?>  ?=(%account -.wallet-update)
      =/  new=state-transition
        %+  ~(run eng caller.wallet-update town-id.hall.town batch-num eth-block-height.act)
        chain.town  mempool.state
      =/  new-root       `@ux`(sham chain.new)
      =/  diff-hash      `@ux`(sham ~[modified.new])
      =/  new-batch-num  +(batch-num.hall.town)
      ::  2. generate our signature
      ::  (address sig, that is)
      ?~  private-key.state
        ~|("%sequencer: error: no signing key found" !!)
      =/  sig
        (ecdsa-raw-sign:secp256k1:secp:crypto `@uvI`new-root u.private-key.state)
      ::  3. poke rollup
      :_  %=  state
            proposed-batch  `[new-batch-num processed.new chain.new diff-hash new-root]
          ==
      =-  [%pass /batch-submit/(scot %ux new-root) %agent [u.rollup.state %rollup] %poke -]~
      :-  %rollup-action
      !>  :-  %receive-batch
          :-  addr
          ^-  batch
          :*  town-id.hall.town
              new-batch-num
              mode.hall.town
              ~[modified.new]
              diff-hash
              new-root
              chain.new
              peer-roots.state
              sig
          ==
    ==
  --
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  |^
  ?+    wire  (on-agent:def wire sign)
      [%batch-submit @ ~]
    ?:  ?=(%poke-ack -.sign)
      ?~  p.sign
        ~&  >>  "%sequencer: batch approved by rollup"
        ?~  proposed-batch
          ~|("%sequencer: error: received batch approval without proposed batch" !!)
        =/  new-town=(unit ^town)
          (transition-state town u.proposed-batch)
        :_  this(town new-town, proposed-batch ~, mempool ~)
        =-  [%give %fact ~[/indexer/updates] %sequencer-indexer-update -]~
        =*  transactions  processed-txs.u.proposed-batch
        !>(`indexer-update`[%update root.u.proposed-batch transactions (need new-town)])
      ::  TODO manage rejected moves here
      ~&  >>>  "%sequencer: our move was rejected by rollup!"
      ~&  u.p.sign
      `this(proposed-batch ~)
    `this
  ::
      [%sub-rollup ~]
    ?:  ?=(%kick -.sign)
      :_  this  ::  attempt to re-sub
      [%pass wire %agent [src.bowl %rollup] %watch (snip `path`wire)]~
    ?.  ?=(%fact -.sign)  `this
    =^  cards  state
      (update-fact !<(town-update q.cage.sign))
    [cards this]
  ::
      [%thread @ ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      ?+    p.cage.sign  (on-agent:def wire sign)
          %thread-fail
        =/  err  !<  (pair term tang)  q.cage.sign
        %-  (slog leaf+"%sequencer: get-eth-block thread failed: {(trip p.err)}" q.err)
        `this
          %thread-done
        =/  height=@ud  !<(@ud q.cage.sign)
        ~&  >  "eth-block-height: {<height>}"
        :_  this
        =-  [%pass /perform %agent [our.bowl %sequencer] %poke -]~
        [%sequencer-town-action !>(`town-action`[%perform-batch height])]
      ==
    ==
  ::
  ==
  ::
  ++  update-fact
    |=  upd=town-update
    ^-  (quip card _state)
    ?-    -.upd
        %new-peer-root
      ::  update our local map
      `state(peer-roots (~(put by peer-roots.state) town.upd root.upd))
    ::
        %new-sequencer
      ::  check if we have been kicked off our town
      ::  this is in place for later..  TODO expand this functionality
      ?~  town.state                          `state
      ?.  =(town.upd town-id.hall.u.town)  `state
      ?:  =(who.upd our.bowl)                 `state
      ~&  >>>  "%sequencer: we've been kicked out of town!"
      `state
    ==
  --
::
++  on-arvo
  |=  [=wire =sign-arvo:agent:gall]
  ^-  (quip card _this)
  (on-arvo:def wire sign-arvo)
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?.  =(%x -.path)  ~
  ?+    +.path  (on-peek:def path)
      [%status ~]
    ``noun+!>(status)
  ::
      [%town-id ~]
    ?~  town  ``noun+!>(~)
    ``noun+!>(`town-id.hall.u.town)
  ::
      [%mempool-size ~]
    ::  returns number of transactions in mempool
    ``noun+!>(`@ud`~(wyt in mempool))
  ::
  ::  state reads fail if sequencer not active
  ::
      [%has @ ~]
    ::  see if grain exists in state
    =/  id  (slav %ux i.t.t.path)
    ?~  town  [~ ~]
    ``noun+!>((~(has by p.chain.u.town) id))
  ::
      [%all-data ~]
    ?~  town  [~ ~]
    =-  ``noun+!>(-)
    %+  murn  ~(tap in p.chain.u.town)
    |=  [=id:smart @ =item:smart]
    ?.  ?=(%& -.item)  ~
    `item
  ::
      [%get-action @ @ ~]
    ::  return lump interface from contract on-chain
    =/  id   (slav %ux i.t.t.path)
    =/  act  (slav %tas i.t.t.t.path)
    ?~  town  [~ ~]
    ?~  g=(get:big p.chain.u.town id)
      ::  contract not found in state
      ``noun+!>(~)
    ?.  ?=(%| -.u.g)
      ::  found ID isn't a contract
      ``noun+!>(~)
    ?~  action=(~(get by interface.p.u.g) act)
      ::  contract doesn't have lump for that action
      ``noun+!>(~)
    ``noun+!>(u.action)
  ::
      [%get-type @ @ ~]
    ::  return lump rice type from contract on-chain
    =/  id     (slav %ux i.t.t.path)
    =/  label  (slav %tas i.t.t.t.path)
    ?~  town  [~ ~]
    ?~  g=(get:big p.chain.u.town id)
      ::  contract not found in state
      ``noun+!>(~)
    ?.  ?=(%| -.u.g)
      ::  found ID isn't a contract
      ``noun+!>(~)
    ?~  typ=(~(get by types.p.u.g) label)
      ::  contract doesn't have lump for that rice label
      ``noun+!>(~)
    ``noun+!>(u.typ)
  ::
      [%grain @ ~]
    ?~  town  [~ ~]
    (read-grain t.path p.chain.u.town)
  ==
::
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--
