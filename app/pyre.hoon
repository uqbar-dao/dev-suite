::  This agent simulates vere. This includes packet routing (ames),
::  unix timers (behn), terminal drivers (dill), and http requests/
::  responses (iris/eyre).
::
/-  *zig-pyro
/+  dbug, default-agent, pyre=pyro-pyre
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
  :-  [%pass / %arvo %e %connect `/pyro %pyre]
  (make-resub:pyre our.bowl)
::
++  on-save  on-save:def
++  on-load  |=(=vase (make-resub:pyre our.bowl)^this)
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(%handle-http-request mark)
  =+  !<([rid=@tas req=inbound-request:^eyre] vase)
  =^  who=ship  url.request.req
    (parse-url:pyre (trip url.request.req))
  :_  this
  abet:(pass-request:(eyre:hc ~nec) rid req)
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [%ames @ ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      =+  ef=!<([pyro-effect] q.cage.sign)
      ?>  ?=(%send -.q.ufs.ef)
      [(send:ames:hc now.bowl who.ef ufs.ef) this]
    ==
  ::
      [%behn @ ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      =+  ef=!<([pyro-effect] q.cage.sign)
      =^  cards  behn-piers
        ?+  -.q.ufs.ef  [~ behn-piers]
          %doze     abet:(doze:(behn:hc who.ef) ufs.ef)
          %kill     `(~(del by behn-piers) who.ef)
        ==
      [cards this]
    ==
  ::
      [%dill %blit ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      =+  ef=!<([pyro-effect] q.cage.sign)
      ?>  ?=(%blit -.q.ufs.ef)
      =+  out=(blit:dill:hc ef)
      ~?  !=(~ out)  out  
      `this
    ==
  ::
      [%eyre %response ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      =+  ef=!<([pyro-effect] q.cage.sign)
      ?>  ?=([@ @ ~] p.ufs.ef)
      =*  rid  i.t.p.ufs.ef
      =/  cards
        ?+    -.q.ufs.ef  ~
            %response
          ^-  (list card)
          =*  ev  http-event.q.ufs.ef
          ?-    -.ev
              %start
            :~  [%give %fact [/http-response/[rid]]~ %http-response-header !>([status-code.response-header.ev ~])] :: TODO for some reason headers suck
                [%give %fact [/http-response/[rid]]~ %http-response-data !>(data.ev)]
                [%give %kick [/http-response/[rid]]~ ~]
            ==
          ::
              %continue  ~  :: TODO
              %cancel    ~  :: TODO
          ==
        ==
      [cards this]
    ==
  ::
      [%iris @ ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      =+  ef=!<([pyro-effect] q.cage.sign)
      =^  cards  iris-piers
        ?+  -.q.ufs.ef  [~ iris-piers]
          %request  abet:(request:(iris:hc who.ef) ufs.ef)
          %kill     `(~(del by iris-piers) who.ef)
        ==
      [cards this]
    ==
  ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?>  ?=([%http-response *] path)
  `this
++  on-leave  on-leave:def
++  on-peek   on-peek:def
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
  ==
::
++  on-fail   on-fail:def
--
::
=|  behn-piers=(map ship behn-pier)
=|  iris-piers=(map ship iris-pier)
|_  bowl=bowl:gall
++  ames  ::  TODO should be in lib/pyre not helper core
  |%
  ++  emit-pyro-events
    |=  aes=(list pyro-event)
    ^-  (list card:agent:gall)
    [%pass /pyro-events %agent [our.bowl %pyro] %poke %pyro-events !>(aes)]~
  ::
  ++  send
    ::  XX unix-timed events need now
    |=  [now=@da sndr=@p way=wire %send lan=lane:^ames pac=@]
    ^-  (list card:agent:gall)
    =/  rcvr=ship  (lane-to-ship lan)
    =/  hear-lane  (ship-to-lane sndr)
    %-  emit-pyro-events
    [rcvr /a/newt/0v1n.2m9vh %hear hear-lane pac]~
  ::  +lane-to-ship: decode a ship from an pyro lane
  ::
  ++  lane-to-ship
    |=  =lane:^ames
    ^-  ship
    ::
    ?-  -.lane
      %&  p.lane
      %|  `ship``@`p.lane
    ==
  ::  +ship-to-lane: encode a lane to look like it came from .ship
  ::
  ::    Never shows up as a galaxy, because Vere wouldn't know that either.
  ::
  ++  ship-to-lane
    |=  =ship
    ^-  lane:^ames
    %|^`address:^ames``@`ship
  ::
  --
::
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
  ++  emit-pyro-events
    |=  aes=(list pyro-event)
    %-  emit-cards
    [%pass /pyro-events %agent [our.bowl %pyro] %poke %pyro-events !>(aes)]~
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
    ~?  debug=|  [who=who %pyro-behn-wake now.bowl error=error]
    =.  next-timer  ~
    =.  this
      %-  emit-pyro-events
      ?^  error
        ::  Should pass through errors to pyro, but doesn't
        ((slog leaf+"pyro-behn: timer failed" u.error) ~)
      [who /b/behn/0v1n.2m9vh [%wake ~]]~
    ..abet
  --
::
++  dill  :: TODO should be in lib/pyre not helper core
  |%
  ++  blit
    |=  [who=@p way=wire %blit blits=(list blit:^dill)]
    ^-  tape
    %+  roll  blits
    |=  [b=blit:^dill line=tape]
    ?-  -.b
      %bel  line
      %clr  ""
      %hop  ""
      %klr  (tape (zing (turn p.b tail)))
      %mor  (blit who way %blit p.b)
      %nel  ""
      %put  ~&  (weld "{<who>}: " (tufa p.b))  ""
      %sag  ~&  [%save-jamfile-to p.b]  line
      %sav  ~&  [%save-file-to p.b]     line
      %url  ~&  [%activate-url p.b]     line
      %wyp  ""
    ==
  --
::
++  eyre  :: TODO should just be in helpers - not in helper-core
  |=  who=ship
  =|  cards=(list card:agent:gall)
  |%
  ++  this  .
  ::
  ++  abet  (flop cards)
  ::
  ++  emit-cards
    |=  cs=(list card:agent:gall)
    %_(this cards (weld cs cards))
  ::
  ++  emit-pyro-events
    |=  aes=(list pyro-event)
    %-  emit-cards
    [%pass /pyro-events %agent [our.bowl %pyro] %poke %pyro-events !>(aes)]~
  ::
  ++  pass-request
    |=  [rid=@t req=inbound-request:^eyre]
    %-  emit-pyro-events
    [~nec /e/(scot %p who)/[rid] %request [secure address request]:req]~
  --
::
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
  ++  emit-pyro-events
    |=  aes=(list pyro-event)
    %-  emit-cards
    [%pass /pyro-events %agent [our.bowl %pyro] %poke %pyro-events !>(aes)]~
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
      %-  emit-pyro-events
      :_  ~
      :*  who  /i/http/0v1n.2m9vh
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
