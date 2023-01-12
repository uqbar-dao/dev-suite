::  UQ| fungible token standard v0.4
::  last updated: 2022/12/21
::
::  Basic fungible token standard. This standard defines an account
::  model, where each address that owns tokens holds one `data` containing
::  their balance and alllowances. (Allowances permit a certain pubkey
::  to spend tokens on your behalf.) There are other viable models for
::  token contracts, such as a single `data` holding all balances, or a
::  UTXO system. This account model provides a good balance between
::  simplicity and capacity for parallel execution.
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
        nonces=(pmap address @ud)      ::  necessary for gasless approves
    ==
  ::
  ::  patterns of arguments supported by this contract
  ::  "action" in input must fit one of these molds
  ::
  +$  action
    $%  give  take
        push  pull
        set-allowance
        mint  deploy
    ==
  ::
  +$  give
    $:  %give
        to=address
        amount=@ud
        from-account=id
    ==
  +$  take
    $:  %take
        to=address
        amount=@ud
        from-account=id
    ==
  +$  push  ::  call a contract's %on-push action with tokens
    $:  %push
        to=address
        amount=@ud
        from-account=id
        calldata=*
    ==
  +$  pull  ::  make use of a signed gasless approval
    $:  %pull
        from=address
        to=address
        amount=@ud
        from-account=id
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
        token-metadata=id
        mints=(list [to=address amount=@ud])
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
    ?>  !=(to.act id.caller.context)
    =+  (need (scry-state from-account.act))
    =+  giver=(husk account:sur - `this.context `id.caller.context)
    ::  fail if amount > balance
    =.  balance.noun.giver  (sub balance.noun.giver amount.act)
    ::  locate receiver account
    =+  to-id=(hash-data this.context to.act town.context salt.giver)
    ?~  receiver-account=(scry-state -)
      ::  if receiver doesn't have an account, issue one for them
      =+  [amount.act ~ metadata.noun.giver ~]
      =+  [to-id this.context to.act town.context salt.giver %account -]
      `(result [%&^giver ~] [%&^- ~] ~ ~)
    ::  otherwise, add amount given to the existing account for that address
    =+  receiver=(husk account:sur u.receiver-account `this.context `to.act)
    ::  assert token accounts are of the same token
    ?>  =(metadata.noun.giver metadata.noun.receiver)
    =.  balance.noun.receiver  (add balance.noun.receiver amount.act)
    `(result [%&^giver %&^receiver ~] ~ ~ ~)
  ::
  ++  take
    |=  [=context act=take:sur]
    ^-  (quip call diff)
    =+  (need (scry-state from-account.act))
    =+  giver=(husk account:sur - `this.context ~)
    ::  this will fail if amount > balance or allowance is exceeded
    =:  balance.noun.giver  (sub balance.noun.giver amount.act)
    ::
        allowances.noun.giver
      %+  ~(jab py allowances.noun.giver)
        id.caller.context
      |=(old=@ud (sub old amount.act))
    ==
    ::  locate receiver account
    =+  to-id=(hash-data this.context to.act town.context salt.giver)
    ::  cannot give back to the account you're taking from
    ::  (would double the amount of tokens)
    ?>  !=(to-id from-account.act)
    ?~  receiver-account=(scry-state -)
      ::  if receiver doesn't have an account, issue one for them
      =+  [amount.act ~ metadata.noun.giver ~]
      =+  [to-id this.context to.act town.context salt.giver %account -]
      `(result [%&^giver ~] [%&^- ~] ~ ~)
    ::  otherwise, add amount given to the existing account for that address
    =+  receiver=(husk account:sur u.receiver-account `this.context `to.act)
    ::  assert token accounts are of the same token
    ?>  =(metadata.noun.giver metadata.noun.receiver)
    =.  balance.noun.receiver  (add balance.noun.receiver amount.act)
    `(result [%&^giver %&^receiver ~] ~ ~ ~)
  ::
  ++  push
    |=  [=context act=push:sur]
    ^-  (quip call diff)
    ::  This is an implementation of the approveAndCall psuedo-standard for ERC20 tokens.
    ::  In a single transaction you can approve a max spend and call a function, saving
    ::  an extra transaction. For any contract that wants to implement this, the wheat
    ::  must have an %on-push arm implemented as [%on-push from=id amount=@ud calldata=*]
    =+  (need (scry-state from-account.act))
    =+  account=(husk account:sur - `this.context `id.caller.context)
    =.  allowances.noun.account
      (~(put py allowances.noun.account) to.act amount.act)
    :_  (result [%&^account ~] ~ ~ ~)
    :_  ~
    :+  to.act  town.context
    [%on-push id.caller.context amount.act calldata.act]
  ::
  ++  pull-jold-hash  0x8a0c.ebea.b35e.84a1.1729.7c78.f677.f39a
    :: ^-  @ux
    :: %-  sham
    :: %-  need
    :: %-  de-json:html
    :: ^-  cord
    :: '''
    :: [
    ::   {"from": "ux"},
    ::   {"to": "ux"},
    ::   {"amount": "ud"},
    ::   {"nonce": "ud"},
    ::   {"deadline": "ud"}
    :: ]
    :: '''
  ::
  ++  pull
    |=  [=context act=pull:sur]
    ^-  (quip call diff)
    ::  %pull allows for gasless approvals for transferring tokens
    ::  the giver must sign the from-account id and the typed +$approve struct
    ::  above, and the taker will pass in the signature to take the tokens
    =+  (need (scry-state from-account.act))
    =+  giver=(husk account:sur - `this.context `from.act)
    ::  will fail if amount > balance
    =.  balance.noun.giver  (sub balance.noun.giver amount.act)
    ::  verify signature is correct
    =/  =typed-message
        :+  (hash-data this.context holder.giver town.context salt.giver)
          pull-jold-hash
        [holder.giver to.act amount.act nonce.act deadline.act]
    ?>  =((recover typed-message sig.act) holder.giver)
    ::  assert nonce is valid
    ?>  .=(nonce.act (~(gut by nonces.noun.giver) to.act 0))
    ::  assert deadline is valid
    ?>  (lte eth-block.context deadline.act)
    ::  locate receiver account
    =+  to-id=(hash-data this.context to.act town.context salt.giver)
    ::  cannot give back to the account you're taking from
    ::  (would double the amount of tokens)
    ?>  !=(to-id from-account.act)
    ?~  receiver-account=(scry-state -)
      ::  if receiver doesn't have an account, issue one for them
      =+  [amount.act ~ metadata.noun.giver ~]
      =+  [to-id this.context to.act town.context salt.giver %account -]
      `(result [%&^giver ~] [%&^- ~] ~ ~)
    ::  otherwise, add amount given to the existing account for that address
    =+  receiver=(husk account:sur u.receiver-account `this.context `to.act)
    ::  assert token accounts are of the same token
    ?>  =(metadata.noun.giver metadata.noun.receiver)
    =.  balance.noun.receiver  (add balance.noun.receiver amount.act)
    `(result [%&^giver %&^receiver ~] ~ ~ ~)
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
    =+  account=(husk account:sur - `this.context `id.caller.context)
    =.  allowances.noun.account
      (~(put py allowances.noun.account) who.act amount.act)
    `(result [%&^account ~] ~ ~ ~)
  ::
  ++  mint
    |=  [=context act=mint:sur]
    ^-  (quip call diff)
    =+  (need (scry-state token-metadata.act))
    =+  meta=(husk token-metadata:sur - `this.context `this.context)
    ::  first, check if token is mintable
    ?>  mintable.noun.meta
    ::  check if caller is permitted to mint
    ?>  (~(has pn minters.noun.meta) id.caller.context)
    ::  loop through mints and either modify existing account or make new
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
    =+  id=(hash-data this.context to.m town.context salt.noun.meta)
    ?~  receiver-account=(scry-state id)
      ::  create new account for receiver
      =+  [amount.m ~ token-metadata.act 0]
      =+  [id this.context to.m town.context salt.noun.meta %account -]
      %=  $
        mints.act         t.mints.act
        supply.noun.meta  new-supply
        issued            [%&^- issued]
      ==
    ::  modify existing receiver account
    =+  receiver=(husk account:sur u.receiver-account `this.context `to.m)
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
      (hash-data this.context this.context town.context salt)
    ::  issue metadata item and mint
    ::  for initial distribution, if any
    =|  issued=(list item)
    |-
    ?~  initial-distribution.act
      ::  finished minting
      =/  metadata-data
        :*  metadata-id  this.context  this.context  town.context
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
    =/  =id  (hash-data this.context to.m town.context salt.token-metadata)
    =+  [amount.m ~ metadata-id 0]
    =+  rec=[id this.context to.m town.context salt.token-metadata %account -]
    %=  $
      supply.token-metadata     new-supply
      issued                    [%&^rec issued]
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
          ['allowances' (pmap-addr-to-ud allowances.a)]
          ['metadata' %s (scot %ux metadata.a)]
          ['nonces' (pmap-addr-to-ud nonces.a)]
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
    ++  pmap-addr-to-ud
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
