/-  *wallet, indexer
/+  *wallet-util
=,  enjs:format
|%
++  parse-asset
  |=  [=id:smart =asset]
  ^-  [p=@t q=json]
  :-  (scot %ux id)
  %-  pairs
  :~  ['id' [%s (scot %ux id)]]
      ['town' [%s (scot %ux town-id.asset)]]
      ['token_type' [%s (scot %tas -.asset)]]
      :-  'data'
      %-  pairs
      ?-    -.asset
          %token
        :~  ['balance' (numb balance.asset)]
            ['metadata' [%s (scot %ux metadata.asset)]]
        ==
      ::
          %nft
        :~  ['metadata' [%s (scot %ux metadata.asset)]]
            :-  'items'
            %-  pairs
            %+  turn  ~(tap by items.asset)
            |=  [id=@ud =item]
            :-  (scot %ud id)
            %-  pairs
            :~  ['desc' [%s desc.item]]
                ['attributes' [%s 'todo...']]
                ['uri' [%s uri.item]]
            ==
        ==
      ::
          %unknown
        ~
      ==
  ==
::
++  parse-transaction
  |=  [hash=@ux t=egg:smart args=(unit supported-args)]
  ^-  [p=@t q=json]
  :-  (scot %ux hash)
  %-  pairs
  :~  ['from' [%s (scot %ux id.from.shell.t)]]
      ['nonce' (numb nonce.from.shell.t)]
      ['to' [%s (scot %ux to.shell.t)]]
      ['rate' (numb rate.shell.t)]
      ['budget' (numb budget.shell.t)]
      ['town' [%s (scot %ux town-id.shell.t)]]
      ['status' (numb status.shell.t)]
      ?~  args  ['args' [%s 'received']]
      :-  'args'
      %-  frond
      :-  (scot %tas -.args)
      %-  pairs
      ?-    -.u.args
          %give
        :~  ['to' [%s (scot %ux to.u.args)]]
            ['amount' (numb amount.u.args)]
            ['from_grain' [%s (scot %ux from-grain.u.args)]]
        ==
          %give-nft
        :~  ['to' [%s (scot %ux to.u.args)]]
            ['item_id' (numb item-id.u.args)]
            ['from_grain' [%s (scot %ux from-grain.u.args)]]
        ==
      ::
          %custom
        ~[['args' [%s args.u.args]]]
      ==
  ==
--
