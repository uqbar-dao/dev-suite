/-  engine=zig-engine, docket, wallet=zig-wallet
/+  smart=zig-sys-smart
|%
+$  card  card:agent:gall
::
+$  projects  (map @t project)
+$  project
  $:  dir=(list path)
      user-files=(set path)  ::  not on list -> grayed out in GUI
      to-compile=(map path id:smart)  ::  compile these contracts with these id's
      next-contract-id=id:smart
      errors=(list [path @t])
      =chain:engine
      noun-texts=(map id:smart @t)  ::  holds `noun.data` that got ream'd
      user-address=address:smart
      user-nonce=@ud
      batch-num=@ud
      =tests
  ==
::
+$  build-result   (each [bat=* pay=*] @t)
::
+$  tests  (map @ux test)
+$  test
  $:  name=(unit @t)  ::  optional
      steps=test-steps
      results=test-results
  ==
::
+$  expected-diff
  (map id:smart [made=(unit item:smart) expected=(unit item:smart) match=(unit ?)])
::
+$  test-steps  (list test-step)
::+$  test-step   ?(test-read-step test-write-step)
+$  test-step  test-write-step
+$  test-read-step
  $%  [%scry payload=scry-payload expected=@t]
      [%read-subscription payload=read-sub-payload expected=@t timeout=@dr]  ::  not sure if need timeout: if want to not block so can handle out-of-order when multiple subscriptions are being passed around, may need it. Ideally wouldn't need.
      [%wait until=@dr]
  ==
+$  test-write-step
  $%  [%poke payload=poke-payload expected=(list test-read-step)]
      [%subscribe payload=sub-payload expected=(list test-read-step)]
  ==
+$  scry-payload  [who=@p =mold care=@tas app=@tas p=path]
+$  read-sub-payload  [who=@p =mold care=@tas app=@tas p=path]  :: TODO
+$  poke-payload  [who=@p app=@tas payload=cage]
+$  sub-payload  [who=@p app=@tas p=path]
::
+$  test-results  (list test-result)
+$  test-result  (list [success=? expected=@t result=@t])
  :: %+  each  [success=? expected=@t result=@t]
  :: (list [success=? expected=@t result=@t])
::
+$  template  ?(%fungible %nft %blank)
::
+$  deploy-location  ?(%local testnet)
+$  testnet  ship
::
+$  action
  $:  project=@t
      $%  [%new-project user-address=address:smart]
          [%populate-template =template metadata=data:smart]  ::  TODO
          [%delete-project ~]
      ::
          [%save-file file=path text=@t]  ::  generates new file or overwrites existing
          [%delete-file file=path]
          ::
          [%register-contract-for-compilation file=path]
          [%compile-contracts ~]  ::  alterations to project files call %compile-contracts which calls %read-desk which sends a project update; TODO: skip compile when no change?
          [%read-desk ~]
          ::
          [%add-to-state source=id:smart holder=id:smart town-id=@ux salt=@ label=@tas noun=*]
          [%delete-from-state =id:smart]
          ::
          [%add-test name=(unit @t) =test-steps]  ::  name optional
          [%delete-test id=@ux]
          :: [%edit-test id=@ux name=(unit @t) for-contract=id:smart action=@t expected-error=(unit @ud)]
          [%run-test id=@ux rate=@ud bud=@ud]
          [%run-tests tests=(list [id=@ux rate=@ud bud=@ud])]  :: each one run with same gas
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
      ==
  ==
::
::  subscription update types
::
+$  project-update
  $:  dir=(list path)
      user-files=(set path)
      compiled=?
      errors=(list [path @t])
      =chain:engine
      noun-texts=(map id:smart @t)
      =tests
  ==
::
+$  test-update
  [%result state-transition:engine]
--
