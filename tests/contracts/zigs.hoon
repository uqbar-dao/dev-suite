::
::  tests for con/zigs.hoon
::
/+  *test, smart=zig-sys-smart, *zig-sys-engine, merk
/*  smart-lib-noun          %noun  /lib/zig/sys/smart-lib/noun
/*  zink-cax-noun           %noun  /lib/zig/sys/hash-cache/noun
/*  zigs-contract           %jam   /con/compiled/zigs/jam
|%
::
::  constants / dummy info for engine
::
++  big  (bi:merk id:smart item:smart)  ::  merkle engine for granary
++  pig  (bi:merk id:smart @ud)         ::                for populace
++  town-id    0x0
++  fake-sig   [0 0 0]
++  eng
  %~  engine  engine
  :^  ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
    ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun)))
  %.n  %.n
::
::  fake data
::
::  separate addresses necessary to avoid circular definitions in zigs
++  address-1  0xd387.95ec.b77f.b88e.c577.6c20.d470.d13c.8d53.2169
++  caller-1  ^-  caller:smart
  [address-1 1 id.p:account-1:zigs]
++  address-2  0x75f.da09.d4aa.19f2.2cad.929c.aa3c.aa7c.dca9.5902
++  caller-2  ^-  caller:smart
  [address-2 1 id.p:account-2:zigs]
++  address-3  0xa2f8.28f2.75a3.28e1.3ba1.25b6.0066.c4ea.399d.88c7
++  caller-3  ^-  caller:smart
  [address-3 6 id.p:account-3:zigs]
::
++  zigs
  |%
  ++  pact
    ^-  item:smart
    =/  code  (cue zigs-contract)
    :*  %|
        zigs-contract-id:smart  ::  id
        zigs-contract-id:smart  ::  source
        zigs-contract-id:smart  ::  holder
        town-id
        [-.code +.code]
        ~
        ~
    ==
  ++  account-1
    ^-  item:smart
    =/  allowances
      (make-pmap:smart ~[[address-2 10.000]])
    :*  %&
        (hash-data:smart zigs-contract-id:smart address-1 town-id `@`'zigs')
        zigs-contract-id:smart
        address-1
        town-id
        `@`'zigs'
        %account
        [300.000.000 allowances `@ux`'zigs-metadata' ~]
    ==
  ++  account-2
    ^-  item:smart
    :*  %&
        (hash-data:smart zigs-contract-id:smart address-2 town-id `@`'zigs')
        zigs-contract-id:smart
        address-2
        town-id
        `@`'zigs'
        %account
        [200.000 ~ `@ux`'zigs-metadata' ~]
    ==
  ++  account-3
    ^-  item:smart
    :*  %&
        (hash-data:smart zigs-contract-id:smart address-3 town-id `@`'zigs')
        zigs-contract-id:smart
        address-3
        town-id
        `@`'zigs'
        %account
        [100.000 ~ `@ux`'zigs-metadata' ~]
    ==
  --
::
++  fake-state
  ^-  state
  %+  gas:big  *(merk:merk id:smart item:smart)
  :~  [id.p:pact pact]:zigs
      [id.p:account-1 account-1]:zigs
      [id.p:account-2 account-2]:zigs
      [id.p:account-3 account-3]:zigs
  ==
++  fake-chain
  ^-  chain
  [fake-state ~]
::
::  tests for %give
::
++  test-zz-zigs-give
  =/  =calldata:smart
    [%give address-2 1.000 id.p:account-1:zigs]
  =/  =shell:smart  [caller-1 ~ id.p:pact:zigs [1 1.000.000] town-id 0]
  =/  tx=transaction:smart  [fake-sig calldata shell]
  =/  =output
    %~  intake  %~  eng  eng
      [caller-1 town-id batch=1 eth-block-height=0]
    [fake-chain tx]
  ::
  (expect-eq !>(%0) !>(errorcode.output))
::
++  test-zy-zigs-give-new-address
  =/  =calldata:smart
    [%give 0xdead.beef 1.000 id.p:account-1:zigs]
  =/  =shell:smart  [caller-1 ~ id.p:pact:zigs [1 1.000.000] town-id 0]
  =/  tx=transaction:smart  [fake-sig calldata shell]
  =/  =output
    %~  intake  %~  eng  eng
      [caller-1 town-id batch=1 eth-block-height=0]
    [fake-chain tx]
  ::
  (expect-eq !>(%0) !>(errorcode.output))
::
++  test-zx-zigs-give-self  ::  should fail
  =/  =calldata:smart
    [%give address-1 1.000 id.p:account-1:zigs]
  =/  =shell:smart  [caller-1 ~ id.p:pact:zigs [1 1.000.000] town-id 0]
  =/  tx=transaction:smart  [fake-sig calldata shell]
  =/  =output
    %~  intake  %~  eng  eng
      [caller-1 town-id batch=1 eth-block-height=0]
    [fake-chain tx]
  ::
  ~&  >  output
  (expect-eq !>(%6) !>(errorcode.output))
::
++  test-zw-zigs-give-too-much  ::  should fail
  =/  =calldata:smart
    [%give address-2 500.000.000 id.p:account-1:zigs]
  =/  =shell:smart  [caller-1 ~ id.p:pact:zigs [1 1.000.000] town-id 0]
  =/  tx=transaction:smart  [fake-sig calldata shell]
  =/  =output
    %~  intake  %~  eng  eng
      [caller-1 town-id batch=1 eth-block-height=0]
    [fake-chain tx]
  ::
  (expect-eq !>(%6) !>(errorcode.output))
::
::  tests for %take
::
++  test-yz-zigs-take
  =/  =calldata:smart
    [%take address-3 1.000 id.p:account-1:zigs]
  =/  =shell:smart  [caller-2 ~ id.p:pact:zigs [1 50.000] town-id 0]
  =/  tx=transaction:smart  [fake-sig calldata shell]
  =/  =output
    %~  intake  %~  eng  eng
      [caller-1 town-id batch=1 eth-block-height=0]
    [fake-chain tx]
  ::
  (expect-eq !>(%0) !>(errorcode.output))
::
++  test-yy-zigs-take-no-allowance  ::  should fail
  =/  =calldata:smart
    [%take address-3 1.000 id.p:account-2:zigs]
  =/  =shell:smart  [caller-1 ~ id.p:pact:zigs [1 1.000.000] town-id 0]
  =/  tx=transaction:smart  [fake-sig calldata shell]
  =/  =output
    %~  intake  %~  eng  eng
      [caller-1 town-id batch=1 eth-block-height=0]
    [fake-chain tx]
  ::
  (expect-eq !>(%6) !>(errorcode.output))
::
::  tests for %set-allowance
::
++  test-xz-set-allowance
  =/  =calldata:smart
    [%set-allowance address-3 1.000 id.p:account-1:zigs]
  =/  =shell:smart  [caller-1 ~ id.p:pact:zigs [1 1.000.000] town-id 0]
  =/  tx=transaction:smart  [fake-sig calldata shell]
  =/  =output
    %~  intake  %~  eng  eng
      [caller-1 town-id batch=1 eth-block-height=0]
    [fake-chain tx]
  ::
  (expect-eq !>(%0) !>(errorcode.output))
::
++  test-xy-set-allowance-again
  =/  =calldata:smart
    [%set-allowance address-2 0 id.p:account-1:zigs]
  =/  =shell:smart  [caller-1 ~ id.p:pact:zigs [1 1.000.000] town-id 0]
  =/  tx=transaction:smart  [fake-sig calldata shell]
  =/  =output
    %~  intake  %~  eng  eng
      [caller-1 town-id batch=1 eth-block-height=0]
    [fake-chain tx]
  ::
  (expect-eq !>(%0) !>(errorcode.output))
::
++  test-xx-set-allowance-self  ::  should fail
  =/  =calldata:smart
    [%set-allowance address-1 1.000 id.p:account-1:zigs]
  =/  =shell:smart  [caller-1 ~ id.p:pact:zigs [1 1.000.000] town-id 0]
  =/  tx=transaction:smart  [fake-sig calldata shell]
  =/  =output
    %~  intake  %~  eng  eng
      [caller-1 town-id batch=1 eth-block-height=0]
    [fake-chain tx]
  ::
  (expect-eq !>(%6) !>(errorcode.output))
::
--