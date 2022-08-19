/-  mill
/+  smart=zig-sys-smart
|%
+$  card  card:agent:gall
::
+$  projects  (map @t project)
+$  project   (each contract-project app-project)
::
+$  app-project
  ~  ::  TODO later
::
+$  contract-project
  $:  main=@t
      libs=(map name=@t text=@t)
      compiled=(unit [bat=* pay=*])
      imported=(map name=@t text=@t)  ::  any other files to view but not compile
      error=(unit @t)  ::  ~ means successfully compiled
      state=land:mill
      =tests
  ==
::
+$  build-result   (each [bat=* pay=*] compile-error)
+$  compile-error  (list tank)
::
+$  tests  (map @ud test)
+$  test
  $:  id=@ud
      name=(unit @t)  ::  optional
      action=yolk:smart
      last-result=(unit mill-result:mill)
  ==
::
+$  template  ?(%fungible %nft %blank)
::
+$  deploy-location  [?(%local testnet) town-id=@ux]
+$  testnet  ship
::
::  available actions. TODO actions for gall side
::
+$  action
  $%  [%new-contract-project =template project=@t]  ::  creates a contract project, TODO add gall option
      [%delete-project project=@t]
      [%save-file project=@t name=@t text=@t]  ::  generates new file or overwrites existing
      [%delete-file project=@t name=@t]
      ::
      [%add-to-state project=@t =rice:smart]
      [%delete-from-state project=@t =id:smart]
      ::
      [%add-test name=(unit @t) action=yolk:smart]  ::  name optional
      [%delete-test id=@ud]
      [%edit-test id=@ud name=(unit @t) action=yolk:smart]
      [%run-test id=@ud]
      [%run-tests ids=(list @ud)]
      ::
      [%deploy-contract =deploy-location]
  ==
::
::  subscription update types
::
+$  contract-update
  $:  compiled=?
      error=(unit @t)
      state=land:mill
      =tests
  ==
::
+$  app-update
  ~  ::  TODO app project update
::
+$  test-update
  [id=@ud result=mill-result:mill]
--
