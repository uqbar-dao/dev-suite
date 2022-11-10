/-  eng=zig-engine
/+  smart=zig-sys-smart
|%
+$  signature   [p=@ux q=ship r=life]
::
::  book: the primary map of assets that we track
::  supports fungibles and NFTs
::
+$  book  (map id:smart asset)
+$  asset
  $%  [%token town=@ux contract=id:smart metadata=id:smart token-account]
      [%nft town=@ux contract=id:smart metadata=id:smart nft]
      [%unknown town=@ux contract=id:smart *]
  ==
::
+$  metadata-store  (map id:smart asset-metadata)
+$  asset-metadata
  $%  [%token town=@ux token-metadata]
      [%nft town=@ux nft-metadata]
  ==
::
+$  unfinished-transaction-store
  (list [hash=@ux tx=transaction:smart action=supported-actions])
::
+$  transaction-store
  %+  map  address:smart
  (map @ux [=transaction:smart action=supported-actions =output:eng])
::
+$  pending-store
  %+  map  address:smart
  (map @ux [=transaction:smart action=supported-actions])
::
+$  transaction-status-code
  $?  %100  ::  100: transaction pending in wallet
      %101  ::  101: transaction submitted from wallet to sequencer
      %102  ::  102: transaction received by sequencer
      %103  ::  103: failure: transaction rejected by sequencer
      ::
      ::  200-class refers to codes that come from a completed, processed transaction
      ::  informed by egg status codes in smart.hoon
      %200  ::  200: successfully performed
      %201  ::  201: bad signature
      %202  ::  202: incorrect nonce
      %203  ::  203: lack zigs to fulfill budget
      %204  ::  204: couldn't find contract
      %205  ::  205: data was under contract ID
      %206  ::  206: crash in contract execution
      %207  ::  207: validation of diff failed
      %208  ::  208: ran out of gas while executing
      %209  ::  209: dedicated burn transaction failed
  ==
::
::  sent to web interface
::
+$  wallet-update
  $%  [%new-book tokens=(map pub=id:smart =book)]
      [%new-metadata metadata=metadata-store]
      [%finished-tx hash=@ux =transaction:smart action=supported-actions =output:eng]
      [%tx-status hash=@ux =transaction:smart action=supported-actions]
  ==
::
::  received from web interface
::
+$  wallet-poke
  $%  [%import-seed mnemonic=@t password=@t nick=@t]
      [%generate-hot-wallet password=@t nick=@t]
      [%derive-new-address hdpath=tape nick=@t]
      [%delete-address address=@ux]
      [%edit-nickname address=@ux nick=@t]
      [%sign-typed-message from=address:smart =typed-message:smart]
      [%add-tracked-address address=@ux nick=@t]
      ::  testing and internal
      [%set-nonce address=@ux town=@ux new=@ud]
      ::
      ::  TX submit pokes
      ::
      ::  sign a pending transaction from an attached hardware wallet
      $:  %submit-signed
          from=address:smart
          hash=@
          eth-hash=@
          sig=[v=@ r=@ s=@]
          gas=[rate=@ud bud=@ud]
      ==
      ::  sign a pending transaction from this wallet
      $:  %submit
          from=address:smart
          hash=@
          gas=[rate=@ud bud=@ud]
      ==
      ::  remove a pending transaction without signing
      $:  %delete-pending
          from=address:smart
          hash=@
      ==
      ::
      $:  %transaction
          from=address:smart
          contract=id:smart
          town=@ux
          action=supported-actions
      ==
  ==
::
+$  supported-actions
  $%  [%give to=address:smart amount=@ud item=id:smart]
      [%give-nft to=address:smart item=id:smart]
      [%text @t]
      [%noun *]
  ==
::
::  hardcoded molds comporting to account-token standard
::
+$  token-metadata
  $:  name=@t
      symbol=@t
      decimals=@ud
      supply=@ud
      cap=(unit @ud)
      mintable=?
      minters=(pset:smart address:smart)
      deployer=id:smart
      salt=@
  ==
::
+$  token-account
  $:  balance=@ud
      allowances=(pmap:smart sender=address:smart @ud)
      metadata=id:smart
      nonces=(pmap:smart taker=address:smart @ud)
  ==
::
::  hardcoded molds comporting to account-NFT standard
::
+$  nft-metadata
  $:  name=@t
      symbol=@t
      properties=(pset:smart @tas)
      supply=@ud
      cap=(unit @ud)  ::  (~ if mintable is false)
      mintable=?      ::  automatically set to %.n if supply == cap
      minters=(pset:smart address:smart)
      deployer=id:smart
      salt=@
  ==
::
+$  nft  ::  a non-fungible token
  $:  id=@ud
      uri=@t
      metadata=id:smart
      allowances=(pset:smart address:smart)
      properties=(pmap:smart @tas @t)
      transferrable=?
  ==
--
