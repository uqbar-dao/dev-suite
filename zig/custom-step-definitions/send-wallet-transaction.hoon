/=  indexer  /sur/zig/indexer
/=  zig      /sur/zig/ziggurat
::
/=  mip      /lib/mip
::
|%
++  $
  |=  $:  [who=@p wallet-poke=test-write-step:zig]
          expected=(list test-read-step:zig)
      ==
  ^-  test-steps:zig
  =/  address=@ux
    %.  ['global' [who %address]]
    ~(got bi:mip configs:test-globals)
  :~  :+  %scry
        :-  who
        :^  '(map @ux *)'  %gx  %wallet
        /pending-store/(scot %ux address)/noun
      ''
  ::
      ::  TODO: avoid this stupid compiler-satisfying pattern
      ?-  -.wallet-poke
        %dojo          wallet-poke(expected expected)
        %poke          wallet-poke(expected expected)
        %subscribe     wallet-poke(expected expected)
        %custom-write  wallet-poke(expected expected)
      ==
  ::
      :+  %scry
        :-  who
        :^  '(map @ux *)'  %gx  %wallet
        /pending-store/(scot %ux address)/noun
      ''
  ::
      :+  %poke
        :-  who
        :^  who  %uqbar  %wallet-poke
        %-  crip
        """
        =/  old-test-result=test-result:zig
          (snag 2 test-results:test-globals)
        ?>  ?=([* ~] old-test-result)
        =/  old-pending=(set @ux)
          %~  key  by
          !<((map @ux *) result:i:old-test-result)
        =/  new-test-result=test-result:zig
          (snag 0 test-results:test-globals)
        ?>  ?=([* ~] new-test-result)
        =/  new-pending=(set @ux)
          %~  key  by
          !<((map @ux *) result:i:new-test-result)
        =/  diff-pending=(list @ux)
          ~(tap in (~(dif in new-pending) old-pending))
        ?>  ?=([@ ~] diff-pending)
        :^  %submit  from={<address>}
          hash=i:diff-pending
        gas=[rate=1 bud=1.000.000]
        """
      ~
  ::
      [%dojo [who ':sequencer|batch'] ~]
  ==
--
