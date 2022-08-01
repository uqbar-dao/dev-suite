/-  *sequencer
/+  smart=zig-sys-smart, ethereum
/*  zigs-contract     %noun  /lib/zig/compiled/zigs/noun
/*  nft-contract      %noun  /lib/zig/compiled/nft/noun
/*  publish-contract  %noun  /lib/zig/compiled/publish/noun
/*  trivial-contract  %noun  /lib/zig/compiled/trivial/noun
:-  %say
|=  [[now=@da eny=@uvJ bek=beak] [rollup-host=@p town-id=@ux private-key=@ux ~] ~]
=/  pubkey-1  0x7772.b8a7.6840.8922.2903.5b28.7494.436f.8850.713c
=/  pubkey-2  0xc7ec.a38c.5c74.d58d.04b0.6650.4772.f3a6.d02e.92f5
=/  pubkey-3  0x435a.11af.b1f8.24b8.a1d7.de8a.c8c1.cce1.363c.6f3b
=/  zigs-1  (fry-rice:smart zigs-wheat-id:smart pubkey-1 town-id `@`'zigs')
=/  zigs-2  (fry-rice:smart zigs-wheat-id:smart pubkey-2 town-id `@`'zigs')
=/  zigs-3  (fry-rice:smart zigs-wheat-id:smart pubkey-3 town-id `@`'zigs')
=/  beef-zigs-grain
  ^-  grain:smart
  :*  %&
      `@`'zigs'
      %account
      [10.321.055.000.000.000.000 ~ `@ux`'zigs-metadata']
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
      [50.000.000.000.000.000.000 ~ `@ux`'zigs-metadata']
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
      [50.000.000.000.000.000.000 ~ `@ux`'zigs-metadata']
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
  :*  `;;([bat=* pay=*] (cue q.q.zigs-contract))
      interface=~  ::  TODO
      types=~      ::  TODO
      zigs-wheat-id:smart  ::  id
      zigs-wheat-id:smart  ::  lord
      zigs-wheat-id:smart  ::  holder
      town-id              ::  town-id
  ==
:: ::  publish.hoon contract
:: =/  publish-grain
::   ^-  grain:smart
::   :*  %|
::       `;;([bat=* pay=*] (cue q.q.publish-contract))
::       interface=~  ::  TODO
::       types=~      ::  TODO
::       0x1111.1111     ::  id
::       0x1111.1111     ::  lord
::       0x1111.1111     ::  holder
::       town-id         ::  town-id
::   ==
:: ::  trivial.hoon contract
:: =/  trivial-grain
::   ^-  grain:smart
::   :*  %|
::       `;;([bat=* pay=*] (cue q.q.trivial-contract))
::       interface=~  ::  TODO
::       types=~      ::  TODO
::       0xdada.dada     ::  id
::       0xdada.dada     ::  lord
::       0xdada.dada     ::  holder
::       town-id         ::  town-id
::   ==
:: ::
:: ::  NFT stuff
:: =/  nft-metadata-grain
::   ^-  grain:smart
::   :*  %&
::       `@`'nftsalt'
::       :*  name='Monkey JPEGs'
::           symbol='BADART'
::           attributes=(silt ~['hair' 'eyes' 'mouth'])
::           supply=1
::           cap=~
::           mintable=%.n
::           minters=~
::           deployer=0x0
::           salt=`@`'nftsalt'
::       ==
::       `@ux`'nft-metadata'
::       0xcafe.babe
::       0xcafe.babe
::       town-id
::   ==
:: =/  item-1
::   [1 (silt ~[['hair' 'red'] ['eyes' 'blue'] ['mouth' 'smile']]) 'a smiling monkey' 'ipfs://QmUbFVTm113tJEuJ4hZY2Hush4Urzx7PBVmQGjv1dXdSV9' %.y]
:: =/  nft-acc-id  (fry-rice:smart 0xcafe.babe pubkey-1 town-id `@`'nftsalt')
:: =/  nft-acc-grain
::   :*  %&
::       `@`'nftsalt'
::       [`@ux`'nft-metadata' (malt ~[[1 item-1]]) ~ ~]
::       nft-acc-id
::       0xcafe.babe
::       pubkey-1
::       town-id
::   ==
:: =/  nft-wheat-grain
::   ^-  grain:smart
::   :*  %|
::       `;;([bat=* pay=*] (cue q.q.nft-contract))
::       interface=~  ::  TODO
::       types=~      ::  TODO
::       0xcafe.babe     ::  id
::       0xcafe.babe     ::  lord
::       0xcafe.babe     ::  holder
::       town-id         ::  town-id
::   ==
::
=/  fake-granary
  ^-  granary
  =/  grains=(list:smart (pair:smart id:smart grain:smart))
    :~  [id.zigs-wheat [%| zigs-wheat]]
        [id.zigs-metadata [%& zigs-metadata]]
        :: [id.nft-wheat-grain nft-wheat-grain]
        :: [id.nft-metadata-grain nft-metadata-grain]
        :: [id.publish-grain publish-grain]
        :: [id.trivial-grain trivial-grain]
        [zigs-1 beef-zigs-grain]
        [zigs-2 dead-zigs-grain]
        [zigs-3 cafe-zigs-grain]
        :: [nft-acc-id nft-acc-grain]
    ==
  (gas:big:smart *(merk:smart id:smart grain:smart) grains)
=/  fake-populace
  ^-  populace
  %+  gas:(bi:smart id:smart @ud)  *(merk:smart id:smart @ud)
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
