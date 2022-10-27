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
        ['user_files' (user-files-to-json user-files.upd)]
        ['compiled' [%b compiled.upd]]
        ['errors' (errors-to-json errors.upd)]
        ['state' (state-to-json p.chain.upd noun-texts.upd)]
        ['tests' (tests-to-json tests.upd)]
    ==
  --
++  grad  %noun
--
