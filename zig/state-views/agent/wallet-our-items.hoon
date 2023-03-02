/=  wal  /sur/zig/wallet
::
/=  mip  /lib/mip
::
::  get our held items
^-  book:wal
=/  who=@p  our:test-globals
=/  who-address=@ux
  %.  [%global [who %address]]
  ~(got bi:mip configs:test-globals)
(~(got by tokens) who-address)
