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
    :~  ['compiled' [%b compiled.upd]]
        ['error' [%s ?~(error.upd '' u.error.upd)]]
        ['dir' (dir-to-json dir.upd)]
    ==
  --
++  grad  %noun
--
