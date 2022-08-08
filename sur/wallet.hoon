/+  smart=zig-sys-smart
|%
+$  signature   [p=@ux q=ship r=life]
::
::  book: the primary map of assets that we track
::  supports fungibles and NFTs
::
+$  book  (map id:smart asset)
+$  asset
  $%  [%token town-id=@ux metadata=id:smart token-account]
      [%nft town-id=@ux metadata=id:smart nft-account]
      [%unknown town-id=@ux *]
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
  $:  sent=(map @ux [=egg:smart args=supported-args])
      received=(map @ux =egg:smart)
  ==
::
::  TODO: move this to smart.hoon?
+$  egg-status-code
  ::  TX status codes:
  $%  %100  ::  100: transaction submitted from wallet to sequencer
      %101  ::  101: transaction received by sequencer
      %103  ::  103: failure: transaction rejected by sequencer
      errorcode:smart
  ==
::
::  sent to web interface
::
+$  wallet-update
  $%  [%new-book tokens=(map pub=id:smart =book)]
      [%tx-status hash=@ux =egg:smart args=(unit supported-args)]
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
      ::  HW wallet stuff
      [%add-tracked-address address=@ux nick=@t]
      [%submit-signed hash=@ eth-hash=@ sig=[v=@ r=@ s=@]]
      ::  testing and internal
      [%set-nonce address=@ux town=id:smart new=@ud]
      ::  TX submit pokes
      ::  if we have a private key for the 'from' address, sign. if not,
      ::  allow hardware wallet to sign on frontend and %submit-signed
      $:  %submit-custom
          from=id:smart
          to=id:smart
          town=id:smart
          gas=[rate=@ud bud=@ud]
          yolk=@t  ::  literally `ream`ed to form yolk
      ==
      $:  %submit
          from=id:smart
          to=id:smart
          town=id:smart
          gas=[rate=@ud bud=@ud]
          args=supported-args
      ==
  ==
::
+$  supported-args
  $%  [%give to=address:smart amount=@ud account=id:smart]
      [%give-nft to=address:smart item-id=@ud account=id:smart]
      [%custom args=@t]
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
      minters=(set id:smart)
      deployer=id:smart
      salt=@
  ==
::
+$  token-account
  $:  balance=@ud
      allowances=(map sender=id:smart @ud)
      metadata=id:smart
  ==
::
::  hardcoded molds comporting to account-NFT standard
::
+$  nft-metadata
  $:  name=@t
      symbol=@t
      attributes=(set @t)
      supply=@ud
      cap=(unit @ud)
      mintable=?
      minters=(set id:smart)
      deployer=id:smart
      salt=@
  ==
::
+$  nft-account
  $:  metadata=id:smart
      items=(map @ud item)
      allowances=(set [id:smart @ud])
      full-allowances=(set id:smart)
  ==
+$  item
  $:  id=@ud
      data=(set [@t @t])
      desc=@t
      uri=@t
      transferrable=?
  ==
--
