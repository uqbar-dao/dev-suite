/-  seq=zig-sequencer
/+  default-agent, dbug, verb
|%
+$  card  card:agent:gall
+$  state-0
  $:  %0
      active=?
      threshold=@ud
  ==
--
::
::  This agent allows you to trigger a sequencer batch after its mempool reaches a certain size.
::  It works by polling the sequencer's basket-size scry path every ~s30, and if the size is
::  above the threshold, triggering a batch.
::
::  To start, poke with (unit) threshold:
::  :batcher-interval `10
::
::  To stop, poke with empty unit:
::  :batcher-interval ~
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
  =/  new-threshold  !<((unit @ud) vase)
  ?~  new-threshold
    ~&  >>>  "%batcher inactive"
    `this(active %.n)
  ~&  >  "%batcher set to poll for batch-size={<new-threshold>} at {<now.bowl>}"
  =/  wait  (add now.bowl ~s30)
  :_  this(threshold u.new-threshold, active %.y)
  [%pass /batch-timer %arvo %b %wait wait]~
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?>  ?=([%batch-timer ~] wire)
  ?.  active  `this
  =/  wait  (add now.bowl ~s30)
  ::  check basket-size
  =/  mempool-size  .^(@ud %gx /(scot %p our.bowl)/sequencer/(scot %da now.bowl)/mempool-size/noun)
  ~&  >  "%batcher: scanning mempool...   current size: {<mempool-size>}"
  ::  compare to threshold
  ?.  (gte mempool-size threshold)
    ::  keep waiting
    :_  this
    [%pass /batch-timer %arvo %b %wait wait]~
  ::  at/above threshold, trigger batch
  :_  this
  :~  [%pass /batch-timer %arvo %b %wait wait]
      =-  [%pass /seq-poke %agent [our.bowl %sequencer] %poke -]
      [%sequencer-town-action !>(`town-action:seq`[%trigger-batch ~])]
  ==
::
++  on-init   `this(state [%0 %.n 1])
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
