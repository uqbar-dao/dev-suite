/-  engine=zig-engine, docket, wallet=zig-wallet
/+  engine-lib=zig-sys-engine,
    smart=zig-sys-smart
|%
+$  card  card:agent:gall
+$  state-0
  $:  %0
      =projects
      virtualnet-addresses=(map @p address:smart)
      pyro-ships-ready=(map ship ?)
      test-queue=(qeu [project=@t test-id=@ux])
      test-running=?
  ==
+$  inflated-state-0  [state-0 =eng smart-lib-vase=vase]
+$  eng  $_  ~(engine engine:engine-lib !>(0) *(map * @) %.n %.n)  ::  sigs off, hints off
::
+$  projects  (map @t project)
+$  project
  $:  dir=(list path)
      user-files=(set path)  ::  not on list -> grayed out in GUI
      to-compile=(set path)
      errors=(list [path @t])
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
      surs=test-surs
      subject=(each vase @t)  ::  test-surs build or error
      =custom-step-definitions
      steps=test-steps
      results=test-results
  ==
::
+$  expected-diff
  (map id:smart [made=(unit item:smart) expected=(unit item:smart) match=(unit ?)])
::
+$  test-surs  (list path)
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
+$  poke-payload  [who=@p app=@tas mark=@tas payload=@t]
+$  sub-payload  [who=@p to=@p app=@tas path=@t]
::
+$  custom-step-definitions
  %+  map  @tas
  (pair custom-step-definition custom-step-compiled)
+$  custom-step-definition  @t
+$  custom-step-compiled  (each transform=vase @t)
::
+$  test-results  (list test-result)
+$  test-result   (list [success=? expected=@t result=@t])
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
+$  action
  $:  project=@t
      $%  [%new-project ~]
          [%populate-template =template metadata=data:smart]  ::  TODO
          [%delete-project ~]
      ::
          [%save-file file=path text=@t]  ::  generates new file or overwrites existing
          [%delete-file file=path]
      ::
          [%set-virtualnet-address who=@p =address:smart]
      ::
          [%register-contract-for-compilation file=path]
          [%compile-contracts ~]  ::  alterations to project files call %compile-contracts which calls %read-desk which sends a project update; TODO: skip compile when no change?
          [%read-desk ~]
      ::
          [%add-item source=id:smart holder=id:smart town-id=@ux salt=@ label=@tas noun=*]
          [%update-item =id:smart source=id:smart holder=id:smart town-id=@ux salt=@ label=@tas noun=*]
          [%delete-item =id:smart]
      ::
          [%add-test name=(unit @t) =test-surs =test-steps]  ::  name optional
          [%delete-test id=@ux]
          [%run-test id=@ux]
          [%add-and-run-test name=(unit @t) =test-surs =test-steps]
          [%run-queue ~]  ::  can be used as [%$ %run-queue ~]
          [%clear-queue ~]
          [%queue-test id=@ux]
          [%add-and-queue-test name=(unit @t) =test-surs =test-steps]
          ::
          [%add-custom-step test-id=@ux tag=@tas =custom-step-definition]
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
          $:  %deploy-contract
              =path
              =address:smart
              rate=@ud  bud=@ud
              =deploy-location
              town-id=@ux
              upgradable=?
          ==
          ::
          [%add-user-file file=path]
          [%delete-user-file file=path]
      ==
  ==
::
::  subscription update types
::
+$  project-update
  $:  state=json  ::  state=(map @ux chain:engine)
      project
  ==
::
+$  test-update
  [%result state-transition:engine]
--
