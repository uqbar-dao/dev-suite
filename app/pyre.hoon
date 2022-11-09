/-  *pyro
/+  dbug, default-agent
::
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 ~]
+$  card  card:agent:gall
--
%-  agent:dbug
=|  state-0
=*  state  -
^-  agent:gall
=<
|_  bowl=bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    hc    ~(. +> bowl)
++  on-init
  ^-  (quip card _this)
  :_  this
  :~  :: ames
      [%pass /ames/restore %agent [our.bowl %pyro] %watch /effect/restore]
      [%pass /ames/send %agent [our.bowl %pyro] %watch /effect/send]
      :: dill
      [%pass /dill/blit %agent [our.bowl %pyro] %watch /effect/blit]
      :: eyre
      :: etc.
  ==
++  on-save  !>(state)
++  on-load
  |=  old-vase=vase
  ^-  (quip card _this)
  [~ this(state !<(state-0 old-vase))]
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  `this
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ::  ames
  ?+    wire  (on-agent:def wire sign)
  ::
      [%ames @ ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      ?>  ?=(%aqua-effect p.cage.sign)
      =/  ef  !<([aqua-effect] q.cage.sign)
      ?+    i.t.wire  !!
          %restore  [(ames-restore:hc who.ef) this]
      ::
          %send
        ?>  ?=(%send -.q.ufs.ef)
        [(ames-send:hc now.bowl who.ef ufs.ef) this]
      ==
    ==
  ::
      [%dill %blit ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      ?>  ?=(%aqua-effect p.cage.sign)
      =/  ef  !<([aqua-effect] q.cage.sign)
      ?>  ?=(%blit -.q.ufs.ef)
      [(handle-blit:hc ef) this]
    ==
  ==
::
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
|_  bowl=bowl:gall
++  emit-aqua-events
  |=  aes=(list aqua-event)
  ^-  (list card:agent:gall)
  [%pass /aqua-events %agent [our.bowl %aqua] %poke %aqua-events !>(aes)]~
::
++  ames-restore
  |=  who=@p
  ^-  (list card:agent:gall)
  %-  emit-aqua-events
  [%event who [/a/newt/0v1n.2m9vh %born ~]]~
::
++  ames-send
  ::  XX unix-timed events need now
  |=  [now=@da sndr=@p way=wire %send lan=lane:ames pac=@]
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
  |=  =lane:ames
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
  ^-  lane:ames
  :-  %|
  ^-  address:ames  ^-  @
  ?.  =(ship ~bosrym-podwyl-magnes-dacrys--pander-hablep-masrym-marbud)
    ship
  0xdead.beef.cafe
::
++  handle-blit
  |=  [who=@p way=wire %blit blits=(list blit:dill)]
  ^-  (list card:agent:gall)
  =/  last-line
    %+  roll  blits
    |=  [b=blit:dill line=tape]
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
