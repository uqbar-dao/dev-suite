/+  *ziggurat
=,  enjs:format
|_  upd=app-update
++  grab
  |%
  ++  noun  app-update
  --
++  grow
  |%
  ++  noun  upd
  ++  json
    ^-  ^json
    %-  pairs
    :~  ['dir' (dir-to-json dir.upd)]
    ==
  --
++  grad  %noun
--
