/+  smart=zig-sys-smart, zink=zink-zink, merk
|%
++  big  (bi:merk id:smart grain:smart)  ::  merkle engine for granary
++  pig  (bi:merk id:smart @ud)          ::                for populace
::
+$  granary   (merk:merk id:smart grain:smart)
+$  populace  (merk:merk id:smart @ud)
+$  land      (pair granary populace)
::
+$  basket     (set [hash=@ux =egg:smart])   ::  transaction "mempool"
+$  carton     (list [hash=@ux =egg:smart])  ::  basket that's been prioritized
::
+$  diff   granary  ::  state transitions for one batch
+$  burns  granary  ::  destroyed state with destination town set in-grain
::
::  final result of +mill-all
::
+$  state-transition
  $:  =land
      processed=carton
      hits=(list (list hints:zink))
      =diff
      crows=(list crow:smart)
      =burns
  ==
::
::  intermediate result in +farm
::
+$  hatchling
  $:  hits=(list hints:zink)
      diff=(unit granary)
      burned=granary
      =crow:smart
      rem=@ud
      =errorcode:smart
  ==
::
::  intermediate result from +mill
::
+$  mill-result
  $:  fee=@ud
      =land
      burned=granary
      =errorcode:smart
      hits=(list hints:zink)
      =crow:smart
  ==
--