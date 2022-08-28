::  ziggurat [UQ| DAO]
::
::  Contract Playground
::
/+  *ziggurat, smart=zig-sys-smart, sequencer,
    default-agent, dbug, verb
/*  smart-lib-noun  %noun  /lib/zig/compiled/smart-lib/noun
/*  zink-cax-noun   %noun  /lib/zig/compiled/hash-cache/noun
::
|%
+$  state-0
  $:  %0
      =projects
  ==
+$  inflated-state-0  [state-0 =mil smart-lib-vase=vase]
+$  mil  $_  ~(mill mill:sequencer !>(0) *(map * @) %.y)
--
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
  =/  smart-lib=vase  ;;(vase (cue q.q.smart-lib-noun))
  =/  mil
    %~  mill  mill:sequencer
    [smart-lib ;;((map * @) (cue q.q.zink-cax-noun)) %.y]
  :-  ~
  %_    this
      state
    [[%0 ~] mil smart-lib]
  ==
++  on-save  !>(-.state)
++  on-load
  |=  =old=vase
  ::  on-load: pre-cue our compiled smart contract library
  =/  smart-lib=vase  ;;(vase (cue q.q.smart-lib-noun))
  =/  mil
    %~  mill  mill:sequencer
    [smart-lib ;;((map * @) (cue q.q.zink-cax-noun)) %.y]
  `this(state [!<(state-0 old-vase) mil smart-lib])
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  !!
      [%contract-project @ ~]
    ::  serve updates about state of a given contract project
    =/  name=@t  `@t`i.t.path
    ?~  proj=(~(get by projects) name)
      `this
    ?>  ?=(%& -.u.proj)
    [(make-contract-update name p.u.proj)^~ this]
  ::
      [%app-project @ ~]
    ::  TODO
    =/  name=@t  `@t`i.t.path
    ?~  proj=(~(get by projects) name)
      `this
    ?>  ?=(%| -.u.proj)
    [(make-app-update name p.u.proj)^~ this]
  ::
      [%test-updates @ ~]
    ::  serve updates for all %run-tests executed
    ::  within a given contract project
    `this
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^
  ::  TODO handle app project pokes in their own arm
  =^  cards  state
    (handle-contract-poke !<(contract-action vase))
  [cards this]
  ::
  ++  handle-contract-poke
    |=  act=contract-action
    ^-  (quip card _state)
    ?:  ?=(%new-contract-project -.+.act)
      ?:  (~(has by projects) project.act)
        ~|("%ziggurat: project name already taken" !!)
      =/  [main=@t libs=(map @t @t)]
        ?-    template.act
            %blank
          [(get-template /trivial/hoon [our now]:bowl) ~]
        ::
            %nft
          :-  (get-template /nft/hoon [our now]:bowl)
          (malt ['nft' (get-template /lib/nft/hoon [our now]:bowl)]~)
        ::
            %fungible
          :-  (get-template /fungible/hoon [our now]:bowl)
          (malt ['fungible' (get-template /lib/fungible/hoon [our now]:bowl)]~)
        ==
      =/  proj=contract-project
        :*  main  libs
            compiled=~
            imported=~
            error=~
            state=starting-state
            caller-nonce=0
            mill-batch-num=0
            tests=~
        ==
      ::  attempt to build the project
      =/  =build-result  (build-contract-project smart-lib-vase proj)
      =?  compiled.proj  ?=(%& -.build-result)
        `p.build-result
      =?  p.state.proj  ?=(%& -.build-result)
        %+  put:big:mill  p.state.proj
        [designated-contract-id (make-contract-grain p.build-result)]
      =?  error.proj  ?=(%| -.build-result)
        `p.build-result
      :_  state(projects (~(put by projects) project.act %&^proj))
      (make-contract-update project.act proj)^~
    ::
    ::  all other pokes require existing project
    ::
    ?~  proj=(~(get by projects) project.act)
      ~|("%ziggurat: project does not exist" !!)
    ::  only handling contract pokes here
    ?>  ?=(%& -.u.proj)
    =*  project  p.u.proj
    ?-    -.+.act
        %delete-project
      ::  should show a warning on frontend before performing this one ;)
      `state(projects (~(del by projects) project.act))
    ::
    ::  file management
    ::
        %save-file
      ::  NOTE: make sure to enforce on frontend that 'main' file name
      ::  always matches the name of the project, and that no other files
      ::  in the project can use that name.
      =?  main.project  =(name.act project.act)
        ::  this is the main file
        text.act
      =?  libs.project  !=(name.act project.act)
        (~(put by libs.project) name.act text.act)
      ::  attempt to rebuild project
      =/  =build-result  (build-contract-project smart-lib-vase project)
      ::  only update compiled nock if successful build
      =?  compiled.project  ?=(%& -.build-result)
        `p.build-result
      =?  p.state.project  ?=(%& -.build-result)
        %+  put:big:mill  p.state.project
        [designated-contract-id (make-contract-grain p.build-result)]
      ::  set error to ~ if successful build
      =.  error.project
        ?.  ?=(%| -.build-result)  ~
        `p.build-result
      :-  (make-contract-update project.act project)^~
      state(projects (~(put by projects) project.act %&^project))
    ::
        %delete-file
      ?:  =(name.act project.act)
        ::  can't delete the main file
        ~|("%ziggurat: tried to delete the main file!" !!)
      =.  libs.project  (~(del by libs.project) name.act)
      ::  attempt to rebuild project
      =/  =build-result  (build-contract-project smart-lib-vase project)
      ::  only update compiled nock if successful build
      =?  compiled.project  ?=(%& -.build-result)
        `p.build-result
      =?  p.state.project  ?=(%& -.build-result)
        %+  put:big:mill  p.state.project
        [designated-contract-id (make-contract-grain p.build-result)]
      ::  set error to ~ if successful build
      =.  error.project
        ?.  ?=(%| -.build-result)  ~
        `p.build-result
      :-  (make-contract-update project.act project)^~
      state(projects (~(put by projects) project.act %&^project))
    ::
    ::  local chain state management
    ::
        %add-to-state
      ::  take text data input and ream to form data noun
      =.  data.rice.act
        q:(slap smart-lib-vase (ream ;;(@t data.rice.act)))
      ::  put a new grain in the granary
      =.  p.state.project
        %+  put:big:mill  p.state.project
        [id.rice.act %&^rice.act]
      :-  (make-contract-update project.act project)^~
      state(projects (~(put by projects) project.act %&^project))
    ::
        %delete-from-state
      ::  remove a grain from the granary
      =.  p.state.project
        (del:big:mill p.state.project id.act)
      :-  (make-contract-update project.act project)^~
      state(projects (~(put by projects) project.act %&^project))
    ::
    ::  test management
    ::
        %add-test
      ::  generate an id for the test
      =/  test-id  `@ux`(mug now.bowl)
      ::  ream action to form yolk
      =+  q:(slap smart-lib-vase (ream action.act))
      =/  =yolk:smart  [;;(@tas -.-) +.-]
      ::  put it in the project
      =.  tests.project
        (~(put by tests.project) test-id [name.act yolk ~ ~ ~])
      :-  (make-contract-update project.act project)^~
      state(projects (~(put by projects) project.act %&^project))
    ::
        %add-test-expectations
      ::  add/replace expected rice outputs
      ?~  current=(~(get by tests.project) id.act)
        ~|("%ziggurat: test does not exist" !!)
      =.  tests.project
        %+  ~(put by tests.project)  id.act
        u.current(expected `expected.act, success ~)
      :-  (make-contract-update project.act project)^~
      state(projects (~(put by projects) project.act %&^project))
    ::
        %delete-test
      =.  tests.project  (~(del by tests.project) id.act)
      :-  (make-contract-update project.act project)^~
      state(projects (~(put by projects) project.act %&^project))
    ::
        %edit-test
      ::  ream action to form yolk
      =+  q:(slap smart-lib-vase (ream action.act))
      =/  =yolk:smart  [;;(@tas -.-) +.-]
      ::  get existing
      =.  tests.project
        ?~  current=(~(get by tests.project) id.act)
          (~(put by tests.project) id.act [name.act yolk ~ ~ ~])
        %+  ~(put by tests.project)  id.act
        [name.act yolk expected.u.current ~ ~]
      :-  (make-contract-update project.act project)^~
      state(projects (~(put by projects) project.act %&^project))
    ::
        %run-test
      =/  =test  (~(got by tests.project) id.act)
      =/  caller
        (designated-caller +(caller-nonce.project))
      =/  =shell:smart
        :*  caller
            ~
            designated-contract-id
            rate.act  bud.act
            designated-town-id
            status=0
        ==
      =.  last-result.test
        :-  ~
        %+  %~  mill  mil
            [caller designated-town-id mill-batch-num.project]
          state.project
        [[0 0 0] shell action.test]
      ::  if test has expected results, go through list and check
      ::  if grains match those in this output
      =.  success.test
        ?~  expected.test  ~
        :-  ~
        %+  levy  ~(tap in u.expected.test)
        |=  =rice:smart
        ?~  last-result.test  %.n
        ?~  comp=(get:big:mill p.land.u.last-result.test id.rice)  %.n
        ?.  ?=(%& -.u.comp)  %.n
        =(p.u.comp rice)
      ::  save result in test, send update
      =.  tests.project  (~(put by tests.project) id.act test)
      :-  (make-contract-update project.act project)^~
      state(projects (~(put by projects) project.act %&^project))
    ::
        %run-tests
      ::  run tests IN SUCCESSION against SAME STATE
      ::  note that this doesn't save last-result for each test,
      ::  as results here will not reflect *just this test*
      =/  [eggs=(list [@ux egg:smart]) new-nonce=@ud]
        %^  spin  tests.act  caller-nonce.project
        |=  [[id=@ux rate=@ud bud=@ud] nonce=@ud]
        =/  =test  (~(got by tests.project) id)
        =/  caller  (designated-caller +(nonce))
        =/  =shell:smart
          :*  caller
              ~
              designated-contract-id
              rate  bud
              designated-town-id
              status=0
          ==
        :_  +(nonce)
        :-  `@ux`(sham shell action.test)
        [[0 0 0] shell action.test]
      =/  [res=state-transition:mill *]
        %^    %~  mill-all  mil
              [(designated-caller 0) designated-town-id mill-batch-num.project]
            state.project
          (silt eggs)
        256
      :-  (make-multi-test-update project.act res)^~
      state(projects (~(put by projects) project.act %&^project))
    ::
    ::  contract deployment to local/remote testnet
    ::
        %deploy-contract
      ::  this will call %wallet agent with a custom constructed %publish call
      ::  will fail if chosen testnet+town combo doesn't exist or doesn't have
      ::  the publish.hoon contract deployed.
      !!
    ==
  --
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  (on-agent:def wire sign)
::
++  on-arvo
  |=  [=wire =sign-arvo:agent:gall]
  ^-  (quip card _this)
  (on-arvo:def wire sign-arvo)
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
      [%project-nock @ ~]
    ?~  project=(~(get by projects) (slav %t i.t.t.path))
      ``noun+!>(~)
    ?>  ?=(%& -.u.project)
    ?~  compiled.p.u.project
      ``noun+!>(~)
    ``noun+!>(compiled.p.u.project)
  ::
  ::  JSONS
  ::
      [%all-projects ~]
    =,  enjs
    =;  =json  ``json+!>(json)
    %-  pairs
    %+  murn  ~(tap by projects)
    |=  [name=@t =project]
    ?:  ?=(%| -.project)  ~
    :-  ~  :-  name
    (contract-project-to-json p.project)
  ::
      [%project-state @ ~]
    ?~  project=(~(get by projects) (slav %t i.t.t.path))
      ``json+!>(~)
    ?>  ?=(%& -.u.project)
    =/  =json  (granary-to-json p.state.p.u.project)
    ``json+!>(json)
  ::
      [%project-tests @ ~]
    ?~  project=(~(get by projects) (slav %t i.t.t.path))
      ``json+!>(~)
    ?>  ?=(%& -.u.project)
    =/  =json  (tests-to-json tests.p.u.project)
    ``json+!>(json)
  ==
::
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--
