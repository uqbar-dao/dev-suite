/-  zig=zig-ziggurat
/+  zig-lib=zig-ziggurat
|_  =update:zig
::
++  grab
  |%
  ++  noun  update:zig
  --
::
++  grow
  |%
  ++  noun  update
  ++  json
    =,  enjs:format
    ^-  ^json
    ?-    -.update
        %error
      %+  frond  %error
      %+  frond  project-name.update
      %-  pairs
      :~  [%project-name %s project-name.update]
          [%source %s source.update]
          [%level %s level.update]
          [%message %s message.update]
      ==
    ::
        %update
      =*  state    state.update
      =*  project  +.+.+.update
      =/  j=^json  (project:enjs:zig-lib project)
      =/  name-and-state=(list [@ta ^json])
        :+  [%state (state:enjs:zig-lib state)]
          [%project-name %s project-name.update]
        ~
      %+  frond  %update
      ?~  j           (pairs name-and-state)
      ?.  ?=(%o -.j)  (pairs name-and-state)
      j(p (~(gas by p.j) name-and-state))
    ==
  --
::
++  grad  %noun
--
