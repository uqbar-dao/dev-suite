::
::  Tests for publish.hoon
::
/+  *test, *zig-sys-engine, smart=zig-sys-smart,
    *zig-sequencer, merk, bip32, bip39, ethereum
/*  smart-lib-noun  %noun  /lib/zig/sys/smart-lib/noun
/*  zink-cax-noun   %noun  /lib/zig/sys/hash-cache/noun
/*  publish-contract  %jam  /con/compiled/publish/jam
|%
::
::  constants / dummy info for mill
::
++  big  (bi:merk id:smart item:smart)   ::  merkle engine for granary
++  pig  (bi:merk id:smart @ud)          ::                for populace
++  town-id   0x0
++  fake-sig  [0 0 0]
++  eng
  %~  engine  engine
  :^    ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
    ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun)))
  %.n  %.n
::
::  fake data
::
++  miller  ^-  caller:smart
  [0x24c.23b9.8535.cd5a.0645.5486.69fb.afbf.095e.fcc0 1 0x0]  ::  zigs account not used
++  holder-1  0xd387.95ec.b77f.b88e.c577.6c20.d470.d13c.8d53.2169
++  holder-2  0xface.face.face.face.face.face.face.face.face.face
++  caller-1  ^-  caller:smart  [holder-1 1 (make-id:zigs holder-1)]
++  caller-2  ^-  caller:smart  [holder-2 1 (make-id:zigs holder-2)]
::
++  zigs
  |%
  ++  make-id
    |=  holder=id:smart
    (hash-data:smart zigs-contract-id:smart holder town-id `@`'zigs')
  ++  make-account
    |=  [holder=id:smart amt=@ud]
    ^-  item:smart
    :*  %&
        (make-id holder)
        zigs-contract-id:smart
        holder
        town-id
        `@`'zigs'  %account
        [amt ~ `@ux`'zigs-metadata-id' ~]

    ==
  --
::
++  trivial-nok  ^-  [bat=* pay=*]
  [bat=[8 [1 0 [0 0] 0 0] [1 [8 [1 0] [1 [1 0] 1 0] 0 1] 8 [1 0] [1 1 0 0 0 0 0] 0 1] 0 1] pay=[1 0]]
++  immutable-nok   ^-  [bat=* pay=*]
  [bat=[8 [1 0 [0 0] 0 0] [1 [8 [1 0] [1 [1 0] 1 0] 0 1] 8 [1 1.684.957.542 0] [1 8 [8 [9 22 0 62] 9 2 10 [6 0 29] 0 2] 6 [5 [1 0] 0 2] [11 [1.735.355.507 [1 0] [1 1.717.658.988] 7 [0 1] 8 [1 1 103 114 97 105 110 32 110 111 116 32 102 111 117 110 100 0] 9 2 0 1] 1 0 0 0 0 0] 11 [1.735.355.507 [1 0] [1 1.717.658.988] 7 [0 1] 8 [1 1 103 114 97 105 110 32 108 111 99 97 116 101 100 0] 9 2 0 1] [1 0] [1 0] [1 0] [1 0] [[1 2.036.573.977.734.092.974.463.363.948.310.374] [1 110] 8 [9 6.108 0 4.063] 9 2 10 [6 [7 [0 3] 1 30.837] 0 446] 0 2] 1 0] 0 1] 0 1] pay=[1 0]]
++  trivial-nok-upgrade  ^-  [bat=* pay=*]
  [bat=[8 [1 0 [0 0] 0 0] [1 [8 [1 0] [1 [1 0] 1 0] 0 1] 8 [1 0] [1 8 [8 [9 2.398 0 16.127] 9 2 10 [6 7 [0 3] 1 100] 0 2] 1 0 0 0 0 0] 0 1] 0 1] pay=[1 0]]
::
++  upgradable-id
  (hash-pact:smart id.p:publish-pact address:caller-1 town-id trivial-nok)
++  upgradable
  ^-  item:smart
  :*  %|
      upgradable-id
      id.p:publish-pact
      address:caller-1
      town-id
      trivial-nok
      ~
      ~
  ==
::
++  immutable-id
  (hash-pact:smart 0x0 address:caller-1 town-id immutable-nok)
++  immutable
  ^-  item:smart
  :*  %|
      immutable-id
      0x0
      address:caller-1
      town-id
      immutable-nok
      ~
      ~
  ==
::
++  publish-pact
  ^-  item:smart
  =/  code  (cue publish-contract)
  :*  %|
      0x1111.1111  ::  id
      0x1111.1111  ::  lord
      0x1111.1111  ::  holder
      town-id
      [-.code +.code]
      interface=~
      types=~
  ==
::
++  fake-state
  ^-  state
  %+  gas:big  *(merk:merk id:smart item:smart)
  %+  turn
    :~  publish-pact
        upgradable
        immutable
        (make-account:zigs holder-1 300.000.000)
        (make-account:zigs holder-2 300.000.000)
    ==
  |=(=item:smart [id.p.item item])
++  fake-chain
  ^-  chain
  [fake-state ~]
::
::  begin tests
::
++  test-deploy
  =/  =calldata:smart  [%deploy %.y trivial-nok-upgrade ~ ~]
  =/  =shell:smart
    [caller-1 ~ id.p:publish-pact [1 1.000.000] town-id %0]
  =/  tx=transaction:smart  [fake-sig calldata shell]
  =/  =output
    %~  intake  %~  eng  eng
      [miller town-id batch=1 eth-block-height=0]
    [fake-chain tx]
  ::
  =/  deployed-id
    (hash-pact:smart id.p:publish-pact address:caller-1 town-id trivial-nok-upgrade)
  =/  deployed-pact
    ^-  item:smart
    :*  %|
        deployed-id
        id.p:publish-pact
        address:caller-1
        town-id
        trivial-nok-upgrade
        ~
        ~
    ==
  ;:  weld
  ::  assert that our call went through
    (expect-eq !>(%0) !>(errorcode.output))
  ::  assert new contract grain was created properly
    (expect-eq !>(deployed-pact) !>((got:big modified.output deployed-id)))
  ==
::
++  test-deploy-immutable
  =/  =calldata:smart  [%deploy %.n trivial-nok-upgrade ~ ~]
  =/  =shell:smart
    [caller-1 ~ id.p:publish-pact [1 1.000.000] town-id 0]
  =/  tx=transaction:smart  [fake-sig calldata shell]
  =/  =output
    %~  intake  %~  eng  eng
      [miller town-id batch=1 eth-block-height=0]
    [fake-chain tx]
  ::
  =/  deployed-id
    (hash-pact:smart 0x0 address:caller-1 town-id trivial-nok-upgrade)
  =/  deployed-pact
    ^-  item:smart
    :*  %|
        deployed-id
        0x0
        address:caller-1
        town-id
        trivial-nok-upgrade
        ~
        ~
    ==
  ;:  weld
  ::  assert that our call went through
    (expect-eq !>(%0) !>(errorcode.output))
  ::  assert new contract grain was created properly
    (expect-eq !>(deployed-pact) !>((got:big modified.output deployed-id)))
  ==
::
++  test-upgrade
  =/  =calldata:smart  [%upgrade upgradable-id trivial-nok-upgrade]
  =/  =shell:smart
    [caller-1 ~ id.p:publish-pact [1 1.000.000] town-id 0]
  =/  tx=transaction:smart  [fake-sig calldata shell]
  =/  =output
    %~  intake  %~  eng  eng
      [miller town-id batch=1 eth-block-height=0]
    [fake-chain tx]
  ::
  =/  new-pact
    ^-  item:smart
    :*  %|
        upgradable-id
        id.p:publish-pact
        address:caller-1
        town-id
        trivial-nok-upgrade
        ~
        ~
    ==
  ;:  weld
  ::  assert that our call went through
    (expect-eq !>(%0) !>(errorcode.output))
  ::  assert new contract grain was created properly
    (expect-eq !>(new-pact) !>((got:big modified.output upgradable-id)))
  ==
::
++  test-upgrade-immutable
  =/  =calldata:smart  [%upgrade immutable-id trivial-nok-upgrade]
  =/  =shell:smart
    [caller-1 ~ id.p:publish-pact [1 1.000.000] town-id 0]
  =/  tx=transaction:smart  [fake-sig calldata shell]
  =/  =output
    %~  intake  %~  eng  eng
      [miller town-id batch=1 eth-block-height=0]
    [fake-chain tx]
  ::  assert that our call failed
  (expect-eq !>(%6) !>(errorcode.output))
::
++  test-upgrade-not-holder
  =/  =calldata:smart  [%upgrade immutable-id trivial-nok-upgrade]
  =/  =shell:smart
    [caller-2 ~ id.p:publish-pact [1 1.000.000] town-id 0]
  =/  tx=transaction:smart  [fake-sig calldata shell]
  =/  =output
    %~  intake  %~  eng  eng
      [miller town-id batch=1 eth-block-height=0]
    [fake-chain tx]
  ::  assert that our call failed
  (expect-eq !>(%6) !>(errorcode.output))
--
