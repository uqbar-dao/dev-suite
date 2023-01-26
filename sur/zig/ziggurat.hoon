/-  docket,
    engine=zig-engine,
    wallet=zig-wallet
/+  engine-lib=zig-sys-engine,
    mip,
    smart=zig-sys-smart
|%
+$  state-0
  $:  %0
      =projects
      =configs
      =sync-desk-to-vship
      pyro-ships-ready=(map @p ?)
      test-queue=(qeu [project=@t test-id=@ux])
      test-running=?
      cis-running=(map @p @t)
  ==
+$  inflated-state-0
  $:  state-0
      =eng
      smart-lib-vase=vase
      =ca-scry-cache
  ==
+$  eng  $_  ~(engine engine:engine-lib !>(0) *(map * @) %.n %.n)  ::  sigs off, hints off
::
+$  projects  (map @t project)
+$  project
  $:  dir=(list path)
      user-files=(set path)  ::  not on list -> grayed out in GUI
      to-compile=(set path)
      =tests
  ==
::
+$  build-result  (each [bat=* pay=*] @t)
::
+$  tests  (map @ux test)
+$  test
  $:  name=(unit @t)  ::  optional
      test-steps-file=path
      =test-imports
      subject=(each vase @t)
      =custom-step-definitions
      steps=test-steps
      results=test-results
  ==
::
+$  configs  (mip:mip project-name=@t [who=@p what=@tas] @)
+$  config   (map [who=@p what=@tas] @)
::
+$  sync-desk-to-vship  (jug @tas @p)
::
+$  expected-diff
  (map id:smart [made=(unit item:smart) expected=(unit item:smart) match=(unit ?)])
::
+$  test-imports  (map @tas path)
::
+$  test-steps  (list test-step)
+$  test-step  $%(test-read-step test-write-step)
+$  test-read-step
  $%  [%scry payload=scry-payload expected=@t]
      [%dbug payload=dbug-payload expected=@t]
      [%read-subscription payload=read-sub-payload expected=@t]
      [%wait until=@dr]
      [%custom-read tag=@tas payload=@t expected=@t]
  ==
+$  test-write-step
  $%  [%dojo payload=dojo-payload expected=(list test-read-step)]
      [%poke payload=poke-payload expected=(list test-read-step)]
      [%subscribe payload=sub-payload expected=(list test-read-step)]
      [%custom-write tag=@tas payload=@t expected=(list test-read-step)]
  ==
+$  scry-payload
  [who=@p mold-name=@t care=@tas app=@tas =path]
+$  dbug-payload  [who=@p mold-name=@t app=@tas]
+$  read-sub-payload  [who=@p to=@p app=@tas =path]
+$  dojo-payload  [who=@p payload=@t]
+$  poke-payload  [who=@p to=@p app=@tas mark=@tas payload=@t]
+$  sub-payload  [who=@p to=@p app=@tas =path]
::
+$  custom-step-definitions
  (map @tas (pair path custom-step-compiled))
+$  custom-step-compiled  (each transform=vase @t)
::
+$  test-results  (list test-result)
+$  test-result   (list [success=? expected=@t result=vase])
::
+$  template  ?(%fungible %nft %blank)
::
+$  deploy-location  ?(%local testnet)
+$  testnet  ship
::
+$  configuration-file-output
  $:  =config
      ships=(list @p)
      install=?
      start=(list @tas)
      setup=(map @p test-steps)
      imports=(list [@tas path])
  ==
::
+$  test-globals
  $:  our=@p
      now=@da
      =test-results
      project=@tas
      =configs
  ==
::
+$  ca-scry-cache  (map [@tas path] (pair @ux vase))
::
+$  action
  $:  project=@t
      request-id=(unit @t)
      $%  [%new-project sync-ships=(list @p)]
          [%delete-project ~]
          [%save-config-to-file ~]
      ::
          [%add-sync-desk-vships ships=(list @p) install=? start-apps=(list @tas)]
          [%delete-sync-desk-vships ships=(list @p)]
      ::
          [%save-file file=path text=@t]  ::  generates new file or overwrites existing
          [%delete-file file=path]
      ::
          [%add-config who=@p what=@tas item=@]
          [%delete-config who=@p what=@tas]
      ::
          [%register-contract-for-compilation file=path]
          [%deploy-contract town-id=@ux =path]
      ::
          [%compile-contracts ~]  ::  make-read-desk
          [%compile-contract =path]  ::  path of form /[desk]/path/to/contract, e.g., /zig/con/fungible/hoon
          [%read-desk ~]  ::  make-project-update, make-watch-for-file-changes
      ::
          [%add-test name=(unit @t) =test-imports =test-steps]
          [%add-and-run-test name=(unit @t) =test-imports =test-steps]
          [%add-and-queue-test name=(unit @t) =test-imports =test-steps]
          [%save-test-to-file id=@ux =path]
      ::
          [%add-test-file name=(unit @t) =path]
          [%add-and-run-test-file name=(unit @t) =path]
          [%add-and-queue-test-file name=(unit @t) =path]
      ::
          [%edit-test id=@ux name=(unit @t) =test-imports =test-steps]
          [%delete-test id=@ux]
          [%run-test id=@ux]
          [%run-queue ~]  ::  can be used as [%$ %run-queue ~]
          [%clear-queue ~]
          [%queue-test id=@ux]
      ::
          [%add-custom-step test-id=@ux tag=@tas =path]
          [%delete-custom-step test-id=@ux tag=@tas]
      ::
          [%stop-pyro-ships ~]
          [%start-pyro-ships ships=(list @p)]  ::  ships=~ -> ~[~nec ~bud ~wes]
          [%start-pyro-snap snap=path]
      ::
          [%publish-app title=@t info=@t color=@ux image=@t version=[@ud @ud @ud] website=@t license=@t]
      ::
          [%add-user-file file=path]
          [%delete-user-file file=path]
      ::
          [%send-pyro-dojo who=@p command=tape]
      ::
          [%cis-panic ~]
      ==
  ==
::
::  subscription update types
::
+$  update-tag
  $?  %project-names
      %projects
      %project
      %state
      %new-project
      %add-config
      %delete-config
      %add-test
      %edit-test
      %compile-contract
      %delete-test
      %run-queue
      %add-custom-step
      %delete-custom-step
      %add-user-file
      %delete-user-file
      %custom-step-compiled
      %test-results
      %dir
      %pyro-ships-ready
      %poke
      %test-queue
      %pyro-agent-state
      %sync-desk-to-vship
      %cis-running
  ==
+$  update-level  ?(%success error-level)
+$  error-level   ?(%info %warning %error)
+$  update-info
  [project-name=@t source=@tas request-id=(unit @t)]
::
++  data  |$(this (each this [level=error-level message=@t]))
::
+$  update
  $@  ~
  $%  [%project-names update-info payload=(data ~) project-names=(set @t)]
      [%projects update-info payload=(data ~) projects=shown-projects]
      [%project update-info payload=(data ~) shown-project]
      [%state update-info payload=(data ~) state=(map @ux chain:engine)]
      [%new-project update-info payload=(data =sync-desk-to-vship) ~]
      [%add-config update-info payload=(data [who=@p what=@tas item=@]) ~]
      [%delete-config update-info payload=(data [who=@p what=@tas]) ~]
      [%add-test update-info payload=(data shown-test) test-id=@ux]
      [%compile-contract update-info payload=(data ~) ~]
      [%edit-test update-info payload=(data shown-test) test-id=@ux]
      [%delete-test update-info payload=(data ~) test-id=@ux]
      [%run-queue update-info payload=(data ~) ~]
      [%add-custom-step update-info payload=(data ~) test-id=@ux tag=@tas]
      [%delete-custom-step update-info payload=(data ~) test-id=@ux tag=@tas]
      [%add-user-file update-info payload=(data ~) file=path]
      [%delete-user-file update-info payload=(data ~) file=path]
      [%custom-step-compiled update-info payload=(data ~) test-id=@ux tag=@tas]
      [%test-results update-info payload=(data shown-test-results) test-id=@ux thread-id=@t =test-steps]
      [%dir update-info payload=(data (list path)) ~]
      [%pyro-ships-ready update-info payload=(data (map @p ?)) ~]
      [%poke update-info payload=(data ~) ~]
      [%test-queue update-info payload=(data (qeu [@t @ux])) ~]
      [%pyro-agent-state update-info payload=(data [agent-state=@t wex=boat:gall sup=bitt:gall]) ~]
      [%sync-desk-to-vship update-info payload=(data sync-desk-to-vship) ~]
      [%cis-running update-info payload=(data (map @p @t)) ~]
  ==
::
+$  shown-projects  (map @t shown-project)
+$  shown-project
  $:  dir=(list path)
      user-files=(set path)  ::  not on list -> grayed out in GUI
      to-compile=(set path)
      tests=shown-tests
  ==
+$  shown-tests  (map @ux shown-test)
+$  shown-test
  $:  name=(unit @t)  ::  optional
      test-steps-file=path
      =test-imports
      subject=(each vase @t)
      =custom-step-definitions
      steps=test-steps
      results=shown-test-results
      test-id=@ux
  ==
+$  shown-test-results  (list shown-test-result)
+$  shown-test-result   (list [success=? expected=@t result=@t])
--
