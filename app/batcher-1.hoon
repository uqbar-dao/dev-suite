/-  sequencer
/+  default-agent, dbug, verb
|%
+$  card  card:agent:gall
+$  state-0
  $:  %0
      interval=@dr
  ==
--
::
::  This agent allows you to set an interval at which your sequencer app should produce a batch.
::  Poke like so: `:batcher-1 ~s30` to trigger a batch every 30 seconds.
::
=|  state-0
=*  state  -
%-  agent:dbug
%+  verb  |
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ~|  "%batcher: wasn't poked with valid @dr"
  =/  new-interval  !<(@dr vase)
  ~&  >  "%batcher set at {<now.bowl>}"
  =/  wait  (add now.bowl new-interval)
  :_  this(interval new-interval)
  [%pass /batch-timer %arvo %b %wait wait]~
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?>  ?=([%batch-timer ~] wire)
  =/  wait  (add now.bowl interval)
  :_  this
  :~  [%pass /batch-timer %arvo %b %wait wait]
      =-  [%pass /seq-poke %agent [our.bowl %sequencer] %poke -]
      [%sequencer-town-action !>(`town-action:sequencer`[%trigger-batch ~])]
  ==
::
++  on-init   `this(state [%0 ~m1])
++  on-save   !>(state)
++  on-load
  |=  =old=vase
  `this(state !<(state-0 old-vase))
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent  on-agent:def
++  on-fail   on-fail:def
--