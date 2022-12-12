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
  :: :-  [%pass /connect %arvo %e %connect [~ /apps/pyro] %pyro]
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
        [/iris/request /effect/request]
        [/iris/cancel-request /effect/cancel-request]
        [/iris/http-response /effect/http-response]
        [/iris/sleep /effect/sleep]
        [/iris/restore /effect/restore]
        [/iris/kill /effect/kill]
    ==
  |=  [=wire =path]
  [%pass wire %agent [our.bowl %pyro] %watch path]
++  on-save  on-save:def
++  on-load  on-load:def
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  `this
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
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
            %sleep    abet:sleep:(behn:hc who.ef)
            %doze     abet:(doze:(behn:hc who.ef) ufs.ef)
            ::  note that %restore and %kill are pyro, not behn, events
            %restore  abet:restore:(behn:hc who.ef)
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
      [%iris @ ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      =+  ef=!<([aqua-effect] q.cage.sign)
      =^  cards  iris-piers
        ?+  -.q.ufs.ef  [~ iris-piers]
          %request         abet:(request:(iris:hc who.ef) ufs.ef)
          %cancel-request  abet:cancel-request:(iris:hc who.ef)
          %http-response   abet:http-response:(iris:hc who.ef)
          %sleep           abet:sleep:(iris:hc who.ef)
          %restore         abet:restore:(iris:hc who.ef)
          %kill            `(~(del by iris-piers) who.ef)
        ==
      [cards this]
    ==
  ==
::
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  ~
      [%x %behn-piers ~]  ``noun+!>(`_behn-piers`behn-piers)
      [%x %soonest-timer ~]
    :^  ~  ~  %noun
    !>  ^-  (unit @da)
    %-  ~(rep by behn-piers)
    |=  [[@ timer=(unit @da)] soonest=(unit @da)]
    ?~  soonest  timer
    ?~  timer    soonest
    ?:((lth u.soonest u.timer) soonest timer)
  ==
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?+    -.sign-arvo  (on-arvo:def)
      %behn
    ?>  ?=([%behn %wake *] sign-arvo)
    ?>  ?=([@ *] wire)
    =/  who  (,@p (slav %p i.wire))
    =^  cards  behn-piers
      abet:(take-wake:(behn:hc who) t.wire error.sign-arvo)
    [cards this]
  ::
      %iris
    ?>  ?=([%iris %http-response %finished *] sign-arvo)
    ?+    wire  (on-arvo:def)
        [@ @ ~]
      =/  who=@p    (slav %p i.wire)
      =/  num=@ud   (slav %ud i.t.wire)
      =*  response-header  response-header.client-response.sign-arvo
      =*  full-file        full-file.client-response.sign-arvo
      =^  cards  iris-piers
        =<  abet
        %^    take-sigh-httr:(iris:hc who)
            num
          response-header
        ?~(full-file ~ `data.u.full-file)
      [cards this]
    ==
    ::
        %eyre
    ~&  >  wire
    ~&  >  sign-arvo
    `this
  ==
::
++  on-fail   on-fail:def
--
::
=|  behn-piers=(map ship behn-pier)
=|  iris-piers=(map ship iris-pier)
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
  ++  abet
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
    ^+  ..abet
    =<  ..abet(pier-data *behn-pier)
    ?~  next-timer
      ..abet
    cancel-timer
  ::
  ++  restore
    ^+  ..abet
    =.  this
      %-  emit-aqua-events
      [%event who [/b/behn/0v1n.2m9vh %born ~]]~
    ..abet
  ::
  ++  doze
    |=  [way=wire %doze tim=(unit @da)]
    ^+  ..abet
    ?~  tim
      ?~  next-timer
        ..abet
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
    ..abet
  ::
  ++  cancel-timer
    ~?  debug=|  [who=who %cancell-timer (need next-timer)]
    =.  this
      (emit-cards [%pass /(scot %p who) %arvo %b %rest (need next-timer)]~)
    =.  next-timer  ~
    ..abet
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
    ..abet
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
          %hop  ""
          %bel  line
          %clr  ""
          %sag  ~&  [%save-jamfile-to p.b]  line
          %sav  ~&  [%save-file-to p.b]  line
          %url  ~&  [%activate-url p.b]  line
      ==
    ~?  !=(~ last-line)  last-line
    ~
  --
++  iris
  ::  :pyro|dojo ~nec "|pass [%i %request [%'GET' 'https://google.com' ~ ~] *outbound-config:iris]"
  ::  :pyro|dojo ~nec "|pass [%i %cancel-request ~]"
  ::  
  |=  who=ship
  =+  (~(gut by iris-piers) who *iris-pier)
  =*  pier-data  -
  =|  cards=(list card:agent:gall)
  |%
  ++  this  .
  ::
  ++  abet
    ^-  (quip card:agent:gall _iris-piers)
    =.  iris-piers  (~(put by iris-piers) who pier-data)
    [(flop cards) iris-piers]
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
    ^+  ..abet
    ..abet(pier-data *iris-pier)
  ::
  ++  restore
    ^+  ..abet
    =.  this
      %-  emit-aqua-events
      [%event who [/i/http/0v1n.2m9vh %born ~]]~
      ..abet
  ::
  ++  request
    |=  [way=wire %request id=@ud req=request:http]
    ^+  ..abet
    =.  http-requests  (~(put in http-requests) id)
    =.  this
      %-  emit-cards  :_  ~
      :*  %pass
          /(scot %p who)/(scot %ud id)
          %arvo  %i
          %request  req  *outbound-config:^iris
      ==
    ..abet
  ++  cancel-request
    ..abet
  ::
  ++  http-response
    ..abet
  ::
  ::  Pass HTTP response back to virtual ship
  ::
  ++  take-sigh-httr
    |=  [num=@ud =response-header:http data=(unit octs)]
    ^+  ..abet
    ?.  (~(has in http-requests) num)
      ~&  [who=who %ignoring-httr num=num]
      ..abet
    =.  http-requests  (~(del in http-requests) num)
    =.  this
      %-  emit-aqua-events
      :_  ~
      :*  %event  who  /i/http/0v1n.2m9vh
          %receive  num
          %start  response-header  data  &
      ==
    ..abet
  ::
  ::  Got error in HTTP response
  ::
  :: ++  take-sigh-tang
  ::   |=  [way=wire tan=tang]
  ::   ^+  ..abet
  ::   ?>  ?=([@ ~] way)
  ::   =/  num  (slav %ud i.way)
  ::   ?.  (~(has in http-requests) num)
  ::     ~&  [who=who %ignoring-httr num=num]
  ::     ..abet
  ::   =.  http-requests  (~(del in http-requests) num)
  ::   %-  (slog tan)
  ::   ..abet
  --
--
