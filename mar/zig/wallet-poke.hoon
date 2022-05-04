/-  *ziggurat, *uqbar-wallet
=,  dejs:format
|_  act=wallet-poke
++  grab
  |%
  ++  noun  wallet-poke
  ++  json
    |=  jon=^json
    ^-  wallet-poke
    %-  wallet-poke
    |^
    (process jon)
    ++  process
      %-  of
      :~  [%import-seed (ot ~[[%mnemonic sa] [%password sa] [%nick sa]])]
          [%generate-hot-wallet (ot ~[[%password sa] [%nick sa]])]
          [%derive-new-address (ot ~[[%hdpath sa] [%nick sa]])]
          [%delete-address (ot ~[[%pubkey (se %ux)]])]
          [%edit-nickname (ot ~[[%pubkey (se %ux)] [%nick sa]])]
          [%set-node (ot ~[[%town ni] [%ship (se %p)]])]
          [%set-indexer (ot ~[[%ship (se %p)]])]
          [%submit-custom parse-custom]
          [%submit parse-submit]
      ==
    ++  parse-custom
      %-  ot
      :~  [%from (se %ux)]
          [%to (se %ux)]
          [%town ni]
          [%gas (ot ~[[%rate ni] [%bud ni]])]
          [%args (se %t)]
          [%my-grains (ar (se %ux))]
          [%cont-grains (ar (se %ux))]
      ==
    ++  parse-submit
      %-  ot
      :~  [%from (se %ux)]
          [%to (se %ux)]
          [%town ni]
          [%gas (ot ~[[%rate ni] [%bud ni]])]
          [%args parse-args]
      ==
    ++  parse-args
      %-  of
      :~  [%give parse-give]
          [%give-nft parse-nft]
      ==
    ++  parse-give
      %-  ot
      :~  [%salt (se %ud)]
          [%to (se %ux)]
          [%amount ni]
      ==
    ++  parse-nft
      %-  ot
      :~  [%salt (se %ud)]
          [%to (se %ux)]
          [%item-id ni]
      ==
    --
  --
++  grow
  |%
  ++  noun  act
  --
++  grad  %noun
--
