/-  *ziggurat
/+  templates=zig-templates, conq=zink-conq
|%
::
::  set parameters for our local test environment
::
++  designated-address  0xdead.beef
++  designated-contract-id  0xfafa.fafa
++  designated-caller
  |=  nonce=@ud
  ^-  caller:smart
  [designated-address nonce id.p:designated-zigs-grain]
++  designated-town-id  0x0
::  we set the designated caller to have 300 zigs
++  designated-zigs-grain
  ^-  grain:smart
  :*  %&  `@`'zigs'
      %account
      [300.000.000.000.000.000.000 ~ `@ux`'zigs-metadata']
      %:  fry-rice:smart
          zigs-wheat-id:smart
          designated-address
          designated-town-id
          `@`'zigs'
      ==
      zigs-wheat-id:smart
      designated-address
      designated-town-id
  ==
::
++  starting-state
  ^-  land:mill
  :_  ~
  (put:big:mill ~ id.p:designated-zigs-grain designated-zigs-grain)
::
++  make-contract-grain
  |=  cont=[bat=* pay=*]
  ^-  grain:smart
  :*  %|
      `cont
      interface=~
      types=~
      designated-contract-id
      0x0
      designated-address
      designated-town-id
  ==
::
::  utilities
::
++  get-template
  |=  [pat=path our=ship now=time]
  ^-  @t
  =/  pre=path  /(scot %p our)/zig/(scot %da now)/lib/zig/contracts
  .^(@t %cx (weld pre pat))
::
++  make-contract-update
  |=  [project=@t =contract-project]
  ^-  card
  =/  =contract-update
    :^    compiled=?~(compiled.contract-project %.n %.y)
        error.contract-project
      state.contract-project
    tests.contract-project
  =/  =path  /contract-updates/(scot %t project)
  [%give %fact ~[path] %contract-update !>(contract-update)]
::
++  make-app-update
  |=  [project=@t =app-project]
  ^-  card
  ::  TODO
  !!
::
++  make-single-test-update
  |=  [project=@t test-id=@ =test]
  ^-  card
  =/  =test-update  [%single test-id (need last-result.test)]
  =/  =path         /test-updates/(scot %t project)
  [%give %fact ~[path] %test-update !>(test-update)]
::
++  make-multi-test-update
  |=  [project=@t result=state-transition:mill]
  ^-  card
  =/  =test-update  [%multi result]
  =/  =path         /test-updates/(scot %t project)
  [%give %fact ~[path] %test-update !>(test-update)]
::
++  build-contract-project
  |=  [smart-lib=vase proj=contract-project]
  ^-  build-result
  ::
  ::  adapted from compile-contract:conq
  ::
  |^
  (mule |.((compile main.proj libs.proj)))
  ::
  ++  compile
    |=  [main=@t libs=(map @t @t)]
    ^-  [bat=* pay=*]
    ::  parse contract code
    ::  ignore raw libs
    =/  [raw=(list [face=term =path]) contract-hoon=hoon]
      (parse-pile:conq (trip main))
    ::  initial subject containing uHoon already generated
    ::  compose libraries flatly against uHoon subject
    =/  braw=(list hoon)
      %+  turn  raw
      |=  [face=term =path]
      ~&  >>  (~(got by libs) `@t`face)
      `hoon`[%ktts face (rain path (~(got by libs) `@t`face))]
    =/  libraries=hoon  [%clsg braw]
    =/  full-nock=*  q:(~(mint ut p.smart-lib) %noun libraries)
    =/  payload=vase  (slap smart-lib libraries)
    =/  cont  (~(mint ut p:(slop smart-lib payload)) %noun contract-hoon)
    [bat=q.cont pay=full-nock]
  --
::
++  get-formatted-error
  |=  e=(list tank)
  ::
  ::  TODO: get MORE error information!!!
  ::
  ^-  @t
  %-  crip
  %+  weld  "syntax error on \{line col}: "
  (of-wall:format (wash [0 80] (snag 1 e)))
::
::  JSON parsing utils
::
++  tests-to-json
  |=  =tests
  =,  enjs:format
  ^-  json
  %-  pairs
  %+  turn  ~(tap by tests)
  |=  [id=@ux =test]
  [(scot %ux id) (test-to-json test)]
::
++  test-to-json
  |=  =test
  =,  enjs:format
  ^-  json
  %-  pairs
  :~  ['name' [%s ?~(name.test '' u.name.test)]]
      ['action' [%s (crip (noah !>(action.test)))]]
      ['last_result' ?~(last-result.test ~ (granary-to-json p.land.u.last-result.test))]
  ==
::
++  granary-to-json
  |=  =granary:mill
  ::
  ::  ignoring/not printing nonces for now.
  ::
  =,  enjs:format
  ^-  json
  %-  pairs
  %+  turn  ~(tap py:smart granary)
  |=  [=id:smart merk=@ux =grain:smart]
  ::  ignore contract nock -- just print metadata
  :-  (scot %ux id)
  %-  pairs
  %+  welp
    :~  ['lord' [%s (scot %ux lord.p.grain)]]
        ['holder' [%s (scot %ux holder.p.grain)]]
        ['town_id' [%s (scot %ux town-id.p.grain)]]
    ==
  ?.  ?=(%& -.grain)
    ['contract' [%b %.y]]~
  :~  ['salt' (numb salt.p.grain)]
      ['label' [%s (scot %tas label.p.grain)]]
      ['data' [%s (crip (noah !>(data.p.grain)))]]
  ==
--