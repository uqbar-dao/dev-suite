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
      =test-steps
      results=(unit test-results)
  ==
::   $:  name=(unit @t)  ::  optional
::       for-contract=id:smart
::       action-text=@t
::       action=calldata:smart
::       expected=(map id:smart [item:smart @t])
::       expected-error=@ud  ::  bad, but we can't get term literals :/
::       result=(unit test-result)
::   ==
:: ::
:: +$  test-result
::   $:  fee=@ud
::       =errorcode:smart
::       events=(list contract-event:engine)
::       =expected-diff
::       success=(unit ?)  ::  does last-result fully match expected?
::   ==
::
+$  expected-diff
  (map id:smart [made=(unit item:smart) expected=(unit item:smart) match=(unit ?)])
::
+$  test-steps  (list test-step)
+$  test-step   ?(test-read test-write)
+$  test-read-step
  :: $%  [%scry scry-payload expected=cage]
  ::     [%read-subscription expected=cage timeout=@dr]  ::  not sure if need timeout: if want to not block so can handle out-of-order when multiple subscriptions are being passed around, may need it. Ideally wouldn't need.
  $%  [%scry payload=scry-payload expected=@t]
      [%read-subscription payload=sub-read-payload expected=@t timeout=@dr]  ::  not sure if need timeout: if want to not block so can handle out-of-order when multiple subscriptions are being passed around, may need it. Ideally wouldn't need.
      [%wait until=@dr]
  ==
+$  test-write-step
  $%  [%poke payload=poke-payload expected=(list test-read-step)]
      :: [%subscribe expected-on-watch=(unit cage) expected=(list test-read-step)]
      [%subscribe payload=sub-payload expected=(list test-read-step)]
  ==
+$  poke-payload  [who=@p app=@tas payload=cage]
+$  scry-payload  [who=@p =mold care=@tas app=@tas p=path]
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
          [%populate-template =template metadata=data:smart]
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
          [%add-test name=(unit @t) for-contract=id:smart action=@t expected-error=(unit @ud)]  ::  name optional
          [%add-test-expectation test-id=@ux source=id:smart holder=id:smart town-id=@ux salt=@ label=@tas noun=*]
          [%delete-test-expectation id=@ux delete=id:smart]
          [%delete-test id=@ux]
          [%edit-test id=@ux name=(unit @t) for-contract=id:smart action=@t expected-error=(unit @ud)]
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
