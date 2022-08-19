::
::  utils for app/ziggurat
::
/-  *ziggurat
/+  templates=zig-templates, conq=zink-conq
|%
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
    |=  [main=file libs=(list file)]
    ^-  [bat=* pay=*]
    ::  parse contract code
    ::  ignore raw libs
    =/  [raw=(list [face=term =path]) contract-hoon=hoon]
      (parse-pile:conq (trip text.main))
    ::  initial subject containing uHoon already generated
    ::  compose libraries flatly against uHoon subject
    =/  braw=(list hoon)
      %+  turn  libs
      |=  [name=@t text=@t]
      (ream text)
    =/  libraries=hoon  [%clsg braw]
    =/  full-nock=*  q:(~(mint ut p.smart-lib) %noun libraries)
    =/  payload=vase  (slap smart-lib libraries)
    =/  cont  (~(mint ut p:(slop smart-lib payload)) %noun contract-hoon)
    [bat=q.cont pay=full-nock]
  --
--