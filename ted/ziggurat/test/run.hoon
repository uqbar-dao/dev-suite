/-  pyro=zig-pyro,
    spider,
    zig=zig-ziggurat
/+  *strandio,
    pyro-lib=zig-pyro,
    zig-lib=zig-ziggurat
::
=*  strand     strand:spider
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
    %+  dojo:pyro-lib  who.payload
    (trip payload.payload)
    :: (noah-slap-ream:zig-lib 0 subject payload.payload)  ::  TODO: enable transforming of dojo arguments like scries & pokes are transformed
  (pure:m ~)
::
++  send-pyro-scry
  |=  payload=scry-payload:zig
  =/  m  (strand ,(each vase @t))
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
  ?.  ?=(^ scry-noun)
    %-  pure:m
    [%| (cat 3 'scry failed: ' (crip (noah !>(payload))))]
  =/  compilation-result
    %^  mule-slap-subject:zig-lib  0  subject
    mold-name.payload
  ?:  ?=(%| -.compilation-result)
    ~&  %ziggurat-test-run^%scry-compilation-fail^p.compilation-result
    %-  pure:m
    :-  %|
    (cat 3 'scry-compilation-fail\0a' p.compilation-result)
  =*  scry-mold  p.compilation-result
  (pure:m [%& (slym scry-mold +.scry-noun)])
::
::  +send-pyro-dbug differs from +send-pyro-scry in that
::   the return value of the %pyro scry is a vase.
::   must throw out the type information -- which has been
::   lost anyways when it is forced into being a noun by the
::   %pyro scry.
::   compare, e.g., the `+.+.dbug-noun` in the final `+slam`
::   in +send-pyro-dbug to the `+.scry-noun` in the final
::   `+slam` of `+send-pyro-scry`.
::
++  send-pyro-dbug
  |=  payload=dbug-payload:zig
  =/  m  (strand ,(each vase @t))
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
  ?.  ?=(^ dbug-noun)
    %-  pure:m
    [%| (cat 3 'dbug failed: ' (crip (noah !>(payload))))]
  =/  compilation-result
    %^  mule-slap-subject:zig-lib  0  subject
    mold-name.payload
  ?:  ?=(%| -.compilation-result)
    ~&  %ziggurat-test-run^%dbug-compilation-fail^p.compilation-result
    %-  pure:m
    :-  %|
    (cat 3 'dbug-compilation-fail\0a' p.compilation-result)
  =*  dbug-mold  p.compilation-result
  (pure:m [%& (slym dbug-mold +.+.dbug-noun)])
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
  ?:  (~(has in fact-set) expected)  (pure:m !>(expected))
  (pure:m !>((crip (noah !>(~(tap in fact-set))))))
::
++  send-pyro-subscription
  |=  payload=sub-payload:zig
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (subscribe:pyro-lib payload)
  (pure:m ~)
::
++  send-pyro-poke
  |=  payload=poke-payload:zig
  =/  m  (strand ,(each ~ @t))
  ^-  form:m
  ::  if %poke mark is not found it will fail
  ;<  =bowl:strand  bind:m  get-bowl
  |^
  ?:  is-mar-found
    ::  found mark: proceed
    =/  compilation-result
      %^  mule-slap-subject:zig-lib  0  subject
      payload.payload
    ?:  ?=(%| -.compilation-result)
      ~&  %ziggurat-test-run^%poke-compilation-fail^p.compilation-result
      %-  pure:m
      :-  %|
      (cat 3 'poke-compilation-fail\0a' p.compilation-result)
    ;<  ~  bind:m
      (poke:pyro-lib payload(payload +.p.compilation-result))
    (pure:m [%& ~])
  ::  mark not found: warn and attempt to fallback to
  ::   equivalent %dojo step rather than failing outright
  ~&  %ziggurat-test-run^%poke-mark-not-found^mark.payload
  ;<  ~  bind:m
    (send-pyro-dojo convert-poke-to-dojo-payload)
  (pure:m [%& ~])
  ::
  ++  is-mar-found
    ^-  ?
    =/  our=@ta  (scot %p our.bowl)
    =/  who=@ta  (scot %p who.payload)
    =/  now=@ta  (scot %da now.bowl)
    ?~  desk=(find-desk-running-app app.payload our who now)
      ~&  %ziggurat-test-run^%no-desk-running-app^app.payload
      %.n
    =/  mar-paths=(unit (list path))
      ;;  (unit (list path))
      .^  *
          %gx
          %+  weld  /[our]/pyro/[now]/i/[who]/ct
          /[who]/[u.desk]/[now]/mar/noun
      ==
    ?~  mar-paths
      ~&  %ziggurat-test-run^%poke-mark-not-found^mark.payload
      !!
    =/  mars=(set @tas)
      %-  ~(gas in *(set @tas))
      %+  murn  u.mar-paths
      |=  p=path
      ?~  p  ~
      [~ `@tas`(rap 3 (join '-' (snip t.p)))]
    (~(has in mars) mark.payload)
  ::
  ++  find-desk-running-app
    |=  [app=@tas our=@ta who=@ta now=@ta]
    ^-  (unit @tas)
    =/  desks-scry=(unit (set @tas))
      ;;  (unit (set @tas))
      .^  *
          %gx
          %+  weld  /[our]/pyro/[now]/i/[who]/cd/[who]/base
          /[now]/noun
      ==
    ?~  desks-scry  ~
    =/  desks=(list @tas)  ~(tap in u.desks-scry)
    |-
    ?~  desks  ~
    =*  desk  i.desks
    =/  apps=(unit (set [@tas ?]))
      ;;  (unit (set [@tas ?]))
      .^  *
          %gx
          %+  weld  /[our]/pyro/[now]/i/[who]/ge/[who]/[desk]
          /[now]/noun
      ==
    ?~  apps  $(desks t.desks)
    ?:  %.  app
        %~  has  in
        %-  ~(gas in *(set @tas))
        (turn ~(tap in u.apps) |=([a=@tas ?] a))
      `desk
    $(desks t.desks)
  ::
  ++  convert-poke-to-dojo-payload
    ^-  dojo-payload:zig
    =*  pp  payload
    :-  who.pp
    %+  rap  3
    :~  ':'
        ?:(=(who.pp to.pp) app.pp (rap 3 to.pp '|' app.pp ~))
        ' &'
        mark.pp
        ' '
        payload.pp
    ==
  --
::
++  take-snapshot
  |=  $:  project-id=@t
          test-id=(unit @ux)
          step=@ud
          snapshot-ships=(list @p)
      ==
  =/  m  (strand:spider ,~)
  ^-  form:m
  ?~  snapshot-ships  (pure:m ~)
  ;<  ~  bind:m
    %+  poke-our  %pyro
    :-  %pyro-action
    !>  ^-  action:pyro
    :+  %snap-ships
      ?~  test-id  /[project-id]/(scot %ud step)
      /[project-id]/(scot %ux u.test-id)/(scot %ud step)
    snapshot-ships
  (pure:m ~)
::
++  block-on-previous-step
  |=  done-duration=@dr
  =/  m  (strand:spider ,~)
  ^-  form:m
  |-
  ;<  soonest-timer=(unit @da)  bind:m
    (scry (unit @da) /gx/pyre/soonest-timer/noun)
  ;<  now=@da  bind:m  get-time
  ?~  soonest-timer                                  (pure:m)
  ?:  (lth (add now done-duration) u.soonest-timer)  (pure:m)
  ;<  ~  bind:m  (wait (add u.soonest-timer 1))  :: TODO: is this a good heuristic or should we wait longer?
  $
::
++  run-steps
  |=  $:  project-id=@t
          test-id=@ux
          =test-steps:zig
          snapshot-ships=(list @p)
      ==
  =/  m  (strand ,(each test-results:zig @t))
  ^-  form:m
  =|  =test-results:zig
  =|  step-number=@ud
  ::  first element of subject is test-results: null on first step
  =/  results-vase=vase  !>(~)
  =.  subject
    %-  slop  :_  subject
    results-vase(p [%face %test-results p.results-vase])
  |-
  ;<  ~  bind:m  (sleep ~s1)  :: TODO: unhardcode; tune time to allow previous step to continue processing
  ;<  ~  bind:m  (block-on-previous-step ~m1)
  ;<  ~  bind:m
    ?~  snapshot-ships  (pure:(strand ,~) ~)
    %:  take-snapshot
        project-id
        `test-id
        step-number
        snapshot-ships
    ==
  ?~  test-steps  (pure:m [%& (flop test-results)])
  =*  test-step   i.test-steps
  ;<  =bowl:strand  bind:m  get-bowl
  ?-    -.test-step
      %wait
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
    ;<  result-from-expected=(each test-results:zig @t)  bind:m
      %-  run-steps
      :^  project-id  test-id
      `test-steps:zig`expected.test-step  ~
    ?:  ?=(%| -.result-from-expected)  !!
    =*  trs  p.result-from-expected
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
    ;<  poke-result=(each ~ @t)  bind:m
      (send-pyro-poke payload.test-step)
    ?:  ?=(%| -.poke-result)  (pure:m [%| p.poke-result])
    ;<  result-from-expected=(each test-results:zig @t)  bind:m
      %-  run-steps
      :^  project-id  test-id
      `test-steps:zig`expected.test-step  ~
    ?:  ?=(%| -.result-from-expected)  !!
    =*  trs  p.result-from-expected
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
    ;<  scry-result=(each vase @t)  bind:m
      (send-pyro-scry payload.test-step)
    ?:  ?=(%| -.scry-result)  (pure:m [%| p.scry-result])
    =*  result    p.scry-result
    =*  expected  expected.test-step
    =/  res-text=@t  (crip (noah result))
    =.  test-results
      [[=(expected res-text) expected result]~ test-results]
    %=  $
        test-steps    t.test-steps
        step-number   +(step-number)
        subject
      (build-next-subject subject !>(test-results) bowl)
    ==
  ::
      %dbug
    ;<  dbug-result=(each vase @t)  bind:m
      (send-pyro-dbug payload.test-step)
    ?:  ?=(%| -.dbug-result)  (pure:m [%| p.dbug-result])
    =*  result    p.dbug-result
    =*  expected  expected.test-step
    =/  res-text=@t  (crip (noah result))
    =.  test-results
      [[=(expected res-text) expected result]~ test-results]
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
      [[=(expected res-text) expected result]~ test-results]
    ==
  ::
      %subscribe
    ;<  ~  bind:m  (send-pyro-subscription payload.test-step)
    ;<  result-from-expected=(each test-results:zig @t)  bind:m
      %-  run-steps
      :^  project-id  test-id
      `test-steps:zig`expected.test-step  ~
    ?:  ?=(%| -.result-from-expected)  !!
    =*  trs  p.result-from-expected
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
    =/  transformed-steps=test-steps:zig
      !<  test-steps:zig
      %+  slam  transform
      %-  slop  :_  !>(expected.test-step)
      (slap subject (ream payload.test-step))  ::  TODO: +mule?
    $(test-steps (weld transformed-steps t.test-steps))
  ::
      %custom-write
    ;<  transform=vase  bind:m
      %+  scry  vase
      %+  weld  /gx/ziggurat/custom-step-compiled/[project-id]
      /(scot %ux test-id)/[tag.test-step]/noun
    =/  transformed-steps=test-steps:zig
      !<  test-steps:zig
      %+  slam  transform
      %-  slop  :_  !>(expected.test-step)
      (slap subject (ream payload.test-step))  ::  TODO: +mule?
    $(test-steps (weld transformed-steps t.test-steps))
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
  ;<  result=(each test-results:zig @t)  bind:m
    (run-steps project-id test-id test-steps snapshot-ships)
  (pure:m !>(`(each test-results:zig @t)`result))
--
