::  %pyro-dojo
::  |start %zig %pyro-dojo
::  prints all fake-ship dojo outputs to your terminal
::
::::
  ::
/-  pyro
/+  default-agent, dbug
/$  blit-to-json  %blit  %json
|%
+$  card  card:agent:gall
--
%-  agent:dbug
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
::
++  on-init
  ^-  (quip card _this)
  :_  this
  [%pass /dojo-outputs %agent [our.bowl %pyro] %watch /effect/blit]~
::
++  on-save  on-save:def
++  on-load  on-load:def
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(src.bowl our.bowl)
  ?+    mark  (on-poke:def mark vase)
      %noun
    =/  action  !<(?([%sub ~] [%unsub ~]) vase)
    ?-    -.action
        %sub
      :_  this
      :~  [%pass /dojo-outputs %agent [our.bowl %pyro] %watch /effect/blit]
      ==
        %unsub
      :_  this
      :~  [%pass /dojo-outputs %agent [our.bowl %pyro] %leave ~]
      ==
    ==
  ==
::
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [%dojo-outputs ~]
    ?+    -.sign  (on-agent:def wire sign)
        %watch-ack
      ?~  p.sign
        ((slog '%pyro-sub: Subscribe succeeded!' ~) `this)
      ((slog '%pyro-sub: Subscribe failed!' ~) `this)
    ::
        %kick
      %-  (slog '%pyro-sub: Got kick, resubscribing...' ~)
      :_  this
      :~  [%pass /dojo-outputs %agent [src.bowl %pyro] %watch /effect/blit]
      ==
    ::
        %fact
      ?+    p.cage.sign  (on-agent:def wire sign)
          %aqua-effect
        =/  mblt  !<(aqua-effect:pyro q.cage.sign)
        ?>  ?=(%blit -.q.ufs.mblt)
        =*  blits  p.q.ufs.mblt
        |-
        ?~  blits  `this
        ?.  ?=(%lin -.i.blits)  $(blits t.blits)
        ~&  >  (tufa p.i.blits)
        $(blits t.blits)
      ==
    ==
  ==
::
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
