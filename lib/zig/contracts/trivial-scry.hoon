|_  =cart
++  write
  |=  [%find my-account=id]
  ^-  chick
  =+  res=(add 9.876 1.234)
  ::  =/  mine=(unit grain)  (scry my-account)
  ::  =+  (mul 2 2)
  ::  ?~  mine
  ::    ~>  %slog.[0 leaf/"grain not found"]
  ::    [%& ~ ~ ~ ~]
  ::  ~>  %slog.[0 leaf/"grain located"]
  [%& ~ ~ ~ [[%found-grain-id [%n '6']] ~]]
++  read
  |_  =path
  ++  json
    ~
  ++  noun
    ~
  --
--
