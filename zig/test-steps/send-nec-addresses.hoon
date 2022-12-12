/=  indexer  /sur/zig/indexer
/=  zig      /sur/zig/ziggurat
::
|%
++  $
  ^-  test-steps:zig
  :^    :+  %poke
          :^  ~nec  %uqbar  %wallet-poke
          '[%transaction from=(~(got by addresses) ~nec) contract=0x74.6361.7274.6e6f.632d.7367.697a town=0x0 action=[%give to=(~(got by addresses) ~bud) amount=123.456 item=0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6]]'
        ~
      :+  %poke
        :^  ~nec  %uqbar  %wallet-poke
        '[%submit from=(~(got by addresses) ~nec) hash=0xa99c.4c8e.1c8d.abb8.e870.81e8.8c96.2cf5 gas=[rate=1 bud=1.000.000]]'
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
