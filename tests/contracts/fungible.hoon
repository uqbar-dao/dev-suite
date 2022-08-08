::
::  tests for %give
::
++  test-give-known-receiver
  ^-  tang
  =/  =action:sur
    [%give id.p:account-1 pub-2 `id.p:account-2 30]
  =/  =cart
    [id.p:fungible-wheat [pub-2 0] batch-num town-id]
  =/  updated-1=grain:smart
    :*  %&  `@`'salt'  %account
        `account:sur`[20 ~ `@ux`'simple' 0]
        0x1.beef
        id.p:fungible-wheat
        pub-1
        town-id
    ==
  =/  updated-2=grain:smart
    :*  %&  `@`'salt'  %account
        `account:sur`[60 ~ `@ux`'simple' 0]
        0x1.dead
        id.p:fungible-wheat
        pub-2
        town-id
    ==
  =/  res=chick:smart      (~(write cont cart) action)
  =/  correct=chick:smart  (result:smart ~[updated-1 updated-2] ~ ~ ~)
  (expect-eq !>(res) !>(correct))
::::
++  test-give-unknown-receiver
  ^-  tang
  =/  =action:sur  [%give id.p:account-1 0xffff ~ 30]
  =/  =cart
    [id.p:fungible-wheat [pub-1 0] batch-num town-id]
  =/  new-id  (fry-rice:smart id.p:fungible-wheat 0xffff town-id `@`'salt')
  =/  new=grain:smart
    :*  %&  `@`'salt'  %account
        `account:sur`[0 ~ `@ux`'simple' 0]
        new-id
        id.p:fungible-wheat
        0xffff
        town-id
    ==
  =/  res=chick:smart  (~(write cont cart) action)
  =/  correct-act=action:sur
    [%give id.p:account-1 0xffff `new-id 30]
  =/  correct=chick:smart
    %+  continuation
      [me.cart town-id.cart correct-act]~
    (result:smart ~[new] ~ ~ ~)
  (expect-eq !>(res) !>(correct))
::::
++  test-give-not-enough
  ^-  tang
  =/  =action:sur  [%give id.p:account-1 0xdead `id.p:account-2 51]
  =/  =cart        [id.p:fungible-wheat [pub-1 0] batch-num town-id]
  =/  res=(each * (list tank))
    (mule |.((~(write cont cart) action)))
  (expect-eq !>(%.n) !>(-.res))
::
++  test-give-metadata-mismatch
  ^-  tang
  =/  =action:sur  [%give id.p:account-1 0xface `0x1.face 10]
  =/  =cart        [id.p:fungible-wheat [pub-1 0] batch-num town-id]
  =/  res=(each * (list tank))
    (mule |.((~(write cont cart) action)))
  (expect-eq !>(%.n) !>(-.res))
::::
::::  tests for %take
::::
++  test-take-send-new-account  ^-  tang
  =/  =action:sur  [%take 0xffff ~ 0x1.cafe 10]
  =/  =cart
    [id.p:fungible-wheat [0xffff 0] batch-num town-id]
  =/  new-id=id:smart  (fry-rice:smart id.p:fungible-wheat 0xffff town-id `@ux`'salt')
  =/  new=grain:smart
    :*  %&  `@`'salt'  %account 
        `account:sur`[0 ~ `@ux`'simple' 0]
        new-id
        id.p:fungible-wheat
        0xffff
        town-id
    ==
  =/  correct-act=action:sur
    [%take 0xffff `new-id 0x1.cafe 10]
  =/  correct=chick:smart
    %+  continuation
      [me.cart town-id.cart correct-act]~
    (result:smart ~[new] ~ ~ ~)
  =/  res=chick:smart  (~(write cont cart) action)
  (expect-eq !>(res) !>(correct))
::::
::::  tests for %take-with-sig
::::
++  test-take-with-sig-known-reciever
  ^-  tang
  ::  owner-1 is giving owner-2 the ability to take 30
  =/  to            pub-2
  =/  account       id.p:account-2  :: a rice of account-2  :: TODO: something is really fishy here. the account rice should have to be signed but this is fucked
  =/  from-account  id.p:account-1
  =/  amount        30
  =/  nonce         0
  =/  deadline      (add batch-num 1)
  =/  =typed-message  :-  (fry-rice:smart id.p:fungible-wheat pub-1 town-id `@`'salt')
                        (sham [pub-1 to amount nonce deadline])
  =/  sig  %+  ecdsa-raw-sign:secp256k1:secp:crypto
             (sham typed-message)
           priv-1
  =/  =action:sur
    [%take-with-sig to `account from-account amount nonce deadline sig]
  =/  =cart
    [id.p:fungible-wheat [pub-2 0] batch-num town-id]
  =/  updated-1=grain:smart
    :*  %&  `@`'salt'  %account
        `account:sur`[20 ~ `@ux`'simple' 1]
        0x1.beef
        id.p:fungible-wheat
        pub-1
        town-id
    ==
  =/  updated-2=grain:smart
    :*  %&  `@`'salt'  %account
        `account:sur`[60 ~ `@ux`'simple' 0]
        0x1.dead
        id.p:fungible-wheat
        pub-2
        town-id
    ==
  =/  res=chick:smart
    (~(write cont cart) action)
  =/  correct=chick:smart
    (result:smart ~[updated-1 updated-2] ~ ~ ~)
  (expect-eq !>(res) !>(correct))

++  test-take-with-sig-unknown-reciever  ^-  tang
  ::  owner-1 is giving owner-2 the ability to take 30
  =/  to  pub-2
  =/  account  ~  :: unkown account this time
  =/  from-account  0x1.beef
  =/  amount  30
  =/  nonce  0
  =/  deadline  (add batch-num 1)
  =/  =typed-message  :-  (fry-rice:smart id.p:fungible-wheat pub-1 town-id `@`'salt')
                      (sham [pub-1 to amount nonce deadline])
  =/  sig  %+  ecdsa-raw-sign:secp256k1:secp:crypto
             (sham typed-message)
           priv-1
  =/  =action:sur
    [%take-with-sig to account from-account amount nonce deadline sig]
  =/  =cart
    [id.p:fungible-wheat [pub-2 0] batch-num town-id] :: cart no longer knows account-2' rice
  =/  updated-1=grain:smart
    :*  %&  `@`'salt'  %account
        `account:sur`[20 ~ `@ux`'simple' 1]
        0x1.beef
        id.p:fungible-wheat
        pub-1
        town-id
    ==
  =/  new-id  (fry-rice:smart pub-2 id.p:fungible-wheat 0x1 `@`'salt')
  =/  new=grain:smart
    :*  %&  `@`'salt'  %account
        `account:sur`[30 ~ `@ux`'simple' 0]
        new-id
        id.p:fungible-wheat
        pub-2
        town-id
    ==
  =/  res=chick:smart
    (~(write cont cart) action)
  =/  correct-act=action:sur
    [%take-with-sig pub-2 `new-id 0x1.beef amount nonce deadline sig]
  =/  correct=chick:smart
    %+  continuation
      [me.cart town-id.cart correct-act]~
    (result:smart ~ ~[new] ~ ~)
  (expect-eq !>(res) !>(correct))
::::
::::  tests for %mint
::::
++  test-mint-known-receivers
  ^-  tang
  =/  =action:sur
    [%mint `@ux`'simple' (silt ~[[pub-1 `0x1.dead 50] [pub-2 `0x1.cafe 10]])]
  =/  =cart
    :*  id.p:fungible-wheat
        [pub-1 0]
        batch-num
        town-id
    ==
  =/  updated-1=grain:smart
        
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
        id.p:fungible-wheat
        `@ux`'holder'
        town-id
    ==
  =/  updated-2=grain:smart
    :*  %&  `@`'salt'  %account
        `account:sur`[80 ~ `@ux`'simple' 0]
        0x1.dead
        id.p:fungible-wheat
        pub-2
        town-id
    ==
  =/  updated-3=grain:smart
    :*  %&  `@`'salt'  %account
        `account:sur`[30 (malt ~[[0xffff 100]]) `@ux`'simple' 0]
        0x1.cafe
        id.p:fungible-wheat
        pub-3
        town-id
    ==
  =/  res=chick:smart
    (~(write cont cart) action)
  =/  correct=chick:smart
    (result:smart ~[updated-1 updated-2 updated-3] ~ ~ ~)
  (expect-eq !>(res) !>(correct))
::
++  test-mint-unknown-receiver
  ^-  tang
  =/  =action:sur
    [%mint `@ux`'simple' (silt ~[[pub-1 ~ 50]])]
  =/  =cart
    [id.p:fungible-wheat [pub-1 0] batch-num town-id]
  =/  new-id  (fry-rice:smart id.p:fungible-wheat pub-1 town-id `@`'salt')
  =/  new=grain:smart
    :*  %&  `@`'salt'  %account
      `account:sur`[0 ~ `@ux`'simple' 0]
      new-id
      id.p:fungible-wheat
      pub-1
      town-id
    ==
  =/  next-mints=(set mint:sur)
    (silt ~[[pub-1 `new-id 50]])
  =/  res=chick:smart
    (~(write cont cart) action)
  =/  correct-act=action:sur  
    [%mint `@ux`'simple' next-mints]
  =/  correct=chick:smart
    %+  continuation
      [me.cart town-id.cart correct-act]~
    (result:smart ~ ~[new] ~ ~)
  (expect-eq !>(res) !>(correct))
::::
::::  tests for %deploy
::::
++  test-deploy  ^-  tang
  =/  token-salt
    (sham (cat 3 pub-1 'TC'))
  =/  new-token-metadata=grain:smart
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
        (fry-rice:smart id.p:fungible-wheat id.p:fungible-wheat town-id token-salt)
        id.p:fungible-wheat
        id.p:fungible-wheat
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
        (fry-rice:smart id.p:fungible-wheat pub-1 town-id token-salt)
        id.p:fungible-wheat
        pub-1
        town-id
    ==
  =/  =action:sur
    [%deploy (silt ~[[pub-1 900]]) (silt ~[pub-1]) 'Test Coin' 'TC' 0 1.000 %.y]
  =/  cart
    [id.p:fungible-wheat [pub-1 0] batch-num town-id]
  =/  res=chick:smart
    (~(write cont cart) action)
  =/  correct=chick:smart
    (result:smart ~ ~[updated-account new-token-metadata] ~ ~)
  (expect-eq !>(res) !>(correct))
--
