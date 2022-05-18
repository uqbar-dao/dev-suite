/-  *ziggurat,
    d=dao
/+  deploy=zig-deploy,
    smart=zig-sys-smart
/*  fungible-contract  %txt  /lib/zig/contracts/fungible/hoon
/*  dao-contract  %txt  /lib/zig/contracts/dao/hoon
:: /*  dao-contract  %noun  /lib/zig/compiled/dao/noun
=/  pubkey-1  0x2.e3c1.d19b.fd3e.43aa.319c.b816.1c89.37fb.b246.3a65.f84d.8562.155d.6181.8113.c85b
=/  pubkey-2  0x3.4cdd.5f53.b551.e62f.2238.6eb3.8abd.3e91.a546.fad3.2940.ff2d.c316.50dd.8d38.e609
=/  pubkey-3  0x3.9452.264c.57a5.1b54.d380.70b0.7e0c.934d.15c0.6692.fa9c.7f35.eaf9.eb52.b925.1b7d
=>
  |%
  ::
  ++  make-dao-self
    |=  [name=@tas dao-id=id:smart our-id=id:smart our=ship]
    ^-  dao:d
    |^
    =|  =dao:d
    =:  name.dao         name
        permissions.dao  (make-permissions dao-id)
        members.dao      make-members
        id-to-ship.dao   (make-id-to-ship our-id our)
        ship-to-id.dao   (make-ship-to-id our-id our)
    ==
    dao
    ::
    ++  make-permissions
      |=  dao-id=id:smart
      ^-  permissions:d
      %-  %~  gas  by  *permissions:d
          :~  :-  name=%host
            %-  %~  gas  ju  *(jug address:d role:d)
            :-  [dao-id %comms-host]
            ~
      ::
          :-  name=%write
          %-  %~  gas  ju  *(jug address:d role:d)
          :~  [dao-id %owner]
              [[~zod %dao-chat] %owner]
              [[~zod %dao-chat] %pleb]
              [[~zod %dao-links] %owner]
          ==
      ::
          :-  name=%read
          %-  %~  gas  ju  *(jug address:d role:d)
          :~  [[~zod %dao-chat] %owner]
              [[~zod %dao-chat] %pleb]
              [[~zod %dao-links] %owner]
              [[~zod %dao-links] %pleb]
              [[~nec %dao-chat] %owner]
              [[~nec %dao-chat] %pleb]
              [[~nec %dao-links] %owner]
              [[~nec %dao-links] %pleb]
          ==
      ::
      ==
    ::
    ++  make-members
      ^-  members:d
      %-  %~  gas  ju  *members:d
      :~  [pubkey-1 %owner]
          [pubkey-1 %comms-host]
          [pubkey-2 %pleb]
          [pubkey-3 %pleb]
      ==
    ::
    ++  make-id-to-ship
      |=  [our-id=id:smart our=ship]
      ^-  id-to-ship:d
      %-  %~  gas  by  *id-to-ship:d
      :^    [pubkey-1 ~zod]
          [pubkey-2 ~nec]
        [pubkey-3 ~bus]
      ~
    ::
    ++  make-ship-to-id
      |=  [our-id=id:smart our=ship]
      ^-  ship-to-id:d
      %-  %~  gas  by  *ship-to-id:d
      :^    [~zod pubkey-1]
          [~nec pubkey-2]
        [~bus pubkey-3]
      ~
    ::
    --
  ::
  --
:-  %say
|=  [[now=@da eny=@uvJ bek=beak] [town-id=@ud ~] ~]
=/  dao-contract-id=id:smart  `@ux`'dao'
=/  dao-salt=@  `@`'uqbar-dao'
=/  uqbar-dao-id=id:smart
  %:  fry-rice:smart
      dao-contract-id
      dao-contract-id
      town-id
      dao-salt
  ==
~&  >  "uqbar-dao-id: {<uqbar-dao-id>}"
=*  our  p.bek
=/  uqbar-dao=dao:d
  (make-dao-self 'Uqbar DAO' uqbar-dao-id pubkey-1 our)
=/  uqbar-dao-grain  ::  ~zod
  ^-  grain:smart
  :*  uqbar-dao-id
      dao-contract-id
      dao-contract-id
      town-id
      [%& dao-salt uqbar-dao]
  ==
::  store only contract code, insert into shared subject
=/  dao-contract-wheat
  ^-  wheat:smart
  =/  cont  (of-wain:format dao-contract)
  :-  `(~(text-deploy deploy p.bek now) cont)
  :: :-  `(cue q.q.dao-contract)
  (silt ~[uqbar-dao-id])
=/  dao-contract-grain
  ^-  grain:smart
  :*  dao-contract-id          ::  id
      dao-contract-id          ::  lord
      dao-contract-id          ::  holder
      town-id                  ::  town-id
      [%| dao-contract-wheat]  ::  germ
  ==
::
=/  zigs-1  (fry-rice:smart pubkey-1 `@ux`'fungible' town-id `@`'zigs')
=/  zigs-2  (fry-rice:smart pubkey-2 `@ux`'fungible' town-id `@`'zigs')
=/  zigs-3  (fry-rice:smart pubkey-3 `@ux`'fungible' town-id `@`'zigs')
=/  beef-zigs-grain  ::  ~zod
  ^-  grain:smart
  :*  zigs-1
      `@ux`'fungible'
      ::  associated seed: 0xbeef
      pubkey-1
      town-id
      [%& `@`'zigs' [300.000 ~ `@ux`'zigs-metadata']]
  ==
=/  dead-zigs-grain  ::  ~bus
  ^-  grain:smart
  :*  zigs-2
      `@ux`'fungible'
      ::  associated seed: 0xdead
      pubkey-2
      town-id
      [%& `@`'zigs' [200.000 ~ `@ux`'zigs-metadata']]
  ==
=/  cafe-zigs-grain  ::  ~nec
  ^-  grain:smart
  :*  zigs-3
      `@ux`'fungible'
      ::  associated seed: 0xcafe
      pubkey-3
      town-id
      [%& `@`'zigs' [100.000 ~ `@ux`'zigs-metadata']]
  ==
=/  zigs-metadata-grain
  ^-  grain:smart
  :*  `@ux`'zigs-metadata'
      `@ux`'fungible'
      `@ux`'fungible'
      town-id
      :+  %&  `@`'zigs'
      :*  name='Uqbar Tokens'
          symbol='ZIG'
          decimals=18
          supply=1.000.000.000.000.000.000.000.000
          cap=~
          mintable=%.n
          minters=~
          deployer=0x0
          salt=`@`'zigs'
      ==
  ==
::  store only contract code, insert into shared subject
=/  wheat
  ^-  wheat:smart
  =/  cont  (of-wain:format fungible-contract)
  :-  `(~(text-deploy deploy p.bek now) cont)
  (silt ~[zigs-1 zigs-2 zigs-3 `@ux`'zigs-metadata'])
=/  wheat-grain
  ^-  grain:smart
  :*  `@ux`'fungible'  ::  id
      `@ux`'fungible'  ::  lord
      `@ux`'fungible'  ::  holder
      town-id          ::  town-id
      [%| wheat]       ::  germ
  ==
=/  fake-granary
  ^-  granary:smart
  =/  grains=(list:smart (pair:smart id:smart grain:smart))
    :~  [`@ux`'fungible' wheat-grain]
        [zigs-1 beef-zigs-grain]
        [zigs-2 dead-zigs-grain]
        [zigs-3 cafe-zigs-grain]
        [dao-contract-id dao-contract-grain]
        [uqbar-dao-id uqbar-dao-grain]
    ==
  (~(gas by:smart *(map:smart id:smart grain:smart)) grains)
=/  fake-populace
  ^-  populace:smart
  %-  %~  gas  by:smart  *(map:smart id:smart @ud)
  ~[[pubkey-1 0] [pubkey-2 0] [pubkey-3 0]]
:-  %zig-hall-poke
^-  hall-poke
:*  %init
    town-id
    `[fake-granary fake-populace]
    [rate=1 bud=10.000]
==
