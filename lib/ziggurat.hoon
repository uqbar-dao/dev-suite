/-  *ziggurat
/+  templates=zig-templates, conq=zink-conq
|%
::
::  set parameters for our local test environment
::
++  designated-address  0xdead.beef
++  designated-contract-id  0xfafa.fafa
++  designated-caller
  ^-  caller:smart
  [designated-address 0 id.p:designated-zigs-grain]
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
++  make-contract-update
  |=  [=path proj=contract-project]
  ^-  card
  =/  =contract-update
    :^    compiled=?~(compiled.proj %.n %.y)
        error.proj
      state.proj
    tests.proj
  [%give %fact ~[path] %contract-update !>(contract-update)]
::
++  make-app-update
  |=  [=path =app-project]
  ^-  card
  ::  TODO
  !!
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
      %+  turn  ~(tap by libs)
      |=  [name=@t text=@t]
      (ream text)
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
--