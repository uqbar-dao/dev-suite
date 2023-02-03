::  An ~~inferno~~ of virtual ships
::  Use with %pyre, the virtual runtime, for the best experience
::
::  Usage:
::  |start %zig %pyro
::  :pyro|init ~nec
::  :pyro|commit ~nec %base
::  :pyro|dojo ~nec "(add 2 2)"
::  :pyro|snap /my-snapshot ~[~nec ~bud]
::  :pyro|restore /my-snapshot
::  :pyro|pause ~nec
::  :pyro|unpause ~nec
::  :pyro|kill ~nec
::  +zig!pyro/scry /~dev/gx/sequencer/status/noun
::
/-  *zig-pyro
/+  pyro=pyro-pyro,
    default-agent,
    pill=pill,
    naive, dbug, verb
::
/=  arvo-core  /lib/pyro/sys/arvo
/=  lull-core  /lib/pyro/sys/lull
/=  zuse-core  /lib/pyro/sys/zuse
/=  ames-core  /lib/pyro/sys/vane/ames
/=  behn-core  /lib/pyro/sys/vane/behn
/=  clay-core  /lib/pyro/sys/vane/clay
/=  dill-core  /lib/pyro/sys/vane/dill
/=  eyre-core  /lib/pyro/sys/vane/eyre
/=  gall-core  /lib/pyro/sys/vane/gall
/=  iris-core  /lib/pyro/sys/vane/iris
/=  jael-core  /lib/pyro/sys/vane/jael
/=  khan-core  /lib/pyro/sys/vane/khan
::
=>  |%
    ++  arvo-adult  ..^load:+>.arvo-core
    ++  clay-types  (clay-core *ship)
    ++  gall-type   (tail (gall-core *ship))
    +$  versioned-state
      $%  state-0
      ==
    +$  state-0
      $:  %0
          piers=fleet
          fleet-snaps=(map path fleet)
          ::  a fake time, starting at *@da and manually ticked up
          ::
          tym=@da  
          :: quickboot cache
          ::
          files=(axal (cask))
          =raft:clay-types
          park=task:clay :: TODO should be $>(%park task:clay)
      ==
    ::
    +$  fleet  (map ship pier)
    +$  pier
      $:  snap=_arvo-adult
          event-log=(list unix-timed-event)
          next-events=(qeu unix-event)
          paused=?
          scry-time=@da
      ==
    +$  card  card:agent:gall
    --
::
=|  state-0
=*  state  -
=<
  %-  agent:dbug
  %+  verb  |
  ^-  agent:gall
  |_  =bowl:gall
  +*  this       .
      ac         ~(. +> bowl)
      def        ~(. (default-agent this %|) bowl)
  ++  on-init
    =.  files
      %-  ~(gas of *(axal (cask)))
      %-  user-files:pill
      /(scot %p p.byk.bowl)/base/(scot %da now.bowl)
    =.  park  (park:pyro our.bowl %base %da now.bowl)
    :_  this
    :: have to start and kill a ship to fill the cache
    %+  turn  ~[!>([%init-ship ~nec]) !>([%kill-ships ~[~nec]])]
    |=(=vase [%pass / %agent [our dap]:bowl %poke %pyro-action vase])
  ++  on-save  !>(state)
  ++  on-load
    |=  old-vase=vase
    ^-  step:agent:gall
    =+  !<(old=versioned-state old-vase)
    ::  TODO uncomment for release
    :: =.  files
    ::   %-  ~(gas of *(axal (cask)))
    ::   %-  user-files:pill
    ::   /(scot %p p.byk.bowl)/base/(scot %da now.bowl)
    :: =.  park  (park:pyro our.bowl %base %da now.bowl)
    ?-  -.old
        %0  `this(state old)
    ==
  ::
  ++  on-poke
    |=  [=mark =vase]
    ^-  step:agent:gall
    =^  cards  state
      ?+  mark  ~|([%pyro-bad-mark mark] !!)
        %pyro-events  (poke-pyro-events:ac !<((list pyro-event) vase))
        %pyro-action  (poke-action:ac our.bowl !<(action vase))
      ==
    [cards this]
  ::
  ++  on-watch
    |=  =path
    ^-  step:agent:gall
    ::  /effect        subscribe to effects one by one
    ::  /effects       subscribe to effects in list form
    ::  /effect/~dev   subscribe to all effects of a given ship
    ::  /effect/blit   subscribe to all effects of a certain kind (e.g. blits)
    ::  /effects/~dev  subscribe to all effects of a given ship in list form
    ::  /events/~dev   subscribe to all events of a given ship
    ::  /event/~dev/*  subscribe to all events of a given ship and wire
    ::  /boths/~dev    subscribe to all events and effects of a given ship
    ?:  ?=([?(%effects %effect) ~] path)
      `this
    ?:  ?=([%effect @ ~] path)
      `this
    ?:  ?=([%event @ ^] path)
      ?~  (slaw %p i.t.path)
        ~|([%pyro-bad-subscribe-path-ship path] !!)
      `this
    ?.  ?=([?(%effects %effect %events %boths) @ ~] path)
      ~|([%pyro-bad-subscribe-path path] !!)
    ?~  (slaw %p i.t.path)
      ~|([%pyro-bad-subscribe-path-ship path] !!) 
    `this
  ::
  ++  on-peek
    |=  =path
    ^-  (unit (unit cage))
    ?+    path  ~
        [%x %snaps ~]
      :^  ~  ~  %pyro-update
      !>(`update`[%snaps (turn ~(tap by fleet-snaps) head)])
    ::
        [%x %ships ~]
      :^  ~  ~  %pyro-update
      !>(`update`[%ships (turn ~(tap by piers) head)])
    ::
        [%x %snap-ships ^]
      =+  sips=(~(get by fleet-snaps) t.t.path)
      :^  ~  ~  %pyro-update
      !>  ^-  update
      ?~  sips  ~
      [%snap-ships t.t.path (turn ~(tap by u.sips) head)]
    ::  scry into running virtual ships
    ::  mold, ship, care, ship, desk, time, path
    ::
        [%x %i ?(%noun %json %mime) @ @ @ @ @ *]
      =/  who  (slav %p i.t.t.path)
      =*  mol  i.t.path
      =/  paf  (snoc t.t.t.path mol)
      `(scry:(pe who) paf mol)
    ::  convenience scry for a virtual ship's running gall app
    ::  mold, ship, app, path
    ::
        [%x ?(%noun %json %mime) @ @ *]
      =/  mol  i.t.path
      =/  who  (slav %p i.t.t.path)
      =*  her  i.t.t.path
      =*  dap  i.t.t.t.path
      =/  paf  (snoc t.t.t.t.path mol)
      `(scry:(pe who) (weld /gx/[her]/[dap]/0 paf) mol)
    ==
  ++  on-leave  on-leave:def
  ++  on-agent  on-agent:def
  ++  on-arvo   on-arvo:def
  ++  on-fail   on-fail:def
  --
::
::  unix-{effects,events,boths}: collect jar of effects and events to
::    brodcast all at once to avoid gall backpressure
::  moves: Hoist moves into state for cleaner state management
::
=|  unix-effects=(jar ship unix-effect)
=|  unix-events=(jar ship unix-timed-event)
=|  unix-boths=(jar ship unix-both)
=|  cards=(list card)
|_  =bowl:gall
::
++  this  .
::
::  Represents a single ship's state.
::
++  pe
  |=  who=ship
  =+  (~(gut by piers) who *pier)
  =*  pier-data  -
  |%
  ::
  ::  Done; install data
  ::
  ++  abet-pe
    ^+  this
    =.  piers  (~(put by piers) who pier-data)
    =.  fad.raft  :: add new files to cache
      %-  ~(uni by fad.raft)
      ?~  cey=(~(get by van.mod.sol.snap) %clay)  ~
      =/  cay  !<((tail clay-types) vase:u.cey)
      fad.ruf.cay
    this
  ::
  ::  Begin: load in cache
  ::
  ++  apex
    ^+  ..abet-pe
    =.  van.mod.sol.snap
      =/  cay  !<((tail clay-types) vase:(~(got by van.mod.sol.snap) %clay))
      =.  fad.ruf.cay  fad.raft
      (~(put by van.mod.sol.snap) %clay [!>(cay) *worm])
    ..abet-pe
  ::
  ::  store ford caches
  ::
  ++  ahoy
    =/  cay  !<((tail clay-types) vase:(~(got by van.mod.sol.snap) %clay))
    =.  raft
      :: have to get rid of the kids desk otherwise boot fails
      =.  dos.rom.ruf.cay  (~(del by dos.rom.ruf.cay) %kids)
      ruf.cay
    ..abet-pe
  ::
  ++  slap-gall
    |=  [dap=term =vase]
    ^+  ..abet-pe
    =.  van.mod.sol.snap
      =/  gal  !<(gall-type vase:(~(got by van.mod.sol.snap) %gall))
      =/  yok  (~(got by yokes.state.gal) dap)
      ?>  ?=(%& -.agent.yok) :: not going to handle dead agents
      =.  agent.yok
        %&^(tail (on-load:p.agent.yok vase))
      =.  yokes.state.gal  (~(put by yokes.state.gal) dap yok)
      (~(put by van.mod.sol.snap) %gall [!>(gal) *worm])
    ..abet-pe
  ::
  ::  Enqueue events to child arvo
  ::
  ++  push-events
    |=  ues=(list unix-event)
    ^+  ..abet-pe
    =.  next-events  (~(gas to next-events) ues)
    ..abet-pe
  ::
  ::  Process the events in our queue.
  ::
  ++  plow
    |-  ^+  ..abet-pe
    ?:  =(~ next-events)
      ..abet-pe
    ?:  paused
      ~&(pyro+not-plowing-events+who ..abet-pe)
    =^  ue  next-events  ~(get to next-events)
    =.  tym  (max +(tym) now.bowl)
    =/  poke-result=(each vase tang)
      (mule |.((slym [-:!>(poke:arvo-adult) poke:snap] [tym ue])))
    ?:  ?=(%| -.poke-result)
      ((slog >%pyro-crash< >who< p.poke-result) $)
    ::  BEWARE: this is extremely dangerous
    =.  snap  !<(_arvo-adult [-:!>(*_arvo-adult) +.q.p.poke-result])
    =.  scry-time  tym
    =.  ..abet-pe  (publish-event tym ue)
    =.  ..abet-pe
      ~|  ova=-.p.poke-result
      (handle-effects ;;((list ovum) -.q.p.poke-result))
    $
  ::
  ::  Handle all the effects produced by a single event.
  ::
  ++  handle-effects
    |=  effects=(list ovum)
    ^+  ..abet-pe
    ?~  effects
      ..abet-pe
    =.  ..abet-pe
      ?~  sof=((soft unix-effect) i.effects)
        ?:  &(=(p.card.i.effects %unto) ?=(^ q.card.i.effects))
          ((slog (flop ;;(tang +.q.card.i.effects))) ~&(who=who ..abet-pe))
        ~&(pyro+unknown-effect+who^i.effects ..abet-pe)
      (publish-effect u.sof)
    $(effects t.effects)
  ::
  ++  publish-effect
    |=  uf=unix-effect
    ^+  ..abet-pe
    =.  unix-effects  (~(add ja unix-effects) who uf)
    =.  unix-boths  (~(add ja unix-boths) who [%effect uf])
    ..abet-pe
  ::
  ++  publish-event
    |=  ute=unix-timed-event
    ^+  ..abet-pe
    =.  event-log  [ute event-log]
    =.  unix-events  (~(add ja unix-events) who ute)
    =.  unix-boths  (~(add ja unix-boths) who [%event ute])
    ..abet-pe
  ::
  ++  scry
    |=  [=path mol=?(%noun %json %mime)]
    ^-  (unit cage)
    ?.  ?=([@ @ @ @ *] path)  ~
    ::  alter timestamp to match %pyro fake-time
    =.  i.t.t.t.path  (scot %da scry-time)
    ::  execute scry
    =/  pek=(each vase tang)
      (mule |.((slym [-:!>(peek:arvo-adult) peek:snap] [`~ %&^path])))
    ?:  ?=(%| -.pek)
      ((slog >%pyro-crash< >who=who< p.pek) ~)
    ?~  q.p.pek  ~
    :: success: make a (unit page) from a (vase (unit page))
    :+  ~
      !<(mark (slam !>(|=((unit page) (head (need +<)))) p.pek))
    :: TODO this is a really hacky and terrible solution to get extra type
    ::   info in the vase caused by the fact that p.p.pek is #t/u([p=@tas q=*])
    ::   i.e., doesn't have enough type information
    ?-  mol
      %noun  (slam !>(|=((unit page) (noun (tail (need +<))))) p.pek)
      %json  (slam !>(|=((unit page) (json (tail (need +<))))) p.pek)
      %mime  (slam !>(|=((unit page) (mime (tail (need +<))))) p.pek)
    ==
  ::
  ::  When paused, events are added to the queue but not processed.
  ::
  ++  pause    .(paused &)
  ++  unpause  .(paused |)
  --
::
::  ++apex-pyro and ++abet-pyro must bookend calls from gall
::
++  apex-pyro
  ^+  this
  =:  cards         ~
      unix-effects  ~
      unix-events   ~
      unix-boths    ~
    ==
  this
::
++  abet-pyro
  ^-  (quip card _state)
  ::
  =.  this
    =/  =path  /effect
    %-  emit-cards
    %-  zing
    %+  turn  ~(tap by unix-effects)
    |=  [=ship ufs=(list unix-effect)]
    %-  zing
    %+  turn  ufs
    |=  uf=unix-effect
    =+  paths=~[/effect /effect/[-.q.uf]]
    [%give %fact paths %pyro-effect !>(`pyro-effect`[ship uf])]~
  ::
  =.  this
    =/  =path  /effects
    %-  emit-cards
    %+  turn  ~(tap by unix-effects)
    |=  [=ship ufs=(list unix-effect)]
    [%give %fact ~[path] %pyro-effects !>(`pyro-effects`[ship (flop ufs)])]
  ::
  =.  this
    %-  emit-cards
    %-  zing
    %+  turn  ~(tap by unix-effects)
    |=  [=ship ufs=(list unix-effect)]
    =/  =path  /effect/(scot %p ship)
    %+  turn  ufs
    |=  uf=unix-effect
    [%give %fact ~[path] %pyro-effect !>(`pyro-effect`[ship uf])]
  ::
  =.  this
    %-  emit-cards
    %+  turn  ~(tap by unix-effects)
    |=  [=ship ufs=(list unix-effect)]
    =/  =path  /effects/(scot %p ship)
    [%give %fact ~[path] %pyro-effects !>(`pyro-effects`[ship (flop ufs)])]
  ::
  =.  this
    %-  emit-cards
    %+  turn  ~(tap by unix-events)
    |=  [=ship ve=(list unix-timed-event)]
    =/  =path  /events/(scot %p ship)
    [%give %fact ~[path] %pyro-events !>(`pyro-events`[ship (flop ve)])]
  ::
  =.  this
    %-  emit-cards
    %-  zing
    %+  turn  ~(tap by unix-events)
    |=  [=ship utes=(list unix-timed-event)]
    %+  turn  utes
    |=  ut=unix-timed-event
    =/  =path  (weld /event/(scot %p ship) p.ue.ut)
    [%give %fact ~[path] %pyro-event !>(`pyro-event`[ship ue.ut])]
  ::
  =.  this
    %-  emit-cards
    %+  turn  ~(tap by unix-boths)
    |=  [=ship bo=(list unix-both)]
    =/  =path  /boths/(scot %p ship)
    [%give %fact ~[path] %pyro-boths !>(`pyro-boths`[ship (flop bo)])]
  ::
  [(flop cards) state]
::
++  emit-cards
  |=  ms=(list card)
  =.  cards  (weld ms cards)
  this
::
::  Apply a list of events tagged by ship
::
++  poke-pyro-events
  |=  events=(list pyro-event)
  ^-  (quip card _state)
  =.  this  apex-pyro  =<  abet-pyro
  %+  turn-events  events
  |=  [ae=pyro-event thus=_this]
  =.  this  thus
  (push-events:(pe who.ae) [ue.ae]~)
::
++  poke-action
  |=  [our=ship act=action]
  ^-  (quip card _state)
  ?-    -.act
      %init-ship
    =.  this  apex-pyro  =<  abet-pyro
    =.  this  abet-pe:unpause:(publish-effect:(pe who.act) [/ %kill ~])
    =/  clay  (clay-core who.act)
    =.  ruf.clay  raft
    =/  new  (~(got by piers) who.act)
    =.  sol.snap.new
      ^-  soul
      :*  [who.act *@da *@uvJ]                         ::  mien
          &                                            ::  fad
          :_  |                                        ::  zen
          :-  [~.nonce /pyro]
          :~  zuse+zuse:zuse-core
              lull+lull:lull-core
              arvo+arvo:arvo-core
              hoon+hoon-version
              nock+4
          ==
          :^    files                                  ::  mod
              !>(lull-core)
            !>(zuse-core)
          %-  ~(gas by *(map term vane))               ::  van.mod
          :~  [%ames [!>((ames-core who.act)) *worm]]
              [%behn [!>((behn-core who.act)) *worm]]
              [%clay [!>(clay) *worm]]
              [%dill [!>((dill-core who.act)) *worm]]
              [%eyre [!>((eyre-core who.act)) *worm]]
              [%gall [!>((gall-core who.act)) *worm]]
              [%iris [!>((iris-core who.act)) *worm]]
              [%jael [!>((jael-core who.act)) *worm]]
              [%khan [!>((khan-core who.act)) *worm]]
      ==  ==
    =.  piers  (~(put by piers) who.act new)
    =.  this
      =<  abet-pe:ahoy:plow
      %-  push-events:(pe who.act)
      ^-  (list unix-event)
      :~  [/d/term/1 %boot & %fake who.act]  ::  start vanes
          [/b/behn/0v1n.2m9vh %born ~]
          [/i/http-client/0v1n.2m9vh %born ~]
          [/e/http-server/0v1n.2m9vh %born ~]
          [/e/http-server/0v1n.2m9vh %live 8.080 `8.445]  :: TODO do we need this event
          [/a/newt/0v1n.2m9vh %born ~]
          [/c/commit/(scot %p who.act) park]
      ==
    (pe who.act)
  ::
      %kill-ships
    =.  this
      %+  turn-ships  hers.act
      |=  [who=ship thus=_this]
      ~&  pyro+killed+who
      =.  this  thus
      (publish-effect:(pe who) [/ %kill ~])
    =.  piers
      %-  ~(dif by piers)
      %-  ~(gas by *fleet)
      (turn hers.act |=(=ship [ship *pier]))
    `state
  ::
      %slap-gall
    =.  this  abet-pe:(slap-gall:(pe her.act) [dap.act vase.act])
    ~&  pyro+slap-gall+her.act
    `state
  ::
      %snap-ships
    =.  fleet-snaps
      %+  ~(put by fleet-snaps)  path.act
      %-  malt
      %+  murn  hers.act
      |=  her=ship
      ^-  (unit (pair ship pier))
      ?~  per=(~(get by piers) her)  ~
      `[her u.per]
    ~&  pyro+snapshot+path.act
    `state
  ::
      %restore-snap
    =/  to-kill  :: only kill ships in the snapshot
      %-  ~(int in ~(key by piers))
      ~(key by (~(got by fleet-snaps) path.act))
    =.  this
      %+  turn-ships  ~(tap in to-kill)
      |=  [who=ship thus=_this]
      =.  this  thus
      (publish-effect:(pe who) [/ %kill ~])
    =.  piers  (~(got by fleet-snaps) path.act)
    ~&  pyro+restore-snap+path.act
    abet-pyro
  ::
      %delete-snap
    ~&  deleted+path.act
    `state(fleet-snaps (~(del by fleet-snaps) path.act))
  ::
      %clear-snaps
    ~&  pyro+%cleared-all-snaps
    `state(fleet-snaps ~)
  ::
      %unpause-ships
    =.  this  apex-pyro  =<  abet-pyro
    ^+  this
    %+  turn-ships  hers.act
    |=  [who=ship thus=_this]
    =.  this  thus
    ~&  pyro+unpaused+who
    unpause:(pe who)
  ::
      %pause-ships
    =.  this  apex-pyro  =<  abet-pyro
    ^+  this
    %+  turn-ships  hers.act
    |=  [who=ship thus=_this]
    =.  this  thus
    ~&  pyro+paused+who
    pause:(pe who)
  ::
      %wish
    =.  this  apex-pyro  =<  abet-pyro
    ^+  this
    %+  turn-ships  hers.act
    |=  [who=ship thus=_this]
    =.  this  thus
    =/  res=vase
      (slym [-:!>(wish:arvo-adult) wish:snap:pier-data:(pe who)] p.act)
    ::  TODO type is a vase, so q.res is a noun. Should be molded somehow
    ~&  who^%wished^q.res
    (pe who)
  ==
::
::  Run a callback function against a list of ships, aggregating state
::  and plowing all ships at the end.
::
::    The callback function must start with `=.  this  thus`, or else
::    you don't get the new state.
::
++  turn-plow
  |*  arg=mold
  |=  [hers=(list arg) fun=$-([arg _this] _(pe))]
  |-  ^+  this
  ?~  hers
    ::  Run all events on all ships until all queues are empty
    |-
    =/  who
      =/  pers  ~(tap by piers)
      |-  ^-  (unit ship)
      ?~  pers  ~
      ?:  &(?=(^ next-events.q.i.pers) !paused.q.i.pers)
        `p.i.pers
      $(pers t.pers)
    ?~  who  this
    =.  this  abet-pe:plow:apex:(pe u.who)
    $
  =.  this
    abet-pe:plow:apex:(fun i.hers this)
  $(hers t.hers, this this)
::
++  turn-ships   (turn-plow ship)
++  turn-events  (turn-plow pyro-event)
::
--
