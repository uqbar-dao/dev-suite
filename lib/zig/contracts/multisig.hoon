::  multisig.hoon  [UQ| DAO]
::
::  Contract to manage a simple multisig wallet. Assets given
::  to this contract's address will be spendable by the multisig.
::
::  This is a simple example -- note that this functionality
::  can be better served with an off-chain Urbit app to
::  collect the signatures and generate a new transaction
::  once a private threshold has been reached. Can save on
::  gas, gain privacy, and get better UX that way.
::
::  /+  *zig-sys-smart
/=  lib  /lib/zig/contracts/lib/multisig
=,  lib
|_  =cart
++  write
  |=  act=action:sur
  ^-  chick
  ?:  ?=(%create -.act)
    ::  since the id we generate here is unique, this
    ::  function can only be called once -- any further
    ::  attempts will fail to issue an ID that already exists.
    ::  this is the desired behavior, since the data
    ::  generated here controls the multisig.
    ::
    ::  issue a new grain for a new multisig wallet
    ::  threshold must be <= member count, > 0
    ?>  ?&  (gth threshold.act 0)
            (lte threshold.act ~(wyt pn members.act))
        ==
    ::  must have at least one member
    ?>  ?=(^ members.act)
    ::  no salt -- this contract creates a single grain.
    =/  =id  (fry-rice me.cart me.cart town-id.cart 0)
    =/  =grain
      :*  %&  0  %multisig
          [members.act threshold.act ~]
          id
          lord=me.cart
          holder=me.cart
          town-id.cart
      ==
    (result ~ grain^~ ~ ~)
  ::  all other calls require multisig ID in action
  =+  (need (scry multisig.act))
  =/  multisig  (husk multisig-state:sur - `me.cart ~)
  ?-    -.act
      %vote
    ::  register a vote on a pending proposal
    ::  caller must be in the multisig
    ?>  (~(has pn members.data.multisig) id.from.cart)
    ::  proposal must exist in pending
    =/  =proposal:sur  (~(got py pending.data.multisig) proposal-hash.act)
    ::  if caller has voted already, will replace existing
    =:  ayes.proposal  ?:(aye.act +(ayes.proposal) ayes.proposal)
        nays.proposal  ?.(aye.act +(nays.proposal) nays.proposal)
        votes.proposal  (~(put py votes.proposal) [id.from.cart aye.act])
    ==
    ?:  =(ayes.proposal threshold.data.multisig)
      ::  if this vote meets threshold, execute the proposal
      ::  NOTE: with this design, final voter ends up paying gas
      ::  for the proposal.
      =.  pending.data.multisig
        (~(del py pending.data.multisig) proposal-hash.act)
      %+  continuation  calls.proposal
      (result [%&^multisig]^~ ~ ~ ~)
    ?:  (gth nays.proposal (sub ~(wyt pn members.data.multisig) threshold.data.multisig))
      ::  if the vote cannot pass, delete the proposal
      =.  pending.data.multisig
        (~(del py pending.data.multisig) proposal-hash.act)
      (result [%&^multisig]^~ ~ ~ ~)
    ::  otherwise return modified proposal
    =.  pending.data.multisig
      (~(put py pending.data.multisig) proposal-hash.act proposal)
    (result [%&^multisig]^~ ~ ~ ~)
  ::
      %propose
    ::  add a new proposal to pending
    ::  caller must be in the multisig
    ?>  (~(has pn members.data.multisig) id.from.cart)
    =/  proposal-hash  (shag calls.act)
    ::  can't already be a registered proposal
    ?<  (~(has py pending.data.multisig) proposal-hash)
    ::  for any proposed call which will be sent to
    ::  this contract, assert that it only modifies
    ::  this multisig -- this is so other multisigs
    ::  can't change each others' properties
    ?>  %+  levy  calls.act
        |=  [to=id town=id =yolk]
        ?.  =(to me.cart)  %.y
        ?.  ?=(?(%add-member %remove-member %set-threshold) p.yolk)  %.y
        =(-.q.yolk multisig.act)
    ::  add to pending, with an automatic vote from proposer
    =/  =proposal:sur
      :^     calls.act
          (~(gas py *(pmap address ?)) ~[[id.from.cart %.y]])
        1
      0
    =.  pending.data.multisig
      (~(put py pending.data.multisig) [proposal-hash proposal])
    (result [%&^multisig]^~ ~ ~ ~)
  ::
  ::  these functions can only be called by this contract, resulting
  ::  from a successful multisig vote.
  ::
      %add-member
    ?>  =(id.from.cart me.cart)
    =.  members.data.multisig
      (~(put pn members.data.multisig) address.act)
    (result [%&^multisig]^~ ~ ~ ~)
  ::
      %remove-member
    ?>  =(id.from.cart me.cart)
    =.  members.data.multisig
      (~(del pn members.data.multisig) address.act)
    ::  if member count has been reduced below threshold, decrement it.
    ::  will also force a crash if we are removing the only member of
    ::  a 1-address multisig.
    =?    threshold.data.multisig
        (gth threshold.data.multisig ~(wyt pn members.data.multisig))
      (dec threshold.data.multisig)
    (result [%&^multisig]^~ ~ ~ ~)
  ::
      %set-threshold
    ?>  =(id.from.cart me.cart)
    ::  threshold must be <= member count, > 0
    ?>  ?&  (gth new.act 0)
            (lte new.act ~(wyt pn members.data.multisig))
        ==
    =.  threshold.data.multisig  new.act
    (result [%&^multisig]^~ ~ ~ ~)
  ==
::
++  read
  |_  =path
    ++  json
      ~
    ++  noun
      ~
    --
--
