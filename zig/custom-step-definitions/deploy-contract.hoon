/=  zig  /sur/zig/ziggurat
::
/=  mip  /lib/mip
::
|%
++  $
  |=  $:  [who=@p contract-jam-path=path non-default-publish-contract-id=(unit @ux)]
          expected=(list test-read-step:zig)
      ==
  ^-  test-steps:zig
  :_  ~
  =/  publish-contract-id=@ux
    (fall non-default-publish-contract-id 0x1111.1111)
  =/  scry-path=path
    %-  weld  :_  contract-jam-path
    :-  (scot %p our:test-globals)
    /[project:test-globals]/(scot %da now:test-globals)
  =/  contract-jam=@  .^(@ %cx scry-path)
  =/  contract  [- +]:(cue contract-jam)
  :^  %poke  ~
    :-  who
    :^  who  %uqbar  %wallet-poke
    %-  crip
    """
    :*  %transaction
        origin=~
        from={<(~(got bi:mip configs:test-globals) 'global' [who %address])>}
        contract={<publish-contract-id>}
        town=0x0  ::  harcode
        [%noun [%deploy mutable=%.n cont={<contract>} interface=~ types=~]]
    ==
    """
  expected
--
