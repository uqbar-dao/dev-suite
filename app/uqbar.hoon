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
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    io    ~(. agentio bowl)
::
++  on-init  `this(state [%0 ~ ~])
++  on-save  !>(state)
++  on-load
  |=  =old=vase
  ^-  (quip card _this)
  `this(state !<(state-0 old-vase))
::
++  on-watch
  |=  =path
  |^  ^-  (quip card _this)
  ?>  =(src.bowl our.bowl)
  :_  this
  ?+    -.path  !!
      ?(%id %grain %holder %lord)
    ?.  ?=([@ @ @ ~] path)  ~
    =/  town=id:smart  (slav %ux i.t.path)
    ?~  card=(watch-indexer town ~ path)  ~
    ~[u.card]
  ::
      %scry
    ?.  ?=([@ @ @ @ ~] path)                      ~
    ?.  ?=(?(%id %grain %holder %lord) i.t.path)  ~
    =/  town=id:smart  (slav %ux i.t.t.path)
    ?~  card=(watch-indexer town /[i.path] path)  ~
    ~[u.card]
  ::
      %track
    ~
  ==
  ::
  ++  watch-indexer  ::  TODO: ping indexers and find responsive one?
    |=  [town=id:smart wire-prefix=wire sub-path=^path]
    ^-  (unit card)
    ?~  town-source=(~(get ja sources) town)  ~
    :-  ~
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
    ?:  ?=(%kick -.sign)
      :_  this  ::  attempt to re-sub
      [%pass wire %agent [src.bowl %rollup] %watch (snip `path`wire)]~
    ?.  ?=(%fact -.sign)  `this
    =^  cards  state
      (update-sequencers !<(capitol-update q.cage.sign))
    [cards this]
  ::
      ?(%id %grain %holder %lord)
    ?+    -.sign  (on-agent:def wire sign)
        %kick
      :_  this
      =/  agent-card=(unit card)  rejoin
      ?~(agent-card ~ ~[u.agent-card])
    ::
        %fact
      :_  this
      ~[(pass-through cage.sign)]
    ==
  ::
      %scry
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      :_  this
      =/  kick-card=(unit card)   kick
      =/  leave-card=(unit card)  leave
      ?~  kick-card
        ~&  >>>  "uqbar: failed to kick {<wire>}"
        ~[(pass-through cage.sign)]
      ?~  leave-card
        ~&  >>>  "uqbar: failed to leave {<wire>}"
        ~[(pass-through cage.sign)]
      ~[(pass-through cage.sign) u.kick-card u.leave-card]
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
  ++  get-sup-ship-by-wire
    ^-  (unit ship)
    ?:  =(0 ~(wyt by sup.bowl))  ~
    ?~  sup=(~(get by sup.bowl) ~[wire])  ~
    `p.u.sup
  ::
  ++  leave
    ^-  (unit card)
    =/  old-source=(unit dock)  get-wex-dock-by-wire
    ?~  old-source  ~
    `(~(leave pass:io wire) u.old-source)
  ::
  ++  kick
    ^-  (unit card)
    =/  kick-ship=(unit ship)  get-sup-ship-by-wire
    ?~  kick-ship  ~
    `(kick-only:io u.kick-ship ~[wire])
  ::
  ++  rejoin  ::  TODO: ping indexers and find responsive one?
    ^-  (unit card)
    =/  old-source=(unit dock)
      get-wex-dock-by-wire
    ?~  old-source  ~
    `(~(watch pass:io wire) u.old-source wire)
  ::
  ++  get-wex-dock-by-wire
    ^-  (unit dock)
    ?:  =(0 ~(wyt by wex.bowl))  ~
    =/  wexs=(list [w=^wire s=ship t=term])
      ~(tap in ~(key by wex.bowl))
    |-
    ?~  wexs  ~
    =*  wex  i.wexs
    ?.  =(wire w.wex)  $(wexs t.wexs)
    `[s.wex t.wex]
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
  (on-arvo:def wire sign-arvo)
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
      [%contract @ @ @tas @ta ^]
    ``noun+!>(~)
  ::
      [%grain @ @ ~]
    =/  town-id  (slav %ux i.t.t.path)
    =/  grain-id  (slav %ux i.t.t.t.path)
    ::  need REMOTE SCRY!!
    =/  result
      .^(update:ui %gx /(scot %p our.bowl)/indexer/(scot %da now.bowl)/grain/(scot %ux town-id)/(scot %ux grain-id)/noun)
    ?.  ?=(%grain -.result)
      ::  need a grain
      ``noun+!>(~)
    =/  =grain:smart  +.+.-.+.-:~(tap by grains.result)
    ``noun+!>(`grain)
  ::
      [%transaction @ ~]
    !!
  ==
::
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--
