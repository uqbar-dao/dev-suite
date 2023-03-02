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
  0x7810.2b9f.109c.e44e.7de3.cd7b.ea4f.45dd.aed8.054c.0b52.b2c8.2788.93c6.5bb4.bb85
::
++  $
  ^-  test-steps:zig
  :~  :^  %dojo  ~
        :-  who
        %-  crip
        "=old-pending %~  key  by  .^((map @ux *) %gx /=wallet=/pending-store/{<address>}/noun)"
      ~
  ::
      :^  %poke  ~
        :-  who
        :^  who  %uqbar  %wallet-poke
        %-  crip
        "[%transaction ~ from={<address>} contract={<contract>} town=0x0 action=[%give to={<to>} amount=123.456 item={<item>}]]"
      ~
  ::
      :^  %dojo  ~
        :-  who
        %-  crip
        "=new-pending %~  key  by  .^((map @ux *) %gx /=wallet=/pending-store/{<address>}/noun)"
      ~
  ::
      :^  %dojo  ~
        :-  who
        '=diff-pending (~(dif in new-pending) old-pending)'
      ~
  ::
      :^  %dojo  ~
        :-  who
        '=tx-hash ?>  =(1 ~(wyt in diff-pending))  -.diff-pending'
      ~
  ::
      :^  %dojo  ~
        :-  who
        %-  crip
        ":uqbar &wallet-poke [%submit from={<address>} hash=tx-hash gas=[rate=1 bud=1.000.000]]"
      ~
  ::
      :^  %dojo  ~  [who ':sequencer|batch']
      :_  ~
      :^  %scry  ~
        :-  who
        :^  'update:indexer'  %gx  %indexer
        (crip "/newest/item/{<item>}/noun/noun")
      ''
  ==
--
