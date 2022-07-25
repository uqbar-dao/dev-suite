::  [UQ| DAO]
::  zigs.hoon v0.9
::
::  Contract for 'zigs' (official name TBD) token, the gas-payment
::  token for the Uqbar network.
::  This token is unique from those defined by the token standard
::  because %give must include their gas budget, in order for
::  zig spends to be guaranteed not to underflow.
::
/+  *zig-sys-smart
/=  zigs  /lib/zig/contracts/lib/zigs
=,  zigs
|_  =cart
++  write
  |=  act=action:sur
  ^-  chick
  ?-    -.act
      %give
    ::  replace this with a scry once we have those
    =+  (~(got by grains.cart) id.from-account.act)
    =/  giver  (assert-rice account:sur - `me.cart `id.from.cart)
    ::  unlike other assertions, this is non-optional: we must confirm
    ::  that the giver's zigs balance is enough to cover the maximum
    ::  cost in the original transaction, which is provided in budget
    ::  argument via execution engine.
    ?>  (gte balance.data.giver (add amount.act budget.act))
    ?~  to-account.act
      ::  if no receiver account specified, generate new account for them
      =/  =id  (fry-rice me.cart to.act town-id.cart salt.giver)
      =/  =rice
        [salt.giver %account [0 ~ metadata.data.giver] id me.cart to.act town-id.cart]
      =/  next  [%give to.act amount.act [%grain id.giver] `[%grain id.rice]]
      (continuation [me.cart town-id.cart next]^~ (result ~ [%& rice]^~ ~ ~))
    ::  have a specified receiver account, grab it and add to balance
    =+  (~(got by grains.cart) id.u.to-account.act)
    =/  receiver  (assert-rice account:sur - `me.cart `to.act)
    =:  balance.data.giver     (sub balance.data.giver amount.act)
        balance.data.receiver  (add balance.data.receiver amount.act)
    ==
    (result [[%& giver] [%& receiver] ~] ~ ~ ~)
  ::
      %take
    ::  replace this with a scry once we have those
    =+  (~(got by grains.cart) id.from-account.act)
    =/  giver  (assert-rice account:sur - `me.cart ~)
    ::  no assertions required here for balance or allowance,
    ::  because subtract underflow will crash when we try to edit these.
    ?~  to-account.act
      ::  if no receiver account specified, generate new account for them
      =/  =id  (fry-rice me.cart to.act town-id.cart salt.giver)
      =/  =rice
        [salt.giver %account [0 ~ metadata.data.giver] id me.cart to.act town-id.cart]
      =/  next  [%take to.act amount.act [%grain id.giver] `[%grain id.rice]]
      (continuation [me.cart town-id.cart next]^~ (result ~ [%& rice]^~ ~ ~))
    ::  have a specified receiver account, grab it and add to balance
    =+  (~(got by grains.cart) id.u.to-account.act)
    =/  receiver  (assert-rice account:sur - `me.cart `to.act)
    =:  balance.data.giver     (sub balance.data.giver amount.act)
        balance.data.receiver  (add balance.data.receiver amount.act)
        allowances.data.giver  %+  ~(jab by allowances.data.giver)
                                 id.from.cart
                               |=(old=@ud (sub old amount.act))
    ==
    (result [[%& giver] [%& receiver] ~] ~ ~ ~)
  ::
      %set-allowance
    ::  cannot set an allowance to ourselves
    ?>  !=(who.act id.from.cart)
    ::  replace with scry
    =+  (~(got by grains.cart) id.account.act)
    =/  account  (assert-rice account:sur - `me.cart `id.from.cart)
    =.  allowances.data.account
      (~(put by allowances.data.account) who.act amount.act)
    (result [%& account]^~ ~ ~ ~)
  ==
::
++  read
  |_  =path
  ++  json
    ~
    ::  ^-  ^json
    ::  ?+    path  !!
    ::      [%rice-data ~]
    ::    ?>  =(1 ~(wyt by owns.cart))
    ::    =/  g=grain  -:~(val by owns.cart)
    ::    ?>  ?=(%& -.germ.g)
    ::    ?:  ?=(%account label.p.germ.g)
    ::      (account:enjs:lib ;;(account:sur data.p.germ.g))
    ::    (token-metadata:enjs:lib ;;(token-metadata:sur data.p.germ.g))
    ::  ::
    ::      [%rice-data @ ~]
    ::    =/  g  ;;(grain (cue (slav %ud i.t.path)))
    ::    ?>  ?=(%& -.germ.g)
    ::    ?:  ?=(%account label.p.germ.g)
    ::      (account:enjs:lib ;;(account:sur data.p.germ.g))
    ::    (token-metadata:enjs:lib ;;(token-metadata:sur data.p.germ.g))
    ::  ::
    ::      [%egg-action @ ~]
    ::    %-  action:enjs:lib
    ::    ;;(action:sur (cue (slav %ud i.t.path)))
    ::  ==
  ::
  ++  noun
    ~
  --
--
