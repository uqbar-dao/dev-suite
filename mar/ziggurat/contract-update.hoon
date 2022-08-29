/+  *ziggurat
=,  enjs:format
|_  upd=contract-update
++  grab
  |%
  ++  noun  contract-update
  --
++  grow
  |%
  ++  noun  upd
  ++  json
    ^-  ^json
    %-  pairs
    :~  ['compiled' [%b compiled.upd]]
        ['error' [%s ?~(error.upd '' u.error.upd)]]
        ['state' (granary-to-json p.state.upd)]
        ['tests' (tests-to-json tests.upd)]
    ==
  --
++  grad  %noun
--
