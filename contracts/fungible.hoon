::  fungible.hoon [UQ| DAO]
::
::  Fungible token implementation using the fungible standard in
::  lib/fungible. Any new token that wishes to use this standard
::  without any changes can be issued through this contract.
::
::  /+  *zig-sys-smart
/=  fungible  /contracts/lib/fungible
|_  =cart
++  write
  |=  act=action:sur:fungible
  ^-  chick
  ?-    -.act
    %give           (give:lib:fungible cart act)
    %take           (take:lib:fungible cart act)
    %take-with-sig  (take-with-sig:lib:fungible cart act)
    %set-allowance  (set-allowance:lib:fungible cart act)
    %mint           (mint:lib:fungible cart act)
    %deploy         (deploy:lib:fungible cart act)
  ==
::
++  read
  |_  =path
  ++  json
    ^-  ^json
    ?+    path  !!
        [%inspect @ ~]
      ?~  g=(scry (slav %ux i.t.path))  ~
      ?.  ?=(%& -.u.g)  ~
      ?^  acc=((soft account:sur:fungible) data.p.u.g)
        (account:enjs:lib:fungible u.acc)
      ?^  meta=((soft token-metadata:sur:fungible) data.p.u.g)
        (metadata:enjs:lib:fungible u.meta)
      ~
    ==
  ::
  ++  noun
    ~
  --
--
