::
::  Test of contract scry reads
::
/-  zink
/+  *test, smart=zig-sys-smart, *sequencer, merk
/*  smart-lib-noun  %noun  /lib/zig/sys/smart-lib/noun
/*  zink-cax-noun   %noun  /lib/zig/sys/hash-cache/noun
/*  trivial-read-contract  %noun  /con/compiled/trivial-read/noun
/*  trivial-read-source-contract  %noun  /con/compiled/trivial-read-source/noun
|%
::
::  constants / dummy info for mill
::
++  big  (bi:merk id:smart item:smart)  ::  merkle engine for granary
++  pig  (bi:merk id:smart @ud)          ::                for populace
++  shard-id   0x0
++  fake-sig  [0 0 0]
++  mil
  %~  mill  mill
  :+    ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
    ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun)))
  %.y
::
+$  single-result
  [fee=@ud =land burned=granary =errorcode:smart hits=(list hints:zink) =crow:smart]
::
::  fake data
::
++  miller  ^-  caller:smart
  [0x24c.23b9.8535.cd5a.0645.5486.69fb.afbf.095e.fcc0 1 0x0]  ::  zigs account not used
++  pubkey-1  0xd387.95ec.b77f.b88e.c577.6c20.d470.d13c.8d53.2169
++  caller-1  ^-  caller:smart  [pubkey-1 1 id.p:account-1:zigs]
::
++  zigs
  |%
  ++  account-1
    ^-  item:smart
    :*  %&
        `@`'zigs'
        %account
        [300.000.000 ~ `@ux`'zigs-metadata']
        (fry-data:smart zigs-contract-id:smart pubkey-1 shard-id `@`'zigs')
        zigs-contract-id:smart
        pubkey-1
        shard-id
    ==
  --
::
++  read-wheat
  ^-  pact:smart
  :*  `;;([bat=* pay=*] (cue +.+:;;([* * @] trivial-read-contract)))
      interface=~
      types=~
      0x5678  ::  id
      0x5678  ::  lord
      0x5678  ::  holder
      shard-id  ::  shard-id
  ==
::
++  read-source-wheat
  ^-  pact:smart
  :*  `;;([bat=* pay=*] (cue +.+:;;([* * @] trivial-read-source-contract)))
      interface=~
      types=~
      0x1234  ::  id
      0x1234  ::  lord
      0x1234  ::  holder
      shard-id   ::  shard-id
  ==
::
++  fake-granary
  ^-  granary
  %+  gas:big  *(merk:merk id:smart item:smart)
  :~  [id:read-wheat [%| read-wheat]]
      [id:read-source-wheat [%| read-source-wheat]]
      [id.p:account-1:zigs account-1:zigs]
  ==
++  fake-populace
  ^-  populace
  %+  gas:pig  *(merk:merk id:smart @ud)
  ~[[id:caller-1 0]]
++  fake-land
  ^-  land
  [fake-granary fake-populace]
::
::  begin tests
::
++  test-read
  =/  =calldata:smart  [%whatever ~]
  =/  shel=shell:smart
    [caller-1 ~ id:read-wheat 1 1.000.000 shard-id 0]
  =/  res=single-result
    %+  ~(mill mil miller shard-id 1)
      fake-land
    `transaction:smart`[fake-sig shel yolk]
  ::
  ~&  >  "crow: {<crow.res>}"
  ;:  weld
  ::  assert that our call went through
    %+  expect-eq
    !>(%0)  !>(errorcode.res)
  ==
--
