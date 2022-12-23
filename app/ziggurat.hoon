::  ziggurat [UQ| DAO]
::
::  Contract Playground
::
/-  spider,
    zig=zig-ziggurat
/+  dbug,
    default-agent,
    verb,
    conq=zink-conq,
    dock=docket,
    engine=zig-sys-engine,
    pyro=zig-pyro,
    seq=zig-sequencer,
    smart=zig-sys-smart,
    ziggurat-lib=zig-ziggurat
/*  smart-lib-noun  %noun  /lib/zig/sys/smart-lib/noun
/*  zink-cax-noun   %noun  /lib/zig/sys/hash-cache/noun
::
|%
+$  card  card:agent:gall
--
::
=|  inflated-state-0:zig
=*  state  -
::
%-  agent:dbug
%+  verb  |
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def      ~(. (default-agent this %|) bowl)
    zig-lib  ~(. ziggurat-lib bowl)
::
++  on-init
  =/  smart-lib=vase  ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
  =/  =eng:zig
    %~  engine  engine:engine
    ::  sigs off, hints off
    [smart-lib ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun))) %.n %.n]
  =*  nec-address
    0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70
  =*  bud-address
    0xd6dc.c8ff.7ec5.4416.6d4e.b701.d1a6.8e97.b464.76de
  :-  ~
  %_    this
      state
    :_  [eng smart-lib ~]
    :*  %0
        ~
    ::
        %-  ~(gas by *(map @p address:smart))
        ~[[~nec nec-address] [~bud bud-address]]
    ::
        ~
        ~
        |
    ==
  ==
++  on-save  !>(-.state)
++  on-load
  |=  =old=vase
  ::  on-load: pre-cue our compiled smart contract library
  =/  smart-lib=vase  ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
  =/  =eng:zig
    %~  engine  engine:engine
    ::  sigs off, hints off
    [smart-lib ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun))) %.n %.n]
  `this(state [!<(state-0:zig old-vase) eng smart-lib ~])
::
++  on-watch
  |=  p=path
  ^-  (quip card _this)
  ?+    p  !!
      [%pyro-done ~]       `this
      [%test-updates @ ~]  `this
      [%project @ ~]
    ::  serve updates about state of a given project
    =/  name=@t  `@t`i.t.p
    ?~  proj=(~(get by projects) name)  `this
    :_  this
    (make-project-update:zig-lib name u.proj)^~
  ==
::
++  on-poke
  |=  [m=mark v=vase]
  ^-  (quip card _this)
  |^
  ::  TODO handle app project pokes in their own arm
  =^  cards  state
    ?+  m  (on-poke:def m v)
      %ziggurat-action  (handle-poke !<(action:zig v))
    ==
  [cards this]
  ::
  ++  add-test
    |=  [project-name=@tas name=(unit @t) p=path]
    ^-  [test:zig _state]
    ?~  p  !!  ::  TODO: do better
    =/  =project:zig  (~(got by projects) project-name)
    =/  file-scry-path=path
      :-  (scot %p our.bowl)
      (weld /[project-name]/(scot %da now.bowl) p)
    =/  [surs=(list [face=@tas =path]) =hoon]
      (parse-pile:conq (trip .^(@t %cx file-scry-path)))
    =^  subject=(each vase @t)  state
      (compile-test-surs `@tas`project-name surs)
    ?:  ?=(%| -.subject)  !!  ::  TODO: do better
    =+  !<  =test-steps:zig
        (slap (slap p.subject hoon) (ream '$'))
    =/  =test:zig
      :*  name
          p
          (~(gas by *test-surs:zig) surs)
          subject
          ~
          test-steps
          ~
      ==
    =.  test
      %-  fall  :_  test
      %-  add-custom-step:zig-lib
      :^  test  project-name  %scry-indexer
      /zig/custom-step-definitions/scry-indexer/hoon
    =.  test
      %-  fall  :_  test
      %-  add-custom-step:zig-lib
      :^  test  project-name  %poke-wallet-transaction
      /zig/custom-step-definitions/poke-wallet-transaction/hoon
    =.  test
      %-  fall  :_  test
      %-  add-custom-step:zig-lib
      :^  test  project-name  %send-wallet-transaction
      /zig/custom-step-definitions/send-wallet-transaction/hoon
    [test state]
  ::
  ++  add-and-queue-test
    |=  [project-name=@t name=(unit @t) test-steps-file=path]
    ^-  (quip card _state)
    =/  =project:zig  (~(got by projects) project-name)
    =^  =test:zig  state
      (add-test project-name name test-steps-file)
    =/  test-id=@ux  `@ux`(sham test)
    =.  tests.project  (~(put by tests.project) test-id test)
    :-  (make-project-update:zig-lib project-name project)^~
    %=  state
        projects
      (~(put by projects) project-name project)
    ::
        test-queue
      (~(put to test-queue) project-name test-id)
    ==
  ::
  ++  compile-test-surs
    |=  [project-desk=@tas surs=(list [face=@tas =path])]
    ^-  [(each vase @t) _state]
    =/  compilation-result
      %-  mule
      |.
      =/  initial-test-globals=vase
        !>  ^-  test-globals:zig
        :^  our.bowl  now.bowl  *test-results:zig
        [project-desk virtualnet-addresses]
      =/  [subject=vase c=ca-scry-cache:zig]
        %+  roll  surs
        |:  [[face=`@tas`%$ sur=`path`/] [subject=`vase`!>(..zuse) ca-scry-cache=ca-scry-cache]]
        ?:  =(%test-globals face)
          ~|("%ziggurat: compilation failed; cannot use %test-globals: reserved and built into subject already" !!)
        =^  sur-hoon=vase  ca-scry-cache
          %^  scry-or-cache-ca:zig-lib  project-desk
          (snoc sur %hoon)  ca-scry-cache
        :_  ca-scry-cache
        %-  slop  :_  subject
        sur-hoon(p [%face face p.sur-hoon])
      :_  c
      %+  slop
        %=  initial-test-globals
          p  [%face %test-globals p.initial-test-globals]
        ==
      subject
    ?:  ?=(%& -.compilation-result)
      :-  [%& -.p.compilation-result]
      state(ca-scry-cache +.p.compilation-result)
    :_  state
    :-  %|
    %-  crip
    %+  roll  p.compilation-result
    |=  [in=tank out=tape]
    :(weld ~(ram re in) "\0a" out)
  ::
  ++  handle-poke
    |=  act=action:zig
    ^-  (quip card _state)
    ?>  =(our.bowl src.bowl)
    ?-    -.+.act
        %new-project
      ?:  (~(has in (~(gas in *(set @t)) ~['fresh-piers' 'assembled'])) project.act)  ::  TODO: still necessary?
        ~|("%ziggurat: choose a different project name, {<project.act>} is reserved" !!)
      ~&  desk
      ~&  >  "scrying..."
      =/  desks=(set desk)
        .^  (set desk)
            %cd
            /(scot %p our.bowl)/[dap.bowl]/(scot %da now.bowl)
        ==
      ?:  (~(has in desks) project.act)
        ~|("%ziggurat: project desk already exists" !!)  ::  TODO: start project using this desk?
      ::  merge new desk, mount desk
      ::  currently using ziggurat desk as template -- should refine this
      =/  merge-task  [%merg `@tas`project.act our.bowl q.byk.bowl da+now.bowl %init]
      =/  mount-task  [%mont `@tas`project.act [our.bowl `@tas`project.act da+now.bowl] /]
      =/  bill-task   [%info `@tas`project.act %& [/desk/bill %ins %bill !>(~[project.act])]~]
      =/  deletions-task  [%info `@tas`project.act %& (clean-desk:zig-lib project.act)]
      :-  :~  [%pass /merge-wire %arvo %c merge-task]
              [%pass /mount-wire %arvo %c mount-task]
              [%pass /save-wire %arvo %c bill-task]
              [%pass /save-wire %arvo %c deletions-task]
              (make-read-desk:zig-lib project.act)
          ==
      %=  state
          projects
        %+  ~(put by projects)  project.act
        :*  dir=~  ::  populated by +make-read-desk / %read-desk
            user-files=(~(put in *(set path)) /app/[project.act]/hoon)
            to-compile=~
            errors=~
            town-sequencers=(~(put by *(map @ux @p)) 0x0 ~nec)
            tests=~
            dbug-dashboards=~
        ==
      ==
    ::
        %delete-project
      ::  should show a warning on frontend before performing this one ;)
      `state(projects (~(del by projects) project.act))
    ::
        %save-file
      =/  =project:zig  (~(got by projects) project.act)
      =.  user-files.project
        (~(put in user-files.project) file.act)
      :-  (make-save-file:zig-lib [project file text]:act)^~
      state(projects (~(put by projects) project.act project))
    ::
        %delete-file
      ::  should show warning
      =/  =project:zig  (~(got by projects) project.act)
      =:  user-files.project
        (~(del in user-files.project) file.act)
      ::
          to-compile.project
        (~(del in to-compile.project) file.act)
      ==
      :_  state(projects (~(put by projects) project.act project))
      :_  ~
      =-  [%pass /del-wire %arvo %c -]
      [%info `@tas`project.act %& [file.act %del ~]~]
    ::
        %set-virtualnet-address
      =/  =project:zig  (~(got by projects) project.act)
      =.  virtualnet-addresses
        (~(put by virtualnet-addresses) [who address]:act)
      ::  rebuild project custom-step-definitions
      :_  state
      %-  zing
      %+  turn  ~(tap by tests.project)
      |=  [test-id=@ux =test:zig]
      %^  make-recompile-custom-steps-cards:zig-lib
      project.act  test-id  custom-step-definitions.test
    ::
        %register-contract-for-compilation
      =/  =project:zig  (~(got by projects) project.act)
      ?:  (~(has in to-compile.project) file.act)  `state
      =:  user-files.project
        (~(put in user-files.project) file.act)
      ::
          to-compile.project
        (~(put in to-compile.project) file.act)
      ==
      :-  (make-compile-contracts:zig-lib project.act)^~
      state(projects (~(put by projects) project.act project))
    ::
        %deploy-contract
      =/  =project:zig  (~(got by projects) project.act)
      =/  who=@p
        (~(got by town-sequencers.project) town-id.act)
      =/  address=@ux  (~(got by virtualnet-addresses) who)
      =/  test-name=@tas  `@tas`(rap 3 %deploy path.act)
      =/  surs=(list [@tas path])
        :+  [%indexer /sur/zig/indexer]
          [%zig /sur/zig/ziggurat]
        ~
      =^  subject=(each vase @t)  state
        (compile-test-surs `@tas`project.act surs)
      ?>  ?=(%& -.subject)
      =/  =test:zig
        :*  `test-name
            ~
            (~(gas by *test-surs:zig) surs)
            subject
            ~
        ::
            :_  ~
            :^  %custom-write  %send-wallet-transaction
              %-  crip
              %-  noah
              !>  ^-  [@p test-write-step:zig]
              :-  who
              :^  %custom-write  %deploy-contract
              (crip "[{<who>} {<path.act>} ~]")  ~
            ~
        ::
            ~
        ==
      =.  test
        %-  fall  :_  test
        %-  add-custom-step:zig-lib
        :^  test  project.act  %deploy-contract
        /zig/custom-step-definitions/deploy-contract/hoon
      =.  test
        %-  fall  :_  test
        %-  add-custom-step:zig-lib
        :^  test  project.act  %send-wallet-transaction
        /zig/custom-step-definitions/send-wallet-transaction/hoon
      =/  test-id=@ux  `@ux`(sham test)
      =.  tests.project  (~(put by tests.project) test-id test)
      :-  :_  (make-run-queue:zig-lib project.act)^~
          (make-project-update:zig-lib project.act project)
      %=  state
          projects
        (~(put by projects) project.act project)
      ::
          test-queue
        (~(put to test-queue) project.act test-id)
      ==
    ::
        %compile-contracts
      ::  for internal use -- app calls itself to scry clay
      ?>  ?=(%ziggurat dap.bowl)
      =/  =project:zig  (~(got by projects) project.act)
      =/  build-results=(list (pair path build-result:zig))
        %^  build-contract-projects:zig-lib  smart-lib-vase
          /(scot %p our.bowl)/[project.act]/(scot %da now.bowl)
        to-compile.project
      ~&  "done building, got errors:"
      =/  [cards=(list card) errors=(list [path @t])]
        %+  save-compiled-contracts:zig-lib  project.act
        build-results
      ~&  errors
      =.  errors.project  (~(gas by errors.project) errors)
      :-  :_  cards
          (make-read-desk:zig-lib project.act)
      state(projects (~(put by projects) project.act project))
    ::
        %compile-contract
      ::  for internal use -- app calls itself to scry clay
      ?>  ?=(%ziggurat dap.bowl)
      =/  =project:zig  (~(got by projects) project.act)
      ?~  path.act  !!
      =/  =build-result:zig
        %^  build-contract-project:zig-lib  smart-lib-vase
          /(scot %p our.bowl)/[i.path.act]/(scot %da now.bowl)
        t.path.act
      ~&  "done building {<path>}, got errors:"
      =/  save-result=(each card [path @t])
        %^  save-compiled-contract:zig-lib  project.act
        t.path.act  build-result
      ?:  ?=(%| -.save-result)
        ~&  p.save-result
        =.  errors.project
          (~(put by errors.project) p.save-result)
        :-  :_  ~
            (make-project-update:zig-lib project.act project)
        %=  state
          projects  (~(put by projects) project.act project)
        ==
      [(make-read-desk:zig-lib project.act)^~ state]
    ::
        %read-desk
      ::  for internal use -- app calls itself to scry clay
      ?>  ?=(%ziggurat dap.bowl)
      =/  =project:zig  (~(got by projects) project.act)
      =.  dir.project
        =-  .^((list path) %ct -)
        /(scot %p our.bowl)/(scot %tas project.act)/(scot %da now.bowl)
      :-  :+  %+  make-project-update:zig-lib  project.act
              project
            %+  make-watch-for-file-changes:zig-lib
            project.act  dir.project
          ~
      state(projects (~(put by projects) project.act project))
    ::
        %add-test
      =/  =project:zig  (~(got by projects) project.act)
      =^  =test:zig  state
        (add-test [project name path]:act)
      =/  test-id=@ux  `@ux`(sham test)
      =.  tests.project  (~(put by tests.project) test-id test)
      :-  :_  ~
          (make-project-update:zig-lib project.act project)
      state(projects (~(put by projects) project.act project))
    ::
        %delete-test
      =/  =project:zig  (~(got by projects) project.act)
      =.  tests.project  (~(del by tests.project) id.act)
      :-  :_  ~
          (make-project-update:zig-lib project.act project)
      %=  state
        projects  (~(put by projects) project.act project)
      ==
    ::
        %run-test
      :_  state(test-queue (~(put to test-queue) [project id]:act))
      ?:  =(| test-running)
        (make-run-queue:zig-lib project.act)^~
      ~&  >  "%ziggurat: another test is running, adding to queue"  ~
    ::
        %add-and-run-test
      =^  cards  state
        (add-and-queue-test [project name path]:act)
      =?  cards  =(| test-running)
        %+  snoc  cards
        (make-run-queue:zig-lib project.act)
      [cards state]
    ::
        %run-queue
      ?:  =(~ pyro-ships-ready)
        ~|("%ziggurat: run %start-pyro-ships before running tests" !!)
      ?:  !(~(all by pyro-ships-ready) same)
        ~|("%ziggurat: %pyro ships aren't ready yet, wait" !!)
      ?:  =(~ test-queue)
        ~|("%ziggurat: no tests in the queue" !!)
      ?:  =(& test-running)
        ~|("%ziggurat: queue already running" !!)
      =^  top  test-queue  ~(get to test-queue)
      =*  project-name  -.top
      =*  test-id        +.top
      ~&  >  "%ziggurat: running {<test-id>}"
      =/  =project:zig  (~(got by projects) project-name)
      =/  =test:zig     (~(got by tests.project) test-id)
      ?:  ?=(%| -.subject.test)
        ~|("%ziggurat: test subject must compile before test can be run" !!)  ::  TODO: do better
      =/  tid=@ta
        %+  rap  3
        :~  'ted-'
            project-name
            '-'
            ?^(name.test u.name.test (scot %ux test-id))
            '-'
            (scot %uw (sham eny.bowl))
        ==
      =/  =start-args:spider
        :-  ~
        :^  `tid  byk.bowl(r da+now.bowl)
          %ziggurat-test-run
        !>  ^-  (unit [@t @ux test-steps:zig vase (list @p)])
        :*  ~
            project-name
            test-id
            steps.test
            p.subject.test
            ~[~nec ~bud]  :: TODO: remove hardcode and allow input of for-snapshot
        ==
      =/  w=wire  /test/[project-name]/(scot %ux test-id)/[tid]
      :_  state(test-running &)
      :+  :^  %pass  w  %agent
            [[our.bowl %spider] %watch /thread-result/[tid]]
        :^  %pass  w  %agent
        [[our.bowl %spider] %poke %spider-start !>(start-args)]
      ~
    ::
        %clear-queue
      `state(test-queue ~)
    ::
        %queue-test
      `state(test-queue (~(put to test-queue) [project.act id.act]))
    ::
        %add-and-queue-test
      (add-and-queue-test [project name path]:act)
    ::
        %add-custom-step
      =/  =project:zig  (~(got by projects) project.act)
      =/  =test:zig     (~(got by tests.project) test-id.act)
      =.  test
        %-  fall  :_  test
        (add-custom-step:zig-lib test [project tag path]:act)
      =.  project
        project(tests (~(put by tests.project) test-id.act test))
      :-  :_  ~
          (make-project-update:zig-lib project.act project)
      %=  state
        projects  (~(put by projects) project.act project)
      ==
    ::
        %delete-custom-step
      =/  =project:zig  (~(got by projects) project.act)
      =/  =test:zig     (~(got by tests.project) test-id.act)
      =.  custom-step-definitions.test
        (~(del by custom-step-definitions.test) tag.act)
      =.  project
        project(tests (~(put by tests.project) test-id.act test))
      :-  :_  ~
          (make-project-update:zig-lib project.act project)
      %=  state
        projects  (~(put by projects) project.act project)
      ==
    ::
        %add-app-to-dashboard
      =/  =project:zig  (~(got by projects) project.act)
      =*  sur  sur.act
      ::
      =/  dbug-mold-result
        %-  mule
        |.
        ::  make mold subject
        ?~  snipped=(snip sur)  !!  ::  TODO: do better
        =/  sur-face=@tas  `@tas`(rear snipped)
        ?>  ?=(^ sur)
        =^  sur-hoon=vase  ca-scry-cache
          %^  scry-or-cache-ca:zig-lib  project.act   sur
          ca-scry-cache
        =/  subject=vase
          %-  slop  :_  !>(..zuse)
          sur-hoon(p [%face sur-face p.sur-hoon])
        ::  make mold
        (slap subject (ream mold-name.act))
      =/  dbug-mold
        ?:  ?=(%& -.dbug-mold-result)  dbug-mold-result
        :-  %|
        %-  crip
        %+  roll  p.dbug-mold-result
        |=  [in=tank out=tape]
        :(weld ~(ram re in) "\0a" out)
      ::
      =/  mar-tube=(unit tube:clay)
        ?~  mar.act  ~
        =/  tube-res
          %-  mule
          |.
          .^  tube:clay
              %cc
              %+  weld  /(scot %p our.bowl)/[i.mar.act]/(scot %da now.bowl)
              t.mar.act
          ==
        ?:  ?=(%| -.tube-res)  ~
        `p.tube-res
      ::
      ~&  "%ziggurat: added {<app.act>} to dashboard with mold, mar: {<?=(%& -.dbug-mold)>} {<?=(^ mar-tube)>}"
      =.  dbug-dashboards.project
        %+  ~(put by dbug-dashboards.project)  app.act
        :*  sur
            mold-name.act
            mar.act
            dbug-mold
            mar-tube
        ==
      :-  :_  ~
          (make-project-update:zig-lib project.act project)
      %=  state
        projects  (~(put by projects) project.act project)
      ==
    ::
        %delete-app-from-dashboard
      =/  =project:zig  (~(got by projects) project.act)
      =.  dbug-dashboards.project
        (~(del by dbug-dashboards.project) app.act)
      :-  :_  ~
          (make-project-update:zig-lib project.act project)
      %=  state
        projects  (~(put by projects) project.act project)
      ==
    ::
        %stop-pyro-ships
      :_  state(pyro-ships-ready ~)
      :~  [%give %fact [/pyro-done]~ [%noun !>(`*`**)]]
          [%give %kick [/pyro-done]~ ~]
      ==
    ::
        %start-pyro-ships
      =?  ships.act  ?=(~ ships.act)  ~[~nec ~bud]
      =/  wach=(list card)
        %+  turn  ships.act
        |=  who=ship
        :*  %pass  /ready/(scot %p who)  %agent
            [our.bowl %pyro]
            %watch  /ready/(scot %p who)
        ==
      =/  init=(list card)
        :_  ~
        :*  %pass  /  %agent
            [our.bowl %pyro]
            %poke  %aqua-events
            !>((turn ships.act |=(who=ship [%init-ship who])))
        ==
      =/  subs=(list card) ::  start %subscriber app
        %+  turn  ships.act
        |=  who=ship
        :*  %pass  /  %agent
            [our.bowl %pyro]
            %poke  %aqua-events
            !>
            (dojo-events:pyro who "|start %zig %subscriber")
        ==
      :-  :(weld wach init subs)
      %_    state
          pyro-ships-ready
        %-  ~(gas by *(map ship ?))
        (turn ships.act |=(=ship [ship %.n]))
      ==
    ::
        %add-town-sequencer
      =/  =project:zig  (~(got by projects) project.act)
      =.  town-sequencers.project
        (~(put by town-sequencers.project) [town-id who]:act)
      :-  :_  ~
          (make-project-update:zig-lib project.act project)
      state(projects (~(put by projects) project.act project))
    ::
        %delete-town-sequencer
      =/  =project:zig  (~(got by projects) project.act)
      =.  town-sequencers.project
        (~(del by town-sequencers.project) town-id.act)
      :-  :_  ~
          (make-project-update:zig-lib project.act project)
      %=  state
        projects  (~(put by projects) project.act project)
      ==
    ::
        %start-pyro-snap
      :_  state(pyro-ships-ready ~)
      :~  [%pass /restore %agent [our.bowl %pyro] %watch /effect/restore]
          [%pass / %agent [our.bowl %pyro] %poke %action !>([%restore-snap snap.act])]
      ==
    ::
        %publish-app  :: TODO
      ::  [%publish-app title=@t info=@t color=@ux image=@t version=[@ud @ud @ud] website=@t license=@t]
      ::  should assert that desk.bill contains only our agent name,
      ::  and that clause has been filled out at least partially,
      ::  then poke treaty agent with publish
      =/  =project:zig  (~(got by projects) project.act)
      =/  bill
        ;;  (list @tas)
        .^(* %cx /(scot %p our.bowl)/(scot %tas project.act)/(scot %da now.bowl)/desk/bill)
      ~|  "desk.bill should only contain our agent"
      ?>  =(bill ~[project.act])
      =/  docket-0
        :*  %1
            'Foo'
            'An app that does a thing.'
            0xf9.8e40
            [%glob `@tas`project.act [0v0 [%ames our.bowl]]]
            `'https://example.com/tile.svg'
            [0 0 1]
            'https://example.com'
            'MIT'
        ==
      =/  docket-task
        [%info `@tas`project.act %& [/desk/docket-0 %ins %docket-0 !>(docket-0)]~]
      :_  state
      :^    [%pass /save-wire %arvo %c docket-task]
          (make-compile-contracts:zig-lib project.act)
        =-  [%pass /treaty-wire %agent [our.bowl %treaty] %poke -]
        [%alliance-update-0 !>([%add our.bowl `@tas`project.act])]
      ~
    ::
        %add-user-file
      =/  =project:zig  (~(got by projects) project.act)
      =.  user-files.project  (~(put in user-files.project) file.act)
      :-  :_  ~
          (make-project-update:zig-lib project.act project)
      state(projects (~(put by projects) project.act project))
    ::
        %delete-user-file
      =/  =project:zig  (~(got by projects) project.act)
      =.  user-files.project  (~(del in user-files.project) file.act)
      :-  :_  ~
          (make-project-update:zig-lib project.act project)
      %=  state
        projects  (~(put by projects) project.act project)
      ==
    ==
  --
::
++  on-agent
  |=  [w=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    w  (on-agent:def w sign)
      [%test @ @ @ ~]
    ?+    -.sign  (on-agent:def w sign)
        %kick      `this
        %poke-ack  `this
        %fact
      =*  project-name  i.t.w
      =/  test-id=@ux   (slav %ux i.t.t.w)
      =*  tid           i.t.t.t.w
      ?+    p.cage.sign  (on-agent:def w sign)
          %thread-fail
        ~&  ziggurat+thread-fail+project-name^test-id^tid
        `this(test-running |)
      ::
          %thread-done
        =+  !<(=test-results:zig q.cage.sign)
        =/  =project:zig  (~(got by projects) project-name)
        =/  =test:zig     (~(got by tests.project) test-id)
        ~&  >  "%ziggurat: test done {<test-id>}"
        ~&  >  (show-test-results:zig-lib test-results)
        =.  tests.project
          %+  ~(put by tests.project)  test-id
          test(results test-results)
        =/  cards=(list card)
          :_  ~
          (make-project-update:zig-lib project-name project)
        =?  cards  ?=(^ test-queue)
          %+  snoc  cards
          :^  %pass  /self-wire  %agent
          :^  [our dap]:bowl  %poke  %ziggurat-action
          !>(`action:zig`[project-name %run-queue ~])
        :-  cards
        %=  this
          projects  (~(put by projects) project-name project)
          test-running  |
        ==
      ==
    ==
  ::
      [%ready @ ~]
    ?+    -.sign  (on-agent:def w sign)
        %fact
      =/  who=@p  (slav %p i.t.w)
      =.  pyro-ships-ready  (~(put by pyro-ships-ready) who %.y)
      =/  leave=card
        :^  %pass  /ready/(scot %p who)  %agent
        [[our.bowl %pyro] %leave ~]
      ?~  test-queue                         [leave^~ this]
      ?.  (~(all by pyro-ships-ready) same)  [leave^~ this]
      :_  this
      :+  leave
        :^  %pass  /self-wire  %agent
        :^  [our dap]:bowl  %poke  %ziggurat-action
        !>(`action:zig`[%$ %run-queue ~])
      ~
    ==
  ::
      [%restore ~]
    ?+    -.sign  (on-agent:def w sign)
        %fact
      :_  this(pyro-ships-ready [[~nec %.y] ~ ~]) :: XX extremely hacky
      [%pass /restore %agent [our.bowl %pyro] %leave ~]^~
    ==
  ==
::
++  on-arvo
  |=  [w=wire =sign-arvo:agent:gall]
  ^-  (quip card _this)
  ?+    w  (on-arvo:def w sign-arvo)
      [%merge-wire ~]
    ?.  ?=(%clay -.sign-arvo)  !!
    ?.  ?=(%mere -.+.sign-arvo)  !!
    ?:  -.p.+.sign-arvo
      ~&  >  "new desk successful"
      `this
    ~&  >>>  "failed to make new desk"
    `this
  ::
      [%clay @ ~]
    ?>  ?=([%clay %wris *] sign-arvo)
    =*  project-name  i.t.w
    =/  =project:zig  (~(got by projects) project-name)
    =/  updated-files=(set path)
      %-  ~(gas in *(set path))
      (turn ~(tap in q.sign-arvo) |=([@ p=path] p))
    :_  this
    :_  ~
    ?:  .=  0
        %~  wyt  in
        (~(int in updated-files) to-compile.project)
      (make-read-desk:zig-lib project-name)
    (make-compile-contracts:zig-lib project-name)
  ==
::
++  on-peek
  |=  p=path
  ^-  (unit (unit cage))
  ?.  =(%x -.p)  ~
  =,  format
  ?+    +.p  (on-peek:def p)
  ::
  ::  NOUNS
  ::
    ::   [%project-nock @ ~]
    :: ?~  project=(~(get by projects) (slav %t i.t.t.p))
    ::   ``noun+!>(~)
    :: ?>  ?=(%& -.u.project)
    :: ?~  compiled.p.u.project
    ::   ``noun+!>(~)
    :: ``noun+!>(compiled.p.u.project)
  ::
    ::   [%custom-step-definitions @ @ ~]
    :: =/  =project  (~(got by projects) (slav %ux i.t.t.p))
    :: =/  =test  (~(got by tests.project) (slav %ux i.t.t.t.p))
    :: :^  ~  ~  %noun
    :: !>  ^-  custom-step-definitions:zig
    :: %-  ~(run by custom-step-definitions.test)
    :: |=  [p=custom-step-definition:zig q=custom-step-compiled:zig]
    :: :-  p
    :: ?:  ?=(%| -.q)  q  [%& *vase]
  ::
      [%custom-step-compiled @ @ @ ~]
    =/  =project:zig  (~(got by projects) i.t.t.p)
    =/  =test:zig
      (~(got by tests.project) (slav %ux i.t.t.t.p))
    =/  tag=@tas  `@tas`i.t.t.t.t.p
    ?~  def=(~(get by custom-step-definitions.test) tag)
      ~|("%ziggurat: did not find {<tag>} custom-step-definition in {<~(key by custom-step-definitions.test)>}" !!)
    ?:  ?=(%| -.q.u.def)  ::  TODO: do better
      ~|("%ziggurat: compilation of {<tag>} failed; please fix and try again. error message: {<p.q.u.def>}" !!)
    ``noun+!>(`vase`p.q.u.def)
  ::
      [%projects ~]
    :^  ~  ~  %noun
    !>  ^-  projects:zig
    %-  ~(run by projects)
    |=  =project:zig
    %=  project
        tests
      %-  ~(run by tests.project)
      |=  =test:zig
      %=  test
          subject
        ?:(?=(%& -.subject.test) [%& *vase] subject.test)
      ::
          custom-step-definitions
        %-  ~(run by custom-step-definitions.test)
        |=  [p=path q=custom-step-compiled:zig]
        [p ?:(?=(%& -.q) [%& *vase] q)]
      ==
    ==
  ::
  ::  JSONS
  ::
      [%all-projects ~]
    =;  =json  ``json+!>(json)
    %-  pairs:enjs:format
    %+  murn  ~(tap by projects)
    |=  [name=@t =project:zig]
    :-  ~  :-  name
    (project:enjs:zig-lib project)
  ::
      [%project-state @ ~]
    ?~  project=(~(get by projects) i.t.t.p)  ``json+!>(~)
    :^  ~  ~  %json
    !>  ^-  json
    (get-state:enjs:zig-lib u.project)
  ::
      [%project-tests @ ~]
    ?~  project=(~(get by projects) i.t.t.p)
      ``json+!>(~)
    ``json+!>((tests:enjs:zig-lib tests.u.project))
  ::
      [%project-user-files @ ~]
    ?~  project=(~(get by projects) i.t.t.p)
      ``json+!>(~)
    :^  ~  ~  %json
    !>  ^-  json
    %+  frond:enjs:format  %user-files
    (dir:enjs:zig-lib ~(tap in user-files.u.project))
  ::
      [%dashboard @ @ @ ~]
    =*  project-name  i.t.t.p
    =*  who           i.t.t.t.p
    =*  app           i.t.t.t.t.p
    :^  ~  ~  %json
    !>  ^-  json
    ?~  project=(~(get by projects) project-name)
      %+  single-string-object:enjs:zig-lib  %error
      "project {<project-name>} not found; must register project with %new-project"
    ?~  dbug=(~(get by dbug-dashboards.u.project) app)
      %+  single-string-object:enjs:zig-lib  %error
      "app {<app>} not found; must add app to dashboard with %add-app-to-dashboard"
    ?:  ?=(%| -.mold.u.dbug)
      %+  single-string-object:enjs:zig-lib  %error
      "app {<app>} subject failed to build; fix sur file path and re-add with %add-app-to-dashboard. error message from build: {<p.mold.u.dbug>}"
    =/  now=@ta  (scot %da now.bowl)
    =/  dbug-noun=*
      .^  *
          %gx
          %+  weld  /(scot %p our.bowl)/pyro/[now]/i/[who]
          /gx/[who]/[app]/[now]/dbug/state/noun/noun
      ==
    ?.  ?=(^ dbug-noun)
      %+  single-string-object:enjs:zig-lib  %error
      "dbug scry failed: unexpected result from pyro"
    =*  mar-tube   mar-tube.u.dbug
    =*  dbug-mold  p.mold.u.dbug
    =/  dbug-vase=vase  (slym dbug-mold +.+.dbug-noun)
    ?~  mar-tube
      %+  single-string-object:enjs:zig-lib  %state
      (noah dbug-vase)
    (frond:enjs:format %state !<(json (u.mar-tube dbug-vase)))
  ::
      [%file-exists @ ^]
    =/  des=@ta    i.t.t.p
    =/  pat=path  `path`t.t.t.p
    =/  pre=path  /(scot %p our.bowl)/(scot %tas des)/(scot %da now.bowl)
    ``json+!>(`json`[%b .^(? %cu (weld pre pat))])
  ::
  ::  APP-PROJECT JSON
  ::
      [%read-file @ ^]
    =/  des=@ta    i.t.t.p
    =/  pat=path  `path`t.t.t.p
    =/  pre  /(scot %p our.bowl)/(scot %tas des)/(scot %da now.bowl)
    =/  padh  (weld pre pat)
    =/  =mark  (rear pat)
    :^  ~  ~  %json  !>
    ^-  json
    :-  %s
    ?+    mark  =-  q.q.-
        !<(mime (.^(tube:clay %cc (weld pre /[mark]/mime)) .^(vase %cr padh)))
      %hoon    .^(@t %cx padh)
      %kelvin  (crip ~(ram re (cain !>(.^([@tas @ud] %cx padh)))))
      %ship    (crip ~(ram re (cain !>(.^(@p %cx padh)))))
      %bill    (crip ~(ram re (cain !>(.^((list @tas) %cx padh)))))
        %docket-0
      =-  (crip (spit-docket:mime:dock -))
      .^(docket:dock %cx padh)
    ==
  ==
::
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--
