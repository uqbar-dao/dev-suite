/-  *zig-wallet, ui=zig-indexer
/+  *wallet-util
=,  enjs:format
|%
++  parse-asset
  |=  [=id:smart =asset]
  ^-  [p=@t q=json]
  :-  (scot %ux id)
  %-  pairs
  :~  ['id' [%s (scot %ux id)]]
      ['shard' [%s (scot %ux shard.asset)]]
      ['contract' [%s (scot %ux contract.asset)]]
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
        :~  ['id' (numb id.asset)]
            ['uri' [%s uri.asset]]
            ['metadata' [%s (scot %ux metadata.asset)]]
            ['allowances' (address-set allowances.asset)]
            ['properties' (properties properties.asset)]
            ['transferrable' [%b transferrable.asset]]
        ==
      ::
          %unknown
        ~
      ==
  ==
::
++  parse-metadata
  |=  [=id:smart m=asset-metadata]
  ^-  [p=@t q=json]
  :-  (scot %ux id)
  %-  pairs
  :~  ['id' [%s (scot %ux id)]]
      ['shard' [%s (scot %ux shard.m)]]
      ['token_type' [%s (scot %tas -.m)]]
      :-  'data'
      %-  pairs
      %+  snoc
        ^-  (list [@t json])
        :~  ['name' [%s name.m]]
            ['symbol' [%s symbol.m]]
            ['supply' (numb supply.m)]
            ['cap' ?~(cap.m ~ (numb u.cap.m))]
            ['mintable' [%b mintable.m]]
            ['minters' (address-set minters.m)]
            ['deployer' [%s (scot %ux deployer.m)]]
            ['salt' (numb salt.m)]
        ==
      ?-  -.m
        %token  ['decimals' (numb decimals.m)]
        %nft  ['properties' (properties-set properties.m)]
      ==
  ==
::
++  address-set
  |=  a=(set address:smart)
  ^-  json
  :-  %a
  %+  turn  ~(tap in a)
  |=(a=address:smart [%s (scot %ux a)])
::
++  properties-set
  |=  p=(set @tas)
  ^-  json
  :-  %a
  %+  turn  ~(tap in p)
  |=(prop=@tas [%s (scot %tas prop)])
::
++  properties
  |=  p=(map @tas @t)
  ^-  json
  %-  pairs
  %+  turn  ~(tap by p)
  |=([prop=@tas val=@t] [prop [%s val]])
::
++  parse-transaction
  |=  [hash=@ux t=transaction:smart action=supported-actions]
  ^-  [p=@t q=json]
  :-  (scot %ux hash)
  %-  pairs
  :~  ['from' [%s (scot %ux address.caller.t)]]
      ['nonce' (numb nonce.caller.t)]
      ['contract' [%s (scot %ux contract.t)]]
      ['rate' (numb rate.gas.t)]
      ['budget' (numb bud.gas.t)]
      ['shard' [%s (scot %ux shard.t)]]
      ['status' (numb status.t)]
      :-  'action'
      %-  frond
      :-  (scot %tas -.action)
      %-  pairs
      ?-    -.action
          %give
        :~  ['to' [%s (scot %ux to.action)]]
            ['amount' (numb amount.action)]
            ['item' [%s (scot %ux item.action)]]
        ==
      ::
          %give-nft
        :~  ['to' [%s (scot %ux to.action)]]
            ['item' [%s (scot %ux item.action)]]
        ==
      ::
          %text
        ~[['custom' [%s +.action]]]
      ::
          %noun
        ~[['custom' [%s (crip (noah !>(+.action)))]]]
      ==
  ==
--
