::  Install a desk into multiple pyro ships, in O(1)ish time
::  much faster than doing multiple :pyro|dojo ~nec "|install our %desk"s
::  Usage: -zig!py-install ~[~nec ~bud ~wes ~rus] %zig
::
/-  spider
/+  pyro=zig-pyro, *strandio
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
?~  a=!<((unit (pair (list ship) desk)) arg)  !!
?~  p.u.a  !!
=*  hers  p.u.a
=*  desk  q.u.a
=/  m  (strand ,vase)
;<  =beak  bind:m  get-beak
~&  pyro+%multi-install
;<  ~  bind:m  (commit:pyro [i.hers]~ p.beak desk r.beak)
~&  pyro+installing+i.hers
;<  ~  bind:m  (dojo:pyro i.hers "|install our {<desk>}")
~&  pyro+multi-install+%copying-cache
;<  ~  bind:m  (poke-our %pyro %pyro-action !>([%copy-cache i.hers t.hers]))
;<  ~  bind:m  (commit:pyro t.hers p.beak desk r.beak)
=/  rec  t.hers
|-
?~  rec  (pure:m !>(~))
~&  pyro+installing+i.rec
;<  ~  bind:m  (dojo:pyro i.rec "|install our {<desk>}")
$(rec t.rec)
