/=  indexer  /sur/zig/indexer
/=  zig      /sur/zig/ziggurat
::
|%
++  $
  ^-  test-steps:zig
  :^    :+  %poke
          :^  ~nec  %uqbar  %wallet-poke
          '[%transaction ~ from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 contract=0x74.6361.7274.6e6f.632d.7367.697a town=0x0 action=[%give to=0xd6dc.c8ff.7ec5.4416.6d4e.b701.d1a6.8e97.b464.76de amount=123.456 item=0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6]]'
        ~
      :+  %poke
        :^  ~nec  %uqbar  %wallet-poke
        '[%submit from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 hash=0xa99c.4c8e.1c8d.abb8.e870.81e8.8c96.2cf5 gas=[rate=1 bud=1.000.000]]'
      ~
    :+  %dojo  [~nec ':sequencer|batch']
    :_  ~
    :+  %scry
      :-  ~nec
      :^  'update:indexer'  %gx  %indexer
      /newest/item/0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6/noun
    ''
  ~
--
