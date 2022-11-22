/-  engine=zig-engine, docket, wallet=zig-wallet
/+  engine-lib=zig-sys-engine,
    smart=zig-sys-smart
|%
+$  card  card:agent:gall
+$  state-0
  $:  %0
      =projects
      =custom-step-definitions
      virtualnet-addresses=(map @p address:smart)
      pyro-ships-ready=(map ship ?)
      running-test=(unit [project=@t test-id=@ux])
      test-queue=(list [project=@t test-id=@ux])  ::  i.test-queue is next
  ==
+$  inflated-state-0  [state-0 =eng smart-lib-vase=vase]
+$  eng  $_  ~(engine engine:engine-lib !>(0) *(map * @) %.n %.n)  ::  sigs off, hints off
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
+$  build-result  (each [bat=* pay=*] @t)
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
+$  test-step  $%(test-read-step test-write-step)
+$  test-read-step
  $%  [%scry payload=scry-payload expected=@t]
      :: [%dbug payload=dbug-payload expected=@t]  :: TODO
      [%read-subscription payload=read-sub-payload expected=@t timeout=@dr]  ::  not sure if need timeout: if want to not block so can handle out-of-order when multiple subscriptions are being passed around, may need it. Ideally wouldn't need.
      [%wait until=@dr]
      [%custom-read tag=@tas payload=@t expected=@t]
  ==
+$  test-write-step
  $%  [%dojo payload=dojo-payload expected=(list test-read-step)]
      [%poke payload=poke-payload expected=(list test-read-step)]
      [%subscribe payload=sub-payload expected=(list test-read-step)]
      [%custom-write tag=@tas payload=@t expected=(list test-read-step)]
  ==
:: +$  dbug-payload  [who=@p app=@tas %state/bowl/???] :: TODO
+$  scry-payload
  ::  if `mold-name` mold in stdlib, set `mold-sur` to `~`.
  ::  `mold-sur` first element is desk and subsequent are
  ::   path to the sur file, e.g., to import this file:
  ::   `mold-sur=/zig/sur/zig/ziggurat/hoon`.
  ::  if `mold-name` from stdlib, `mold-name` is a direct
  ::   reference, e.g., `@ud`
  ::  if `mold-name` from `mold-sur`, `mold-name` is
  ::   namespaced by file name, e.g., from this file,
  ::   `test-write-step:ziggurat`.
  [who=@p mold-sur=path mold-name=@t care=@tas app=@tas =path]
+$  read-sub-payload  [who=@p =mold care=@tas app=@tas =path]  :: TODO
:: +$  poke-payload  [who=@p app=@tas payload=cage]
+$  dojo-payload  [who=@p payload=@t]
+$  poke-payload  [who=@p app=@tas mark=@tas payload=@t]
+$  sub-payload  [who=@p app=@tas p=path]
::
+$  custom-step-definitions
  %+  map  @tas
  (pair custom-step-definition custom-step-compiled)
+$  custom-step-definition
  transform=@t
  :: $:  payload=[mold-surs=(list path) input=@t]
  ::     transform=$-(payload=vase test-step)
  :: ==
+$  custom-step-compiled  (each transform=vase @t)
  :: (unit (each [payload=vase transform=vase] @t))
::
+$  test-results  (list test-result)
+$  test-result   (list [success=? expected=@t result=@t])
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
          [%add-test name=(unit @t) =test-steps]  ::  name optional
          [%delete-test id=@ux]
          :: [%edit-test id=@ux name=(unit @t) for-contract=id:smart action=@t expected-error=(unit @ud)]
          [%run-test id=@ux]
          [%add-and-run-test name=(unit @t) =test-steps]
          ::
          [%add-custom-step tag=@tas =custom-step-definition]
          [%delete-custom-step tag=@tas]
          ::
          [%stop-pyro-ships ~]
          [%start-pyro-ships ships=(list @p)]  ::  ships=~ -> [~nec ~bud]
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
