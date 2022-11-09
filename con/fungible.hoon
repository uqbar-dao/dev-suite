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
    %pull           (pull:lib context act)
    %push           (push:lib context act)
    %set-allowance  (set-allowance:lib context act)
    %mint           (mint:lib context act)
    %deploy         (deploy:lib context act)
  ==
::
++  read
  |_  =pith
  ++  json
    ^-  ^json
    ?+    pith  !!
        [%inspect [%ux @ux] ~]
      ?~  i=(scry-state +.i.t.pith)  ~
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
