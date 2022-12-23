::  ziggurat [UQ| DAO]
::
::  Contract Playground
::
/-  spider
/+  dbug,
    default-agent,
    verb,
    *zig-ziggurat,
    conq=zink-conq,
    engine=zig-sys-engine,
    pyro=zig-pyro,
    seq=zig-sequencer,
    smart=zig-sys-smart
/*  smart-lib-noun  %noun  /lib/zig/sys/smart-lib/noun
/*  zink-cax-noun   %noun  /lib/zig/sys/hash-cache/noun
::
=|  inflated-state-0
=*  state  -
::
%-  agent:dbug
%+  verb  |
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
::
++  on-init
  =/  smart-lib=vase  ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
  =/  eng
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
  =/  eng
    %~  engine  engine:engine
    ::  sigs off, hints off
    [smart-lib ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun))) %.n %.n]
  `this(state [!<(state-0 old-vase) eng smart-lib ~])
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  !!
      [%pyro-done ~]  `this
      [%test-updates @ ~]  `this
      [%project @ ~]
    ::  serve updates about state of a given project
    =/  name=@t  `@t`i.t.path
    ?~  proj=(~(get by projects) name)
      `this
    [(make-project-update name u.proj [our now]:bowl)^~ this]
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^
  ::  TODO handle app project pokes in their own arm
  =^  cards  state
    ?+  mark  !!
      %ziggurat-action  (handle-poke !<(action vase))
    ==
  [cards this]
  ::
  ++  compile-custom-step
    |=  [tag=@tas =hoon subject=(each ^vase @t)]
    ^-  (each ^vase @t)
    ?:  ?=(%| -.subject)
      ~|("%ziggurat: subject must compile from surs before adding custom step" !!)
    =/  compilation-result
      %-  mule
      |.  (slap (slap p.subject hoon) (ream '$'))
    ?:  ?=(%& -.compilation-result)  compilation-result
    :-  %|
    %-  crip
    %+  roll  p.compilation-result
    |=  [in=tank out=tape]
    :(weld ~(ram re in) "\0a" out)
  ::
  ++  make-recompile-custom-steps-cards
    |=  [project-name=@t test-id=@ux =custom-step-definitions]
    ^-  (list card)
    %+  turn  ~(tap by custom-step-definitions)
    |=  [tag=@tas [p=path *]]
    :^  %pass  /self-wire  %agent
    :^  [our dap]:bowl  %poke  %ziggurat-action
    !>  ^-  action
    project-name^[%add-custom-step test-id tag p]
  ::
  ++  add-custom-step
    |=  [=test project-name=@tas tag=@tas p=path]
    ^-  (unit ^test)
    =/  file-scry-path=path
      :-  (scot %p our.bowl)
      (weld /[project-name]/(scot %da now.bowl) p)
    ?.  .^(? %cu file-scry-path)  ~
    =/  [surs=(list [face=@tas =path]) =hoon]
      (parse-pile:conq (trip .^(@t %cx file-scry-path)))
    =/  compilation-result=(each ^vase @t)
      (compile-custom-step tag hoon subject.test)
    =.  custom-step-definitions.test
      %+  ~(put by custom-step-definitions.test)  tag
      [p compilation-result]
    ~?  ?=(%| -.compilation-result)
      %ziggurat^%custom-step-compilation-failed^p.compilation-result
    `test
  ::
  ++  add-test
    |=  $:  project-name=@t
            name=(unit @t)
            surs=test-surs
            =test-steps
        ==
    ^-  [[(list card) test] _state]
    =/  =project  (~(got by projects) project-name)
    =/  addresses=^vase  !>(virtualnet-addresses)
    =.  surs
      ?~  zig-val=(~(get by surs) %zig)
        (~(put by surs) %zig /sur/zig/ziggurat)
      ?:  =(/sur/zig/ziggurat u.zig-val)  surs
      ~|("%ziggurat: %zig face reserved for /sur/zig/ziggurat; got {<u.zig-val>}" !!)
    ?.  =(1 (lent (fand ~[/sur/zig/ziggurat] ~(val by surs))))
      ~|("%ziggurat: please use only %zig face for /sur/zig/ziggurat; got {<surs>}" !!)
    =^  subject=(each ^vase @t)  state
      (compile-test-surs `@tas`project-name ~(tap by surs))
    =/  =test
      :*  name
          /
          surs
          subject
          ~
          test-steps
          ~
      ==
    =.  test
      %-  fall  :_  test
      %-  add-custom-step
      :^  test  project-name  %scry-indexer
      /zig/custom-step-definitions/scry-indexer/hoon
    =.  test
      %-  fall  :_  test
      %-  add-custom-step
      :^  test  project-name  %poke-wallet-transaction
      /zig/custom-step-definitions/poke-wallet-transaction/hoon
    :_  state
    :_  test
    :_  ~
    %^  make-project-update  project-name  project
    [our now]:bowl
  ::
  ++  add-and-queue-test
    |=  [project-name=@t name=(unit @t) =test-surs =test-steps]
    ^-  (quip card _state)
    =/  =project  (~(got by projects) project-name)
    =^  [cards=(list card) =test]  state
        (add-test project-name name test-surs test-steps)
    =/  test-id=@ux  `@ux`(sham test)
    =.  tests.project  (~(put by tests.project) test-id test)
    :-  cards
    %=  state
        projects
      (~(put by projects) project-name project)
    ::
        test-queue
      (~(put to test-queue) project-name test-id)
    ==
  ::
  ++  add-test-file
    |=  [project-name=@tas name=(unit @t) p=path]
    ^-  [test _state]
    ?~  p  !!  ::  TODO: do better
    =/  =project  (~(got by projects) project-name)
    =/  file-scry-path=path
      :-  (scot %p our.bowl)
      (weld /[project-name]/(scot %da now.bowl) p)
    =/  [surs=(list [face=@tas =path]) =hoon]
      (parse-pile:conq (trip .^(@t %cx file-scry-path)))
    =^  subject=(each ^vase @t)  state
      (compile-test-surs `@tas`project-name surs)
    ?:  ?=(%| -.subject)  !!  ::  TODO: do better
    =+  !<  =test-steps
        (slap (slap p.subject hoon) (ream '$'))
    =/  =test
      :*  name
          p
          (~(gas by *test-surs) surs)
          subject
          ~
          test-steps
          ~
      ==
    =.  test
      %-  fall  :_  test
      %-  add-custom-step
      :^  test  project-name  %scry-indexer
      /zig/custom-step-definitions/scry-indexer/hoon
    =.  test
      %-  fall  :_  test
      %-  add-custom-step
      :^  test  project-name  %poke-wallet-transaction
      /zig/custom-step-definitions/poke-wallet-transaction/hoon
    [test state]
  ::
  ++  add-and-queue-test-file
    |=  [project-name=@t name=(unit @t) test-steps-file=path]
    ^-  (quip card _state)
    =/  =project  (~(got by projects) project-name)
    =^  =test  state
      (add-test-file project-name name test-steps-file)
    =/  test-id=@ux  `@ux`(sham test)
    =.  tests.project  (~(put by tests.project) test-id test)
    :-  :_  ~
        %^  make-project-update  project-name  project
        [our now]:bowl
    %=  state
        projects
      (~(put by projects) project-name project)
    ::
        test-queue
      (~(put to test-queue) project-name test-id)
    ==
  ::  scry %ca or fetch from local cache
  ::
  ++  scry-or-cache-ca
    |=  [project-desk=@tas p=path ca-scry-cache=_ca-scry-cache]
    |^  ^-  [^vase _ca-scry-cache]
    =/  scry-path=path
      :-  (scot %p our.bowl)
      (weld /[project-desk]/(scot %da now.bowl) p)
    ?~  cache=(~(get by ca-scry-cache) [project-desk p])
      scry-and-cache-ca
    ?.  =(p.u.cache .^(@ %cz scry-path))
      scry-and-cache-ca
    [q.u.cache ca-scry-cache]
    ::
    ++  scry-and-cache-ca
      ^-  [^vase _ca-scry-cache]
      =/  scry-path=path
        :-  (scot %p our.bowl)
        (weld /[project-desk]/(scot %da now.bowl) p)
      =/  v=^vase  .^(^vase %ca scry-path)
      :-  v
      %+  ~(put by ca-scry-cache)  [project-desk p]
      [`@ux`.^(@ %cz scry-path) v]
    --
  ::
  ++  compile-test-surs
    |=  [project-desk=@tas surs=(list [face=@tas =path])]
    ^-  [(each ^vase @t) _state]
    =/  compilation-result
      %-  mule
      |.
      =/  initial-test-globals=^vase
        !>  ^-  test-globals
        :^  our.bowl  now.bowl  *test-results
        [project-desk virtualnet-addresses]
      =/  [subject=^vase c=_ca-scry-cache]
        %+  roll  surs
        |:  [[face=`@tas`%$ sur=`path`/] [subject=`^vase`!>(..zuse) ca-scry-cache=ca-scry-cache]]
        ?:  =(%test-globals face)
          ~|("%ziggurat: compilation failed; cannot use %test-globals: reserved and built into subject already" !!)
        =^  sur-hoon=^vase  ca-scry-cache
          %^  scry-or-cache-ca  project-desk  (snoc sur %hoon)
          ca-scry-cache
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
    |=  act=action
    ^-  (quip card _state)
    ?>  =(our.bowl src.bowl)
    ?-    -.+.act
        %new-project
      ?:  (~(has in (~(gas in *(set @t)) ~['fresh-piers' 'assembled'])) project.act)
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
      =/  deletions-task  [%info `@tas`project.act %& (clean-desk project.act)]
      :-  :~  [%pass /merge-wire %arvo %c merge-task]
              [%pass /mount-wire %arvo %c mount-task]
              [%pass /save-wire %arvo %c bill-task]
              [%pass /save-wire %arvo %c deletions-task]
              (make-read-desk project.act our.bowl)
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
        %populate-template
      !!  ::  TODO
      :: ::  spawn some hardcoded example tests and grains for %fungible and %nft templates
      :: =/  =project  (~(got by projects) project.act)
      :: ?<  ?=(%blank template.act)
      :: =.  project
      ::   ?:  ?=(%fungible template.act)
      ::     (fungible-template-project project metadata.act smart-lib-vase)
      ::   (nft-template-project project metadata.act smart-lib-vase)
      :: :-  (make-compile-contracts project.act our.bowl)^~
      :: state(projects (~(put by projects) project.act project))
    ::
        %delete-project
      ::  should show a warning on frontend before performing this one ;)
      `state(projects (~(del by projects) project.act))
    ::
        %save-file
      =/  =project  (~(got by projects) project.act)
      =.  user-files.project
        (~(put in user-files.project) file.act)
      :-  (make-save-file [project file text]:act)^~
      state(projects (~(put by projects) project.act project))
    ::
        %delete-file
      ::  should show warning
      =/  =project  (~(got by projects) project.act)
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
      =/  =project  (~(got by projects) project.act)
      =.  virtualnet-addresses
        (~(put by virtualnet-addresses) [who address]:act)
      =/  addresses=^vase  !>(virtualnet-addresses)
      ::  rebuild project custom-step-definitions
      :_  state
      %-  zing
      %+  turn  ~(tap by tests.project)
      |=  [test-id=@ux t=test]
      %^  make-recompile-custom-steps-cards  project.act
      test-id  custom-step-definitions.t
    ::
        %register-contract-for-compilation
      =/  =project  (~(got by projects) project.act)
      ?:  (~(has in to-compile.project) file.act)  `state
      =:  user-files.project
        (~(put in user-files.project) file.act)
      ::
          to-compile.project
        (~(put in to-compile.project) file.act)
      ==
      :-  (make-compile-contracts project.act our.bowl)^~
      state(projects (~(put by projects) project.act project))
    ::
        %deploy-contract
      =/  =project  (~(got by projects) project.act)
      =/  who=@p
        (~(got by town-sequencers:project) town-id.act)
      =/  address=@ux  (~(got by virtualnet-addresses) who)
      =/  deploy-contract-path=path  ::  TODO: unhardcode
        /zig/custom-step-definitions/deploy-contract/hoon
      =/  scry-path=path
        %-  weld  :_  deploy-contract-path
        /(scot %p our.bowl)/[project.act]/(scot %da now.bowl)
      =/  test-name=@tas  `@tas`(rap 3 %deploy path.act)
      =/  surs=(list [@tas path])  ~[[%zig /sur/zig/ziggurat]]
      =^  subject=(each ^vase @t)  state
        (compile-test-surs `@tas`project.act surs)
      ?>  ?=(%& -.subject)
      =/  [surs=(list [face=@tas =path]) =hoon]
        (parse-pile:conq (trip .^(@t %cx scry-path)))
      =/  =test
        :*  `test-name
            ~
            (~(gas by *test-surs) surs)
            subject
        ::
            %+  ~(put by *custom-step-definitions)
              %deploy-contract
            :-  deploy-contract-path
            (compile-custom-step %deploy-contract hoon subject)
        ::
            :~  :+  %scry
                  :-  who
                  :^  '(map @ux *)'  %gx  %wallet
                  /pending-store/(scot %ux address)/noun
                ''
            ::
                :^  %custom-write  %deploy-contract
                (crip "[{<who>} {<path.act>} ~]")  ~
            ::
                :+  %scry
                  :-  who
                  :^  '(map @ux *)'  %gx  %wallet
                  /pending-store/(scot %ux address)/noun
                ''
            ::
                :+  %poke
                  :-  ~nec
                  :^  ~nec  %uqbar  %wallet-poke
                  %-  crip
                  """
                  =/  old-test-result=test-result:zig
                    (snag 2 test-results:test-globals)
                  ?>  ?=([* ~] old-test-result)
                  =/  old-pending=(set @ux)
                    %~  key  by
                    !<((map @ux *) result:i:old-test-result)
                  =/  new-test-result=test-result:zig
                    (snag 0 test-results:test-globals)
                  ?>  ?=([* ~] new-test-result)
                  =/  new-pending=(set @ux)
                    %~  key  by
                    !<((map @ux *) result:i:new-test-result)
                  =/  diff-pending=(list @ux)
                    ~(tap in (~(dif in new-pending) old-pending))
                  ?>  ?=([@ ~] diff-pending)
                  :^  %submit  from={<address>}
                    hash=i:diff-pending
                  gas=[rate=1 bud=1.000.000]
                  """
                ~
            ::
                [%dojo [~nec ':sequencer|batch'] ~]
            ==
        ::
            ~
        ==
      =/  test-id=@ux  `@ux`(sham test)
      =.  tests.project  (~(put by tests.project) test-id test)
      :-  :_  (make-run-queue our.bowl project.act)^~
          %^  make-project-update  project.act  project
          [our now]:bowl
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
      =/  =project  (~(got by projects) project.act)
      =/  build-results=(list (pair path build-result))
        %^  build-contract-projects  smart-lib-vase
          /(scot %p our.bowl)/[project.act]/(scot %da now.bowl)
        to-compile.project
      ~&  "done building, got errors:"
      =/  [cards=(list card) errors=(list [path @t])]
        (save-compiled-contracts project.act build-results)
      ~&  errors
      =.  errors.project  (~(gas by errors.project) errors)
      :-  [(make-read-desk project.act our.bowl) cards]
      state(projects (~(put by projects) project.act project))
    ::
        %compile-contract
      ::  for internal use -- app calls itself to scry clay
      ?>  ?=(%ziggurat dap.bowl)
      =/  =project  (~(got by projects) project.act)
      ?~  path.act  !!
      =/  =build-result
        %^  build-contract-project  smart-lib-vase
          /(scot %p our.bowl)/[i.path.act]/(scot %da now.bowl)
        t.path.act
      ~&  "done building {<path>}, got errors:"
      =/  save-result=(each card [path @t])
        (save-compiled-contract project.act t.path.act build-result)
      ?:  ?=(%| -.save-result)
        ~&  p.save-result
        =.  errors.project
          (~(put by errors.project) p.save-result)
        :-  (make-project-update project.act project [our now]:bowl)^~
        state(projects (~(put by projects) project.act project))
      [(make-read-desk project.act our.bowl)^~ state]
    ::
        %read-desk
      ::  for internal use -- app calls itself to scry clay
      ?>  ?=(%ziggurat dap.bowl)
      =/  =project  (~(got by projects) project.act)
      =.  dir.project
        =-  .^((list path) %ct -)
        /(scot %p our.bowl)/(scot %tas project.act)/(scot %da now.bowl)
      :-  :+  %^  make-project-update  project.act  project
                  [our now]:bowl
            %^  make-watch-for-file-changes  project.act
            dir.project  [our now]:bowl
          ~
      state(projects (~(put by projects) project.act project))
    ::
        %add-test
      =/  =project  (~(got by projects) project.act)
      =^  [cards=(list card) =test]  state
        (add-test [project name test-surs test-steps]:act)
      =/  test-id=@ux  `@ux`(sham test)
      =.  tests.project  (~(put by tests.project) test-id test)
      :-  cards
      state(projects (~(put by projects) project.act project))
    ::
        %add-and-run-test
      =^  cards  state
        %-  add-and-queue-test
        [project name test-surs test-steps]:act
      =?  cards  =(| test-running)
        (snoc cards (make-run-queue our.bowl project.act))
      [cards state]
    ::
        %add-and-queue-test
      %-  add-and-queue-test
      [project name test-surs test-steps]:act
    ::
        %save-test-to-file
      =/  =project  (~(got by projects) project.act)
      =/  =test  (~(got by tests.project) id.act)
      =/  file-text=@t  (make-test-steps-file test)
      =.  test-steps-file.test  path.act
      =.  tests.project  (~(put by tests.project) id.act test)
      :-  (make-save-file project.act path.act file-text)^~
      state(projects (~(put by projects) project.act project))
    ::
        %add-test-file
      =/  =project  (~(got by projects) project.act)
      =^  =test  state  (add-test-file [project name path]:act)
      =/  test-id=@ux  `@ux`(sham test)
      =.  tests.project  (~(put by tests.project) test-id test)
      :-  :_  ~
          %^  make-project-update  project.act  project
          [our now]:bowl
      state(projects (~(put by projects) project.act project))
    ::
        %add-and-run-test-file
      =^  cards  state
        (add-and-queue-test-file [project name path]:act)
      =?  cards  =(| test-running)
        (snoc cards (make-run-queue our.bowl project.act))
      [cards state]
    ::
        %add-and-queue-test-file
      (add-and-queue-test-file [project name path]:act)
    ::
        %delete-test
      =/  =project  (~(got by projects) project.act)
      =.  tests.project  (~(del by tests.project) id.act)
      :-  (make-project-update project.act project [our now]:bowl)^~
      state(projects (~(put by projects) project.act project))
    ::
        %run-test
      :_  state(test-queue (~(put to test-queue) [project id]:act))
      ?:  =(| test-running)
        (make-run-queue our.bowl project.act)^~
      ~&  >  "%ziggurat: another test is running, adding to queue"  ~
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
      =*  project-id  -.top
      =*  test-id     +.top
      ~&  >  "%ziggurat: running {<test-id>}"
      =/  =project  (~(got by projects) project-id)
      =/  =test     (~(got by tests.project) test-id)
      ?:  ?=(%| -.subject.test)
        ~|("%ziggurat: test subject must compile before test can be run" !!)  ::  TODO: do better
      =/  tid=@ta
        %+  rap  3
        :~  'ted-'
            project-id
            '-'
            ?^(name.test u.name.test (scot %ux test-id))
            '-'
            (scot %uw (sham eny.bowl))
        ==
      =/  =start-args:spider
        :-  ~
        :^  `tid  byk.bowl(r da+now.bowl)
          %ziggurat-test-run
        !>  ^-  (unit [@t @ux test-steps ^vase (list @p)])
        :*  ~
            project-id
            test-id
            steps.test
            p.subject.test
            ~[~nec ~bud]  :: TODO: remove hardcode and allow input of for-snapshot
        ==
      =/  w=wire  /test/[project-id]/(scot %ux test-id)/[tid]
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
        %add-custom-step
      =/  =project  (~(got by projects) project.act)
      =/  =test     (~(got by tests.project) test-id.act)
      =.  test
        %-  fall  :_  test
        (add-custom-step test [project tag path]:act)
      =.  project
        project(tests (~(put by tests.project) test-id.act test))
      :-  (make-project-update project.act project [our now]:bowl)^~
      %=  state
          projects  (~(put by projects) project.act project)
      ==
    ::
        %delete-custom-step
      =/  =project  (~(got by projects) project.act)
      =/  =test     (~(got by tests.project) test-id.act)
      =.  custom-step-definitions.test
        (~(del by custom-step-definitions.test) tag.act)
      =.  project
        project(tests (~(put by tests.project) test-id.act test))
      :-  (make-project-update project.act project [our now]:bowl)^~
      %=  state
          projects  (~(put by projects) project.act project)
      ==
    ::
        %add-app-to-dashboard
      =/  =project  (~(got by projects) project.act)
      =*  sur  sur.act
      ::
      =/  dbug-mold-result
        %-  mule
        |.
        ::  make mold subject
        ?~  snipped=(snip sur)  !!  ::  TODO: do better
        =/  sur-face=@tas  `@tas`(rear snipped)
        ?>  ?=(^ sur)
        =^  sur-hoon=^vase  ca-scry-cache
          (scry-or-cache-ca project.act sur ca-scry-cache)
        =/  subject=^vase
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
      :-  (make-project-update project.act project [our now]:bowl)^~
      %=  state
          projects  (~(put by projects) project.act project)
      ==
    ::
        %delete-app-from-dashboard
      =/  =project  (~(got by projects) project.act)
      =.  dbug-dashboards.project
        (~(del by dbug-dashboards.project) app.act)
      :-  (make-project-update project.act project [our now]:bowl)^~
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
      =/  wach=(list card:agent:gall)
        %+  turn  ships.act
        |=  who=ship
        :*  %pass  /ready/(scot %p who)  %agent
            [our.bowl %pyro]
            %watch  /ready/(scot %p who)
        ==
      =/  init=(list card:agent:gall)
        :_  ~
        :*  %pass  /  %agent
            [our.bowl %pyro]
            %poke  %aqua-events
            !>((turn ships.act |=(who=ship [%init-ship who])))
        ==
      =/  subs=(list card:agent:gall) ::  start %subscriber app
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
      =/  =project  (~(got by projects) project.act)
      =.  town-sequencers.project
        (~(put by town-sequencers.project) [town-id who]:act)
      :-  (make-project-update project.act project [our now]:bowl)^~
      state(projects (~(put by projects) project.act project))
    ::
        %delete-town-sequencer
      =/  =project  (~(got by projects) project.act)
      =.  town-sequencers.project
        (~(del by town-sequencers.project) town-id.act)
      :-  (make-project-update project.act project [our now]:bowl)^~
      state(projects (~(put by projects) project.act project))
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
      =/  project  (~(got by projects) project.act)
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
          (make-compile-contracts project.act our.bowl)
        =-  [%pass /treaty-wire %agent [our.bowl %treaty] %poke -]
        [%alliance-update-0 !>([%add our.bowl `@tas`project.act])]
      ~
    ::
        %add-user-file
      =/  =project  (~(got by projects) project.act)
      =.  user-files.project  (~(put in user-files.project) file.act)
      :-  (make-project-update project.act project [our now]:bowl)^~
      state(projects (~(put by projects) project.act project))
    ::
        %delete-user-file
      =/  =project  (~(got by projects) project.act)
      =.  user-files.project  (~(del in user-files.project) file.act)
      :-  (make-project-update project.act project [our now]:bowl)^~
      state(projects (~(put by projects) project.act project))
    ==
  ++  add-or-update-item
    |=  [project-id=@t =item:smart]
    ^-  (quip card _state)
    ?>  ?=(%& -.item)
    =,  p.item
    =/  =project  (~(got by projects) project-id)
    =/  noun-text  ;;(@t noun)
    =/  =data:smart
      =+  (text-to-zebra-noun noun-text smart-lib-vase)
      [id source holder town salt label -]
    :-  (make-project-update project-id project [our now]:bowl)^~
    state(projects (~(put by projects) project-id project))
  --
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [%test @ @ @ ~]
    ?+    -.sign  (on-agent:def wire sign)
        %kick      `this
        %poke-ack  `this
        %fact
      =*  project-name  i.t.wire
      =/  test-id=@ux   (slav %ux i.t.t.wire)
      =/  tid=@ta       i.t.t.t.wire
      ?+    p.cage.sign  (on-agent:def wire sign)
          %thread-fail
        ~&  ziggurat+thread-fail+project^test-id^tid
        `this(test-running |)
      ::
          %thread-done
        =+  !<(=test-results q.cage.sign)
        =/  =project  (~(got by projects) project-name)
        =/  =test     (~(got by tests.project) test-id)
        ~&  >  "%ziggurat: test done {<test-id>}"
        ~&  >  (show-test-results test-results)
        =.  tests.project
          %+  ~(put by tests.project)  test-id
          test(results test-results)
        =/  cards=(list card)
          (make-project-update project-name project [our now]:bowl)^~
        =?  cards  ?=(^ test-queue)
          %+  snoc  cards
          :^  %pass  /self-wire  %agent
          :^  [our dap]:bowl  %poke  %ziggurat-action
          !>([project-name %run-queue ~])
        :-  cards
        %=  this
          projects  (~(put by projects) project-name project)
          test-running  |
        ==
      ==
    ==
  ::
      [%ready @ ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      =/  who=ship  (slav %p i.t.wire)
      =.  pyro-ships-ready  (~(put by pyro-ships-ready) who %.y)
      =/  card=card:agent:gall
        :^  %pass  /ready/(scot %p who)  %agent
        [[our.bowl %pyro] %leave ~]
      ?~  test-queue                         [card^~ this]
      ?.  (~(all by pyro-ships-ready) same)  [card^~ this]
      :_  this
      :+  card
        :^  %pass  /self-wire  %agent
        :^  [our dap]:bowl  %poke  %ziggurat-action
        !>([%$ %run-queue ~])
      ~
    ==
  ::
      [%restore ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      :_  this(pyro-ships-ready [[~nec %.y] ~ ~]) :: XX extremely hacky
      [%pass /restore %agent [our.bowl %pyro] %leave ~]^~
    ==
  ==
::
++  on-arvo
  |=  [=wire =sign-arvo:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-arvo:def wire sign-arvo)
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
    ~&  %ziggurat^%clay
    ?>  ?=([%clay %wris *] sign-arvo)
    =*  project-name  i.t.wire
    =/  project  (~(got by projects) project-name)
    =/  updated-files=(set path)
      %-  ~(gas in *(set path))
      (turn ~(tap in q.sign-arvo) |=([@ p=path] p))
    :_  this
    :_  ~
    ?:  .=  0
        %~  wyt  in
        (~(int in updated-files) to-compile.project)
      (make-read-desk project-name our.bowl)
    (make-compile-contracts project-name our.bowl)
  ==
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?.  =(%x -.path)  ~
  =,  format
  ?+    +.path  (on-peek:def path)
  ::
  ::  NOUNS
  ::
    ::   [%project-nock @ ~]
    :: ?~  project=(~(get by projects) (slav %t i.t.t.path))
    ::   ``noun+!>(~)
    :: ?>  ?=(%& -.u.project)
    :: ?~  compiled.p.u.project
    ::   ``noun+!>(~)
    :: ``noun+!>(compiled.p.u.project)
  ::
    ::   [%custom-step-definitions @ @ ~]
    :: =/  =project  (~(got by projects) (slav %ux i.t.t.path))
    :: =/  =test  (~(got by tests.project) (slav %ux i.t.t.t.path))
    :: :^  ~  ~  %noun
    :: !>  ^-  custom-step-definitions
    :: %-  ~(run by custom-step-definitions.test)
    :: |=  [p=custom-step-definition q=custom-step-compiled]
    :: :-  p
    :: ?:  ?=(%| -.q)  q  [%& *vase]
  ::
      [%custom-step-compiled @ @ @ ~]
    =/  =project  (~(got by projects) i.t.t.path)
    =/  =test  (~(got by tests.project) (slav %ux i.t.t.t.path))
    =/  tag=@tas  `@tas`i.t.t.t.t.path
    ?~  def=(~(get by custom-step-definitions.test) tag)
      ~|("%ziggurat: did not find {<tag>} custom-step-definition in {<~(key by custom-step-definitions.test)>}" !!)
    ?:  ?=(%| -.q.u.def)  ::  TODO: do better
      ~|("%ziggurat: compilation of {<tag>} failed; please fix and try again. error message: {<p.q.u.def>}" !!)
    ``noun+!>(`vase`p.q.u.def)
  ::
      [%projects ~]
    :^  ~  ~  %noun
    !>  ^-  ^projects
    %-  ~(run by projects)
    |=  =project
    %=  project
        tests
      %-  ~(run by tests.project)
      |=  =test
      %=  test
          subject
        ?:(?=(%& -.subject.test) [%& *vase] subject.test)
      ::
          custom-step-definitions
        %-  ~(run by custom-step-definitions.test)
        |=  [p=^path q=custom-step-compiled]
        [p ?:(?=(%& -.q) [%& *vase] q)]
      ==
    ==
  ::
  ::  JSONS
  ::
      [%all-projects ~]
    =,  enjs
    =;  =json  ``json+!>(json)
    %-  pairs
    %+  murn  ~(tap by projects)
    |=  [name=@t =project]
    :-  ~  :-  name
    (project-to-json project)
  ::
      [%project-state @ ~]
    ?~  project=(~(get by projects) i.t.t.path)  ``json+!>(~)
    :^  ~  ~  %json
    !>  ^-  json
    (get-state-to-json u.project [our now]:bowl)
  ::
      [%project-tests @ ~]
    ?~  project=(~(get by projects) i.t.t.path)
      ``json+!>(~)
    ``json+!>((tests-to-json tests.u.project))
  ::
      [%project-user-files @ ~]
    ?~  project=(~(get by projects) i.t.t.path)
      ``json+!>(~)
    :^  ~  ~  %json
    !>  ^-  json
    %+  frond:enjs:format  %user-files
    (dir-to-json ~(tap in user-files.u.project))
  ::
      [%dashboard @ @ @ ~]
    =*  project-name  i.t.t.path
    =*  who           i.t.t.t.path
    =*  app           i.t.t.t.t.path
    :^  ~  ~  %json
    !>  ^-  json
    ?~  project=(~(get by projects) project-name)
      %+  json-single-string-object  %error
      "project {<project-name>} not found; must register project with %new-project"
    ?~  dbug=(~(get by dbug-dashboards.u.project) app)
      %+  json-single-string-object  %error
      "app {<app>} not found; must add app to dashboard with %add-app-to-dashboard"
    ?:  ?=(%| -.mold.u.dbug)
      %+  json-single-string-object  %error
      "app {<app>} subject failed to build; fix sur file path and re-add with %add-app-to-dashboard. error message from build: {<p.mold.u.dbug>}"
    =/  now=@ta  (scot %da now.bowl)
    =/  dbug-noun=*
      .^  *
          %gx
          %+  weld  /(scot %p our.bowl)/pyro/[now]/i/[who]
          /gx/[who]/[app]/[now]/dbug/state/noun/noun
      ==
    ?.  ?=(^ dbug-noun)
      %+  json-single-string-object  %error
      "dbug scry failed: unexpected result from pyro"
    =*  mar-tube   mar-tube.u.dbug
    =*  dbug-mold  p.mold.u.dbug
    =/  dbug-vase=vase  (slym dbug-mold +.+.dbug-noun)
    ?~  mar-tube
      (json-single-string-object %state (noah dbug-vase))
    (frond:enjs:format %state !<(json (u.mar-tube dbug-vase)))
  ::
      [%file-exists @ ^]
    =/  des=@ta    i.t.t.path
    =/  pat=^path  `^path`t.t.t.path
    =/  pre=^path  /(scot %p our.bowl)/(scot %tas des)/(scot %da now.bowl)
    ``json+!>(`json`[%b .^(? %cu (weld pre pat))])
  ::
  ::  APP-PROJECT JSON
  ::
      [%read-file @ ^]
    =/  des=@ta    i.t.t.path
    =/  pat=^path  `^path`t.t.t.path
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
