/=  smart  /lib/zig/sys/smart
::
::  get all items with contract source=zigs
^-  (map @ux item:smart)
=*  source=@ux  0x74.6361.7274.6e6f.632d.7367.697a
%-  ~(gas by *(map @ux item:smart))
%+  murn  ~(tap by p:chain:(~(got by -) 0x0))
|=  [id=@ux @ =item:smart]
?.  =(source source.p.item)  ~
`[id item]
