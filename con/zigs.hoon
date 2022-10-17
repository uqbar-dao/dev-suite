::  [UQ| DAO]
::  zigs.hoon v1.0
::
::  Contract for 'zigs' (official name TBD) token, the gas-payment
::  token for the Uqbar network.
::  This token is unique from those defined by the token standard
::  because %give must include their gas budget, in order for
::  zig spends to be guaranteed not to underflow.
::
::  /+  *zig-sys-smart
/=  zigs  /con/lib/zigs
=,  zigs
|_  =cart
++  write
  |=  act=action:sur
  ^-  chick
  ?-    -.act
      %give
    =+  (need (scry-granary from-account.act))
    =/  giver  (husk account:sur - `me.cart `id.from.cart)
    ::  we must confirm that the giver's zigs balance is enough to
    ::  cover the maximum cost in the original transaction, which
    ::  is provided in budget argument via execution engine.
    ?>  (gte balance.data.giver (add amount.act budget.act))
    =.  balance.data.giver  (sub balance.data.giver amount.act)
    ?~  to-account.act
      ::  if receiver doesn't have an account, try to produce one for them
      =/  =id  (fry-rice me.cart to.act town-id.cart salt.giver)
      =+  [amount.act ~ metadata.data.giver 0]
      =+  receiver=[salt.giver %account - id me.cart to.act town-id.cart]
      (result [%&^giver ~] [%&^receiver ~] ~ ~)
    ::  otherwise, add amount given to the existing account for that address
    =+  (need (scry-granary u.to-account.act))
    ::  assert that account is held by the address we're sending to
    =/  receiver  (husk account:sur - `me.cart `to.act)
    =.  balance.data.receiver  (add balance.data.receiver amount.act)
    ::  return the result: two changed grains
    (result [%&^giver %&^receiver ~] ~ ~ ~)

  ::
      %take
    =+  (need (scry-granary from-account.act))
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
    =+  (need (scry-granary u.to-account.act))
    ::  assert that account is held by the address we're sending to
    =/  receiver  (husk account:sur - `me.cart `to.act)
    =.  balance.data.receiver  (add balance.data.receiver amount.act)
    ::  return the result: two changed grains
    (result [%&^giver %&^receiver ~] ~ ~ ~)
  ::
      %set-allowance
    ::  let some pubkey spend tokens on your behalf
    ::  note that you can arbitrarily allow as much spend as you want,
    ::  but spends will still be constrained by token balance
    ::  note: cannot set an allowance to ourselves
    ?>  !=(who.act id.from.cart)
    =+  (need (scry-granary account.act))
    =/  account  (husk account:sur - `me.cart `id.from.cart)
    =.  allowances.data.account
      (~(put py allowances.data.account) who.act amount.act)
    (result [%& account]^~ ~ ~ ~)
  ==
::
++  read
  |_  =path
  ++  json
    ^-  ^json
    ?+    path  !!
        [%get-balance @ ~]
      =+  (need (scry-granary (slav %ux i.t.path)))
      =+  (husk account:sur - ~ ~)
      `^json`[%n (scot %ud balance.data.-)]
    ==
  ::
  ++  noun
    ~
  --
--
