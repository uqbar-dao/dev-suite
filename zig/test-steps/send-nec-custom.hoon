/=  indexer  /sur/zig/indexer
/=  zig      /sur/zig/ziggurat
::
|%
++  $
  ^-  test-steps:zig
  :~  :+  %dojo
        :-  ~nec
        %-  crip
        "=old-pending %~  key  by  .^((map @ux *) %gx /=wallet=/pending-store/{<(~(got by addresses:test-globals) ~nec)>}/noun)"
      ~
  ::
      :^  %custom-write  %poke-wallet-transaction
        '[who=~nec contract=0x74.6361.7274.6e6f.632d.7367.697a transaction=\'[%give to=0xd6dc.c8ff.7ec5.4416.6d4e.b701.d1a6.8e97.b464.76de amount=123.456 item=0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6 `0xd79b.98fc.7d3b.d71b.4ac9.9135.ffba.cc6c.6c98.9d3b.8aca.92f8.b07e.a0a5.3d8f.a26c]\']'
      ~
  ::
      :+  %dojo
        :-  ~nec
        %-  crip
        "=new-pending %~  key  by  .^((map @ux *) %gx /=wallet=/pending-store/{<(~(got by addresses:test-globals) ~nec)>}/noun)"
      ~
  ::
      :+  %dojo
        :-  ~nec
        '=diff-pending (~(dif in new-pending) old-pending)'
      ~
  ::
      :+  %dojo
        :-  ~nec
        '=deploy-tx ?>  =(1 ~(wyt in diff-pending))  -.diff-pending'
      ~
  ::
      :+  %poke
        :^  ~nec  %uqbar  %wallet-poke
        '[%submit from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 hash=deploy-tx gas=[rate=1 bud=1.000.000]]'
      ~
  ::
      :+  %dojo  [~nec ':sequencer|batch']
      :_  ~
      :^  %custom-read  %scry-indexer
        '/newest/item/0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6/noun'
      ''
  ==
--
