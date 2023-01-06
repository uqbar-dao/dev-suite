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
  %.  [who %address]
  ~(got by (~(got by configs:test-globals) ''))
::
++  them
  ^-  @p
  ~bud
::
++  to
  ^-  @ux
  %.  [them %address]
  ~(got by (~(got by configs:test-globals) ''))
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
  :_  :-  :+  %scry
            :-  who
            :^  'update:indexer'  %gx  %indexer
            /newest/item/(scot %ux item)/noun
          ''
      ~
  :^  %custom-write  %send-wallet-transaction
    %-  crip
    %-  noah
    !>  ^-  [@p test-write-step:zig]
    :-  who
    :+  %poke
      :-  who
      :^  who  %uqbar  %wallet-poke
      %-  crip
      "[%transaction ~ from={<address>} contract={<contract>} town=0x0 action=[%give to={<to>} amount=123.456 item={<item>}]]"
    ~
  ~
--
