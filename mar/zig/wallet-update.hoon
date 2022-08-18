/-  *ziggurat, *wallet
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
      ~&  >>  %-  pairs
              %+  turn  ~(tap by tokens.upd)
              |=  [=address:smart =book]
              :-  (scot %ux address)
              %-  pairs
              %+  turn  ~(tap by book)
              |=  [=id:smart =asset]
              (parse-asset id asset)
      %-  pairs
      %+  turn  ~(tap by tokens.upd)
      |=  [=address:smart =book]
      :-  (scot %ux address)
      %-  pairs
      %+  turn  ~(tap by book)
      |=  [=id:smart =asset]
      (parse-asset id asset)
    ::
        %tx-status
      %-  frond
      (parse-transaction hash.upd egg.upd args.upd)
    ==
  --
++  grad  %noun
--
