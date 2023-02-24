/=  zig  /sur/zig/ziggurat
::
/=  mip  /lib/mip
::
|%
++  make-config
  ^-  config:zig
  %-  ~(gas by *config:zig)
  [[~nec %sequencer] 0x0]~
::
++  make-virtualships-to-sync
  ^-  (list @p)
  ~[~nec ~bud ~wes]
::
++  make-install
  ^-  ?
  %.y
::
++  make-start-apps
  ^-  (list @tas)
  ~[%subscriber]
::
++  make-state-views
  ^-  (list [who=@p app=(unit @tas) file-path=path])
  ::  app=~ -> chain view, not an agent view
  =/  pfix  (cury welp `path`/zig/state-views)
  :~  [~nec ~ (pfix /chain/transactions/hoon)]
      [~nec ~ (pfix /chain/chain/hoon)]
      [~nec ~ (pfix /chain/holder-our/hoon)]
      [~nec ~ (pfix /chain/source-zigs/hoon)]
  ::
      [~nec `%wallet (pfix /agent/wallet-metadata-store/hoon)]
      [~nec `%wallet (pfix /agent/wallet-our-items/hoon)]
  ==
::
++  make-setup
  |^  ^-  (map @p test-steps:zig)
  %-  ~(gas by *(map @p test-steps:zig))
  :^    [~nec make-setup-nec]
      [~bud make-setup-bud]
    [~wes make-setup-wes]
  ~
  ::
  ++  make-setup-nec
    ^-  test-steps:zig
    =/  who=@p  ~nec
    :~  [%dojo ~ [who ':rollup|activate'] ~]
    ::
        :^  %poke  ~
          :-  who
          [who %indexer %indexer-action '[%set-sequencer [~nec %sequencer]]']
        ~
    ::
        :^  %poke  ~
          [who who %indexer %indexer-action '[%set-rollup [~nec %rollup]]']
        ~
    ::
        :^  %dojo  ~
          :-  who
          ':sequencer|init our 0x0 0xc9f8.722e.78ae.2e83.0dd9.e8b9.db20.f36a.1bc4.c704.4758.6825.c463.1ab6.daee.e608'
        ~
    ::
        :^  %poke  ~
          :-  who
          :^  who  %uqbar  %wallet-poke
          '[%import-seed \'uphold apology rubber cash parade wonder shuffle blast delay differ help priority bleak ugly fragile flip surge shield shed mistake matrix hold foam shove\' \'squid\' \'nickname\']'
        ~
    ::
        [%subscribe ~ [who who %uqbar /track] ~]
    ==
  ::
  ++  make-setup-bud
    ^-  test-steps:zig
    =/  who=@p  ~bud
    %+  snoc  (make-setup-chain-user who)
    :^  %poke  ~
      :-  who
      :^  who  %uqbar  %wallet-poke
      '[%import-seed \'post fitness extend exit crack question answer fruit donkey quality emotion draw section width emotion leg settle bulb zero learn solution dutch target kidney\' \'squid\' \'nickname\']'
    ~
  ::
  ++  make-setup-wes
    ^-  test-steps:zig
    =/  who=@p  ~wes
    %+  snoc  (make-setup-chain-user who)
    :^  %poke  ~
      :-  who
      :^  who  %uqbar  %wallet-poke
      '[%import-seed \'flee alter erode parrot turkey harvest pass combine casual interest receive album coyote shrug envelope turtle broken purity wear else fluid transaction theme buyer\' \'squid\' \'nickname\']'
    ~
  ::
  ++  make-setup-chain-user
    |=  who=@p
    ^-  test-steps:zig
    :~  :^  %poke  ~
          :-  who
          [who %indexer %indexer-action '[%set-sequencer [~nec %sequencer]]']
        ~
    ::
        :^  %poke  ~
          [who who %indexer %indexer-action '[%set-rollup [~nec %rollup]]']
        ~
    ::
        :^  %poke  ~
          :-  who
          [who %indexer %indexer-action '[%bootstrap [~nec %indexer]]']
        ~
    ==
  --
--
