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
=/  faucet-pubkey  0x1a37.8abd.e505.f675.49e2.091f.769e.cc9e.013c.3ee6
=/  zigs-1
  ^-  rice:smart
  :*  `@`'zigs'
      %account
      [testnet-zigs-supply ~ `@ux`'zigs-metadata' 0]
      (fry-rice:smart zigs-wheat-id:smart faucet-pubkey town-id `@`'zigs')
      zigs-wheat-id:smart
      faucet-pubkey
      town-id
  ==
::
=/  zigs-metadata
  ^-  rice:smart
  :*  `@`'zigs'
      %token-metadata
      :*  name='UQ| Tokens'
          symbol='ZIG'
          decimals=18
          supply=testnet-zigs-supply
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
      [id.zigs-1 [%& zigs-1]]
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
