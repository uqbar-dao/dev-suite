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
    =/  name=@t  (slav %t i.t.path)
    ?~  proj=(~(get by projects) name)
      `this
    ?>  ?=(%& -.u.proj)
    [(make-contract-update path p.u.proj)^~ this]
  ::
      [%app-project @ ~]
    ::  TODO
    =/  name=@t  (slav %t i.t.path)
    ?~  proj=(~(get by projects) name)
      `this
    ?>  ?=(%| -.u.proj)
    [(make-app-update path p.u.proj)^~ this]
  ::
      [%test-updates @ ~]
    ::  serve updates for all tests executed
    ::  within a given contract project
    `this
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^
  =^  cards  state
    (handle-poke !<(action vase))
  [cards this]
  ::
  ++  handle-poke
    |=  act=action
    ^-  (quip card _state)
    ?-    -.act
    ::
    ::  project creation/deletion
    ::
        %new-contract-project
      ?:  (~(has by projects) name.act)
        ~|("%ziggurat: project name already taken" !!)
      =/  [main=@t libs=(map @t @t)]
        ?-    template.act
            %blank
          [blank:templates ~]
        ::
            %nft
          :-  main:nft:templates
          (malt ['lib' lib:nft:templates]~)
        ::
            %fungible
          :-  main:fungible:templates
          (malt ['lib' lib:fungible:templates]~)
        ==
      =/  proj=contract-project
        :*  main  libs
            compiled=~
            imported=~
            error=~
            state=starting-state
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
        `(get-formatted-error p.build-result)
      :_  state(projects (~(put by projects) name.act %&^proj))
      (make-contract-update /contract-project/(scot %t name.act) proj)^~
    ::
        %delete-project
      ::  should show a warning on frontend before performing this one ;)
      `state(projects (~(del by projects) name.act))
    ::
    ::  file management
    ::
        %save-file
      ::  NOTE: make sure to enforce on frontend that 'main' file name
      ::  always matches the name of the project, and that no other files
      ::  in the project can use that name.
      ?~  proj=(~(get by projects) project.act)
        ~|("%ziggurat: project does not exist" !!)
      ?>  ?=(%& -.u.proj)
      =*  project  p.u.proj
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
        `(get-formatted-error p.build-result)
      :_  state(projects (~(put by projects) project.act %&^project))
      (make-contract-update /contract-project/(scot %t name.act) project)^~
    ::
        %delete-file
      ?~  proj=(~(get by projects) project.act)
        ~|("%ziggurat: project does not exist" !!)
      ?>  ?=(%& -.u.proj)
      =*  project  p.u.proj
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
        `(get-formatted-error p.build-result)
      :_  state(projects (~(put by projects) project.act %&^project))
      (make-contract-update /contract-project/(scot %t name.act) project)^~
    ::
    ::  local chain state management
    ::
        %add-to-state
      !!
    ::
        %delete-from-state
      !!
    ::
    ::  test management
    ::
        %add-test
      !!
    ::
        %delete-test
      !!
    ::
        %edit-test
      !!
    ::
        %run-test
      !!
    ::
        %run-tests
      !!
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
  ?+    +.path  (on-peek:def path)
      [%path ~]
    ``noun+!>(~)
  ==
::
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--
