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
      "[%transaction ~ from={<address>} contract=0x74.6361.7274.6e6f.632d.7367.697a town=0x0 action=[%give to=0xd6dc.c8ff.7ec5.4416.6d4e.b701.d1a6.8e97.b464.76de amount=123.456 item={<item>}]]"
    ~
  ~
--
