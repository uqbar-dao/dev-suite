/-  spider,
    zig=zig-ziggurat
/+  strandio,
    pyio=py-io
::
=*  strand     strand:spider
=*  get-bowl   get-bowl:strandio
=*  scry       scry:strandio
=*  sleep      sleep:strandio
=*  watch-our  watch-our:strandio
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
  ;<  =bowl:strand  bind:m  get-bowl
  =/  who=@ta  (scot %p who.payload)
  =/  now=@ta  (scot %da now.bowl)
  =/  scry-noun=*
    .^  *
        %gx
        ;:  weld
            /(scot %p our.bowl)/pyro/[now]/i/[who]
            /[care.payload]/[who]/[app.payload]/[now]
            path.payload
            /noun
        ==
    ==
  ?.  ?=(^ scry-noun)  (pure:m !>(`~`~))
  ;<  scry-mold=vase  bind:m
    (build-scry-mold [mold-sur mold-name]:payload)
  (pure:m (slam scry-mold !>(+.scry-noun)))
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
++  build-scry-mold
  |=  [mold-sur-path=path mold-name=@t]
  =/  m  (strand ,vase)
  ^-  form:m
  ?~  mold-sur-path  (pure:m (slap !>(.) (ream mold-name)))
  ;<  mold-sur=vase  bind:m  (scry vase [%ca mold-sur-path])
  (pure:m (slap mold-sur (ream mold-name)))
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
      %scry
    ;<  result=vase  bind:m
      (send-pyro-scry [payload expected]:test-step)
    =*  expected  expected.test-step
    =/  res-text=@t  (crip (noah result))
    %=  $
        test-steps    t.test-steps
        test-results
      [[=(expected res-text) expected res-text]~ test-results]
    ==
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
  ;<  ~  bind:m  (watch-our /effect %pyro /effect)
  ;<  =test-results:zig  bind:m  (run-steps test-steps)
  (pure:m !>(`test-results:zig`test-results))
--
