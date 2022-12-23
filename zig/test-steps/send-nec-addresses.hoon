/=  indexer  /sur/zig/indexer
/=  zig      /sur/zig/ziggurat
::
|%
++  who
  ^-  @p
  ~nec
::
++  address
  ^-  @ux
  (~(got by addresses:test-globals) who)
::
++  $
  ^-  test-steps:zig
  :~  :+  %dojo
        :-  who
        %-  crip
        "=old-pending %~  key  by  .^((map @ux *) %gx /=wallet=/pending-store/{<address>}/noun)"
      ~
  ::
      :+  %poke
        :-  who
        :^  who  %uqbar  %wallet-poke
        %-  crip
        "[%transaction ~ from={<address>} contract=0x74.6361.7274.6e6f.632d.7367.697a town=0x0 action=[%give to={<(~(got by addresses:test-globals) ~bud)>} amount=123.456 item=0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6]]"
      ~
  ::
      :+  %dojo
        :-  who
        %-  crip
        "=new-pending %~  key  by  .^((map @ux *) %gx /=wallet=/pending-store/{<address>}/noun)"
      ~
  ::
      :+  %dojo
        :-  who
        '=diff-pending (~(dif in new-pending) old-pending)'
      ~
  ::
      :+  %dojo
        :-  who
        '=deploy-tx ?>  =(1 ~(wyt in diff-pending))  -.diff-pending'
      ~
  ::
      :+  %dojo  ::  TODO: back to poke
        :-  who
        %-  crip
        ":uqbar &wallet-poke [%submit from={<address>} hash=deploy-tx gas=[rate=1 bud=1.000.000]]"
      ~
  ::
      :+  %dojo  [who ':sequencer|batch']
      :_  ~
      :+  %scry
        :-  who
        :^  'update:indexer'  %gx  %indexer
        /newest/item/0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6/noun
      ''
  ==
--
