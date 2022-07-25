/+  *zig-sys-smart, zink=zink-zink
|%
+$  granary   (merk id grain)
+$  populace  (merk id @ud)
+$  land      (pair granary populace)
::
+$  basket     (set [hash=@ux =egg])   ::  transaction "mempool"
+$  carton     (list [hash=@ux =egg])  ::  basket that's been prioritized
::
+$  diff  granary  ::  state transitions for one batch
+$  state-transition
  $:  =land
      processed=(list [id egg])
      hits=(list (list hints:zink))
      =diff
      crows=(list crow)
      burns=granary
  ==
--