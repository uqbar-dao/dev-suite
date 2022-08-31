/-  *ziggurat
/+  conq=zink-conq
|%
::
::  set parameters for our local test environment
::
++  designated-address  0xdead.beef
++  designated-contract-id  0xfafa.fafa
++  designated-metadata-id  0xdada.dada
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
    :*  compiled=?~(compiled.contract-project %.n %.y)
        error.contract-project
        state.contract-project
        data-texts.contract-project
        tests.contract-project
    ==
  =/  =path  /contract-project/[project]
  [%give %fact ~[path] %ziggurat-contract-update !>(contract-update)]
::
++  make-app-update
  |=  [project=@t =app-project]
  ^-  card
  =/  =app-update
    :*  dir.app-project
        error.app-project
        compiled.app-project
    ==
  =/  =path  /app-project/[project]
  [%give %fact ~[path] %ziggurat-app-update !>(app-update)]
::
++  make-multi-test-update
  |=  [project=@t result=state-transition:mill]
  ^-  card
  =/  =test-update  [%result result]
  =/  =path         /test-updates/[project]
  [%give %fact ~[path] %ziggurat-test-update !>(test-update)]
::
++  build-contract-project
  |=  [smart-lib=vase proj=contract-project]
  ^-  build-result
  ::
  ::  adapted from compile-contract:conq
  ::  this wacky design is to get a somewhat more helpful error print
  ::
  |^
  =/  first  (mule |.((parse-main main.proj)))
  ?:  ?=(%| -.first)
    %|^(get-formatted-error (snoc p.first 'error parsing main:'))
  =/  second  (mule |.((parse-libs -.p.first)))
  ?:  ?=(%| -.second)
    %|^(get-formatted-error (snoc p.second 'error parsing libraries:'))
  =/  third  (mule |.((build-libs p.second)))
  ?:  ?=(%| -.third)
    %|^(get-formatted-error (snoc p.third 'error building libraries:'))
  =/  fourth  (mule |.((build-main +.p.third +.p.first)))
  ?:  ?=(%| -.fourth)
    %|^(get-formatted-error (snoc p.fourth 'error building libraries:'))
  %&^[bat=p.fourth pay=-.p.third]
  ::
  ++  parse-main  ::  first
    |=  main=@t
    ^-  [raw=(list [face=term =path]) contract-hoon=hoon]
    (parse-pile:conq (trip main))
  ::
  ++  parse-libs  ::  second
    |=  raw=(list [face=term =path])
    ^-  (list hoon)
    %+  turn  raw
    |=  [face=term =path]
    `hoon`[%ktts face (rain path (~(got by libs.proj) `@t`face))]
  ::
  ++  build-libs  ::  third
    |=  braw=(list hoon)
    ^-  [nok=* =vase]
    =/  libraries=hoon  [%clsg braw]
    :-  q:(~(mint ut p.smart-lib) %noun libraries)
    (slap smart-lib libraries)
  ::
  ++  build-main  ::  fourth
    |=  [payload=vase contract=hoon]
    ^-  *
    q:(~(mint ut p:(slop smart-lib payload)) %noun contract)
  --
::
++  get-formatted-error
  |=  e=(list tank)
  ^-  @t
  %-  crip
  %-  zing
  %+  turn  (flop e)
  |=  =tank
  (of-wall:format (wash [0 80] tank))
::
::  project states for templates
::
++  fungible-template-project
  |=  [current=contract-project meta-rice=rice:smart smart-lib-vase=vase]
  ^-  contract-project
  ::  make fungible accounts and tests
  =/  metadata
    ;;  $:  name=@t
            symbol=@t
            decimals=@ud
            supply=@ud
            cap=(unit @ud)
            mintable=?
            minters=(pset:smart address:smart)
            deployer=address:smart
            salt=@
        ==
    q:(slap smart-lib-vase (ream ;;(@t data.meta-rice)))
  =/  dead-beef-account-id
    %:  fry-rice:smart
        lord.meta-rice
        designated-address
        designated-town-id
        salt.metadata
    ==
  =/  dead-beef-account
    ^-  grain:smart
    :*  %&  salt.metadata
        %account
        [200 ~ id.meta-rice 0]
        dead-beef-account-id
        lord.meta-rice
        designated-address
        designated-town-id
    ==
  =/  cafe-babe-account-id
    %:  fry-rice:smart
        lord.meta-rice
        0xcafe.babe
        designated-town-id
        salt.metadata
    ==
  =/  cafe-babe-account
    ^-  grain:smart
    :*  %&  salt.metadata
        %account
        [100 ~ id.meta-rice 0]
        cafe-babe-account-id
        lord.meta-rice
        0xcafe.babe
        designated-town-id
    ==
  =/  cafe-d00d-account-id
    %:  fry-rice:smart
        lord.meta-rice
        0xcafe.d00d
        designated-town-id
        salt.metadata
    ==
  =/  cafe-d00d-account
    ^-  grain:smart
    :*  %&  salt.metadata
        %account
        [100 (~(gas py:smart *(pmap:smart @ux @ud)) ~[[0xdead.beef 50]]) id.meta-rice 0]
        cafe-babe-account-id
        lord.meta-rice
        0xcafe.d00d
        designated-town-id
    ==
  =/  action-1=@t
    %-  crip
    %-  zing
    :~  "[%give to=0xcafe.babe amount=30 from-account="
        (trip (scot %ux dead-beef-account-id))
        " to-account=`"
        (trip (scot %ux cafe-babe-account-id))
        "]"
    ==
  =/  yolk-1=yolk:smart
    =-  [;;(@tas -.-) +.-]
    q:(slap smart-lib-vase (ream action-1))
  =/  test-1=test
    :*  `'test-give'
        action-1
        yolk-1
        ~  ::  TODO
        ~
    ==
  =/  action-2=@t
    %-  crip
    %-  zing
    :~  "[%take to=0xcafe.babe amount=50 from-account="
        (trip (scot %ux cafe-d00d-account-id))
        " to-account=`"
        (trip (scot %ux cafe-babe-account-id))
        "]"
    ==
  =/  yolk-2=yolk:smart
    =-  [;;(@tas -.-) +.-]
    q:(slap smart-lib-vase (ream action-2))
  =/  test-2=test
    :*  `'test-give'
        action-2
        yolk-2
        ~  ::  TODO
        ~
    ==
  %=    current
      tests
    (malt ~[[0x1111.1111 test-1] [0x2222.2222 test-2]])
  ::
      data-texts
    %-  ~(uni by data-texts.current)
    %-  ~(gas by *(map id:smart @t))
    :~  [id.meta-rice ;;(@t data.meta-rice)]
        [dead-beef-account-id '[balance=200 allowances=~ metadata=0xdada.dada nonce=0]']
        [cafe-babe-account-id '[balance=100 allowances=~ metadata=0xdada.dada nonce=0]']
        [cafe-babe-account-id '[balance=100 allowances=(~(gas py *(pmap @ux @ud)) ~[[0xdead.beef 50]]) metadata=0xdada.dada nonce=0]']
    ==
  ::
      p.state
    =-  (uni:big:mill p.state.current -)
    %+  gas:big:mill  *granary:mill
    :~  [id.meta-rice %&^meta-rice(data metadata)]
        [dead-beef-account-id dead-beef-account]
        [cafe-babe-account-id cafe-babe-account]
        [cafe-d00d-account-id cafe-d00d-account]
    ==
  ==
++  nft-template-project
  |=  meta-rice=rice:smart
  ^-  contract-project
  !!
::
::  JSON parsing utils
::
++  grain-to-json
  |=  [=grain:smart tex=@t]
  =,  enjs:format
  ^-  json
  %-  pairs
  %+  welp
    :~  ['lord' %s (scot %ux lord.p.grain)]
        ['holder' %s (scot %ux holder.p.grain)]
        ['town_id' %s (scot %ux town-id.p.grain)]
    ==
  ?.  ?=(%& -.grain)
    ['contract' %b %.y]~
  :~  ['salt' (numb salt.p.grain)]
      ['label' %s (scot %tas label.p.grain)]
      ['data_text' %s tex]
      ['data' %s (crip (noah !>(data.p.grain)))]
  ==
::
++  contract-project-to-json
  |=  p=contract-project
  =,  enjs:format
  ^-  json
  %-  pairs
  :~  ['main' %s main.p]
      :-  'libs'
      %-  pairs
      %+  turn  ~(tap by libs.p)
      |=  [name=@t text=@t]
      [name %s text]
      ::  not sharing nock, can add later if desired
      ::  not sharing imported either
      ['error' %s ?~(error.p '' u.error.p)]
      ['state' (granary-to-json p.state.p data-texts.p)]
      ['tests' (tests-to-json tests.p)]
  ==
::
++  granary-to-json
  |=  [=granary:mill data-texts=(map id:smart @t)]
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
  %+  grain-to-json  grain
  ?~(t=(~(get by data-texts) id) '' u.t)
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
  :~  ['name' %s ?~(name.test '' u.name.test)]
      ['action_text' %s action-text.test]
      ['action' %s (crip (noah !>(action.test)))]
      ['expected' (expected-to-json expected.test)]
      ['result' ?~(result.test ~ (test-result-to-json u.result.test))]
  ==
::
++  expected-to-json
  |=  m=(map id:smart [grain:smart @t])
  =,  enjs:format
  ^-  json
  %-  pairs
  %+  turn  ~(tap by m)
  |=  [=id:smart =grain:smart tex=@t]
  [(scot %ux id) (grain-to-json grain tex)]
::
++  test-result-to-json
  |=  t=test-result
  =,  enjs:format
  ^-  json
  %-  pairs
  :~  ['fee' (numb fee.t)]
      ['errorcode' (numb errorcode.t)]
      ['events' (crow-to-json crow.t)]
      ['grains' (expected-diff-to-json expected-diff.t)]
      ['success' ?~(success.t ~ [%b u.success.t])]
  ==
::
++  expected-diff-to-json
  |=  m=expected-diff
  =,  enjs:format
  ^-  json
  %-  pairs
  %+  turn  ~(tap by m)
  |=  [=id:smart made=(unit grain:smart) expected=(unit grain:smart) match=(unit ?)]
  :-  (scot %ux id)
  %-  pairs
  :~  ['made' ?~(made ~ (grain-to-json u.made ''))]
      ['expected' ?~(expected ~ (grain-to-json u.expected ''))]
      ['match' ?~(match ~ [%b u.match])]
  ==
::
++  crow-to-json
  |=  =crow:smart
  =,  enjs:format
  ^-  json
  %-  pairs
  %+  turn  crow
  |=  [label=@tas =json]
  [(scot %tas label) json]
::
++  dir-to-json
  |=  dir=(list path)
  =,  enjs:format
  ^-  json
  :-  %a
  %+  turn  dir
  |=  p=^path
  (path p)
--