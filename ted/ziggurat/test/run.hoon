/-  spider,
    zig=zig-ziggurat
/+  strandio,
    pyio=py-io
::
=*  strand  strand:spider
=*  poke-our  poke-our:strandio
=*  scry      scry:strandio
=*  sleep     sleep:strandio
::
=/  m  (strand ,vase)
|^  ted
::
+$  arg-mold  test-steps:zig
::
++  test-results-of-reads-to-test-result
  |=  trs=test-results:zig
  ^-  (unit test-result:zig)
  =|  tr=test-result:zig
  |-
  ?~  trs  `(flop tr)
  ?~  i.trs  $(trs t.trs)
  ?.  =(1 (lent i.trs))  ~
  $(trs t.trs, tr [i.i.trs tr])
::
++  send-pyro-dojo
  |=  payload=dojo-payload:zig
  =/  m  (strand ,~)
  ^-  form:m
  %+  dojo:pyio  who.payload
  (trip payload.payload)
::
++  send-pyro-scry
  |=  [payload=scry-payload:zig expected=@t]
  =/  m  (strand ,vase)
  ^-  form:m
  ;<  scry-noun=noun  bind:m
    %+  scry  noun
    [care.payload app.payload (snoc path.payload %noun)]
  =/  scry-molded  ;;(mold.payload scry-noun)
  ?~  scry-molded  (pure:m !>(`~`~))
  (pure:m !>(`mold.payload`scry-molded))
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
      (trip mark.payload)
      " "
      (trip payload.payload)
  ==
::
++  run-steps
  |=  =test-steps:zig
  =/  m  (strand ,test-results:zig)
  ^-  form:m
  =|  =test-results:zig
  |-
  ?~  test-steps  (pure:m (flop test-results))
  =*  test-step   i.test-steps
  ?-    -.test-step
      %wait
    ~&  %wait
    ~!  test-step
    ;<  ~  bind:m  (sleep until.test-step)
    ~&  %wait-done
    $(test-steps t.test-steps, test-results [~ test-results])
  ::
      %dojo
    ;<  ~  bind:m  (send-pyro-dojo payload.test-step)
    ;<  trs=test-results:zig  bind:m
      (run-steps `test-steps:zig`expected.test-step)
    ?~  tr=(test-results-of-reads-to-test-result trs)
      ~|("ziggurat-test-run: %dojo expected can only contain %scrys, %subscribes, %waits" !!)
    %=  $
        test-steps    t.test-steps
        test-results  [u.tr test-results]
    ==
  ::
      %poke
    ;<  ~  bind:m  (send-pyro-poke payload.test-step)
    ;<  trs=test-results:zig  bind:m
      (run-steps `test-steps:zig`expected.test-step)
    ?~  tr=(test-results-of-reads-to-test-result trs)
      ~|("ziggurat-test-run: %poke expected can only contain %scrys, %subscribes, %waits" !!)
    %=  $
        test-steps    t.test-steps
        test-results  [u.tr test-results]
    ==
  ::
      %scry  !!
    :: ;<  result=vase  bind:m
    ::   (send-pyro-scry payload.test-step)
    :: =*  expected  expected.test-step
    :: =/  res-text=@t  (noah result)
    :: %=  $
    ::     test-steps    t.test-steps
    ::     test-results
    ::   [[=(expected res-text) expected res-text]~ test-results]
    :: ==
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
  =/  args  !<((unit arg-mold) args-vase)
  ?~  args
    ~&  >>>  "Usage:"
    ~&  >>>  "-zig!ziggurat-test-run test-steps:zig"
    (pure:m !>(~))
  =*  test-steps  u.args
  ::
  ;<  ~  bind:m  start-simple:pyio
  ;<  ~  bind:m  (init-ship:pyio ~nec)
  ;<  ~  bind:m  (init-ship:pyio ~bud)
  ;<  ~  bind:m  (send-hi:pyio ~nec ~bud)
  ;<  =test-results:zig  bind:m  (run-steps test-steps)
  :: ;<  ~  bind:m  end:pyio
  (pure:m !>(`test-results:zig`test-results))
--
