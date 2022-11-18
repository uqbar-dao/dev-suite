::  [UQ| DAO]
::  zigs.hoon v1.0
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
    =+  (need (scry-state from-account.act))
    =/  giver  (husk account:sur - `this.context `id.caller.context)
    ::  we must confirm that the giver's zigs balance is enough to
    ::  cover the maximum cost in the original transaction, which
    ::  is provided in budget argument via execution engine.
    ?>  (gte balance.noun.giver (add amount.act budget.act))
    =.  balance.noun.giver  (sub balance.noun.giver amount.act)
    =/  to-account=id  (hash-data this.context to.act town.context salt.giver)
    ?~  to-account-data=(scry-state to-account)
      ::  if receiver doesn't have an account, try to produce one for them
      =+  [amount.act ~ metadata.noun.giver ~]
      =+  receiver=[to-account this.context to.act town.context salt.giver %account -]
      `(result [%&^giver ~] [%&^receiver ~] ~ ~)
    ::  otherwise, add amount given to the existing account for that address
    ::  assert that account is held by the address we're sending to
    =/  receiver  (husk account:sur u.to-account-data `this.context `to.act)
    =.  balance.noun.receiver  (add balance.noun.receiver amount.act)
    ::  return the result: two changed grains
    `(result [%&^giver %&^receiver ~] ~ ~ ~)

  ::
      %take
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
    =/  to-account=id  (hash-data this.context to.act town.context salt.giver)
    ?~  to-account-data=(scry-state to-account)
      ::  if receiver doesn't have an account, try to produce one for them
      =+  [amount.act ~ metadata.noun.giver ~]
      =+  receiver=[to-account this.context to.act town.context salt.giver %account -]
      `(result [%&^giver ~] [%&^receiver ~] ~ ~)
    ::  otherwise, add amount given to the existing account for that address
    ::  assert that account is held by the address we're sending to
    =/  receiver  (husk account:sur u.to-account-data `this.context `to.act)
    =.  balance.noun.receiver  (add balance.noun.receiver amount.act)
    ::  return the result: two changed grains
    `(result [%&^giver %&^receiver ~] ~ ~ ~)
  ::
      %set-allowance
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
