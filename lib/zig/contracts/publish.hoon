::  publish.hoon  [UQ| DAO]
::
::  Smart contract that processes deployment and upgrades
::  for other smart contracts. Automatically (?) inserted
::  on any town that wishes to allow contract production.
::
::  /+  *zig-sys-smart
/=  pub  /lib/zig/contracts/lib/publish
|_  =cart
++  write
  |=  act=action:pub
  ^-  chick
  ?-    -.act
      %deploy
    ::  0x0 denotes immutable contract
    =/  lord=id  ?.(mutable.act 0x0 me.cart)
    =+  our-id=(fry-wheat lord town-id.cart `cont.act)
    =/  contract=grain
      :*  %|
          `cont.act
          interface.act
          types.act
          our-id
          lord
          id.from.cart
          town-id.cart
      ==
    (result [contract ~] ~ ~ ~)
  ::
      %upgrade
    ::  caller must be holder
    ::  we must be lord
    =/  contract  (need (scry to-upgrade.act))
    ?>  ?&  ?=(%| -.contract)
            =(holder.p.contract id.from.cart)
            =(lord.p.contract me.cart)
        ==
    =.  cont.p.contract  `new-nok.act
    (result [contract ~] ~ ~ ~)
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
