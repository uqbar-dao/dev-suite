::
::  token escrow contract for managing pokur games
::  (but general enough to be used for anything?)
::
/+  *zig-sys-smart
/=  lib  /con/lib/escrow
|_  =context
++  write
  |=  act=action:lib
  ^-  (quip call diff)
  ?-    -.act
      %new-bond
    ::  get token metadata
    =/  meta  (need (scry-state asset-metadata.act))
    ?>  ?=(%& -.meta)
    =/  our-account=id
      (hash-data source.p.meta this.context town.context salt.p.meta)
    =/  bond-salt
      (cat 3 id.caller.context nonce.caller.context)
    =-  `(result ~ [%&^- ~] ~ [[%new-bond s+(scot %ux id.-)]]^~)
    :*  id=(hash-data this.context this.context town.context bond-salt)
        this.context
        this.context
        town.context
        bond-salt
        %bond
        ^-  bond:lib
        :^    custodian.act
            timelock.act
          [source.p.meta asset-metadata.act 0 our-account]
        ~
    ==
  ::
      %new-bond-with-deposit
    ::  get token metadata
    =/  meta  (need (scry-state asset-metadata.act))
    ?>  ?=(%& -.meta)
    =/  our-account=id
      (hash-data source.p.meta this.context town.context salt.p.meta)
    =/  bond-salt
      (cat 3 id.caller.context nonce.caller.context)
    :-  :_  ~
        :+  source.p.meta
          town.context
        :^    %take
            this.context
          amount.act
        account.act
    =-  (result ~ [- ~] ~ `(list event)`[%new-bond s+(scot %ux -.+.-)]^~)
    :*  %&
        (hash-data this.context this.context town.context bond-salt)
        this.context
        this.context
        town.context
        bond-salt
        %bond
        ^-  bond:lib
        :^    custodian.act
            timelock.act
          [source.p.meta asset-metadata.act amount.act our-account]
        (make-pmap ~[[ship.act id.caller.context amount.act]])
    ==
  ::
      %deposit
    =/  bond
      =+  (need (scry-state bond-id.act))
      (husk bond:lib - `this.context `this.context)
    ::  adjust asset, add caller as depositor
    =.  amount.escrow-asset.noun.bond
      (add amount.escrow-asset.noun.bond amount.act)
    =.  depositors.noun.bond
      ?:  (~(has py depositors.noun.bond) ship.act)
        ::  if already a depositor, add amount to previous
        %+  ~(jab py depositors.noun.bond)
          ship.act
        |=  [=address amount=@ud]
        ?>  =(address id.caller.context)
        [address (add amount amount.act)]
      ::  otherwise add new depositor
      %+  ~(put py depositors.noun.bond)
        ship.act
      [id.caller.context amount.act]
    ::  return result bond + make %take call to token
    :_  (result [%&^bond ~] ~ ~ ~)
    :~  :+  contract.escrow-asset.noun.bond
          town.context
        :^    %take
            this.context
          amount.act
        account.act
    ==
  ::
      %award
    =/  bond
      =+  (need (scry-state bond-id.act))
      (husk bond:lib - `this.context `this.context)
    ::  caller must be the custodian
    ?>  =(custodian.noun.bond id.caller.context)
    ::  give asset
    =/  receiver=[=address amount=@ud]
      (~(got py depositors.noun.bond) to.act)
    :-  :_  ~
        :+  contract.escrow-asset.noun.bond
          town.context
        :^    %give
            address.receiver
          amount.act
        account.escrow-asset.noun.bond
    ::  if award adds up to total amount in escrow, destroy bond here
    ?:  =(amount.escrow-asset.noun.bond amount.act)
      ::  zero out and destroy the bond item
      =:  amount.escrow-asset.noun.bond  0
          depositors.noun.bond           ~
      ==
      (result ~ ~ [%&^bond ~] ~)
    ::  if award is partial, bond is modified and not destroyed
    =:  amount.escrow-asset.noun.bond
      (sub amount.escrow-asset.noun.bond amount.act)
    ::  subtract depositor's claim
        depositors.noun.bond
      %+  ~(jab py depositors.noun.bond)  to.act
      |=  [=address amount=@ud]
      [address (sub amount amount.act)]
    ==
    (result [%&^bond ~] ~ ~ ~)
  ::
      %refund
    =/  bond
      =+  (need (scry-state bond-id.act))
      (husk bond:lib - `this.context `this.context)
    ::  caller must be custodian
    ?>  =(custodian.noun.bond id.caller.context)
    ::  all tokens returned to depositors
    ::  zero out and destroy the bond item
    =:  amount.escrow-asset.noun.bond  0
        depositors.noun.bond           ~
    ==
    :_  (result ~ ~ [%&^bond ~] ~)
    %+  turn  ~(tap py depositors.noun.bond)
    |=  [=ship =address amount=@ud]
    ^-  call
    :+  contract.escrow-asset.noun.bond
      town.context
    :^    %give
        address
      amount
    account.escrow-asset.noun.bond
  ::
      %release
    =/  bond
      =+  (need (scry-state bond-id.act))
      (husk bond:lib - `this.context `this.context)
    ::  timelock must have passed
    ?>  (gth eth-block.context timelock.noun.bond)
    ::  tokens must remain in contract
    ?>  (gth amount.escrow-asset.noun.bond 0)
    ::  all tokens returned to depositors
    ::  zero out and destroy the bond item
    =:  amount.escrow-asset.noun.bond  0
        depositors.noun.bond           ~
    ==
    :_  (result ~ ~ [%&^bond ~] ~)
    %+  turn  ~(tap py depositors.noun.bond)
    |=  [=ship =address amount=@ud]
    ^-  call
    :+  contract.escrow-asset.noun.bond
      town.context
    :^    %give
        address
      amount
    account.escrow-asset.noun.bond
  ::
      %on-push
    ::  react to token %push, where allowance equaling `amount.act` was set
    ::  and this contract was called by `from.act`. we only handle %deposit
    ::  and %new-bond-with-deposit here.
    =/  calldata  ;;(action:lib calldata.act)
    ?>  ?+  -.calldata  %.n
          %deposit                =(amount.act amount.calldata)
          %new-bond-with-deposit  =(amount.act amount.calldata)
        ==
    %=  $
      act  calldata
      id.caller.context  from.act
    ==
  ==
++  read
  |_  =pith
  ++  json
    ~
  ++  noun
    ~
  --
--
