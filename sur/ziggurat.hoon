/-  mill, docket, wallet
/+  smart=zig-sys-smart
|%
+$  card  card:agent:gall
::
+$  projects  (map @t project)
+$  project   (each contract-project app-project)
::
+$  app-project
  dir=(list path)
::
+$  contract-project
  $:  main=@t
      libs=(map name=@t text=@t)
      compiled=(unit [bat=* pay=*])
      imported=(map name=@t text=@t)  ::  any other files to view but not compile
      error=(unit @t)  ::  ~ means successfully compiled
      state=land:mill
      data-texts=(map id:smart @t)  ::  holds rice data that got ream'd
      user-address=address:smart
      user-nonce=@ud
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
      expected=(map id:smart [grain:smart @t])
      expected-error=@ud  ::  bad, but we can't get term literals :/
      result=(unit test-result)
  ==
::
+$  test-result
  $:  fee=@ud
      =errorcode:smart
      =crow:smart
      =expected-diff
      success=(unit ?)  ::  does last-result fully match expected?
  ==
+$  expected-diff
  (map id:smart [made=(unit grain:smart) expected=(unit grain:smart) match=(unit ?)])
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
      $%  [%new-contract-project =template user-address=address:smart]  ::  creates a contract project, TODO add gall option
          [%populate-template =template metadata=rice:smart]
          [%delete-project ~]
          [%save-file name=@t text=@t]  ::  generates new file or overwrites existing
          [%delete-file name=@t]
          ::
          [%add-to-state salt=@ label=@tas data=* lord=id:smart holder=id:smart town-id=id:smart]
          [%delete-from-state =id:smart]
          ::
          [%add-test name=(unit @t) action=@t expected-error=(unit @ud)]  ::  name optional
          [%add-test-expectation id=@ux salt=@ label=@tas data=* lord=id:smart holder=id:smart town-id=id:smart]
          [%delete-test-expectation id=@ux delete=id:smart]
          [%delete-test id=@ux]
          [%edit-test id=@ux name=(unit @t) action=@t expected-error=(unit @ud)]
          [%run-test id=@ux rate=@ud bud=@ud]
          [%run-tests tests=(list [id=@ux rate=@ud bud=@ud])]  :: each one run with same gas
          ::
          $:  %deploy-contract
              =address:smart
              rate=@ud  bud=@ud
              =deploy-location
              town-id=@ux
              upgradable=?
          ==
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
          [%approve-cors-domain domain=@t]
          ::
          [%publish-app title=@t info=@t color=@ux image=@t version=[@ud @ud @ud] website=@t license=@t]
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
  dir=(list path)
::
+$  test-update
  [%result state-transition:mill]
--
