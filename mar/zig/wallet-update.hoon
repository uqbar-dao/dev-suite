/-  *wallet
/+  *wallet-parsing
=,  enjs:format
|_  upd=wallet-update
++  grab
  |%
  ++  noun  wallet-update
  --
++  grow
  |%
  ++  noun  upd
  ++  json
    ?-    -.upd
        %new-book
      %-  pairs
      %+  turn  ~(tap by tokens.upd)
      |=  [=address:smart =book]
      :-  (scot %ux address)
      %-  pairs
      %+  turn  ~(tap by book)
      |=  [=id:smart =asset]
      (parse-asset id asset)
    ::
        %new-metadata
      %-  pairs
      %+  turn  ~(tap by metadata.upd)
      |=  [=id:smart d=asset-metadata]
      (parse-metadata id d)
    ::
        %tx-status
      %-  frond
      (parse-transaction hash.upd egg.upd action.upd)
    ==
  --
++  grad  %noun
--
