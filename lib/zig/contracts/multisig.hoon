::  multisig.hoon  [UQ| DAO]
::
::  Generic contract to manage a simple multisig wallet.
::  New multisigs can be generated through the %create
::  argument, and are stored in account-controlled rice.
::
/+  *zig-sys-smart
/=  lib  /lib/zig/contracts/lib/multisig
=,  lib
|_  =cart
++  write
  |=  act=action:sur
  ^-  chick
  ?:  ?=(%create -.act)
    ::  issue a new grain for a new multisig wallet
    ::  threshold must be <= member count
    ?>  (lte threshold.act ~(wyt pn members.act))
    ::  generate unique salt to differentiate grain IDs
    =/  salt  (shag (cat 3 id.from.cart batch.cart))
    =/  =id  (fry-rice me.cart me.cart town-id.cart salt)
    =/  =grain
      :*  %&  salt  %multisig
          [members.act threshold.act ~]
          id
          lord=me.cart
          holder=me.cart
          town-id.cart
      ==
    (result ~ grain^~ ~ ~)
  ::  all other calls require multisig ID in action
  ?>  =(id.from.cart me.cart)
  =+  (need (scry multisig.act))
  =/  multisig  (husk multisig-state:sur - `me.cart ~)
  ?-    -.act
      %vote
    ::  register a vote on a pending proposal
    ::  caller must be in the multisig
    ?>  (~(has pn members.data.multisig) id.from.cart)
    ::  proposal must exist in pending
    =/  proposal  (~(got py pending.data.multisig) proposal-hash.act)
    ::  if caller has voted already, will replace existing
    =:  ayes.proposal  ?:(aye.act +(ayes.proposal) ayes.proposal)
        nays.proposal  ?.(aye.act +(nays.proposal) nays.proposal)
        votes.proposal  (~(put py votes.proposal) [id.from.cart aye.act])
    ==
    ?:  =(ayes.proposal threshold.data.multisig)
      ::  if this vote meets threshold, execute the proposal
      =.  pending.data.multisig
        (~(del py pending.data.multisig) proposal-hash.act)
      %+  continuation  calls.proposal
      (result [%&^multisig]^~ ~ ~ ~)
    ::  otherwise return modified proposal
    =.  pending.data.multisig
      (~(put py pending.data.multisig) [proposal-hash.act proposal])
    (result [%&^multisig]^~ ~ ~ ~)
  ::
      %propose
    ::  add a new proposal to pending
    ::  caller must be in the multisig
    ?>  (~(has pn members.data.multisig) id.from.cart)
    =/  proposal-hash  (shag calls.act)
    ::  can't already be a registered proposal
    ?<  (~(has py pending.data.multisig) proposal-hash)
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
      %add-member
    =.  members.data.multisig
      (~(put pn members.data.multisig) address.act)
    (result [%&^multisig]^~ ~ ~ ~)
  ::
      %remove-member
    =.  members.data.multisig
      (~(del pn members.data.multisig) address.act)
    (result [%&^multisig]^~ ~ ~ ~)
  ::
      %set-threshold
    ::  threshold must be <= member count
    ?>  (lte new.act ~(wyt pn members.data.multisig))
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
