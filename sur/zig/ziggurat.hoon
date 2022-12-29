/-  engine=zig-engine, docket, wallet=zig-wallet
/+  engine-lib=zig-sys-engine,
    smart=zig-sys-smart
|%
+$  state-0
  $:  %0
      =projects
      virtualnet-addresses=(map @p address:smart)
      pyro-ships-ready=(map ship ?)
      test-queue=(qeu [project=@t test-id=@ux])
      test-running=?
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
      errors=(map path @t)
      town-sequencers=(map @ux @p)
      =tests
      dbug-dashboards=(map app=@tas dbug-dashboard)
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
+$  shown-test-results  (list shown-test-result)
+$  shown-test-result   (list [success=? expected=@t result=@t])
::
+$  template  ?(%fungible %nft %blank)
::
+$  deploy-location  ?(%local testnet)
+$  testnet  ship
::
+$  dbug-dashboard
  $:  sur=path
      mold-name=@t
      mar=path
      mold=(each vase @t)
      mar-tube=(unit tube:clay)
  ==
::
+$  test-globals
  $:  our=@p
      now=@da
      =test-results
      project=@tas
      addresses=(map @p address:smart)
  ==
::
+$  ca-scry-cache  (map [@tas path] (pair @ux vase))
::
+$  action
  $:  project=@t
      $%  [%new-project ~]
          [%delete-project ~]
      ::
          [%save-file file=path text=@t]  ::  generates new file or overwrites existing
          [%delete-file file=path]
      ::
          [%set-virtualnet-address who=@p =address:smart]
      ::
          [%register-contract-for-compilation file=path]
          [%deploy-contract town-id=@ux =path]
      ::
          [%compile-contracts ~]  ::  make-read-desk
          [%compile-contract =path]  ::  path of form /[desk]/path/to/contract, e.g., /zig/con/fungible/hoon
          [%read-desk ~]  ::  make-project-update, make-watch-for-file-changes
      ::
          [%add-test name=(unit @t) =test-imports =test-steps]  ::  name optional
          [%add-and-run-test name=(unit @t) =test-imports =test-steps]
          [%add-and-queue-test name=(unit @t) =test-imports =test-steps]
          [%save-test-to-file id=@ux =path]
      ::
          [%add-test-file name=(unit @t) =path]  ::  name optional
          [%add-and-run-test-file name=(unit @t) =path]
          [%add-and-queue-test-file name=(unit @t) =path]
      ::
          [%delete-test id=@ux]
          [%run-test id=@ux]
          [%run-queue ~]  ::  can be used as [%$ %run-queue ~]
          [%clear-queue ~]
          [%queue-test id=@ux]
      ::
          [%add-custom-step test-id=@ux tag=@tas =path]
          [%delete-custom-step test-id=@ux tag=@tas]
      ::
          [%add-app-to-dashboard app=@tas sur=path mold-name=@t mar=path]
          [%delete-app-from-dashboard app=@tas]
      ::
          [%add-town-sequencer town-id=@ux who=@p]
          [%delete-town-sequencer town-id=@ux]
      ::
          [%stop-pyro-ships ~]
          [%start-pyro-ships ships=(list @p)]  ::  ships=~ -> [~nec ~bud]
          [%start-pyro-snap snap=path]
      ::
          [%publish-app title=@t info=@t color=@ux image=@t version=[@ud @ud @ud] website=@t license=@t]
      ::
          [%add-user-file file=path]
          [%delete-user-file file=path]
      ==
  ==
::
::  subscription update types
::
+$  project-update
  $%
    $:  %error
        project-name=@t
        source=@tas
        level=@tas
        message=@t
    ==
  ::
    $:  %update
        project-name=@t
        state=(map @ux chain:engine)
        project
    ==
  ==
--
