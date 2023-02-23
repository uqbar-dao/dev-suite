/=  zig  /sur/zig/ziggurat
::
/=  mip  /lib/mip
::
|%
++  $
  |=  $:  [who=@p contract=@ux transaction=@t]
          expected=(list test-read-step:zig)
      ==
  ^-  [test-steps:zig configs:zig]
  :_  configs:test-globals
  :_  ~
  :^  %poke  ~
    :-  who
    :^  who  %uqbar  %wallet-poke
    %-  crip
    """
    :*  %transaction
        origin=~
        from={<(~(got bi:mip configs:test-globals) 'global' [who %address])>}
        contract={<contract>}
        town=0x0  ::  harcode
        action=[%text {<transaction>}]  ::  TODO: how to transform within the %text?
    ==
    """
  expected
--
