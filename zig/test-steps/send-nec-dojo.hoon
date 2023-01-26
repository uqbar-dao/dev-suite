/=  indexer  /sur/zig/indexer
/=  zig      /sur/zig/ziggurat
::
/=  mip      /lib/mip
::
|%
++  who
  ^-  @p
  ~nec
::
++  address
  ^-  @ux
  %.  ['global' [who %address]]
  ~(got bi:mip configs:test-globals)
::
++  them
  ^-  @p
  ~bud
::
++  to
  ^-  @ux
  %.  ['global' [them %address]]
  ~(got bi:mip configs:test-globals)
::
++  contract
  ^-  @ux
  0x74.6361.7274.6e6f.632d.7367.697a
::
++  item
  ^-  @ux
  0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6
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
        "[%transaction ~ from={<address>} contract={<contract>} town=0x0 action=[%give to={<to>} amount=123.456 item={<item>}]]"
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
        '=tx-hash ?>  =(1 ~(wyt in diff-pending))  -.diff-pending'
      ~
  ::
      :+  %dojo
        :-  who
        %-  crip
        ":uqbar &wallet-poke [%submit from={<address>} hash=tx-hash gas=[rate=1 bud=1.000.000]]"
      ~
  ::
      :+  %dojo  [who ':sequencer|batch']
      :_  ~
      :+  %scry
        :-  who
        :^  'update:indexer'  %gx  %indexer
        /newest/item/(scot %ux item)/noun/noun
      ''
  ==
--
