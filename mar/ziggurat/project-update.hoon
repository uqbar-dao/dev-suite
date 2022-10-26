/+  *zig-ziggurat
=,  enjs:format
|_  upd=project-update
++  grab
  |%
  ++  noun  project-update
  --
++  grow
  |%
  ++  noun  upd
  ++  json
    ^-  ^json
    %-  pairs
    :~  ['dir' (dir-to-json dir.upd)]
        ['compiled' [%b compiled.upd]]
        ['errors' [%a errors.upd]]
        ['state' (state-to-json p.chain.upd data-texts.upd)]
        ['tests' (tests-to-json tests.upd)]
    ==
  --
++  grad  %noun
--
