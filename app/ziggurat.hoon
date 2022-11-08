::  ziggurat [UQ| DAO]
::
::  Contract Playground
::
/+  *zig-ziggurat, smart=zig-sys-smart,
    engine=zig-sys-engine, seq=zig-sequencer,
    default-agent, dbug, verb
/*  smart-lib-noun  %noun  /lib/zig/sys/smart-lib/noun
/*  zink-cax-noun   %noun  /lib/zig/sys/hash-cache/noun
::
|%
+$  state-0
  $:  %0
      =projects
  ==
+$  inflated-state-0  [state-0 =eng smart-lib-vase=vase]
+$  eng  $_  ~(engine engine:engine !>(0) *(map * @) %.n %.n)  ::  sigs off, hints off
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
  =/  eng
    %~  engine  engine:engine
    ::  sigs off, hints off
    [smart-lib ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun))) %.n %.n]
  :-  ~
  %_    this
      state
    [[%0 ~] eng smart-lib]
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
  `this(state [!<(state-0 old-vase) eng smart-lib])
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  !!
      [%project @ ~]
    ::  serve updates about state of a given project
    =/  name=@t  `@t`i.t.path
    ?~  proj=(~(get by projects) name)
      `this
    [(make-project-update name u.proj)^~ this]
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
    ?+  mark  !!
      %ziggurat-action  (handle-poke !<(action vase))
    ==
  [cards this]
  ::
  ++  handle-poke
    |=  act=action
    ^-  (quip card _state)
    ?-    -.+.act
        %new-project
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
      ~&  >>  q.byk.bowl
      =/  merge-task  [%merg `@tas`project.act our.bowl q.byk.bowl da+now.bowl %init]
      =/  mount-task  [%mont `@tas`project.act [our.bowl `@tas`project.act da+now.bowl] /]
      =/  bill-task   [%info `@tas`project.act %& [/desk/bill %ins %bill !>(~[project.act])]~]
      =/  deletions-task  [%info `@tas`project.act %& (clean-desk project.act)]
      :-  :~  [%pass /merge-wire %arvo %c merge-task]
              [%pass /mount-wire %arvo %c mount-task]
              [%pass /save-wire %arvo %c bill-task]
              [%pass /save-wire %arvo %c deletions-task]
              =-  [%pass /self-wire %agent [our.bowl %ziggurat] %poke -]
              [%ziggurat-action !>(`action`project.act^[%read-desk ~])]
          ==
      %=  state
          projects
        %+  ~(put by projects)  project.act
        :*  dir=~  ::  populated by %read-desk
            user-files=(~(put in *(set path)) /app/[project.act]/hoon)
            to-compile=~
            next-contract-id=0xfafa.faf0
            error=~
            state=(starting-state user-address.act)
            noun-texts=(malt ~[[id.p:(designated-zigs-item user-address.act) '[balance=300.000.000.000.000.000.000 allowances=~ metadata=0x61.7461.6461.7465.6d2d.7367.697a]']])
            user-address.act
            user-nonce=0
            batch-num=0
            tests=~
        ==
      ==
    ::
        %populate-template
      ::  spawn some hardcoded example tests and grains for %fungible and %nft templates
      =/  =project  (~(got by projects) project.act)
      ?<  ?=(%blank template.act)
      =.  project
        ?:  ?=(%fungible template.act)
          (fungible-template-project project metadata.act smart-lib-vase)
        (nft-template-project project metadata.act smart-lib-vase)
      :-  (make-compile project.act our.bowl)^~
      state(projects (~(put by projects) project.act project))
    ::
        %delete-project
      ::  should show a warning on frontend before performing this one ;)
      `state(projects (~(del by projects) project.act))
    ::
        %save-file
      =/  =project  (~(got by projects) project.act)
      =.  user-files.project
        (~(put in user-files.project) file.act)
      :_  state(projects (~(put by projects) project.act project))
      :+  (make-save-file [project file text]:act)
        (make-compile project.act our.bowl)
      ~
    ::
        %delete-file
      ::  should show warning
      =/  =project  (~(got by projects) project.act)
      =:  user-files.project
        (~(del in user-files.project) file.act)
      ::
          to-compile.project
        (~(del by to-compile.project) file.act)
      ::
          p.chain.project
        ?~  remove-id=(~(get by to-compile.project) file.act)
          p.chain.project
        (del:big:engine p.chain.project u.remove-id)
      ==
      :_  state(projects (~(put by projects) project.act project))
      :+  (make-compile project.act our.bowl)
        =-  [%pass /del-wire %arvo %c -]
        [%info `@tas`project.act %& [file.act %del ~]~]
      ~
    ::
        %register-contract-for-compilation
      =/  =project  (~(got by projects) project.act)
      ?:  (~(has by to-compile.project) file.act)  `state
      =:  next-contract-id.project
        (add next-contract-id.project 1)
      ::
          user-files.project
        (~(put in user-files.project) file.act)
      ::
          to-compile.project
        %+  ~(put by to-compile.project)  file.act
        next-contract-id.project
      ==
      :-  (make-compile project.act our.bowl)^~
      state(projects (~(put by projects) project.act project))
    ::
        %compile-contracts
      ::  for internal use -- app calls itself to scry clay
      =/  =project  (~(got by projects) project.act)
      =/  build-results=(list (trel path id:smart build-result))
        %^  build-contract-projects  smart-lib-vase
          /(scot %p our.bowl)/[project.act]/(scot %da now.bowl)
        to-compile.project
      ~&  "done building, got errors:"
      =/  [cards=(list card) errors=(list [path @t])]
        (save-compiled-projects project.act build-results)
      ~&  errors
      =:  errors.project  errors
          p.chain.project
        %+  gas:big:engine  p.chain.project
        %+  murn  build-results
        |=  [p=path q=id:smart r=build-result]
        ?:  ?=(%| -.r)  ~
        :+  ~  q
        :*  %|
            id=q
            source=0x0
            holder=user-address.project
            town-id=designated-town-id
            code=p.r
            interface=~
            types=~
        ==
      ==
      :-  [(make-read-desk project.act our.bowl) cards]
      state(projects (~(put by projects) project.act project))
    ::
        %read-desk
      ::  for internal use -- app calls itself to scry clay
      =/  =project  (~(got by projects) project.act)
      =.  dir.project
        =-  .^((list path) %ct -)
        /(scot %p our.bowl)/(scot %tas project.act)/(scot %da now.bowl)
      :-  (make-project-update project.act project)^~
      state(projects (~(put by projects) project.act project))
    ::
        %add-item
      =/  =id:smart  (hash-data:smart source.act holder.act town-id.act salt.act)
      (add-or-update-item project.act %& id +.+.act)
    ::
        %update-item
      (add-or-update-item project.act %& +.+.act)
    ::
        %delete-item
      ::  remove a grain from the granary
      =/  =project  (~(got by projects) project.act)
      =.  p.chain.project
        (del:big:engine p.chain.project id.act)
      :-  (make-project-update project.act project)^~
      state(projects (~(put by projects) project.act project))
    ::
        %add-test
      ::  generate an id for the test
      =/  =project  (~(got by projects) project.act)
      =/  test-id  `@ux`(mug now.bowl)
      ::  ream action to form calldata
      =+  (text-to-zebra-noun action.act smart-lib-vase)
      =/  =calldata:smart  [;;(@tas -.-) +.-]
      =/  new-error=@ud  (fall expected-error.act 0)
      ::  put it in the project
      =.  tests.project
        %+  ~(put by tests.project)  test-id
        :*  name.act
            for-contract.act
            action.act
            calldata
            ~
            new-error
            ~
        ==
      :-  (make-project-update project.act project)^~
      state(projects (~(put by projects) project.act project))
    ::
        %add-test-expectation
      ::  add/replace expected data output
      =/  =project  (~(got by projects) project.act)
      ?~  current=(~(get by tests.project) test-id.act)
        ~|("%ziggurat: test does not exist" !!)
      =/  =id:smart  (hash-data:smart source.act holder.act town-id.act salt.act)
      =/  =data:smart
        [id source.act holder.act town-id.act salt.act label.act noun.act]
      =/  tex  ;;(@t noun.data)
      =/  new
        =-  [id.data %&^data(noun -) tex]
        (text-to-zebra-noun tex smart-lib-vase)
      =.  tests.project
        %+  ~(put by tests.project)  test-id.act
        u.current(expected (~(put by expected.u.current) new), result ~)
      :-  (make-project-update project.act project)^~
      state(projects (~(put by projects) project.act project))
    ::
        %delete-test-expectation
      =/  =project  (~(got by projects) project.act)
      ?~  current=(~(get by tests.project) id.act)
        ~|("%ziggurat: test does not exist" !!)
      =.  tests.project
        %+  ~(put by tests.project)  id.act
        u.current(expected (~(del by expected.u.current) delete.act), result ~)
      :-  (make-project-update project.act project)^~
      state(projects (~(put by projects) project.act project))
    ::
        %delete-test
      =/  =project  (~(got by projects) project.act)
      =.  tests.project  (~(del by tests.project) id.act)
      :-  (make-project-update project.act project)^~
      state(projects (~(put by projects) project.act project))
    ::
        %edit-test
      =/  =project  (~(got by projects) project.act)
      ::  ream action to form calldata
      =+  (text-to-zebra-noun action.act smart-lib-vase)
      =/  =calldata:smart  [;;(@tas -.-) +.-]
      =/  new-error
        ?~  expected-error.act  0
        u.expected-error.act
      ::  get existing
      =.  tests.project
        ?~  current=(~(get by tests.project) id.act)
          %+  ~(put by tests.project)  id.act
          :*  name.act
              for-contract.act
              action.act
              calldata
              ~
              new-error
              ~
          ==
        %+  ~(put by tests.project)  id.act
        :*  name.act
            for-contract.act
            action.act
            calldata
            expected.u.current
            (fall expected-error.act expected-error.u.current)
            ~
        ==
      :-  (make-project-update project.act project)^~
      state(projects (~(put by projects) project.act project))
    ::
        %run-test
      =/  =project  (~(got by projects) project.act)
      =/  =test  (~(got by tests.project) id.act)
      =/  caller
        (designated-caller user-address.project +(user-nonce.project))
      =/  =shell:smart
        :*  caller
            ~
            for-contract.test
            gas=[rate.act bud.act]
            designated-town-id
            status=0
        ==
      =/  =output:engine
        %~  intake  %~  eng  eng
          [caller designated-town-id batch-num.project eth-block-height=0]
        [chain.project [[0 0 0] action.test shell]]
      =/  =expected-diff
        %-  malt
        %+  turn  ~(tap by modified.output)
        |=  [=id:smart [@ux made=item:smart]]
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
        ?&  =(errorcode.output expected-error.test)
        ::
            %+  levy  ~(val by expected-diff)
            |=  [(unit item:smart) (unit item:smart) match=(unit ?)]
            ?~  match  %.y
            u.match
        ==
      ::
      =/  =test-result
        :*  gas.output
            errorcode.output
            events.output
            expected-diff
            success
        ==
      ::  save result in test, send update
      =.  tests.project
        (~(put by tests.project) id.act test(result `test-result))
      :-  (make-project-update project.act project)^~
      state(projects (~(put by projects) project.act project))
    ::
        %run-tests
      ::  run tests IN SUCCESSION against SAME STATE
      ::  note that this doesn't save last-result for each test,
      ::  as results here will not reflect *just this test*
      =/  =project  (~(got by projects) project.act)
      =/  [eggs=(list [@ux transaction:smart]) new-nonce=@ud]
        %^  spin  tests.act  user-nonce.project
        |=  [[id=@ux rate=@ud bud=@ud] nonce=@ud]
        =/  =test  (~(got by tests.project) id)
        =/  caller  (designated-caller user-address.project +(nonce))
        =/  =shell:smart
          :*  caller
              ~
              for-contract.test
              gas=[rate bud]
              designated-town-id
              status=0
          ==
        :_  +(nonce)
        :-  `@ux`(sham shell action.test)
        [[0 0 0] action.test shell]
      =/  res=state-transition:engine
        %+  %~  run  eng
            [(designated-caller user-address.project 0) designated-town-id batch-num.project 0]
        chain.project  (silt eggs)
      :-  (make-multi-test-update project.act res)^~
      state(projects (~(put by projects) project.act project))
    ::
        %deploy-contract  ::  TODO
      !!
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
          (make-compile project.act our.bowl)
        =-  [%pass /treaty-wire %agent [our.bowl %treaty] %poke -]
        [%alliance-update-0 !>([%add our.bowl `@tas`project.act])]
      ~
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
    =:  p.chain.project
      %+  put:big:engine  p.chain.project
      [id.data %&^data]
    ::
        noun-texts.project
      (~(put by noun-texts.project) id.data noun-text)
    ==
    :-  (make-project-update project-id project)^~
    state(projects (~(put by projects) project-id project))
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
    ::   [%project-nock @ ~]
    :: ?~  project=(~(get by projects) (slav %t i.t.t.path))
    ::   ``noun+!>(~)
    :: ?>  ?=(%& -.u.project)
    :: ?~  compiled.p.u.project
    ::   ``noun+!>(~)
    :: ``noun+!>(compiled.p.u.project)
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
    ?~  project=(~(get by projects) i.t.t.path)
      ``json+!>(~)
    =/  =json  (state-to-json p.chain.u.project noun-texts.u.project)
    ``json+!>(json)
  ::
      [%project-tests @ ~]
    ?~  project=(~(get by projects) i.t.t.path)
      ``json+!>(~)
    =/  =json  (tests-to-json tests.u.project)
    ``json+!>(json)
  ::
      [%project-user-files @ ~]
    ?~  project=(~(get by projects) i.t.t.path)
      ``json+!>(~)
    ``json+!>(`json`(user-files-to-json user-files.u.project))
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
