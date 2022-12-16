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
      :+  %poke
        :-  ~nec
        :^  ~nec  %uqbar  %wallet-poke
        %-  crip
        "[%transaction ~ from={<(~(got by addresses:test-globals) ~nec)>} contract=0x74.6361.7274.6e6f.632d.7367.697a town=0x0 action=[%give to={<(~(got by addresses:test-globals) ~bud)>} amount=123.456 item=0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6]]"
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
      :: :+  %poke
      ::   :-  ~nec
      ::   :^  ~nec  %uqbar  %wallet-poke
      ::   %-  crip
      ::   "[%submit from={<(~(got by addresses:test-globals) ~nec)>} hash=deploy-tx gas=[rate=1 bud=1.000.000]]"
      :: ~
  ::
      :+  %dojo  ::  TODO: back to poke
        :-  ~nec
        %-  crip
        ":uqbar &wallet-poke [%submit from={<(~(got by addresses:test-globals) ~nec)>} hash=deploy-tx gas=[rate=1 bud=1.000.000]]"

      ~
  ::
      :+  %dojo  [~nec ':sequencer|batch']
      :_  ~
      :+  %scry
        :-  ~nec
        :^  'update:indexer'  %gx  %indexer
        /newest/item/0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6/noun
      ''
  ==
--
