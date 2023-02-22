/=  indexer  /sur/zig/indexer
/=  zig      /sur/zig/ziggurat
::
/=  mip      /lib/mip
::
|%
++  $
  |=  $:  [who=@p sequencer-host=@p wallet-poke=test-write-step:zig]
          expected=(list test-read-step:zig)
      ==
  ^-  [test-steps:zig configs:zig]
  =/  address=@ux
    %.  ['global' [who %address]]
    ~(got bi:mip configs:test-globals)
  :_  configs:test-globals
  :~  :^  %scry  `%old-scry
        :-  who
        :^  '(map @ux *)'  %gx  %wallet
        (crip "/pending-store/{<address>}/noun/noun")
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
      :^  %scry  `%new-scry
        :-  who
        :^  '(map @ux *)'  %gx  %wallet
        (crip "/pending-store/{<address>}/noun/noun")
      ''
  ::
      :^  %poke  ~
        :-  who
        :^  who  %uqbar  %wallet-poke
        %-  crip
        """
        =/  old-pending=(set @ux)  ~(key by old-scry)
        =/  new-pending=(set @ux)  ~(key by new-scry)
        =/  diff-pending=(list @ux)
          ~(tap in (~(dif in new-pending) old-pending))
        ?>  ?=([@ ~] diff-pending)
        :^  %submit  from={<address>}
          hash=i:diff-pending
        gas=[rate=1 bud=1.000.000]
        """
      ~
  ::
      [%wait ~s5]
  ::
      [%dojo ~ [sequencer-host ':sequencer|batch'] ~]
  ==
--
