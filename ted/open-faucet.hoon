/-  spider,
    f=faucet
/+  strandio,
    smart=zig-sys-smart
::
=*  strand     strand:spider
=*  poke       poke:strandio
::
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=/  arg-mold
  $:  faucet-host=@p
      shard-id=id:smart
      =address:smart
  ==
=/  args  !<((unit arg-mold) arg)
?~  args
  ~&  >  "open-faucet: Poke the %faucet app on faucet-host"
  ~&  >  "             to receive some native tokens to address"
  ~&  >  "Usage: -zig!open-faucet faucet-host shard-id address"
=*  faucet-host  faucet-host.u.args
=*  shard-id      shard-id.u.args
=*  address      address.u.args
::
;<  ~  bind:m
  %^  poke  [faucet-host %faucet]  %faucet-action
  !>(`action:f`[%open shard-id address])
(pure:m !>(~))
