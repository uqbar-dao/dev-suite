::  fungible.hoon tests
/-  zink
/+  *test, smart=zig-sys-smart, *sequencer, merk, ethereum
/*  smart-lib-noun     %noun  /lib/zig/sys/smart-lib/noun
/*  zink-cax-noun      %noun  /lib/zig/sys/hash-cache/noun
/*  zigs-contract      %noun  /con/compiled/zigs/noun
/*  fungible-contract  %noun  /con/compiled/fungible/noun
|%
::
::  constants / dummy info for mill
::
++  big  (bi:merk id:smart item:smart)  ::  merkle engine for granary
++  pig  (bi:merk id:smart @ud)          ::                for populace
++  batch-num  1
++  town-id    0x2
++  rate    1
++  budget  100.000
++  fake-sig   [0 0 0]
++  mil
  %~  mill  mill
  :+    ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
    ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun)))
  %.y
::
+$  granary   (merk:merk id:smart item:smart)
+$  single-result
  [fee=@ud =land burned=granary =errorcode:smart hits=(list hints:zink) =crow:smart]
++  gilt
  ::  grains list to granary
  |=  grz=(list item:smart)
  (gas:big *granary (turn grz |=(g=item:smart [id.p.g g])))
::
::  fake data
::
++  miller
  ^-  caller:smart
  :+  0x24c.23b9.8535.cd5a.0645.5486.69fb.afbf.095e.fcc0
    1
  (zig-id:zigs 0x24c.23b9.8535.cd5a.0645.5486.69fb.afbf.095e.fcc0)
++  caller-1  ^-  caller:smart  [holder-1:zigs 1 (zig-id:zigs holder-1:zigs)]
++  caller-2  ^-  caller:smart  [holder-2:zigs 1 (zig-id:zigs holder-2:zigs)]
++  caller-3  ^-  caller:smart  [holder-3:zigs 1 (zig-id:zigs holder-3:zigs)]
++  caller-4  ^-  caller:smart  [holder-4:zigs 1 (zig-id:zigs holder-4:zigs)]
::
++  zigs
  |%
  ++  holder-1  0xd387.95ec.b77f.b88e.c577.6c20.d470.d13c.8d53.2169
  ++  holder-2  0x75f.da09.d4aa.19f2.2cad.929c.aa3c.aa7c.dca9.5902
  ++  holder-3  0xa2f8.28f2.75a3.28e1.3ba1.25b6.0066.c4ea.399d.88c7
  ++  holder-4  0xface.face.face.face.face.face.face.face.face.face
  ++  zig-id
    |=  holder=id:smart
    (fry-data:smart zigs-contract-id:smart holder town-id `@`'zigs')
  ++  zig-account
    |=  [holder=id:smart amt=@ud]
    ^-  item:smart
    =/  id  (zig-id holder)
    :*  %&  `@`'zigs'  %account
        [amt ~ `@ux`'zigs-metadata-id']
        id
        zigs-contract-id:smart
        holder
        town-id
    ==
  ++  wheat
    ^-  item:smart
    =/  cont  ;;([bat=* pay=*] (cue +.+:;;([* * @] zigs-contract)))
    =/  interface  ~
    =/  types  ~
    :*  %|
        `cont
        interface
        types
        zigs-contract-id:smart  ::  id
        zigs-contract-id:smart  ::  lord
        zigs-contract-id:smart  ::  holder
        town-id
    ==
  --
::
::
::
::  N.B. owner zigs ids must match the ones generated in `+zig-account`
++  fun-account
  |=  [holder=id:smart amt=@ud meta=item:smart allowances=(pmap:smart address:smart @ud)]
  ::  meta - metadata of the fungible account. defaults to `@ux`'simple' unless provided
  ^-  item:smart
  ?>  ?=(%& -.meta)
  =/  id  (fry-data:smart id.p:fungible-wheat holder town-id salt.p.meta)
  :*  %&  salt.p.meta  %account
      [amt allowances id.p:meta 0]
      id
      id.p:fungible-wheat
      holder
      town-id
  ==
::
++  account-1-mintable
  (fun-account holder-1:zigs 50 token-mintable ~)
++  account-2-mintable
  (fun-account holder-2:zigs 50 token-mintable ~)
++  account-1
  (fun-account holder-1:zigs 50 token-simple ~)
++  account-2
  (fun-account holder-2:zigs 50 token-simple ~)
++  account-3
  %:  fun-account
      holder-3:zigs
      20
      token-simple
      (~(gas py:smart *(pmap:smart address:smart @ud)) ~[[id:caller-4 10]])
  ==
++  account-4-different
  (fun-account holder-4:zigs 20 token-different ~)
::
++  fungible-wheat
  ^-  item:smart
  =/  cont  ;;([bat=* pay=*] (cue +.+:;;([* * @] fungible-contract)))
  =/  interface  ~
  =/  types  ~
  :*  %|
      `cont
      interface
      types
      id=`@ux`'fungible'
      lord=`@ux`'fungible'
      holder=`@ux`'fungible'
      town-id
  ==
::
++  token-simple
  ^-  item:smart
  =+  deployer=0x0
  =+  sal=`@`'simple-token'
  :*  %&  sal  %metadata
      :*  name='Simple Token'
          'ST'
          decimals=0
          supply=100
          cap=~
          mintable=%.n
          minters=~
          deployer
          sal
      ==
      `@ux`'simple-metadata-1'
      id.p:fungible-wheat
      id.p:fungible-wheat
      town-id
  ==
++  token-mintable
  ^-  item:smart
  =+  deployer=0x0
  =+  sym='STM'
  :*  %&  `@`'simple-token-mintable'  %metadata
      :*  name='Simple Token Mintable'
          sym
          decimals=0
          supply=100
          cap=`1.000
          mintable=%.y
          minters=(~(gas pn:smart *(pset:smart address:smart)) ~[id:caller-1])
          deployer
          `@`'simple-token-mintable'
      ==
      `@ux`'simple-mintable'
      id.p:fungible-wheat
      id.p:fungible-wheat
      town-id
  ==
++  token-different
  ^-  item:smart
  =+  deployer=0x0
  =+  sym='DIF'
  :*  %&  `@`'different-token'  %metadata
      :*  name='Different'
          sym
          decimals=0
          supply=0
          cap=`12
          mintable=%.y
          minters=(~(gas pn:smart *(pset:smart address:smart)) ~[id:caller-1])
          deployer
          `@`'different-token'
      ==
      `@ux`'different-token'
      id.p:fungible-wheat
      id.p:fungible-wheat
      town-id
  ==
++  salt-of
  |=  tok=item:smart
  ?>  ?=(%& -.tok)
  salt.p.tok
::
++  token-metadata-mold
  $:  name=@t                 ::  the name of a token (not unique!)
      symbol=@t               ::  abbreviation (also not unique)
      decimals=@ud            ::  granularity (maximum defined by implementation)
      supply=@ud              ::  total amount of token in existence
      cap=(unit @ud)          ::  supply cap (~ if no cap)
      mintable=?              ::  whether or not more can be minted
      minters=(pset:smart address:smart)  ::  pubkeys permitted to mint, if any
      deployer=address:smart        ::  pubkey which first deployed token
      salt=@
  ==
::
::
::
++  fake-granary
  ^-  granary
  %-  gilt
  :~  fungible-wheat
      token-simple
      token-mintable
      token-different
      account-1
      account-2
      account-3
      account-4-different
      account-1-mintable
      account-2-mintable
      (zig-account:zigs id:caller-1 999.999.999)
      (zig-account:zigs id:caller-2 999.999.999)
      (zig-account:zigs id:caller-3 999.999.999)
      (zig-account:zigs id:caller-4 999.999.999)
      (zig-account:zigs id:miller 999.999.999)
  ==
++  fake-populace
  ^-  populace
  %+  gas:pig  *(merk:merk id:smart @ud)
  :~  [id:caller-1 0]
      [id:caller-2 0]
      [id:caller-3 0]
  ==
++  fake-land
  ^-  land
  [fake-granary fake-populace]
::
++  test-set-allowance
  ^-  tang
  =/  action  [%set-allowance id:caller-3 10 id.p:account-1]
  =/  shel=shell:smart
    [caller-1 ~ id.p:fungible-wheat rate budget town-id 0]
  =/  updated-1=item:smart
    (fun-account id:caller-1 50 token-simple (malt ~[[id:caller-3 10]]))
  =/  milled=single-result
    %+  ~(mill mil miller town-id 1)
    fake-land  `transaction:smart`[fake-sig shel action]
  =/  res=item:smart  (got:big p.land.milled id.p:account-1)
  =*  correct  updated-1
  (expect-eq !>(correct) !>(res))
::
::  %give
::
++  test-give-known-receiver  ::  failing on a subtract
  ^-  tang
  =/  action  [%give id:caller-2 30 id.p:account-1 `id.p:account-2]
  =/  shel=shell:smart
    [caller-1 ~ id.p:fungible-wheat rate budget town-id 0]
  =/  updated-1=item:smart  (fun-account id:caller-1 20 token-simple ~)
  =/  updated-2=item:smart  (fun-account id:caller-2 80 token-simple ~)
  =/  milled=single-result
    %+  ~(mill mil miller town-id 1)
    fake-land  `transaction:smart`[fake-sig shel action]
  =/  expected=granary  (gas:big *granary ~[[id.p:updated-1 updated-1] [id.p:updated-2 updated-2]])
  ::  N.B. we use int to filter out any grains whose keys are not in expected,
  ::  but preserve the values of those keys from p.land.milled. this is a recurring pattern
  =/  res=granary       (int:big expected p.land.milled)
  (expect-eq !>(expected) !>(res))
++  test-give-unknown-receiver  ::  failing on a subtract
  ^-  tang
  =/  action  [%give id:caller-4 30 id.p:account-1 ~]
  =/  shel=shell:smart
    [caller-1 ~ id.p:fungible-wheat rate budget town-id 0]
  =/  new-id  (fry-data:smart id.p:fungible-wheat id:caller-4 town-id (salt-of token-simple))
  =/  new=item:smart  (fun-account id:caller-4 30 token-simple ~)
  =/  milled=single-result
    %+  ~(mill mil miller town-id 1)
    fake-land  `transaction:smart`[fake-sig shel action]
  =/  res=item:smart  (got:big p.land.milled new-id)
  =*  correct  new
  (expect-eq !>(correct) !>(res))
++  test-give-not-enough
  ^-  tang
  ::  should fail on a subtract
  =/  action  [%give id:caller-2 51 id.p:account-1 `id.p:account-2]
  =/  shel=shell:smart
    [caller-1 ~ id.p:fungible-wheat rate budget town-id 0]
  =/  milled=single-result
    %+  ~(mill mil miller town-id 1)
    fake-land  `transaction:smart`[fake-sig shel action]
  (expect-eq !>(%6) !>(errorcode.milled))
++  test-give-metadata-mismatch
  ^-  tang
  =/  action  [%give id:caller-4 10 id.p:account-1 `id.p:account-4-different]
  =/  shel=shell:smart
    [caller-1 ~ id.p:fungible-wheat rate budget town-id 0]
  =/  milled=single-result
    %+  ~(mill mil miller town-id 1)
    fake-land  `transaction:smart`[fake-sig shel action]
  (expect-eq !>(%6) !>(errorcode.milled))
::
:: %take
::
++  test-take-send-new-account
  ^-  tang
  ::  taking 10 "simple token" from account-3
  ::  will produce a new account for caller-4, who has none
  =/  action  [%take id:caller-4 10 id.p:account-3 ~]
  =/  shel=shell:smart
    [caller-4 ~ id.p:fungible-wheat rate budget town-id 0]
  =/  new-id=id:smart  (fry-data:smart id.p:fungible-wheat id:caller-4 town-id (salt-of token-simple))
  =/  correct=item:smart  (fun-account id:caller-4 10 token-simple ~)
  =/  milled=single-result
    %+  ~(mill mil miller town-id 1)
    fake-land  `transaction:smart`[fake-sig shel action]
  =/  res=item:smart  (got:big p.land.milled new-id)
  (expect-eq !>(correct) !>(res))
::
::  %mint
::
++  test-mint-known-receivers
  ^-  tang
  =/  action
    :*  %mint
        id.p:token-mintable
        ~[[id:caller-1 `id.p:account-1-mintable 50] [id:caller-2 `id.p:account-2-mintable 10]]
    ==
  =/  shel=shell:smart
    [caller-1 ~ id.p:fungible-wheat rate budget town-id 0]
  =/  new-simp-meta=item:smart
    =-  [%& tok(supply.data 160)]
    tok=(husk:smart token-metadata-mold token-mintable ~ ~)
  =/  updated-1=item:smart
    (fun-account id:caller-1 100 token-mintable ~)
  =/  updated-2=item:smart
    (fun-account id:caller-2 60 token-mintable ~)
  =/  milled=single-result
    %+  ~(mill mil miller town-id 1)
    fake-land  `transaction:smart`[fake-sig shel action]
  =/  expected=granary  (gilt ~[new-simp-meta updated-1 updated-2])
  =/  res=granary       (int:big expected p.land.milled)
  (expect-eq !>(expected) !>(res))
++  test-mint-unknown-receiver
  ^-  tang
  =/  action
    [%mint id.p:token-mintable ~[[id:caller-3 ~ 50]]]
  =/  shel=shell:smart
    [caller-1 ~ id.p:fungible-wheat rate budget town-id 0]
  =/  expected=item:smart
    (fun-account id:caller-3 50 token-mintable ~)
  =/  milled=single-result
    %+  ~(mill mil miller town-id 1)
    fake-land  `transaction:smart`[fake-sig shel action]
  =/  res=item:smart  (got:big p.land.milled id.p:expected)
  (expect-eq !>(expected) !>(res))
::
::  %take-with-sig
::
::++  test-take-with-sig-known-reciever
::  ^-  tang
::  ::  owner-1 is giving owner-2 the ability to take 30
::  =/  to            id:caller-2
::  =/  account       id.p:account-2  :: a rice of account-2  :: TODO: something is really fishy here. the account rice should have to be signed but this is fucked
::  =/  from-account  id.p:account-1
::  =/  amount        30
::  =/  nonce         0
::  =/  deadline      (add batch-num 1)
::  =/  =typed-message:smart
::    :-  (fry-data:smart id.p:fungible-wheat id:caller-1 town-id (salt-of account-1))
::    (sham [id:caller-1 to amount nonce deadline])
::  =/  sig
::    %+  ecdsa-raw-sign:secp256k1:secp:crypto
::      (sham typed-message)
::    priv-1
::  =/  =action:sur:fun
::    [%take-with-sig to `account from-account amount nonce deadline sig]
::  ::  this bad boi guzzles gas like crazy
::  =/  shel=shell:smart
::    [caller-2 ~ id.p:fungible-wheat rate 999.999.999 town-id 0]
::  =/  updated-1=item:smart
::    =-  [%& g(nonce.data 1)]
::    g=(husk:smart account:sur:fun (fun-account id:caller-1 20 token-simple ~) ~ ~)
::  =/  updated-2=item:smart
::    (fun-account id:caller-2 60 token-simple ~)
::  =/  milled=single-result
::    %+  ~(mill mil miller town-id 1)
::    fake-land  `transaction:smart`[fake-sig shel action]
::  =/  expected=granary  (gilt ~[updated-1 updated-2])
::  =/  res=granary       (int:big expected p.land.milled)
::  (expect-eq !>(expected) !>(res))
::++  test-take-with-sig-unknown-reciever  ^-  tang
::  ::  owner-1 is giving owner-2 the ability to take 30
::  =/  to  id:caller-2
::  =/  account  ~  :: unkown account this time
::  =/  from-account  0x1.beef
::  =/  amount  30
::  =/  nonce  0
::  =/  deadline  (add batch-num 1)
::  =/  =typed-message  :-  (fry-data:smart id.p:fungible-wheat id:caller-1 town-id `@`'salt')
::                      (sham [id:caller-1 to amount nonce deadline])
::  =/  sig  %+  ecdsa-raw-sign:secp256k1:secp:crypto
::             (sham typed-message)
::           priv-1
::  =/  =action:sur
::    [%take-with-sig to account from-account amount nonce deadline sig]
::  =/  =cart
::    [id.p:fungible-wheat [id:caller-2 0] batch-num town-id] :: cart no longer knows account-2' rice
::  =/  updated-1=item:smart
::    :*  %&  `@`'salt'  %account
::        `account:sur`[20 ~ `@ux`'simple' 1]
::        0x1.beef
::        id.p:fungible-wheat
::        id:caller-1
::        town-id
::    ==
::  =/  new-id  (fry-data:smart id:caller-2 id.p:fungible-wheat 0x1 `@`'salt')
::  =/  new=item:smart
::    :*  %&  `@`'salt'  %account
::        `account:sur`[30 ~ `@ux`'simple' 0]
::        new-id
::        id.p:fungible-wheat
::        id:caller-2
::        town-id
::    ==
::  =/  res=chick:smart
::    (~(write cont cart) action)
::  =/  correct-act=action:sur
::    [%take-with-sig id:caller-2 `new-id 0x1.beef amount nonce deadline sig]
::  =/  correct=chick:smart
::    %+  continuation
::      [me.cart town-id.cart correct-act]~
::    (result:smart ~ ~[new] ~ ~)
::  (expect-eq !>(res) !>(correct))
::::
::::
::::  %deploy
::::
::++  test-deploy
::  ::  XX this test infinite loops because of a problematic tap:in callsite in handling `%deploy`
::  ^-  tang
::  =/  token-salt  (sham (cat 3 id:caller-1 'TC'))
::  =/  new-token-metadata=item:smart
::    :*  %&  token-salt  %metadata
::        ^-  token-metadata:sur:fun
::        :*  'Test Coin'
::            'TC'
::            0
::            900
::            `1.000
::            %.y
::            (silt ~[id:caller-1])
::            id:caller-1
::        ==
::        (fry-data:smart id.p:fungible-wheat id.p:fungible-wheat town-id token-salt)
::        id.p:fungible-wheat
::        id.p:fungible-wheat
::        town-id
::    ==
::  =/  new-account=item:smart
::    (fun-account id:caller-1 900 new-token-metadata ~)
::  =/  =action:sur:fun
::    [%deploy (silt ~[[id:caller-1 900]]) (silt ~[id:caller-1]) 'Test Coin' 'TC' 0 1.000 %.y]
::  =/  shel=shell:smart
::    [caller-1 ~ id.p:fungible-wheat rate budget town-id 0]
::  =/  milled=single-result
::    %+  ~(mill mil miller town-id 1)
::    fake-land  `transaction:smart`[fake-sig shel action]
::  =/  expected=granary  (gilt ~[new-account new-token-metadata])
::  =/  res=granary       (int:big expected p.land.milled)
::  (expect-eq !>(expected) !>(res))
--