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
=/  args  !<((unit [p=path q=(unit @ux)]) arg)
?~  args  (pure:m !>(~))
;<  =bowl:spider  bind:m  get-bowl:strandio
=/  watch-path=path
  %+  snoc  p.u.args
  %+  scot  %ux
  ?~(q.u.args (cut 5 [0 1] eny.bowl) u.q.u.args)
=/  watch-wire=wire  /my/wire
;<  ~  bind:m
  (watch watch-wire [our.bowl %indexer] watch-path)
~&  >  "watch-indexer: watching {<watch-path>}..."
;<  =cage  bind:m  (take-fact watch-wire)
:: ~&  >  "watch-indexer: got:"
:: ~&  >  "watch-indexer:  {<cage>}"
;<  ~  bind:m  (leave watch-wire [our.bowl %indexer])
?+    p.cage
      ~&  >  "watch-indexer: done"
      (pure:m !>(~))
    %indexer-update
  ~&  >  "watch-indexer:  got:"
  ~&  !<(update:ui q.cage)
  ~&  >  "watch-indexer:  done"
  (pure:m !>(~))
::
    %json
  ~&  >  "watch-indexer:  got:"
  ~&  !<(json q.cage)
  ~&  (en-json:html !<(json q.cage))
  ~&  >  "watch-indexer:  done"
  (pure:m !>(~))
==
