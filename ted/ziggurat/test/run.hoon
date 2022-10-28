/-  spider,
    zig=zig-ziggurat
/+  strandio,
    pyio=py-io
::
=*  strand  strand:spider
=*  scry    scry:strandio
::
=/  m  (strand ,vase)
|^  ted
::
+$  arg-mold  test-steps:zig
::
++  send-pyro-scry
  |=  payload=scry-payload
  =/  m  (strand ,vase)
  ^-  form:m
  ;<  scry-noun=noun  bind:m
    %+  scry  noun
    [care.payload app.payload (snoc path.payload %noun)]
  =/  scry-molded  ;;(mold.payload scry-noun)
  ?~  scry-molded  (pure:m !>(`~`~))
  (pure:m !>(`mold`u.scry-molded))
::
++  send-pyro-poke
  |=  payload=poke-payload:zig
  =/  m  (strand ,~)
  ^-  form:m
  %+  dojo:pyio  who.payload
  ;:  weld
      ":"
      (trip app.payload)
      " &"
      (trip p.cage.payload)
      " "
      (noah q.cage.payload)
  ==
::
++  run-steps
  |=  =test-steps:zig
  =/  m  (strand ,test-results:zig)
  ^-  form:m
  %-  pure:m
  %+  turn  test-steps
  |=  =test-step:zig
  ?-    -.test-step
      %wait
    ;<  ~  bind:m  (sleep until.test-step)
    ~
    :: [%| ~]
  ::
      %poke
    ;<  ~  bind:m  (send-pyro-poke payload.test-step)
    ;<  trs=test-results:zig  bind:m  (run-steps expected)
    :: ;<  trs=test-results:zig  bind:m  (run-steps `test-steps:zig`expected)
    trs
    :: :-  %|
    :: (turn trs |=([tr=test-result:zig] ?>(%& -.tr) p.tr))
  ::
      %scry
    ;<  ~  result=vase  (send-pyro-scry payload.test-step)
    =*  expected  expected.test-step
    =/  res-text=@t  (noah result)
    [=(expected res-text) expected res-text]
  ::
      %read-subscription  !!
  ::
      %subscribe  !!
  ==
::
++  ted
  ^-  thread:spider
  |=  args-vase=vase
  ^-  form:m
  =/  args  !<((unit arg-mold) arg)
  ?~  args
    ~&  >>>  "Usage:"
    ~&  >>>  "-zig!ziggurat-test-run test-steps:zig"
    (pure:m !>(~))
  =*  test-steps  test-steps.u.args
  ::
  ;<  =test-results:zig  bind:m  (run-steps test-steps)
  (pure:m !>(`test-results:zig`test-results))
--
