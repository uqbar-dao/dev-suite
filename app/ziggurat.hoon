::  ziggurat [UQ| DAO]
::
::  Contract Playground
::
/-  spider,
    pyro=zig-pyro,
    zig=zig-ziggurat
/+  agentio,
    dbug,
    default-agent,
    mip,
    verb,
    conq=zink-conq,
    dock=docket,
    engine=zig-sys-engine,
    pyro-lib=zig-pyro,
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
  =*  wes-address
    0x5da4.4219.e382.ad70.db07.0a82.12d2.0559.cf8c.b44d
  :-  :_  ~
      %.  (add now.bowl ~s1)
      ~(wait pass:io /on-init-zig-setup)
  %_    this
      state
    :_  [eng smart-lib ~]
    :*  %0
        ~
    ::
        %+  ~(put by *configs:zig)  'global'
        %-  ~(gas by *config:zig)
        :^    [[~nec %address] nec-address]
            [[~bud %address] bud-address]
          [[~wes %address] wes-address]
        ~
    ::
        ~
        ''
        ~
        ~
        :: ~
        ~
        :: %.n
        :: ~
        [%uninitialized ~]
    ==
  ==
::
++  on-save  !>(-.state)
::
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
      %^  compile-test-imports:zig-lib  `@tas`project-name
      ~(tap by imports)  state
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
    =.  test-queue
      (~(put to test-queue) project-name test-id)
    :_  %=  state
            projects
          (~(put by projects) project-name project)
        ==
    :_  cards
    %+  update-vase-to-card:zig-lib  project-name
    %.  test-queue
    %~  test-queue  make-update-vase:zig-lib
    [project-name %add-and-queue-test request-id]
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
    =/  [imports=(list [face=@tas =path]) payload=hoon]
      (parse-pile:conq file-scry-path (trip file-cord))
    =^  subject=(each vase @t)  state
      %^  compile-test-imports:zig-lib  `@tas`project-name
      imports  state
    ?:  ?=(%| -.subject)
      =/  message=tape
        "compilation of test-imports failed: {<p.subject>}"
      :_  state
      :_  *test:zig
      :_  ~
      %+  update-vase-to-card:zig-lib  project-name
      (add-test-error (crip message) 0x0)
    =/  test-steps-compilation-result=(each vase @t)
      (compile-and-call-arm:zig-lib '$' p.subject payload)
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
    =.  test-queue
      (~(put to test-queue) project-name test-id)
    :_  %=  state
            projects
          (~(put by projects) project-name project)
        ==
    :+  %+  update-vase-to-card:zig-lib  project-name
        %.  test-queue
        %~  test-queue  make-update-vase:zig-lib
        [project-name %add-and-queue-test-file request-id]
      %+  update-vase-to-card:zig-lib  project-name
      %.  [test test-id]
      %~  add-test  make-update-vase:zig-lib
      [project-name %add-and-queue-test-file request-id]
    cards
  ::
  ++  start-ships-then-rerun
    |=  $:  ships-to-run=(list @p)
            project-name=@t
            request-id=(unit @t)
        ==
    ^-  (quip card _state)
    :_  state
    :+  %+  ~(poke-self pass:io /self-wire)  m
        !>  ^-  action:zig
        :^  project-name  request-id  %start-pyro-ships
        ships-to-run
      (~(poke-self pass:io /self-wire) m v)
    ~
  ::
  ++  handle-poke
    |=  act=action:zig
    ^-  (quip card _state)
    ?>  =(our.bowl src.bowl)
    =*  tag  -.+.+.act
    ?:  =(tag %cis-panic) 
      ~^state(status [%ready ~])
    =/  =update-info:zig  [project.act tag request-id.act]
    ?:  ?|  ?&  ?=(%commit-install-starting -.status)
                !=(0 ~(wyt by cis-running.status))
                ?|  ?=(~ request-id.act)
                ::
                    ?!
                    %.  u.request-id.act
                    %~  has  in
                    %-  ~(gas in *(set @t))
                    ~(val by cis-running.status)
            ==  ==
        ::
            :: %changing-project-links
        ==
      :_  state
      :_  ~
      %+  update-vase-to-card:zig-lib  project.act
      %.  'currently setting up new project; try again later'
      %~  poke  make-error-vase:zig-lib
      [update-info %error]
    ?-    tag
        %new-project
      =/  new-project-error
        %~  new-project  make-error-vase:zig-lib
        [update-info %error]
      ?:  =('global' project.act)
        =/  message=tape
          "{<`@tas`project.act>} face reserved"
        :_  state
        :_  ~
        %+  update-vase-to-card:zig-lib  project.act
        (new-project-error (crip message))
      ?:  &(=(0 ~(wyt by projects)) =('zig' project.act))
        =.  projects  (~(put by projects) 'zig' *project:zig)
        %+  start-ships-then-rerun  default-ships:zig-lib
        [project request-id]:act
      =/  snap-cards=(list card)
        :_  ~
        %+  ~(poke-our pass:io /pyro-poke)  %pyro
        :-  %pyro-action
        !>  ^-  action:pyro
        [%restore-snap default-snap-path:zig-lib]
      =.  snap-cards
        ?:  =('zig' project.act)   ~
        ?:  =('' focused-project)  snap-cards
        =/  current-links=@t
          %-  crip
          %-  noah
          !>  ^-  (set @t)
          (~(get ju linked-projects) focused-project)
        :_  snap-cards
        %+  ~(poke-our pass:io /pyro-poke)  %pyro
        :-  %pyro-action
        !>  ^-  action:pyro
        :+  %snap-ships  /[current-links]/(scot %da now.bowl)
        pyro-ships:(~(got by projects) focused-project)
      =/  desks=(set desk)
        .^  (set desk)
            %cd
            /(scot %p our.bowl)/[dap.bowl]/(scot %da now.bowl)
        ==
      ?:  (~(has in desks) project.act)
        =/  [cards=(list card) cfo=(unit configuration-file-output:zig) modified-state=_state]
          %+  load-configuration-file:zig-lib  update-info
          %=  state
              projects
            (~(put by projects) project.act *project:zig)
          ==
        :: =/  ships-to-run=(list @p)  :: TODO
        ::   %~  tap  in
        ::   %.  default-ships:zig-lib
        ::   %~  dif  in
        ::   %-  ~(gas in *(set @p))
        ::   ?^(cfo ships.u.cfo default-ships:zig-lib)
        :: ?^  ships-to-run
        ::   %+  start-ships-then-rerun  ships-to-run
        ::   [project request-id]:act
        ::
        :: ?:  (~(has by projects) project.act)
        ::   =.  projects  (~(del by projects) project.act)
        ::   =.  focused-project
        ::     ?:  =(project.act focused-project)  ''
        ::     focused-project
        ::   :_  state
        ::   :_  ~
        ::   (~(poke-self pass:io /self-wire) m v)
        =/  request-id=@t
          ?>  ?=(%commit-install-starting -.status.modified-state)
          %-  ~(got by cis-running.status.modified-state)
          -:?^(cfo ships.u.cfo default-ships:zig-lib)
        :_  modified-state
        :+  (make-read-desk:zig-lib project.act `request-id)
          %+  update-vase-to-card:zig-lib  project.act
          %.  sync-desk-to-vship
          %~  new-project  make-update-vase:zig-lib
          update-info
        (weld snap-cards cards)
      :: =/  ships-to-run=(list @p)
      ::   %~  tap  in
      ::   %-  ships-not-yet-running-to-run
      ::   (~(gas in *(set @p)) default-ships:zig-lib)
      :: ?^  ships-to-run
      ::   %+  start-ships-then-rerun  ships-to-run
      ::   [project request-id]:act
      =.  sync-desk-to-vship
        %-  ~(gas ju sync-desk-to-vship)
        %+  turn  sync-ships.act
        |=(who=@p [project.act who])
      ::  merge new desk, mount desk
      ::  currently using ziggurat desk as template -- should refine this
      =/  merge-task  [%merg `@tas`project.act our.bowl q.byk.bowl da+now.bowl %init]
      =/  mount-task  [%mont `@tas`project.act [our.bowl `@tas`project.act da+now.bowl] /]
      =/  bill-task   [%info `@tas`project.act %& [/desk/bill %ins %bill !>(~[project.act])]~]
      =/  deletions-task  [%info `@tas`project.act %& (clean-desk:zig-lib project.act)]
      :-  %+  welp  snap-cards
          :~  [%pass /merge-wire/[project.act]/(scot %ud (jam sync-ships.act)) %arvo %c merge-task]
              [%pass /mount-wire %arvo %c mount-task]
              [%pass /save-wire %arvo %c bill-task]
              [%pass /save-wire %arvo %c deletions-task]
              (make-read-desk:zig-lib [project request-id]:act)
          ::
              %+  update-vase-to-card:zig-lib  project.act
              %.  sync-desk-to-vship
              %~  new-project  make-update-vase:zig-lib
              update-info
          ::
              :: %+  update-vase-to-card:zig-lib  project.act  ::  TODO: replace with status update?
              :: %~  cis-setup-done  make-update-vase:zig-lib
              :: update-info
          ==
      %=  state
          configs  ::  TODO: generalize: read in configuration file
        %^  ~(put bi:mip configs)  project.act
        [~nec %sequencer]  0x0
      ::
          projects
        %+  ~(put by projects)  project.act
        :*  dir=~  ::  populated by +make-read-desk / %read-desk
            user-files=(~(put in *(set path)) /app/[project.act]/hoon)
            to-compile=~
            tests=~
            pyro-ships=default-ships:zig-lib
            saved-test-queue=~
        ==
      ==
    ::
        %delete-project
      ::  should show a warning on frontend before performing this one ;)
      `state(projects (~(del by projects) project.act))
    ::
        %cis-panic  :: we handle this above, not here. ignore
      ~^state
    ::
        %save-config-to-file
      ::  frontend should warn about overwriting
      =/  file-text=@t
        %-  make-configs-file:zig-lib
        %-  build-default-configuration:zig-lib
        (~(got by configs) project.act)
      =/  file-path=path  /zig/configs/[project.act]/hoon
      :_  state
      :+  %^  make-save-file:zig-lib  project.act
          file-path  file-text
        (make-read-desk:zig-lib [project request-id]:act)
      ~
    ::
        %add-sync-desk-vships
      =*  desk         project.act
      =*  ships        ships.act
      =*  install      install.act
      =*  start-apps   start-apps.act
      =^  cards  state
        (handle-poke project.act^request-id.act^%read-desk^~)
      =.  status
        :-  %commit-install-starting
        (make-cis-running:zig-lib ships desk)
      :_  %=  state
              sync-desk-to-vship
            %-  ~(gas ju sync-desk-to-vship)
            %+  turn  ships
            |=(who=@p [desk who])
          ==
      :-  %+  update-vase-to-card:zig-lib  desk
          %.  status
          %~  status  make-update-vase:zig-lib
          update-info
      |-
      ?~  ships.act  cards
      =*  who   i.ships
      =/  cis-cards=(list card)
        %~  do-commit  cis:zig-lib
        [who desk install start-apps status]
      %=  $
          ships.act  t.ships.act
          cards      (weld cards cis-cards)
      ==
    ::
        %delete-sync-desk-vships
      :-  (make-cancel-watch-for-file-changes:zig-lib)^~
      %=  state
          sync-desk-to-vship
        |-
        ?~  ships.act  sync-desk-to-vship
        %=  $
            ships.act  t.ships.act
        ::
            sync-desk-to-vship
          %-  ~(del ju sync-desk-to-vship)
          [project i.ships]:act
        ==
      ==
    ::
        %change-focus
      =/  old=@t           focused-project
      =*  new=@t           project.act
      =.  focused-project  new
      ?:  (~(has ju linked-projects) old new)  `state
      =/  old-project=project:zig  (~(got by projects) old)
      =/  old-links=(set @t)
        (~(get ju linked-projects) old)
      =/  old-snap-path=path
        :-  (crip (noah !>(`(set @t)`old-links)))
        /(scot %da now.bowl)
      =*  new-snap-path=path
        %-  ~(got by unfocused-project-snaps)
        (~(get ju linked-projects) new)
      =.  unfocused-project-snaps
        %+  ~(put by unfocused-project-snaps)  old-links
        old-snap-path
      :_  state
      :+  %+  ~(poke-our pass:io /pyro-wire)  %pyro
          :-  %pyro-action
          !>  ^-  action:pyro
          [%snap-ships old-snap-path pyro-ships.old-project]
        %+  ~(poke-our pass:io /pyro-wire)  %pyro
        :-  %pyro-action
        !>  ^-  action:pyro
        [%restore-snap new-snap-path]
      ~
    ::
        %add-project-link
      =*  project-a=@t  focused-project
      =*  project-b=@t  project.act
      =/  new-links=(set @t)
        %.  (~(get ju linked-projects) project-b)
        ~(uni in (~(get ju linked-projects) project-a))
      =.  linked-projects
        %-  ~(gas by linked-projects)
        %+  turn  ~(tap in new-links)
        |=  project-name=@t
        [project-name new-links]
      !!
    ::
        %delete-project-link  !!  :: TODO
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
        %^  ~(put bi:mip configs)  project.act
        [who what]:act  item.act
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
        (~(del bi:mip configs) project.act [who what]:act)
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
        (~(got bi:mip configs) 'global' [u.who %address])
      =/  test-name=@tas  `@tas`(rap 3 %deploy path.act)
      =/  imports=(list [@tas path])
        :+  [%indexer /sur/zig/indexer]
          [%zig /sur/zig/ziggurat]
        ~
      =^  subject=(each vase @t)  state
        %^  compile-test-imports:zig-lib  `@tas`project.act
        imports  state
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
      =.  test-queue
        (~(put to test-queue) project.act test-id)
      :_  %=  state
              projects
            (~(put by projects) project.act project)
          ==
      :^    (make-run-queue:zig-lib [project request-id]:act)
          %+  update-vase-to-card:zig-lib  project.act
          %.  test-queue
          ~(test-queue make-update-vase:zig-lib update-info)
        %+  update-vase-to-card:zig-lib  project.act
        %.  [test test-id]
        %~  add-test  make-update-vase:zig-lib
        update-info
      (weld cards all-cards)
    ::
        %compile-contracts
      ::  for internal use -- app calls itself to scry clay
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
      =/  =project:zig  (~(got by projects) project.act)
      =.  dir.project
        =-  .^((list path) %ct -)
        /(scot %p our.bowl)/(scot %tas project.act)/(scot %da now.bowl)
      :_  %=  state
              projects
            (~(put by projects) project.act project)
          ==
      :+  %+  make-watch-for-file-changes:zig-lib
          project.act  dir.project
        %+  update-vase-to-card:zig-lib  project.act
        %.  dir.project
        %~  dir  make-update-vase:zig-lib
        update-info
      ~
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
      =?  cards  !?=(%running-test-steps -.status)
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
      :-  :+  %^  make-save-file:zig-lib  project.act
                  path.act  file-text
            (make-read-desk:zig-lib [project request-id]:act)
           ~
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
      =?  cards  !?=(%running-test-steps -.status)
        %+  snoc  cards
        (make-run-queue:zig-lib [project request-id]:act)
      [cards state]
    ::
        %add-and-queue-test-file
      %-  add-and-queue-test-file
      [project name path request-id]:act
    ::
        %edit-test
      =/  =project:zig  (~(got by projects) project.act)
      =^  [cards=(list card) =test:zig]  state
        (add-test [project name test-imports test-steps request-id]:act)
      ?:  =(*test:zig test)
        :_  state  ::  encountered error
        ?~  cards  ~
        ~[(add-test-error-to-edit-test:zig-lib i.cards)]
      =*  test-id  id.act
      =.  tests.project  (~(put by tests.project) test-id test)
      :_  %=  state
              projects
            (~(put by projects) project.act project)
          ==
      :_  (slag 1 cards)
      %+  update-vase-to-card:zig-lib  project.act
      %.  [test test-id]
      %~  edit-test  make-update-vase:zig-lib
      update-info
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
      =.  test-queue  (~(put to test-queue) [project id]:act)
      =/  cards=(list card)
        :+  %+  update-vase-to-card:zig-lib  project.act
            %.  test-queue
            %~  test-queue  make-update-vase:zig-lib
            update-info
          %+  update-vase-to-card:zig-lib  project.act
          ~(run-queue make-update-vase:zig-lib update-info)
        ~
      :_  state
      ?:  !?=(%running-test-steps -.status)
        %+  snoc  cards
        (make-run-queue:zig-lib [project request-id]:act)
      ~&  >  "%ziggurat: another test is running, adding to queue"
      cards
    ::
        %run-queue
      =/  run-queue-error
        %~  run-queue  make-error-vase:zig-lib
        [update-info %error]
      =/  s=status:zig  status  ::  TODO: remove this hack
      ?-    -.s
          %changing-project-links   !!
          %commit-install-starting  !!
          %uninitialized
        =/  message=tape
          "must run %start-pyro-ships before tests"
        :_  state
        :_  ~
        %+  update-vase-to-card:zig-lib  project.act
        (run-queue-error(level %warning) (crip message))
      ::
          %running-test-steps
        =/  message=tape  "queue already running"
        :_  state
        :_  ~
        %+  update-vase-to-card:zig-lib  project.act
        (run-queue-error(level %info) (crip message))
          %ready
        ?:  =(~ test-queue)
          =/  message=tape  "no tests in queue"
          :_  state
          :_  ~
          %+  update-vase-to-card:zig-lib  project.act
          (run-queue-error(level %warning) (crip message))
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
              default-ships:zig-lib  :: TODO: remove hardcode and allow input of for-snapshot
          ==
        =/  w=wire
          /test/[next-project-name]/(scot %ux next-test-id)/[tid]
        =.  status  [%running-test-steps ~]
        :_  state
        :-  %+  update-vase-to-card:zig-lib  project.act
            %.  status
            %~  status  make-update-vase:zig-lib
            update-info
        :^    %+  update-vase-to-card:zig-lib  project.act
              %.  test-queue
              %~  test-queue  make-update-vase:zig-lib
              update-info
            %+  ~(watch-our pass:io w)  %spider
            /thread-result/[tid]
          %+  ~(poke-our pass:io w)  %spider
          [%spider-start !>(start-args)]
        ~
      ==
    ::
        %clear-queue
      =.  test-queue  ~
      :_  state
      :_  ~
      %+  update-vase-to-card:zig-lib  project.act
      %.  test-queue
      ~(test-queue make-update-vase:zig-lib update-info)
    ::
        %queue-test
      =.  test-queue
        (~(put to test-queue) [project.act id.act])
      :_  state
      :_  ~
      %+  update-vase-to-card:zig-lib  project.act
      %.  test-queue
      ~(test-queue make-update-vase:zig-lib update-info)
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
        %stop-pyro-ships
      =/  =project:zig  (~(got by projects) project.act)
      =.  projects
        %+  ~(put by projects)  project.act
        project(pyro-ships ~)
      =.  status  [%uninitialized ~]
      :_  state
      :_  ~
      %+  update-vase-to-card:zig-lib  project.act
      %.  status
      %~  status  make-update-vase:zig-lib
      update-info
    ::
        %start-pyro-ships
      =/  =project:zig
        (~(gut by projects) project.act *project:zig)
      =?  ships.act  ?=(~ ships.act)  ~[~nec ~bud ~wes]
      =.  pyro-ships.project
        (weld pyro-ships.project ships.act)
      =.  projects
        (~(put by projects) project.act project)
      :_  state
      %+  turn  ships.act
      |=  who=@p
      %+  ~(poke-our pass:io /self-wire)  %pyro
      [%pyro-action !>([%init-ship who])]
    ::
        %start-pyro-snap  !!  ::  TODO
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
    ::
        %send-pyro-dojo
      :_  state
      (send-pyro-dojo:zig-lib [who command]:act)^~
    ::
        %pyro-agent-state
      =/  who=@ta  (scot %p who.act)
      =*  app      app.act
      =*  grab     grab.act
      =/  now=@ta  (scot %da now.bowl)
      =/  agent-state-noun=*
        .^  *
            %gx
            :-  (scot %p our.bowl)
            %+  weld  /pyro/[now]/i/[who]/gx/[who]/subscriber
            /[now]/agent-state/[app]/[grab]/noun/noun
        ==
      :_  state
      :_  ~
      %+  update-vase-to-card:zig-lib  project.act
      ?~  agent-state-noun
        %.  (crip "scry for /{<who>}/{<app>} failed")
        %~  pyro-agent-state  make-error-vase:zig-lib
        [['' %pyro-agent-state ~] %error]
      =/  [agent-state=@t wex=boat:gall sup=bitt:gall]
        %-  need
        ;;((unit [@t boat:gall bitt:gall]) agent-state-noun)
      %.  [agent-state wex sup]
      %~  pyro-agent-state  make-update-vase:zig-lib
      ['' %pyro-agent-state ~]
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
        =.  status  [%ready ~]
        :_  this
        :+  %+  update-vase-to-card:zig-lib  project-name
            %+  test-results-error  'thread crashed'
            [test-id tid steps.test]
          %+  update-vase-to-card:zig-lib  project-name
          %.  status
          %~  status  make-update-vase:zig-lib
          [project-name %ziggurat-test-run-thread-crash ~]
        ~
      ::
          %thread-done
        =+  !<(result=(each test-results:zig @t) q.cage.sign)
        ?:  ?=(%| -.result)
          =/  message=tape
            "thread fail with error: {<p.result>}"
          =.  status  [%ready ~]
          :_  this
          :+  %+  update-vase-to-card:zig-lib  project-name
              %+  test-results-error  (crip message)
              [test-id tid steps.test]
            %+  update-vase-to-card:zig-lib  project-name
            %.  status
            %~  status  make-update-vase:zig-lib
            [project-name %ziggurat-test-run-thread-fail ~]
          ~
        =*  test-results  p.result
        =/  =shown-test-results:zig
          (show-test-results:zig-lib test-results)
        ~&  >  "%ziggurat: test done {<test-id>}"
        ~&  >  shown-test-results
        =.  tests.project
          %+  ~(put by tests.project)  test-id
          test(results test-results)
        =.  status  [%ready ~]
        =/  cards=(list card)
          :+  %+  update-vase-to-card:zig-lib  project-name
              %.  [shown-test-results test-id tid steps.test]
              %~  test-results  make-update-vase:zig-lib
              [project-name %ziggurat-test-run-thread-done ~]
            %+  update-vase-to-card:zig-lib  project-name
            %.  status
            %~  status  make-update-vase:zig-lib
            [project-name %ziggurat-test-run-thread-done ~]
          ~
        =?  cards  ?=(^ test-queue)
          %+  weld  cards
          :+  %-  ~(poke-self pass:io /self-wire)
              :-  %ziggurat-action
              !>(`action:zig`project-name^~^[%run-queue ~])
            %+  update-vase-to-card:zig-lib  project-name
            %~  run-queue  make-update-vase:zig-lib
            [project-name %ziggurat-test-run-thread-done ~]
          ~
        :-  cards
        %=  this
          projects  (~(put by projects) project-name project)
        ==
      ==
    ==
  ::
      [%cis-setup-done @ @ @ @ ~]
    ?.  ?=(%fact -.sign)  (on-agent:def w sign)
    =/  who=@p            (slav %p i.t.w)
    =*  desk              i.t.t.w
    =/  install=?         ;;  ?  (slav %ud i.t.t.t.w)
    =/  apps=(list @tas)
      ;;  (list @tas)  (cue (slav %ud i.t.t.t.t.w))
    =/  initial-links=(set @t)
      (~(put in *(set @t)) desk)  ::  self only
    :-  :-  %+  ~(poke-our pass:io /pyro-wire)  %pyro
            :-  %pyro-action
            !>  ^-  action:pyro
            :+  %snap-ships  default-snap-path:zig-lib
            default-ships:zig-lib
        %.  cage.sign
        %~  on-update-setup-done  cis:zig-lib
        [who desk install apps status]
    %=  this
        status  [%ready ~]
        focused-project
      ?:(=('' focused-project) desk focused-project)
    ::
        linked-projects
      (~(put by linked-projects) desk initial-links)
    ::
        unfocused-project-snaps
      %+  ~(put by unfocused-project-snaps)  initial-links
      default-snap-path:zig-lib
    ==
  ==
::
++  on-arvo
  |=  [w=wire =sign-arvo:agent:gall]
  ^-  (quip card _this)
  ?+    w  (on-arvo:def w sign-arvo)
      [%on-init-zig-setup ~]
    =*  our  (scot %p our.bowl)
    =*  now  (scot %da now.bowl)
    :_  this
    ?:  .^(? %gu /[our]/subscriber/[now])  ~
    :_  ~
    %-  ~(poke-self pass:io /self-wire)
    :-  %ziggurat-action
    !>(`action:zig`[%zig ~ %new-project ~])
  ::
      [%merge-wire @ @ ~]
    ?.  ?=(%clay -.sign-arvo)  !!
    ?.  ?=(%mere -.+.sign-arvo)  !!
    ?:  -.p.+.sign-arvo
      =*  project-name  i.t.w
      =/  sync-ships=(list @p)
        ;;  (list @p)  (cue (slav %ud i.t.t.w))
        :_  this
        %+  turn  sync-ships
        |=  who=@p
        (sync-desk-to-virtualship:zig-lib who project-name)
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
    :-  ?:  .=  0
            %~  wyt  in
            (~(int in updated-files) to-compile.project)
          (make-read-desk:zig-lib project-name ~)
        (make-compile-contracts:zig-lib project-name ~)
    %+  turn
      %~  tap  in
      (~(get ju sync-desk-to-vship) project-name)
    |=  who=@p
    (sync-desk-to-virtualship:zig-lib who project-name)
  ::
      [%committing @ @ @ @ ~]
    ?>  ?=([%behn %wake *] sign-arvo)
    ?^  error.sign-arvo  !!  ::  TODO: do better
    =/  who=@p            (slav %p i.t.w)
    =*  desk              i.t.t.w
    =/  install=?         ;;  ?  (slav %ud i.t.t.t.w)
    =/  apps=(list @tas)
      ;;  (list @tas)  (cue (slav %ud i.t.t.t.t.w))
    =^  cards  status
      %~  on-wake-commit  cis:zig-lib
      [who desk install apps status]
    [cards this]
  ::
      [%installing @ @ @ @ ~]
    ?>  ?=([%behn %wake *] sign-arvo)
    ?^  error.sign-arvo  !!  ::  TODO: do better
    =/  who=@p            (slav %p i.t.w)
    =*  desk              i.t.t.w
    =/  install=?         ;;  ?  (slav %ud i.t.t.t.w)
    =/  apps=(list @tas)
      ;;  (list @tas)  (cue (slav %ud i.t.t.t.t.w))
    =^  cards  status
      %~  on-wake-install  cis:zig-lib
      [who desk install apps status]
    [cards this]
  ::
      [%starting @ @ @ @ ~]
    ?>  ?=([%behn %wake *] sign-arvo)
    ?^  error.sign-arvo  !!  ::  TODO: do better
    =/  who=@p            (slav %p i.t.w)
    =*  desk              i.t.t.w
    =/  install=?         ;;  ?  (slav %ud i.t.t.t.w)
    =/  apps=(list @tas)
      ;;  (list @tas)  (cue (slav %ud i.t.t.t.t.w))
    =^  cards  status
      %~  on-wake-start  cis:zig-lib
      [who desk install apps status]
    [cards this]
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
      [%test-queue ~]
    :^  ~  ~  %ziggurat-update
    %.  test-queue
    %~  test-queue  make-update-vase:zig-lib
    ['' %test-queue ~]
  ::
      [%sync-desk-to-vship ~]
    :^  ~  ~  %ziggurat-update
    %.  sync-desk-to-vship
    %~  sync-desk-to-vship  make-update-vase:zig-lib
    ['' %sync-desk-to-vship ~]
  ::
      [%status ~]
    :^  ~  ~  %ziggurat-update
    %.  status
    %~  status  make-update-vase:zig-lib
    ['' %status ~]
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
      [%pyro-agent-state @ @ @ ~]
    =*  who      i.t.t.p
    =*  app      `@tas`i.t.t.t.p
    =*  grab     `@t`i.t.t.t.t.p
    =/  now=@ta  (scot %da now.bowl)
    =/  agent-state-noun=*
      .^  *
          %gx
          :-  (scot %p our.bowl)
          %+  weld  /pyro/[now]/i/[who]/gx/[who]/subscriber
          /[now]/agent-state/[app]/[grab]/noun/noun
      ==
    :^  ~  ~  %ziggurat-update
    ?~  agent-state-noun
      %.  (crip "scry for /{<who>}/{<app>} failed")
      %~  pyro-agent-state  make-error-vase:zig-lib
      [['' %pyro-agent-state ~] %error]
    =/  [agent-state=@t wex=boat:gall sup=bitt:gall]
      %-  need
      ;;((unit [@t boat:gall bitt:gall]) agent-state-noun)
    %.  [agent-state wex sup]
    %~  pyro-agent-state  make-update-vase:zig-lib
    ['' %pyro-agent-state ~]
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
  ::
      [%read-desks ~]
    =/  pat  /(scot %p our.bowl)/base/(scot %da now.bowl)
    :^  ~  ~  %json  !>
    ^-  json
    =/  desks  .^((set @t) %cd pat)
    (set-cords:enjs:zig-lib desks)
  ==
::
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--
