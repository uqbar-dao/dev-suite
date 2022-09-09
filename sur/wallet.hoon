/+  smart=zig-sys-smart
|%
+$  signature   [p=@ux q=ship r=life]
::
::  book: the primary map of assets that we track
::  supports fungibles and NFTs
::
+$  book  (map id:smart asset)
+$  asset
  $%  [%token town-id=@ux contract=id:smart metadata=id:smart token-account]
      [%nft town-id=@ux contract=id:smart metadata=id:smart nft]
      [%unknown town-id=@ux contract=id:smart *]
  ==
::
+$  metadata-store  (map id:smart asset-metadata)
+$  asset-metadata
  $%  [%token town-id=@ux token-metadata]
      [%nft town-id=@ux nft-metadata]
  ==
::
+$  transaction-store
  %+  map  address:smart
  $:  sent=(map @ux [=egg:smart action=supported-actions])
      received=(map @ux =egg:smart)
  ==
::
+$  pending-store
  %+  map  address:smart
  (map @ux [=egg:smart action=supported-actions])
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
      [%tx-status hash=@ux =egg:smart action=supported-actions]
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
      [%sign-typed-message from=id:smart =typed-message:smart]
      [%add-tracked-address address=@ux nick=@t]
      ::  testing and internal
      [%set-nonce address=@ux town=id:smart new=@ud]
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
          town=id:smart
          action=supported-actions
      ==
  ==
::
+$  supported-actions
  $%  [%give to=address:smart amount=@ud grain=id:smart]
      [%give-nft to=address:smart grain=id:smart]
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
      minters=(pset:smart id:smart)
      deployer=id:smart
      salt=@
  ==
::
+$  token-account
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
