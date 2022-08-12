::  fungible.hoon [UQ| DAO]
::
::  Fungible token implementation. Any new token that wishes to use this
::  format can be issued through this contract. The contract uses an account
::  model, where each pubkey holds one rice that contains their balance and
::  alllowances. (Allowances permit a certain pubkey to spend tokens on your
::  behalf.) When issuing a new token, you can either designate a pubkey or
::  pubkeys who is permitted to mint, or set a permanent supply, all of which
::  must be distributed at first issuance.
::
::  Each newly issued token also issues a single rice which stores metadata
::  about the token, which this contract both holds and is lord of, and must
::  be included in any transactions involving that token.
::
::  Many tokens that perform various utilities will want to retain control
::  over minting, burning, and sending. They can of course write their own
::  contract to custom-handle all of these scenarios, or write a manager
::  which performs custom logic but calls back to this contract for the
::  base token actions. Any token that maintains the same metadata and account
::  format, even if using a different contract (such as zigs) should be
::  composable among tools designed to this standard.
::
::  Tokens that wish to be properly displayed and handled with no additional
::  work in the wallet agent should implement the same structure for their
::  rice.
::
  ::/+  *zig-sys-smart
/=  fungible  /lib/zig/contracts/lib/fungible
=,  fungible
|_  =cart
++  write
  |=  act=action:sur
  ^-  chick
  ::  TODO extract logic out into library for reuse
  ::
  ::  the execution arm. branches on argument type and returns final result.
  ::  note that many of these lines will crash with bad input. this is good,
  ::  because we don't want failing transactions to waste more gas than required
  ::
  ::
  ::  N.B: arms which re-enter themselves (i.e. continuation calls to me.cart)
  ::  cannot depend on id.from.cart being the caller, since in a continuation call
  ::  id.from.cart == me.cart. this is why we simply accept what we'd otherwise use caller for
  ::  explicitly as part of the arguments
  ::
  ::  N.B: in the current implementation, `account`s have the same salts as their collections
  ::  This could maybe cause problems if one is not careful.
  ?-    -.act
      %give
    =/  giv=grain          (need (scry from-account.act))
    ?>  ?=(%& -.giv)
    =/  giver=account:sur  data:(husk account:sur giv `me.cart ~)
    ?>  ?|(=(id.from.cart holder.p.giv) =(id.from.cart me.cart))  :: needed to allow reentrancy
    ?>  (gte balance.giver amount.act)
    ?:  ?=(~ to-account.act)
      ::  if receiver doesn't have an account, try to produce one for them
      =/  =id          (fry-rice me.cart to.act town-id.cart salt.p.giv)
      =/  new=grain    [%& salt.p.giv %account [0 ~ metadata.giver 0] id me.cart to.act town-id.cart]
      =/  =action:sur  [%give from-account=id.p.giv to.act to-account=`id.p.new amount.act]
      ::  continuation call: %give to rice we issued
      %+  continuation
        [me.cart town-id.cart action]~
      (result ~ [new ~] ~ ~)
    ::  otherwise, add to the existing account for that pubkey
    ::  giving account in embryo, and receiving one in owns.cart
    =/  rec=grain  (need (scry u.to-account.act))
    =/  receiver   data:(husk account:sur rec `me.cart `to.act)
    ?>  ?=(%& -.rec)
    ::  assert that tokens match
    ?>  =(metadata.receiver metadata.giver)
    ::  alter the two balances inside the grains
    =:  data.p.giv  giver(balance (sub balance.giver amount.act))
        data.p.rec  receiver(balance (add balance.receiver amount.act))
    ==
    ::  return the result: two changed grains
    (result [giv rec ~] ~ ~ ~)
  ::
      %take
    =/  giv=grain  (need (scry from-account.act))
    ?>  ?=(%& -.giv)
    =/  giver=account:sur  data:(husk account:sur giv `me.cart ~)
    =/  allowance=@ud  (~(got by allowances.giver) to.act)
    ::  assert caller is permitted to spend this amount of token
    ?>  (gte balance.giver amount.act)
    ?>  (gte allowance amount.act)
    ?~  account.act
      ::  create new rice for reciever and add it to state
      =/  =id          (fry-rice me.cart to.act town-id.cart salt.p.giv)
      =/  new=grain    [%& salt.p.giv %account [0 ~ metadata.giver 0] id me.cart to.act town-id.cart]
      =/  =action:sur  [%take to.act `id.p.new id.p.giv amount.act]
      ::  continuation call: %take to rice found in book
      %+  continuation
        [me.cart town-id.cart action]~
      (result ~ [new ~] ~ ~)
    ::  direct send
    =/  rec=grain  (need (scry u.account.act))
    =/  receiver   data:(husk account:sur rec `me.cart `to.act)
    ?>  ?=(%& -.rec)
    ?>  =(metadata.receiver metadata.giver)
    ::  update the allowance of taker
    =:  data.p.rec
      receiver(balance (add balance.receiver amount.act))
    ::
        data.p.giv
      %=  giver
        balance     (sub balance.giver amount.act)
        allowances  %+  ~(jab by allowances.giver)
                      to.act
                    |=(old=@ud (sub old amount.act))
      ==
    ==
    (result [giv rec ~] ~ ~ ~)
  ::
      %take-with-sig
    ::  %take-with-sig allows for gasless approvals for transferring tokens
    ::  the giver must sign the from-account id and the typed +$approve struct above
    ::  and the taker will pass in the signature to take the tokens
    =/  giv=grain          (need (scry from-account.act))
    ?>  ?=(%& -.giv)
    =/  giver=account:sur  data:(husk account:sur giv `me.cart `to.act)
    ::  reconstruct the typed message and hash
    =/  =typed-message
      :-  (fry-rice me.cart holder.p.giv town-id.cart salt.p.giv)
      (sham [holder.p.giv to.act amount.act nonce.act deadline.act])
    =/  signed-hash  (sham typed-message)
    ::  recover the address from the message and signature
    =/  recovered-address
      %-  address-from-pub
      %-  serialize-point:secp256k1:secp:crypto
      (ecdsa-raw-recover:secp256k1:secp:crypto signed-hash sig.act)
    ::  assert the signature is valid
    ?>  =(recovered-address holder.p.giv)
    :: TODO need to figure out how to implement the deadline since now.cart no longer exists
    ?>  (lte batch.cart deadline.act)
    ?>  (gte balance.giver amount.act)
    ?~  account.act
    ::  create new rice for reciever and add it to state
      =+  (fry-rice to.act me.cart town-id.cart salt.p.giv)
      =/  new=grain
        [%& salt.p.giv %account [amount.act ~ metadata.giver 0] - me.cart to.act town-id.cart]
      ::  continuation call: %take to rice found in book
      =/  =action:sur  [%take-with-sig to.act `id.p.new id.p.giv amount.act nonce.act deadline.act sig.act]
      %+  continuation
        [me.cart town-id.cart action]~
      (result [new ~] ~ ~ ~)
    ::  direct send
    =/  rec=grain  (need (scry u.account.act))
    =/  receiver   data:(husk account:sur rec `me.cart `to.act)
    ?>  ?=(%& -.rec)
    ?>  =(metadata.receiver metadata.giver)
    =:  data.p.rec  receiver(balance (add balance.receiver amount.act))
        data.p.giv
      %=  giver
        balance  (sub balance.giver amount.act)
        nonce  .+(nonce.giver)
      ==
    ==
    (result [giv rec ~] ~ ~ ~)
    ::
      %set-allowance
    ::  let some pubkey spend tokens on your behalf
    ::  note that you can arbitrarily allow as much spend as you want,
    ::  but spends will still be constrained by token balance
    ::  single rice expected, account
    =/  acc=grain          (need (scry from-account.act))
    ?>  ?=(%& -.acc)
    =/  =account:sur  data:(husk account:sur acc `me.cart `id.from.cart)
    ?>  !=(who.act holder.p.acc)  :: no allowances for yourself
    =.  data.p.acc
      %=    account
          allowances
        (~(put by allowances.account) who.act amount.act)
      ==
    (result [acc ~] ~ ~ ~)
  ::
      %mint
    =/  tok=grain  (need (scry token.act))
    ?>  ?=(%& -.tok)
    =/  meta   data:(husk token-metadata:sur tok `me.cart `me.cart)
    ::  first, check if token is mintable
    ?>  &(mintable.meta ?=(^ cap.meta) !=(~ minters.meta))
    ::  check if caller is permitted to mint
    ?>  ?|  =(id.from.cart me.cart)         ::  caller is the contract itself
            ?&  =(id.from.cart minter.act)  ::  caller is who they claim to be in minter
                (~(has in minters.meta) minter.act)
            ==                              ::  and is in approved minters set
        ==
    ::  for accounts which we know rice of, find in owns.cart
    ::  and alter. for others, generate id and add to c-call
    =/  mints  ~(tap in mints.act)
    =|  changed=(list grain)
    =|  to-issue=(list grain)
    =|  minted-total=@ud
    =|  next-mints=(set mint:sur)
    |-
    ?~  mints
      ::  finished minting, return chick
      =/  new-supply  (add supply.meta minted-total)
      =.  data.p.tok
        %=  meta
          supply    new-supply
          mintable  ?:(=(u.cap.meta new-supply) %.y %.n)
        ==
      ?~  to-issue
        ::  no new accounts to issue
        (result [tok changed] ~ ~ ~)
      ::  finished but need to mint to newly-issued rices
      =/  =action:sur  [%mint minter.act token.act next-mints]
      %+  continuation
        [me.cart town-id.cart action]~
      (result changed to-issue ~ ~)
    ::
    ?~  account.i.mints
      ::  need to issue
      =/  =id     (fry-rice me.cart to.i.mints town-id.cart salt.p.tok)
      =/  =grain  [%& salt.p.tok %account [0 ~ token.act 0] id me.cart to.i.mints town-id.cart]
      %=  $
        mints        t.mints
        to-issue     [grain to-issue]
        next-mints   (~(put in next-mints) [to.i.mints `id amount.i.mints])
      ==
    ::  have rice, can modify
    =/  =grain  (need (scry u.account.i.mints))
    ?>  ?=(%& -.grain)
    =/  acc  data:(husk account:sur grain `me.cart ~)
    ?>  =(metadata.acc token.act)
    =.  data.p.grain  acc(balance (add balance.acc amount.i.mints))
    %=  $
      mints         t.mints
      changed       [grain changed]
      minted-total  (add minted-total amount.i.mints)
    ==
  ::
      %deploy
    ::  enforce 0 <= decimals <= 18
    ?>  &((gte decimals.act 0) (lte decimals.act 18))
    ::  if mintable, enforce minter set not empty
    ?>  &(mintable.act ?=(^ minters.act))
    ::  if !mintable, enforce distribution adds up to cap
    ::  otherwise, enforce distribution < cap
    =/  distribution-total  ^-  @ud
      %.  add
      %~  rep  in
      ^-  (set @ud)
      (~(run in distribution.act) |=([id bal=@ud] bal))
    ?>  ?:  mintable.act
          (gth cap.act distribution-total)
        =(cap.act distribution-total)
    ::  generate salt
    =/  salt  (sham (cat 3 id.from.cart symbol.act))
    ::  generate metadata
    =/  metadata-grain  ^-  grain
      :*  %&  salt  %metadata
          ^-  token-metadata:sur
          :*  name.act
              symbol.act
              decimals.act
              supply=distribution-total
              ?:(mintable.act `cap.act ~)
              mintable.act
              minters.act
              deployer=id.from.cart
          ==
          (fry-rice me.cart me.cart town-id.cart salt)
          me.cart
          me.cart
          town-id.cart
      ==
    ::  generate accounts
    =/  accounts
      %+  gas:big  *(merk id grain)
      %+  turn  ~(tap in distribution.act)  :: XX tap:in seems to be pathological here (causes infinite loop)
      |=  [=id bal=@ud]
      =+  (fry-rice me.cart id town-id.cart salt)
      :-  -
      [%& salt %account [bal ~ id.p.metadata-grain 0] - me.cart id town-id.cart]
    [%& ~ (put:big accounts id.p.metadata-grain metadata-grain) ~ ~]
  ==
::
++  read
  |_  =path
  ++  json
    ^-  ^json
    ::  TODO potentially add /mintable here
    ?+    path  !!
        [%mintable @ ~]
      =/  g=grain  (need (scry (slav %ux i.t.path)))
      ?>  =(lord.p.g me.cart)
      =/  meta  ;;(token-metadata:sur g)
      ::  husk breaks here and idk why :(
      ::=/  meta=token-metadata:sur
      ::  (husk token-metadata:sur - `me.cart `me.cart)
      b+(mintable:lib meta)
    ::    [%rice-data ~]
    ::  ?>  =(1 ~(wyt by owns.cart))
    ::  =/  g=grain  -:~(val by owns.cart)
    ::  ?>  ?=(%& -.g)
    ::  ?:  ?=(%account label.p.g)
    ::    (account:enjs:lib ;;(account:sur data.p.g))
    ::  (token-metadata:enjs:lib ;;(token-metadata:sur data.p.g))
    ::::
    ::    [%rice-data @ ~]
    ::  =/  g  ;;(grain (cue (slav %ud i.t.path)))
    ::  ?>  ?=(%& -.g)
    ::  ?:  ?=(%account label.p.g)
    ::    (account:enjs:lib ;;(account:sur data.p.g))
    ::  (token-metadata:enjs:lib ;;(token-metadata:sur data.p.g))
    ::::
    ::    [%egg-act @ ~]
    ::  %-  action:enjs:lib
    ::  ;;(action:sur (cue (slav %ud i.t.path)))
    ==
  ::
  ++  noun
    ~
  --
--
