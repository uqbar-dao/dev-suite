::  ziggurat [UQ| DAO]
::
::  Contract Playground
::
/-  spider,
    pyro=zig-pyro,
    ui=zig-indexer,
    zig=zig-ziggurat,
    zink=zig-zink
/+  agentio,
    dbug,
    default-agent,
    mip,
    strandio,
    verb,
    conq=zink-conq,
    dock=docket,
    engine=zig-sys-engine,
    pyro-lib=pyro-pyro,
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
    strand   strand:spider
    zig-lib  ~(. ziggurat-lib bowl settings)
::
++  on-init
  =/  smart-lib=vase  ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
  =/  =eng:zig
    %~  engine  engine
    ::  sigs off, hints off
    [smart-lib ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun))) jets:zink %.y %.n]
  =*  nec-address
    0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70
  =*  bud-address
    0xd6dc.c8ff.7ec5.4416.6d4e.b701.d1a6.8e97.b464.76de
  =*  wes-address
    0x5da4.4219.e382.ad70.db07.0a82.12d2.0559.cf8c.b44d
  :-  :_  ~
      %.  (add now.bowl ~s5)
      ~(wait pass:io /on-init-zig-setup)
  %_    this
      state
    :_  [eng smart-lib ~]
    :*  %0
        ~
    ::
        %+  ~(put by *configs:zig)  'global'
        %-  ~(gas by *config:zig)
        :~  [[~nec %address] nec-address]
            [[~bud %address] bud-address]
            [[~wes %address] wes-address]
            [[~nec %sequencer] 0x0]
        ==
    ::
        ~
        ''
        ~
        ~
        ~
        [%uninitialized ~]
        [1.024 10.000 10 200]
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
    %~  engine  engine
    ::  sigs off, hints off
    [smart-lib ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun))) jets:zink %.y %.n]
  `this(state [!<(state-0:zig old-vase) eng smart-lib ~])
::
++  on-watch
  |=  p=path
  ^-  (quip card _this)
  ?+    p  (on-watch:def p)
      [%pyro-done ~]  `this
      [%project ~]    `this
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
      :_  state
      :_  *test:zig
      :_  ~
      %-  update-vase-to-card:zig-lib
      %+  add-test-error  0x0
      %-  crip
      %+  weld  "%zig face reserved for /sur/zig/ziggurat"
      "; got {<`(unit path)`zig-val>}"
    =^  subject=(each vase @t)  state
      %^  compile-test-imports:zig-lib  `@tas`project-name
      ~(tap by imports)  state
    ?:  ?=(%| -.subject)
      :_  state
      :_  *test:zig
      :_  ~
      %-  update-vase-to-card:zig-lib
      %+  add-test-error  0x0
      %^  cat  3  'compilation of test-imports failed:\0a'
      p.subject
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
    =.  all-cards  (weld cards all-cards)
    =^  cards=(list card)  test
      %+  add-custom-step:zig-lib  test
      :^  project-name  %deploy-contract
        /zig/custom-step-definitions/deploy-contract/hoon
      request-id
    :_  state
    :_  test
    :_  (weld cards all-cards)
    %-  update-vase-to-card:zig-lib
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
    %-  update-vase-to-card:zig-lib
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
      :_  state
      :_  *test:zig
      :_  ~
      %-  update-vase-to-card:zig-lib
      %+  add-test-error  0x0
      'test-steps path must not be empty'
    =/  =project:zig  (~(got by projects) project-name)
    =^  result  state
      (read-test-file:zig-lib project-name p state)
    ?:  ?=(%| -.result)
      :_  state
      :_  *test:zig
      :_  ~
      %-  update-vase-to-card:zig-lib
      (add-test-error 0x0 p.result)
    =*  imports     p.p.result
    =*  subject     q.p.result
    =*  test-steps  r.p.result
    =/  =test:zig
      :*  name
          p
          (~(gas by *test-imports:zig) imports)
          [%& subject]
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
    =.  all-cards  (weld cards all-cards)
    =^  cards=(list card)  test
      %+  add-custom-step:zig-lib  test
      :^  project-name  %deploy-contract
        /zig/custom-step-definitions/deploy-contract/hoon
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
    :+  %-  update-vase-to-card:zig-lib
        %.  test-queue
        %~  test-queue  make-update-vase:zig-lib
        [project-name %add-and-queue-test-file request-id]
      %-  update-vase-to-card:zig-lib
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
    =^  cards  state
      %-  handle-poke
      [project-name request-id %start-pyro-ships ships-to-run]
    :_  state
    %+  snoc  cards
    %.  (add now.bowl ~s1)
    %~  wait  pass:io
    /on-new-project-ship-rerun/[m]/(jam !<(action:zig v))
  ::
  ++  make-snap-cards
    |=  $:  project-name=@t
            request-id=(unit @t)
            state=_state
            ships=(set @p)
        ==
    ^-  [(list card) _state]
    =/  snap-cards=(list card)
      :_  ~
      %+  ~(poke-our pass:io /pyro-poke)  %pyro
      :-  %pyro-action
      !>  ^-  action:pyro
      [%restore-snap default-snap-path:zig-lib]
    =.  snap-cards
      ?:  =('zig' project-name)   ~
      ?:  =('' focused-project)  snap-cards
      =/  current-links=@t
        %-  crip
        %-  noah
        !>  ^-  (set @t)
        (~(get ju linked-projects) focused-project)
      :_  snap-cards
      %-  ~(poke-self pass:io /pyro-poke)
      :-  %ziggurat-action
      !>  ^-  action:zig
      [focused-project request-id %take-snapshot ~]
    =/  ships-to-run=(list @p)
      %~  tap  in
      (~(dif in ships) default-ships-set:zig-lib)
    ?~  ships-to-run  [snap-cards state]
    :_  %^  change-state-linked-projects:zig-lib
          project-name  state
        |=  p=project:zig
        p(pyro-ships (sort ~(tap in ships) lth))
    %+  weld  snap-cards
    %+  turn  ships-to-run
    |=  who=@p
    %+  ~(poke-our pass:io /self-wire)  %pyro
    [%pyro-action !>([%init-ship who])]
  ::
  ++  make-desk-setup-cards-state
    |=  [links-list=(list @t) =update-info:zig]
    ^-  [(list card) _state (mip:mip @t @p [@t ?])]
    =/  [cards=(list card) modified-state=_state project-cis-running=(mip:mip @t @p [@t ?]) ships=(set @p)]
      %+  roll  links-list
      |=  [project-name=@t [cards=(list card) modified-state=_state project-cis-running=(mip:mip @t @p [@t ?]) ships=(set @p)]]
      =/  [iteration-cards=(list card) cfo=(unit configuration-file-output:zig) modified-state=_state]
        %+  load-configuration-file:zig-lib
          update-info(project-name project-name)
        modified-state
      ?>  ?=(%commit-install-starting -.status.modified-state)
      =/  [request-id=@t ?]
        %-  ~(got by cis-running.status.modified-state)
        -:?^(cfo ships.u.cfo default-ships:zig-lib)
      :^    :_  (weld cards iteration-cards)
            (make-read-desk:zig-lib project-name `request-id)
          modified-state
        %+  ~(put by project-cis-running)  project-name
        cis-running.status.modified-state
      %-  ~(gas in ships)
      %+  weld  ?~(cfo ~ ships.u.cfo)
      =<  pyro-ships
      (~(gut by projects) project-name *project:zig)
    ~&  %z^%mdscs^ships
    =/  snap-cards=(list card)
      :_  ~
      %+  ~(poke-our pass:io /pyro-poke)  %pyro
      :-  %pyro-action
      !>  ^-  action:pyro
      [%restore-snap default-snap-path:zig-lib]
    =/  [snap-cards=(list card) modified-state=_state]
      =/  ships-to-run=(list @p)
        ~(tap in (~(dif in ships) default-ships-set:zig-lib))
      ?~  ships-to-run  [snap-cards modified-state]
      :_  %^  change-state-linked-projects:zig-lib
            project-name:update-info  state
          |=  p=project:zig
          p(pyro-ships (sort ~(tap in ships) lth))
      %+  weld  snap-cards
      %+  turn  ships-to-run
      |=  who=@p
      %+  ~(poke-our pass:io /self-wire)  %pyro
      [%pyro-action !>([%init-ship who])]
    :+  (weld snap-cards cards)  modified-state
    project-cis-running
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
                    %+  turn  ~(val by cis-running.status)
                    |=([cis-name=@t ?] cis-name)
            ==  ==
        ::
            ?&  ?=(%changing-project-links -.status)
                !=(0 ~(wyt by project-cis-running.status))
                ?|  ?=(~ request-id.act)
                ::
                    ?!
                    %.  u.request-id.act
                    %~  has  in
                    %-  ~(gas in *(set @t))
                    %+  turn
                      ~(tap bi:mip project-cis-running.status)
                    |=([@t @p cis-name=@t ?] cis-name)
                ==
            ==
        ==
      :_  state
      :_  ~
      %-  update-vase-to-card:zig-lib
      %-  %~  poke  make-error-vase:zig-lib
          [update-info %error]
      ?:  ?=(%commit-install-starting -.status)
        'setting up new project; try again later'
      'linking projects; try again later'
    ?-    tag
        %new-project
      =/  new-project-error
        %~  new-project  make-error-vase:zig-lib
        [update-info %error]
      ?:  =('global' project.act)
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %-  new-project-error
        (crip "{<`@tas`project.act>} face reserved")
      ?:  &(=(0 ~(wyt by projects)) =('zig' project.act))
        =.  projects  (~(put by projects) 'zig' *project:zig)
        %+  start-ships-then-rerun  default-ships:zig-lib
        [project request-id]:act
      =/  desks=(set desk)
        .^  (set desk)
            %cd
            /(scot %p our.bowl)/[dap.bowl]/(scot %da now.bowl)
        ==
      ?:  (~(has in desks) project.act)
        =/  [cards=(list card) cfo=(unit configuration-file-output:zig) modified-state=_state]
          =|  =project:zig
          =.  pyro-ships.project  default-ships:zig-lib
          %+  load-configuration-file:zig-lib  update-info
          %=  state
              projects
            (~(put by projects) project.act project)
          ::
              linked-projects
            %+  ~(put by linked-projects)  project.act
            (~(put in *(set @t)) project.act)
          ==
        :: ?:  (~(has by projects) project.act)
        ::   =.  projects  (~(del by projects) project.act)
        ::   =.  focused-project
        ::     ?:  =(project.act focused-project)  ''
        ::     focused-project
        ::   :_  state
        ::   :_  ~
        ::   (~(poke-self pass:io /self-wire) m v)
        ?.  ?=(%commit-install-starting -.status.modified-state)
          [cards state]
        =/  [request-id=@t ?]
          %-  ~(got by cis-running.status.modified-state)
          -:?^(cfo ships.u.cfo default-ships:zig-lib)
        =/  [snap-cards=(list card) modified-state=_state]
          %-  make-snap-cards
          :^  project.act  `request-id  modified-state
          (~(gas in *(set @p)) ?~(cfo ~ ships.u.cfo))
        :_  modified-state
        :+  (make-read-desk:zig-lib project.act `request-id)
          %-  update-vase-to-card:zig-lib
          %.  sync-desk-to-vship
          %~  new-project  make-update-vase:zig-lib
          update-info
        (weld snap-cards cards)
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
      =^  snap-cards=(list card)  state
        %-  make-snap-cards
        :^  project.act  request-id.act  state
        (~(gas in *(set @p)) sync-ships.act)
      :-  ;:  welp
              snap-cards
          ::
              :~  [%pass /merge-wire/[project.act]/(scot %ud (jam sync-ships.act)) %arvo %c merge-task]
                  [%pass /mount-wire %arvo %c mount-task]
                  [%pass /save-wire %arvo %c bill-task]
                  [%pass /save-wire %arvo %c deletions-task]
                  (make-read-desk:zig-lib [project request-id]:act)
              ::
                  %-  update-vase-to-card:zig-lib
                  %.  sync-desk-to-vship
                  %~  new-project  make-update-vase:zig-lib
                  update-info
              ==
          ::
              (make-done-cards:zig-lib status project.act)
          ==
      =.  state
        %^  change-state-linked-projects:zig-lib
          focused-project  state
        |=(=project:zig project(saved-test-queue test-queue))
      %=  state
          test-queue       ~
          focused-project  project.act
      ::
          linked-projects
        %+  ~(put by linked-projects)  project.act
        (~(put in *(set @t)) project.act)
      ::
          configs  ::  TODO: generalize: read in configuration file
        %^  ~(put bi:mip configs)  project.act
        [~nec %sequencer]  0x0
      ::
          projects
        =|  =project:zig
        =.  user-files.project
          (~(put in *(set path)) /app/[project.act]/hoon)
        =.  pyro-ships.project
          ?^  sync-ships.act  sync-ships.act
          default-ships:zig-lib
        (~(put by projects) project.act project)
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
      :+  %^  make-save-file:zig-lib  update-info
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
      :-  %-  update-vase-to-card:zig-lib
          %.  status
          %~  status  make-update-vase:zig-lib
          update-info
      |-
      ?~  ships.act  cards
      =*  who   i.ships
      =/  cis-cards=(list card)
        :_  ~
        %+  cis-thread:zig-lib
          /cis-done/(scot %p who)/[desk]
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
      ?:  (~(has ju linked-projects) old new)
        `state(focused-project new)
      =/  old-project=project:zig  (~(got by projects) old)
      =/  new-project=project:zig  (~(got by projects) new)
      =/  old-links=(set @t)
        (~(get ju linked-projects) old)
      =/  old-snap-path=path
        :-  (crip (noah !>(`(set @t)`old-links)))
        /(scot %da now.bowl)
      =/  new-snap-path=path
        %-  ~(got by unfocused-project-snaps)
        (~(get ju linked-projects) new)
      =.  unfocused-project-snaps
        %+  ~(put by unfocused-project-snaps)  old-links
        old-snap-path
      =.  state
        %^  change-state-linked-projects:zig-lib  new
          %^  change-state-linked-projects:zig-lib  old  state
          |=(=project:zig project(saved-test-queue test-queue))
        |=(=project:zig project(saved-test-queue ~))
      :_  %=  state
              focused-project  new
              test-queue       saved-test-queue.new-project
          ==
      :+  %+  ~(poke-our pass:io /pyro-wire)  %pyro
          :-  %pyro-action
          !>  ^-  action:pyro
          :+  %snap-ships  old-snap-path
          pyro-ships.old-project
        %+  ~(poke-our pass:io /pyro-wire)  %pyro
        :-  %pyro-action
        !>  ^-  action:pyro
        [%restore-snap new-snap-path]
      ~
    ::
        %add-project-link
      ?>  (~(has by projects) project.act)
      =*  project-a=@t  focused-project
      =*  project-b=@t  project.act
      =/  project-a-links=(set @t)
        (~(get ju linked-projects) project-a)
      =/  project-b-links=(set @t)
        (~(get ju linked-projects) project-b)
      =/  new-links=(set @t)
        (~(uni in project-a-links) project-b-links)
      ::  the del and snoc are to ensure focused-project
      ::   is the last element of the list so it remains
      ::   focused after we are cis-setup-done
      =/  new-links-list=(list @t)
        %-  snoc  :_  focused-project
        ~(tap in (~(del in new-links) focused-project))
      =.  linked-projects
        %-  ~(gas by linked-projects)
        %+  turn  new-links-list
        |=  project-name=@t
        [project-name new-links]
      =/  [cards=(list card) modified-state=_state project-cis-running=(mip:mip @t @p [@t ?])]
        %+  make-desk-setup-cards-state  new-links-list
        update-info
      :-  cards
      %=  modified-state
          status
        [%changing-project-links project-cis-running]
      ::
          unfocused-project-snaps
        %.  project-b-links
        %~  del  by
        %.  project-a-links
        ~(del by unfocused-project-snaps)
      ==
    ::
        %delete-project-link
      ?>  (~(has by projects) project.act)
      =*  project-to-remove=@t  project.act
      =/  links=(set @t)
        (~(get ju linked-projects) focused-project)
      ?.  .=  links
          (~(get ju linked-projects) project-to-remove)
        !!  :: TODO: do better
      =/  new-links=(set @t)
        (~(del in links) project-to-remove)
      ::  the del and snoc are to ensure focused-project
      ::   is the last element of the list so it remains
      ::   focused after we are cis-setup-done
      =/  new-links-list=(list @t)
        %-  snoc  :_  focused-project
        ~(tap in (~(del in new-links) focused-project))
      =.  linked-projects
        %-  ~(gas by linked-projects)
        :-  :-  project-to-remove
            (~(put in *(set @t)) project-to-remove)
        %+  turn  new-links-list
        |=  project-name=@t
        [project-name new-links]
      =/  [cards=(list card) modified-state=_state project-cis-running=(mip:mip @t @p [@t ?])]
        %+  make-desk-setup-cards-state  new-links-list
        update-info
      :-  cards
      %=  modified-state
          status
        [%changing-project-links project-cis-running]
      ::
          unfocused-project-snaps
        =/  single-link=(set @t)
          (~(put in *(set @t)) project-to-remove)
        =/  snaps=(list path)
          =+  .^  =update:pyro
                  %gx
                  :-  (scot %p our.bowl)
                  /pyro/(scot %da now.bowl)/snaps/noun
              ==
          ?>  ?=(%snaps -.update)
          snap-paths.update
        =/  single-link-cord=@t
          (crip (noah !>(`(set @t)`single-link)))
        %+  %~  put  by
            (~(del by unfocused-project-snaps) links)
          single-link
        =<  q
        %+  roll  snaps
        |=  [snap=path latest=(pair @da path)]
        ?~  snap                        latest
        ?.  =(single-link-cord i.snap)  latest
        ?~  t.snap                      latest
        =/  snap-time=@da  (slav %da i.t.snap)
        ?:  (gth p.latest snap-time)    latest
        [snap-time snap]
      ==
    ::
        %save-file
      =/  =project:zig  (~(got by projects) project.act)
      =.  user-files.project
        (~(put in user-files.project) file.act)
      :-  :_  ~
          (make-save-file:zig-lib update-info [file text]:act)
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
      :-  %-  update-vase-to-card:zig-lib
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
      :-  %-  update-vase-to-card:zig-lib
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
        %unregister-contract-for-compilation
      =/  =project:zig  (~(got by projects) project.act)
      ?:  (~(has in to-compile.project) file.act)  `state
      =.  to-compile.project
        (~(del in to-compile.project) file.act)
      :-  ~
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
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %+  add-test-error  0x0
        %-  crip
        %+  weld  "could not find host for town-id"
        " {<town-id.act>} amongst {<configs>}"
      =/  address=@ux
        (~(got bi:mip configs) 'global' [u.who %address])
      =/  test-name=@tas  `@tas`(rap 3 %deploy path.act)
      =/  imports=(list [@tas path])
        :^    [%indexer /sur/zig/indexer]
            [%zig /sur/zig/ziggurat]
          [%mip /lib/mip]
        ~
      =^  subject=(each vase @t)  state
        %^  compile-test-imports:zig-lib  `@tas`project.act
        imports  state
      ?:  ?=(%| -.subject)
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %+  add-test-error  0x0
        %^  cat  3  'compilation of test-imports failed:\0a'
        p.subject
      =*  service-host  ~nec  ::  TODO: remove hardcode
      =.  path.act
        ?+    (rear path.act)  !!  ::  TODO: error handle
            %jam   path.act
            %hoon
          %-  need  ::  TODO: error handle
          (convert-contract-hoon-to-jam:zig-lib path.act)
        ==
      =/  =test:zig
        :*  `test-name
            ~
            (~(gas by *test-imports:zig) imports)
            subject
            ~
        ::
            :_  ~
            :-  %custom-write
            :^  %send-wallet-transaction  ~
              %-  crip
              %-  noah
              !>  ^-  [@p @p test-write-step:zig]
              :+  u.who  service-host
              :-  %custom-write
              :^  %deploy-contract  ~
                %-  crip
                "[{<u.who>} {<service-host>} {<path.act>} %.n ~]"
              ~
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
      :-  %-  %~  arvo  pass:io
              /delete-test/[project.act]/(scot %ux test-id)
          :^  %k  %lard  q.byk.bowl
          =/  m  (strand ,vase)
          ^-  form:m
          ;<  ~  bind:m
            %^  watch-our:strandio  /updates  %ziggurat
            /project
          |-
          ;<  update-cage=cage  bind:m
            (take-fact:strandio /updates)
          ?.  ?=(%ziggurat-update -.update-cage)  $
          =+  !<(=update:zig q.update-cage)
          ?~  update                              $
          ?.  ?=(%test-results -.update)          $
          ?.  =(test-id test-id.update)           $
          (pure:m !>(`?`-.payload.update))
      ^-  (list card)
      :^    (make-run-queue:zig-lib [project request-id]:act)
          %-  update-vase-to-card:zig-lib
          %.  test-queue
          ~(test-queue make-update-vase:zig-lib update-info)
        %-  update-vase-to-card:zig-lib
        %.  [test test-id]
        %~  add-test  make-update-vase:zig-lib
        update-info
      (weld cards all-cards)
    ::
        %compile-contracts
      ::  for internal use
      =/  =project:zig  (~(got by projects) project.act)
      =/  compile-contract-error
        %~  compile-contract  make-error-vase:zig-lib
        [update-info %error]
      =/  build-results=(list (pair path build-result:zig))
        %^  build-contract-projects:zig-lib  smart-lib-vase
          /(scot %p our.bowl)/[project.act]/(scot %da now.bowl)
        to-compile.project
      =/  error-cards=(list card)
        %+  murn  build-results
        |=  [p=path =build-result:zig]
        ?:  ?=(%& -.build-result)  ~
        :-  ~
        %-  update-vase-to-card:zig-lib
        %-  compile-contract-error
        %-  crip
        ;:  weld
            "contract compilation failed at"
            "{<`path`p>} with error:\0a"
            (trip p.build-result)
        ==
      =/  [cards=(list card) errors=(list [path @t])]
        %+  save-compiled-contracts:zig-lib  project.act
        build-results
      :_  state
      :_  (weld cards error-cards)
      (make-read-desk:zig-lib [project request-id]:act)
    ::
        %compile-contract
      ::  for internal use
      =/  =project:zig  (~(got by projects) project.act)
      =/  compile-contract-error
        %~  compile-contract  make-error-vase:zig-lib
        [update-info %error]
      ?~  path.act
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %-  compile-contract-error
        'contract path must not be empty'
      ::
      =/  =build-result:zig
        %^  build-contract-project:zig-lib  smart-lib-vase
          /(scot %p our.bowl)/[project.act]/(scot %da now.bowl)
        path.act
      ?:  ?=(%| -.build-result)
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %-  compile-contract-error
        %-  crip
        ;:  weld
            "contract compilation failed at"
            "{<`path`path.act>} with error:\0a"
            (trip p.build-result)
        ==
      ::
      =/  save-result=(each card (pair path @t))
        %^  save-compiled-contract:zig-lib  project.act
        path.act  build-result
      ?:  ?=(%| -.save-result)
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %-  compile-contract-error
        %-  crip
        ;:  weld
            "failed to save newly compiled contract"
            " {<`path`p.p.save-result>} with error:\0a"
            (trip q.p.save-result)
        ==
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
      :+  (make-watch-for-file-changes:zig-lib project.act)
        %-  update-vase-to-card:zig-lib
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
      :-  :+  %^  make-save-file:zig-lib  update-info
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
      %-  update-vase-to-card:zig-lib
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
      %-  update-vase-to-card:zig-lib
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
      %-  update-vase-to-card:zig-lib
      %.  id.act
      %~  delete-test  make-update-vase:zig-lib
      update-info
    ::
        %run-test
      =.  test-queue  (~(put to test-queue) [project id]:act)
      =/  cards=(list card)
        :+  %-  update-vase-to-card:zig-lib
            %.  test-queue
            %~  test-queue  make-update-vase:zig-lib
            update-info
          %-  update-vase-to-card:zig-lib
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
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %-  run-queue-error(level %warning)
        'must run %start-pyro-ships before tests'
      ::
          %running-test-steps
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %-  run-queue-error(level %info)
        'queue already running'
          %ready
        ?:  =(~ test-queue)
          :_  state
          :_  ~
          %-  update-vase-to-card:zig-lib
          %-  run-queue-error(level %warning)
          'no tests in queue'
        =^  top  test-queue  ~(get to test-queue)
        =*  next-project-name  -.top
        =*  next-test-id        +.top
        =/  =project:zig  (~(got by projects) next-project-name)
        =/  =test:zig     (~(got by tests.project) next-test-id)
        ?:  ?=(%| -.subject.test)
          :_  state
          :_  ~
          %-  update-vase-to-card:zig-lib
          %-  run-queue-error
          'test subject must compile before test can be run'
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
        :-  %-  update-vase-to-card:zig-lib
            %.  status
            %~  status  make-update-vase:zig-lib
            update-info
        :^    %-  update-vase-to-card:zig-lib
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
      %-  update-vase-to-card:zig-lib
      %.  test-queue
      ~(test-queue make-update-vase:zig-lib update-info)
    ::
        %queue-test
      =.  test-queue
        (~(put to test-queue) [project.act id.act])
      :_  state
      :_  ~
      %-  update-vase-to-card:zig-lib
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
      %-  update-vase-to-card:zig-lib
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
      %-  update-vase-to-card:zig-lib
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
      %-  update-vase-to-card:zig-lib
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
        %take-snapshot
      =/  =project:zig  (~(got by projects) project.act)
      =/  links=(set @t)  (~(get ju linked-projects) project.act)
      =/  snap-path=path
        ?^  update-project-snaps.act
          u.update-project-snaps.act
        :-  (crip (noah !>(`(set @t)`links)))
        /(scot %da now.bowl)
      :-  :_  ~
          %+  ~(poke-our pass:io /pyro-poke)  %pyro
          :-  %pyro-action
          !>  ^-  action:pyro
          [%snap-ships snap-path pyro-ships.project]
      %=  state
          unfocused-project-snaps
        ?^  update-project-snaps.act
          unfocused-project-snaps
        (~(put by unfocused-project-snaps) links snap-path)
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
      %-  update-vase-to-card:zig-lib
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
      %-  update-vase-to-card:zig-lib
      %.  file.act
      %~  delete-user-file  make-update-vase:zig-lib
      update-info
    ::
        %send-pyro-dojo
      :_  state
      (send-pyro-dojo-card:zig-lib [who command]:act)^~
    ::
        %pyro-agent-state
      =/  who=@ta  (scot %p who.act)
      =*  app      app.act
      =?  grab.act  =('' grab.act)  '-'
      =/  now=@ta  (scot %da now.bowl)
      =/  state-error
        %~  pyro-agent-state  make-error-vase:zig-lib
        [update-info %error]
      ?.  .^  ?
              %gx
              :-  (scot %p our.bowl)
              /pyro/[now]/i/[who]/gu/[who]/[app]/[now]/noun
          ==
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %-  state-error
        %-  crip
        "%pyro ship {<who.act>} not running agent {<`@tas`app>}"
      =/  [wex=boat:gall sup=bitt:gall]
        .^  [boat:gall bitt:gall]
            %gx
            :+  (scot %p our.bowl)  %pyro
            /[now]/[who]/[app]/dbug/subscriptions/noun/noun
        ==
      =+  .^  agent-state=vase
              %gx
              :+  (scot %p our.bowl)  %pyro
              /[now]/[who]/[app]/dbug/state/noun/noun
          ==
      =^  subject=(each vase @t)  state
        %^  compile-test-imports:zig-lib  `@tas`project.act
        ~(tap by test-imports.act)  state
      ?:  ?=(%| -.subject)
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %-  state-error
        %^  cat  3  'compilation of test-imports failed:\0a'
        p.subject
      =.  p.subject
        (slop agent-state (slop !>(bowl=bowl) p.subject))
      =/  modified-state=vase
        (slap p.subject (loud-ream:zig-lib grab.act /))
      ::  %shown-pyro-agent-state over %pyro-agent-state
      ::   because there are casts deep in vanes that don't
      ::   take too kindly to vases within vases
      :_  state
      :_  ~
      %-  update-vase-to-card:zig-lib
      %.  [(show-state:zig-lib modified-state) wex sup]
      %~  shown-pyro-agent-state  make-update-vase:zig-lib
      update-info
    ::
        %pyro-chain-state
      =?  grab.act  =('' grab.act)  '-'
      ::  %shown-pyro-chain-state over %pyro-chain-state
      ::   because there are casts deep in vanes that don't
      ::   take too kindly to vases within vases
      =/  state-error
        %~  pyro-chain-state  make-error-vase:zig-lib
        [update-info %error]
      =/  chain-state=(each (map @ux batch:ui) @t)
        (get-chain-state:zig-lib project.act configs)
      ?:  ?=(%| -.chain-state)
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        (state-error p.chain-state)
      =^  subject=(each vase @t)  state
        %^  compile-test-imports:zig-lib  `@tas`project.act
        ~(tap by test-imports.act)  state
      ?:  ?=(%| -.subject)
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %-  state-error
        %^  cat  3  'compilation of test-imports failed:\0a'
        p.subject
      =.  p.subject
        (slop !>(p.chain-state) (slop !>(bowl=bowl) p.subject))
      =/  modified-state=vase
        (slap p.subject (loud-ream:zig-lib grab.act /))
      :_  state
      :_  ~
      %-  update-vase-to-card:zig-lib
      %.  (show-state:zig-lib modified-state)
      %~  shown-pyro-chain-state  make-update-vase:zig-lib
      update-info
    ::
        %change-settings
      `state(settings settings.act)
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
        :+  %-  update-vase-to-card:zig-lib
            %+  test-results-error  [test-id tid steps.test]
            'thread crashed'
          %-  update-vase-to-card:zig-lib
          %.  status
          %~  status  make-update-vase:zig-lib
          [project-name %ziggurat-test-run-thread-crash ~]
        ~
      ::
          %thread-done
        =/  result=(each (pair test-results:zig configs:zig) @t)
          !<  (each [test-results:zig configs:zig] @t)
          q.cage.sign
        ?:  ?=(%| -.result)
          =.  status  [%ready ~]
          :_  this
          :+  %-  update-vase-to-card:zig-lib
              %+  test-results-error  [test-id tid steps.test]
              (cat 3 'thread fail with error:\0a' p.result)
            %-  update-vase-to-card:zig-lib
            %.  status
            %~  status  make-update-vase:zig-lib
            [project-name %ziggurat-test-run-thread-fail ~]
          ~
        =*  test-results  p.p.result
        =/  =shown-test-results:zig
          (show-test-results:zig-lib test-results)
        =.  tests.project
          %+  ~(put by tests.project)  test-id
          test(results test-results)
        =.  status  [%ready ~]
        =/  cards=(list card)
          :_  ~
          %-  update-vase-to-card:zig-lib
          %.  [shown-test-results test-id tid steps.test]
          %~  test-results  make-update-vase:zig-lib
          [project-name %ziggurat-test-run-thread-done ~]
        :_  %=  this
                configs
              (uni-configs:zig-lib configs q.p.result)
            ::
                projects
              (~(put by projects) project-name project)
            ==
        ?^  test-queue
          :_  cards
          %-  ~(poke-self pass:io /self-wire)
          :-  %ziggurat-action
          !>(`action:zig`project-name^~^[%run-queue ~])
        :+  %-  update-vase-to-card:zig-lib
            %~  run-queue  make-update-vase:zig-lib
            [project-name %ziggurat-test-run-thread-done ~]
          %-  update-vase-to-card:zig-lib
          %.  status
          %~  status  make-update-vase:zig-lib
          [project-name %ziggurat-test-run-thread-done ~]
        cards
      ==
    ==
  ::
      [%cis-setup-done @ ~]
    =*  desk  i.t.w
    ?.  ?=(%fact -.sign)  (on-agent:def w sign)
    ?.  ?=(%ziggurat-update p.cage.sign)  !!  ::  TODO: do better
    =+  !<(=update:zig q.cage.sign)
    ?~  update  !!  ::  TODO: do better
    =*  payload  payload.update
    ?.  ?|  ?&  ?=(%run-queue -.update)
                ?=(%| -.payload)
                ?=(%warning level.p.payload)
                =('no tests in queue' message.p.payload)
            ==
        ::
            ?&  ?=(%status -.update)
                ?=(%& -.payload)
                ?=([%ready ~] p.payload)
                =(0 ~(wyt in test-queue))
            ==
        ==
      `this
    =/  links=(set @t)  (~(get ju linked-projects) desk)
    =/  snap-path=path
      ?:  &(=('' focused-project) =('zig' desk))
        default-snap-path:zig-lib
      :-  (crip (noah !>(`(set @t)`links)))
      /(scot %da now.bowl)
    =.  state
      %^  change-state-linked-projects:zig-lib  desk  state
      |=(p=project:zig p(tests ~))
    :_  %=  this
            status           [%ready ~]
            focused-project  desk
        ::
            unfocused-project-snaps
          %+  ~(put by unfocused-project-snaps)  links
          snap-path
        ==
    :^    (~(leave-our pass:io w) %ziggurat)
        %+  ~(poke-our pass:io /pyro-wire)  %pyro
        :-  %pyro-action
        !>  ^-  action:pyro
        :+  %snap-ships  snap-path
        =<  pyro-ships
        (~(got by projects) desk)
      %-  update-vase-to-card:zig-lib
      %~  cis-setup-done  make-update-vase:zig-lib
      [desk %cis-setup-done ~]
    (sync-all-desks-cards:zig-lib sync-desk-to-vship)
  ==
::
++  on-arvo
  |=  [w=wire =sign-arvo:agent:gall]
  |^  ^-  (quip card _this)
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
      [%on-new-project-ship-rerun @ @ ~]
    :_  this
    :_  ~
    %+  ~(poke-self pass:io /self-wire)
    i.t.w  !>(;;(action:zig (cue i.t.t.w)))
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
        %+  sync-desk-to-virtualship-card:zig-lib  who
        project-name
    ~&  >>>  "failed to make new desk"
    `this
  ::
      [%clay @ ~]
    ?>  ?=([%clay %writ *] sign-arvo)
    =*  project-name  i.t.w
    =/  =project:zig  (~(got by projects) project-name)
    ?~  p.sign-arvo
      :_  this
      :_  ~
      (make-watch-for-file-changes:zig-lib project-name)
    =/  updated-files=(set path)
      =+  !<(=dome:clay q.r.u.p.sign-arvo)
      =/  =tako:clay  (~(got by hit.dome) let.dome)
      =+  .^  =yaki:clay
              %cs
              %+  weld  /(scot %p our.bowl)/[project-name]
              /(scot %da now.bowl)/yaki/(scot %uv tako)
          ==
      ~(key by q.yaki)
    |^
    =^  cards  state  update-tests-from-file
    :_  this
    :-  ?:  .=  0
            %~  wyt  in
            (~(int in updated-files) to-compile.project)
          (make-read-desk:zig-lib project-name ~)
        (make-compile-contracts:zig-lib project-name ~)
    %-  weld  :_  cards
    %+  turn
      %~  tap  in
      (~(get ju sync-desk-to-vship) project-name)
    |=  who=@p
    (sync-desk-to-virtualship-card:zig-lib who project-name)
    ::
    ::  check if any test-steps loaded from file were
    ::   updated; if yes, reload them under same id.
    ::   however, this only will update if the test-steps
    ::   file itself is updated, not any of its dependencies.
    ::   TODO: replace with a more full-featured dependency
    ::   rebuilding/updating system
    ++  update-tests-from-file
      ^-  (quip card _state)
      %+  roll  ~(tap by projects)
      |:  :-  [project-name=`@t`'' project=`project:zig`*project:zig]
          [outer-cards=`(list card)`~ outer-state=`_state`state]
      =;  [=tests:zig inner-cards=(list card) inner-state=_state]
        :-  (weld outer-cards inner-cards)
        %=  inner-state
            projects
          %+  ~(put by projects)  project-name
          project(tests tests)
        ==
      %+  roll  ~(tap by tests.project)
      |:  :-  [test-id=`@ux`0x0 test=`test:zig`*test:zig]
          :+  tests=`tests:zig`tests.project
            inner-cards=`(list card)`~
          inner-state=`_state`outer-state
      ?.  (~(has in updated-files) test-steps-file.test)
        [tests inner-cards inner-state]
      =^  result  inner-state
        %^  read-test-file:zig-lib  project-name
        test-steps-file.test  inner-state
      ?:  ?=(%| -.result)
        :+  tests
          :_  inner-cards
          %-  update-vase-to-card:zig-lib
          %.  p.result
          %~  sync-desk-to-vship  make-error-vase:zig-lib
          [[project-name %clay-sync ~] %error]
        inner-state
      :_  [inner-cards inner-state]
      %+  ~(put by tests)  test-id
      %=  test
          subject       [%& q.p.result]
          steps         r.p.result
          test-imports
        (~(gas in *test-imports:zig) p.p.result)
      ==
    --
  ::
      [%cis-done @ @ ~]
    ?.  ?&  ?=(%khan -.sign-arvo)
            ?=(%arow -.+.sign-arvo)
            ?=(%& -.p.+.sign-arvo)
        ==
      (on-arvo:def w sign-arvo)
    =*  desk  i.t.t.w
    =*  cage  p.p.+.sign-arvo
    =.  status  !<(status:zig q.cage)
    ?.  ?|  ?&  ?=(%commit-install-starting -.status)
                (is-cis-done cis-running.status)
            ==
        ::
            ?&  ?=(%changing-project-links -.status)
                (is-cpl-done project-cis-running.status)
            ==
        ==
      [(make-status-card:zig-lib status desk)^~ this]
    =/  new-status=status:zig  [%ready ~]
    :_  this(status new-status)
    (make-done-cards:zig-lib status desk)
  ::
      [%delete-test @ @ ~]
    ?.  ?&  ?=(%khan -.sign-arvo)
            ?=(%arow -.+.sign-arvo)
            ?=(%& -.p.+.sign-arvo)
        ==
      (on-arvo:def w sign-arvo)
    =*  project-name  i.t.w
    =*  test-id=@ux   (slav %ux i.t.t.w)
    :_  this
    ~[(make-delete-test:zig-lib test-id project-name ~)]
  ==
  ::
  ++  is-cis-done
    |=  cis-running=(map @p [@t ?])
    ^-  ?
    %-  levy  :_  same
    %+  turn  ~(val by cis-running)
    |=([@t is-ship-done=?] is-ship-done)
  ::
  ++  is-cpl-done
    |=  project-cis-running=(mip:mip @t @p [@t ?])
    ^-  ?
    %-  levy  :_  same
    %+  turn  ~(tap bi:mip project-cis-running)
    |=([@t @p @t is-ship-done=?] is-ship-done)
  --
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
      [%focused-linked ~]
    :^  ~  ~  %ziggurat-update
    %^  %~  focused-linked  make-update-vase:zig-lib
        ['' %focused-linked ~]
    focused-project  linked-projects  unfocused-project-snaps
  ::
      [%custom-step-compiled @ @ @ ~]
    =*  project-name  i.t.t.p
    =/  test-id=@ux   (slav %ux i.t.t.t.p)
    =*  tag           `@tas`i.t.t.t.t.p
    =/  custom-step-error
      %~  custom-step-compiled  make-error-vase:zig-lib
      [[project-name %custom-step-compiled ~] %error]
    |^
    =/  project=(unit project:zig)
      (~(get by projects) project-name)
    ?~  project
      %-  make-error
      %+  weld  "did not find project {<project-name>} in"
      " {<~(key by projects)>}"
    =/  test=(unit test:zig)
      (~(get by tests.u.project) test-id)
    ?~  test
      %-  make-error
      %+  weld  "did not find test {<test-id>} in"
      " {<~(key by tests.u.project)>}"
    ?~  def=(~(get by custom-step-definitions.u.test) tag)
      %-  make-error
      %+  weld  "did not find custom-step-definition {<tag>}"
      " in {<~(key by custom-step-definitions.u.test)>}"
    ?:  ?=(%| -.q.u.def)  ::  TODO: do better
      %-  make-error
      %+  weld  "compilation failed; fix and try again."
      " error message:\0a {<p.q.u.def>}"
    ``noun+!>(`vase`p.q.u.def)
    ::
    ::  vasing a vase is sketchy, but works for scries
    ::   (does not work well for subscription %facts!)
    ::
    ++  make-error
      |=  message=tape
      ^-  (unit (unit cage))
      :^  ~  ~  %noun
      !>  ^-  vase
      (custom-step-error [test-id tag] (crip message))
    --
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
      [%settings ~]
    :^  ~  ~  %ziggurat-update
    %.  settings
    %~  settings  make-update-vase:zig-lib
    ['' %settings ~]
  ::
      [%state-views @ ~]
    =*  project-name  i.t.t.p
    =*  update-info  [project-name %state-views ~]
    =/  [* cfo=(unit configuration-file-output:zig) *]
      (load-configuration-file:zig-lib update-info state)
    :^  ~  ~  %json
    !>  ^-  json
    ?~  cfo  ~
    %-  update:enjs:zig-lib
    !<  update:zig
    %.  state-views.u.cfo
    %~  state-views  make-update-vase:zig-lib  update-info
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
