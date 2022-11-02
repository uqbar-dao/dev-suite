::
::  Tests for nft.hoon
::
/-  zink
/+  *test, smart=zig-sys-smart, *sequencer, merk
/*  smart-lib-noun  %noun  /lib/zig/sys/smart-lib/noun
/*  zink-cax-noun   %noun  /lib/zig/sys/hash-cache/noun
/*  nft-contract    %noun  /con/compiled/nft/noun
|%
::
::  constants / dummy info for mill
::
++  big  (bi:merk id:smart item:smart)  ::  merkle engine for granary
++  pig  (bi:merk id:smart @ud)          ::                for populace
++  town-id   0x0
++  fake-sig  [0 0 0]
++  mil
  %~  mill  mill
  :+    ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
    ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun)))
  %.y
::
+$  single-result
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
    ^-  item:smart
    :*  %&
        `@`'zigs'
        %account
        [300.000.000 ~ `@ux`'zigs-metadata']
        (fry-data:smart zigs-contract-id:smart pubkey-1 town-id `@`'zigs')
        zigs-contract-id:smart
        pubkey-1
        town-id
    ==
  --
::
++  nft-metadata-rice
  ^-  data:smart
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
++  nft-1  (fry-data:smart 0xcafe.babe pubkey-1 town-id `@`'nftsalt1')
++  nft-rice
  ^-  data:smart
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
++  nft-wheat
  ^-  pact:smart
  :*  `;;([bat=* pay=*] (cue +.+:;;([* * @] nft-contract)))
      interface=~  ::  TODO
      types=~      ::  TODO
      0xcafe.babe  ::  id
      0xcafe.babe  ::  lord
      0xcafe.babe  ::  holder
      town-id      ::  town-id
  ==
::
++  fake-granary
  ^-  granary
  %+  gas:big  *(merk:merk id:smart item:smart)
  :~  [id:nft-wheat [%| nft-wheat]]
      [id:nft-metadata-rice [%& nft-metadata-rice]]
      [id:nft-rice [%& nft-rice]]
      [id.p:account-1:zigs account-1:zigs]
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
++  test-mill-nft-give
  =/  =calldata:smart  [%give 0xffff.ffff.ffff.ffff id:nft-rice]
  =/  shel=shell:smart
    [caller-1 ~ id:nft-wheat 1 1.000.000 town-id 0]
  =/  res=single-result
    %+  ~(mill mil miller town-id 1)
      fake-land
    `transaction:smart`[fake-sig shel yolk]
  ::
  ~&  >  "fee: {<fee.res>}"
  ~&  p.land.res
  ;:  weld
  ::  assert that our call went through
    %+  expect-eq
    !>(%0)  !>(errorcode.res)
  ==
--
