/-  mill
/+  smart=zig-sys-smart
|%
+$  card  card:agent:gall
::
+$  projects  (map @t project)
+$  project   (each contract-project app-project)
+$  file      [name=@t text=@t]  ::  always .hoon files
::
+$  app-project
  ~  ::  TODO later
::
+$  contract-project
  $:  main=file
      libs=(list file)
      compiled=(unit [bat=* pay=*])
      imported=(list file)  ::  any other files to view but not compile
      error=(unit compile-error)  ::  ~ means successfully compiled
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
+$  deploy-location  ?(%local testnet)
+$  testnet  ship
::
::  available actions. TODO actions for gall side
::
+$  action
  $%  [%new-contract-project =template name=@t]  ::  creates a contract project, TODO add gall option
      [%delete-project name=@t]
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
      error=(unit compile-error)
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
