/+  *zig-sys-smart
|_  =context
++  write
  |=  read-path=pith
  ^-  (quip call diff)
  =/  got-it=(unit *)
    (scry-contract 0x1234 read-path)
  `[~ ~ ~ [[;;(@tas (fall got-it %fail)) ~] ~]]
++  read
  |_  =pith
  ++  json
    ~
  ++  noun
    ~
  --
--
