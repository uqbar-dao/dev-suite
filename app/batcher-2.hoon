/-  sequencer
/+  default-agent, dbug, verb
|%
+$  card  card:agent:gall
+$  state-0
  $:  %0
      threshold=@ud
  ==
--
::
::  This agent allows you to trigger a sequencer batch after its mempool reaches a certain size.
::  It works by polling the sequencer's basket-size scry path every ~s30, and if the size is
::  above the threshold, triggering a batch.
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
  ~|  "%batcher: wasn't poked with valid @ud"
  =/  new-threshold  !<(@ud vase)
  ~&  >  "%batcher set to poll for batch-size={<new-threshold>} at {<now.bowl>}"
  =/  wait  (add now.bowl ~s30)
  :_  this(threshold new-threshold)
  [%pass /batch-timer %arvo %b %wait wait]~
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?>  ?=([%batch-timer ~] wire)
  =/  wait  (add now.bowl ~s30)
  ::  check basket-size
  =/  basket-size  .^(@ud %gx /(scot %p our.bowl)/sequencer/(scot %da now.bowl)/basket-size/noun)
  ~&  >  "%batcher: scanning mempool...   current size: {<basket-size>}"
  ::  compare to threshold
  ?.  (gte basket-size threshold)
    ::  keep waiting
    :_  this
    [%pass /batch-timer %arvo %b %wait wait]~
  ::  at/above threshold, trigger batch
  :_  this
  :~  [%pass /batch-timer %arvo %b %wait wait]
      =-  [%pass /seq-poke %agent [our.bowl %sequencer] %poke -]
      [%sequencer-town-action !>(`town-action:sequencer`[%trigger-batch ~])]
  ==
::
++  on-init   `this(state [%0 1])
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