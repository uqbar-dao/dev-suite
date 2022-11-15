::
::  Test of contract scry reads
::
/+  *test, *zig-sys-engine, smart=zig-sys-smart,
    *zig-sequencer, merk, bip32, bip39, ethereum
/*  smart-lib-noun  %noun  /lib/zig/sys/smart-lib/noun
/*  zink-cax-noun   %noun  /lib/zig/sys/hash-cache/noun
/*  trivial-signature-verify  %jam  /con/compiled/trivial-signature-verify/jam
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
  :^  ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
    ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun)))
  %.n  %.n
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
++  sig-pact
  ^-  pact:smart
  :*  0x5678  ::  id
      0x5678  ::  lord
      0x5678  ::  holder
      town-id
      [- +]:(cue trivial-signature-verify)
      interface=~
      types=~
  ==
::
++  fake-state
  ^-  state
  %+  gas:big  *(merk:merk id:smart item:smart)
  :~  [id:sig-pact [%| sig-pact]]
      [id.p:account-1:zigs account-1:zigs]
  ==
++  fake-chain
  ^-  chain
  [fake-state ~]
::
::  begin tests
::
++  test-read
  ::  generate an address and create a signed message
  =+  mnem=(from-entropy:bip39 [32 'entropy'])
  =+  core=(from-seed:bip32 [64 (to-seed:bip39 mnem "password")])
  =+  addr=(address-from-prv:key:ethereum private-key:core)
  =+  to-sign=`@ux`'this is a message hash'
  =/  sig=[@ @ @]
    (ecdsa-raw-sign:secp256k1:secp:crypto `@uvI`to-sign private-key:core)
  =/  =calldata:smart  [%signed to-sign sig]
  =/  =shell:smart     [caller-1 ~ id:sig-pact [1 1.000.000] town-id %0]
  =/  tx=transaction:smart  [fake-sig calldata shell]
  =/  =output
    %~  intake  %~  eng  eng
      [miller town-id batch=1 eth-block-height=0]
    [fake-chain tx]
  ::
  ~&  >  "events: {<events.output>}"
  =/  recovered
    %+  slav  %ux
    ;;(@t +.json:(head events.output))
  ;:  weld
    (expect-eq !>(%0) !>(errorcode.output))
    (expect-eq !>(addr) !>(recovered))
  ==
--
