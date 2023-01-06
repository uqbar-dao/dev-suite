::  ziggurat [UQ| DAO]
::
::  Contract Playground
::
/-  spider,
    zig=zig-ziggurat
/+  agentio,
    dbug,
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
    io       ~(. agentio bowl)
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
        %+  ~(put by *configs:zig)  ''
        %-  ~(gas by *config:zig)
        :+  [[~nec %address] nec-address]
          [[~bud %address] bud-address]
        ~
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
  ?+    p  (on-watch:def p)
      [%pyro-done ~]  `this
      [%project @ ~]
    ::  serve updates about state of a given project
    =/  name=@t  `@t`i.t.p
    ?~  proj=(~(get by projects) name)  `this
    :_  this
    :_  ~
    %+  make-project-update:zig-lib
    [name %on-watch-project ~]  u.proj
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
    |=  $:  project-name=@t
            name=(unit @t)
            imports=test-imports:zig
            =test-steps:zig
            request-id=(unit @t)
        ==
    ^-  [[(list card) test:zig] _state]
    =/  =project:zig  (~(got by projects) project-name)
    =/  add-test-error
      %~  add-test  make-error-vase:zig-lib
      [[project-name %add-test request-id] %error]
    =/  zig-val=(unit path)  (~(get by imports) %zig)
    =.  imports
      ?^  zig-val  imports
      (~(put by imports) %zig /sur/zig/ziggurat)
    ?:  ?|  &(?=(^ zig-val) !=(/sur/zig/ziggurat u.zig-val))
            !=(1 (lent (fand ~[/sur/zig/ziggurat] ~(val by imports))))
        ==
      =/  message=tape
        %+  weld  "%zig face reserved for /sur/zig/ziggurat"
        " ; got {<zig-val>}"
      :_  state
      :_  *test:zig
      :_  ~
      %+  update-vase-to-card:zig-lib  project-name
      (add-test-error (crip message) 0x0)
    =^  subject=(each vase @t)  state
      (compile-test-imports `@tas`project-name ~(tap by imports))
    ?:  ?=(%| -.subject)
      =/  message=tape
        "compilation of test-imports failed: {<p.subject>}"
      :_  state
      :_  *test:zig
      :_  ~
      %+  update-vase-to-card:zig-lib  project-name
      (add-test-error (crip message) 0x0)
    =/  =test:zig
      :*  name
          /
          imports
          subject
          ~
          test-steps
          ~
      ==
    =^  cards=(list card)  test
      %+  add-custom-step:zig-lib  test
      :^  project-name  %scry-indexer
        /zig/custom-step-definitions/scry-indexer/hoon
      request-id
    =/  all-cards=(list card)  cards
    =^  cards=(list card)  test
      %+  add-custom-step:zig-lib  test
      :^  project-name  %poke-wallet-transaction
        /zig/custom-step-definitions/poke-wallet-transaction/hoon
      request-id
    =.  all-cards  (weld cards all-cards)
    =^  cards=(list card)  test
      %+  add-custom-step:zig-lib  test
      :^  project-name  %send-wallet-transaction
        /zig/custom-step-definitions/send-wallet-transaction/hoon
      request-id
    :_  state
    :_  test
    :_  (weld cards all-cards)
    %+  update-vase-to-card:zig-lib  project-name
    %.  [test `@ux`(sham test)]
    %~  add-test  make-update-vase:zig-lib
    [project-name %add-test request-id]
  ::
  ++  add-and-queue-test
    |=  $:  project-name=@t
            name=(unit @t)
            =test-imports:zig
            =test-steps:zig
            request-id=(unit @t)
        ==
    ^-  (quip card _state)
    =/  =project:zig  (~(got by projects) project-name)
    =^  [cards=(list card) =test:zig]  state
        %:  add-test
            project-name
            name
            test-imports
            test-steps
            request-id
        ==
    ?:  =(*test:zig test)
      [cards state]  ::  encountered error
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
    |=  $:  project-name=@tas
            name=(unit @t)
            p=path
            request-id=(unit @t)
        ==
    ^-  [[(list card) test:zig] _state]
    =/  add-test-error
      %~  add-test  make-error-vase:zig-lib
      [[project-name %add-test-file request-id] %error]
    ?~  p
      =/  message=tape  "test-steps path must not be empty"
      :_  state
      :_  *test:zig
      :_  ~
      %+  update-vase-to-card:zig-lib  project-name
      (add-test-error (crip message) 0x0)
    =/  =project:zig  (~(got by projects) project-name)
    =/  file-scry-path=path
      :-  (scot %p our.bowl)
      (weld /[project-name]/(scot %da now.bowl) p)
    =/  file-cord=@t  .^(@t %cx file-scry-path)
    =/  [imports=(list [face=@tas =path]) =hair]
      (parse-start-of-pile:zig-lib (trip file-cord))
    =^  subject=(each vase @t)  state
      (compile-test-imports `@tas`project-name imports)
    ?:  ?=(%| -.subject)
      =/  message=tape
        "compilation of test-imports failed: {<p.subject>}"
      :_  state
      :_  *test:zig
      :_  ~
      %+  update-vase-to-card:zig-lib  project-name
      (add-test-error (crip message) 0x0)
    =/  test-steps-compilation-result=(each vase @t)
      %^  compile-and-call-buc:zig-lib  p.hair  p.subject
      %-  of-wain:format
      (slag (dec p.hair) (to-wain:format file-cord))
    ?:  ?=(%| -.test-steps-compilation-result)
      =/  message=tape
        %+  weld  "test-steps compilation failed for"
        " {<`path`p>} with error {<p.test-steps-compilation-result>}"
      :_  state
      :_  *test:zig
      :_  ~
      %+  update-vase-to-card:zig-lib  project-name
      (add-test-error (crip message) 0x0)
    =+  !<(=test-steps:zig p.test-steps-compilation-result)
    =/  =test:zig
      :*  name
          p
          (~(gas by *test-imports:zig) imports)
          subject
          ~
          test-steps
          ~
      ==
    =^  cards=(list card)  test
      %+  add-custom-step:zig-lib  test
      :^  project-name  %scry-indexer
        /zig/custom-step-definitions/scry-indexer/hoon
      request-id
    =/  all-cards=(list card)  cards
    =^  cards=(list card)  test
      %+  add-custom-step:zig-lib  test
      :^  project-name  %poke-wallet-transaction
        /zig/custom-step-definitions/poke-wallet-transaction/hoon
      request-id
    =.  all-cards  (weld cards all-cards)
    =^  cards=(list card)  test
      %+  add-custom-step:zig-lib  test
      :^  project-name  %send-wallet-transaction
        /zig/custom-step-definitions/send-wallet-transaction/hoon
      request-id
    [[(weld cards all-cards) test] state]
  ::
  ++  add-and-queue-test-file
    |=  $:  project-name=@t
            name=(unit @t)
            test-steps-file=path
            request-id=(unit @t)
        ==
    ^-  (quip card _state)
    =/  =project:zig  (~(got by projects) project-name)
    =^  [cards=(list card) =test:zig]  state
      %-  add-test-file
      [project-name name test-steps-file request-id]
    ?:  =(*test:zig test)
      [cards state]  ::  encountered error
    =/  test-id=@ux  `@ux`(sham test)
    =.  tests.project  (~(put by tests.project) test-id test)
    :-  :_  cards
        %+  update-vase-to-card:zig-lib  project-name
        %.  [test test-id]
        %~  add-test  make-update-vase:zig-lib
        [project-name %add-and-queue-test-file request-id]
    %=  state
        projects
      (~(put by projects) project-name project)
    ::
        test-queue
      (~(put to test-queue) project-name test-id)
    ==
  ::
  ++  compile-test-imports
    |=  [project-desk=@tas imports=(list [face=@tas =path])]
    ^-  [(each vase @t) _state]
    =/  compilation-result
      %-  mule
      |.
      =/  initial-test-globals=vase
        !>  ^-  test-globals:zig
        :^  our.bowl  now.bowl  *test-results:zig
        [project-desk configs]
      =/  [subject=vase c=ca-scry-cache:zig]
        %+  roll  imports
        |:  [[face=`@tas`%$ sur=`path`/] [subject=`vase`!>(..zuse) ca-scry-cache=ca-scry-cache]]
        ?:  =(%test-globals face)
          !!  ::  TODO: do better  [[%| '%test-globals face is reserved'] state]
        =^  sur-hoon=vase  ca-scry-cache
          %-  need  ::  TODO: handle error
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
    =*  tag  -.+.+.act
    =/  =update-info:zig  [project.act tag request-id.act]
    ?-    tag
        %new-project
      =/  new-project-error
        %~  new-project  make-error-vase:zig-lib
        [update-info %error]
      ?:  (~(has in (~(gas in *(set @t)) ~['fresh-piers' 'assembled'])) project.act)  ::  TODO: still necessary?
        =/  message=tape
          "{<`@tas`project.act>} face reserved"
        :_  state
        :_  ~
        %+  update-vase-to-card:zig-lib  project.act
        (new-project-error (crip message))
      ~&  desk
      ~&  >  "scrying..."
      =/  desks=(set desk)
        .^  (set desk)
            %cd
            /(scot %p our.bowl)/[dap.bowl]/(scot %da now.bowl)
        ==
      ?:  (~(has in desks) project.act)  ::  TODO: start project using this desk?
        =/  message=tape  "project desk already exists"
        :_  state
        :_  ~
        %+  update-vase-to-card:zig-lib  project.act
        (new-project-error (crip message))
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
              (make-read-desk:zig-lib [project request-id]:act)
          ::
              %+  update-vase-to-card:zig-lib  project.act
              %~  new-project  make-update-vase:zig-lib
              update-info
          ==
      %=  state
          configs  ::  TODO: generalize: read in configuration file
        %+  ~(put by configs)  project.act
        %.  [[~nec %sequencer] 0x0]
        ~(put by (~(gut by configs) project.act ~))
      ::
          projects
        %+  ~(put by projects)  project.act
        :*  dir=~  ::  populated by +make-read-desk / %read-desk
            user-files=(~(put in *(set path)) /app/[project.act]/hoon)
            to-compile=~
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
      %-  ~(arvo pass:io /del-wire)
      [%c %info `@tas`project.act %& [file.act %del ~]~]
    ::
        %add-config
      =.  configs
        %+  ~(put by configs)  project.act
        %.  [[who what]:act item.act]
        ~(put by (~(gut by configs) project.act ~))
      :_  state
      :-  %+  update-vase-to-card:zig-lib  project.act
          %.  [who what item]:act
          %~  add-config  make-update-vase:zig-lib
          update-info
      ?:  =('' project.act)  ~
      =/  =project:zig  (~(got by projects) project.act)
      %-  zing
      %+  turn  ~(tap by tests.project)
      |=  [test-id=@ux =test:zig]
      %-  make-recompile-custom-steps-cards:zig-lib
      :^  project.act  test-id  custom-step-definitions.test
      request-id.act
    ::
        %delete-config
      =.  configs
        %+  ~(put by configs)  project.act
        %.  [who what]:act
        ~(del by (~(gut by configs) project.act ~))
      :_  state
      :-  %+  update-vase-to-card:zig-lib  project.act
          %.  [who what]:act
          %~  delete-config  make-update-vase:zig-lib
          update-info
      ?:  =('' project.act)  ~
      =/  =project:zig  (~(got by projects) project.act)
      %-  zing
      %+  turn  ~(tap by tests.project)
      |=  [test-id=@ux =test:zig]
      %-  make-recompile-custom-steps-cards:zig-lib
      :^  project.act  test-id  custom-step-definitions.test
      request-id.act
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
      :-  :_  ~
          %-  make-compile-contracts:zig-lib
          [project request-id]:act
      state(projects (~(put by projects) project.act project))
    ::
        %deploy-contract
      =/  =project:zig  (~(got by projects) project.act)
      =/  add-test-error
        %~  add-test  make-error-vase:zig-lib
        [update-info %error]
      =/  who=(unit @p)
        %^  town-id-to-sequencer-host:zig-lib  project.act
        town-id.act  configs
      ?~  who
        =/  message=tape
          %+  weld  "could not find host for town-id"
          " {<town-id.act>} amongst {<configs>}"
        :_  state
        :_  ~
        %+  update-vase-to-card:zig-lib  project.act
        (add-test-error (crip message) 0x0)
      =/  address=@ux
        (~(got by (~(got by configs) '')) [u.who %address])
      =/  test-name=@tas  `@tas`(rap 3 %deploy path.act)
      =/  imports=(list [@tas path])
        :+  [%indexer /sur/zig/indexer]
          [%zig /sur/zig/ziggurat]
        ~
      =^  subject=(each vase @t)  state
        (compile-test-imports `@tas`project.act imports)
      ?:  ?=(%| -.subject)
        =/  message=tape
          "compilation of test-imports failed: {<p.subject>}"
        :_  state
        :_  ~
        %+  update-vase-to-card:zig-lib  project.act
        (add-test-error (crip message) 0x0)
      =/  =test:zig
        :*  `test-name
            ~
            (~(gas by *test-imports:zig) imports)
            subject
            ~
        ::
            :_  ~
            :^  %custom-write  %send-wallet-transaction
              %-  crip
              %-  noah
              !>  ^-  [@p test-write-step:zig]
              :-  u.who
              :^  %custom-write  %deploy-contract
              (crip "[{<u.who>} {<path.act>} ~]")  ~
            ~
        ::
            ~
        ==
      =^  cards=(list card)  test
        %+  add-custom-step:zig-lib  test
        :^  project.act  %deploy-contract
          /zig/custom-step-definitions/deploy-contract/hoon
        request-id.act
      =/  all-cards=(list card)  cards
      =^  cards=(list card)  test
        %+  add-custom-step:zig-lib  test
        :^  project.act  %send-wallet-transaction
          /zig/custom-step-definitions/send-wallet-transaction/hoon
        request-id.act
      =/  test-id=@ux  `@ux`(sham test)
      =.  tests.project  (~(put by tests.project) test-id test)
      :-  :+  (make-run-queue:zig-lib [project request-id]:act)
            %+  update-vase-to-card:zig-lib  project.act
            %.  [test test-id]
            %~  add-test  make-update-vase:zig-lib
            update-info
          (weld cards all-cards)
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
      :_  state
      :_  cards
      (make-read-desk:zig-lib [project request-id]:act)
    ::
        %compile-contract
      ::  for internal use -- app calls itself to scry clay
      ?>  ?=(%ziggurat dap.bowl)
      =/  =project:zig  (~(got by projects) project.act)
      =/  compile-contract-error
        %~  compile-contract  make-error-vase:zig-lib
        [update-info %error]
      ?~  path.act
        =/  message=tape  "contract path must not be empty"
        :_  state
        :_  ~
        %+  update-vase-to-card:zig-lib  project.act
        (compile-contract-error (crip message))
      ::
      =/  =build-result:zig
        %^  build-contract-project:zig-lib  smart-lib-vase
          /(scot %p our.bowl)/[i.path.act]/(scot %da now.bowl)
        t.path.act
      ?:  ?=(%| -.build-result)
        =/  message=tape
          "compilation failed with error: {<p.build-result>}"
        :_  state
        :_  ~
        %+  update-vase-to-card:zig-lib  project.act
        (compile-contract-error (crip message))
      ::
      =/  save-result=(each card [path @t])
        %^  save-compiled-contract:zig-lib  project.act
        t.path.act  build-result
      ?:  ?=(%| -.save-result)
        =/  message=tape
          %+  weld  "failed to save newly compiled contract"
          " with error: {<p.save-result>}"
        :_  state
        :_  ~
        %+  update-vase-to-card:zig-lib  project.act
        (compile-contract-error (crip message))
      ::
      :_  state
      :+  p.save-result
        (make-read-desk:zig-lib [project request-id]:act)
      ~
    ::
        %read-desk
      ::  for internal use -- app calls itself to scry clay
      ?>  ?=(%ziggurat dap.bowl)
      =/  =project:zig  (~(got by projects) project.act)
      =.  dir.project
        =-  .^((list path) %ct -)
        /(scot %p our.bowl)/(scot %tas project.act)/(scot %da now.bowl)
      :-  :+  %+  make-watch-for-file-changes:zig-lib
              project.act  dir.project
            %+  update-vase-to-card:zig-lib  project.act
            %.  dir.project
            %~  dir  make-update-vase:zig-lib
            update-info
          ~
      state(projects (~(put by projects) project.act project))
    ::
        %add-test
      =/  =project:zig  (~(got by projects) project.act)
      =^  [cards=(list card) =test:zig]  state
        (add-test [project name test-imports test-steps request-id]:act)
      ?:  =(*test:zig test)
        [cards state]  ::  encountered error
      =/  test-id=@ux  `@ux`(sham test)
      =.  tests.project  (~(put by tests.project) test-id test)
      :-  cards
      state(projects (~(put by projects) project.act project))
    ::
        %add-and-run-test
      =^  cards  state
        %-  add-and-queue-test
        [project name test-imports test-steps request-id]:act
      =?  cards  =(| test-running)
        %+  snoc  cards
        (make-run-queue:zig-lib [project request-id]:act)
      [cards state]
    ::
        %add-and-queue-test
      %-  add-and-queue-test
      [project name test-imports test-steps request-id]:act
    ::
        %save-test-to-file
      =/  =project:zig  (~(got by projects) project.act)
      =/  =test:zig  (~(got by tests.project) id.act)
      =/  file-text=@t  (make-test-steps-file:zig-lib test)
      =.  test-steps-file.test  path.act
      =.  tests.project  (~(put by tests.project) id.act test)
      :-  :_  ~
          %^  make-save-file:zig-lib  project.act  path.act
          file-text
      %=  state
        projects  (~(put by projects) project.act project)
      ==
    ::
        %add-test-file
      =/  =project:zig  (~(got by projects) project.act)
      =^  [cards=(list card) =test:zig]  state
        (add-test-file [project name path request-id]:act)
      ?:  =(*test:zig test)
        [cards state]  ::  encountered error
      =/  test-id=@ux  `@ux`(sham test)
      =.  tests.project  (~(put by tests.project) test-id test)
      :_
        %=  state
          projects  (~(put by projects) project.act project)
        ==
      :_  cards
      %+  update-vase-to-card:zig-lib  project.act
      %.  [test test-id]
      %~  add-test  make-update-vase:zig-lib
      update-info
    ::
        %add-and-run-test-file
      =^  cards  state
        %-  add-and-queue-test-file
        [project name path request-id]:act
      =?  cards  =(| test-running)
        %+  snoc  cards
        (make-run-queue:zig-lib [project request-id]:act)
      [cards state]
    ::
        %add-and-queue-test-file
      %-  add-and-queue-test-file
      [project name path request-id]:act
    ::
        %delete-test
      =/  =project:zig  (~(got by projects) project.act)
      =.  tests.project  (~(del by tests.project) id.act)
      :_
        %=  state
          projects  (~(put by projects) project.act project)
        ==
      :_  ~
      %+  update-vase-to-card:zig-lib  project.act
      %.  id.act
      %~  delete-test  make-update-vase:zig-lib
      update-info
    ::
        %run-test
      :_  state(test-queue (~(put to test-queue) [project id]:act))
      ?:  =(| test-running)
        (make-run-queue:zig-lib [project request-id]:act)^~
      ~&  >  "%ziggurat: another test is running, adding to queue"  ~
    ::
        %run-queue
      =/  run-queue-error
        %~  run-queue  make-error-vase:zig-lib
        [update-info %error]
      ?:  =(~ pyro-ships-ready)
        =/  message=tape
          "must run %start-pyro-ships before tests"
        :_  state
        :_  ~
        %+  update-vase-to-card:zig-lib  project.act
        (run-queue-error(level %warning) (crip message))
      ?:  !(~(all by pyro-ships-ready) same)
        =/  message=tape
          "%pyro ships aren't ready; will run when ready"
        :_  state
        :_  ~
        %+  update-vase-to-card:zig-lib  project.act
        (run-queue-error(level %info) (crip message))
      ?:  =(~ test-queue)
        =/  message=tape  "no tests in queue"
        :_  state
        :_  ~
        %+  update-vase-to-card:zig-lib  project.act
        (run-queue-error(level %warning) (crip message))
      ?:  =(& test-running)
        =/  message=tape  "queue already running"
        :_  state
        :_  ~
        %+  update-vase-to-card:zig-lib  project.act
        (run-queue-error(level %info) (crip message))
      =^  top  test-queue  ~(get to test-queue)
      =*  next-project-name  -.top
      =*  next-test-id        +.top
      ~&  >  "%ziggurat: running {<next-test-id>}"
      =/  =project:zig  (~(got by projects) next-project-name)
      =/  =test:zig     (~(got by tests.project) next-test-id)
      ?:  ?=(%| -.subject.test)
        =/  message=tape
          "test subject must compile before test can be run"
        :_  state
        :_  ~
        %+  update-vase-to-card:zig-lib  project.act
        (run-queue-error (crip message))
      =/  tid=@ta
        %+  rap  3
        :~  'ted-'
            next-project-name
            '-'
            ?^(name.test u.name.test (scot %ux next-test-id))
            '-'
            (scot %uw (sham eny.bowl))
        ==
      =/  =start-args:spider
        :-  ~
        :^  `tid  byk.bowl(r da+now.bowl)
          %ziggurat-test-run
        !>  ^-  (unit [@t @ux test-steps:zig vase (list @p)])
        :*  ~
            next-project-name
            next-test-id
            steps.test
            p.subject.test
            ~[~nec ~bud]  :: TODO: remove hardcode and allow input of for-snapshot
        ==
      =/  w=wire
        /test/[next-project-name]/(scot %ux next-test-id)/[tid]
      :_  state(test-running &)
      :+  %+  ~(watch-our pass:io w)  %spider
          /thread-result/[tid]
        %+  ~(poke-our pass:io w)  %spider
        [%spider-start !>(start-args)]
      ~
    ::
        %clear-queue
      `state(test-queue ~)
    ::
        %queue-test
      `state(test-queue (~(put to test-queue) [project.act id.act]))
    ::
        %add-custom-step
      =/  =project:zig  (~(got by projects) project.act)
      =/  =test:zig     (~(got by tests.project) test-id.act)
      =^  cards=(list card)  test
        %+  add-custom-step:zig-lib  test
        [project tag path request-id]:act
      =.  project
        project(tests (~(put by tests.project) test-id.act test))
      :_
        %=  state
          projects  (~(put by projects) project.act project)
        ==
      :_  cards
      %+  update-vase-to-card:zig-lib  project.act
      %.  [test-id tag]:act
      %~  add-custom-step  make-update-vase:zig-lib
      update-info
    ::
        %delete-custom-step
      =/  =project:zig  (~(got by projects) project.act)
      =/  =test:zig     (~(got by tests.project) test-id.act)
      =.  custom-step-definitions.test
        (~(del by custom-step-definitions.test) tag.act)
      =.  project
        project(tests (~(put by tests.project) test-id.act test))
      :_
        %=  state
          projects  (~(put by projects) project.act project)
        ==
      :_  ~
      %+  update-vase-to-card:zig-lib  project.act
      %.  [test-id tag]:act
      %~  delete-custom-step  make-update-vase:zig-lib
      update-info
    ::
        %add-app-to-dashboard
      =/  =project:zig  (~(got by projects) project.act)
      =/  add-app-error
        %~  add-app-to-dashboard  make-error-vase:zig-lib
        [update-info %error]
      =*  sur  sur.act
      ::  make mold subject
      ?~  snipped=(snip sur)
        =/  message=tape  "sur must be nonnull, got {<sur>}"
        :_  state
        :_  ~
        %+  update-vase-to-card:zig-lib  project.act
        %+  add-app-error  (crip message)
        [app sur mold-name mar]:act
      =/  sur-face=@tas  `@tas`(rear snipped)
      =^  sur-hoon=vase  ca-scry-cache
        %-  need  ::  TODO: handle error
        %^  scry-or-cache-ca:zig-lib  project.act   sur
        ca-scry-cache
      =/  subject=vase
        %-  slop  :_  !>(..zuse)
        sur-hoon(p [%face sur-face p.sur-hoon])
      ::  make mold
      =/  dbug-mold
        %^  mule-slap-subject:zig-lib  0  subject
        mold-name.act
      ~?  ?=(%| -.dbug-mold)
        "%ziggurat: dbug mold build failed with error: {<p.dbug-mold>}"
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
      :_
        %=  state
          projects  (~(put by projects) project.act project)
        ==
      :_  ~
      %+  update-vase-to-card:zig-lib  project.act
      %.  [app sur mold-name mar]:act
      %~  add-app-to-dashboard  make-update-vase:zig-lib
      update-info
    ::
        %delete-app-from-dashboard
      =/  =project:zig  (~(got by projects) project.act)
      =.  dbug-dashboards.project
        (~(del by dbug-dashboards.project) app.act)
      :_
        %=  state
          projects  (~(put by projects) project.act project)
        ==
      :_  ~
      %+  update-vase-to-card:zig-lib  project.act
      %.  app.act
      %~  delete-app-from-dashboard  make-update-vase:zig-lib
      update-info
    ::
        %stop-pyro-ships
      =.  pyro-ships-ready  ~
      :_  state
      :^    [%give %fact [/pyro-done]~ [%noun !>(`*`**)]]
          [%give %kick [/pyro-done]~ ~]
        %+  update-vase-to-card:zig-lib  ''
        %.  pyro-ships-ready
        %~  pyro-ships-ready  make-update-vase:zig-lib
        ['' %pyro-ships-ready ~]
      ~
    ::
        %start-pyro-ships
      =?  ships.act  ?=(~ ships.act)  ~[~nec ~bud]
      =/  wach=(list card)
        %+  turn  ships.act
        |=  who=ship
        =/  w=wire  /ready/(scot %p who)
        (~(watch-our pass:io w) %pyro w)
      =/  init=(list card)
        :_  ~
        %+  ~(poke-our pass:io /self-wire)  %pyro
        :-  %aqua-events
        !>((turn ships.act |=(who=ship [%init-ship who])))
      =/  subs=(list card)  ::  start %subscriber app
        %+  turn  ships.act
        |=  who=ship
        %+  ~(poke-our pass:io /self-wire)  %pyro
        :-  %aqua-events
        !>((dojo-events:pyro who "|start %zig %subscriber"))
      :-  :(weld wach init subs)
      %_    state
          pyro-ships-ready
        %-  ~(gas by *(map ship ?))
        (turn ships.act |=(=ship [ship %.n]))
      ==
    ::
        %start-pyro-snap
      :_  state(pyro-ships-ready ~)
      :+  (~(watch-our pass:io /restore) /effect/restore)
        %+  ~(poke-our pass:io /self-wire)  %pyro
        [%pyro-action !>([%restore-snap snap.act])]
      ~
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
      :^    (~(arvo pass:io /save-wire) %c [docket-task])
          %-  make-compile-contracts:zig-lib
          [project request-id]:act
        %+  ~(poke-our pass:io /treaty-wire)  %treaty
        [%alliance-update-0 !>([%add our.bowl `@tas`project.act])]
      ~
    ::
        %add-user-file
      =/  =project:zig  (~(got by projects) project.act)
      =.  user-files.project  (~(put in user-files.project) file.act)
      :_
        %=  state
          projects  (~(put by projects) project.act project)
        ==
      :_  ~
      %+  update-vase-to-card:zig-lib  project.act
      %.  file.act
      %~  add-user-file  make-update-vase:zig-lib
      update-info
    ::
        %delete-user-file
      =/  =project:zig  (~(got by projects) project.act)
      =.  user-files.project  (~(del in user-files.project) file.act)
      :_
        %=  state
          projects  (~(put by projects) project.act project)
        ==
      :_  ~
      %+  update-vase-to-card:zig-lib  project.act
      %.  file.act
      %~  delete-user-file  make-update-vase:zig-lib
      update-info
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
      =/  =project:zig  (~(got by projects) project-name)
      =/  =test:zig     (~(got by tests.project) test-id)
      =/  test-results-error
        %~  test-results  make-error-vase:zig-lib
        [[project-name %ziggurat-test-run-thread-fail ~] %error]
      ?+    p.cage.sign  (on-agent:def w sign)
          %thread-fail
        :_  this(test-running |)
        :_  ~
        %+  update-vase-to-card:zig-lib  project-name
        %+  test-results-error  'thread crashed'
        [test-id tid steps.test]
      ::
          %thread-done
        =+  !<(result=(each test-results:zig @t) q.cage.sign)
        ?:  ?=(%| -.result)
          =/  message=tape
            "thread fail with error: {<p.result>}"
          :_  this(test-running |)
          :_  ~
          %+  update-vase-to-card:zig-lib  project-name
          %+  test-results-error  (crip message)
          [test-id tid steps.test]
        =*  test-results  p.result
        =/  =shown-test-results:zig
          (show-test-results:zig-lib test-results)
        ~&  >  "%ziggurat: test done {<test-id>}"
        ~&  >  shown-test-results
        =.  tests.project
          %+  ~(put by tests.project)  test-id
          test(results test-results)
        =/  cards=(list card)
          :_  ~
          %+  update-vase-to-card:zig-lib  project-name
          %.  [shown-test-results test-id tid steps.test]
          %~  test-results  make-update-vase:zig-lib
          [project-name %ziggurat-test-run-thread-done ~]
        =?  cards  ?=(^ test-queue)
          %+  snoc  cards
          %-  ~(poke-self pass:io /self-wire)
          :-  %ziggurat-action
          !>(`action:zig`project-name^~^[%run-queue ~])
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
        (~(leave-our pass:io /ready/(scot %p who)) %pyro)
      ?~  test-queue                         [leave^~ this]
      ?.  (~(all by pyro-ships-ready) same)  [leave^~ this]
      :_  this
      :^    leave
          %-  ~(poke-self pass:io /self-wire)
          [%ziggurat-action !>(`action:zig`%$^~^[%run-queue ~])]
        %+  update-vase-to-card:zig-lib  ''
        %.  pyro-ships-ready
        %~  pyro-ships-ready  make-update-vase:zig-lib
        ['' %pyro-ships-ready ~]
      ~
    ==
  ::
      [%restore ~]
    ?+    -.sign  (on-agent:def w sign)
        %fact
      :_  this(pyro-ships-ready [[~nec %.y] ~ ~]) :: XX extremely hacky
      (~(leave-our pass:io /restore) %pyro)^~
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
      (make-read-desk:zig-lib project-name ~)
    (make-compile-contracts:zig-lib project-name ~)
  ==
::
++  on-peek
  |=  p=path
  ^-  (unit (unit cage))
  ?.  =(%x -.p)  ~
  =,  format
  ?+    +.p  (on-peek:def p)
      [%project-names ~]
    :^  ~  ~  %ziggurat-update
    !>  ^-  update:zig
    :^  %project-names  ['' %project-names ~]  [%& ~]
    ~(key by projects)
  ::
      [%projects ~]
    :^  ~  ~  %ziggurat-update
    %.  projects
    ~(projects make-update-vase:zig-lib ['' %projects ~])
  ::
      [%project @ ~]
    =*  project-name  i.t.t.p
    =/  project=(unit project:zig)
      (~(get by projects) project-name)
    :^  ~  ~  %ziggurat-update
    ?~  project  !>(`update:zig`~)
    %.  u.project
    ~(project make-update-vase:zig-lib [project-name %project ~])
  ::
      [%pyro-ships-ready ~]
    :^  ~  ~  %ziggurat-update
    %.  pyro-ships-ready
    %~  pyro-ships-ready  make-update-vase:zig-lib
    ['' %pyro-ships-ready ~]
  ::
  ::
      [%state @ ~]
    =*  project-name  i.t.t.p
    =/  project=(unit project:zig)
      (~(get by projects) project-name)
    :^  ~  ~  %ziggurat-update
    !>  ^-  update:zig
    ?~  project  ~
    :^  %state  [project-name %state ~]  [%& ~]
    (get-state:zig-lib project-name u.project configs)
  ::
      [%custom-step-compiled @ @ @ ~]
    =*  project-name  i.t.t.p
    =*  test-id       i.t.t.t.p
    =*  tag           `@tas`i.t.t.t.t.p
    =/  =project:zig  (~(got by projects) project-name)
    =/  =test:zig
      (~(got by tests.project) (slav %ux test-id))
    =/  custom-step-error
      %~  custom-step-compiled  make-error-vase:zig-lib
      [[project-name %custom-step-compiled ~] %error]
    ?~  def=(~(get by custom-step-definitions.test) tag)
      =/  message=tape
        %+  weld  "did not find {<tag>} custom-step-definition"
        " in {<~(key by custom-step-definitions.test)>}"
      :^  ~  ~  %ziggurat-update
      %+  custom-step-error  (crip message)
      [(slav %ux test-id) tag]
    ?:  ?=(%| -.q.u.def)  ::  TODO: do better
      =/  message=tape
        %+  weld  "compilation of {<tag>} failed; fix and"
        "try again. error message: {<p.q.u.def>}"
      :^  ~  ~  %ziggurat-update
      %+  custom-step-error  (crip message)
      [(slav %ux test-id) tag]
    ``noun+!>(`vase`p.q.u.def)
  ::
  ::     [%project-tests @ ~]
  ::   ?~  project=(~(get by projects) i.t.t.p)
  ::     ``json+!>(~)
  ::   ``json+!>((tests:enjs:zig-lib tests.u.project))
  :: ::
  ::     [%project-user-files @ ~]
  ::   ?~  project=(~(get by projects) i.t.t.p)
  ::     ``json+!>(~)
  ::   :^  ~  ~  %json
  ::   !>  ^-  json
  ::   %+  frond:enjs:format  %user-files
  ::   (dir:enjs:zig-lib ~(tap in user-files.u.project))
  ::
      [%dashboard @ @ @ ~]
    =*  project-name  i.t.t.p
    =*  who           i.t.t.t.p
    =*  app           `@tas`i.t.t.t.t.p
    =/  dashboard-error
      %~  dashboard  make-error-vase:zig-lib
      [[project-name %dashboard ~] %error]
    :^  ~  ~  %ziggurat-update
    ?~  project=(~(get by projects) project-name)
      %-  dashboard-error
      %-  crip
      %+  weld  "project {<project-name>} not found;"
      " must register project with %new-project"
    ?~  dbug=(~(get by dbug-dashboards.u.project) app)
      %-  dashboard-error
      %-  crip
      %+  weld  "app {<app>} not found; must add app to"
      " dashboard with %add-app-to-dashboard"
    ?:  ?=(%| -.mold.u.dbug)
      %-  dashboard-error
      %-  crip
      ;:  weld
          "app {<app>} subject failed to build; fix sur"
          " file path and re-add with %add-app-to-dashboard."
          " error message from build: {<p.mold.u.dbug>}"
      ==
    =/  now=@ta  (scot %da now.bowl)
    =/  dbug-noun=*
      .^  *
          %gx
          %+  weld  /(scot %p our.bowl)/pyro/[now]/i/[who]
          /gx/[who]/[app]/[now]/dbug/state/noun/noun
      ==
    ?.  ?=(^ dbug-noun)
      %-  dashboard-error
      'dbug scry failed: unexpected result from pyro'
    =*  mar-tube   mar-tube.u.dbug
    =*  dbug-mold  p.mold.u.dbug
    =/  dbug-vase=vase  (slym dbug-mold +.+.dbug-noun)
    %-  %~  dashboard  make-update-vase:zig-lib
        [project-name %dashboard ~]
    %+  frond:enjs:format  %state
    ?~  mar-tube  [%s (crip (noah dbug-vase))]
    !<(json (u.mar-tube dbug-vase))
  ::
      [%file-exists @ ^]
    =/  des=@ta    i.t.t.p
    =/  pat=path  `path`t.t.t.p
    =/  pre=path  /(scot %p our.bowl)/(scot %tas des)/(scot %da now.bowl)
    ``json+!>(`json`[%b .^(? %cu (weld pre pat))])
  ::
      [%test-queue ~]
    ``noun+!>(test-queue)
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
