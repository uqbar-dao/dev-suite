/-  *sequencer
/+  ethereum,
    merk,
    smart=zig-sys-smart,
    fungible=zig-contracts-lib-fungible-interface-types,
    nft=zig-contracts-lib-nft-interface-types,
    publish=zig-contracts-lib-publish-interface-types,
    zigs=zig-contracts-lib-zigs-interface-types
/*  fungible-contract  %noun  /lib/zig/compiled/fungible/noun
/*  nft-contract       %noun  /lib/zig/compiled/nft/noun
/*  publish-contract   %noun  /lib/zig/compiled/publish/noun
/*  zigs-contract      %noun  /lib/zig/compiled/zigs/noun
:-  %say
|=  [[now=@da eny=@uvJ bek=beak] [rollup-host=@p town-id=@ux private-key=@ux ~] ~]
::  one hundred million testnet zigs, now and forever
=/  testnet-zigs-supply  100.000.000.000.000.000.000.000.000
::
=/  pubkey-1  0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70
=/  pubkey-2  0xd6dc.c8ff.7ec5.4416.6d4e.b701.d1a6.8e97.b464.76de
=/  pubkey-3  0x25a8.eb63.a5e7.3111.c173.639b.68ce.091d.d3fc.f139
=/  zigs-1  (fry-rice:smart zigs-wheat-id:smart pubkey-1 town-id `@`'zigs')
=/  zigs-2  (fry-rice:smart zigs-wheat-id:smart pubkey-2 town-id `@`'zigs')
=/  zigs-3  (fry-rice:smart zigs-wheat-id:smart pubkey-3 town-id `@`'zigs')
::
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
::
=/  zigs-metadata
  ^-  rice:smart
  :*  `@`'zigs'
      %metadata
      :*  name='UQ| Tokens'
          symbol='ZIG'
          decimals=18
          supply=testnet-zigs-supply
          cap=`testnet-zigs-supply
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
::  zigs.hoon contract
=/  zigs-wheat
  ^-  wheat:smart
  :*  `;;([bat=* pay=*] (cue +.+:;;([* * @] zigs-contract)))
      interface=interface-json:zigs
      types=types-json:zigs
      zigs-wheat-id:smart  ::  id
      zigs-wheat-id:smart  ::  lord
      zigs-wheat-id:smart  ::  holder
      town-id              ::  town-id
  ==
::  publish.hoon contract
=/  publish-wheat
  ^-  wheat:smart
  :*  `;;([bat=* pay=*] (cue +.+:;;([* * @] publish-contract)))
      interface=interface-json:publish
      types=~
      0x1111.1111  ::  id
      0x0          ::  lord
      0x0          ::  holder
      town-id      ::  town-id
  ==
::  nft.hoon contract
=/  nft-wheat
  ^-  wheat:smart
  =/  cont  ;;([bat=* pay=*] (cue +.+:;;([* * @] nft-contract)))
  :*  `cont
      interface=interface-json:nft
      types=types-json:nft
      (fry-wheat:smart 0x0 0x0 town-id `cont)
      0x0          ::  lord
      0x0          ::  holder
      town-id      ::  town-id
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
      lord=id:nft-wheat
      holder=id:nft-wheat
      town-id
  ==
=/  nft-1  (fry-rice:smart id:nft-wheat pubkey-1 town-id `@`'nftsalt1')
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
      id:nft-wheat
      pubkey-1
      town-id
  ==
::  fungible.hoon contract
=/  fungible-wheat
  ^-  wheat:smart
  =/  cont  ;;([bat=* pay=*] (cue +.+:;;([* * @] fungible-contract)))
  :*  `cont
      interface=interface-json:fungible
      types=types-json:fungible
      (fry-wheat:smart 0x0 0x0 town-id `cont)
      0x0          ::  lord
      0x0          ::  holder
      town-id      ::  town-id
  ==
::
=/  fake-granary
  ^-  granary
  %+  gas:(bi:merk id:smart grain:smart)
    *(merk:merk id:smart grain:smart)
  :~  [id.zigs-wheat [%| zigs-wheat]]
      [id.publish-wheat [%| publish-wheat]]
      [id.nft-wheat [%| nft-wheat]]
      [id.fungible-wheat [%| fungible-wheat]]
      [zigs-1 beef-zigs-grain]
      [zigs-2 dead-zigs-grain]
      [zigs-3 cafe-zigs-grain]
      [nft-1 [%& nft-rice]]
      [id.nft-metadata-rice [%& nft-metadata-rice]]
      [id.zigs-metadata [%& zigs-metadata]]
  ==
::
:-  %sequencer-town-action
^-  town-action
:*  %init
    rollup-host
    (address-from-prv:key:ethereum private-key)
    private-key
    town-id
    `[fake-granary *populace]
    [%full-publish ~]
==
