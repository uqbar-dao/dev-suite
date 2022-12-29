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
      %+  frond  project-name.project
      %+  pairs
      :~  [%project-name %s project-name.project]
          [%source %s source.project]
          [%level %s level.project]
          [%message %s message.project]
      ==
    ::
        %update
      =*  state    state.project-update
      =*  project  +.project-update
      =/  j=^json  (project:enjs:zig-lib project)
      =/  name-and-state=(list [@ta json])
        :+  [%state (state:enjs:zig-lib state)]
          [%project-name %s project-name.project]
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
