/-  *zig-wallet
/+  *zig-wallet
=,  enjs:format
|_  upd=wallet-frontend-update
++  grab
  |%
  ++  noun  wallet-frontend-update
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
      (asset:parsing id asset)
    ::
        %new-metadata
      %-  pairs
      %+  turn  ~(tap by metadata.upd)
      |=  [=id:smart d=asset-metadata]
      (metadata:parsing id d)
    ::
        %tx-status
      %-  frond
      (transaction-no-output:parsing hash.upd ~ +.+.upd)
    ::
        %finished-tx
      %-  frond
      (transaction-with-output:parsing +.upd)
    ==
  --
++  grad  %noun
--
