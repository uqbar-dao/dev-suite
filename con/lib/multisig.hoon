/+  *zig-sys-smart
|%
++  sur
  |%
  ::  calls is hashed to form proposal's key in pending map
  ::  this hash is used to vote on that proposal
  +$  proposal
    $:  calls=(list call)
        votes=(pmap address ?)
        ayes=@ud
        nays=@ud
    ==
  ::
  +$  multisig-state
    $:  members=(pset address)
        threshold=@ud
        executed=(list @ux)
        pending=(pmap @ux proposal)
    ==
  ::
  +$  action
    $%  ::  called once to initialize multisig
        [%create threshold=@ud members=(pset address)]
        ::
        [%execute multisig=id sigs=(pmap id sig) calls=(list call) deadline=@ud]
        ::
        [%vote multisig=id proposal-hash=@ux aye=?]
        [%propose multisig=id calls=(list call)]
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
  ++  execute-jold-hash  0x1bdb.45ec.612a.7371.4ce8.f462.0108.5ab7
    :: ^-  @ux
    :: %-  sham
    :: %-  need
    :: %-  de-json:html
    :: ^-  cord
    :: '''
    :: [
    ::   {"multisig": "ux"},
    ::   {"calls": [
    ::     "list",
    ::     [
    ::       {"contract": "ux"},
    ::       {"town": "ux"},
    ::       {"calldata": [{"p": "tas"}, {"q": "*"}]}
    ::     ]
    ::   ]},
    ::   {"nonce": "ud"},
    ::   {"deadline": "ud"}
    :: ]
    :: '''
  --
--