/-  spider
/+  strandio
::
=*  strand     strand:spider
=*  watch-one  watch-one:strandio
::
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=/  arg-mold
  $:  indexer-to-ping=dock
  ==
=/  args  !<(arg-mold arg)
=*  indexer-to-ping  indexer-to-ping.args
::
=/  watch-path=path  /ping
=/  watch-wire=wire  /ping-response
;<  =cage  bind:m
  (watch-one watch-wire indexer-to-ping watch-path)
?.(?=(%loob p.cage) (pure:m !>(`?`%.n)) (pure:m q.cage))
