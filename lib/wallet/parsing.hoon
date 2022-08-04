/-  *wallet, indexer
/+  *wallet-util
=,  enjs:format
|%
++  parse-asset
  |=  [town-id=@ux =id:smart =asset]
  ^-  [p=@t q=json]
  :-  (scot %ux id)
  %-  pairs
  :~  ['id' [%s (scot %ux id)]]
      ['town' [%s (scot %ux town-id)]]
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
                ['attributes' [%s 'TODO...']]
                ['URI' [%s uri.item]]
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
        :~  ['salt' [%s (scot %ux salt.u.args)]]
            ['to' [%s (scot %ux to.u.args)]]
            ['amount' (numb amount.u.args)]
        ==
          %give-nft
        :~  ['salt' [%s (scot %ux salt.u.args)]]
            ['to' [%s (scot %ux to.u.args)]]
            ['item-id' (numb item-id.u.args)]
        ==
      ::
          %custom
        ~[['args' [%s args.u.args]]]
      ==
  ==
--
