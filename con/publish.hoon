::  publish.hoon  [UQ| DAO]
::
::  Smart contract that processes deployment and upgrades
::  for other smart contracts. Automatically (?) inserted
::  on any town that wishes to allow contract production.
::
/+  *zig-sys-smart
/=  pub  /con/lib/publish
=,  pub
|_  =context
++  write
  |=  act=action
  ^-  (quip call diff)
  ?-    -.act
      %deploy
    =/  source=id  ?:(mutable.act this.context 0x0)
    =/  pact=item
      :*  %|
          (hash-pact source id.caller.context town.context code.act)
          source
          id.caller.context
          town.context
          code.act
          interface.act
          types.act
      ==
    `(result ~ [pact ~] ~ ~)
  ::
      %upgrade
    ::  this contract must be source to upgrade
    ::  caller must be holder to upgrade
    =/  pact  (need (scry-state to-upgrade.act))
    ?>  ?&  ?=(%| -.pact)
            =(this.context source.p.pact)
            =(id.caller.context holder.p.pact)
        ==
    =.  code.p.pact  new-code.act
    `(result [pact ~] ~ ~ ~)
  ==
::
++  read
  |_  =path
  ++  json
    ~
  ++  noun
    ~
  --
--
