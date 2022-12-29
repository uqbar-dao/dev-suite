/-  zig=zig-ziggurat
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
    =,  enjs:format
    ^-  ^json
    ?-    -.project-update
        %error
      %+  frond  %error
      %+  frond  project-name.project-update
      %-  pairs
      :~  [%project-name %s project-name.project-update]
          [%source %s source.project-update]
          [%level %s level.project-update]
          [%message %s message.project-update]
      ==
    ::
        %update
      =*  state    state.project-update
      =*  project  +.+.+.project-update
      =/  j=^json  (project:enjs:zig-lib project)
      =/  name-and-state=(list [@ta ^json])
        :+  [%state (state:enjs:zig-lib state)]
          [%project-name %s project-name.project-update]
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
