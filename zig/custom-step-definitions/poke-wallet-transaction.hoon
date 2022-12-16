/=  zig  /sur/zig/ziggurat
::
|%
++  $
  |=  $:  [who=@p contract=@ux transaction=@t]
          expected=(list test-read-step:zig)
      ==
  ^-  test-write-step:zig
  :+  %poke
    :-  who
    :^  who  %uqbar  %wallet-poke
    %-  crip
    """
    :*  %transaction
        origin=~
        from={<(~(got by addresses:test-globals) who)>}
        contract={<contract>}
        town=0x0  ::  harcode
        action=[%text {<transaction>}]  ::  TODO: how to transform within the %text?
    ==
    """
  expected
--
