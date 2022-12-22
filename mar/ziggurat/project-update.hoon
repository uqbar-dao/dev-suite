/+  zig-lib=zig-ziggurat
|_  =project-update:zig
::
++  grab
  |%
  ++  noun  project-update:zig
  --
::
++  grow
  |%
  ++  noun  project-update
  ++  json
    ^-  ^json
    =*  state    state.project-update
    =*  project  +.project-update
    =/  j=^json  (project:enjs:zig-lib project)
    j(p (~(put by p.j) %state state))
  --
::
++  grad  %noun
--
