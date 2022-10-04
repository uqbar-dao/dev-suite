::  UQ| fungible token standard v0.2
::  last updated: 2022/08/20
::
::  Basic fungible token standard. This standard defines an account
::  model, where each address that owns tokens holds one rice containing
::  their balance and alllowances. (Allowances permit a certain pubkey
::  to spend tokens on your behalf.) There are other viable models for
::  token contracts, such as a single rice holding all balances, or a
::  UTXO system. This account model provides a good balance between
::  simplicity and capacity for parallel execution.
::
::  Note that in any token send, the transaction must either specify
::  the account grain of the receiver, or assert that the receiver
::  does not yet have an account for this token. The transaction will
::  fail if the contract attempts to generate an account grain for
::  an address that already has one. This maintains the 1:1 relation
::  between addresses and accounts.
::
::  Note that a token is classified not by its issuing contract address
::  (the "lord"), but rather its metadata grain address. The issuing
::  contract is potentially generic, as any contract can import this
::  full library and allow %deploy transactions. The token send logic
::  used here therefore asserts that sends are performed to accounts
::  which have matching metadata addresses, which are unique per-token.

::  When issuing a new token, one can either designate an address or
::  addresses that are permitted to mint, or set a permanent supply,
::  all of which must be distributed at first issuance.
::
/+  *zig-sys-smart
|%
++  sur
  |%
  ::
  ::  types that populate grains this standard generates
  ::
  +$  token-metadata
    $:  name=@t                 ::  the name of a token (not unique!)
        symbol=@t               ::  abbreviation (also not unique)
        decimals=@ud            ::  granularity (maximum defined by implementation)
        supply=@ud              ::  total amount of token in existence
        cap=(unit @ud)          ::  supply cap (~ if no cap)
        mintable=?              ::  whether or not more can be minted
        minters=(pset address)  ::  pubkeys permitted to mint, if any
        deployer=address        ::  pubkey which first deployed token
        salt=@                  ::  deployer-defined salt for account grains
    ==
  ::
  +$  account
    $:  balance=@ud                    ::  the amount of tokens someone has
        allowances=(pmap address @ud)  ::  a map of pubkeys they've permitted to spend their tokens and how much
        metadata=id                    ::  address of the rice holding this token's metadata
        nonces=(map address @ud)       ::  necessary for gasless approves
    ==
  ::
  +$  approval
    $:  from=id       ::  pubkey giving
        to=address    ::  pubkey permitted to take
        amount=@ud    ::  how many tokens the taker can take
        nonce=@ud     ::  current nonce of the giver
        deadline=@da  ::  how long this approve is valid
    ==
  ::
  ::  patterns of arguments supported by this contract
  ::  "action" in input must fit one of these molds
  ::
  +$  action
    $%  give
        take
        push
        pull
        set-allowance
        mint
        deploy
    ==
  ::
  +$  give
    $:  %give
        to=address
        amount=@ud
        from-account=id
        to-account=(unit id)
    ==
  +$  take
    $:  %take
        to=address
        amount=@ud
        from-account=id
        to-account=(unit id)
    ==
  +$  push
    $:  %push
        to=address
        from-account=id
        to-account=id :: not a unit because the contract *must* set up an account rice to use push
        amount=@ud
    ==
  +$  pull
    $:  %pull
        to=address
        from-account=id
        to-account=(unit id)
        amount=@ud
        nonce=@ud
        deadline=@ud :: can we do a @ud with now.cart? doesn't exist anymore
        =sig
    ==
  +$  set-allowance
    $:  %set-allowance
        who=address
        amount=@ud  ::  (to revoke, call with amount=0)
        account=id
    ==
  +$  mint
    $:  %mint  ::  can only be called by minters, can't mint above cap
        token=id
        mints=(list [to=address account=(unit id) amount=@ud])
    ==
  +$  deploy
    $:  %deploy
        name=@t
        symbol=@t
        salt=@
        cap=(unit @ud)          ::  if ~, no cap (fr fr)
        minters=(pset address)  ::  if ~, mintable becomes %.n, otherwise %.y
        initial-distribution=(list [to=address amount=@ud])
    ==
  --
::
++  lib
  |%
  ++  give
    |=  [=cart act=give:sur]
    ^-  chick
    =+  (need (scry from-account.act))
    =/  giver  (husk account:sur - `me.cart `id.from.cart)
    ::  this will fail if amount > balance, as desired
    =.  balance.data.giver  (sub balance.data.giver amount.act)
    ?~  to-account.act
      ::  if receiver doesn't have an account, try to produce one for them
      =/  =id  (fry-rice me.cart to.act town-id.cart salt.giver)
      =+  [amount.act ~ metadata.data.giver 0]
      =+  receiver=[salt.giver %account - id me.cart to.act town-id.cart]
      (result [%&^giver ~] [%&^receiver ~] ~ ~)
    ::  otherwise, add amount given to the existing account for that address
    =+  (need (scry u.to-account.act))
    ::  assert that account is held by the address we're sending to
    =/  receiver  (husk account:sur - `me.cart `to.act)
    ::  assert that token accounts are of the same token
    ::  (since this contract can deploy and thus manage multiple tokens)
    ?>  =(metadata.data.receiver metadata.data.giver)
    =.  balance.data.receiver  (add balance.data.receiver amount.act)
    ::  return the result: two changed grains
    (result [%&^giver %&^receiver ~] ~ ~ ~)
  ::
  ++  take
    |=  [=cart act=take:sur]
    ^-  chick
    =+  (need (scry from-account.act))
    =/  giver  (husk account:sur - `me.cart ~)
    ::  this will fail if amount > balance or allowance is exceeded, as desired
    =:  balance.data.giver  (sub balance.data.giver amount.act)
    ::
          allowances.data.giver
        %+  ~(jab py allowances.data.giver)
          id.from.cart
        |=(old=@ud (sub old amount.act))
    ==
    ?~  to-account.act
      ::  if receiver doesn't have an account, try to produce one for them
      =/  =id  (fry-rice me.cart to.act town-id.cart salt.giver)
      =+  [amount.act ~ metadata.data.giver 0]
      =+  receiver=[salt.giver %account - id me.cart to.act town-id.cart]
      (result [%&^giver ~] [%&^receiver ~] ~ ~)
    ::  otherwise, add amount given to the existing account for that address
    =+  (need (scry u.to-account.act))
    ::  assert that account is held by the address we're sending to
    =/  receiver  (husk account:sur - `me.cart `to.act)
    ::  assert that token accounts are of the same token
    ::  (since this contract can deploy and thus manage multiple tokens)
    ?>  =(metadata.data.receiver metadata.data.giver)
    =.  balance.data.receiver  (add balance.data.receiver amount.act)
    ::  return the result: two changed grains
    (result [%&^giver %&^receiver ~] ~ ~ ~)
  ::
  ++  push
    :: This is an ERC677 implementation. It let's you send tokens to a contract
    :: and execute arbitrary logic after that - saving you an extra approve
    :: transaction. For any contract that wants to implement this, the wheat
    :: must have an %on-push arm implemented as [%on-push from=id amount=id]
    :: Any contract that users must pay to use should implement this - e.g.
    :: an oracle query.
    |=  [=cart act=push:sur]
    ^-  chick
    =+  (need (scry from-account.act))
    =/  giver  (husk account:sur - `me.cart `id.from.cart)
    ::  this will fail if amount > balance, as desired
    =.  balance.data.giver  (sub balance.data.giver amount.act)
    ::  add amount given to the existing account for that address
    =+  (need (scry to-account.act))
    ::  assert that account is held by the address we're sending to
    =/  receiver  (husk account:sur - `me.cart `to.act)
    ::  assert that token accounts are of the same token
    ::  (since this contract can deploy and thus manage multiple tokens)
    ?>  =(metadata.data.receiver metadata.data.giver)
    =.  balance.data.receiver  (add balance.data.receiver amount.act)
    ::  return the result: two changed grains
    %+  continuation
      [to.act town-id.cart [%on-push id.from.cart amount.act]]~
    (result [%&^giver %&^receiver ~] ~ ~ ~)
  ::
  ++  pull
    |=  [=cart act=pull:sur]
    ^-  chick
    ::  %pull allows for gasless approvals for transferring tokens
    ::  the giver must sign the from-account id and the typed +$approve struct above
    ::  and the taker will pass in the signature to take the tokens
    =/  giv=grain          (need (scry from-account.act))
    ?>  ?=(%& -.giv)
    =/  giver=account:sur  data:(husk account:sur giv `me.cart ~)
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
    :: assert nonce is valid
    =+  (~(get by nonces.giver) to.act)
    ?>  .=  nonce.act
      ?~  -
        =>((~(put py nonces.giver) to.act 1) 0)
      =>((~(jab py nonces.giver) to.act succ) ->)
    :: TODO need to figure out how to implement the deadline since now.cart no longer exists
    ?>  (lte batch.cart deadline.act)
    ?>  (gte balance.giver amount.act)
    ?~  to-account.act
    ::  create new rice for reciever and add it to state
      =+  (fry-rice to.act me.cart town-id.cart salt.p.giv)
      =/  new=grain
        [%& salt.p.giv %account [amount.act ~ metadata.giver ~] - me.cart to.act town-id.cart]
      ::  continuation call: %take to rice found in book
      =/  =action:sur  [%pull to.act id.p.giv `id.p.new amount.act nonce.act deadline.act sig.act]
      %+  continuation
        [me.cart town-id.cart action]~
      (result [new ~] ~ ~ ~)
    ::  direct send
    =/  rec=grain  (need (scry u.to-account.act))
    =/  receiver   data:(husk account:sur rec `me.cart `to.act)
    ?>  ?=(%& -.rec)
    ?>  =(metadata.receiver metadata.giver)
    =:  data.p.rec  receiver(balance (add balance.receiver amount.act))
        data.p.giv
      %=  giver
        balance   (sub balance.giver amount.act)
        nonces    (~(jab py nonces.giver) to.act succ) 
      ==
    ==
    (result [giv rec ~] ~ ~ ~)
  ::
  ++  set-allowance
    |=  [=cart act=set-allowance:sur]
    ^-  chick
    ::  let some pubkey spend tokens on your behalf
    ::  note that you can arbitrarily allow as much spend as you want,
    ::  but spends will still be constrained by token balance
    ::  note: cannot set an allowance to ourselves
    ?>  !=(who.act id.from.cart)
    =+  (need (scry account.act))
    =/  account  (husk account:sur - `me.cart `id.from.cart)
    =.  allowances.data.account
      (~(put py allowances.data.account) who.act amount.act)
    (result [%& account]^~ ~ ~ ~)
  ::
  ++  mint
    |=  [=cart act=mint:sur]
    ^-  chick
    =+  (need (scry token.act))
    =/  meta  (husk token-metadata:sur - `me.cart `me.cart)
    ::  first, check if token is mintable
    ?>  mintable.data.meta
    ::  check if caller is permitted to mint
    ?>  (~(has pn minters.data.meta) id.from.cart)
    ::  loop through mints and either modify existing account or make new
    ::  note: entire mint will fail if any accounts are not found, or
    ::  if new accounts overlap with existing ones
    =|  issued=(list grain)
    =|  changed=(list grain)
    |-
    ?~  mints.act
      ::  finished minting
      (result [[%&^meta changed] issued ~ ~])
    =*  m  i.mints.act
    =/  new-supply  (add supply.data.meta amount.m)
    ?>  ?~  cap.data.meta  %.y
        (gte u.cap.data.meta new-supply)
    ?~  account.m
      ::  create new account for receiver
      =/  =id  (fry-rice me.cart to.m town-id.cart salt.data.meta)
      =+  [amount.m ~ token.act 0]
      =+  receiver=[salt.data.meta %account - id me.cart to.m town-id.cart]
      %=  $
        mints.act         t.mints.act
        supply.data.meta  new-supply
        issued            [%&^receiver issued]
      ==
    ::  find and modify existing receiver account
    =+  (need (scry u.account.m))
    =/  receiver  (husk account:sur - `me.cart `to.m)
    =.  balance.data.receiver  (add balance.data.receiver amount.m)
    %=  $
      mints.act         t.mints.act
      supply.data.meta  new-supply
      changed           [%&^receiver changed]
    ==
  ::
  ++  deploy
    |=  [=cart act=deploy:sur]
    ::  create new metadata grain
    =/  =token-metadata:sur
      :*  name.act
          symbol.act
          18
          supply=0
          cap.act
          ?~(minters.act %.n %.y)
          minters.act
          deployer=id.from.cart
          salt.act
      ==
    =/  metadata-id
      (fry-rice me.cart me.cart town-id.cart salt.act)
    =/  =rice
      :*  salt.act
          %token-metadata
          token-metadata
          metadata-id
          me.cart  me.cart  town-id.cart
      ==
    ::  issue metadata grain and c-call a mint
    ::  for initial distribution, if any
    =/  res  (result ~ [%&^rice ~] ~ ~)
    ?~  initial-distribution.act
      res
    =/  mints
      %+  turn  initial-distribution.act
      |=([to=address amount=@ud] [to ~ amount])
    %+  continuation
      ~[[me.cart town-id.cart [%mint metadata-id mints]]]
    res
  ::
  ::  JSON parsing for types
  ::
  ++  enjs
    =,  enjs:format
    |%
    ++  account
      |=  a=account:sur
      ^-  json
      %-  pairs
      :~  ['balance' (numb balance.a)]
          ['allowances' (addr-to-ud-map allowances.a)]
          ['metadata' %s (scot %ux metadata.a)]
          ['nonce' (addr-to-ud-map nonces.a)]
      ==
    ::
    ++  metadata
      |=  md=token-metadata:sur
      ^-  json
      %-  pairs
      :~  ['name' %s name.md]
          ['symbol' %s symbol.md]
          ['decimals' (numb decimals.md)]
          ['supply' (numb supply.md)]
          ['cap' ?~(cap.md ~ (numb u.cap.md))]
          ['mintable' %b mintable.md]
          ['minters' (address-set minters.md)]
          ['deployer' %s (scot %ux deployer.md)]
          ['salt' (numb salt.md)]
      ==
    ::
    ++  addr-to-ud-map
      |=  al=(pmap address @ud)
      ^-  json
      %-  pairs
      %+  turn  ~(tap py al)
      |=  [a=address b=@ud]
      [(scot %ux a) (numb b)]
    ::
    ++  address-set
      |=  as=(pset address)
      ^-  json
      :-  %a
      %+  turn  ~(tap pn as)
      |=(a=address [%s (scot %ux a)])
    --
  --
--
