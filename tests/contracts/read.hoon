::
::  Test of contract scry reads
::
/-  zink, engine=zig-engine
/+  *test, smart=zig-sys-smart, *zig-sequencer, merk
/*  smart-lib-noun  %noun  /lib/zig/sys/smart-lib/noun
/*  zink-cax-noun   %noun  /lib/zig/sys/hash-cache/noun
/*  trivial-read-contract  %jam  /con/compiled/trivial-read/jam
/*  trivial-read-source-contract  %jam  /con/compiled/trivial-read-source/jam
|%
::
::  constants / dummy info for mill
::
++  big  (bi:merk id:smart item:smart)  ::  merkle engine for state
++  pig  (bi:merk id:smart @ud)         ::                for nonces
++  town-id   0x0
++  fake-sig  [0 0 0]
++  eng
  %~  engine  engine
  :+    ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
    ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun)))
  %.y
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
        (hash-data:smart zigs-contract-id:smart pubkey-1 town-id `@`'zigs')
        zigs-contract-id:smart
        pubkey-1
        town-id
        `@`'zigs'
        %account
        [300.000.000 ~ `@ux`'zigs-metadata']
    ==
  --
::
++  read-pact
  ^-  pact:smart
  :*  0x5678  ::  id
      0x5678  ::  lord
      0x5678  ::  holder
      town-id
      [- +]:(cue trivial-read-contract)
      interface=~
      types=~
  ==
::
++  read-source-pact
  ^-  pact:smart
  :*  0x1234  ::  id
      0x1234  ::  lord
      0x1234  ::  holder
      town-id
      [- +]:(cue trivial-read-source-contract)
      interface=~
      types=~
  ==
::
++  fake-state
  ^-  state
  %+  gas:big  *(merk:merk id:smart item:smart)
  :~  [id:read-pact [%| read-pact]]
      [id:read-source-pact [%| read-source-pact]]
      [id.p:account-1:zigs account-1:zigs]
  ==
++  fake-chain
  ^-  chain
  [fake-state ~]
::
::  begin tests
::
++  test-read
  =/  =calldata:smart  [%read-me-for-free ~]
  =/  shel=shell:smart
    [caller-1 ~ id:read-pact [1 1.000.000] town-id %0]
  =/  res=single-result:engine
    %+  ~(run-single eng miller town-id 1 0)
      fake-chain
    `transaction:smart`[fake-sig calldata shel]
  ::
  ~&  >  "events: {<events.res>}"
  ;:  weld
  ::  assert that our call went through
    %+  expect-eq
    !>(%0)  !>(errorcode.res)
  ==
--
