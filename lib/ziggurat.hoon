/-  *ziggurat
/+  conq=zink-conq
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
  =/  =path  /contract-project/[project]
  [%give %fact ~[path] %ziggurat-contract-update !>(contract-update)]
::
++  make-app-update
  |=  [project=@t =app-project]
  ^-  card
  ::  TODO
  !!
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
    data.meta-rice
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
        [200 ~ id.meta-rice]
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
        [100 ~ id.meta-rice]
        cafe-babe-account-id
        lord.meta-rice
        0xcafe.babe
        designated-town-id
    ==
  =/  action-text=@t
    %-  crip
    %-  zing
    :~  "[%give to=0xcafe.babe amount=30 from-account="
        (trip (scot %ux dead-beef-account-id))
        " to-account=`"
        (trip (scot %ux cafe-babe-account-id))
        "]"
    ==
  =/  =yolk:smart
    =-  [;;(@tas -.-) +.-]
    q:(slap smart-lib-vase (ream action-text))
  =/  test1=test
    :*  `'test-give'
        action-text
        yolk
        ~  ::  TODO
        ~
        ~
    ==
  %=    current
      tests
    (malt ~[[0x1234.5678 test1]])
  ::
      p.state
    =-  (uni:big:mill p.state.current -)
    %+  gas:big:mill  *granary:mill
    :~  [dead-beef-account-id dead-beef-account]
        [cafe-babe-account-id cafe-babe-account]
    ==
  ==
++  nft-template-project
  |=  meta-rice=rice:smart
  ^-  contract-project
  !!
::
::  JSON parsing utils
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
      ['tests' (tests-to-json tests.p data-texts.p)]
  ==
::
++  tests-to-json
  |=  [=tests data-texts=(map id:smart @t)]
  =,  enjs:format
  ^-  json
  %-  pairs
  %+  turn  ~(tap by tests)
  |=  [id=@ux =test]
  [(scot %ux id) (test-to-json test data-texts)]
::
++  test-to-json
  |=  [=test data-texts=(map id:smart @t)]
  =,  enjs:format
  ^-  json
  %-  pairs
  :~  ['name' %s ?~(name.test '' u.name.test)]
      ['action_text' %s action-text.test]
      ['action' %s (crip (noah !>(action.test)))]
      ['expected' ?~(expected.test ~ (rice-set-to-json u.expected.test))]
      ['last_result' ?~(last-result.test ~ (granary-to-json p.land.u.last-result.test data-texts))]
      ['errorcode' ?~(last-result.test ~ (numb errorcode.u.last-result.test))]
      ['success' ?~(success.test ~ [%b u.success.test])]
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
      ['data_text' %s (~(got by data-texts) id)]
      ['data' %s (crip (noah !>(data.p.grain)))]
  ==
::
++  rice-set-to-json
  |=  s=(set rice:smart)
  =,  enjs:format
  ^-  json
  %-  pairs
  %+  turn  ~(tap in s)
  |=  =rice:smart
  :-  (scot %ux id.rice)
  %-  pairs
  :~  ['lord' %s (scot %ux lord.rice)]
      ['holder' %s (scot %ux holder.rice)]
      ['town_id' %s (scot %ux town-id.rice)]
      ['salt' (numb salt.rice)]
      ['label' %s (scot %tas label.rice)]
      ['data' %s (crip (noah !>(data.rice)))]
  ==
--