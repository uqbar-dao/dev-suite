::  This agent simulates vere. Since we aren't sending messages
::  over a real network - just a virtual network, we need to simulate
::  all all networking and runtime. This includes packet routing (ames),
::  unix timers (behn), terminal drivers (dill), and http requests/
::  responses (iris/eyre).
::
/-  *pyro
/+  dbug, default-agent
::
%-  agent:dbug
^-  agent:gall
=<
|_  bowl=bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    hc    ~(. +> bowl)
    card  card:agent:gall
++  on-init
  ^-  (quip card _this)
  :_  this
  %+  turn
    :~  [/ames/restore /effect/restore]
        [/ames/send /effect/send]
        ::
        [/behn/sleep /effect/sleep]
        [/behn/restore /effect/restore]
        [/behn/doze /effect/doze]
        [/behn/kill /effect/kill]
        ::
        [/dill/blit /effect/blit]
        ::
        [/eyre/sleep /effect/sleep]
        [/eyre/restore /effect/restore]
        [/eyre/thus /effect/thus]
        [/eyre/kill /effect/kill]
        ::
    ==
  |=  [=wire =path]
  [%pass wire %agent [our.bowl %pyro] %watch path]
++  on-save  on-save:def
++  on-load  on-load:def
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  `this
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
  ::
      [%ames @ ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      =+  ef=!<([aqua-effect] q.cage.sign)
      ?+    -.q.ufs.ef  (on-agent:def wire sign)
          %restore  [(restore:ames:hc who.ef) this]
          %send     [(send:ames:hc now.bowl who.ef ufs.ef) this]
      ==
    ==
  ::
      [%behn @ ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      =+  ef=!<([aqua-effect] q.cage.sign)
      =^  cards  behn-piers
        ?+    -.q.ufs.ef  [~ behn-piers]
            %sleep    abet-pe:sleep:(behn:hc who.ef)
            %restore  abet-pe:restore:(behn:hc who.ef)
            %doze     abet-pe:(doze:(behn:hc who.ef) ufs.ef)
            %kill     `(~(del by behn-piers) who.ef)
        ==
      [cards this]
    ==
  ::
      [%dill %blit ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      =+  ef=!<([aqua-effect] q.cage.sign)
      ?>  ?=(%blit -.q.ufs.ef)
      [(blit:dill:hc ef) this]
    ==
  ::
      [%eyre @ ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      =+  ef=!<([aqua-effect] q.cage.sign)
      =^  cards  eyre-piers
        ?+    -.q.ufs.ef  [~ eyre-piers]
            %sleep    abet-pe:sleep:(eyre who.ef)
            %restore  abet-pe:restore:(eyre who.ef)
            %thus     abet-pe:(thus:(eyre who.ef) ufs.ef)
            %kill     `(~(del by eyre-piers) who.ef)
        ==
      [cards this]
    ==
  ==
::
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
::
=|  behn-piers=(map ship behn-pier)
=|  eyre-piers=(map ship eyre-pier)
|_  bowl=bowl:gall
++  ames
  |%
  ++  emit-aqua-events
    |=  aes=(list aqua-event)
    ^-  (list card:agent:gall)
    [%pass /aqua-events %agent [our.bowl %pyro] %poke %aqua-events !>(aes)]~
  ::
  ++  restore
    |=  who=@p
    ^-  (list card:agent:gall)
    %-  emit-aqua-events
    [%event who [/a/newt/0v1n.2m9vh %born ~]]~
  ::
  ++  send
    ::  XX unix-timed events need now
    |=  [now=@da sndr=@p way=wire %send lan=lane:^ames pac=@]
    ^-  (list card:agent:gall)
    =/  rcvr=ship  (lane-to-ship lan)
    =/  hear-lane  (ship-to-lane sndr)
    %-  emit-aqua-events
    [%event rcvr /a/newt/0v1n.2m9vh %hear hear-lane pac]~
  ::  +lane-to-ship: decode a ship from an aqua lane
  ::
  ::    Special-case one comet, since its address doesn't fit into a lane.
  ::
  ++  lane-to-ship
    |=  =lane:^ames
    ^-  ship
    ::
    ?-  -.lane
      %&  p.lane
      %|  =/  s  `ship``@`p.lane
          ?.  =(s 0xdead.beef.cafe)
            s
          ~bosrym-podwyl-magnes-dacrys--pander-hablep-masrym-marbud
    ==
  ::  +ship-to-lane: encode a lane to look like it came from .ship
  ::
  ::    Never shows up as a galaxy, because Vere wouldn't know that either.
  ::    Special-case one comet, since its address doesn't fit into a lane.
  ::
  ++  ship-to-lane
    |=  =ship
    ^-  lane:^ames
    :-  %|
    ^-  address:^ames  ^-  @
    ?.  =(ship ~bosrym-podwyl-magnes-dacrys--pander-hablep-masrym-marbud)
      ship
    0xdead.beef.cafe
  ::
  --
++  behn
  |=  who=ship
  =+  (~(gut by behn-piers) who *behn-pier)
  =*  pier-data  -
  =|  cards=(list card:agent:gall)
  |%
  ++  this  .
  ++  abet-pe
    ^-  (quip card:agent:gall _behn-piers)
    =.  behn-piers  (~(put by behn-piers) who pier-data)
    [(flop cards) behn-piers]
  ::
  ++  emit-cards
    |=  cs=(list card:agent:gall)
    %_(this cards (weld cs cards))
  ::
  ++  emit-aqua-events
    |=  aes=(list aqua-event)
    %-  emit-cards
    [%pass /aqua-events %agent [our.bowl %pyro] %poke %aqua-events !>(aes)]~
  ::
  ++  sleep
    ^+  ..abet-pe
    =<  ..abet-pe(pier-data *behn-pier)
    ?~  next-timer
      ..abet-pe
    cancel-timer
  ::
  ++  restore
    ^+  ..abet-pe
    =.  this
      %-  emit-aqua-events
      [%event who [/b/behn/0v1n.2m9vh %born ~]]~
    ..abet-pe
  ::
  ++  doze
    |=  [way=wire %doze tim=(unit @da)]
    ^+  ..abet-pe
    ?~  tim
      ?~  next-timer
        ..abet-pe
      cancel-timer
    ?~  next-timer
      (set-timer u.tim)
    (set-timer:cancel-timer u.tim)
  ::
  ++  set-timer
    |=  tim=@da
    ~?  debug=|  [who=who %setting-timer tim]
    =.  next-timer  `tim
    =.  this  (emit-cards [%pass /(scot %p who) %arvo %b %wait tim]~)
    ..abet-pe
  ::
  ++  cancel-timer
    ~?  debug=|  [who=who %cancell-timer (need next-timer)]
    =.  this
      (emit-cards [%pass /(scot %p who) %arvo %b %rest (need next-timer)]~)
    =.  next-timer  ~
    ..abet-pe
  ::
  ++  take-wake
    |=  [way=wire error=(unit tang)]
    ~?  debug=|  [who=who %aqua-behn-wake now.bowl error=error]
    =.  next-timer  ~
    =.  this
      %-  emit-aqua-events
      ?^  error
        ::  Should pass through errors to aqua, but doesn't
        ::
        %-  (slog leaf+"aqua-behn: timer failed" u.error)
        ~
      :_  ~
      ^-  aqua-event
      :+  %event  who
      [/b/behn/0v1n.2m9vh [%wake ~]]
    ..abet-pe
  --
++  dill
  |%
  ++  blit
    |=  [who=@p way=wire %blit blits=(list blit:^dill)]
    ^-  (list card:agent:gall)
    =/  last-line
      %+  roll  blits
      |=  [b=blit:^dill line=tape]
      ?-    -.b
          %lin  (tape p.b)
          %klr  (tape (zing (turn p.b tail)))
          %mor  ~&  "{<who>}: {line}"  ""
          %hop  line
          %bel  line
          %clr  ""
          %sag  ~&  [%save-jamfile-to p.b]  line
          %sav  ~&  [%save-file-to p.b]  line
          %url  ~&  [%activate-url p.b]  line
      ==
    ~?  !=(~ last-line)  last-line
    ~
  --
++  eyre
  |=  who=ship
  =+  (~(gut by eyre-piers) who *eyre-pier)
  =*  pier-data  -
  =|  cards=(list card:agent:gall)
  |%
  ++  this  .
  ++  abet-pe
    ^-  (quip card:agent:gall _eyre-piers)
    =.  eyre-piers  (~(put by eyre-piers) who pier-data)
    [(flop cards) eyre-piers]
  ::
  ++  emit-cards
    |=  cs=(list card:agent:gall)
    %_(this cards (weld cs cards))
  ::
  ++  emit-aqua-events
    |=  aes=(list aqua-event)
    %-  emit-cards
    [%pass /aqua-events %agent [our.bowl %pyro] %poke %aqua-events !>(aes)]~
  ::
  ++  sleep
    ^+  ..abet-pe
    ..abet-pe(pier-data *eyre-pier)
  ::
  ++  restore
    ^+  ..abet-pe
    =.  this
      %-  emit-aqua-events
      [%event who [/i/http/0v1n.2m9vh %born ~]]~
    ..abet-pe
  ::
  ++  thus
    |=  [way=wire %thus num=@ud req=(unit hiss:^eyre)]
    ^+  ..abet-pe
    ?~  req
      ?.  (~(has in http-requests) num)
        ..abet-pe
      ::  Eyre doesn't support cancelling HTTP requests from userspace,
      ::  so we remove it from our state so we won't pass along the
      ::  response.
      ::
      ~&  [who=who %aqua-eyre-cant-cancel-thus num=num]
      =.  http-requests  (~(del in http-requests) num)
      ..abet-pe
    ~&  [who=who %aqua-eyre-requesting u.req]
    =.  http-requests  (~(put in http-requests) num)
    =.  this
      %-  emit-cards  :_  ~
      :*  %pass
          /(scot %p who)/(scot %ud num)
          %arvo
          %i
          %request
          (hiss-to-request:html u.req)
          *outbound-config:iris
      ==
    ..abet-pe
  ::
  ::  Pass HTTP response back to virtual ship
  ::
  ++  take-sigh-httr
    |=  [way=wire res=httr:^eyre]
    ^+  ..abet-pe
    ?>  ?=([@ ~] way)
    =/  num  (slav %ud i.way)
    ?.  (~(has in http-requests) num)
      ~&  [who=who %ignoring-httr num=num]
      ..abet-pe
    =.  http-requests  (~(del in http-requests) num)
    =.  this
      (emit-aqua-events [%event who [/i/http/0v1n.2m9vh %receive num [%start [p.res q.res] r.res &]]]~)
    ..abet-pe
  ::
  ::  Got error in HTTP response
  ::
  ++  take-sigh-tang
    |=  [way=wire tan=tang]
    ^+  ..abet-pe
    ?>  ?=([@ ~] way)
    =/  num  (slav %ud i.way)
    ?.  (~(has in http-requests) num)
      ~&  [who=who %ignoring-httr num=num]
      ..abet-pe
    =.  http-requests  (~(del in http-requests) num)
    %-  (slog tan)
    ..abet-pe
  --
--
