/=  mip    /lib/mip
/=  smart  /lib/zig/sys/smart
::
::  get all our held items
^-  (map @ux item:smart)
=*  who=@p  our:test-globals
=*  who-address=@ux
  %.  [%global [who %address]]
  ~(got bi:mip configs:test-globals)
%-  ~(gas by *(map @ux item:smart))
%+  murn  ~(tap by p:chain:(~(got by -) 0x0))
|=  [id=@ux @ =item:smart]
?.  =(who-address holder.p.item)  ~
`[id item]
