/-  *wallet
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
          [%add-tracked-address (ot ~[[%address (se %ux)] [%nick so]])]
          ::
          [%submit-signed parse-signed]
          [%submit parse-submit]
          [%delete-pending parse-delete]
          [%transaction parse-transaction]
      ==
    ++  parse-signed
      %-  ot
      :~  [%from (se %ux)]
          [%hash (se %ux)]
          [%eth-hash (se %ux)]
          [%sig (ot ~[[%v ni] [%r (se %ux)] [%s (se %ux)]])]
          [%gas (ot ~[[%rate ni] [%bud ni]])]
      ==
    ++  parse-submit
      %-  ot
      :~  [%from (se %ux)]
          [%hash (se %ux)]
          [%gas (ot ~[[%rate ni] [%bud ni]])]
      ==
    ++  parse-delete
      %-  ot
      :~  [%from (se %ux)]
          [%hash (se %ux)]
      ==
    ++  parse-transaction
      %-  ot
      :~  [%from (se %ux)]
          [%contract (se %ux)]
          [%town (se %ux)]
          [%action parse-action]
      ==
    ++  parse-action
      %-  of
      :~  [%give parse-give]
          [%give-nft parse-nft]
          [%text so]
      ==
    ++  parse-give
      %-  ot
      :~  [%to (se %ux)]
          [%amount ni]
          [%grain (se %ux)]
      ==
    ++  parse-nft
      %-  ot
      :~  [%to (se %ux)]
          [%grain (se %ux)]
      ==
    --
  --
++  grow
  |%
  ++  noun  act
  --
++  grad  %noun
--
