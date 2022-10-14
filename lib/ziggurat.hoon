/-  *ziggurat
/+  conq=zink-conq, zink=zink-zink
|%
::
::  set parameters for our local test environment
::
++  designated-contract-id  0xfafa.fafa
++  designated-metadata-id  0xdada.dada
++  designated-caller
  |=  [=address:smart nonce=@ud]
  ^-  caller:smart
  [address nonce id.p:(designated-zigs-grain address)]
++  designated-town-id  0x0
::  we set the designated caller to have 300 zigs
++  designated-zigs-grain
  |=  =address:smart
  ^-  grain:smart
  :*  %&  `@`'zigs'
      %account
      [300.000.000.000.000.000.000 ~ `@ux`'zigs-metadata' 0]
      %:  fry-rice:smart
          zigs-wheat-id:smart
          address
          designated-town-id
          `@`'zigs'
      ==
      zigs-wheat-id:smart
      address
      designated-town-id
  ==
::
++  starting-state
  |=  =address:smart
  ^-  land:mill
  :_  ~
  =-  (put:big:mill ~ id.p.- -)
  (designated-zigs-grain address)
::
++  make-contract-grain
  |=  [=address:smart cont=[bat=* pay=*]]
  ^-  grain:smart
  :*  %|
      `cont
      interface=~
      types=~
      designated-contract-id
      0x0
      address
      designated-town-id
  ==
::
::  utilities
::
++  get-template
  |=  [pat=path our=ship now=time]
  ^-  @t
  =/  pre=path  /(scot %p our)/zig/(scot %da now)/con
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
  =/  =path  /app-project/[project]
  [%give %fact ~[path] %ziggurat-app-update !>(`app-update`app-project)]
::
++  make-multi-test-update
  |=  [project=@t result=state-transition:mill]
  ^-  card
  =/  =path         /test-updates/[project]
  [%give %fact ~[path] %ziggurat-test-update !>(`test-update`[%result result])]
::
++  text-to-zebra-noun
  |=  [tex=@t smart-lib=vase]
  ^-  *
  ~|  "ziggurat: syntax error in custom data!"
  =+  gun=(~(mint ut p.smart-lib) %noun (ream tex))
  =/  res=book:zink
    (zebra:zink 200.000 ~ *granary-scry:zink [q.smart-lib q.gun] %.y)
  ~|  "ziggurat: failed to compile custom data!"
  ?.  ?=(%& -.p.res)  !!
  ~&  >>  "size: {<(met 3 (jam p.p.res))>}"
  ?:  (gth (met 3 (jam p.p.res)) 5.000)
    ~|("ziggurat: custom data noun too large, likely using a mold" !!)
  ~|  "ziggurat: result of custom data compile was ~"
  (need p.p.res)
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
    :-  %|
    %-  get-formatted-error
    (snoc (scag 4 p.first) 'error parsing main:')
  =/  second  (mule |.((parse-libs -.p.first)))
  ?:  ?=(%| -.second)
    :-  %|
    %-  get-formatted-error
    (snoc (scag 3 p.second) 'error parsing library:')
  =/  third  (mule |.((build-libs p.second)))
  ?:  ?=(%| -.third)
    %|^(get-formatted-error (snoc (scag 1 p.third) 'error building libraries:'))
  =/  fourth  (mule |.((build-main +.p.third +.p.first)))
  ?:  ?=(%| -.fourth)
    %|^(get-formatted-error (snoc (scag 1 p.fourth) 'error building main:'))
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
    `hoon`[%ktts face (rain path (~(got by libs.proj) `@t`(rear path)))]
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
    =/  data-text  ;;(@t data.meta-rice)
    =+  gun=(~(mint ut p.smart-lib-vase) %noun (ream data-text))
    =/  res=book:zink
      (zebra:zink 200.000 ~ *granary-scry:zink [q.smart-lib-vase q.gun] %.y)
    ?.  ?=(%& -.p.res)
      ~|("ziggurat: failed to compile custom data!" !!)
    (need p.p.res)
  =/  dead-beef-account-id
    %:  fry-rice:smart
        lord.meta-rice
        user-address.current
        designated-town-id
        salt.metadata
    ==
  =/  dead-beef-account
    ^-  rice:smart
    :*  salt.metadata
        %account
        [200 ~ id.meta-rice 0]
        dead-beef-account-id
        lord.meta-rice
        user-address.current
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
    ^-  rice:smart
    :*  salt.metadata
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
    ^-  rice:smart
    :*  salt.metadata
        %account
        [100 (make-pmap:smart ~[[0xdead.beef 50]]) id.meta-rice 0]
        cafe-d00d-account-id
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
    =/  data-1
      '[balance=170 allowances=~ metadata=0xdada.dada nonce=0]'
    =/  data-2
      '[balance=130 allowances=~ metadata=0xdada.dada nonce=0]'
    :*  `'test-give'
        action-1
        yolk-1
        %-  malt
        :~  :+  dead-beef-account-id
              %&^dead-beef-account(data q:(slap smart-lib-vase (ream data-1)))
            data-1
            :+  cafe-babe-account-id
              %&^cafe-babe-account(data q:(slap smart-lib-vase (ream data-2)))
            data-2
        ==
        %0
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
    =/  data-1
      '[balance=50 allowances=(make-pmap ~[[0xdead.beef 0]]) metadata=0xdada.dada nonce=0]'
    =/  data-2
      '[balance=150 allowances=~ metadata=0xdada.dada nonce=0]'
    :*  `'test-take'
        action-2
        yolk-2
        %-  malt
        :~  :+  cafe-d00d-account-id
              %&^cafe-d00d-account(data (text-to-zebra-noun data-1 smart-lib-vase))
            data-1
            :+  cafe-babe-account-id
              %&^cafe-babe-account(data q:(slap smart-lib-vase (ream data-2)))
            data-2
        ==
        %0
        ~
    ==
  =/  action-3=@t
    %-  crip
    %-  zing
    :~  "[%set-allowance who=0xcafe.babe amount=100 account="
        (trip (scot %ux dead-beef-account-id))
        "]"
    ==
  =/  yolk-3=yolk:smart
    =-  [;;(@tas -.-) +.-]
    q:(slap smart-lib-vase (ream action-3))
  =/  test-3=test
    =/  data-1
      '[balance=200 allowances=(make-pmap ~[[0xcafe.babe 100]]) metadata=0xdada.dada nonce=0]'
    :*  `'test-set-allowance'
        action-3
        yolk-3
        %-  malt
        :~  :+  dead-beef-account-id
              %&^dead-beef-account(data (text-to-zebra-noun data-1 smart-lib-vase))
            data-1
        ==
        %0
        ~
    ==
  %=    current
      tests
    (malt ~[[0x1111.1111 test-1] [0x2222.2222 test-2] [0x3333.3333 test-3]])
  ::
      data-texts
    %-  ~(uni by data-texts.current)
    %-  ~(gas by *(map id:smart @t))
    :~  [id.meta-rice ;;(@t data.meta-rice)]
        [dead-beef-account-id '[balance=200 allowances=~ metadata=0xdada.dada nonce=0]']
        [cafe-babe-account-id '[balance=100 allowances=~ metadata=0xdada.dada nonce=0]']
        [cafe-d00d-account-id '[balance=100 allowances=(make-pmap ~[[0xdead.beef 50]]) metadata=0xdada.dada nonce=0]']
    ==
  ::
      p.state
    =-  (uni:big:mill p.state.current -)
    %+  gas:big:mill  *granary:mill
    :~  [id.meta-rice %&^meta-rice(data metadata)]
        [dead-beef-account-id %&^dead-beef-account]
        [cafe-babe-account-id %&^cafe-babe-account]
        [cafe-d00d-account-id %&^cafe-d00d-account]
    ==
  ==
++  nft-template-project
  |=  [current=contract-project meta-rice=rice:smart smart-lib-vase=vase]
  ^-  contract-project
  ::  make fungible accounts and tests
  =/  metadata
    ;;  $:  name=@t
            symbol=@t
            properties=(pset:smart @tas)
            supply=@ud
            cap=(unit @ud)
            mintable=?
            minters=(pset:smart address:smart)
            deployer=address:smart
            salt=@
        ==
    (text-to-zebra-noun ;;(@t data.meta-rice) smart-lib-vase)
  ::
  =/  props
    %-  ~(gas py:smart *(map @tas @t))
    %+  turn  ~(tap pn:smart properties.metadata)
    |=  prop=@tas
    [prop 'random_attribute']
  =/  props-tape=tape
    %-  zing
    :~  "properties=(make-pmap `(list [@tas @t])`~["
        ^-  tape
        %-  snip
        ^-  tape
        %-  zing
        %+  turn  ~(tap pn:smart properties.metadata)
        |=  prop=@tas
        %-  zing
        :~  "[%"  (trip (scot %tas prop))
            " 'random_attribute'] "
        ==
        "])"
    ==
  ::
  =/  nft-1-id
    %:  fry-rice:smart
        lord.meta-rice
        user-address.current
        designated-town-id
        (cat 3 salt.metadata (scot %ud 1))
    ==
  =/  nft-1
    ^-  rice:smart
    :*  (cat 3 salt.metadata (scot %ud 1))
        %nft
        [1 'https://image.link' id.meta-rice ~ props &]
        nft-1-id
        lord.meta-rice
        user-address.current
        designated-town-id
    ==
  =/  nft-1-text=@t
    %-  crip
    %-  zing
    :~  "[id=1 uri='https://image.link' metadata=0xdada.dada allowances=~ "
        props-tape
        " transferrable=%.y]"
    ==
  =/  nft-2-id
    %:  fry-rice:smart
        lord.meta-rice
        0xcafe.babe
        designated-town-id
        (cat 3 salt.metadata (scot %ud 2))
    ==
  =/  nft-2
    ^-  rice:smart
    :*  (cat 3 salt.metadata (scot %ud 2))
        %nft
        [2 'https://image.link' id.meta-rice ~ props &]
        nft-2-id
        lord.meta-rice
        0xcafe.babe
        designated-town-id
    ==
  =/  nft-2-text=@t
    %-  crip
    %-  zing
    :~  "[id=2 uri='https://image.link' metadata=0xdada.dada allowances=~ "
        props-tape
        " transferrable=%.y]"
    ==
  ::
  =/  action-1=@t
    %-  crip
    %-  zing
    :~  "[%give to=0xcafe.babe grain-id="
        (trip (scot %ux nft-1-id))
        "]"
    ==
  =/  yolk-1=yolk:smart
    =-  [;;(@tas -.-) +.-]
    q:(slap smart-lib-vase (ream action-1))
  =/  test-1=test
    :*  `'test-give'
        action-1
        yolk-1
        %-  malt
        :~  :+  nft-1-id
              %&^nft-1(holder 0xcafe.babe)
            nft-1-text
        ==
        %0
        ~
    ==
  ::
  =/  action-2=@t
    %-  crip
    %-  zing
    :~  "[%give to=0xcafe.babe grain-id="
        (trip (scot %ux nft-2-id))
        "]"
    ==
  =/  yolk-2=yolk:smart
    =-  [;;(@tas -.-) +.-]
    q:(slap smart-lib-vase (ream action-2))
  =/  test-2=test
    :*  `'test-give-dont-have'
        action-2
        yolk-2
        ~
        %6
        ~
    ==
  ::
  =/  action-3=@t
    %-  crip
    %-  zing
    :~  "[%mint token=0xdada.dada mints=[to="
        (trip (scot %ux user-address.current))
        " uri='https://image.link' "
        props-tape
        " transferrable=&] ~]"
    ==
  =/  yolk-3=yolk:smart
    =-  [;;(@tas -.-) +.-]
    (text-to-zebra-noun action-3 smart-lib-vase)
  =/  nft-3-id
    %:  fry-rice:smart
        lord.meta-rice
        user-address.current
        designated-town-id
        (cat 3 salt.metadata (scot %ud 3))
    ==
  =/  nft-3
    ^-  rice:smart
    :*  (cat 3 salt.metadata (scot %ud 3))
        %nft
        [3 'https://image.link' id.meta-rice ~ props &]
        nft-3-id
        lord.meta-rice
        user-address.current
        designated-town-id
    ==
  =/  nft-3-text=@t
    %-  crip
    %-  zing
    :~  "[id=3 uri='https://image.link' metadata=0xdada.dada allowances=~ "
        props-tape
        " transferrable=%.y]"
    ==
  =/  test-3=test
    :*  `'test-mint'
        action-3
        yolk-3
        (malt ~[[nft-3-id [%&^nft-3 nft-3-text]]])
        %0
        ~
    ==
  ::
  %=    current
      tests
    (malt ~[[0x1111.1111 test-1] [0x2222.2222 test-2] [0x3333.3333 test-3]])
  ::
      data-texts
    %-  ~(uni by data-texts.current)
    %-  ~(gas by *(map id:smart @t))
    :~  [id.meta-rice ;;(@t data.meta-rice)]
        ::  [1 'https://image.link' id.meta-rice ~ props &]
        [nft-1-id nft-1-text]
    ::
        [nft-2-id nft-2-text]
    ==
  ::
      p.state
    =-  (uni:big:mill p.state.current -)
    %+  gas:big:mill  *granary:mill
    :~  [id.meta-rice %&^meta-rice(data metadata)]
        [nft-1-id %&^nft-1]
        [nft-2-id %&^nft-2]
    ==
  ==
::
::  files we delete from zig desk to make new gall desk
::
++  clean-desk
  |=  name=@t
  :~  [/app/indexer/hoon %del ~]
      [/app/rollup/hoon %del ~]
      [/app/sequencer/hoon %del ~]
      [/app/uqbar/hoon %del ~]
      [/app/wallet/hoon %del ~]
      [/app/ziggurat/hoon %del ~]
      [/gen/rollup/activate/hoon %del ~]
      [/gen/sequencer/batch/hoon %del ~]
      [/gen/sequencer/init/hoon %del ~]
      [/gen/uqbar/set-sources/hoon %del ~]
      [/gen/wallet/basic-tx/hoon %del ~]
      [/gen/build-hash-cache/hoon %del ~]
      [/gen/compile/hoon %del ~]
      [/gen/compose/hoon %del ~]
      [/gen/merk-profiling/hoon %del ~]
      [/gen/mk-smart/hoon %del ~]
      [/tests/contracts/fungible/hoon %del ~]
      [/tests/contracts/nft/hoon %del ~]
      [/tests/contracts/publish/hoon %del ~]
      [/tests/lib/merk/hoon %del ~]
      [/tests/lib/mill-2/hoon %del ~]
      [/tests/lib/mill/hoon %del ~]
      [/roadmap/md %del ~]
      [/readme/md %del ~]
      [/app/[name]/hoon %ins hoon+!>(simple-app)]
  ==
::
++  simple-app
  ^-  @t
  '''
  +  default-agent, dbug
  |%
  +$  versioned-state
      $%  state-0
      ==
  +$  state-0  [%0 ~]
  --
  %-  agent:dbug
  =|  state-0
  =*  state  -
  ^-  agent:gall
  |_  =bowl:gall
  +*  this     .
      default   ~(. (default-agent this %|) bowl)
  ::
  ++  on-init
    `this(state [%0 ~])
  ++  on-save
    ^-  vase
    !>(state)
  ++  on-load
    on-load:default
  ++  on-poke  on-poke:default
  ++  on-watch  on-watch:default
  ++  on-leave  on-leave:default
  ++  on-peek   on-peek:default
  ++  on-agent  on-agent:default
  ++  on-arvo   on-arvo:default
  ++  on-fail   on-fail:default
  --
  '''
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
++  app-project-to-json
  |=  p=app-project
  =,  enjs:format
  ^-  json
  %-  frond
  ['dir' (dir-to-json dir.p)]
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
      ['expected_error' ?~(expected-error.test n+'0' (numb expected-error.test))]
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