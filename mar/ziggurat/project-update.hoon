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
    ?-    -.project-update
        %error
      %+  frond:enjs:format  %error
      %+  frond:enjs:format  project-name.project
      %+  pairs:enjs:format
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
      %+  frond:enjs:format  %update
      %=  j
          p
        %-  ~(gas by p.j)
        :+  [%state state]
          [%project-name %s project-name.project]
        ~
      ==
    ==
  --
::
++  grad  %noun
--
