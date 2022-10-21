::  Start up a new indexer and sync its state to one that
::  is already running.
::
::  TODO:
::  * Generalize to take app-names for %indexer, %rollup,
::    etc, to allow for third-party versions of these apps.
::
/-  spider,
    uqbar
/+  strandio
::
=*  strand    strand:spider
=*  poke-our  poke-our:strandio
=*  scry      scry:strandio
=*  sleep     sleep:strandio
::
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=/  arg-mold
  $:  shard-id=@ux
      indexer-ship=ship
      sequencer-ship=ship
      rollup-ship=ship
  ==
=/  args  !<((unit arg-mold) arg)
?~  args
  ~&  >>>  "Usage:"
  ~&  >>>  "-zig!indexer-bootstrap shard-id indexer-ship sequencer-ship rollup-ship"
  (pure:m !>(~))
::
=*  shard-id         shard-id.u.args
=*  indexer-ship    indexer-ship.u.args
=*  sequencer-ship  sequencer-ship.u.args
=*  rollup-ship     rollup-ship.u.args
::
~&  >  "catching up to %indexer at {<indexer-ship>}..."
;<  ~  bind:m
  %^  poke-our  %indexer  %indexer-bootstrap
  !>(`dock`[indexer-ship %indexer])
::  hacky sleep to allow bootstrap to run before other pokes
::  TODO: replace hack with a more correct wait of some kind
::  TODO: check if just putting bootstrap after seq/rol fixes
::
;<  ~  bind:m  (sleep ~s10)
::
;<  batch-order=(list @ux)  bind:m
  %+  scry  (list @ux)
  /gx/indexer/batch-order/(scot %ux shard-id)/noun
~&  >  "indexer now has batch-order: {<batch-order>}"
~&  >  "subscribing to %sequencer at {<sequencer-ship>}..."
;<  ~  bind:m
  %^  poke-our  %indexer  %set-sequencer
  !>(`dock`[sequencer-ship %sequencer])
~&  >  "subscribing to %rollup at {<rollup-ship>}..."
;<  ~  bind:m
  %^  poke-our  %indexer  %set-rollup
  !>(`dock`[rollup-ship %rollup])
~&  >  "setting %uqbar source to our %indexer..."
;<  ~  bind:m
  %^  poke-our  %uqbar  %uqbar-action
  !>(`action:uqbar`[%set-sources [shard-id [indexer-ship]~]~])
~&  >  "done"
(pure:m !>(~))
