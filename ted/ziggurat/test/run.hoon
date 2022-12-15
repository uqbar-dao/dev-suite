/-  spider,
    zig=zig-ziggurat
/+  strandio,
    pyro=zig-pyro,
    test=zig-ziggurat-test
::
=*  strand     strand:spider
=*  get-bowl   get-bowl:strandio
=*  scry       scry:strandio
=*  sleep      sleep:strandio
=*  watch-our  watch-our:strandio
::
=/  m  (strand ,vase)
=|  subject=vase
|^  ted
::
+$  arg-mold
  $:  project-id=@t
      test-id=@ux
      =test-steps:zig
      subject=vase
      snapshot-ships=(list @p)
  ==
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
++  slap-subject
  |=  payload=@t
  ^-  vase
  (slap subject (ream payload))
::
++  noah-slap-ream
  |=  payload=@t
  ^-  tape
  =/  compilation-result
    (mule |.((slap-subject payload)))
  ?:  ?=(%| -.compilation-result)
    (trip payload)
  (noah p.compilation-result)
::
++  build-next-subject
  |=  [old-subject=vase results=vase =bowl:strand]
  ^-  vase
  =+  !<  old=test-globals:zig
      (slap old-subject (ream 'test-globals'))
  =/  test-globals=vase
    !>  ^-  test-globals:zig
    :^  our.bowl  now.bowl  !<(test-results:zig results)
    [project addresses]:old
  %-  slop  :_  (slap old-subject (ream '+'))
  test-globals(p [%face %test-globals p.test-globals])
::
++  send-pyro-dojo
  |=  payload=dojo-payload:zig
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m
    %+  dojo:pyro  who.payload
    (trip payload.payload)
    :: (noah-slap-ream payload.payload)  ::  TODO: enable transforming of dojo arguments like scries & pokes are transformed
  (pure:m ~)
::
++  send-pyro-scry
  |=  payload=scry-payload:zig
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
  =/  scry-mold=vase  (slap-subject mold-name.payload)
  (pure:m (slym scry-mold +.scry-noun))
::
::  +send-pyro-dbug differs from +send-pyro-scry in that
::   the return value of +send-pyro-dbug is a vase.
::   must throw out the type information -- which has been
::   lost anyways when it is forced into being a noun by the
::   %pyro scry.
::   compare, e.g., the `+.+.dbug-noun` in the final `+slam`
::   in +send-pyro-dbug to the `+.scry-noun` in the final
::   `+slam` of `+send-pyro-scry`.
::
++  send-pyro-dbug
  |=  payload=dbug-payload:zig
  =/  m  (strand ,vase)
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  =/  who=@ta  (scot %p who.payload)
  =/  now=@ta  (scot %da now.bowl)
  =/  dbug-noun=*
    .^  *
        %gx
        %+  weld  /(scot %p our.bowl)/pyro/[now]/i/[who]/gx
        /[who]/[app.payload]/[now]/dbug/state/noun/noun
    ==
  ?.  ?=(^ dbug-noun)  (pure:m !>(`~`~))
  =/  dbug-mold=vase  (slap-subject mold-name.payload)
  (pure:m (slym dbug-mold +.+.dbug-noun))
::
++  read-pyro-subscription
  |=  [payload=read-sub-payload:zig expected=@t]
  =/  m  (strand ,vase)
  ;<  =bowl:strand  bind:m  get-bowl
  =/  now=@ta  (scot %da now.bowl)
  =/  scry-noun=*
    .^  *
        %gx
        ;:  weld
          /(scot %p our.bowl)/pyro/[now]/i/(scot %p who.payload)/gx
          /(scot %p who.payload)/subscriber/[now]
          /facts/(scot %p to.payload)/[app.payload]
          path.payload
          /noun
        ==
    ==
  ?.  ?=(^ scry-noun)  (pure:m !>(~))
  =+  fact-set=(fall ;;((unit (set @t)) scry-noun) *(set @t))
  ?:  (~(has in fact-set) expected)
    (pure:m !>(expected))
  (pure:m !>((crip (noah !>(~(tap in fact-set))))))
::
++  send-pyro-subscription
  |=  payload=sub-payload:zig
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (subscribe:pyro payload)
  (pure:m ~)
::
++  send-pyro-poke
  |=  payload=poke-payload:zig
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (poke:pyro payload)
  (pure:m ~)
::
++  run-steps
  |=  $:  project-id=@t
          test-id=@ux
          =test-steps:zig
          snapshot-ships=(list @p)
      ==
  =/  m  (strand ,test-results:zig)
  ^-  form:m
  =|  =test-results:zig
  =|  step-number=@ud
  ::  first element of subject is test-results: null on first step
  =/  results-vase=vase  !>(~)
  =.  subject
    %-  slop  :_  subject
    results-vase(p [%face %test-results p.results-vase])
  |-
  ;<  ~  bind:m
    ?~(snapshot-ships (pure:(strand ,~) ~) (sleep ~s1))  :: TODO: unhardcode; tune time to allow previous step to continue processing
  ;<  ~  bind:m
    ?~  snapshot-ships  (pure:(strand ,~) ~)
    (block-on-previous-step:test ~s1 ~m1)  :: TODO: unhardcode; are these good numbers?
  ;<  ~  bind:m
    ?~  snapshot-ships  (pure:(strand ,~) ~)
    %:  take-snapshot:test
        project-id
        `test-id
        step-number
        snapshot-ships
    ==
  ?~  test-steps  (pure:m (flop test-results))
  =*  test-step   i.test-steps
  ;<  =bowl:strand  bind:m  get-bowl
  ?-    -.test-step
      %wait
    ~!  test-step
    ;<  ~  bind:m  (sleep until.test-step)
    =.  test-results  [~ test-results]
    %=  $
        test-steps    t.test-steps
        step-number   +(step-number)
        subject
      (build-next-subject subject !>(test-results) bowl)
    ==
  ::
      %dojo
    ;<  ~  bind:m  (send-pyro-dojo payload.test-step)
    ;<  trs=test-results:zig  bind:m
      %-  run-steps
      :^  project-id  test-id
      `test-steps:zig`expected.test-step  ~
    ?~  tr=(test-results-of-reads-to-test-result trs)
      ~|("ziggurat-test-run: %dojo expected can only contain %scrys, %subscribes, %waits" !!)
    =.  test-results  [u.tr test-results]
    %=  $
        test-steps    t.test-steps
        step-number   +(step-number)
        subject
      (build-next-subject subject !>(test-results) bowl)
    ==
  ::
      %poke
    ;<  ~  bind:m  (send-pyro-poke payload.test-step)
    ;<  trs=test-results:zig  bind:m
      %-  run-steps
      :^  project-id  test-id
      `test-steps:zig`expected.test-step  ~
    ?~  tr=(test-results-of-reads-to-test-result trs)
      ~|("ziggurat-test-run: %poke expected can only contain %scrys, %subscribes, %waits" !!)
    =.  test-results  [u.tr test-results]
    %=  $
        test-steps    t.test-steps
        step-number   +(step-number)
        subject
      (build-next-subject subject !>(test-results) bowl)
    ==
  ::
      %scry
    ;<  result=vase  bind:m
      (send-pyro-scry payload.test-step)
    =*  expected  expected.test-step
    =/  res-text=@t  (crip (noah result))
    =.  test-results
      [[=(expected res-text) expected res-text]~ test-results]
    %=  $
        test-steps    t.test-steps
        step-number   +(step-number)
        subject
      (build-next-subject subject !>(test-results) bowl)
    ==
  ::
      %dbug
    ;<  result=vase  bind:m
      (send-pyro-dbug payload.test-step)
    =*  expected  expected.test-step
    =/  res-text=@t  (crip (noah result))
    =.  test-results
      [[=(expected res-text) expected res-text]~ test-results]
    %=  $
        test-steps    t.test-steps
        step-number   +(step-number)
        subject
      (build-next-subject subject !>(test-results) bowl)
    ==
  ::
        %read-subscription
    ;<  result=vase  bind:m
      (read-pyro-subscription [payload expected]:test-step)
    =*  expected  expected.test-step
    =/  res-text=@t  !<(@t result)
    %=    $
        test-steps    t.test-steps
        step-number   +(step-number)
        test-results
      [[=(expected res-text) expected res-text]~ test-results]
    ==
  ::
      %subscribe
    ;<  ~  bind:m  (send-pyro-subscription payload.test-step)
    ;<  trs=test-results:zig  bind:m
      %:  run-steps
          project-id  test-id
          `test-steps:zig`expected.test-step  ~
      ==
    ?~  tr=(test-results-of-reads-to-test-result trs)
      ~|("ziggurat-test-run: %subscribe expected can only contain %scrys, %subscribes, %waits" !!)
    %=  $
        test-steps    t.test-steps
        step-number   +(step-number)
        test-results  [u.tr test-results]
    ==
  ::
      %custom-read
    ;<  transform=vase  bind:m
      %+  scry  vase
      %+  weld  /gx/ziggurat/custom-step-compiled/[project-id]
      /(scot %ux test-id)/[tag.test-step]/noun
    =/  transformed-step=test-read-step:zig
      !<  test-read-step:zig
      %+  slam  transform
      %-  slop  :_  !>(expected.test-step)
      (slap-subject payload.test-step)
    $(test-steps [transformed-step t.test-steps])
  ::
      %custom-write
    ;<  transform=vase  bind:m
      %+  scry  vase
      %+  weld  /gx/ziggurat/custom-step-compiled/[project-id]
      /(scot %ux test-id)/[tag.test-step]/noun
    =/  transformed-step=test-write-step:zig
      !<  test-write-step:zig
      %+  slam  transform
      %-  slop  :_  !>(expected.test-step)
      (slap-subject payload.test-step)
    ::  execute code given as @t, e.g., transform
    ::   `:*  %foo  %bar  ==`
    ::   to
    ::   `[%foo %bar]`
    ::   TODO: consolidate logic
    =?    transformed-step
        ?=(%dojo -.transformed-step)
      %=  transformed-step
          payload.payload
        %-  crip
        %-  noah
        (slap-subject payload.payload.transformed-step)
      ==
    =?    transformed-step
        ?=(%poke -.transformed-step)
      %=  transformed-step
          payload.payload
        %-  crip
        %-  noah
        (slap-subject payload.payload.transformed-step)
      ==
    $(test-steps [transformed-step t.test-steps])
  ==
::
++  ted
  ^-  thread:spider
  |=  args-vase=vase
  ^-  form:m
  =/  args  !<((unit arg-mold) args-vase)
  ?~  args
    ~&  >>>  "Usage:"
    ~&  >>>  "-zig!ziggurat-test-run project-id=@t test-id=@ux test-steps:zig subject=vase (list @p)"
    ~&  >>>  "producing snapshots if second argument is non-null"
    (pure:m !>(~))
  =*  project-id      project-id.u.args
  =*  test-id         test-id.u.args
  =*  test-steps      test-steps.u.args
  =*  snapshot-ships  snapshot-ships.u.args
  ;<  =bowl:strand  bind:m  get-bowl
  =.  subject  (build-next-subject subject.u.args !>(`~`~) bowl)
  ::
  ;<  ~  bind:m  (watch-our /effect %pyro /effect)
  ;<  =test-results:zig  bind:m
    (run-steps project-id test-id test-steps snapshot-ships)
  (pure:m !>(`test-results:zig`test-results))
--
