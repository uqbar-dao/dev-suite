::  /+  *zig-sys-smart
|%
++  sur
  |%
  ::  calls is hashed to form proposal's key in pending map
  ::  this hash is used to vote on that proposal
  +$  proposal
    $:  calls=(list [to=id town=id =yolk])
        votes=(pmap address ?)
        ayes=@ud
        nays=@ud
    ==
  ::
  +$  multisig-state
    $:  members=(pset address)
        threshold=@ud
        pending=(pmap @ux proposal)
    ==
  ::
  +$  action
    $%  ::  anyone can call the following to create a new multisig grain
        [%create threshold=@ud members=(pset address)]
        ::  actions for an already-created multisig
        [%vote multisig=id proposal-hash=@ux aye=?]
        ::
        [%propose multisig=id calls=(list [to=id town=id =yolk])]
        ::  the following must be sent by the contract, which means
        ::  that they can only be executed by a successful proposal!
        [%add-member multisig=id =address]
        [%remove-member multisig=id =address]
        [%set-threshold multisig=id new=@ud]
    ==
  --
::
++  lib
  |%
  --
--