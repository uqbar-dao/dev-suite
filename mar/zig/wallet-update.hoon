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
      |=  [pub=@ux =book]
      :-  (scot %ux pub)
      %-  pairs
      %+  turn  ~(tap by book)
      |=  [* [=token-type =grain:smart]]
      (parse-asset token-type grain)
    ::
        %tx-status
      %-  frond
      (parse-transaction hash.upd egg.upd args.upd)
    ==
  --
++  grad  %noun
--
