::  An ~~inferno~~ of virtual ships.  Put in some fish and watch them die!
::
::  usage:
::  |start %zig %pyro
::  :pyro +solid %base %zig
::  swap files is NOT working
::  :pyro &aqua-events [%init-ship ~dev %.y]~  OR  :pyro|init ~dev
::  :pyro &action [%dojo ~dev "(add 2 2)"]     OR  :pyro|dojo ~dev "(add 2 2)"
::
::  Then try stuff:
::  XX :aqua [%init ~[~bud ~dev]]
::  XX :aqua [%dojo ~[~bud ~dev] "[our eny (add 3 5)]"]
::  XX :aqua [%dojo ~[~bud] "|hi ~dev"]
::  XX :aqua [%wish ~[~bud ~dev] '(add 2 3)']
::  XX :aqua [%peek ~[~bud] /cx/~bud/base/(scot %da now)/app/curl/hoon]
::  XX :aqua [%dojo ~[~bud ~dev] '|mount %']
::  XX :aqua [%file ~[~bud ~dev] %/sys/vane]
::  XX :aqua [%pause-events ~[~bud ~dev]]
::
::  We get ++unix-event and ++pill from /-pyro
::
/-  *pyro
/+  pill, default-agent, naive, dbug, verb
=,  pill-lib=pill
=>  $~  |%
    +$  versioned-state
      $%  state-0
      ==
    +$  state-0
      $:  %0
          pil=$>(%pill pill)  ::  the boot sequence a new fakeship will use
          assembled=*
          tym=@da  ::  a fake time, starting at *@da and manually ticked up
          fresh-piers=(map =ship [=pier boths=(list unix-both)])
          fleet-snaps=(map term fleet)
          piers=fleet
      ==
    ::  XX temporarily shadowed, fix and remove
    ::
    +$  pill  pill:pill-lib
    ::
    +$  fleet  (map ship pier)
    +$  pier
      $:  snap=*
          event-log=(list unix-timed-event)
          next-events=(qeu unix-event)
          processing-events=?
      ==
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
      aqua-core  +>
      ac         ~(. aqua-core bowl)
      def        ~(. (default-agent this %|) bowl)
  ++  on-init  `this
  ++  on-save  !>(state)
  ++  on-load
    |=  old-vase=vase
    ^-  step:agent:gall
    ~&  prep=%aqua
    =+  !<(old=versioned-state old-vase)
    =|  cards=(list card:agent:gall)
    |-
    ?-  -.old
    ::  wipe fleets and piers rather than give them falsely nulled azimuth state
    ::
        %0
      [cards this(state old)]
    ==
  ::
  ++  on-poke
    |=  [=mark =vase]
    ^-  step:agent:gall
    |^
    =^  cards  state
      ?+  mark  ~|([%aqua-bad-mark mark] !!)
        %aqua-events  (poke-aqua-events:ac !<((list aqua-event) vase))
        %pill         (poke-pill:ac !<(pill vase))
        %noun         (poke-noun:ac !<(* vase))
        %action       (handle-action !<(pyro-action vase))
      ==
    [cards this]
    ::
    ++  handle-action
      |=  act=pyro-action
      ^-  (quip card:agent:gall _state)
      ?-    -.act
          %peek
        !!
      ::
          %dojo
        :_  state
        =-  [%pass /self-poke %agent [our.bowl %pyro] %poke -]~
        :-  %aqua-events  !>
        ^-  (list aqua-event)
        %+  turn
          ^-  (list unix-event)
          :~  [/d/term/1 %belt %ctl `@c`%e]
              [/d/term/1 %belt %ctl `@c`%u]
              [/d/term/1 %belt %txt ((list @c) ;;(tape command.act))]
              [/d/term/1 %belt %ret ~]
          ==
        |=  ue=unix-event
        [%event who.act ue]
      ::
          %remove-ship
        =.  piers  (~(del by piers) who.act)
        `state
      ==
    --
  ::
  ++  on-watch
    |=  =path
    ^-  step:agent:gall
    ?:  ?=([?(%effects %effect) ~] path)
      `this
    ?:  ?=([%effect @ ~] path)
      `this
    ?.  ?=([?(%effects %effect %evens %boths) @ ~] path)
      ~|  [%aqua-bad-subscribe-path path]
      !!
    ?~  (slaw %p i.t.path)
      ~|  [%aqua-bad-subscribe-path-ship path]
      !!
    `this
  ::
  ++  on-peek
    |=  =path
    ^-  (unit (unit cage))
    ?+  path  ~
        [%x %fleet-snap @ ~]  ``noun+!>((~(has by fleet-snaps) i.t.t.path))
        [%x %fleets ~]        ``noun+!>((turn ~(tap by fleet-snaps) head))
        [%x %ships ~]         ``noun+!>((turn ~(tap by piers) head))
        [%x %pill ~]          ``pill+!>(pil)
        [%x %i @ @ @ @ @ *]
      ::   ship | scry path
      ::          care, ship, desk, time, path
      ::  scry into running virtual ships
      =/  who  (slav %p i.t.t.path)
      =/  pier  (~(get by piers) who)
      ?~  pier
        ~
      :^  ~  ~  %noun  !>
      (peek:(pe who) t.t.t.path)
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
=|  cards=(list card:agent:gall)
|_  hid=bowl:gall
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
    =.  snap  assembled
    ~&  pill-size=(met 3 (jam snap))
    ..abet-pe
  ::
  ::  store post-pill ship for later re-use
  ::
  ++  ahoy
    =?  fresh-piers  !(~(has by fresh-piers) who)
      %+  ~(put by fresh-piers)  who
      [pier-data (~(get ja unix-boths) who)]
    ..ahoy
  ::
  ::  restore post-pill ship for re-use
  ::
  ++  yaho
    =/  fresh  (~(got by fresh-piers) who)
    =.  pier-data  pier.fresh
    =.  boths.fresh  (flop boths.fresh)
    |-
    ?~  boths.fresh  ..yaho
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
    |=  ms=(list card:agent:gall)
    =.  this  (^emit-cards ms)
    ..abet-pe
  ::
  ::  Process the events in our queue.
  ::
  ++  plow
    |-  ^+  ..abet-pe
    ?:  =(~ next-events)
      ..abet-pe
    ?.  processing-events
      ..abet-pe
    =^  ue  next-events  ~(get to next-events)
    =/  poke-arm  (mox +23.snap)
    ?>  ?=(%0 -.poke-arm)
    =/  poke  p.poke-arm
    =.  tym  (max +(tym) now.hid)
    =/  poke-result  (mule |.((slum poke tym ue)))
    ?:  ?=(%| -.poke-result)
      %-  (slog >%aqua-crash< >guest=who< p.poke-result)
      $
    =.  snap  +.p.poke-result
    =.  ..abet-pe  (publish-event tym ue)
    =.  ..abet-pe
      ~|  ova=-.p.poke-result
      (handle-effects ;;((list ovum) -.p.poke-result))
    $
  ::
  ::  Peek
  ::
  ++  peek
    |=  p=*
    ::  grab scry axis from snapshot
    =/  res  (mox +22.snap)
    ?>  ?=(%0 -.res)
    =/  scry  p.res
    ::  get path from input
    =/  pax  (path p)
    ::  validate path
    ?>  ?=([@ @ @ @ *] pax)
    ::  alter timestamp to match %pyro fake-time
    =.  i.t.t.t.pax  (scot %da tym)
    ~&  >>  `path`pax
    ::  execute scry
    =/  pek  (slum scry [[~ ~] & pax])
    =+  ;;(res=(unit (cask)) pek)
    (bind res tail)
  ::
  ::  Wish
  ::
  ++  wish
    |=  txt=@t
    =/  res  (mox +10.snap)
    ?>  ?=(%0 -.res)
    =/  wish  p.res
    ~&  [who=who %wished (slum wish txt)]
    ..abet-pe
  ::
  ++  mox  |=(* (mock [snap +<] scry))
  ::
  ::  Start/stop processing events.  When stopped, events are added to
  ::  our queue but not processed.
  ::
  ++  start-processing-events  .(processing-events &)
  ++  stop-processing-events  .(processing-events |)
  ::
  ::  Handle all the effects produced by a single event.
  ::
  ++  handle-effects
    |=  effects=(list ovum)
    ^+  ..abet-pe
    ?~  effects
      ..abet-pe
    =.  ..abet-pe
      =/  sof  ((soft unix-effect) i.effects)
      ?~  sof
        ~?  aqua-debug=&  [who=who %unknown-effect i.effects]
        $(effects t.effects)  ::  XX this used to be ..abet-pe
      (publish-effect u.sof)
    $(effects t.effects)
  ::
  ::  Give effect to our subscribers
  ::
  ++  publish-effect
    |=  uf=unix-effect
    ^+  ..abet-pe
    =.  unix-effects  (~(add ja unix-effects) who uf)
    =.  unix-boths  (~(add ja unix-boths) who [%effect uf])
    ..abet-pe
  ::
  ::  Give event to our subscribers
  ::
  ++  publish-event
    |=  ute=unix-timed-event
    ^+  ..abet-pe
    =.  event-log  [ute event-log]
    =.  unix-events  (~(add ja unix-events) who ute)
    =.  unix-boths  (~(add ja unix-boths) who [%event ute])
    ..abet-pe
  --
::
++  this  .
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
  ^-  (quip card:agent:gall _state)
  ::
  ::  interecept %request effects to handle azimuth subscription
  ::
  ::  =.  this
  ::    %-  emit-cards
  ::    %-  zing
  ::    %+  turn  ~(tap by unix-effects)
  ::    |=  [=ship ufs=(list unix-effect)]
  ::    %+  murn  ufs
  ::    |=  uf=unix-effect
  ::    (router:aqua-azimuth our.hid ship uf azi.piers)
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
    :~  [%give %fact ~[/effect] %aqua-effect !>(`aqua-effect`[ship uf])]
        [%give %fact ~[/effect/[-.q.uf]] %aqua-effect !>(`aqua-effect`[ship uf])]
    ==
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
    %+  turn  ~(tap by unix-boths)
    |=  [=ship bo=(list unix-both)]
    =/  =path  /boths/(scot %p ship)
    [%give %fact ~[path] %aqua-boths !>(`aqua-boths`[ship (flop bo)])]
  ::
  [(flop cards) state]
::
++  emit-cards
  |=  ms=(list card:agent:gall)
  =.  cards  (weld ms cards)
  this
::
::  Run all events on all ships until all queues are empty
::
++  plow-all
  |-  ^+  this
  =/  who
    =/  pers  ~(tap by piers)
    |-  ^-  (unit ship)
    ?~  pers
      ~
    ?:  &(?=(^ next-events.q.i.pers) processing-events.q.i.pers)
      `p.i.pers
    $(pers t.pers)
  ~?  aqua-debug=|  plowing=who
  ?~  who
    this
  =.  this  abet-pe:plow:(pe u.who)
  $
::
::  Load a pill and assemble arvo.  Doesn't send any of the initial
::  events.
::
++  poke-pill
  |=  p=pill
  ^-  (quip card:agent:gall _state)
  ?<  ?=(%ivory -.p)
  =.  userspace-ova.p
    ::  if there is an azimuth-snapshot in the pill, we stub it out,
    ::  since it would interfere with aqua's azimuth simulation.
    ::
    ^+  userspace-ova.p
    %+  turn  userspace-ova.p
    |=  e=unix-event:pill-lib
    ^+  e
    ?.  ?=(%park -.q.e)   e
    ?.  ?=(%& -.yok.q.e)  e
    =-  e(q.p.yok.q -)
    ^-  (map path (each page lobe:clay))
    %-  ~(urn by q.p.yok.q.e)
    |=  [=path fil=(each page lobe:clay)]
    ^+  fil
    ?.  =(/app/azimuth/version-0/azimuth-snapshot path)  fil
    ?:  ?=(%| -.fil)  fil
    &+azimuth-snapshot+[%0 [0x0 0] *^state:naive ~ ~]
  =.  this  apex-aqua  =<  abet-aqua
  =.  pil  p
  ~&  lent=(met 3 (jam boot-ova.pil))
  =/  res=toon :: (each * (list tank))
    (mock [boot-ova.pil [2 [0 3] [0 2]]] scry)
  =.  fleet-snaps  ~
  ?-  -.res
      %0
    ~&  >  "successfully assembled pill"
    =.  assembled  +7.p.res
    =.  fresh-piers  ~
    this
  ::
      %1
    ~&  [%vere-blocked p.res]
    this
  ::
      %2
    ~&  %vere-fail
    %-  (slog p.res)
    this
  ==
::
::  Handle commands from CLI
::
::    Should put some thought into arg structure, maybe make a mark.
::
::    Should convert some of these to just rewrite into ++poke-events.
::
++  poke-noun
  |=  val=*
  ^-  (quip card:agent:gall _state)
  =.  this  apex-aqua  =<  abet-aqua
  ^+  this
  ?+  val  ~|(%bad-noun-arg !!)
      [%swap-files des=@tas]
    ::  %pyro must have a functional pill containing %base BEFORE
    ::  another desk can be added with this poke!
    =.  userspace-ova.pil
      :_  ~
      %-  unix-event:pill-lib
      ::  take all files from a userspace desk
      %+  %*(. file-ovum:pill-lib directories ~[/])
      des.val  /(scot %p our.hid)/[des.val]/(scot %da now.hid)
    =^  ms  state  (poke-pill pil)
    (emit-cards ms)
  ::
      [%wish hers=* p=@t]
    %+  turn-ships  ((list ship) hers.val)
    |=  [who=ship thus=_this]
    =.  this  thus
    (wish:(pe who) p.val)
  ::
      [%unpause-events hers=*]
    ::  =.  this  start-azimuth-timer
    %+  turn-ships  ((list ship) hers.val)
    |=  [who=ship thus=_this]
    =.  this  thus
    start-processing-events:(pe who)
  ::
      [%pause-events hers=*]
    ::  =.  this  stop-azimuth-timer
    %+  turn-ships  ((list ship) hers.val)
    |=  [who=ship thus=_this]
    =.  this  thus
    stop-processing-events:(pe who)
  ::
      [%clear-snap lab=@tas]
    =.  fleet-snaps  ~  ::  (~(del by fleet-snaps) lab.val)
    this
  ==
::
::  Apply a list of events tagged by ship
::
++  poke-aqua-events
  |=  events=(list aqua-event)
  ^-  (quip card:agent:gall _state)
  =.  this  apex-aqua  =<  abet-aqua
  %+  turn-events  events
  |=  [ae=aqua-event thus=_this]
  =.  this  thus
  ?-  -.ae
  ::
      %init-ship
    ?:  (~(has by fresh-piers) who:ae)
      ~&  [%aqua %cached-init +.ae]
      =.  this  abet-pe:yaho:[ae (pe who.ae)]
      (pe who.ae)
    =.  this  abet-pe:(publish-effect:(pe who.ae) [/ %sleep ~])
    =/  initted
      =<  plow
      %-  push-events:apex:(pe who.ae)
      ^-  (list unix-event)
      %-  zing
      :~
        :~  [/ %wack 0]  ::  eny
            :: [/ %verb `|]  :: possible verb
            :^  /  %wyrd  [~.nonce /aqua] :: dummy runtime version + nonce
            ^-  (list (pair term @))
            :~  zuse+zuse
                lull+lull
                arvo+arvo
                hoon+hoon-version
                nock+4
            ==
            [/ %whom who.ae]  ::  who
        ==
        ::
        kernel-ova.pil  :: load compiler
        ::
        :_  ~
        :^  /d/term/1  %boot  &
        [%fake who.ae]
        ::
        userspace-ova.pil  :: load os
        ::
        :*  [/b/behn/0v1n.2m9vh %born ~]
            [/i/http-client/0v1n.2m9vh %born ~]
            [/e/http-server/0v1n.2m9vh %born ~]
            [/e/http-server/0v1n.2m9vh %live 8.080 `8.445]
            [/a/newt/0v1n.2m9vh %born ~]
            [/d/term/1 %hail ~]
            ~
        ==
      ==
    =.  this
      abet-pe:ahoy:[ae initted]
    (pe who.ae)
  ::
      %pause-events
    stop-processing-events:(pe who.ae)
  ::
      %snap-ships
    =.  this
      %+  turn-ships  (turn ~(tap by piers) head)
      |=  [who=ship thus=_this]
      =.  this  thus
      (publish-effect:(pe who) [/ %kill ~])
    =.  fleet-snaps
      %+  ~(put by fleet-snaps)  lab.ae
      %-  malt
      %+  murn  hers.ae
      |=  her=ship
      ^-  (unit (pair ship pier))
      =+  per=(~(get by piers) her)
      ?~  per
        ~
      `[her u.per]
    ::  =.  this   stop-azimuth-timer
    =.  piers  *fleet
    (pe -.hers.ae)
  ::
      %restore-snap
    =.  this
      %+  turn-ships  (turn ~(tap by piers) head)
      |=  [who=ship thus=_this]
      =.  this  thus
      (publish-effect:(pe who) [/ %kill ~])
    =.  piers  (~(got by fleet-snaps) lab.ae)
    ::  =.  this   start-azimuth-timer
    =.  this
      %+  turn-ships  (turn ~(tap by piers) head)
      |=  [who=ship thus=_this]
      =.  this  thus
      (publish-effect:(pe who) [/ %restore ~])
    (pe ~bud)  ::  XX why ~bud?  need an example
  ::
      %event
    ~?  &(aqua-debug=| !?=(?(%belt %hear) -.q.ue.ae))
      raw-event=[who.ae -.q.ue.ae]
    ~?  &(debug=| ?=(%receive -.q.ue.ae))
      raw-event=[who.ae ue.ae]
    (push-events:(pe who.ae) [ue.ae]~)
  ==
::
::  Run a callback function against a list of ships, aggregating state
::  and plowing all ships at the end.
::
::    I think we should use patterns like this more often.  Because we
::    don't, here's some points to be aware.
::
::    `fun` must take `this` as a parameter, since it needs to be
::    downstream of previous state changes.  You could use `state` as
::    the state variable, but it muddles the code and it's not clear
::    whether it's better.  You could use the `_(pe)` core if you're
::    sure you'll never need to refer to anything outside of your pier,
::    but I don't think we can guarantee that.
::
::    The callback function must start with `=.  this  thus`, or else
::    you don't get the new state.  Would be great if you could hot-swap
::    that context in here, but we don't know where to put it unless we
::    restrict the callbacks to always have `this` at a particular axis,
::    and that doesn't feel right
::
++  turn-plow
  |*  arg=mold
  |=  [hers=(list arg) fun=$-([arg _this] _(pe))]
  |-  ^+  this
  ?~  hers
    plow-all
  =.  this
    abet-pe:plow:(fun i.hers this)
  $(hers t.hers, this this)
::
++  turn-ships   (turn-plow ship)
++  turn-events  (turn-plow aqua-event)
::
::  Check whether we have a snapshot
::
::
::  Trivial scry for mock
::
++  scry  |=([* *] ~)
--
