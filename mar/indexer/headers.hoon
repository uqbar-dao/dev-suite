/-  ui=zig-indexer,
    zig=zig-ziggurat
/+  ui-lib=zig-indexer
::
|_  headers=(list [epoch-num=@ud =block-header:zig])
+$  headers-mold  (list [epoch-num=@ud =block-header:zig])
++  grab
  |%
  ++  noun  headers-mold
  --
::
++  grow
  |%
  ++  noun  headers
  ++  json  (headers:enjs:ui-lib headers)
  --
::
++  grad  %noun
::
--
