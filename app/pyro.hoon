::  An ~~inferno~~ of virtual ships.  Put in some fish and watch them die!
::  Use with %pyre, the virtual runtime, for the best experience
::
::  Usage:
::  |start %zig %pyro
::  :pyro|init ~dev
::  :pyro|dojo ~dev "(add 2 2)"
::  +zig!pyro/scry ~dev %sequencer /status/noun
::
::  Use a custom pill: :pyro +solid
::
/-  *zig-pyro
/+  pyro=zig-pyro,
    pill-lib=pill,
    default-agent,
    naive, dbug, verb
/=  arvo-core  /lib/zig/sys/arvo
/*  cached-pill  %noun  /zig/snapshots/pill/pill
=>  |%
    ++  arvo-adult  ..^load:+>.arvo-core
    +$  versioned-state
      $%  state-0
      ==
    +$  state-0
      $:  %0
          pil=$>(%pill pill:pill-lib)  ::  the boot sequence a new fakeship will use
          assembled=_arvo-adult
          tym=@da  ::  a fake time, starting at *@da and manually ticked up
          fresh-piers=(map =ship [=pier boths=(list unix-both)])
          fleet-snaps=(map path fleet)
          piers=fleet
      ==
    ::
    +$  fleet  (map ship pier)
    +$  pier
      $:  snap=_arvo-adult
          event-log=(list unix-timed-event)
          next-events=(qeu unix-event)
          processing-events=$~(%.n ?)
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
    :_  this
    [%pass / %agent [our dap]:bowl %poke %pill !>(cached-pill)]~
    :: [%pass / %agent [our dap]:bowl %poke %pyro-action !>([%import-fresh-piers /zig/lib/py/fresh-piers/jam])]
  ++  on-save  !>(state)
  ++  on-load
    |=  old-vase=vase
    ^-  step:agent:gall
    =+  !<(old=versioned-state old-vase)
    ?-  -.old
        %0  `this(state old)
    ==
  ::
  ++  on-poke
    |=  [=mark =vase]
    ^-  step:agent:gall
    =^  cards  state
      ?+  mark  ~|([%aqua-bad-mark mark] !!)
        %aqua-events  (poke-aqua-events:ac !<((list aqua-event) vase))
        %pyro-action  (poke-action:ac our.bowl !<(action vase))
        %pill         (poke-pill:ac !<(pill:pill-lib vase))
      ==
    [cards this]
  ::
  ++  on-watch
    |=  =path
    ^-  step:agent:gall
    ::  /ready/~dev    subscribe to when a ship has fully booted
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
        ~|([%aqua-bad-subscribe-path-ship path] !!)
      `this
    ?.  ?=([?(%effects %effect %events %boths %ready) @ ~] path)
      ~|([%aqua-bad-subscribe-path path] !!)
    ?~  (slaw %p i.t.path)
      ~|([%aqua-bad-subscribe-path-ship path] !!) 
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
        [%x %fresh-piers ~]
      :^  ~  ~  %pyro-update
      !>(`update`[%fresh-piers (turn ~(tap by fresh-piers) head)])
    ::
        [%x %snap-ships ^]
      =+  sips=(~(get by fleet-snaps) t.t.path)
      :^  ~  ~  %pyro-update
      !>  ^-  update
      ?~  sips  ~
      [%snap-ships t.t.path (turn ~(tap by u.sips) head)]
    ::
        [%x %pill ~]  ``pill+!>(pil)
    ::
    ::  scry into running virtual ships
    ::  ship, care, ship, desk, time, path
        [%x %i @ @ @ @ @ *]
      =/  who  (slav %p i.t.t.path)
      `(scry:(pe who) t.t.t.path)
    ::
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
    this
  ::
  ::  Initialize new ship
  ::
  ++  apex
    =.  pier-data  *pier
    =.  processing-events.pier-data  %.y
    =.  snap  assembled
    ~&  pill-size=(met 3 (jam snap))
    ..abet-pe
  ::
  ::  store post-pill ship for later re-use
  ::
  ++  ahoy
    =?  fresh-piers  !(~(has by fresh-piers) who)
      %+  ~(put by fresh-piers)  who
      [pier-data(processing-events %.y) (~(get ja unix-boths) who)]
    =-  ..ahoy:(emit-cards -)
    [%give %fact ~[/ready/(scot %p who)] %noun !>(%.y)]~
  ::
  ::  restore post-pill ship for re-use
  ::
  ++  yaho
    =/  fresh  (~(got by fresh-piers) who)
    =/  =card  [%give %fact ~[/ready/(scot %p who)] %noun !>(%.y)]
    =.  pier-data  pier.fresh
    =.  boths.fresh  (flop boths.fresh)
    |-
    ?~  boths.fresh  ..yaho:(emit-cards ~[card])
    =.  ..yaho
      ?-  -.i.boths.fresh
        %effect  (publish-effect +.i.boths.fresh)
        %event   (publish-event +.i.boths.fresh)
      ==
    $(boths.fresh t.boths.fresh)
  ::
  ::  Enqueue events to child arvo
  ::
  ++  push-events
    |=  ues=(list unix-event)
    ^+  ..abet-pe
    =.  next-events  (~(gas to next-events) ues)
    ..abet-pe
  ::
  ::  Send cards to host arvo
  ::
  ++  emit-cards
    |=  ms=(list card)
    =.  this  (^emit-cards ms)
    ..abet-pe
  ::
  ::  Process the events in our queue.
  ::
  ++  plow
    :: TODO this is a little slower than the untyped version
    :: is there a way to speed it up?
    |-  ^+  ..abet-pe
    ?:  =(~ next-events)
      ..abet-pe
    ?.  processing-events
      ~&(%pyro^%not-plowing-events^who=who ..abet-pe)
    =^  ue  next-events  ~(get to next-events)
    =.  tym  (max +(tym) now.bowl)
    =/  poke-result=(each vase tang)
      (mule |.((slam [-:!>(poke:arvo-adult) poke:snap] !>([tym ue]))))
    ?:  ?=(%| -.poke-result)
      %-  (slog >%aqua-crash< >who=who< p.poke-result)
      $
    =.  snap  (hole _arvo-adult +.q.p.poke-result)
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
        ~&([who=who %unknown-effect i.effects] ..abet-pe)
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
    |=  pax=path
    ^-  (unit cage)
    ?.  ?=([@ @ @ @ *] pax)  ~
    ::  alter timestamp to match %pyro fake-time
    =.  i.t.t.t.pax  (scot %da scry-time)
    ::  execute scry
    =/  pek=(each vase tang)
      (mule |.((slam [-:!>(peek:arvo-adult) peek:snap] !>([`~ %.y pax]))))
    ?:  ?=(%| -.pek)
      ((slog >%aqua-crash< >who=who< p.pek) ~)
    ?~  q.p.pek  ~
    :: success: make a (unit cage)
    :+  ~  :: TODO clean this code
      !<(mark (slam !>(|=(u=(unit (cask)) (head (need u)))) p.pek))
    (slam !>(|=(u=(unit (cask)) (tail (need u)))) p.pek)
  ::
  ::  Start/stop processing events.  When stopped, events are added to
  ::  our queue but not processed.
  ::
  ++  unpause  .(processing-events &)
  ++  pause    .(processing-events |)
  --
::
::  ++apex-aqua and ++abet-aqua must bookend calls from gall
::
++  apex-aqua
  ^+  this
  =:  cards         ~
      unix-effects  ~
      unix-events   ~
      unix-boths    ~
    ==
  this
::
++  abet-aqua
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
    [%give %fact paths %aqua-effect !>(`aqua-effect`[ship uf])]~
  ::
  =.  this
    =/  =path  /effects
    %-  emit-cards
    %+  turn  ~(tap by unix-effects)
    |=  [=ship ufs=(list unix-effect)]
    [%give %fact ~[path] %aqua-effects !>(`aqua-effects`[ship (flop ufs)])]
  ::
  =.  this
    %-  emit-cards
    %-  zing
    %+  turn  ~(tap by unix-effects)
    |=  [=ship ufs=(list unix-effect)]
    =/  =path  /effect/(scot %p ship)
    %+  turn  ufs
    |=  uf=unix-effect
    [%give %fact ~[path] %aqua-effect !>(`aqua-effect`[ship uf])]
  ::
  =.  this
    %-  emit-cards
    %+  turn  ~(tap by unix-effects)
    |=  [=ship ufs=(list unix-effect)]
    =/  =path  /effects/(scot %p ship)
    [%give %fact ~[path] %aqua-effects !>(`aqua-effects`[ship (flop ufs)])]
  ::
  =.  this
    %-  emit-cards
    %+  turn  ~(tap by unix-events)
    |=  [=ship ve=(list unix-timed-event)]
    =/  =path  /events/(scot %p ship)
    [%give %fact ~[path] %aqua-events !>(`aqua-events`[ship (flop ve)])]
  ::
  =.  this
    %-  emit-cards
    %-  zing
    %+  turn  ~(tap by unix-events)
    |=  [=ship utes=(list unix-timed-event)]
    %+  turn  utes
    |=  ut=unix-timed-event
    =/  =path  (weld /event/(scot %p ship) p.ue.ut)
    [%give %fact ~[path] %aqua-event !>(`aqua-event`[%event ship ue.ut])]
  ::
  =.  this
    %-  emit-cards
    %+  turn  ~(tap by unix-boths)
    |=  [=ship bo=(list unix-both)]
    =/  =path  /boths/(scot %p ship)
    [%give %fact ~[path] %aqua-boths !>(`aqua-boths`[ship (flop bo)])]
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
++  poke-aqua-events
  |=  events=(list aqua-event)
  ^-  (quip card _state)
  =.  this  apex-aqua  =<  abet-aqua
  %+  turn-events  events
  |=  [ae=aqua-event thus=_this]
  =.  this  thus
  ?-  -.ae
  ::
      %init-ship
    =.  this  abet-pe:unpause:(pe who.ae)
    ?:  (~(has by fresh-piers) who:ae)
      ~&  [%pyro %cached-init +.ae]
      =.  this  abet-pe:yaho:[ae (pe who.ae)]
      (pe who.ae)
    =.  this  abet-pe:(publish-effect:(pe who.ae) [/ %sleep ~])
    =/  initted
      =<  plow
      %-  push-events:apex:(pe who.ae)
      ^-  (list unix-event)
      %-  zing
      :~  :~  [/ %wack 0]                       ::  eny
              :: [/ %verb `|]                   ::  possible verb
              :^  /  %wyrd  [~.nonce /aqua]     ::  dummy runtime version+nonce
              ^-  (list (pair term @))
              :~  zuse+zuse
                  lull+lull
                  arvo+arvo
                  hoon+hoon-version
                  nock+4
              ==
              [/ %whom who.ae]                  ::  who
          ==
          ::
          kernel-ova.pil                        ::  load compiler
          ::
          userspace-ova.pil                     ::  load os
          ::
          :~  [/d/term/1 %boot & %fake who.ae]  ::  reset vanes
              [/b/behn/0v1n.2m9vh %born ~]
              [/i/http-client/0v1n.2m9vh %born ~]
              [/e/http-server/0v1n.2m9vh %born ~]
              [/e/http-server/0v1n.2m9vh %live 8.080 `8.445]
              [/a/newt/0v1n.2m9vh %born ~]
      ==  ==
    =.  this  abet-pe:ahoy:[ae initted]
    (pe who.ae)
  ::
      %event  (push-events:(pe who.ae) [ue.ae]~)
  ==
::
++  poke-action
  |=  [our=ship act=action]
  ^-  (quip card _state)
  ?-    -.act
      %kill-ships
    =.  this
      %+  turn-ships  hers.act
      |=  [who=ship thus=_this]
      ~&  [%pyro %killing who]
      =.  this  thus
      (publish-effect:(pe who) [/ %kill ~])
    =.  piers
      %-  ~(dif by piers)
      %-  ~(gas by *fleet)
      (turn hers.act |=(=ship [ship *pier]))
    `state
  ::
      %snap-ships
    =.  fleet-snaps
      %+  ~(put by fleet-snaps)  path.act
      %-  malt
      %+  murn  hers.act
      |=  her=ship
      ^-  (unit (pair ship pier))
      =+  per=(~(get by piers) her)
      ?~  per
        ~
      `[her u.per]
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
    =.  this
      %+  turn-ships  (turn ~(tap by piers) head)
      |=  [who=ship thus=_this]
      =.  this  thus
      (publish-effect:(pe who) [/ %restore ~])
    abet-aqua
  ::
      %delete-snap
    `state(fleet-snaps (~(del by fleet-snaps) path.act))
  ::
      %clear-snaps  `state(fleet-snaps ~)
  ::
      %export-snap
    :: all snapshots are put in /=zig=/zig/snapshots/[path]/jam
    ?~  p=(~(get by fleet-snaps) path.act)
      ~&(%pyro^%no-such-snapshot !!)
    :_  state
    :_  ~
    :*  %pass
        export+path.act
        %arvo
        %c
        %info
        %zig
        %&
        :_  ~
        :+  lib+py+snapshots+(snoc path.act %jam)  %ins
        [%jam !>((jam u.p))]
    ==
  ::
      %import-snap
    :: fetches from /=zig=/zig/snapshots
    ?~  jam-file-path.act
      ~&(%pyro^%unexpected-file-path^jam-file-path.act !!)
    =/  jammed=@
      .^  @
          %cx
          %+  welp
            /(scot %p our.bowl)/zig/(scot %da now.bowl)/zig/snapshots
          jam-file-path.act
      ==
    =/  cued=*  (cue jammed)
    =/  f=fleet  ;;(fleet cued)
    =.  fleet-snaps
      (~(put by fleet-snaps) snap-label.act f)
    :_  state
    [%pass / %agent [our.bowl %hood] %poke %helm-meld !>(~)]~
  ::
      %export-fresh-piers
    ?~  fresh-piers  ~&(%pyro^%no-fresh-piers !!)
    =/  jam-fresh-piers=@  (jam fresh-piers)
    =*  piers-hash=@ta  (scot %ux (mug jam-fresh-piers))
    :_  state
    :_  ~
    :*  %pass
        /export/fresh-piers
        %arvo
        %c
        %info
        %zig
        %&
        :_  ~
        :+  /snapshots/[piers-hash]/jam  %ins
        [%jam !>(jam-fresh-piers)]
    ==
  ::
      %import-fresh-piers
    ?~  jam-file-path.act
      ~&(%pyro^%unexpected-file-path^jam-file-path.act !!)
    =/  jammed=@
      .^  @
          %cx
          %+  welp
            :-  (scot %p our.bowl)
            /[i.jam-file-path.act]/(scot %da now.bowl)
          t.jam-file-path.act
      ==
    =/  piers-hash=@ux  (mug jammed)
    =/  imported-fresh-piers
      ;;((map ship [pier (list unix-both)]) (cue jammed))
    ~&  %pyro^%import-fresh-piers^jam-file-path.act^piers-hash^~(key by imported-fresh-piers)
    `state(fresh-piers imported-fresh-piers)
  ::
      %wish
    =.  this  apex-aqua  =<  abet-aqua
    ^+  this
    %+  turn-ships  hers.act
    |=  [who=ship thus=_this]
    =.  this  thus
    =/  res=vase
      (slam [-:!>(wish:arvo-adult) wish:snap:pier-data:(pe who)] !>(p.act))
    ::  TODO type is a vase, so q.res is a noun. Should be molded somehow
    ~&  [who=who %wished q.res]
    (pe who)
  ::
      %unpause-events
    =.  this  apex-aqua  =<  abet-aqua
    ^+  this
    %+  turn-ships  hers.act
    |=  [who=ship thus=_this]
    =.  this  thus
    unpause:(pe who)
  ::
      %pause-events
    =.  this  apex-aqua  =<  abet-aqua
    ^+  this
    %+  turn-ships  hers.act
    |=  [who=ship thus=_this]
    =.  this  thus
    pause:(pe who)
  ::
      %commit
    =/  pak  (park:pyro p.byk.bowl desk.act r.byk.bowl)
    :_  state
    %+  turn  hers.act
    |=  =ship
    ^-  card
    :*  %pass  /  %agent  [our.bowl %pyro]
        %poke  %aqua-events
        !>([%event ship /c/commit/(scot %p ship) pak]~)
    ==
  ==
::
::  Load a pill and assemble arvo.  Doesn't send any initial events
::
++  poke-pill
  |=  p=pill:pill-lib
  ^-  (quip card _state)
  ?<  ?=(%ivory -.p)
  =.  this  apex-aqua  =<  abet-aqua
  =.  pil  p
  ~&  lent=(met 3 (jam boot-ova.pil))
  =/  res=toon
    (mock [boot-ova.pil [2 [0 3] [0 2]]] |=([* *] ~))
  =.  fleet-snaps  ~
  ?-    -.res
      %0
    ~&  >  "successfully assembled pill"
    =.  assembled  (hole _arvo-adult +7.p.res)
    =.  fresh-piers  ~
    this
  ::
      %1  ~&([%vere-blocked p.res] this)
      %2  ~&(%vere-fail ((slog p.res) this))
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
      ?:  &(?=(^ next-events.q.i.pers) processing-events.q.i.pers)
        `p.i.pers
      $(pers t.pers)
    ?~  who  this
    =.  this  abet-pe:plow:(pe u.who)
    $
  =.  this
    abet-pe:plow:(fun i.hers this)
  $(hers t.hers, this this)
::
++  turn-ships   (turn-plow ship)
++  turn-events  (turn-plow aqua-event)
::
::  BEWARE: this is a "profoundly broken" piece of code, use with caution
::
++  hole
  |*  [typ=mold val=*]
  ^-  typ
  !<(typ [-:!>(*typ) val])
::
--
