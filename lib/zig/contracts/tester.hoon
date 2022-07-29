::  /+  *zig-sys-smart
|_  =cart
++  write
  |=  [%look my-account=id]
  ^-  chick
  |^
  =/  mine=(unit grain)  (scry my-account)
  ?~  mine
    ~>  %slog.[0 leaf/"grain not found"]
    [%& ~ ~ ~ ~]
  ~>  %slog.[0 leaf/"grain located"]
  ?>  ?=(%& -.u.mine)
  =/  info  ;;(my-mold data.p.u.mine)
  ::  husk is not functional in its current state.
  ::  =/  giver  (husk my-mold u.mine ~ `id.from.cart)
  ::  =/  changed  *(merk id grain)
  =/  hash=@ux  (hash:pedersen 'atom' 0)
  =/  changed=(merk id grain)
    %+  gas:big  *(merk id grain)
    :~  [*id *grain]
    ==
  =/  events
    :~  [%found [%n (scot %ud bal.info)]]
        [%hash [%n (scot %ux hash)]]
    ==
  [%& changed ~ ~ events]
  ::
  +$  my-mold  [bal=@ud m=(map id @ud) meta=@ux]
  --
++  read
  |_  =path
  ++  json
    ~
  ++  noun
    ~
  --
--
