/+  smart=zig-sys-smart, zink=zink-zink
|%
++  big  (bi:smart id:smart item:smart)  ::  merkle engine for state
++  pig  (bi:smart id:smart @ud)         ::                for nonces
::
+$  state   (merk:smart id:smart item:smart)
+$  nonces  (merk:smart address:smart @ud)
+$  chain   (pair state nonces)
::
+$  mempool  (set [hash=@ux =transaction:smart])   ::  transaction mempool
+$  memlist  (list [hash=@ux =transaction:smart])  ::  sorted mempool
::
+$  state-diff  state  ::  state transitions for one batch
+$  burns       state  ::  destroyed state with destination shard set in-item
::
::  contract events are converted to this -- source is txn hash
::
+$  event  [contract=id:smart source=@ux label=@tas =json]
::
::  final result of +mill-all
::
+$  state-transition
  $:  =chain
      processed=memlist
      hits=(list (list hints:zink))
      =state-diff
      events=(list event)
      =burns
  ==
::
::  intermediate result in +farm
::
+$  hatchling
  $:  hits=(list hints:zink)
      state-diff=(unit state)
      =burns
      =events:smart
      rem=@ud
      =errorcode:smart
  ==
::
::  intermediate result from +mill
::
+$  mill-result
  $:  fee=@ud
      =chain
      burned=state
      =errorcode:smart
      hits=(list hints:zink)
      =events:smart
  ==
--