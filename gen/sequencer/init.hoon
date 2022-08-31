/-  *sequencer
/+  smart=zig-sys-smart, ethereum, merk
/*  zigs-contract     %noun  /lib/zig/compiled/zigs/noun
/*  nft-contract      %noun  /lib/zig/compiled/nft/noun
/*  publish-contract  %noun  /lib/zig/compiled/publish/noun
::  TODO
::  /*  multisig-contract      %noun  /lib/zig/compiled/multisig/noun
::  /*  fungible-contract      %noun  /lib/zig/compiled/fungible/noun
:-  %say
|=  [[now=@da eny=@uvJ bek=beak] [rollup-host=@p town-id=@ux private-key=@ux ~] ~]
=/  pubkey-1  0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70
=/  pubkey-2  0xd6dc.c8ff.7ec5.4416.6d4e.b701.d1a6.8e97.b464.76de
=/  pubkey-3  0x25a8.eb63.a5e7.3111.c173.639b.68ce.091d.d3fc.f139
=/  zigs-1  (fry-rice:smart zigs-wheat-id:smart pubkey-1 town-id `@`'zigs')
=/  zigs-2  (fry-rice:smart zigs-wheat-id:smart pubkey-2 town-id `@`'zigs')
=/  zigs-3  (fry-rice:smart zigs-wheat-id:smart pubkey-3 town-id `@`'zigs')
=/  beef-zigs-grain
  ^-  grain:smart
  :*  %&
      `@`'zigs'
      %account
      [300.000.000.000.000.000.000 ~ `@ux`'zigs-metadata' 0]
      zigs-1
      zigs-wheat-id:smart
      pubkey-1
      town-id
  ==
=/  dead-zigs-grain
  ^-  grain:smart
  :*  %&
      `@`'zigs'
      %account
      [200.000.000.000.000.000.000 ~ `@ux`'zigs-metadata' 0]
      zigs-2
      zigs-wheat-id:smart
      pubkey-2
      town-id
  ==
=/  cafe-zigs-grain
  ^-  grain:smart
  :*  %&
      `@`'zigs'
      %account
      [100.000.000.000.000.000.000 ~ `@ux`'zigs-metadata' 0]
      zigs-3
      zigs-wheat-id:smart
      pubkey-3
      town-id
  ==
=/  zigs-metadata
  ^-  rice:smart
  :*  `@`'zigs'
      %metadata
      :*  name='UQ| Tokens'
          symbol='ZIG'
          decimals=18
          supply=1.000.000.000.000.000.000.000.000
          cap=~
          mintable=%.n
          minters=~
          deployer=0x0
          salt=`@`'zigs'
      ==
      `@ux`'zigs-metadata'
      zigs-wheat-id:smart
      zigs-wheat-id:smart
      town-id
  ==
=/  zigs-wheat
  ^-  wheat:smart
  ::  interface
  =/  interface  ~
    ::  %-  ~(gas by *(map @tas lump))
    ::  :~  (to-lump ...)
    ::  ==
  ::  types
  =/  types  ~
    ::  %-  ~(gas by *(map @tas lump))
    ::  :~  (to-lump ...)
    ::  ==
  ::
  :*  `;;([bat=* pay=*] (cue q.q.zigs-contract))
      interface=~  ::  TODO
      types=~      ::  TODO
      zigs-wheat-id:smart  ::  id
      zigs-wheat-id:smart  ::  lord
      zigs-wheat-id:smart  ::  holder
      town-id              ::  town-id
  ==
::  publish.hoon contract
=/  publish-wheat
  ^-  wheat:smart
  :*  `;;([bat=* pay=*] (cue q.q.publish-contract))
      interface=~  ::  TODO
      types=~      ::  TODO
      0x1111.1111     ::  id
      0x1111.1111     ::  lord
      0x1111.1111     ::  holder
      town-id         ::  town-id
  ==
::
:: NFT stuff
::
=/  nft-metadata-rice
  ^-  rice:smart
  :*  salt=`@`'nftsalt'
      label=%metadata
      :*  name='Ziggurat Girls'
          symbol='GOODART'
          properties=(~(gas pn:smart *(pset:smart @tas)) `(list @tas)`~[%hat %eyes %mouth])
          supply=1
          cap=`5
          mintable=%.y
          minters=(~(gas pn:smart *(pset:smart address:smart)) ~[pubkey-1])
          deployer=pubkey-1
          salt=`@`'nftsalt'
      ==
      id=`@ux`'nft-metadata'
      lord=0xcafe.babe
      holder=0xcafe.babe
      town-id
  ==
=/  nft-1  (fry-rice:smart 0xcafe.babe pubkey-1 town-id `@`'nftsalt1')
=/  nft-rice
  ^-  rice:smart
  :*  salt=`@`'nftsalt1'
      label=%nft
      :*  1
          'ipfs://QmUbFVTm113tJEuJ4hZY2Hush4Urzx7PBVmQGjv1dXdSV9'
          id:nft-metadata-rice
          ~
          %-  ~(gas py:smart *(pmap:smart @tas @t))
          `(list [@tas @t])`~[[%hat 'pyramid'] [%eyes 'big'] [%mouth 'smile']]
          %.y
      ==
      nft-1
      0xcafe.babe
      pubkey-1
      town-id
  ==
=/  nft-wheat
  ^-  wheat:smart
  :*  `;;([bat=* pay=*] (cue q.q.nft-contract))
      interface=~  ::  TODO
      types=~      ::  TODO
      0xcafe.babe     ::  id
      0xcafe.babe     ::  lord
      0xcafe.babe     ::  holder
      town-id         ::  town-id
  ==
::
=/  fake-granary
  ^-  granary
  %+  gas:(bi:merk id:smart grain:smart)
    *(merk:merk id:smart grain:smart)
  :~  [zigs-1 beef-zigs-grain]
      [zigs-2 dead-zigs-grain]
      [zigs-3 cafe-zigs-grain]
      [nft-1 [%& nft-rice]]
      [id.zigs-metadata [%& zigs-metadata]]
      [id.nft-metadata-rice [%& nft-metadata-rice]]
      [id.publish-wheat [%| publish-wheat]]
      [id.zigs-wheat [%| zigs-wheat]]
      [id.nft-wheat [%| nft-wheat]]
  ==
=/  fake-populace
  ^-  populace
  %+  gas:(bi:merk id:smart @ud)  *(merk:merk id:smart @ud)
  ~[[pubkey-1 0] [pubkey-2 0] [pubkey-3 0]]
::
=/  =address:smart  (address-from-prv:key:ethereum private-key)
::
:-  %sequencer-town-action
^-  town-action
:*  %init
    rollup-host
    address
    private-key
    town-id
    `[fake-granary fake-populace]
    [%full-publish ~]
==
