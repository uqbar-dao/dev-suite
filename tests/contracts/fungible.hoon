::  Tests for fungible.hoon (token contract)
::  to test, make sure to add library import at top of contract
::  (remove again before compiling for deployment)
::
/+  *test, cont=zig-contracts-fungible, *zig-contracts-lib-fungible, *zig-sys-smart, ethereum
::  TODO: need to create a test mill since we can no longer directly pass in grains
=>  ::  test data
    |%
    ++  batch-num  1
    ++  town-id    0x2
    ++  fungible-wheat-id  `@ux`'fungible'
    ++  metadata-1
      ^-  grain
      :*  %&  `@`'salt'  %metadata
          :*  name='Simple Token'
              symbol='ST'
              decimals=0
              supply=100
              cap=~
              mintable=%.n
              minters=~
              deployer=0x0
              salt=`@`'salt'
          ==
          `@ux`'simple'
          fungible-wheat-id
          `@ux`'holder'
          town-id
      ==
    ++  metadata-mintable
      ^-  grain
      :*  %&  `@`'salt'  %metadata
          ^-  token-metadata:sur
          :*  name='Simple Token'
              symbol='ST'
              decimals=0
              supply=100
              cap=`1.000
              mintable=%.y
              minters=(silt ~[pub-1])
              deployer=0x0
              salt=`@`'salt'
          ==
          `@ux`'simple'
          fungible-wheat-id
          `@ux`'holder'
          town-id
      ==
    ::
    ++  priv-1  0xbeef.beef.beef.beef.beef.beef.beef.beef.beef.beef
    ++  pub-1   (address-from-prv:key:ethereum priv-1)
    ++  owner-1
      ^-  caller
      [pub-1 0 0x1234.5678]
    ++  account-1
      ^-  grain
      :*  %&  `@`'salt'  %account
          `account:sur`[50 ~ `@ux`'simple' 0]
          0x1.beef
          fungible-wheat-id  ::  lord
          pub-1              ::  holder
          town-id
      ==
    ::
    ++  priv-2  0xdead.dead.dead.dead.dead.dead.dead.dead.dead.dead
    ++  pub-2   (address-from-prv:key:ethereum priv-2)
    ++  owner-2
      ^-  caller
      [pub-2 0 0x1234.5678]
    ++  account-2  ^-  grain
      :*  %&  `@`'salt'  %account
          `account:sur`[30 ~ `@ux`'simple' 0]
          0x1.dead
          fungible-wheat-id
          pub-2
          town-id
      ==
    ::
    ++  priv-3  0xcafe.cafe.cafe.cafe.cafe.cafe.cafe.cafe.cafe.cafe
    ++  pub-3   (address-from-prv:key:ethereum priv-3)
    ++  owner-3
      ^-  caller
      [pub-3 0 0x1234.5678]
    ++  account-3
      ^-  grain
      :*  %&  `@`'salt'  %account
          `account:sur`[20 (malt ~[[0xffff 100]]) `@ux`'simple' 0]
          0x1.cafe
          fungible-wheat-id
          pub-3
          town-id
      ==
    ::
    ++  account-4
      ^-  grain
      :*  %&  `@`'diff'  %account
          `account:sur`[20 ~ `@ux`'different!' 0]
          0x1.face
          fungible-wheat-id
          0xface
          town-id
      ==
    --
::  testing arms
|%
++  test-matches-type  ^-  tang
  =/  valid  (mule |.(;;(contract cont)))
  (expect-eq !>(%.y) !>(-.valid))
::
::  tests for %set-allowance
::
++  test-set-allowance  ^-  tang
  =/  =action:sur  [%set-allowance 0xcafe 10]
  =/  =cart
    [fungible-wheat-id [pub-1 0] batch-num town-id]
  =/  updated-1=grain
    :*  %&  `@`'salt'  %account
        `account:sur`[50 (malt ~[[0xcafe 10]]) `@ux`'simple' 0]
        id.p:account-1
        fungible-wheat-id
        pub-1
        town-id
    ==
  =/  correct=chick  (result ~[updated-1] ~ ~ ~)
  =/  res=chick      (~(write cont cart) action)
  (expect-eq !>(res) !>(correct))
::
::  tests for %give
::
++  test-give-known-receiver
  ^-  tang
  =/  =action:sur
    [%give [%grain id.p:account-1] pub-2 `[%grain id.p:account-2] 30]
  =/  =cart
    [fungible-wheat-id [pub-2 0] batch-num town-id]
  =/  updated-1=grain
    :*  %&  `@`'salt'  %account
        `account:sur`[20 ~ `@ux`'simple' 0]
        0x1.beef
        fungible-wheat-id
        pub-1
        town-id
    ==
  =/  updated-2=grain
    :*  %&  `@`'salt'  %account
        `account:sur`[60 ~ `@ux`'simple' 0]
        0x1.dead
        fungible-wheat-id
        pub-2
        town-id
    ==
  =/  res=chick      (~(write cont cart) action)
  =/  correct=chick  (result ~[updated-1 updated-2] ~ ~ ~)
  (expect-eq !>(res) !>(correct))
::
++  test-give-unknown-receiver
  ^-  tang
  =/  =action:sur  [%give [%grain id.p:account-1] 0xffff ~ 30]
  =/  =cart
    [fungible-wheat-id [pub-1 0] batch-num town-id]
  =/  new-id  (fry-rice fungible-wheat-id 0xffff town-id `@`'salt')
  =/  new=grain
    :*  %&  `@`'salt'  %account
        `account:sur`[0 ~ `@ux`'simple' 0]
        new-id
        fungible-wheat-id
        0xffff
        town-id
    ==
  =/  res=chick  (~(write cont cart) action)
  =/  correct-act=action:sur
    [%give [%grain id.p:account-1] 0xffff `[%grain new-id] 30]
  =/  correct=chick
    %+  continuation
      [me.cart town-id.cart correct-act]~
    (result ~[new] ~ ~ ~)
  (expect-eq !>(res) !>(correct))
::
++  test-give-not-enough
  ^-  tang
  =/  =action:sur  [%give [%grain id.p:account-1] 0xdead `[%grain id.p:account-2] 51]
  =/  =cart        [fungible-wheat-id [pub-1 0] batch-num town-id]
  =/  res=(each * (list tank))
    (mule |.((~(write cont cart) action)))
  (expect-eq !>(%.n) !>(-.res))
::
++  test-give-metadata-mismatch
  ^-  tang
  =/  =action:sur  [%give [%grain id.p:account-1] 0xface `[%grain 0x1.face] 10]
  =/  =cart        [fungible-wheat-id [pub-1 0] batch-num town-id]
  =/  res=(each * (list tank))
    (mule |.((~(write cont cart) action)))
  (expect-eq !>(%.n) !>(-.res))
::
::  tests for %take
::
++  test-take-send-new-account  ^-  tang
  =/  =action:sur  [%take 0xffff ~ [%grain 0x1.cafe] 10]
  =/  =cart
    [fungible-wheat-id [0xffff 0] batch-num town-id]
  =/  new-id=id  (fry-rice fungible-wheat-id 0xffff town-id `@ux`'salt')
  =/  new=grain
    :*  %&  `@`'salt'  %account 
        `account:sur`[0 ~ `@ux`'simple' 0]
        new-id
        fungible-wheat-id
        0xffff
        town-id
    ==
  =/  correct-act=action:sur
    [%take 0xffff `[%grain new-id] [%grain 0x1.cafe] 10]
  =/  correct=chick
    %+  continuation
      [me.cart town-id.cart correct-act]~
    (result ~[new] ~ ~ ~)
  =/  res=chick  (~(write cont cart) action)
  (expect-eq !>(res) !>(correct))
::
::  tests for %take-with-sig
::
++  test-take-with-sig-known-reciever
  ^-  tang
  ::  owner-1 is giving owner-2 the ability to take 30
  =/  to            pub-2
  =/  account       id.p:account-2  :: a rice of account-2  :: TODO: something is really fishy here. the account rice should have to be signed but this is fucked
  =/  from-account  id.p:account-1
  =/  amount        30
  =/  nonce         0
  =/  deadline      (add batch-num 1)
  =/  =typed-message  :-  (fry-rice fungible-wheat-id pub-1 town-id `@`'salt')
                        (sham [pub-1 to amount nonce deadline])
  =/  sig  %+  ecdsa-raw-sign:secp256k1:secp:crypto
             (sham typed-message)
           priv-1
  =/  =action:sur
    [%take-with-sig to `[%grain account] [%grain from-account] amount nonce deadline sig]
  =/  =cart
    [fungible-wheat-id [pub-2 0] batch-num town-id]
  =/  updated-1=grain
    :*  %&  `@`'salt'  %account
        `account:sur`[20 ~ `@ux`'simple' 1]
        0x1.beef
        fungible-wheat-id
        pub-1
        town-id
    ==
  =/  updated-2=grain
    :*  %&  `@`'salt'  %account
        `account:sur`[60 ~ `@ux`'simple' 0]
        0x1.dead
        fungible-wheat-id
        pub-2
        town-id
    ==
  =/  res=chick
    (~(write cont cart) action)
  =/  correct=chick
    (result ~[updated-1 updated-2] ~ ~ ~)
  (expect-eq !>(res) !>(correct))

++  test-take-with-sig-unknown-reciever  ^-  tang
  ::  owner-1 is giving owner-2 the ability to take 30
  =/  to  pub-2
  =/  account  ~  :: unkown account this time
  =/  from-account  0x1.beef
  =/  amount  30
  =/  nonce  0
  =/  deadline  (add batch-num 1)
  =/  =typed-message  :-  (fry-rice fungible-wheat-id pub-1 town-id `@`'salt')
                      (sham [pub-1 to amount nonce deadline])
  =/  sig  %+  ecdsa-raw-sign:secp256k1:secp:crypto
             (sham typed-message)
           priv-1
  =/  =action:sur
    [%take-with-sig to account [%grain from-account] amount nonce deadline sig]
  =/  =cart
    [fungible-wheat-id [pub-2 0] batch-num town-id] :: cart no longer knows account-2' rice
  =/  updated-1=grain
    :*  %&  `@`'salt'  %account
        `account:sur`[20 ~ `@ux`'simple' 1]
        0x1.beef
        fungible-wheat-id
        pub-1
        town-id
    ==
  =/  new-id  (fry-rice pub-2 fungible-wheat-id 0x1 `@`'salt')
  =/  new=grain
    :*  %&  `@`'salt'  %account
        `account:sur`[30 ~ `@ux`'simple' 0]
        new-id
        fungible-wheat-id
        pub-2
        town-id
    ==
  =/  res=chick
    (~(write cont cart) action)
  =/  correct-act=action:sur
    [%take-with-sig pub-2 `[%grain new-id] [%grain 0x1.beef] amount nonce deadline sig]
  =/  correct=chick
    %+  continuation
      [me.cart town-id.cart correct-act]~
    (result ~ ~[new] ~ ~)
  (expect-eq !>(res) !>(correct))
::
::  tests for %mint
::
++  test-mint-known-receivers
  ^-  tang
  =/  =action:sur
    [%mint `@ux`'simple' (silt ~[[pub-1 `[%grain 0x1.dead] 50] [pub-2 `[%grain 0x1.cafe] 10]])]
  =/  =cart
    :*  fungible-wheat-id
        [pub-1 0]
        batch-num
        town-id
    ==
  =/  updated-1=grain
        
    :*  %&  `@`'salt'  %metadata
        ^-  token-metadata:sur
        :*  name='Simple Token'
            symbol='ST'
            decimals=0
            supply=160
            cap=`1.000
            mintable=%.n
            minters=(silt ~[pub-1])
            deployer=0x0
            salt=`@`'salt'
        ==
        `@ux`'simple'
        fungible-wheat-id
        `@ux`'holder'
        town-id
    ==
  =/  updated-2=grain
    :*  %&  `@`'salt'  %account
        `account:sur`[80 ~ `@ux`'simple' 0]
        0x1.dead
        fungible-wheat-id
        pub-2
        town-id
    ==
  =/  updated-3=grain
    :*  %&  `@`'salt'  %account
        `account:sur`[30 (malt ~[[0xffff 100]]) `@ux`'simple' 0]
        0x1.cafe
        fungible-wheat-id
        pub-3
        town-id
    ==
  =/  res=chick
    (~(write cont cart) action)
  =/  correct=chick
    (result ~[updated-1 updated-2 updated-3] ~ ~ ~)
  (expect-eq !>(res) !>(correct))
::
++  test-mint-unknown-receiver
  ^-  tang
  =/  =action:sur
    [%mint `@ux`'simple' (silt ~[[pub-1 ~ 50]])]
  =/  =cart
    [fungible-wheat-id [pub-1 0] batch-num town-id]
  =/  new-id  (fry-rice fungible-wheat-id pub-1 town-id `@`'salt')
  =/  new=grain
    :*  %&  `@`'salt'  %account
      `account:sur`[0 ~ `@ux`'simple' 0]
      new-id
      fungible-wheat-id
      pub-1
      town-id
    ==
  =/  next-mints=(set mint:sur)
    (silt ~[[pub-1 `[%grain new-id] 50]])
  =/  res=chick
    (~(write cont cart) action)
  =/  correct-act=action:sur  
    [%mint `@ux`'simple' next-mints]
  =/  correct=chick
    %+  continuation
      [me.cart town-id.cart correct-act]~
    (result ~ ~[new] ~ ~)
  (expect-eq !>(res) !>(correct))
::
::  tests for %deploy
::
++  test-deploy  ^-  tang
  =/  token-salt
    (sham (cat 3 pub-1 'TC'))
  =/  new-token-metadata=grain
    :*  %&  token-salt  %metadata
        ^-  token-metadata:sur
        :*  'Test Coin'
            'TC'
            0
            900
            `1.000
            %.y
            (silt ~[pub-1])
            pub-1
            token-salt
        ==
        (fry-rice fungible-wheat-id fungible-wheat-id town-id token-salt)
        fungible-wheat-id
        fungible-wheat-id
        town-id
    ==
  =/  updated-account=grain
    :*  %&  token-salt  %account
        ^-  account:sur
        :*  900
            ~
            id.p.new-token-metadata
            0
        ==
        (fry-rice fungible-wheat-id pub-1 town-id token-salt)
        fungible-wheat-id
        pub-1
        town-id
    ==
  =/  =action:sur
    [%deploy (silt ~[[pub-1 900]]) (silt ~[pub-1]) 'Test Coin' 'TC' 0 1.000 %.y]
  =/  cart
    [fungible-wheat-id [pub-1 0] batch-num town-id]
  =/  res=chick
    (~(write cont cart) action)
  =/  correct=chick
    (result ~ ~[updated-account new-token-metadata] ~ ~)
  (expect-eq !>(res) !>(correct))
--