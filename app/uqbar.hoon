::  uqbar [UQ| DAO]
::
::  The "vane" for interacting with UQ|. Provides read/write layer for userspace agents.
::
/-  ui=indexer
/+  *uqbar, *sequencer, default-agent, dbug, verb, agentio
|%
+$  card  card:agent:gall
+$  state-0
  $:  %0
      min-ping-time=@dr
      max-ping-time=@dr
      next-ping-time=@da
      sources=(jar id:smart ship)  ::  priority-ordered list of indexers for each town
      sequencers=(map id:smart sequencer)  ::  single sequencer for each town
  ==
--
::
=|  state-0
=*  state  -
::
%-  agent:dbug
%+  verb  |
^-  agent:gall
=<
  |_  =bowl:gall
  +*  this        .
      def         ~(. (default-agent this %|) bowl)
      io          ~(. agentio bowl)
      uqbar-core  +>
      uc          ~(. uqbar-core bowl)
  ::
  ++  on-init
    ^-  (quip card _this)
    =.  min-ping-time   ~m15  ::  TODO: allow user to set?
    =.  max-ping-time   ~h2   ::   Spam risk?
    =.  next-ping-time  make-next-ping-time:uc
    :_  this
    [make-ping-wait-card:uc]~
  ::
  ++  on-save  !>(state)
  ++  on-load
    |=  =old=vase
    ^-  (quip card _this)
    =.  state  !<(state-0 old-vase)
    :_  this
    ?:  (lth next-ping-time now.bowl)  ~
    =.  next-ping-time  make-next-ping-time:uc  ::  TODO: does this work with `:_  this` above?
    [make-ping-wait-card:uc]~
  ::
  ++  on-watch
    |=  =path
    |^  ^-  (quip card _this)
    ?>  =(src.bowl our.bowl)
    :_  this
    ?+    -.path  !!
        %track
      ~
    ::
        %indexer
      ::  must be of the form, e.g.,
      ::   /indexer/grain/[town-id]/[grain-id]
      ?.  ?=([%indexer @ @ @ ~] path)  ~
      =/  town-id=id:smart  (slav %ux i.t.t.path)
      (watch-indexer town-id /[i.path] t.path)
    ==
    ::
    ++  watch-indexer  ::  TODO: ping indexers and find responsive one?
      |=  [town-id=id:smart wire-prefix=wire sub-path=^path]
      ^-  (list card)
      ?~  town-source=(~(get ja sources) town-id)  ~
      :_  ~
      %+  ~(watch pass:io (weld wire-prefix sub-path))
      [i.town-source %indexer]  sub-path
    --
  ::
  ++  on-poke
    |=  [=mark =vase]
    ^-  (quip card _this)
    |^
    ?>  =(src.bowl our.bowl)
    ?.  ?=(?(%uqbar-action %uqbar-write) mark)
      ~|("%uqbar: rejecting erroneous poke" !!)
    =^  cards  state
      ?-  mark
        %uqbar-action  (handle-action !<(action vase))
        %uqbar-write   (handle-write !<(write vase))
      ==
    [cards this]
    ::
    ++  handle-action
      |=  act=action
      ^-  (quip card _state)
      ?-    -.act
          %set-sources
        =/  pa  /capitol-updates
        :_  state(sources (~(gas by *(map id:smart (list ship))) towns.act))
        %+  murn  towns.act
        |=  [town=id:smart indexers=(list ship)]
        ^-  (unit card)
        ?~  indexers  ~
        `(~(watch pass:io pa) [i.indexers %indexer] pa)
      ::
          %add-source
        :-  ~
        %=  state
            sources
          ?~  town-source=(~(get ja sources) town-id.act)
            (~(add ja sources) town-id.act ship.act)
          ?^  index=(find [ship.act]~ town-source)
            sources
          (~(put by sources) town-id.act [ship.act]~)
        ==
      ::
          %remove-source
        :-  ~
        %=  state
            sources
          ?~  town-source=(~(get ja sources) town-id.act)  !!
          ?~  index=(find [ship.act]~ town-source)         !!
          %+  ~(put by sources)  town-id.act
          (oust [u.index 1] `(list ship)`town-source)
        ==
      ==
    ::
    ++  handle-write
      |=  =write
      ^-  (quip card _state)
      ?-    -.write
      ::
      ::  Each write can optionally create a subscription, which will forward these things:
      ::
      ::  - a "receipt" from sequencer, which contains a signed hash of the egg
      ::    (signed by both urbit ID and uqbar address -- enforcing that reputational link)
      ::
      ::  - once the egg gets submitted in batch to rollup, a card with the status/errorcode
      ::
      ::  - a card containing the new nonce of the address submitting the egg
      ::    (apps can ignore and track on their own, or use this)
      ::
      ::  To enable status update, uqbar.hoon should subscribe to indexer for that egg
      ::  and unsub when either status is received, or batch is rejected. (TODO how to determine latter?)
      ::
          %submit
        =/  town-id  `@ux`town-id.shell.egg.write
        ?~  seq=(~(get by sequencers.state) town-id)
          ~|("%uqbar: no known sequencer for that town" !!)
        =/  egg-hash  (scot %ux `@ux`(sham [shell yolk]:egg.write))
        :_  state
        =+  [%sequencer-town-action !>([%receive (silt ~[egg.write])])]
        :~  [%pass /submit-transaction/egg-hash %agent [q.u.seq %sequencer] %poke -]
            [%give %fact ~[/track/egg-hash] %write-result !>([%sent ~])]
        ==
      ::
          %receipt
        ::  forward to local watchers
        :_  state
        ~[[%give %fact ~[/track/(scot %ux egg-hash.write)] %write-result !>(write)]]
      ==
    --
  ::
  ++  on-agent
    |=  [=wire =sign:agent:gall]
    |^  ^-  (quip card _this)
    ?+    -.wire  (on-agent:def wire sign)
        %capitol-updates
      ::  set sequencers based on rollup state, given by indexer
      ?+    -.sign  (on-agent:def wire sign)
          %kick
        [rejoin this]
      ::
          %fact
        =^  cards  state
          (update-sequencers !<(capitol-update q.cage.sign))
        [cards this]
      ==
    ::
        %indexer
      ?+  -.sign  (on-agent:def wire sign)
        %kick  [rejoin this]
        %fact  [[(pass-through cage.sign)]~ this]
      ==
    ::
        %submit-transaction
      ::  get receipt from sequencer
      ?.  ?=([@ ~] t.wire)      `this
      ?.  ?=(%poke-ack -.sign)  `this
      =/  path  ~[/track/[i.t.wire]]
      :_  this
      ?~  p.sign  ~
      [%give %fact path %write-result !>(`write-result`[%rejected src.bowl])]~
    ==
    ::
    ++  pass-through
      |=  =cage
      ^-  card
      (fact:io cage ~[wire])
    ::
    ++  rejoin  ::  TODO: ping indexers and find responsive one?
      ^-  (list card)
      =/  old-source=(unit [dock path])  get-wex-dock-by-wire
      ?~  old-source  ~
      ~[(~(watch pass:io wire) u.old-source)]
    ::
    ++  get-wex-dock-by-wire
      ^-  (unit [dock path])
      ?:  =(0 ~(wyt by wex.bowl))  ~
      =/  wexs=(list [[w=^wire s=ship t=term] a=? p=path])
        ~(tap by wex.bowl)
      |-
      ?~  wexs  ~
      =*  wex  i.wexs
      ?.  =(wire w.wex)  $(wexs t.wexs)
      `[[s.wex t.wex] p.wex]
    ::
    ++  update-sequencers
      |=  upd=capitol-update
      ^-  (quip card _state)
      :-  ~
      %=    state
          sequencers
        %-  ~(run by capitol.upd)
        |=(=hall sequencer.hall)
      ==
    --
  ::
  ++  on-arvo
    |=  [=wire =sign-arvo:agent:gall]
    ^-  (quip card _this)
    ?+    wire  (on-arvo:def wire sign-arvo)
        [%indexer-ping @ ~]
      ?+    sign-arvo  (on-arvo:def wire sign-arvo)
          [%behn %wake error=@]
        =/  until=@da  (slav %da i.t.wire)
        ?:  (gth until now.bowl)  `this
        ?^  error
          ~&  >>>  "%uqbar: error from ping timer: {<u.error>}"
          `this
        ~&  >  "%uqbar: +on-arvo: got %behn %wake"
        ::  TODO: do stuff:
        ::   * ping indexers
        ::   * update a list about which are most recently seen to be
        ::     online
        ::   * move current subscriptions if on non-replying indexer?
        =.  next-ping-time  make-next-ping-time:uc
        :_  this
        [make-ping-wait-card:uc]~
      ==
    ==
  ::
  ++  on-peek
    |=  =path
    ^-  (unit (unit cage))
    ::  all scrys should return a unit
    ::
    ::  TODO: revisit this when remote scry is a thing..
    ::
    ?.  =(%x -.path)  ~
    ?+    +.path  (on-peek:def path)
        ::  TODO: scry contract interface/data from sequencer?
        ::  TODO: scry wallet?
        [%indexer *]
      :^  ~  ~  %noun
      !>  ^-  update:ui
      .^(update:ui %gx (scry:io %indexer (snoc t.t.path %noun)))
    ==
  ::
  ++  on-leave  on-leave:def
  ++  on-fail   on-fail:def
  --
::
|_  =bowl:gall
+*  io          ~(. agentio bowl)
::
++  make-ping-wait-card
  ^-  card
  %.  next-ping-time
  ~(wait pass:io /indexer-ping/(scot %da next-ping-time))
::
++  make-next-ping-time
  ^-  @da
  %+  add  now.bowl
  %+  add  min-ping-time
  %-  ~(rad og eny.bowl)
  (sub max-ping-time min-ping-time)
::
++  roll-without-replacement
  |=  [max=@ud seen=(list @ud)]
  ^-  [@ud (list @ud)]
  =/  number-seen=@ud  (lent seen)
  =/  roll=@ud  (~(rad og eny.bowl) (sub max number-seen))
  =|  index=@ud
  |-
  ?:  |(=(number-seen index) (lth roll (snag index seen)))
    =.  roll  (add roll index)
    [roll (into seen index roll)]
  $(index +(index))
--
