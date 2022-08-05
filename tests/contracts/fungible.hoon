::  Tests for fungible.hoon (token contract)
::  to test, make sure to add library import at top of contract
::  (remove again before compiling for deployment)
::
/-  *mill, *zink
/+  *test, ethereum
/+  zig-sys-smart, conq=zink-conq, mill=zig-mill, merk
/+  cont=zig-contracts-fungible, *zig-contracts-lib-fungible
/*  smart-lib-noun  %noun  /lib/zig/compiled/smart-lib/noun
/*  zink-cax-noun   %noun  /lib/zig/compiled/hash-cache/noun
/*  fung-contract   %noun  /lib/zig/compiled/fungible/noun
:: TODO maybe get rid of cont=zig-contracts-fungible
=>  ::  test data
    |%
    ++  batch-num  1
    ++  town-id    0x2
    ++  fungible-wheat
      ^-  grain:smart
      =/  cont  ;;([bat=* pay=*] (cue q.q.fung-contract))
      =/  interface=lumps:smart  ~
      =/  types=lumps:smart      ~
      :*  %|
          `cont
          interface
          types
          id=`@ux`'fungible'
          lord=`@ux`'fungible'
          holder=`@ux`'fungible'
          town-id
      ==
    ++  metadata-1
      ^-  grain:smart
      :*  %&  `@`'salt'  %metadata
          ^-  token-metadata:sur
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
          `@ux`'simple-metadata-1'
          id.p:fungible-wheat
          `@ux`'holder'
          town-id
      ==
    ++  metadata-mintable
      ^-  grain:smart
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
          `@ux`'simple-mintable'
          id.p:fungible-wheat
          `@ux`'holder'
          town-id
      ==
    ::
    ::  N.B. owner zigs ids must match the ones generated in `+zig-account`
    ++  priv-1  0xbeef.beef.beef.beef.beef.beef.beef.beef.beef.beef
    ++  pub-1   (address-from-prv:key:ethereum priv-1)
    ++  owner-1
      ^-  caller:smart
      [pub-1 0 (fry-rice:smart zigs-wheat-id:smart pub-1 town-id `@`'zigsalt')]
    ++  account-1
      ^-  grain:smart
      :*  %&  `@`'salt'  %account
          `account:sur`[50 ~ `@ux`'simple' 0]
          0x1.beef
          id.p:fungible-wheat  ::  lord
          pub-1              ::  holder
          town-id
      ==
    ::
    ++  priv-2  0xdead.dead.dead.dead.dead.dead.dead.dead.dead.dead
    ++  pub-2   (address-from-prv:key:ethereum priv-2)
    ++  owner-2
      ^-  caller:smart
      [pub-2 0 (fry-rice:smart zigs-wheat-id:smart pub-2 town-id `@`'zigsalt')]
    ++  account-2  ^-  grain:smart
      :*  %&  `@`'salt'  %account
          `account:sur`[30 ~ `@ux`'simple' 0]
          0x1.dead
          id.p:fungible-wheat
          pub-2
          town-id
      ==
    ::
    ++  priv-3  0xcafe.cafe.cafe.cafe.cafe.cafe.cafe.cafe.cafe.cafe
    ++  pub-3   (address-from-prv:key:ethereum priv-3)
    ++  owner-3
      ^-  caller:smart
      [pub-3 0 (fry-rice:smart zigs-wheat-id:smart pub-3 town-id `@`'zigsalt')]
    ++  account-3
      ^-  grain:smart
      :*  %&  `@`'salt'  %account
          `account:sur`[20 (malt ~[[0xffff 100]]) `@ux`'simple' 0]
          0x1.cafe
          id.p:fungible-wheat
          pub-3
          town-id
      ==
    ::
    ++  account-4
      ^-  grain:smart
      :*  %&  `@`'diff'  %account
          `account:sur`[20 ~ `@ux`'different!' 0]
          0x1.face
          id.p:fungible-wheat
          0xface
          town-id
      ==
    ::
    ::  Mill
    ::
    ++  big  (bi:merk id:smart grain:smart)  ::  explicitly defining this to use jetted merk
    ++  pig  (bi:merk id:smart @ud)
    ::  Alternatively, we could just have mill skip budget checks
    ++  zig-account
      |=  holder=id:smart
      ^-  [id:smart grain:smart]
      =/  sal  `@`'zigsalt'
      =/  id  (fry-rice:smart zigs-wheat-id:smart holder town-id sal)
      :-  id
      :*  %&  sal  %account
          [999.999.999.999.999.999.999.999.999 ~ `@ux`'zigs']
          id
          zigs-wheat-id:smart
          holder
          town-id
      ==
    +$  mill-result
      [fee=@ud =land burned=granary =errorcode:smart hits=(list hints:zink) =crow:smart]
    ++  rate    1
    ++  budget  10
    ++  fake-sig   *sig:smart
    ++  fake-granary
      ^-  granary
      %+  gas:big  *(merk:merk id:smart grain:smart)
      :~  [id.p:fungible-wheat fungible-wheat]
          [id.p:metadata-1 metadata-1]
          [id.p:metadata-mintable metadata-mintable]
          [id.p:account-1 account-1]
          [id.p:account-2 account-2]
          [id.p:account-3 account-3]
          [id.p:account-4 account-4]
          (zig-account holder.p:account-1)
          (zig-account holder.p:account-2)
          (zig-account holder.p:account-3)
          (zig-account id.p:account-4)
      ==
    ++  fake-populace
      ^-  populace
      
      %+  gas:pig  *(merk:merk id:smart @ud)
      :~  [pub-1 0]
          [pub-2 0]
          [pub-3 0]
      ==
    ++  fake-land
      ^-  land
      [fake-granary fake-populace]
    ++  mil
      %~  mill  mill
      :+    ;;(vase (cue q.q.smart-lib-noun))
        ;;((map * @) (cue q.q.zink-cax-noun))
      %.y
    ++  miller-account
      ^-  grain:smart
      :*  %&  `@`'miller-salt'  %account
          [1.000.000 ~ `@ux`'zigs-metadata']
          0x1.1512.3341
          zigs-wheat-id:smart
          0x1512.3341
          town-id
      ==
    ++  miller  
      ^-  caller:smart
      [0x1512.3341 0 id.p:miller-account]
    --
::  testing arms
|%
++  test-matches-type  ^-  tang
  =/  valid  (mule |.(;;(contract:smart cont)))
  (expect-eq !>(%.y) !>(-.valid))
::
::  tests for %set-allowance
::
++  test-set-allowance  ^-  tang
  =/  =action:sur  [%set-allowance 0xcafe 10]
  ::~&  "zigs owner 1 {<zigs:owner-1>}"
  =/  shel=shell:smart
    [[id +(nonce) zigs]:owner-1 ~ id.p:fungible-wheat rate budget town-id 0]
  =/  updated-1=grain:smart
    :*  %&  `@`'salt'  %account
        `account:sur`[50 (malt ~[[0xcafe 10]]) `@ux`'simple' 0]
        id.p:account-1
        id.p:fungible-wheat
        pub-1
        town-id
    ==
  =/  correct=chick:smart  (result:smart ~[updated-1] ~ ~ ~)
  ~&  >  (key:big fake-granary)
  =/  milled=mill-result
    %+  ~(mill mil miller town-id 1)
    fake-land  `egg:smart`[fake-sig shel action]
  ::~&  >>  (key:big p.land.milled)
  ::~&  >  p.land.milled
  ~&  milled
  =/  res=grain:smart  (got:big p.land.milled id.p:account-1)
  (expect-eq !>(res) !>(correct))
::
::  tests for %give
::
::++  test-give-known-receiver
::  ^-  tang
::  =/  =action:sur
::    [%give id.p:account-1 pub-2 `id.p:account-2 30]
::  =/  =cart
::    [id.p:fungible-wheat [pub-2 0] batch-num town-id]
::  =/  updated-1=grain:smart
::    :*  %&  `@`'salt'  %account
::        `account:sur`[20 ~ `@ux`'simple' 0]
::        0x1.beef
::        id.p:fungible-wheat
::        pub-1
::        town-id
::    ==
::  =/  updated-2=grain:smart
::    :*  %&  `@`'salt'  %account
::        `account:sur`[60 ~ `@ux`'simple' 0]
::        0x1.dead
::        id.p:fungible-wheat
::        pub-2
::        town-id
::    ==
::  =/  res=chick:smart      (~(write cont cart) action)
::  =/  correct=chick:smart  (result:smart ~[updated-1 updated-2] ~ ~ ~)
::  (expect-eq !>(res) !>(correct))
::::
::++  test-give-unknown-receiver
::  ^-  tang
::  =/  =action:sur  [%give id.p:account-1 0xffff ~ 30]
::  =/  =cart
::    [id.p:fungible-wheat [pub-1 0] batch-num town-id]
::  =/  new-id  (fry-rice:smart id.p:fungible-wheat 0xffff town-id `@`'salt')
::  =/  new=grain:smart
::    :*  %&  `@`'salt'  %account
::        `account:sur`[0 ~ `@ux`'simple' 0]
::        new-id
::        id.p:fungible-wheat
::        0xffff
::        town-id
::    ==
::  =/  res=chick:smart  (~(write cont cart) action)
::  =/  correct-act=action:sur
::    [%give id.p:account-1 0xffff `new-id 30]
::  =/  correct=chick:smart
::    %+  continuation
::      [me.cart town-id.cart correct-act]~
::    (result:smart ~[new] ~ ~ ~)
::  (expect-eq !>(res) !>(correct))
::::
::++  test-give-not-enough
::  ^-  tang
::  =/  =action:sur  [%give id.p:account-1 0xdead `id.p:account-2 51]
::  =/  =cart        [id.p:fungible-wheat [pub-1 0] batch-num town-id]
::  =/  res=(each * (list tank))
::    (mule |.((~(write cont cart) action)))
::  (expect-eq !>(%.n) !>(-.res))
::::
::++  test-give-metadata-mismatch
::  ^-  tang
::  =/  =action:sur  [%give id.p:account-1 0xface `0x1.face 10]
::  =/  =cart        [id.p:fungible-wheat [pub-1 0] batch-num town-id]
::  =/  res=(each * (list tank))
::    (mule |.((~(write cont cart) action)))
::  (expect-eq !>(%.n) !>(-.res))
::::
::::  tests for %take
::::
::++  test-take-send-new-account  ^-  tang
::  =/  =action:sur  [%take 0xffff ~ 0x1.cafe 10]
::  =/  =cart
::    [id.p:fungible-wheat [0xffff 0] batch-num town-id]
::  =/  new-id=id:smart  (fry-rice:smart id.p:fungible-wheat 0xffff town-id `@ux`'salt')
::  =/  new=grain:smart
::    :*  %&  `@`'salt'  %account 
::        `account:sur`[0 ~ `@ux`'simple' 0]
::        new-id
::        id.p:fungible-wheat
::        0xffff
::        town-id
::    ==
::  =/  correct-act=action:sur
::    [%take 0xffff `new-id 0x1.cafe 10]
::  =/  correct=chick:smart
::    %+  continuation
::      [me.cart town-id.cart correct-act]~
::    (result:smart ~[new] ~ ~ ~)
::  =/  res=chick:smart  (~(write cont cart) action)
::  (expect-eq !>(res) !>(correct))
::::
::::  tests for %take-with-sig
::::
::++  test-take-with-sig-known-reciever
::  ^-  tang
::  ::  owner-1 is giving owner-2 the ability to take 30
::  =/  to            pub-2
::  =/  account       id.p:account-2  :: a rice of account-2  :: TODO: something is really fishy here. the account rice should have to be signed but this is fucked
::  =/  from-account  id.p:account-1
::  =/  amount        30
::  =/  nonce         0
::  =/  deadline      (add batch-num 1)
::  =/  =typed-message  :-  (fry-rice:smart id.p:fungible-wheat pub-1 town-id `@`'salt')
::                        (sham [pub-1 to amount nonce deadline])
::  =/  sig  %+  ecdsa-raw-sign:secp256k1:secp:crypto
::             (sham typed-message)
::           priv-1
::  =/  =action:sur
::    [%take-with-sig to `account from-account amount nonce deadline sig]
::  =/  =cart
::    [id.p:fungible-wheat [pub-2 0] batch-num town-id]
::  =/  updated-1=grain:smart
::    :*  %&  `@`'salt'  %account
::        `account:sur`[20 ~ `@ux`'simple' 1]
::        0x1.beef
::        id.p:fungible-wheat
::        pub-1
::        town-id
::    ==
::  =/  updated-2=grain:smart
::    :*  %&  `@`'salt'  %account
::        `account:sur`[60 ~ `@ux`'simple' 0]
::        0x1.dead
::        id.p:fungible-wheat
::        pub-2
::        town-id
::    ==
::  =/  res=chick:smart
::    (~(write cont cart) action)
::  =/  correct=chick:smart
::    (result:smart ~[updated-1 updated-2] ~ ~ ~)
::  (expect-eq !>(res) !>(correct))

::++  test-take-with-sig-unknown-reciever  ^-  tang
::  ::  owner-1 is giving owner-2 the ability to take 30
::  =/  to  pub-2
::  =/  account  ~  :: unkown account this time
::  =/  from-account  0x1.beef
::  =/  amount  30
::  =/  nonce  0
::  =/  deadline  (add batch-num 1)
::  =/  =typed-message  :-  (fry-rice:smart id.p:fungible-wheat pub-1 town-id `@`'salt')
::                      (sham [pub-1 to amount nonce deadline])
::  =/  sig  %+  ecdsa-raw-sign:secp256k1:secp:crypto
::             (sham typed-message)
::           priv-1
::  =/  =action:sur
::    [%take-with-sig to account from-account amount nonce deadline sig]
::  =/  =cart
::    [id.p:fungible-wheat [pub-2 0] batch-num town-id] :: cart no longer knows account-2' rice
::  =/  updated-1=grain:smart
::    :*  %&  `@`'salt'  %account
::        `account:sur`[20 ~ `@ux`'simple' 1]
::        0x1.beef
::        id.p:fungible-wheat
::        pub-1
::        town-id
::    ==
::  =/  new-id  (fry-rice:smart pub-2 id.p:fungible-wheat 0x1 `@`'salt')
::  =/  new=grain:smart
::    :*  %&  `@`'salt'  %account
::        `account:sur`[30 ~ `@ux`'simple' 0]
::        new-id
::        id.p:fungible-wheat
::        pub-2
::        town-id
::    ==
::  =/  res=chick:smart
::    (~(write cont cart) action)
::  =/  correct-act=action:sur
::    [%take-with-sig pub-2 `new-id 0x1.beef amount nonce deadline sig]
::  =/  correct=chick:smart
::    %+  continuation
::      [me.cart town-id.cart correct-act]~
::    (result:smart ~ ~[new] ~ ~)
::  (expect-eq !>(res) !>(correct))
::::
::::  tests for %mint
::::
::++  test-mint-known-receivers
::  ^-  tang
::  =/  =action:sur
::    [%mint `@ux`'simple' (silt ~[[pub-1 `0x1.dead 50] [pub-2 `0x1.cafe 10]])]
::  =/  =cart
::    :*  id.p:fungible-wheat
::        [pub-1 0]
::        batch-num
::        town-id
::    ==
::  =/  updated-1=grain:smart
        
::    :*  %&  `@`'salt'  %metadata
::        ^-  token-metadata:sur
::        :*  name='Simple Token'
::            symbol='ST'
::            decimals=0
::            supply=160
::            cap=`1.000
::            mintable=%.n
::            minters=(silt ~[pub-1])
::            deployer=0x0
::            salt=`@`'salt'
::        ==
::        `@ux`'simple'
::        id.p:fungible-wheat
::        `@ux`'holder'
::        town-id
::    ==
::  =/  updated-2=grain:smart
::    :*  %&  `@`'salt'  %account
::        `account:sur`[80 ~ `@ux`'simple' 0]
::        0x1.dead
::        id.p:fungible-wheat
::        pub-2
::        town-id
::    ==
::  =/  updated-3=grain:smart
::    :*  %&  `@`'salt'  %account
::        `account:sur`[30 (malt ~[[0xffff 100]]) `@ux`'simple' 0]
::        0x1.cafe
::        id.p:fungible-wheat
::        pub-3
::        town-id
::    ==
::  =/  res=chick:smart
::    (~(write cont cart) action)
::  =/  correct=chick:smart
::    (result:smart ~[updated-1 updated-2 updated-3] ~ ~ ~)
::  (expect-eq !>(res) !>(correct))
::::
::++  test-mint-unknown-receiver
::  ^-  tang
::  =/  =action:sur
::    [%mint `@ux`'simple' (silt ~[[pub-1 ~ 50]])]
::  =/  =cart
::    [id.p:fungible-wheat [pub-1 0] batch-num town-id]
::  =/  new-id  (fry-rice:smart id.p:fungible-wheat pub-1 town-id `@`'salt')
::  =/  new=grain:smart
::    :*  %&  `@`'salt'  %account
::      `account:sur`[0 ~ `@ux`'simple' 0]
::      new-id
::      id.p:fungible-wheat
::      pub-1
::      town-id
::    ==
::  =/  next-mints=(set mint:sur)
::    (silt ~[[pub-1 `new-id 50]])
::  =/  res=chick:smart
::    (~(write cont cart) action)
::  =/  correct-act=action:sur  
::    [%mint `@ux`'simple' next-mints]
::  =/  correct=chick:smart
::    %+  continuation
::      [me.cart town-id.cart correct-act]~
::    (result:smart ~ ~[new] ~ ~)
::  (expect-eq !>(res) !>(correct))
::::
::::  tests for %deploy
::::
::++  test-deploy  ^-  tang
::  =/  token-salt
::    (sham (cat 3 pub-1 'TC'))
::  =/  new-token-metadata=grain:smart
::    :*  %&  token-salt  %metadata
::        ^-  token-metadata:sur
::        :*  'Test Coin'
::            'TC'
::            0
::            900
::            `1.000
::            %.y
::            (silt ~[pub-1])
::            pub-1
::            token-salt
::        ==
::        (fry-rice:smart id.p:fungible-wheat id.p:fungible-wheat town-id token-salt)
::        id.p:fungible-wheat
::        id.p:fungible-wheat
::        town-id
::    ==
::  =/  updated-account=grain
::    :*  %&  token-salt  %account
::        ^-  account:sur
::        :*  900
::            ~
::            id.p.new-token-metadata
::            0
::        ==
::        (fry-rice:smart id.p:fungible-wheat pub-1 town-id token-salt)
::        id.p:fungible-wheat
::        pub-1
::        town-id
::    ==
::  =/  =action:sur
::    [%deploy (silt ~[[pub-1 900]]) (silt ~[pub-1]) 'Test Coin' 'TC' 0 1.000 %.y]
::  =/  cart
::    [id.p:fungible-wheat [pub-1 0] batch-num town-id]
::  =/  res=chick:smart
::    (~(write cont cart) action)
::  =/  correct=chick:smart
::    (result:smart ~ ~[updated-account new-token-metadata] ~ ~)
::  (expect-eq !>(res) !>(correct))
--
