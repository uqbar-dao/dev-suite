/-  pyro
/+  default-agent, dbug
/$  blit-to-json  %blit  %json
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
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
::
++  on-init
  ^-  (quip card _this)
  `this
::
++  on-save
  ^-  vase
  !>(state)
::
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-state)
  ?-  -.old
    %0  `this(state old)
  ==
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
      :~  [%pass /meme %agent [our.bowl %pyro] %watch /effect/blit]
      ==
        %unsub
      :_  this
      :~  [%pass /meme %agent [our.bowl %pyro] %leave ~]
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
      [%meme ~]
    ?+    -.sign  (on-agent:def wire sign)
        %watch-ack
      ?~  p.sign
        ((slog '%pyro-sub: Subscribe succeeded!' ~) `this)
      ((slog '%pyro-sub: Subscribe failed!' ~) `this)
    ::
        %kick
      %-  (slog '%pyro-sub: Got kick, resubscribing...' ~)
      :_  this
      :~  [%pass /meme %agent [src.bowl %pyro] %watch /effect/blit]
      ==
    ::
        %fact
      ?+    p.cage.sign  (on-agent:def wire sign)
          %aqua-effect
        =/  meme  !<(aqua-effect:pyro q.cage.sign)
        :: ~&  >>  -.q.q.cage.sign :: ship
        ?>  ?=(%blit -.q.ufs.meme)
        =*  blits  p.q.ufs.meme
        |-
        ?~  blits  `this
        ?.  ?=(%lin -.i.blits)  $(blits t.blits)
        ~&  (tufa p.i.blits)
        $(blits t.blits)
      ==
    ==
  ==
::
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
