/=  zig  /sur/zig/ziggurat
::
/=  mip  /lib/mip
::
|%
++  $
  |=  $:  $:  who=@p
              service-host=@p
              contract-jam-path=path
              mutable=?
              non-default-publish-contract-id=(unit @ux)
          ==
          expected=(list test-read-step:zig)
      ==
  ^-  [test-steps:zig configs:zig]
  =/  publish-contract-id=@ux
    (fall non-default-publish-contract-id 0x1111.1111)
  |^
  :_  %^  ~(put bi:mip configs:test-globals)
        project:test-globals  [who (spat contract-jam-path)]
      compute-escrow-contract-hash
  :_  ~
  :^  %poke  ~
    :-  who
    :^  who  %uqbar  %wallet-poke
    %-  crip
    """
    :*  %transaction
        origin=~
        from={<(~(got bi:mip configs:test-globals) 'global' [who %address])>}
        contract={<publish-contract-id>}
        town=0x0  ::  hardcode
        :-  %noun
        [%deploy mutable={<mutable>} code={<get-escrow-contract>} interface=~]
    ==
    """
  expected
  ::
  ++  get-address
    |=  who=@p
    ^-  @ux
    %.  ['global' [who %address]]
    ~(got bi:mip configs:test-globals)
  ::
  ++  make-full-scry-path
    ^-  path
    %-  weld  :_  contract-jam-path
    :-  (scot %p our:test-globals)
    /[project:test-globals]/(scot %da now:test-globals)
  ::
  ++  get-escrow-contract
    [- +]:(cue .^(@ %cx make-full-scry-path))
  ::
  ++  compute-escrow-contract-hash
    ^-  @ux
    %-  hash-pact:smart:zig
    :^  ?.(mutable 0x0 publish-contract-id)
      (get-address service-host)  town-id=0x0  ::  hardcode
    get-escrow-contract
  --
--
