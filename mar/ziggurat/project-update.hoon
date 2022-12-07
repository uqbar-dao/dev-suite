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
    =*  state    state.upd
    =*  project  +.upd
    =/  j=json  (project-to-json project)
    j(p (~(put by p.j) %state state))
  --
++  grad  %noun
--
