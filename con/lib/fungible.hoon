::  UQ| fungible token standard v0.3
::  last updated: 2022/10/22
::
::  Basic fungible token standard. This standard defines an account
::  model, where each address that owns tokens holds one `data` containing
::  their balance and alllowances. (Allowances permit a certain pubkey
::  to spend tokens on your behalf.) There are other viable models for
::  token contracts, such as a single `data` holding all balances, or a
::  UTXO system. This account model provides a good balance between
::  simplicity and capacity for parallel execution.
::
::  Note that in any token send, the transaction must either specify
::  the account item of the receiver, or assert that the receiver
::  does not yet have an account for this token. The transaction will
::  fail if the contract attempts to generate an account item for
::  an address that already has one. This maintains the 1:1 relation
::  between addresses and accounts.
::
::  Note that a token is classified not by its issuing contract address
::  (the "source"), but rather its metadata item address. The issuing
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
  ::  types that populate items this standard generates
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
        salt=@                  ::  deployer-defined salt for account items
    ==
  ::
  +$  account
    $:  balance=@ud                    ::  the amount of tokens someone has
        allowances=(pmap address @ud)  ::  a map of pubkeys they've permitted to spend their tokens and how much
        metadata=id                    ::  address of the `data` holding this token's metadata
        nonce=@ud                      ::  necessary for gasless approves
    ==
  ::
  +$  approval
    $:  from=id       ::  pubkey giving
        to=address    ::  pubkey permitted to take
        amount=@ud    ::  how many tokens the taker can take
        nonce=@ud     ::  current nonce of the giver
        deadline=@ud  ::  how long this approve is valid
    ==
  ::
  ::  patterns of arguments supported by this contract
  ::  "action" in input must fit one of these molds
  ::
  +$  action
    $%  give
        take
        take-with-sig
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
  +$  take-with-sig
    $:  %take-with-sig
        to=address
        from-account=id
        to-account=(unit id)
        amount=@ud
        nonce=@ud
        deadline=@ud
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
    |=  [=context act=give:sur]
    ^-  (quip call diff)
    =+  (need (scry-state from-account.act))
    =/  giver  (husk account:sur - `this.context `id.caller.context)
    ::  this will fail if amount > balance, as desired
    =.  balance.noun.giver  (sub balance.noun.giver amount.act)
    ?~  to-account.act
      ::  if receiver doesn't have an account, try to produce one for them
      =/  =id  (hash-data this.context to.act shard.context salt.giver)
      =+  [amount.act ~ metadata.noun.giver 0]
      =+  receiver=[id this.context to.act shard.context salt.giver %account -]
      `(result [%&^giver ~] [%&^receiver ~] ~ ~)
    ::  otherwise, add amount given to the existing account for that address
    =+  (need (scry-state u.to-account.act))
    ::  assert that account is held by the address we're sending to
    =/  receiver  (husk account:sur - `this.context `to.act)
    ::  assert that token accounts are of the same token
    ::  (since this contract can deploy and thus manage multiple tokens)
    ?>  =(metadata.noun.receiver metadata.noun.giver)
    =.  balance.noun.receiver  (add balance.noun.receiver amount.act)
    ::  return the result: two changed items
    `(result [%&^giver %&^receiver ~] ~ ~ ~)
  ::
  ++  take
    |=  [=context act=take:sur]
    ^-  (quip call diff)
    =+  (need (scry-state from-account.act))
    =/  giver  (husk account:sur - `this.context ~)
    ::  this will fail if amount > balance or allowance is exceeded, as desired
    =:  balance.noun.giver  (sub balance.noun.giver amount.act)
    ::
          allowances.noun.giver
        %+  ~(jab py allowances.noun.giver)
          id.caller.context
        |=(old=@ud (sub old amount.act))
    ==
    ?~  to-account.act
      ::  if receiver doesn't have an account, try to produce one for them
      =/  =id  (hash-data this.context to.act shard.context salt.giver)
      =+  [amount.act ~ metadata.noun.giver 0]
      =+  receiver=[id this.context to.act shard.context salt.giver %account -]
      `(result [%&^giver ~] [%&^receiver ~] ~ ~)
    ::  otherwise, add amount given to the existing account for that address
    =+  (need (scry-state u.to-account.act))
    ::  assert that account is held by the address we're sending to
    =/  receiver  (husk account:sur - `this.context `to.act)
    ::  assert that token accounts are of the same token
    ::  (since this contract can deploy and thus manage multiple tokens)
    ?>  =(metadata.noun.receiver metadata.noun.giver)
    =.  balance.noun.receiver  (add balance.noun.receiver amount.act)
    ::  return the result: two changed items
    `(result [%&^giver %&^receiver ~] ~ ~ ~)
  ::
  ++  take-with-sig
    |=  [=context act=take-with-sig:sur]
    ^-  (quip call diff)
    ::  %take-with-sig allows for gasless approvals for transferring tokens
    ::  the giver must sign the from-account id and the typed +$approve struct above
    ::  and the taker will pass in the signature to take the tokens
    =/  giv=item  (need (scry-state from-account.act))
    ?>  ?=(%& -.giv)
    =/  giver=account:sur  noun:(husk account:sur giv `this.context ~)
    ::  reconstruct the typed message and hash
    =/  =typed-message
      :-  (hash-data this.context holder.p.giv shard.context salt.p.giv)
      (sham [holder.p.giv to.act amount.act nonce.act deadline.act])
    =/  signed-hash  (sham typed-message)
    ::  recover the address from the message and signature
    =/  recovered-address
      %-  address-from-pub
      %-  serialize-point:secp256k1:secp:crypto
      (ecdsa-raw-recover:secp256k1:secp:crypto signed-hash sig.act)
    ::  assert the signature is valid
    ?>  =(recovered-address holder.p.giv)
    :: TODO need to figure out how to implement the deadline since now.context no longer exists
    ?>  (lte batch.context deadline.act)
    ?>  (gte balance.giver amount.act)
    ?~  to-account.act
    ::  create new `data` for reciever and add it to state
      =+  (hash-data to.act this.context shard.context salt.p.giv)
      =/  new=item
        [%& - this.context to.act shard.context salt.p.giv %account [amount.act ~ metadata.giver 0]]
      ::  continuation call: %take to `data` found in book
      =/  =action:sur  [%take-with-sig to.act id.p.giv `id.p.new amount.act nonce.act deadline.act sig.act]
      :-  [this.context shard.context action]~
      (result [new ~] ~ ~ ~)
    ::  direct send
    =/  rec=item  (need (scry-state u.to-account.act))
    =/  receiver  noun:(husk account:sur rec `this.context `to.act)
    ?>  ?=(%& -.rec)
    ?>  =(metadata.receiver metadata.giver)
    =:  noun.p.rec  receiver(balance (add balance.receiver amount.act))
        noun.p.giv
      %=  giver
        balance  (sub balance.giver amount.act)
        nonce  .+(nonce.giver)
      ==
    ==
    `(result [giv rec ~] ~ ~ ~)
  ::
  ++  set-allowance
    |=  [=context act=set-allowance:sur]
    ^-  (quip call diff)
    ::  let some pubkey spend tokens on your behalf
    ::  note that you can arbitrarily allow as much spend as you want,
    ::  but spends will still be constrained by token balance
    ::  note: cannot set an allowance to ourselves
    ?>  !=(who.act id.caller.context)
    =+  (need (scry-state account.act))
    =/  account  (husk account:sur - `this.context `id.caller.context)
    =.  allowances.noun.account
      (~(put py allowances.noun.account) who.act amount.act)
    `(result [%& account]^~ ~ ~ ~)
  ::
  ++  mint
    |=  [=context act=mint:sur]
    ^-  (quip call diff)
    =+  (need (scry-state token.act))
    =/  meta  (husk token-metadata:sur - `this.context `this.context)
    ::  first, check if token is mintable
    ?>  mintable.noun.meta
    ::  check if caller is permitted to mint
    ?>  (~(has pn minters.noun.meta) id.caller.context)
    ::  loop through mints and either modify existing account or make new
    ::  note: entire mint will fail if any accounts are not found, or
    ::  if new accounts overlap with existing ones
    =|  issued=(list item)
    =|  changed=(list item)
    |-
    ?~  mints.act
      ::  finished minting
      `(result [[%&^meta changed] issued ~ ~])
    =*  m  i.mints.act
    =/  new-supply  (add supply.noun.meta amount.m)
    ?>  ?~  cap.noun.meta  %.y
        (gte u.cap.noun.meta new-supply)
    ?~  account.m
      ::  create new account for receiver
      =/  =id  (hash-data this.context to.m shard.context salt.noun.meta)
      =+  [amount.m ~ token.act 0]
      =+  receiver=[id this.context to.m shard.context salt.noun.meta %account -]
      %=  $
        mints.act         t.mints.act
        supply.noun.meta  new-supply
        issued            [%&^receiver issued]
      ==
    ::  find and modify existing receiver account
    =+  (need (scry-state u.account.m))
    =/  receiver  (husk account:sur - `this.context `to.m)
    =.  balance.noun.receiver  (add balance.noun.receiver amount.m)
    %=  $
      mints.act         t.mints.act
      supply.noun.meta  new-supply
      changed           [%&^receiver changed]
    ==
  ::
  ++  deploy
    |=  [=context act=deploy:sur]
    ::  make salt unique by including deployer + their input
    =/  salt  (cat 3 salt.act id.caller.context)
    ::  create new metadata item
    =/  =token-metadata:sur
      :*  name.act
          symbol.act
          18
          supply=0
          cap.act
          ?~(minters.act %.n %.y)
          minters.act
          deployer=id.caller.context
          salt
      ==
    =/  metadata-id
      (hash-data this.context this.context shard.context salt)
    ::  issue metadata item and mint
    ::  for initial distribution, if any
    =|  issued=(list item)
    |-
    ?~  initial-distribution.act
      ::  finished minting
      =/  metadata-data
        :*  metadata-id  this.context  this.context  shard.context
            salt
            %token-metadata
            token-metadata
        ==
      `(result ~ [%&^metadata-data issued] ~ ~)
    =*  m  i.initial-distribution.act
    =/  new-supply  (add supply.token-metadata amount.m)
    ?>  ?~  cap.token-metadata  %.y
        (gte u.cap.token-metadata new-supply)
    ::  create new account for receiver
    =/  =id  (hash-data this.context to.m shard.context salt.token-metadata)
    =+  [amount.m ~ metadata-id 0]
    =+  receiver=[id this.context to.m shard.context salt.token-metadata %account -]
    %=  $
      supply.token-metadata     new-supply
      issued                    [%&^receiver issued]
      initial-distribution.act  t.initial-distribution.act
    ==
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
          ['allowances' (allowances allowances.a)]
          ['metadata' %s (scot %ux metadata.a)]
          ['nonce' (numb nonce.a)]
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
    ++  allowances
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
