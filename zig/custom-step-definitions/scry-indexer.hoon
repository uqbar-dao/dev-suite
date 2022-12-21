/=  indexer  /sur/zig/indexer
/=  zig      /sur/zig/ziggurat
::
|%
++  $
  |=  [indexer-path=path expected=@t]
  ^-  test-steps:zig
  :_  ~
  :+  %scry
    :*  who=~nec  ::  hardcode: ~nec runs rollup/sequencer
        'update:indexer'
        %gx
        %indexer
        indexer-path
    ==
  expected
--
