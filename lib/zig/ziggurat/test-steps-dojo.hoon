::  helper file. Instead of pasting all of this into the dojo
::  just run `=help -build-file /=zig=/lib/zig/ziggurat/dojo-utils/hoon`
::
/-  zig=zig-ziggurat
|%
++  setup-nec
  ^-  test-steps:zig
  :~  [%dojo [~nec ':rollup|activate'] ~]
      [%dojo [~nec ':sequencer|init our 0x0 0xc9f8.722e.78ae.2e83.0dd9.e8b9.db20.f36a.1bc4.c704.4758.6825.c463.1ab6.daee.e608'] ~]
      [%poke [~nec %indexer %set-sequencer '[our %sequencer]'] ~]
      [%poke [~nec %indexer %set-rollup '[our %rollup]'] ~]
      [%poke [~nec %uqbar %wallet-poke '[%import-seed \'uphold apology rubber cash parade wonder shuffle blast delay differ help priority bleak ugly fragile flip surge shield shed mistake matrix hold foam shove\' \'squid\' \'nickname\']'] ~]
      [%subscribe [~nec ~nec %uqbar '/track'] ~]
  ==
::
++  setup-bud
  ^-  test-steps:zig
  :~  [%poke [~bud %indexer %set-sequencer '[~nec %sequencer]'] ~]
      [%poke [~bud %indexer %set-rollup '[~nec %rollup]'] ~]
      [%poke [~bud %indexer %indexer-bootstrap '[~nec %indexer]'] ~]
      [%poke [~bud %uqbar %wallet-poke '[%import-seed \'post fitness extend exit crack question answer fruit donkey quality emotion draw section width emotion leg settle bulb zero learn solution dutch target kidney\' \'squid\' \'nickname\']'] ~]
  ==
::
++  setup
  ^-  test-steps:zig
  (weld setup-nec setup-bud)
::
++  scry-nec
  ^-  test-steps:zig
  [%scry [~nec 'update:indexer' %gx %indexer /batch-order/0x0/noun] '[%batch-order batch-order=~[0xd85a.d919.9806.cbc2.b841.eb0d.854d.22af]]']~

::
++  scry-bud
  ^-  test-steps:zig
  [%scry [~bud 'update:indexer' %gx %indexer /batch-order/0x0/noun] '[%batch-order batch-order=~[0xd85a.d919.9806.cbc2.b841.eb0d.854d.22af]]']~
::
++  scry-clay
  ^-  test-steps:zig
  [%scry [~bud 'wain' %cx %base /desk/bill] '<|acme azimuth dbug dojo eth-watcher hood herm lens ping spider|>']~
::
++  subscribe-nec
  ^-  test-steps:zig
  [%subscribe [~bud ~nec %rollup '/capitol-updates'] [%read-subscription [~bud ~nec %rollup /capitol-updates/noun] 'rollup-update=[%new-capitol capitol={[p=0x0 q=[town-id=0x0 batch-num=0 sequencer=[p=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 q=~nec] mode=[%full-publish ~] latest-diff-hash=0x0 roots=~[0xd85a.d919.9806.cbc2.b841.eb0d.854d.22af]]]}]']~]~
::
++  send-nec
  ^-  test-steps:zig
  :~  [%poke [~nec %uqbar %wallet-poke '[%transaction from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 contract=0x74.6361.7274.6e6f.632d.7367.697a town=0x0 action=[%give to=0xd6dc.c8ff.7ec5.4416.6d4e.b701.d1a6.8e97.b464.76de amount=123.456 item=0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6]]'] ~]
      [%poke [~nec %uqbar %wallet-poke '[%submit from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 hash=0xa99c.4c8e.1c8d.abb8.e870.81e8.8c96.2cf5 gas=[rate=1 bud=1.000.000]]'] ~]
      [%dojo [~nec ':sequencer|batch'] [%scry [~nec 'update:indexer' %gx %indexer /newest/item/0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6/noun] '']~]
  ==
::
++  send-nec-custom
  ^-  test-steps:zig
  :~  [%custom-write %poke-wallet-transaction '[who=~nec contract=0x74.6361.7274.6e6f.632d.7367.697a transaction=\'[%give to=0xd6dc.c8ff.7ec5.4416.6d4e.b701.d1a6.8e97.b464.76de amount=123.456 item=0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6 `0xd79b.98fc.7d3b.d71b.4ac9.9135.ffba.cc6c.6c98.9d3b.8aca.92f8.b07e.a0a5.3d8f.a26c]\']' ~]
      [%poke [~nec %uqbar %wallet-poke '[%submit from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 hash=0xa99c.4c8e.1c8d.abb8.e870.81e8.8c96.2cf5 gas=[rate=1 bud=1.000.000]]'] ~]
      [%dojo [~nec ':sequencer|batch'] `(list test-read-step:zig)`~[[%custom-read %scry-indexer '/newest/item/0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6/noun' '']]]
  ==
::
++  setup-id            (sham setup)
++  scry-nec-id         (sham scry-nec)
++  scry-bud-id         (sham scry-bud)
++  scry-clay-id        (sham scry-clay)
++  subscribe-nec-id    (sham subscribe-nec)
++  send-nec-id         (sham send-nec)
++  send-nec-custom-id  (sham send-nec-custom)
--
