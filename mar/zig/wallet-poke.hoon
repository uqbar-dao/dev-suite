/-  *ziggurat, *wallet
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
      :~  [%import-seed (ot ~[[%mnemonic so] [%password so] [%nick so]])]
          [%generate-hot-wallet (ot ~[[%password so] [%nick so]])]
          [%derive-new-address (ot ~[[%hdpath sa] [%nick so]])]
          [%delete-address (ot ~[[%address (se %ux)]])]
          [%edit-nickname (ot ~[[%address (se %ux)] [%nick so]])]
          [%set-node (ot ~[[%town ni] [%ship (se %p)]])]
          [%set-indexer (ot ~[[%ship (se %p)]])]
          [%add-tracked-address (ot ~[[%address (se %ux)] [%nick so]])]
          [%submit-signed parse-signed]
          [%submit-custom parse-custom]
          [%submit parse-submit]
      ==
    ++  parse-signed
      %-  ot
      :~  [%hash (se %ux)]
          [%eth-hash (se %ux)]
          [%sig (ot ~[[%v ni] [%r (se %ux)] [%s (se %ux)]])]
      ==
    ++  parse-custom
      %-  ot
      :~  [%from (se %ux)]
          [%to (se %ux)]
          [%town (se %ux)]
          [%gas (ot ~[[%rate ni] [%bud ni]])]
          [%yolk (se %t)]
      ==
    ++  parse-submit
      %-  ot
      :~  [%from (se %ux)]
          [%to (se %ux)]
          [%town (se %ux)]
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
