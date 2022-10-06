::
::  Test of AMM contract
::
/-  zink
/+  *test, smart=zig-sys-smart, *sequencer, merk
/*  smart-lib-noun  %noun  /lib/zig/compiled/smart-lib/noun
/*  zink-cax-noun   %noun  /lib/zig/compiled/hash-cache/noun
/*  amm-contract    %noun  /lib/zig/contracts/uhoon-amm/compiled/amm/noun
/*  fungible-contract  %noun  /lib/zig/compiled/fungible/noun
|%
::
::  constants / dummy info for mill
::
++  big  (bi:merk id:smart grain:smart)  ::  merkle engine for granary
++  pig  (bi:merk id:smart @ud)          ::                for populace
++  town-id   0x0
++  fake-sig  [0 0 0]
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
++  miller  ^-  caller:smart
  [0x24c.23b9.8535.cd5a.0645.5486.69fb.afbf.095e.fcc0 1 0x0]  ::  zigs account not used
++  pubkey-1  0xd387.95ec.b77f.b88e.c577.6c20.d470.d13c.8d53.2169
++  caller-1  ^-  caller:smart  [pubkey-1 1 id.p:account-1:zigs]
::
++  zigs
  |%
  ++  account-1
    ^-  grain:smart
    :*  %&
        `@`'zigs'
        %account
        [300.000.000 ~ `@ux`'zigs-metadata']
        (fry-rice:smart zigs-wheat-id:smart pubkey-1 town-id `@`'zigs')
        zigs-wheat-id:smart
        pubkey-1
        town-id
    ==
  --
::
++  amm-wheat
  ^-  wheat:smart
  :*  `;;([bat=* pay=*] (cue +.+:;;([* * @] amm-contract)))
      interface=~
      types=~
      0xcafe  ::  id
      0xcafe  ::  lord
      0xcafe  ::  holder
      town-id  ::  town-id
  ==
::
++  fungible-wheat
  ^-  wheat:smart
  :*  `;;([bat=* pay=*] (cue +.+:;;([* * @] fungible-contract)))
      interface=~
      types=~
      0x1234  ::  id
      0x1234  ::  lord
      0x1234  ::  holder
      town-id   ::  town-id
  ==
::
++  cgy-token
  ^-  grain:smart
  =+  deployer=0x0
  =+  salt=`@`'cgy-token'
  :*  %&  salt  %metadata
      :*  name='CGY Token'
          'CGY'
          decimals=18
          supply=100.000.000.000.000.000.000
          cap=~
          mintable=%.n
          minters=~
          deployer
          salt
      ==
      `@ux`'cgy-metadata'
      id:fungible-wheat
      id:fungible-wheat
      town-id
  ==
++  ecs-token
  ^-  grain:smart
  =+  deployer=0x0
  =+  salt=`@`'ecs-token'
  :*  %&  salt  %metadata
      :*  name='ECS Token'
          'ECS'
          decimals=18
          supply=200.000.000.000.000.000.000
          cap=~
          mintable=%.n
          minters=~
          deployer
          salt
      ==
      `@ux`'ecs-metadata'
      id:fungible-wheat
      id:fungible-wheat
      town-id
  ==
++  sal-token
  ^-  grain:smart
  =+  deployer=0x0
  =+  salt=`@`'sal-token'
  :*  %&  salt  %metadata
      :*  name='SAL Token'
          'SAL'
          decimals=18
          supply=300.000.000.000.000.000.000
          cap=~
          mintable=%.n
          minters=~
          deployer
          salt
      ==
      `@ux`'sal-metadata'
      id:fungible-wheat
      id:fungible-wheat
      town-id
  ==
::
++  make-fun-account
  |=  [holder=id:smart amt=@ud meta=grain:smart allowances=(pmap:smart address:smart @ud)]
  ::  meta - metadata of the fungible account. defaults to `@ux`'simple' unless provided
  ^-  grain:smart
  ?>  ?=(%& -.meta)
  =/  id  (fry-rice:smart id:fungible-wheat holder town-id salt.p.meta)
  :*  %&  salt.p.meta  %account
      [amt allowances id.p:meta 0]
      id
      id:fungible-wheat
      holder
      town-id
  ==
::
++  cgy-account
  %:  make-fun-account
      pubkey-1
      100.000.000.000.000.000.000
      cgy-token
      (~(gas py:smart *(pmap:smart address:smart @ud)) ~[[id:amm-wheat 100.000.000.000.000.000.000]])
  ==
::
++  ecs-account
  %:  make-fun-account
      pubkey-1
      100.000.000.000.000.000.000
      ecs-token
      (~(gas py:smart *(pmap:smart address:smart @ud)) ~[[id:amm-wheat 100.000.000.000.000.000.000]])
  ==
::
::  these are held by amm contract
::
++  amm-ecs-account
  %:  make-fun-account
      id:amm-wheat
      100.000.000.000.000.000.000
      ecs-token
      ~
  ==
++  amm-sal-account
  %:  make-fun-account
      id:amm-wheat
      300.000.000.000.000.000.000
      sal-token
      ~
  ==
::
++  ecs-sal-pool
  ^-  grain:smart
  =/  salt  (cat 3 `@`'ecs-metadata' `@`'sal-metadata')
  :*  %&  salt  %pool
      :*  [`@ux`'ecs-metadata' 100.000.000.000.000.000.000]
          [`@ux`'sal-metadata' 300.000.000.000.000.000.000]
          liq-shares=173.205.080.756.887.728.352
      ==
      (fry-rice:smart id:amm-wheat id:amm-wheat town-id salt)
      id:amm-wheat
      id:amm-wheat
      town-id
  ==
::
++  fake-granary
  ^-  granary
  %+  gas:big  *(merk:merk id:smart grain:smart)
  :~  [id:amm-wheat [%| amm-wheat]]
      [id:fungible-wheat [%| fungible-wheat]]
      [id.p:account-1:zigs account-1:zigs]
      [id.p:cgy-token cgy-token]
      [id.p:ecs-token ecs-token]
      [id.p:sal-token sal-token]
      [id.p:cgy-account cgy-account]
      [id.p:ecs-account ecs-account]
      [id.p:amm-ecs-account amm-ecs-account]
      [id.p:amm-sal-account amm-sal-account]
      [id.p:ecs-sal-pool ecs-sal-pool]
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
++  test-pool-start
  =/  =yolk:smart
    :+  %start-pool
      [id.p:cgy-token 100.000.000.000.000.000.000]
    [id.p:ecs-token 50.000.000.000.000.000.000]
  =/  shel=shell:smart
    [caller-1 ~ id:amm-wheat 1 1.000.000 town-id 0]
  ::  ~&  >  "starting state:"
  ::  ~&  >  %+  turn  ~(tap by fake-granary)
  ::         |=  [@ux @ux =grain:smart]
  ::         ^-  (unit grain:smart)
  ::         ?:  ?=(%& -.grain)
  ::           `grain
  ::         ~
  =/  res=mill-result
    %+  ~(mill mil miller town-id 1)
      fake-land
    `egg:smart`[fake-sig shel yolk]
  ::
  ~&  >>>  "fee: {<fee.res>}"
  ~&  >>  "result:"
  ~&  >>  land.res
  ;:  weld
  ::  assert that our call went through
    %+  expect-eq
    !>(%0)  !>(errorcode.res)
  ==
::
++  test-swap
  =/  =yolk:smart
    :+  %swap
      id.p:ecs-sal-pool
    [id.p:ecs-token 50.000.000.000.000.000.000]
  =/  shel=shell:smart
    [caller-1 ~ id:amm-wheat 1 1.000.000 town-id 0]
  =/  res=mill-result
    %+  ~(mill mil miller town-id 1)
      fake-land
    `egg:smart`[fake-sig shel yolk]
  ::
  ~&  >>>  "fee: {<fee.res>}"
  ~&  >>  "result:"
  ~&  >>  land.res
  ;:  weld
  ::  assert that our call went through
    %+  expect-eq
    !>(%0)  !>(errorcode.res)
  ==
--
