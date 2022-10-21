::  fungible.hoon [UQ| DAO]
::
::  Fungible token implementation using the fungible standard in
::  lib/fungible. Any new token that wishes to use this standard
::  without any changes can be issued through this contract.
::
/+  *zig-sys-smart
/=  fungible  /con/lib/fungible
=,  fungible
|_  =context
++  write
  |=  act=action:sur
  ^-  (quip call diff)
  ?-  -.act
    %give           (give:lib context act)
    %take           (take:lib context act)
    %take-with-sig  (take-with-sig:lib context act)
    %set-allowance  (set-allowance:lib context act)
    %mint           (mint:lib context act)
    %deploy         (deploy:lib context act)
  ==
::
++  read
  |_  =path
  ++  json
    ^-  ^json
    ?+    path  !!
        [%inspect @ ~]
      ?~  i=(scry-state (slav %ux i.t.path))  ~
      ?.  ?=(%& -.u.i)  ~
      ?^  acc=((soft account:sur) noun.p.u.i)
        (account:enjs:lib u.acc)
      ?^  meta=((soft token-metadata:sur) noun.p.u.i)
        (metadata:enjs:lib u.meta)
      ~
    ==
  ::
  ++  noun
    ~
  --
--
