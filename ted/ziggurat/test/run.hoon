/-  pyro=zig-pyro,
    spider,
    zig=zig-ziggurat
/+  strandio,
    pyro-lib=pyro-pyro,
    ziggurat-lib=zig-ziggurat
::
=*  strand     strand:spider
=*  get-bowl   get-bowl:strandio
=*  get-time   get-time:strandio
=*  poke-our   poke-our:strandio
=*  scry       scry:strandio
=*  sleep      sleep:strandio
=*  watch-our  watch-our:strandio
=*  wait       wait:strandio
::
=/  m  (strand ,vase)
=|  subject=vase
=|  =settings:zig
=*  zig-lib  ~(. ziggurat-lib *bowl:gall settings)
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
++  get-settings
  |=  =bowl:spider
  ^-  settings:zig
  =+  .^  =update:zig
          %gx
          :-  (scot %p our.bowl)
          /ziggurat/(scot %da now.bowl)/settings/noun
      ==
  ?.  ?&  ?=(^ update)
          ?=(%settings -.update)
          ?=(%& -.payload.update)
      ==
    *settings:zig
  p.payload.update
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
  |=  $:  old-subject=vase
          results=vase
          =bowl:strand
          result-face=(unit @tas)
          configs=(unit configs:zig)
      ==
  ^-  vase
  =+  !<  old=test-globals:zig
      (slap old-subject (ream 'test-globals'))
  =+  !<(=test-results:zig results)
  =/  test-globals=vase
    !>  ^-  test-globals:zig
    :*  our.bowl
        now.bowl
        test-results
        project.old
        ?^(configs u.configs configs.old)
    ==
  =/  base-subject=vase
    ?~  result-face   (slap old-subject (ream '+'))
    ?~  test-results  (slap old-subject (ream '+'))
    ?.  ?=([* ~] i.test-results)  ::  TODO: properly implement
      (slap old-subject (ream '+'))
    =*  result-vase  result.i.i.test-results
    %-  slop  :_  (slap old-subject (ream '+'))
    result-vase(p [%face u.result-face p.result-vase])
  %-  slop  :_  base-subject
  test-globals(p [%face %test-globals p.test-globals])
::
++  send-pyro-dojo
  |=  payload=dojo-payload:zig
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m
    %+  dojo:pyro-lib  who.payload
    (trip payload.payload)
  (pure:m ~)
::
++  send-pyro-scry
  |=  payload=scry-payload:zig
  =/  m  (strand ,(each vase @t))
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  =/  who=@ta  (scot %p who.payload)
  =/  now=@ta  (scot %da now.bowl)
  =/  path-compilation-result
    (mule-slap-subject:zig-lib subject (ream path.payload))
  ?:  ?=(%| -.path-compilation-result)
    %-  pure:m
    :-  %|
    %^  cat  3  'scry-path-compilation-fail\0a'
    p.path-compilation-result
  =/  scry-noun=*
    .^  *
        %gx
        ;:  weld
            /(scot %p our.bowl)/pyro/[now]/i/[who]
            /[care.payload]/[who]/[app.payload]/[now]
            !<(path p.path-compilation-result)
        ==
    ==
  =/  compilation-result
    %+  mule-slap-subject:zig-lib  subject
    (ream mold-name.payload)
  ?:  ?=(%| -.compilation-result)
    %-  pure:m
    :-  %|
    %^  cat  3  'scry-mold-compilation-fail\0a'
    p.compilation-result
  =*  scry-mold  p.compilation-result
  (pure:m [%& (slym scry-mold scry-noun)])
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
  =+  ;;(fact-set=(set @t) scry-noun)
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
      %+  mule-slap-subject:zig-lib  subject
      (ream payload.payload)
    ?:  ?=(%| -.compilation-result)
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
    =/  mar-paths=(list path)
      .^  (list path)
          %gx
          %+  weld  /[our]/pyro/[now]/i/[who]/ct
          /[who]/[u.desk]/[now]/mar/file-list
      ==
    =/  mars=(set @tas)
      %-  ~(gas in *(set @tas))
      %+  murn  mar-paths
      |=  p=path
      ?~  p  ~
      [~ `@tas`(rap 3 (join '-' (snip t.p)))]
    (~(has in mars) mark.payload)
  ::
  ++  find-desk-running-app
    |=  [app=@tas our=@ta who=@ta now=@ta]
    ^-  (unit @tas)
    =/  desks-scry=(set @tas)
      .^  (set @tas)
          %gx
          /[our]/pyro/[now]/i/[who]/cd/[who]/base/[now]/noun
      ==
    =/  desks=(list @tas)  ~(tap in desks-scry)
    |-
    ?~  desks  ~
    =*  desk  i.desks
    =/  apps=(set [@tas ?])
      .^  (set [@tas ?])
          %gx
          %+  weld  /[our]/pyro/[now]/i/[who]/ge/[who]/[desk]
          /[now]/apps
      ==
    ?:  %.  app
        %~  has  in
        %-  ~(gas in *(set @tas))
        (turn ~(tap in apps) |=([a=@tas ?] a))
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
  |=  [done-duration=@dr project-id=@t]
  =/  m  (strand:spider ,~)
  ^-  form:m
  ;<  ~  bind:m  (sleep `@dr`1)
  |-
  ;<  is-stack-empty=?  bind:m  get-is-stack-empty
  ?.  is-stack-empty
    ;<  ~  bind:m  (sleep (div ~s1 4))
    $
  ;<  =bowl:strand  bind:m  get-bowl
  =*  now  now.bowl
  =/  timers=(list [@da duct])
    (get-real-and-virtual-timers project-id [our now]:bowl)
  ?~  timers                                       (pure:m ~)
  =*  soonest-timer  -.i.timers
  ?:  (lth (add now done-duration) soonest-timer)  (pure:m ~)
  ;<  ~  bind:m  (wait +(soonest-timer))  :: TODO: is this a good heuristic or should we wait longer?
  :: ~&  [%ztr %block now `(list [@da duct])`timers]
  $
::
++  get-is-stack-empty
  =/  m  (strand:spider ,?)
  ^-  form:m
  ;<  maz=(list mass)  bind:m  (scry (list mass) /i//whey)  ::  sys/vane/iris/hoon:386
  =/  by-id  (snag 2 maz)
  ?^  p.q.by-id  (pure:m %.n)
  (pure:m %.y)
::
++  ignored-virtualship-timer-prefixes
  ^-  (list path)
  :_  ~
  /ames/pump
::
++  ignored-realship-timer-prefixes
  ^-  (list path)
  :~  /ames/pump
      /eyre/channel
      /eyre/sessions
      /gall/use/eth-watcher
      /gall/use/hark-system-hook
      /gall/use/hark
      /gall/use/notify
      /gall/use/ping
      /gall/use/pyre
  ==
::
++  filter-timers
  |=  $:  now=@da
          ignored-prefixes=(list path)
          timers=(list [@da duct])
      ==
  ^-  (list [@da duct])
  %+  murn  timers
  |=  [time=@da d=duct]
  ?~  d               `[time d]  ::  ?
  ?:  (gth now time)  ~
  =*  p  i.d
  %+  roll  ignored-prefixes
  |:  [ignored-prefix=`path`/ timer=`(unit [@da duct])``[time d]]
  ?:  =(ignored-prefix (scag (lent ignored-prefix) p))  ~
  timer
::
++  get-virtualship-timers
  |=  [project-id=@t our=@p now=@da]
  ^-  (list [@da duct])
  =/  now-ta=@ta  (scot %da now)
  =/  ships=(list @p)
    (get-virtualships-synced-for-project project-id our now)
  %+  roll  ships
  |=  [who=@p all-timers=(list [@da duct])]
  =/  who-ta=@ta  (scot %p who)
  =/  timers=(list [@da duct])
    .^  (list [@da duct])
        %gx
        %+  weld  /(scot %p our)/pyro/[now-ta]/i/[who-ta]
        /bx/[who-ta]//[now-ta]/debug/timers/noun
    ==
  (weld timers all-timers)
::
++  get-virtualships-synced-for-project
  |=  [project-id=@t our=@p now=@da]
  ^-  (list @p)
  =+  .^  =update:zig
          %gx
          :-  (scot %p our)
          /ziggurat/(scot %da now)/sync-desk-to-vship/noun
      ==
  ?~  update                            ~
  ?.  ?=(%sync-desk-to-vship -.update)  ~  ::  TODO: throw error?
  ?:  ?=(%| -.payload.update)           ~  ::  "
  =*  sync-desk-to-vship  p.payload.update
  ~(tap in (~(get ju sync-desk-to-vship) project-id))
::
++  get-realship-timers
  |=  [our=@p now=@da]
  ^-  (list [@da duct])
  .^  (list [@da duct])
      %bx
      /(scot %p our)//(scot %da now)/debug/timers
  ==
::
++  get-real-and-virtual-timers
  |=  [project-id=@t our=@p now=@da]
  ^-  (list [@da duct])
  %-  sort
  :_  |=([a=(pair @da duct) b=(pair @da duct)] (lth p.a p.b))
  %+  weld
    %^  filter-timers  now  ignored-realship-timer-prefixes
    (get-realship-timers our now)
  %^  filter-timers  now  ignored-virtualship-timer-prefixes
  (get-virtualship-timers project-id our now)
::
++  run-steps
  |=  $:  project-id=@t
          test-id=@ux
          =test-steps:zig
          snapshot-ships=(list @p)
      ==
  =/  m  (strand ,(each [test-results:zig configs:zig] @t))
  ^-  form:m
  =|  =test-results:zig
  =|  step-number=@ud
  |-
  ;<  ~  bind:m  (block-on-previous-step ~m1 project-id)  :: TODO: unhardcode; are these good numbers?
  ;<  ~  bind:m
    ?~  snapshot-ships  (pure:(strand ,~) ~)
    %:  take-snapshot
        project-id
        `test-id
        step-number
        snapshot-ships
    ==
  ?~  test-steps
    %-  pure:m
    :+  %&  (flop test-results)
    !<  configs:zig
    (slap subject (ream 'configs:test-globals'))
  =*  test-step   i.test-steps
  ;<  =bowl:strand  bind:m  get-bowl
  =.  settings  (get-settings bowl)
  ?-    -.test-step
      %wait
    ;<  ~  bind:m  (sleep until.test-step)
    =.  test-results  [~ test-results]
    %=  $
        test-steps    t.test-steps
        step-number   +(step-number)
        subject
      (build-next-subject subject !>(test-results) bowl ~ ~)
    ==
  ::
      %dojo
    ;<  ~  bind:m  (send-pyro-dojo payload.test-step)
    ;<  result-from-expected=(each (pair test-results:zig configs:zig) @t)
        bind:m
      %-  run-steps
      :^  project-id  test-id
      `test-steps:zig`expected.test-step  ~
    ?:  ?=(%| -.result-from-expected)
      (pure:m [%| p.result-from-expected])
    =*  trs  p.p.result-from-expected
    ?~  tr=(test-results-of-reads-to-test-result trs)
      %-  pure:m
      :-  %|
      '%dojo expected can only contain %scrys, %subscribes, %waits'
    =.  test-results  [u.tr test-results]
    %=  $
        test-steps    t.test-steps
        step-number   +(step-number)
        subject
      %-  build-next-subject
      :-  subject
      :^  !>(test-results)  bowl  result-face.test-step
      `q.p.result-from-expected
    ==
  ::
      %poke
    ;<  poke-result=(each ~ @t)  bind:m
      (send-pyro-poke payload.test-step)
    ?:  ?=(%| -.poke-result)  (pure:m [%| p.poke-result])
    ;<  result-from-expected=(each (pair test-results:zig configs:zig) @t)
        bind:m
      %-  run-steps
      :^  project-id  test-id
      `test-steps:zig`expected.test-step  ~
    ?:  ?=(%| -.result-from-expected)
      (pure:m [%| p.result-from-expected])
    =*  trs  p.p.result-from-expected
    ?~  tr=(test-results-of-reads-to-test-result trs)
      %-  pure:m
      :-  %|
      'ziggurat-test-run: %poke expected can only contain %scrys, %subscribes, %waits'
    =.  test-results  [u.tr test-results]
    %=  $
        test-steps    t.test-steps
        step-number   +(step-number)
        subject
      %-  build-next-subject
      :-  subject
      :^  !>(test-results)  bowl  result-face.test-step
      `q.p.result-from-expected
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
      %-  build-next-subject
      [subject !>(test-results) bowl result-face.test-step ~]
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
    ;<  result-from-expected=(each (pair test-results:zig configs:zig) @t)
        bind:m
      %-  run-steps
      :^  project-id  test-id
      `test-steps:zig`expected.test-step  ~
    ?:  ?=(%| -.result-from-expected)  !!
    =*  trs  p.p.result-from-expected
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
    =/  transform-error
      %-  mule  |.  !<(update:zig transform)
    ?:  ?=(%& -.transform-error)
      %-  pure:m
      :-  %|
      %^  cat  3  'custom-read retrieve transform failed\0a'
      ?.  ?&  ?=(%custom-step-compiled -.p.transform-error)
              ?=(%| -.payload.p.transform-error)
          ==
        'unknown error'
      message.p.payload.p.transform-error
    =/  compilation-result=(each vase @t)
      %+  mule-slap-subject:zig-lib  subject
      (ream payload.test-step)
    ?:  ?=(%| -.compilation-result)
      %-  pure:m
      :-  %|
      %^  cat  3  'custom-read-compilation-fail\0a'
      p.compilation-result
    =/  slam-result=(each vase @t)
      %+  mule-slam-transform:zig-lib  transform
      %-  slop  :_  !>(expected.test-step)
      p.compilation-result
    ?:  ?=(%| -.slam-result)
      %-  pure:m
      :-  %|
      %^  cat  3  'custom-read-slam-fail\0a'
      p.slam-result
    =/  [transformed-steps=test-steps:zig =configs:zig]
      !<([test-steps:zig configs:zig] p.slam-result)
    %=  $
        test-steps  (weld transformed-steps t.test-steps)
        subject
      %-  build-next-subject
      :*  subject
          (slap subject (ream 'test-results:test-globals'))
          bowl
          result-face.test-step
          `configs
      ==
    ==
  ::
      %custom-write
    ;<  transform=vase  bind:m
      %+  scry  vase
      %+  weld  /gx/ziggurat/custom-step-compiled/[project-id]
      /(scot %ux test-id)/[tag.test-step]/noun
    =/  transform-error
      %-  mule  |.  !<(update:zig transform)
    ?:  ?=(%& -.transform-error)
      %-  pure:m
      :-  %|
      %^  cat  3  'custom-write retrieve transform failed\0a'
      ?.  ?&  ?=(%custom-step-compiled -.p.transform-error)
              ?=(%| -.payload.p.transform-error)
          ==
        'unknown error'
      message.p.payload.p.transform-error
    =/  compilation-result=(each vase @t)
      %+  mule-slap-subject:zig-lib  subject
      (ream payload.test-step)
    ?:  ?=(%| -.compilation-result)
      %-  pure:m
      :-  %|
      %^  cat  3  'custom-write-compilation-fail\0a'
      p.compilation-result
    =/  slam-result=(each vase @t)
      %+  mule-slam-transform:zig-lib  transform
      %-  slop  :_  !>(expected.test-step)
      p.compilation-result
    ?:  ?=(%| -.slam-result)
      %-  pure:m
      :-  %|
      %^  cat  3  'custom-write-slam-fail\0a'
      p.slam-result
    =/  [transformed-steps=test-steps:zig =configs:zig]
      !<([test-steps:zig configs:zig] p.slam-result)
    %=  $
        test-steps  (weld transformed-steps t.test-steps)
        subject
      %-  build-next-subject
      :*  subject
          (slap subject (ream 'test-results:test-globals'))
          bowl
          result-face.test-step
          `configs
      ==
    ==
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
  =.  subject
    (build-next-subject subject.u.args !>(`~`~) bowl ~ ~)
  ::
  ;<  ~  bind:m  (watch-our /effect %pyro /effect)
  ;<  result=(each [test-results:zig configs:zig] @t)
      bind:m
    (run-steps project-id test-id test-steps snapshot-ships)
  %-  pure:m
  !>(`(each [test-results:zig configs:zig] @t)`result)
--
