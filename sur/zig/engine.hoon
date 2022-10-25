/+  smart=zig-sys-smart, zink=zink-zink
|%
++  big  (bi:smart id:smart item:smart)  ::  merkle engine for state
++  pig  (bi:smart id:smart @ud)         ::                for nonces
::
+$  state   (merk:smart id:smart item:smart)
+$  nonces  (merk:smart address:smart @ud)
+$  chain   (pair state nonces)
::
+$  mempool  (set [hash=@ux txn=transaction:smart])   ::  transaction mempool
+$  memlist  (list [hash=@ux txn=transaction:smart])  ::  sorted mempool
::
+$  state-diff  state  ::  state transitions for one batch
::
::  The engine, at the top level, takes in a chain-state and mempool
::  and produces the resulting state-transition, shown below
::
+$  state-transition
  $:  =chain
      processed=memlist
      hits=(list (list hints:zink))
      =state-diff
      events=(list contract-event)
      burned=state
  ==
::
+$  state-transition-2
  $:  =chain
      processed=memlist
      modified=state
      burned=state
      events=(list contract-event)
  ==
::
+$  output
  $:  gas=@ud
      =errorcode:smart
      modified=state
      burned=state
      =events:smart
  ==
::
::  intermediate result in +farm
::
+$  hatchling
  $:  hits=(list hints:zink)
      state-diff=(unit state)
      burned=state
      events=(list contract-event)
      rem=@ud
      =errorcode:smart
  ==
::
::  intermediate result from +mill
::
+$  single-result
  $:  fee=@ud
      =chain
      burned=state
      =errorcode:smart
      hits=(list hints:zink)
      events=(list contract-event)
  ==
::
::  contract events are converted to this -- `txn` is txn hash
::
+$  contract-event  [contract=id:smart txn=@ux label=@tas =json]
--