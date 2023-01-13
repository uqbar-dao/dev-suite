/=  zig  /sur/zig/ziggurat
::
/=  mip  /lib/mip
::
|%
++  $
  ^-  test-steps:zig
  (weld setup-nec setup-bud)
::
++  setup-nec
  ^-  test-steps:zig
  :~  [%dojo [~nec ':rollup|activate'] ~]
  ::
      :+  %poke
        :-  ~nec
        [~nec %indexer %indexer-action '[%set-sequencer [~nec %sequencer]]']
      ~
  ::
      :+  %poke
        [~nec ~nec %indexer %indexer-action '[%set-rollup [~nec %rollup]]']
      ~
  ::
      :+  %dojo
        :-  ~nec
        ':sequencer|init our 0x0 0xc9f8.722e.78ae.2e83.0dd9.e8b9.db20.f36a.1bc4.c704.4758.6825.c463.1ab6.daee.e608'
      ~
  ::
      :+  %poke
        :-  ~nec
        :^  ~nec  %uqbar  %wallet-poke
        '[%import-seed \'uphold apology rubber cash parade wonder shuffle blast delay differ help priority bleak ugly fragile flip surge shield shed mistake matrix hold foam shove\' \'squid\' \'nickname\']'
      ~
  ::
      [%subscribe [~nec ~nec %uqbar /track] ~]
  ==
::
++  setup-bud
  ^-  test-steps:zig
  :~  :+  %poke
        :-  ~bud
        [~bud %indexer %indexer-action '[%set-sequencer [~nec %sequencer]]']
      ~
  ::
      :+  %poke
        [~bud ~bud %indexer %indexer-action '[%set-rollup [~nec %rollup]]']
      ~
  ::
      :+  %poke
        :-  ~bud
        [~bud %indexer %indexer-action '[%bootstrap [~nec %indexer]]']
      ~
  ::
      :+  %poke
        :-  ~bud
        :^  ~bud  %uqbar  %wallet-poke
        '[%import-seed \'post fitness extend exit crack question answer fruit donkey quality emotion draw section width emotion leg settle bulb zero learn solution dutch target kidney\' \'squid\' \'nickname\']'
      ~
  ==
--
