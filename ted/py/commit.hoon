/-  spider
/+  pyro=zig-pyro, *strandio
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
?~  a=!<((unit (pair (list ship) desk)) arg)  !!
?~  p.u.a  !!
=*  hers  p.u.a
=*  desk  q.u.a
~&  >  t.hers

=/  m  (strand ,vase)
;<  =beak  bind:m  get-beak
~&  >  "starting"
;<  ~  bind:m  (commit:pyro [i.hers]~ p.beak desk r.beak)
~&  >  "done first commit"
;<  ~  bind:m  (poke-our %pyro %pyro-action !>([%copy-cache i.hers t.hers]))
~&  >  "done copying cache"
;<  ~  bind:m  (commit:pyro t.hers p.beak desk r.beak)
~&  >  "done committing all"
(pure:m *vase)
