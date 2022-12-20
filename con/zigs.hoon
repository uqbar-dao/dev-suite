::  zigs.hoon [UQ| DAO]
::
::  Contract for 'zigs' (official name TBD) token, the gas-payment
::  token for the Uqbar network.
::  This token is unique from those defined by the token standard
::  because %give must include their gas budget, in order for
::  zig spends to be guaranteed not to underflow.
::
/+  *zig-sys-smart
/=  zigs  /con/lib/zigs
=,  zigs
|_  =context
++  write
  |=  act=action:sur
  ^-  (quip call diff)
  ?-    -.act
      %give
    ?>  !=(to.act id.caller.context)
    =+  (need (scry-state from-account.act))
    =+  giver=(husk account:sur - `this.context `id.caller.context)
    ::  we must confirm that the giver's zigs balance is enough to
    ::  cover the maximum cost in the original transaction, which
    ::  is provided in budget argument via execution engine.
    ?>  (gte balance.noun.giver (add amount.act budget.act))
    =.  balance.noun.giver  (sub balance.noun.giver amount.act)
    ::  locate receiver account
    =+  to-id=(hash-data this.context to.act town.context `@`'zigs')
    ?~  receiver-account=(scry-state -)
      ::  if receiver doesn't have an account, issue one for them
      =+  [amount.act ~ metadata.noun.giver ~]
      =+  [to-id this.context to.act town.context `@`'zigs' %account -]
      `(result [%&^giver ~] [%&^- ~] ~ ~)
    ::  otherwise, add amount given to the existing account for that address
    =+  receiver=(husk account:sur u.receiver-account `this.context `to.act)
    =.  balance.noun.receiver  (add balance.noun.receiver amount.act)
    `(result [%&^giver %&^receiver ~] ~ ~ ~)
  ::
      %take
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
    =+  to-id=(hash-data this.context to.act town.context `@`'zigs')
    ::  cannot give back to the account you're taking from
    ::  (would double the amount of tokens)
    ?>  !=(to-id from-account.act)
    ?~  receiver-account=(scry-state -)
      ::  if receiver doesn't have an account, issue one for them
      =+  [amount.act ~ metadata.noun.giver ~]
      =+  [to-id this.context to.act town.context `@`'zigs' %account -]
      `(result [%&^giver ~] [%&^- ~] ~ ~)
    ::  otherwise, add amount given to the existing account for that address
    =+  receiver=(husk account:sur u.receiver-account `this.context `to.act)
    =.  balance.noun.receiver  (add balance.noun.receiver amount.act)
    `(result [%&^giver %&^receiver ~] ~ ~ ~)
  ::
      %push
    =+  (need (scry-state from-account.act))
    =+  account=(husk account:sur - `this.context `id.caller.context)
    =.  allowances.noun.account
      (~(put py allowances.noun.account) to.act amount.act)
    :_  (result [%&^account ~] ~ ~ ~)
    :_  ~
    :+  to.act  town.context
    [%on-push id.caller.context amount.act calldata.act]
  ::
      %pull
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
          pull-jold-hash:lib
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
    =.  balance.noun.receiver  (add balance.noun.receiver amount.act)
    `(result [%&^giver %&^receiver ~] ~ ~ ~)
  ::
      %set-allowance
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
  ==
::
++  read
  |_  =pith
  ++  json
    ^-  ^json
    ?+    pith  !!
        [%get-balance [%ux @ux] ~]
      =+  (need (scry-state +.i.t.pith))
      =+  (husk account:sur - ~ ~)
      `^json`[%n (scot %ud balance.noun.-)]
    ==
  ::
  ++  noun
    ~
  --
--
