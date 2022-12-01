/-  *zig-ziggurat,
    ui=zig-indexer
/+  conq=zink-conq,
    dock=docket,
    pyio=py-io,
    zink=zink-zink
|%
::
::  set parameters for our local test environment
::
++  first-contract-id       0xfafa.faf0
++  designated-metadata-id  0xdada.dada
++  designated-caller
  |=  [=address:smart nonce=@ud]
  ^-  caller:smart
  [address nonce id.p:(designated-zigs-item address)]
++  designated-town-id  0x0
::  we set the designated caller to have 300 zigs
++  designated-zigs-item
  |=  =address:smart
  ^-  item:smart
  :*  %&
      %:  hash-data:smart
          zigs-contract-id:smart
          address
          designated-town-id
          `@`'zigs'
      ==
      zigs-contract-id:smart
      address
      designated-town-id
      `@`'zigs'
      %account
      [300.000.000.000.000.000.000 ~ `@ux`'zigs-metadata' 0]
  ==
::
++  starting-state
  |=  =address:smart
  ^-  chain:engine
  :_  ~
  =-  (put:big:engine ~ id.p.- -)
  (designated-zigs-item address)
::
::  utilities
::
++  get-template
  |=  [pat=path our=ship now=time]
  ^-  @t
  =/  pre=path  /(scot %p our)/zig/(scot %da now)/con
  .^(@t %cx (weld pre pat))
::
++  make-project-update
  |=  [project-name=@t p=project]
  ^-  card
  =/  =path  /project/[project-name]
  =/  update=project-update
    :*  dir.p
        user-files.p
        ?=(~ errors.p)
        errors.p
        chain.p
        noun-texts.p
        tests.p
    ==
  :^  %give  %fact  ~[path]
  :-  %ziggurat-project-update
  !>(`project-update`update)
::
++  make-multi-test-update
  |=  [project=@t result=state-transition:engine]
  ^-  card
  =/  =path  /test-updates/[project]
  [%give %fact ~[path] %ziggurat-test-update !>(`test-update`[%result result])]
::
++  make-compile
  |=  [project=@t our=@p]
  ^-  card
  =-  [%pass /self-wire %agent [our %ziggurat] %poke -]
  :-  %ziggurat-action
  !>(`action`project^[%compile-contracts ~])
::
++  make-read-desk
  |=  [project=@t our=@p]
  ^-  card
  =-  [%pass /self-wire %agent [our %ziggurat] %poke -]
  :-  %ziggurat-action
  !>(`action`project^[%read-desk ~])
::
++  make-save-jam
  |=  [project=@t file=path non=*]
  ^-  card
  ?>  ?=(%jam (rear file))
  =-  [%pass /save-wire %arvo %c -]
  :-  %info
  [`@tas`project %& [file %ins %noun !>(`@`(jam non))]~]
::
++  make-save-file
  |=  [project=@t file=path text=@t]
  ^-  card
  =/  file-type  (rear file)
  =/  mym=mime  :-  /application/x-urb-unknown
    %-  as-octt:mimes:html
    %+  rash  text
    (star ;~(pose (cold '\0a' (jest '\0d\0a')) next))
  =-  [%pass /save-wire %arvo %c -]
  :^  %info  `@tas`project  %&
  :_  ~  :+  file  %ins
  =*  reamed-text  q:(slap !>(~) (ream text))  ::  =* in case text unreamable
  ?+  file-type  [%mime !>(mym)] :: don't need to know mar if we have bytes :^)
    %hoon        [%hoon !>(text)]
    %ship        [%ship !>(;;(@p reamed-text))]
    %bill        [%bill !>(;;((list @tas) reamed-text))]
    %kelvin      [%kelvin !>(;;([@tas @ud] reamed-text))]
      %docket-0
    =-  [%docket-0 !>((need (from-clauses:mime:dock -)))]
    ;;((list clause:dock) reamed-text)
  ==
::
++  make-run-queue
  |=  [our=ship project=@t]
  ^-  card
  :^  %pass  /self-poke  %agent
  :^  [our %ziggurat]  %poke  %ziggurat-action
  !>([project %run-queue ~])
::
++  text-to-zebra-noun
  |=  [tex=@t smart-lib=vase]
  ^-  *
  ~|  "ziggurat: syntax error in custom data!"
  =+  gun=(~(mint ut p.smart-lib) %noun (ream tex))
  =/  res=book:zink
    (zebra:zink 200.000 ~ *chain-state-scry:zink [q.smart-lib q.gun] %.y)
  ~|  "ziggurat: failed to compile custom data!"
  ?.  ?=(%& -.p.res)  !!
  ~&  >>  "size: {<(met 3 (jam p.p.res))>}"
  ?:  (gth (met 3 (jam p.p.res)) 5.000)
    ~|("ziggurat: custom data noun too large, likely using a mold" !!)
  ~|  "ziggurat: result of custom data compile was ~"
  (need p.p.res)
::
++  save-compiled-projects
  |=  $:  project=@t
          build-results=(list [p=path q=@ux r=build-result])
      ==
  ^-  [(list card) (list [path @t])]
  =|  cards=(list card)
  =|  errors=(list [path @t])
  |-
  ?~  build-results  [cards errors]
  =*  contract-path   p.i.build-results
  =/  =build-result   r.i.build-results
  ?:  ?=(%| -.build-result)
    %=  $
        build-results  t.build-results
        errors         [[contract-path p.build-result] errors]
    ==
  =/  contract-jam-path=path
    ?>  ?=([%con *] contract-path)
    %-  snoc
    :_  %jam
    %-  snip
    `path`(welp /con/compiled +.contract-path)
  %=  $
      build-results  t.build-results
      cards
    :_  cards
    %^  make-save-jam  project
    contract-jam-path  p.build-result
  ==
::
++  build-contract-projects
  |=  $:  smart-lib=vase
          desk=path
          to-compile=(map path @ux)
      ==
  ^-  (list [path @ux build-result])
  %+  turn  ~(tap by to-compile)
  |=  [p=path q=@ux]
  ~&  "building {<p>} {<q>}..."
  [p q (build-contract-project smart-lib desk p)]
::
++  build-contract-project
  |=  [smart-lib=vase desk=path to-compile=path]
  ^-  build-result
  ::
  ::  adapted from compile-contract:conq
  ::  this wacky design is to get a somewhat more helpful error print
  ::
  |^
  =/  first  (mule |.(parse-main))
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
    ^-  [raw=(list [face=term =path]) contract-hoon=hoon]
    %-  parse-pile:conq
    (trip .^(@t %cx (welp desk to-compile)))
  ::
  ++  parse-libs  ::  second
    |=  raw=(list [face=term =path])
    ^-  (list hoon)
    %+  turn  raw
    |=  [face=term =path]
    ^-  hoon
    :+  %ktts  face
    +:(parse-pile:conq (trip .^(@t %cx (welp desk (welp path /hoon)))))
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
:: ++  fungible-template-project
::   |=  [current=project meta-rice=data:smart smart-lib-vase=vase]
::   ^-  project
::   ::  make fungible accounts and tests
::   =/  metadata
::     ;;  $:  name=@t
::             symbol=@t
::             decimals=@ud
::             supply=@ud
::             cap=(unit @ud)
::             mintable=?
::             minters=(pset:smart address:smart)
::             deployer=address:smart
::             salt=@
::         ==
::     (text-to-zebra-noun ;;(@t noun.meta-rice) smart-lib-vase)
::   =/  dead-beef-account-id
::     %:  hash-data:smart
::         source.meta-rice
::         user-address.current
::         designated-town-id
::         salt.metadata
::     ==
::   =/  dead-beef-account
::     ^-  data:smart
::     :*  dead-beef-account-id
::         source.meta-rice
::         user-address.current
::         designated-town-id
::         salt.metadata
::         %account
::         [200 ~ id.meta-rice 0]
::     ==
::   =/  cafe-babe-account-id
::     %:  hash-data:smart
::         source.meta-rice
::         0xcafe.babe
::         designated-town-id
::         salt.metadata
::     ==
::   =/  cafe-babe-account
::     ^-  data:smart
::     :*  cafe-babe-account-id
::         source.meta-rice
::         0xcafe.babe
::         designated-town-id
::         salt.metadata
::         %account
::         [100 ~ id.meta-rice 0]
::     ==
::   =/  cafe-d00d-account-id
::     %:  hash-data:smart
::         source.meta-rice
::         0xcafe.d00d
::         designated-town-id
::         salt.metadata
::     ==
::   =/  cafe-d00d-account
::     ^-  data:smart
::     :*  cafe-d00d-account-id
::         source.meta-rice
::         0xcafe.d00d
::         designated-town-id
::         salt.metadata
::         %account
::         [100 (make-pmap:smart ~[[0xdead.beef 50]]) id.meta-rice 0]
::     ==
::   =/  action-1=@t
::     %-  crip
::     %-  zing
::     :~  "[%give to=0xcafe.babe amount=30 from-account="
::         (trip (scot %ux dead-beef-account-id))
::         " to-account=`"
::         (trip (scot %ux cafe-babe-account-id))
::         "]"
::     ==
::   =/  yolk-1=calldata:smart
::     =-  [;;(@tas -.-) +.-]
::     q:(slap smart-lib-vase (ream action-1))
::   =/  test-1=test
::     =/  data-1
::       '[balance=170 allowances=~ metadata=0xdada.dada nonce=0]'
::     =/  data-2
::       '[balance=130 allowances=~ metadata=0xdada.dada nonce=0]'
::     :*  `'test-give'
::         next-contract-id.current
::         action-1
::         yolk-1
::         %-  malt
::         :~  :+  dead-beef-account-id
::               %&^dead-beef-account(noun q:(slap smart-lib-vase (ream data-1)))
::             data-1
::             :+  cafe-babe-account-id
::               %&^cafe-babe-account(noun q:(slap smart-lib-vase (ream data-2)))
::             data-2
::         ==
::         %0
::         ~
::     ==
::   =/  action-2=@t
::     %-  crip
::     %-  zing
::     :~  "[%take to=0xcafe.babe amount=50 from-account="
::         (trip (scot %ux cafe-d00d-account-id))
::         " to-account=`"
::         (trip (scot %ux cafe-babe-account-id))
::         "]"
::     ==
::   =/  yolk-2=calldata:smart
::     =-  [;;(@tas -.-) +.-]
::     q:(slap smart-lib-vase (ream action-2))
::   =/  test-2=test
::     =/  data-1
::       '[balance=50 allowances=(make-pmap ~[[0xdead.beef 0]]) metadata=0xdada.dada nonce=0]'
::     =/  data-2
::       '[balance=150 allowances=~ metadata=0xdada.dada nonce=0]'
::     :*  `'test-take'
::         next-contract-id.current
::         action-2
::         yolk-2
::         %-  malt
::         :~  :+  cafe-d00d-account-id
::               %&^cafe-d00d-account(noun (text-to-zebra-noun data-1 smart-lib-vase))
::             data-1
::             :+  cafe-babe-account-id
::               %&^cafe-babe-account(noun q:(slap smart-lib-vase (ream data-2)))
::             data-2
::         ==
::         %0
::         ~
::     ==
::   =/  action-3=@t
::     %-  crip
::     %-  zing
::     :~  "[%set-allowance who=0xcafe.babe amount=100 account="
::         (trip (scot %ux dead-beef-account-id))
::         "]"
::     ==
::   =/  yolk-3=calldata:smart
::     =-  [;;(@tas -.-) +.-]
::     q:(slap smart-lib-vase (ream action-3))
::   =/  test-3=test
::     =/  data-1
::       '[balance=200 allowances=(make-pmap ~[[0xcafe.babe 100]]) metadata=0xdada.dada nonce=0]'
::     :*  `'test-set-allowance'
::         next-contract-id.current
::         action-3
::         yolk-3
::         %-  malt
::         :~  :+  dead-beef-account-id
::               %&^dead-beef-account(noun (text-to-zebra-noun data-1 smart-lib-vase))
::             data-1
::         ==
::         %0
::         ~
::     ==
::   =/  fungible-contract-path=path  /con/fungible/hoon
::   %=  current
::       next-contract-id  (add next-contract-id.current 1)
::       user-files
::     (~(put in user-files.current) fungible-contract-path)
::   ::
::       to-compile
::     %+  ~(put by to-compile.current)  fungible-contract-path
::     next-contract-id.current
::   ::
::       tests
::     (malt ~[[0x1111.1111 test-1] [0x2222.2222 test-2] [0x3333.3333 test-3]])
::   ::
::       noun-texts
::     %-  ~(uni by noun-texts.current)
::     %-  ~(gas by *(map id:smart @t))
::     :~  [id.meta-rice ;;(@t noun.meta-rice)]
::         [dead-beef-account-id '[balance=200 allowances=~ metadata=0xdada.dada nonce=0]']
::         [cafe-babe-account-id '[balance=100 allowances=~ metadata=0xdada.dada nonce=0]']
::         [cafe-d00d-account-id '[balance=100 allowances=(make-pmap ~[[0xdead.beef 50]]) metadata=0xdada.dada nonce=0]']
::     ==
::   ::
::       p.chain
::     =-  (uni:big:engine p.chain.current -)
::     %+  gas:big:engine  *state:engine
::     :~  [id.meta-rice %&^meta-rice(noun metadata)]
::         [dead-beef-account-id %&^dead-beef-account]
::         [cafe-babe-account-id %&^cafe-babe-account]
::         [cafe-d00d-account-id %&^cafe-d00d-account]
::     ==
::   ==
:: ++  nft-template-project
::   |=  [current=project meta-rice=data:smart smart-lib-vase=vase]
::   ^-  project
::   ::  make fungible accounts and tests
::   =/  metadata
::     ;;  $:  name=@t
::             symbol=@t
::             properties=(pset:smart @tas)
::             supply=@ud
::             cap=(unit @ud)
::             mintable=?
::             minters=(pset:smart address:smart)
::             deployer=address:smart
::             salt=@
::         ==
::     (text-to-zebra-noun ;;(@t noun.meta-rice) smart-lib-vase)
::   ::
::   =/  props
::     %-  ~(gas py:smart *(map @tas @t))
::     %+  turn  ~(tap pn:smart properties.metadata)
::     |=  prop=@tas
::     [prop 'random_attribute']
::   =/  props-tape=tape
::     %-  zing
::     :~  "properties=(make-pmap `(list [@tas @t])`~["
::         ^-  tape
::         %-  snip
::         ^-  tape
::         %-  zing
::         %+  turn  ~(tap pn:smart properties.metadata)
::         |=  prop=@tas
::         %-  zing
::         :~  "[%"  (trip (scot %tas prop))
::             " 'random_attribute'] "
::         ==
::         "])"
::     ==
::   ::
::   =/  nft-1-id
::     %:  hash-data:smart
::         source.meta-rice
::         user-address.current
::         designated-town-id
::         (cat 3 salt.metadata (scot %ud 1))
::     ==
::   =/  nft-1
::     ^-  data:smart
::     :*  nft-1-id
::         source.meta-rice
::         user-address.current
::         designated-town-id
::         (cat 3 salt.metadata (scot %ud 1))
::         %nft
::         [1 'https://image.link' id.meta-rice ~ props &]
::     ==
::   =/  nft-1-text=@t
::     %-  crip
::     %-  zing
::     :~  "[id=1 uri='https://image.link' metadata=0xdada.dada allowances=~ "
::         props-tape
::         " transferrable=%.y]"
::     ==
::   =/  nft-2-id
::     %:  hash-data:smart
::         source.meta-rice
::         0xcafe.babe
::         designated-town-id
::         (cat 3 salt.metadata (scot %ud 2))
::     ==
::   =/  nft-2
::     ^-  data:smart
::     :*  nft-2-id
::         source.meta-rice
::         0xcafe.babe
::         designated-town-id
::         (cat 3 salt.metadata (scot %ud 2))
::         %nft
::         [2 'https://image.link' id.meta-rice ~ props &]
::     ==
::   =/  nft-2-text=@t
::     %-  crip
::     %-  zing
::     :~  "[id=2 uri='https://image.link' metadata=0xdada.dada allowances=~ "
::         props-tape
::         " transferrable=%.y]"
::     ==
::   ::
::   =/  action-1=@t
::     %-  crip
::     %-  zing
::     :~  "[%give to=0xcafe.babe item-id="
::         (trip (scot %ux nft-1-id))
::         "]"
::     ==
::   =/  yolk-1=calldata:smart
::     =-  [;;(@tas -.-) +.-]
::     q:(slap smart-lib-vase (ream action-1))
::   =/  test-1=test
::     :*  `'test-give'
::         next-contract-id.current
::         action-1
::         yolk-1
::         %-  malt
::         :~  :+  nft-1-id
::               %&^nft-1(holder 0xcafe.babe)
::             nft-1-text
::         ==
::         %0
::         ~
::     ==
::   ::
::   =/  action-2=@t
::     %-  crip
::     %-  zing
::     :~  "[%give to=0xcafe.babe item-id="
::         (trip (scot %ux nft-2-id))
::         "]"
::     ==
::   =/  yolk-2=calldata:smart
::     =-  [;;(@tas -.-) +.-]
::     q:(slap smart-lib-vase (ream action-2))
::   =/  test-2=test
::     :*  `'test-give-dont-have'
::         next-contract-id.current
::         action-2
::         yolk-2
::         ~
::         %6
::         ~
::     ==
::   ::
::   =/  action-3=@t
::     %-  crip
::     %-  zing
::     :~  "[%mint token=0xdada.dada mints=[to="
::         (trip (scot %ux user-address.current))
::         " uri='https://image.link' "
::         props-tape
::         " transferrable=%.y] ~]"
::     ==
::   =/  yolk-3=calldata:smart
::     =-  [;;(@tas -.-) +.-]
::     (text-to-zebra-noun action-3 smart-lib-vase)
::   =/  nft-3-id
::     %:  hash-data:smart
::         source.meta-rice
::         user-address.current
::         designated-town-id
::         (cat 3 salt.metadata (scot %ud 3))
::     ==
::   =/  nft-3
::     ^-  data:smart
::     :*  nft-3-id
::         source.meta-rice
::         user-address.current
::         designated-town-id
::         (cat 3 salt.metadata (scot %ud 3))
::         %nft
::         [3 'https://image.link' id.meta-rice ~ props &]
::     ==
::   =/  nft-3-text=@t
::     %-  crip
::     %-  zing
::     :~  "[id=3 uri='https://image.link' metadata=0xdada.dada allowances=~ "
::         props-tape
::         " transferrable=%.y]"
::     ==
::   =/  test-3=test
::     :*  `'test-mint'
::         next-contract-id.current
::         action-3
::         yolk-3
::         (malt ~[[nft-3-id [%&^nft-3 nft-3-text]]])
::         %0
::         ~
::     ==
::   =/  nft-contract-path=path  /con/nft/hoon
::   %=  current
::       next-contract-id  (add next-contract-id.current 1)
::       user-files
::     (~(put in user-files.current) nft-contract-path)
::   ::
::       to-compile
::     %+  ~(put by to-compile.current)  nft-contract-path
::     next-contract-id.current
::   ::
::       tests
::     (malt ~[[0x1111.1111 test-1] [0x2222.2222 test-2] [0x3333.3333 test-3]])
::   ::
::       noun-texts
::     %-  ~(uni by noun-texts.current)
::     %-  ~(gas by *(map id:smart @t))
::     :~  [id.meta-rice ;;(@t noun.meta-rice)]
::         ::  [1 'https://image.link' id.meta-rice ~ props &]
::         [nft-1-id nft-1-text]
::     ::
::         [nft-2-id nft-2-text]
::     ==
::   ::
::       p.chain
::     =-  (uni:big:engine p.chain.current -)
::     %+  gas:big:engine  *state:engine
::     :~  [id.meta-rice %&^meta-rice(noun metadata)]
::         [nft-1-id %&^nft-1]
::         [nft-2-id %&^nft-2]
::     ==
::   ==
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
++  item-to-json
  |=  [=item:smart tex=@t]
  =,  enjs:format
  ^-  json
  %-  pairs
  %+  welp
    :~  ['is-pact' %b ?=(%| -.item)]
        ['source' %s (scot %ux source.p.item)]
        ['holder' %s (scot %ux holder.p.item)]
        ['town' %s (scot %ux town.p.item)]
    ==
  ?:  ?=(%| -.item)  ~
  :~  ['salt' (numb salt.p.item)]
      ['label' %s (scot %tas label.p.item)]
      ['noun_text' %s tex]
      ['noun' %s (crip (noah !>(noun.p.item)))]  ::  TODO: remove?
  ==
::
++  project-to-json
  |=  [p=project our=@p now=@da]
  =,  enjs:format
  ^-  json
  %-  pairs
  :~  ['dir' (dir-to-json dir.p)]
      ['user_files' (dir-to-json ~(tap in user-files.p))]
      ['to_compile' (to-compile-to-json to-compile.p)]
      ['next_contract_id' %s (scot %ux next-contract-id.p)]
      ['errors' (errors-to-json errors.p)]
      ['state' (state-to-json p our now)]
      :: ['tests' (tests-to-json tests.p)]  :: TODO
  ==
::
++  state-to-json
  |=  [p=project our=@p now=@da]
  ^-  json
  %-  pairs:enjs:format
  %+  turn  ~(tap by town-sequencers.p)
  |=  [town-id=@ux who=@p]
  =/  who-ta=@ta   (scot %p who)
  =/  now-ta=@ta   (scot %da now)
  =/  town-ta=@ta  (scot %ux town-id)
  =/  =update:ui
    %-  fall  :_  ~
    ;;  (unit update:ui)
    .^  noun
        %gx
        ;:  weld
          /(scot %p our)/pyro/[now-ta]/i/[who-ta]/gx
          /[who-ta]/indexer/[now-ta]/batch-order/[town-ta]
          /noun/noun
    ==  ==
  =/  newest-batch=@ux
    ?>  ?=(^ update)
    ?>  ?=(%batch-order -.update)
    ?>  ?=(^ batch-order.update)
    i.batch-order.update
  :-  (scot %ux town-id)
  %-  fall  :_  ~
  ;;  (unit json)
  .^  noun
      %gx
      ;:  weld
          /(scot %p our)/pyro/[now-ta]/i/[who-ta]/gx
          /[who-ta]/indexer/[now-ta]/json/newest/batch-chain
          /[town-ta]/(scot %ux newest-batch)/noun/noun
  ==  ==
::
++  tests-to-json  :: TODO
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
      ['surs' (dir-to-json surs.test)]
      ['subject' %s ?:(?=(%& -.subject.test) '' p.subject.test)]
      ['custom-step-definitions' (custom-step-definitions-to-json custom-step-definitions.test)]
      ['steps' (test-steps-to-json steps.test)]
      ['results' (test-results-to-json results.test)]
  ==
::
++  dir-to-json
  |=  dir=(list path)
  =,  enjs:format
  ^-  json
  :-  %a
  %+  turn  dir
  |=  p=^path
  (path p)
::
++  to-compile-to-json
  |=  to-compile=(map path @ux)
  =,  enjs:format
  ^-  json
  :-  %a
  %+  turn  ~(tap by to-compile)
  |=  [p=^path id=@ux]
  %-  pairs
  :+  ['path' (path p)]
    ['wheat-id' %s (scot %ux id)]
  ~
::
++  errors-to-json
  |=  errors=(list [path @t])
  =,  enjs:format
  ^-  json
  ?~  errors  ~
  :-  %a
  %+  turn  errors
  |=  [p=^path error=@t]
  %-  pairs
  :+  ['path' (path p)]
    ['error' %s error]
  ~
::
++  custom-step-definitions-to-json
  |=  =custom-step-definitions
  =,  enjs:format
  ^-  json
  %-  pairs
  %+  turn  ~(tap by custom-step-definitions)
  |=  [id=@tas def=custom-step-definition com=custom-step-compiled]
  :-  id
  %-  pairs
  :+  ['custom-step-definition' %s def]
    ['custom-step-compiled' (custom-step-compiled-to-json com)]
  ~
::
++  custom-step-compiled-to-json
  |=  =custom-step-compiled
  =,  enjs:format
  ^-  json
  %-  pairs
  :+  ['compiled-successfully' %b ?=(%& -.custom-step-compiled)]
    ['compile-error' %s ?:(?=(%& -.custom-step-compiled) '' p.custom-step-compiled)]
  ~
::
++  test-steps-to-json
  |=  =test-steps
  ^-  json
  :-  %a
  %+  turn  test-steps
  |=([=test-step] (test-step-to-json test-step))
::
++  test-step-to-json
  |=  =test-step
  ^-  json
  ?:  ?=(?(%dojo %poke %subscribe %custom-write) -.test-step)
    (test-write-step-to-json test-step)
  ?>  ?=(?(%scry %read-subscription %wait %custom-read) -.test-step)
  (test-read-step-to-json test-step)
::
++  test-write-step-to-json
  |=  test-step=test-write-step
  =,  enjs:format
  ^-  json
  %+  frond  -.test-step
  ?-    -.test-step
      %dojo
    %-  pairs
    :+  ['payload' (dojo-payload-to-json payload.test-step)]
      ['expected' (write-expected-to-json expected.test-step)]
    ~
  ::
      %poke
    %-  pairs
    :+  ['payload' (poke-payload-to-json payload.test-step)]
      ['expected' (write-expected-to-json expected.test-step)]
    ~
  ::
      %subscribe
    %-  pairs
    :+  ['payload' (sub-payload-to-json payload.test-step)]
      ['expected' (write-expected-to-json expected.test-step)]
    ~
  ::
      %custom-write
    %+  frond  tag.test-step
    %-  pairs
    :+  ['payload' %s payload.test-step]
      ['expected' (write-expected-to-json expected.test-step)]
    ~
  ==
::
++  test-read-step-to-json
  |=  test-step=test-read-step
  =,  enjs:format
  ^-  json
  %+  frond  -.test-step
  ?-    -.test-step
      %scry
    %-  pairs
    :+  ['payload' (scry-payload-to-json payload.test-step)]
      ['expected' %s expected.test-step]
    ~
  ::
      %read-subscription  ~  ::  TODO
  ::
      %wait
    (frond 'until' [%s (scot %dr until.test-step)])
  ::
      %custom-read
    %+  frond  tag.test-step
    %-  pairs
    :+  ['payload' %s payload.test-step]
      ['expected' %s expected.test-step]
    ~
  ==
::
++  scry-payload-to-json
  |=  payload=scry-payload
  =,  enjs:format
  ^-  json
  %-  pairs
  :~  ['who' %s (scot %p who.payload)]
      ['mold-name' %s mold-name.payload]
      ['care' %s care.payload]
      ['app' %s app.payload]
      ['path' (path path.payload)]
  ==
::
++  poke-payload-to-json
  |=  payload=poke-payload
  =,  enjs:format
  ^-  json
  %-  pairs
  :~  ['who' %s (scot %p who.payload)]
      ['app' %s app.payload]
      ['mark' %s mark.payload]
      ['payload' %s payload.payload]
  ==
::
++  dojo-payload-to-json
  |=  payload=dojo-payload
  =,  enjs:format
  ^-  json
  %-  pairs
  :+  ['who' %s (scot %p who.payload)]
    ['payload' %s payload.payload]
  ~
::
++  sub-payload-to-json
  |=  payload=sub-payload
  =,  enjs:format
  ^-  json
  %-  pairs
  :^    ['who' %s (scot %p who.payload)]
      ['app' %s app.payload]
    ['path' (path p.payload)]
  ~
::
++  write-expected-to-json
  |=  test-read-steps=(list test-read-step)
  =,  enjs:format
  ^-  json
  :-  %a
  %+  turn  test-read-steps
  |=([=test-read-step] (test-read-step-to-json test-read-step))
::
++  test-results-to-json
  |=  =test-results
  =,  enjs:format
  ^-  json
  :-  %a
  %+  turn  test-results
  |=([=test-result] (test-result-to-json test-result))
::
++  test-result-to-json
  |=  =test-result
  =,  enjs:format
  ^-  json
  :-  %a
  %+  turn  test-result
  |=  [success=? expected=@t result=@t]
  %-  pairs
  :^    ['success' %b success]
      ['expected' %s expected]
    ['result' %s result]
  ~
--
