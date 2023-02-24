/=  wal  /sur/zig/wallet
::
::  get our held items
^-  (map @ux book:wal)
=/  who=@p  our:test-globals
=/  who-address=@ux
  %.  [%global [who %address]
  ~(got bi:mip configs:test-globals)
(~(got by tokens) who-address)
