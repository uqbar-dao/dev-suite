/-  spider
/+  strandio
=,  strand=strand:spider
::
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
;<  our=ship  bind:m  get-our:strandio
::
::  no state upgrades needed now, but keeping thread in case future states
::  need to be reset.
::
::  ~&  >  "Nuking all apps in {<our>}'s %zig to prepare for upgrade..."
::  ::
::  =/  apps=(list @tas)
::    :~  %uqbar
::        %rollup
::        %sequencer
::        %indexer
::        %wallet
::        %ziggurat
::        %faucet
::        %batcher-interval
::        %batcher-threshold
::    ==
::  =/  cards
::    %+  turn  apps
::    |=  name=@tas
::    [%pass /poke %agent [our %hood] %poke kiln-nuke+!>([name %|])]
::  ;<  ~  bind:m  (send-raw-cards:strandio `(list card:agent:gall)`cards)
(pure:m !>('no upgrade necessary right now!'))
