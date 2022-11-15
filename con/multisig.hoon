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
/+  *zig-sys-smart
/=  lib  /con/lib/multisig
=,  lib
|_  =context
++  write
  |=  act=action:sur
  ^-  (quip call diff)
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
    =/  =id  (hash-data this.context this.context town.context 0)
    =/  =item
      :*  %&  id
          this.context
          this.context
          town.context
          0
          %multisig  [members.act threshold.act ~ ~]
      ==
    `(result ~ item^~ ~ ~)
  ::  all other calls require multisig ID in action
  =+  (need (scry-state multisig.act))
  =/  multisig  (husk multisig-state:sur - `this.context ~)
  ?-    -.act
      %execute
    ::  assert sigs aren't duplicated
    ?>  ~(apt py sigs.act)
    ::  assert threshold has been met
    ?>  (gte ~(wyt py sigs.act) threshold.noun.multisig)
    ::  assert deadline is valid
    ?>  (lte eth-block.context deadline.act)
    ::  assert signatures are correct
    =/  =typed-message
      :+  (hash-data this.context this.context town.context 0)
        execute-jold-hash:lib
      [multisig.act calls.act (lent executed.noun.multisig) deadline.act]
    ?>  %+  levy  ~(tap py sigs.act)
        |=  [=id =sig]
        =((recover typed-message sig) id)
    ::  add to call history
    =.  executed.noun.multisig
      [`@ux`(sham typed-message) executed.noun.multisig]
    ::  create continuation calls
    :-  calls.act
    (result [%&^multisig]^~ ~ ~ ~)
    ::
      %vote
    ::  register a vote on a pending proposal
    ::  caller must be in the multisig
    ?>  (~(has pn members.noun.multisig) id.caller.context)
    ::  proposal must exist in pending
    =/  =proposal:sur  (~(got py pending.noun.multisig) proposal-hash.act)
    ::  if caller has voted already, will replace existing
    =:  ayes.proposal  ?:(aye.act +(ayes.proposal) ayes.proposal)
        nays.proposal  ?.(aye.act +(nays.proposal) nays.proposal)
        votes.proposal  (~(put py votes.proposal) [id.caller.context aye.act])
    ==
    ?:  =(ayes.proposal threshold.noun.multisig)
      ::  if this vote meets threshold, execute the proposal
      ::  NOTE: with this design, final voter ends up paying gas
      ::  for the proposal.
      =.  pending.noun.multisig
        (~(del py pending.noun.multisig) proposal-hash.act)
      :-  calls.proposal
      (result [%&^multisig]^~ ~ ~ ~)
    ?:  (gth nays.proposal (sub ~(wyt pn members.noun.multisig) threshold.noun.multisig))
      ::  if the vote cannot pass, delete the proposal
      =.  pending.noun.multisig
        (~(del py pending.noun.multisig) proposal-hash.act)
      `(result [%&^multisig]^~ ~ ~ ~)
    ::  otherwise return modified proposal
    =.  pending.noun.multisig
      (~(put py pending.noun.multisig) proposal-hash.act proposal)
    `(result [%&^multisig]^~ ~ ~ ~)
  ::
      %propose
    ::  add a new proposal to pending
    ::  caller must be in the multisig
    ?>  (~(has pn members.noun.multisig) id.caller.context)
    =/  proposal-hash  (shag calls.act)
    ::  can't already be a registered proposal
    ?<  (~(has py pending.noun.multisig) proposal-hash)
    ::  for any proposed call which will be sent to
    ::  this contract, assert that it only modifies
    ::  this multisig -- this is so other multisigs
    ::  can't change each others' properties
    ?>  %+  levy  calls.act
        |=  [to=id town=id =calldata]
        ?.  =(to this.context)  %.y
        ?.  ?=(?(%add-member %remove-member %set-threshold) p.calldata)  %.y
        =(-.q.calldata multisig.act)
    ::  add to pending, with an automatic vote from proposer
    =/  =proposal:sur
      :^     calls.act
          (~(gas py *(pmap address ?)) ~[[id.caller.context %.y]])
        1
      0
    =.  pending.noun.multisig
      (~(put py pending.noun.multisig) [proposal-hash proposal])
    `(result [%&^multisig]^~ ~ ~ ~)
  ::
  ::  these functions can only be called by this contract, resulting
  ::  from a successful multisig vote.
  ::
      %add-member
    ?>  =(id.caller.context this.context)
    =.  members.noun.multisig
      (~(put pn members.noun.multisig) address.act)
    `(result [%&^multisig]^~ ~ ~ ~)
  ::
      %remove-member
    ?>  =(id.caller.context this.context)
    =.  members.noun.multisig
      (~(del pn members.noun.multisig) address.act)
    ::  if member count has been reduced below threshold, decrement it.
    ::  will also force a crash if we are removing the only member of
    ::  a 1-address multisig.
    =?    threshold.noun.multisig
        (gth threshold.noun.multisig ~(wyt pn members.noun.multisig))
      (dec threshold.noun.multisig)
    `(result [%&^multisig]^~ ~ ~ ~)
  ::
      %set-threshold
    ?>  =(id.caller.context this.context)
    ::  threshold must be <= member count, > 0
    ?>  ?&  (gth new.act 0)
            (lte new.act ~(wyt pn members.noun.multisig))
        ==
    =.  threshold.noun.multisig  new.act
    `(result [%&^multisig]^~ ~ ~ ~)
  ==
::
++  read
  |_  =path
    ++  json
      ~
    ++  noun
      ::  XX make an ++is-valid-bundle of signatures. This lets you use gasless
      ::  multisignatures. Fairly certain it is safe...
      ~
    --
--
