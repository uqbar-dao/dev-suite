/-  spider,
    ui=indexer
/+  strandio,
    smart=zig-sys-smart
::
=*  strand     strand:spider
=*  leave      leave:strandio
=*  take-fact  take-fact:strandio
=*  watch      watch:strandio
::
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=/  args  !<((unit path) arg)
?~  args  (pure:m !>(~))
;<  =bowl:spider  bind:m  get-bowl:strandio
=*  watch-path  u.args
=/  watch-wire=wire  /my/wire
;<  ~  bind:m
  (watch watch-wire [our.bowl %indexer] watch-path)
~&  >  "watch-indexer: watching {<watch-path>}..."
;<  =cage  bind:m  (take-fact watch-wire)
~&  >  "watch-indexer: got:"
~&  >  "watch-indexer:  {<cage>}"
?:  ?=(%indexer-update p.cage)
  ~&  >  "watch-indexer:  {<!<(update:ui q.cage)>}"
  ;<  ~  bind:m  (leave watch-wire [our.bowl %indexer])
  ~&  >  "watch-indexer:  done"
  (pure:m !>(~))
;<  ~  bind:m  (leave watch-wire [our.bowl %indexer])
~&  >  "watch-indexer:  done"
(pure:m !>(~))
