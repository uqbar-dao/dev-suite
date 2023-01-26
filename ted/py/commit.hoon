::  Commit into multiple pyro ships, in O(1) time
::  much faster than doing multiple :pyro|commits
::  Usage: -zig!py-commit ~[~nec ~bud ~wes ~rus] %zig
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
~&  pyro+multi-commit+hers
;<  ~  bind:m  (commit:pyro [i.hers]~ p.beak desk r.beak)
;<  ~  bind:m  (poke-our %pyro %pyro-action !>([%copy-cache i.hers t.hers]))
~&  pyro+multi-commit+%copying-cache
;<  ~  bind:m  (commit:pyro t.hers p.beak desk r.beak)
(pure:m !>(~))
