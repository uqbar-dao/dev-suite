/=  indexer  /sur/zig/indexer
/=  zig      /sur/zig/ziggurat
::
|%
++  $
  |=  [result-face=(unit @t) indexer-path=path expected=@t]
  ^-  test-steps:zig
  :_  ~
  :^  %scry  result-face
    :*  who=~nec  ::  hardcode: ~nec runs rollup/sequencer
        'update:indexer'
        %gx
        %indexer
        indexer-path
    ==
  expected
--
