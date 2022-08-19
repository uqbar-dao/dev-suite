/-  mill
/+  smart=zig-sys-smart
|%
+$  projects  (map @t project)
+$  project   (pair @t (each contract gall-app))
+$  file      [name=@t text=@t]
::
+$  gall-app
  ~  ::  TODO later
::
+$  contract
  $:  main=file
      libs=(list file)
      imported=(list file)  ::  any other files to view but not compile
      error=(unit (list tank))
      state=land:mill
      =tests
  ==
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
  $%  [%new-project =template name=@t]  ::  creates a contract project, TODO add gall option
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
--
