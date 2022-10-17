::  ziggurat [UQ| DAO]
::
::  Contract Playground
::
/+  *ziggurat, smart=zig-sys-smart, sequencer,
    default-agent, dbug, verb
/*  smart-lib-noun  %noun  /lib/zig/sys/smart-lib/noun
/*  zink-cax-noun   %noun  /lib/zig/sys/hash-cache/noun
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
  =/  smart-lib=vase  ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
  =/  mil
    %~  mill  mill:sequencer
    [smart-lib ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun))) %.y]
  :-  ~
  %_    this
      state
    [[%0 ~] mil smart-lib]
  ==
++  on-save  !>(-.state)
++  on-load
  |=  =old=vase
  ::  on-load: pre-cue our compiled smart contract library
  =/  smart-lib=vase  ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
  =/  mil
    %~  mill  mill:sequencer
    [smart-lib ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun))) %.y]
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
    ?+    mark  !!
        %ziggurat-app-action
      (handle-app-poke !<(app-action vase))
        %ziggurat-contract-action
      (handle-contract-poke !<(contract-action vase))
    ==
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
            state=(starting-state user-address.act)
            data-texts=(malt ~[[id.p:(designated-zigs-grain user-address.act) '[balance=300.000.000.000.000.000.000 allowances=~ metadata=0x61.7461.6461.7465.6d2d.7367.697a]']])
            user-address.act
            user-nonce=0
            mill-batch-num=0
            tests=~
        ==
      ::  attempt to build the project
      =/  =build-result  (build-contract-project smart-lib-vase proj)
      =?  compiled.proj  ?=(%& -.build-result)
        `p.build-result
      =?  p.state.proj  ?=(%& -.build-result)
        %+  put:big:mill  p.state.proj
        [designated-contract-id (make-contract-grain user-address.act p.build-result)]
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
        %populate-template
      ::  spawn some hardcoded example tests and grains for %fungible and %nft templates
      ?<  ?=(%blank template.act)
      =.  project
        ?:  ?=(%fungible template.act)
          (fungible-template-project project metadata.act smart-lib-vase)
        (nft-template-project project metadata.act smart-lib-vase)
      :-  (make-contract-update project.act project)^~
      state(projects (~(put by projects) project.act %&^project))
    ::
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
      ~&  name.act
      =?  main.project  =(name.act project.act)
        ::  this is the main file
        text.act
      =?  libs.project  !=(name.act project.act)
        (~(put by libs.project) name.act text.act)
      ::  attempt to rebuild project
      =/  =build-result  (build-contract-project smart-lib-vase project)
      ::  only update compiled nock if successful build
      =?  compiled.project  ?=(%& -.build-result)
        ~&  >  "project successfully rebuilt"
        `p.build-result
      =?  p.state.project  ?=(%& -.build-result)
        %+  put:big:mill  p.state.project
        [designated-contract-id (make-contract-grain user-address.project p.build-result)]
      ::  set error to ~ if successful build
      =.  error.project
        ?.  ?=(%| -.build-result)  ~
        ~&  >>>  "project build failed"
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
        ~&  >  "project successfully rebuilt"
        `p.build-result
      =?  p.state.project  ?=(%& -.build-result)
        %+  put:big:mill  p.state.project
        [designated-contract-id (make-contract-grain user-address.project p.build-result)]
      ::  set error to ~ if successful build
      =.  error.project
        ?.  ?=(%| -.build-result)  ~
        ~&  >>>  "project build failed"
        `p.build-result
      :-  (make-contract-update project.act project)^~
      state(projects (~(put by projects) project.act %&^project))
    ::
    ::  local chain state management
    ::
        %add-to-state
      =/  data-text  ;;(@t data.act)
      =/  =id:smart  (fry-rice:smart lord.act holder.act town-id.act salt.act)
      =/  =rice:smart
        =+  (text-to-zebra-noun data-text smart-lib-vase)
        [salt.act label.act - id lord.act holder.act town-id.act]
      ::  take text data input and ream to form data noun
      ::  put a new grain in the granary
      =:  p.state.project
        %+  put:big:mill  p.state.project
        [id.rice %&^rice]
      ::
          data-texts.project
        (~(put by data-texts.project) id.rice data-text)
      ==
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
      =+  (text-to-zebra-noun action.act smart-lib-vase)
      =/  =yolk:smart  [;;(@tas -.-) +.-]
      =/  new-error
        ?~  expected-error.act  0
        u.expected-error.act
      ::  put it in the project
      =.  tests.project
        (~(put by tests.project) test-id [name.act action.act yolk ~ new-error ~])
      :-  (make-contract-update project.act project)^~
      state(projects (~(put by projects) project.act %&^project))
    ::
        %add-test-expectation
      ::  add/replace expected rice output
      ?~  current=(~(get by tests.project) id.act)
        ~|("%ziggurat: test does not exist" !!)
      =/  =id:smart  (fry-rice:smart lord.act holder.act town-id.act salt.act)
      =/  =rice:smart
        [salt.act label.act data.act id lord.act holder.act town-id.act]
      =/  tex  ;;(@t data.rice)
      =/  new
        =-  [id.rice %&^rice(data -) tex]
        (text-to-zebra-noun tex smart-lib-vase)
      =.  tests.project
        %+  ~(put by tests.project)  id.act
        u.current(expected (~(put by expected.u.current) new), result ~)
      :-  (make-contract-update project.act project)^~
      state(projects (~(put by projects) project.act %&^project))
    ::
        %delete-test-expectation
      ?~  current=(~(get by tests.project) id.act)
        ~|("%ziggurat: test does not exist" !!)
      =.  tests.project
        %+  ~(put by tests.project)  id.act
        u.current(expected (~(del by expected.u.current) delete.act), result ~)
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
      =+  (text-to-zebra-noun action.act smart-lib-vase)
      =/  =yolk:smart  [;;(@tas -.-) +.-]
      =/  new-error
        ?~  expected-error.act  0
        u.expected-error.act
      ::  get existing
      =.  tests.project
        ?~  current=(~(get by tests.project) id.act)
          (~(put by tests.project) id.act [name.act action.act yolk ~ new-error ~])
        %+  ~(put by tests.project)  id.act
        =-  [name.act action.act yolk expected.u.current - ~]
        ?~  expected-error.act  expected-error.u.current
        u.expected-error.act
      :-  (make-contract-update project.act project)^~
      state(projects (~(put by projects) project.act %&^project))
    ::
        %run-test
      =/  =test  (~(got by tests.project) id.act)
      =/  caller
        (designated-caller user-address.project +(user-nonce.project))
      =/  =shell:smart
        :*  caller
            ~
            designated-contract-id
            rate.act  bud.act
            designated-town-id
            status=0
        ==
      =/  =mill-result:mill
        %+  %~  mill  mil
            [caller designated-town-id mill-batch-num.project]
          state.project
        [[0 0 0] shell action.test]
      =/  =expected-diff
        %-  malt
        %+  turn  ~(tap by p.land.mill-result)
        |=  [=id:smart [@ux made=grain:smart]]
        =/  expected  (~(get by expected.test) id)
        :-  id
        :+  `made
          ?~(expected ~ `-.u.expected)
        ?~  expected  ~
        `=(-.u.expected made)
      ::  add any expected that weren't ids in result
      =.  expected-diff
        =/  lis  ~(tap by expected.test)
        |-
        ?~  lis  expected-diff
        %=  $
          lis  t.lis
        ::
            expected-diff
          ?:  (~(has by expected-diff) -.i.lis)
            expected-diff
          (~(put by expected-diff) [-.i.lis [~ `-.+.i.lis `%.n]])
        ==
      ::
      =/  success
        ?~  expected.test  ~
        :-  ~
        ?&  =(errorcode.mill-result expected-error.test)
        ::
            %+  levy  ~(val by expected-diff)
            |=  [(unit grain:smart) (unit grain:smart) match=(unit ?)]
            ?~  match  %.y
            u.match
        ==
      ::
      =/  =test-result
        :*  fee.mill-result
            errorcode.mill-result
            crow.mill-result
            expected-diff
            success
        ==
      ::  save result in test, send update
      =.  tests.project
        (~(put by tests.project) id.act test(result `test-result))
      :-  (make-contract-update project.act project)^~
      state(projects (~(put by projects) project.act %&^project))
    ::
        %run-tests
      ::  run tests IN SUCCESSION against SAME STATE
      ::  note that this doesn't save last-result for each test,
      ::  as results here will not reflect *just this test*
      =/  [eggs=(list [@ux egg:smart]) new-nonce=@ud]
        %^  spin  tests.act  user-nonce.project
        |=  [[id=@ux rate=@ud bud=@ud] nonce=@ud]
        =/  =test  (~(got by tests.project) id)
        =/  caller  (designated-caller user-address.project +(nonce))
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
              [(designated-caller user-address.project 0) designated-town-id mill-batch-num.project]
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
      ::
      ?~  compiled.project
        ~|("%ziggurat: project must be compiled before deploy!" !!)
      ?^  error.project
        ~|("%ziggurat: you should save a build without errors first" !!)
      ~&  >  "%ziggurat: deploying contract to {<deploy-location.act>} testnet"
      =/  pok
        :*  %transaction  from=address.act
            contract=0x1111.1111  town=town-id.act
            action=[%noun [%deploy upgradable.act u.compiled.project ~ ~]]
        ==
      :_  state
      =+  [%zig-wallet-poke !>(`wallet-poke:wallet`pok)]
      [%pass /uqbar-poke %agent [our.bowl %uqbar] %poke -]~
    ==
  ::
  ++  handle-app-poke
    |=  act=app-action
    ^-  (quip card _state)
    ?-    -.+.act
        %new-app-project
      ::  merge new desk, mount desk
      ::  currently using ziggurat desk as template -- should refine this
      ~&  >>  -.+.byk.bowl
      =/  merge-task  [%merg `@tas`project.act our.bowl -.+.byk.bowl da+now.bowl %init]
      =/  mount-task  [%mont `@tas`project.act [our.bowl `@tas`project.act da+now.bowl] /]
      =/  bill-task   [%info `@tas`project.act %& [/desk/bill %ins %bill !>(~[project.act])]~]
      =/  deletions-task  [%info `@tas`project.act %& (clean-desk project.act)]
      :_  state(projects (~(put by projects) project.act [%| ~]))
      :~  [%pass /merge-wire %arvo %c merge-task]
          [%pass /mount-wire %arvo %c mount-task]
          [%pass /save-wire %arvo %c bill-task]
          [%pass /save-wire %arvo %c deletions-task]
          =-  [%pass /self-wire %agent [our.bowl %ziggurat] %poke -]
          [%ziggurat-app-action !>(`app-action`project.act^[%read-desk ~])]
      ==
    ::
        %delete-project
      ::  should show a warning on frontend before performing this one ;)
      `state(projects (~(del by projects) project.act))
    ::
        %save-file
      :_  state
      :~  =-  [%pass /save-wire %arvo %c -]
          [%info `@tas`project.act %& [file.act %ins %hoon !>(text.act)]~]
          =-  [%pass /self-wire %agent [our.bowl %ziggurat] %poke -]
          [%ziggurat-app-action !>(`app-action`project.act^[%read-desk ~])]
      ==

    ::
        %delete-file
      ::  should show warning
      :_  state
      :~  =-  [%pass /del-wire %arvo %c -]
          [%info `@tas`project.act %& [file.act %del ~]~]
          =-  [%pass /self-wire %agent [our.bowl %ziggurat] %poke -]
          [%ziggurat-app-action !>(`app-action`project.act^[%read-desk ~])]
      ==

    ::
        %publish-app
      ::  [%publish-app title=@t info=@t color=@ux image=@t version=[@ud @ud @ud] website=@t license=@t]
      ::  should assert that desk.bill contains only our agent name,
      ::  and that clause has been filled out at least partially,
      ::  then poke treaty agent with publish
      =/  project  (~(got by projects) project.act)
      ?>  ?=(%| -.project)
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
      :~  [%pass /save-wire %arvo %c docket-task]
          =-  [%pass /self-wire %agent [our.bowl %ziggurat] %poke -]
          [%ziggurat-app-action !>(`app-action`project.act^[%read-desk ~])]
          =-  [%pass /treaty-wire %agent [our.bowl %treaty] %poke -]
          [%alliance-update-0 !>([%add our.bowl `@tas`project.act])]
      ==
    ::
        %read-desk
      ::  for internal use -- app calls itself to scry clay
      =/  =app-project
        =+  (~(got by projects) project.act)
        ?>  ?=(%| -.-)
        p.-
      =.  dir.app-project
        =-  .^((list path) %ct -)
        /(scot %p our.bowl)/(scot %tas project.act)/(scot %da now.bowl)
      :-  (make-app-update project.act app-project)^~
      state(projects (~(put by projects) project.act %|^app-project))
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
    :-  ~  :-  name
    ?:  ?=(%| -.project)
      (app-project-to-json p.project)
    (contract-project-to-json p.project)
  ::
      [%project-state @ ~]
    ?~  project=(~(get by projects) (slav %t i.t.t.path))
      ``json+!>(~)
    ?>  ?=(%& -.u.project)
    =/  =json  (granary-to-json p.state.p.u.project data-texts.p.u.project)
    ``json+!>(json)
  ::
      [%project-tests @ ~]
    ?~  project=(~(get by projects) (slav %t i.t.t.path))
      ``json+!>(~)
    ?>  ?=(%& -.u.project)
    =/  =json  (tests-to-json tests.p.u.project)
    ``json+!>(json)
  ::
  ::  APP-PROJECT JSON
  ::
      [%read-file @ ^]
    =/  des  (slav %tas i.t.t.path)
    =/  pat=^path  `^path`t.t.t.path
    =/  pre  /(scot %p our.bowl)/(scot %tas des)/(scot %da now.bowl)
    ~&  >  (weld pre pat)
    =/  res  .^(@t %cx (weld pre pat))
    ``json+!>(`json`[%s res])
  ==
::
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--
