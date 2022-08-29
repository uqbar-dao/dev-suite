/-  mill, docket
/+  smart=zig-sys-smart
|%
+$  card  card:agent:gall
::
+$  projects  (map @t project)
+$  project   (each contract-project app-project)
::
+$  app-project
  $:  dir=(list path)
      error=(unit @t)
      compiled=?
      =clause:docket
  ==
::
+$  contract-project
  $:  main=@t
      libs=(map name=@t text=@t)
      compiled=(unit [bat=* pay=*])
      imported=(map name=@t text=@t)  ::  any other files to view but not compile
      error=(unit @t)  ::  ~ means successfully compiled
      state=land:mill
      data-texts=(map id:smart @t)  ::  holds rice data that got ream'd
      caller-nonce=@ud
      mill-batch-num=@ud
      =tests
  ==
::
+$  build-result   (each [bat=* pay=*] @t)
::
+$  tests  (map @ux test)
+$  test
  $:  name=(unit @t)  ::  optional
      action-text=@t
      action=yolk:smart
      expected=(unit (set rice:smart))
      last-result=(unit mill-result:mill)
      success=(unit ?)  ::  does last-result match expected?
  ==
::
+$  template  ?(%fungible %nft %blank)
::
+$  deploy-location  ?(%local testnet)
+$  testnet  ship
::
::  available actions. TODO actions for gall side
::
+$  contract-action
  $:  project=@t
      $%  [%new-contract-project =template]  ::  creates a contract project, TODO add gall option
          [%populate-template =template metadata=rice:smart]
          [%delete-project ~]
          [%save-file name=@t text=@t]  ::  generates new file or overwrites existing
          [%delete-file name=@t]
          ::
          [%add-to-state =rice:smart]
          [%delete-from-state =id:smart]
          ::
          [%add-test name=(unit @t) action=@t]  ::  name optional
          [%add-test-expectations id=@ux expected=(set rice:smart)]
          [%delete-test id=@ux]
          [%edit-test id=@ux name=(unit @t) action=@t]
          [%run-test id=@ux rate=@ud bud=@ud]
          [%run-tests tests=(list [id=@ux rate=@ud bud=@ud])]  :: each one run with same gas
          ::
          [%deploy-contract =deploy-location town-id=@ux]
      ==
  ==
::
+$  app-action
  $:  project=@t
      $%  [%new-app-project ~]
          [%delete-project ~]
          ::
          [%save-file file=path text=@t]
          [%delete-file file=path]
          ::
          [%read-desk ~]
          ::
          [%publish-app clause:docket]
      ==
  ==
::
::  subscription update types
::
+$  contract-update
  $:  compiled=?
      error=(unit @t)
      state=land:mill
      data-texts=(map id:smart @t)
      =tests
  ==
::
+$  app-update
  ::  should scry clay with %t to get dir here
  ::  TODO: how to retrieve compilation result for gall app?
  $:  dir=(list path)
      error=(unit @t)
      compiled=?
  ==
::
+$  test-update
  [%result state-transition:mill]
--
