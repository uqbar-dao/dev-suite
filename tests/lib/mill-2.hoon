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
/+  *test, smart=zig-sys-smart, *sequencer, merk
/*  smart-lib-noun  %noun  /con/compiled/smart-lib/noun
/*  zink-cax-noun   %noun  /con/compiled/hash-cache/noun
/*  triv-contract   %noun  /con/compiled/trivial/noun
/*  scry-contract   %noun  /con/compiled/trivial-scry/noun
/*  zigs-contract   %noun  /con/compiled/zigs/noun
/*  temp-contract   %noun  /con/compiled/tester/noun
|%
::
::  constants / dummy info for mill
::
++  big  (bi:merk id:smart grain:smart)  ::  merkle engine for granary
++  pig  (bi:merk id:smart @ud)          ::                for populace
++  town-id    0x0
++  set-fee    7
++  fake-sig   [0 0 0]
++  mil
  %~  mill  mill
  :+    ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
    ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun)))
  %.y
::
+$  mill-result
  [fee=@ud =land burned=granary =errorcode:smart hits=(list hints:zink) =crow:smart]
::
::  fake data
::
++  miller
  ^-  caller:smart
  :+  0x24c.23b9.8535.cd5a.0645.5486.69fb.afbf.095e.fcc0
    1
  id.p:miller-account:zigs
++  caller-1  ^-  caller:smart  [holder-1:zigs 1 id.p:account-1:zigs]
++  caller-2  ^-  caller:smart  [holder-2:zigs 1 id.p:account-2:zigs]
++  caller-3  ^-  caller:smart  [holder-3:zigs 1 id.p:account-3:zigs]
::
++  zigs
  |%
  ++  holder-1  0xd387.95ec.b77f.b88e.c577.6c20.d470.d13c.8d53.2169
  ++  holder-2  0x75f.da09.d4aa.19f2.2cad.929c.aa3c.aa7c.dca9.5902
  ++  holder-3  0xa2f8.28f2.75a3.28e1.3ba1.25b6.0066.c4ea.399d.88c7
  ++  miller-account
    ^-  grain:smart
    :*  %&
        `@`'zigs'
        %account
        [1.000.000 ~ `@ux`'zigs-metadata']
        (fry-rice:smart zigs-wheat-id:smart 0x24c.23b9.8535.cd5a.0645.5486.69fb.afbf.095e.fcc0 town-id `@`'zigs')
        zigs-wheat-id:smart
        0x24c.23b9.8535.cd5a.0645.5486.69fb.afbf.095e.fcc0
        town-id
    ==
  ++  account-1
    ^-  grain:smart
    :*  %&
        `@`'zigs'
        %account
        [300.000.000 ~ `@ux`'zigs-metadata']
        (fry-rice:smart zigs-wheat-id:smart holder-1 town-id `@`'zigs')
        zigs-wheat-id:smart
        holder-1
        town-id
    ==
  ++  account-2
    ^-  grain:smart
    :*  %&
        `@`'zigs'
        %account
        [200.000 ~ `@ux`'zigs-metadata']
        (fry-rice:smart zigs-wheat-id:smart holder-2 town-id `@`'zigs')
        zigs-wheat-id:smart
        holder-2
        town-id
    ==
  ++  account-3
    ^-  grain:smart
    :*  %&
        `@`'zigs'
        %account
        [100.000 ~ `@ux`'zigs-metadata']
        (fry-rice:smart zigs-wheat-id:smart holder-3 town-id `@`'zigs')
        zigs-wheat-id:smart
        holder-3
        town-id
    ==
  ++  wheat
    ^-  grain:smart
    =/  cont  ;;([bat=* pay=*] (cue +.+:;;([* * @] zigs-contract)))
    =/  interface=lumps:smart  ~
    =/  types=lumps:smart  ~
    :*  %|
        `cont
        interface
        types
        zigs-wheat-id:smart  ::  id
        zigs-wheat-id:smart  ::  lord
        zigs-wheat-id:smart  ::  holder
        town-id
    ==
  --
::
++  scry-wheat
  ^-  grain:smart
  =/  cont  ;;([bat=* pay=*] (cue +.+:;;([* * @] scry-contract)))
  =/  interface=lumps:smart  ~
  =/  types=lumps:smart  ~
  :*  %|
      `cont
      interface
      types
      0xdada.dada  ::  id
      0xdada.dada  ::  lord
      0xdada.dada  ::  holder
      town-id
  ==
::
++  temp-wheat
  ^-  grain:smart
  =/  cont  ;;([bat=* pay=*] (cue +.+:;;([* * @] temp-contract)))
  =/  interface=lumps:smart  ~
  =/  types=lumps:smart      ~
  :*  %|
      `cont
      interface
      types
      0xcafe.cafe  ::  id
      0xcafe.cafe  ::  lord
      0xcafe.cafe  ::  holder
      town-id
  ==
++  temp-grain
  ^-  grain:smart
  :*  %&
      `@`'loach'
      %account
      [300.000.000 ~ `@ux`'custom-token']
      0x1111.2222.3333
      0xcafe.cafe
      `@ux`123.456.789
      town-id
  ==
::
++  fake-granary
  ^-  granary
  %+  gas:big  *(merk:merk id:smart grain:smart)
  :~  [id.p:scry-wheat scry-wheat]
      [id.p:wheat:zigs wheat:zigs]
      ::  [id.p:temp-wheat temp-wheat]
      ::  [id.p:temp-grain temp-grain]
      [id.p:account-1:zigs account-1:zigs]
      [id.p:account-2:zigs account-2:zigs]
      :: [id.p:miller-account:zigs miller-account:zigs]
  ==
++  fake-populace
  ^-  populace
  %+  gas:pig  *(merk:merk id:smart @ud)
  ~[[holder-1:zigs 0]] :: [holder-2:zigs 0] [holder-3:zigs 0]]
++  fake-land
  ^-  land
  [fake-granary fake-populace]
::
::  begin tests
::
++  test-mill-zigs-give
  =/  =yolk:smart  [%give holder-2:zigs 1.000 id.p:account-1:zigs `id.p:account-2:zigs]
  =/  shel=shell:smart
    [caller-1 ~ id.p:wheat:zigs 1 1.000.000 town-id 0]
  =/  res=[fee=@ud =land burned=granary =errorcode:smart hits=(list) =crow:smart]
    %+  ~(mill mil miller town-id 1)
    fake-land  `egg:smart`[fake-sig shel yolk]
  ~&  >  "output: {<crow.res>}"
  ~&  >  "fee: {<fee.res>}"
  ~&  >>  "diff:"
  ~&  p.land.res
  ::  assert that our call went through
  %+  expect-eq
    !>(%0)
  !>(errorcode.res)
::
++  test-mill-trivial-scry
  =/  =yolk:smart  [%find id.p:account-1:zigs]
  =/  shel=shell:smart
    [caller-1 ~ id.p:scry-wheat 1 1.000.000 town-id 0]
  =/  res=[fee=@ud =land burned=granary =errorcode:smart hits=(list) =crow:smart]
    %+  ~(mill mil miller town-id 1)
    fake-land  `egg:smart`[fake-sig shel yolk]
  ~&  >  "output: {<crow.res>}"
  ~&  >  "fee: {<fee.res>}"
  ::  assert that our call went through
  %+  expect-eq
    !>(%0)
  !>(errorcode.res)
::
++  test-mill-simple-burn
  ::               id of grain to burn, destination town id
  =/  =yolk:smart  [%burn id.p:account-1:zigs 0x2]
  =/  shel=shell:smart
    [caller-1 ~ 0x0 1 1.000.000 town-id 0]
  =/  res=[fee=@ud =land burned=granary =errorcode:smart hits=(list) =crow:smart]
    %+  ~(mill mil miller town-id 1)
    fake-land  `egg:smart`[fake-sig shel yolk]
  ~&  >  "output: {<crow.res>}"
  ~&  >  "fee: {<fee.res>}"
  ::  assert that our call went through
  ;:  weld
    (expect-eq !>(%0) !>(errorcode.res))
  ::
    (expect-eq !>(1.000) !>(fee.res))
  ::
    (expect-eq !>(%.y) !>((has:big burned.res id.p:account-1:zigs)))
  ==
--