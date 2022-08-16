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
    =+  our-id=(fry-wheat me.cart town-id.cart `cont.act)
    =/  holder  ?:(mutable.act id.from.cart 0x0)
    =/  contract=grain
      :*  %|
          `cont.act
          interface.act
          types.act
          our-id
          me.cart
          holder
          town-id.cart
      ==
    (result ~ [contract ~] ~ ~)
  ::
      %upgrade
    ::  caller must be holder
    =/  contract  (need (scry to-upgrade.act))
    ?>  ?&  ?=(%| -.contract)
            =(holder.p.contract id.from.cart)
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
