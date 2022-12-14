::  trivial.hoon [UQ| DAO]
/+  *zig-sys-smart
|_  =context
++  write
  |=  act=*
  ^-  (quip call diff)
  =/  [hash=@ sig=[v=@ r=@ s=@]]
    +:;;([%signed @ @ @ @] act)
  =/  result=address
    %-  address-from-pub
    %-  serialize-point:secp256k1:secp:crypto
    %+  ecdsa-raw-recover:secp256k1:secp:crypto
    hash  sig
  `[~ ~ ~ [[%recovered s+(scot %ux result)]]~]
::
++  read
  |_  =pith
  ++  json
    ~
  ::
  ++  noun
    ~
  --
--
