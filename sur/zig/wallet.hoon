/+  smart=zig-sys-smart
|%
+$  signature   [p=@ux q=ship r=life]
::
::  state -1 fields
+$  book  (map id:smart asset)
+$  asset
  $%  [%token town=@ux contract=id:smart metadata=id:smart token-account]
      [%nft town=@ux contract=id:smart metadata=id:smart nft]
      [%unknown town=@ux contract=id:smart *]
  ==
::
+$  state-0
  $:  %0
      ::  wallet holds a single seed at once
      ::  address-index notes where we are in derivation path
      seed=[mnem=@t pass=@t address-index=@ud]
      ::  many keys can be derived or imported
      ::  if the private key is ~, that means it's a hardware wallet import
      keys=(map address:smart [priv=(unit @ux) nick=@t])
      ::  we track the nonce of each address we're handling
      ::  TODO: introduce a poke to check nonce from chain and re-align
      nonces=(map address:smart (map town=@ux nonce=@ud))
      ::  signatures tracks any signed calls we've made
      signatures=(list [=typed-message:smart =sig:smart])
      ::  tokens tracked for each address we're handling
      tokens=(map address:smart =book-0)
      ::  metadata for tokens we track
      =metadata-store
      ::  transactions we've sent and received
      =transaction-store
      ::  transactions we've been asked to sign, keyed by hash
      =pending-store
  ==
::
::  book: the primary map of assets that we track
::  supports fungibles and NFTs
::
+$  book-0  (map id:smart asset-0)
+$  asset-0
  $%  [%token town-id=@ux contract=id:smart metadata=id:smart token-account-0]
      [%nft town-id=@ux contract=id:smart metadata=id:smart nft]
      [%unknown town-id=@ux contract=id:smart *]
  ==
::
+$  metadata-store  (map id:smart asset-metadata)
+$  asset-metadata
  $%  [%token town=@ux token-metadata]
      [%nft town=@ux nft-metadata]
  ==
::
+$  transaction-store
  %+  map  address:smart
  $:  sent=(map @ux [txn=transaction:smart action=supported-actions])
      received=(map @ux transaction:smart)
  ==
::
+$  pending-store
  %+  map  address:smart
  (map @ux [txn=transaction:smart action=supported-actions])
::
+$  transaction-status-code
  $%  %100  ::  100: transaction pending in wallet
      %101  ::  101: transaction submitted from wallet to sequencer
      %102  ::  102: transaction received by sequencer
      %103  ::  103: failure: transaction rejected by sequencer
      ::
      ::  200-class refers to codes that come from a completed, processed transaction
      ::  informed by egg status codes in smart.hoon
      %200  ::  0: successfully performed
      %201  ::  1: submitted with raw id / no account info
      %202  ::  2: bad signature
      %203  ::  3: incorrect nonce
      %204  ::  4: lack zigs to fulfill budget
      %205  ::  5: couldn't find contract
      %206  ::  6: crash in contract execution
      %207  ::  7: validation of changed/issued/burned rice failed
      %208  ::  8: ran out of gas while executing
      %209  ::  9: was not parallel / superceded by another egg in batch
  ==
::
::  sent to web interface
::
+$  wallet-update
  $%  [%new-book tokens=(map pub=id:smart =book)]
      [%new-metadata metadata=metadata-store]
      [%tx-status hash=@ux txn=transaction:smart action=supported-actions]
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
+$  token-account-0
  $:  balance=@ud
      allowances=(pmap:smart sender=id:smart @ud)
      metadata=id:smart
      nonce=@ud
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
