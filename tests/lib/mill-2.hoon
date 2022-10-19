::
::  Tests for lib/zig/mill.hoon
::  Basic goal: construct a simple town / helix state
::  and manipulate it with some calls to our zigs contract.
::  Mill should handle clearing a mempool populated by
::  calls and return an updated town. The zigs contract
::  should manage transactions properly so this is testing
::  the arms of that contract as well.
::
::  Tests here should cover:
::  (all calls to exclusively zigs contract)
::
::  * executing a single call with +mill
::  * executing same call unsuccessfully -- not enough gas
::  * unsuccessfully -- some constraint in contract unfulfilled
::  * (test all constraints in contract: balance, gas, +give, etc)
::  * executing multiple calls with +mill-all
::
/-  zink
/+  *test, smart=zig-sys-smart, seq=zig-sequencer, merk
/*  smart-lib-noun  %noun  /lib/zig/sys/smart-lib/noun
/*  zink-cax-noun   %noun  /lib/zig/sys/hash-cache/noun
/*  zigs-contract   %jam  /con/compiled/zigs-2/jam
|%
::
::  constants / dummy info for mill
::
++  big  (bi:merk id:smart item:smart)  ::  merkle engine for granary
++  pig  (bi:merk id:smart @ud)          ::                for populace
++  shard-id    0x0
++  set-fee    7
++  fake-sig   [0 0 0]
++  eng
  %~  engine  engine:seq
  :+    ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
    ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun)))
  %.y
::
::  fake data
::
++  sequencer
  ^-  caller:smart
  :+  0x24c.23b9.8535.cd5a.0645.5486.69fb.afbf.095e.fcc0
    1
  id.p:sequencer-account:zigs
++  caller-1  ^-  caller:smart  [holder-1:zigs 1 id.p:account-1:zigs]
++  caller-2  ^-  caller:smart  [holder-2:zigs 1 id.p:account-2:zigs]
++  caller-3  ^-  caller:smart  [holder-3:zigs 1 id.p:account-3:zigs]
::
++  zigs
  |%
  ++  holder-1  0xd387.95ec.b77f.b88e.c577.6c20.d470.d13c.8d53.2169
  ++  holder-2  0x75f.da09.d4aa.19f2.2cad.929c.aa3c.aa7c.dca9.5902
  ++  holder-3  0xa2f8.28f2.75a3.28e1.3ba1.25b6.0066.c4ea.399d.88c7
  ++  sequencer-account
    ^-  item:smart
    :*  %&
        (hash-data:smart zigs-contract-id:smart 0x24c.23b9.8535.cd5a.0645.5486.69fb.afbf.095e.fcc0 shard-id `@`'zigs')
        zigs-contract-id:smart
        0x24c.23b9.8535.cd5a.0645.5486.69fb.afbf.095e.fcc0
        shard-id
        `@`'zigs'
        %account
        [1.000.000 ~ `@ux`'zigs-metadata' 0]
    ==
  ++  account-1
    ^-  item:smart
    :*  %&
        (hash-data:smart zigs-contract-id:smart holder-1 shard-id `@`'zigs')
        zigs-contract-id:smart
        holder-1
        shard-id
        `@`'zigs'
        %account
        [300.000.000 ~ `@ux`'zigs-metadata' 0]
    ==
  ++  account-2
    ^-  item:smart
    :*  %&
        (hash-data:smart zigs-contract-id:smart holder-2 shard-id `@`'zigs')
        zigs-contract-id:smart
        holder-2
        shard-id
        `@`'zigs'
        %account
        [200.000 ~ `@ux`'zigs-metadata' 0]
    ==
  ++  account-3
    ^-  item:smart
    :*  %&
        (hash-data:smart zigs-contract-id:smart holder-3 shard-id `@`'zigs')
        zigs-contract-id:smart
        holder-3
        shard-id
        `@`'zigs'
        %account
        [100.000 ~ `@ux`'zigs-metadata' 0]
    ==
  ++  pact
    ^-  item:smart
    =/  code  (cue zigs-contract)
    :*  %|
        zigs-contract-id:smart  ::  id
        zigs-contract-id:smart  ::  source
        zigs-contract-id:smart  ::  holder
        shard-id
        [-.code +.code]
        ~
        ~
    ==
  --
::
::  ++  scry-pact
::    ^-  item:smart
::    =/  code  ;;([bat=* pay=*] (cue +.+:;;([* * @] scry-contract)))
::    =/  interface=lumps:smart  ~
::    =/  types=lumps:smart  ~
::    :*  %|
::        0xdada.dada  ::  id
::        0xdada.dada  ::  source
::        0xdada.dada  ::  holder
::        shard-id
::        code
::        interface
::        types
::    ==
::  ::
::  ++  temp-pact
::    ^-  item:smart
::    =/  cont  ;;([bat=* pay=*] (cue +.+:;;([* * @] temp-contract)))
::    =/  interface=lumps:smart  ~
::    =/  types=lumps:smart      ~
::    :*  %|
::        `cont
::        interface
::        types
::        0xcafe.cafe  ::  id
::        0xcafe.cafe  ::  source
::        0xcafe.cafe  ::  holder
::        shard-id
::    ==
::  ++  temp-grain
::    ^-  item:smart
::    :*  %&
::        `@`'loach'
::        %account
::        [300.000.000 ~ `@ux`'custom-token']
::        0x1111.2222.3333
::        0xcafe.cafe
::        `@ux`123.456.789
::        shard-id
::    ==
::
++  fake-state
  ^-  state:seq
  %+  gas:big  *(merk:merk id:smart item:smart)
  :~  ::  [id.p:scry-pact scry-pact]
      [id.p:pact:zigs pact:zigs]
      ::  [id.p:temp-pact temp-pact]
      ::  [id.p:temp-grain temp-grain]
      [id.p:account-1:zigs account-1:zigs]
      [id.p:account-2:zigs account-2:zigs]
      :: [id.p:sequencer-account:zigs sequencer-account:zigs]
  ==
++  fake-chain
  ^-  chain:seq
  [fake-state ~]
::
::  begin tests
::
++  test-engine-zigs-give
  =/  =calldata:smart  [%give holder-2:zigs 1.000 id.p:account-1:zigs `id.p:account-2:zigs]
  =/  shel=shell:smart
    [caller-1 ~ id.p:pact:zigs [1 1.000.000] shard-id 0]
  =/  res=single-result:seq
    %+  ~(execute-single eng sequencer shard-id batch=1 eth-block-height=0)
    fake-chain  [fake-sig calldata shel]
  ~&  >  "output: {<events.res>}"
  ~&  >  "fee: {<fee.res>}"
  ~&  >>  "diff:"
  ~&  p.chain.res
  ::  assert that our call went through
  %+  expect-eq
    !>(%0)
  !>(errorcode.res)
::
::  ++  test-mill-trivial-scry
::    =/  =calldata:smart  [%find id.p:account-1:zigs]
::    =/  shel=shell:smart
::      [caller-1 ~ id.p:scry-pact 1 1.000.000 shard-id 0]
::    =/  res=[fee=@ud =land burned=granary =errorcode:smart hits=(list) =crow:smart]
::      %+  ~(mill mil sequencer shard-id 1)
::      fake-land  `transaction:smart`[fake-sig shel yolk]
::    ~&  >  "output: {<crow.res>}"
::    ~&  >  "fee: {<fee.res>}"
::    ::  assert that our call went through
::    %+  expect-eq
::      !>(%0)
::    !>(errorcode.res)
::  ::
::  ++  test-mill-simple-burn
::    ::               id of grain to burn, destination town id
::    =/  =calldata:smart  [%burn id.p:account-1:zigs 0x2]
::    =/  shel=shell:smart
::      [caller-1 ~ 0x0 1 1.000.000 shard-id 0]
::    =/  res=[fee=@ud =land burned=granary =errorcode:smart hits=(list) =crow:smart]
::      %+  ~(mill mil sequencer shard-id 1)
::      fake-land  `transaction:smart`[fake-sig shel yolk]
::    ~&  >  "output: {<crow.res>}"
::    ~&  >  "fee: {<fee.res>}"
::    ::  assert that our call went through
::    ;:  weld
::      (expect-eq !>(%0) !>(errorcode.res))
::    ::
::      (expect-eq !>(1.000) !>(fee.res))
::    ::
::      (expect-eq !>(%.y) !>((has:big burned.res id.p:account-1:zigs)))
::    ==
--