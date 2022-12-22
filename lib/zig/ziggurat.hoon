/-  eng=zig-engine,
    ui=zig-indexer,
    zig=zig-ziggurat
/+  conq=zink-conq,
    dock=docket,
    smart=zig-sys-smart,
    ui-lib=zig-indexer,
    zink=zink-zink
|_  =bowl:gall
+$  card  card:agent:gall
::
::  utilities
::
++  make-project-update
  |=  [project-name=@t =project:zig]
  ^-  card
  =/  p=path  /project/[project-name]
  =/  update=project-update:zig
    :_  project
    (get-state-to-json project)
  :^  %give  %fact  ~[p]
  :-  %ziggurat-project-update
  !>(`project-update:zig`update)
::
++  make-compile-contracts
  |=  [project-name=@t]
  ^-  card
  =-  [%pass /self-wire %agent [our.bowl %ziggurat] %poke -]
  :-  %ziggurat-action
  !>(`action:zig`project-name^[%compile-contracts ~])
::
++  make-compile-contract
  |=  [project-name=@t file=path]
  ^-  card
  =-  [%pass /self-wire %agent [our.bowl %ziggurat] %poke -]
  :-  %ziggurat-action
  !>(`action:zig`project-name^[%compile-contract file])
::
++  make-watch-for-file-changes
  |=  [project-name=@tas files=(list path)]
  ^-  card
  =-  [%pass /clay/[project-name] %arvo %c %warp our.bowl project-name -]
  :^  ~  %mult  da+now.bowl
  %-  ~(gas in *(set [care:clay path]))
  (turn files |=(p=path [%x p]))
::
++  make-read-desk
  |=  project-name=@t
  ^-  card
  =-  [%pass /self-wire %agent [our.bowl %ziggurat] %poke -]
  :-  %ziggurat-action
  !>(`action:zig`project-name^[%read-desk ~])
::
++  make-save-jam
  |=  [project-name=@t file=path non=*]
  ^-  card
  ?>  ?=(%jam (rear file))
  =-  [%pass /save-wire %arvo %c -]
  :-  %info
  [`@tas`project-name %& [file %ins %noun !>(`@`(jam non))]~]
::
++  make-save-file
  |=  [project-name=@t file=path text=@t]
  ^-  card
  =/  file-type  (rear file)
  =/  mym=mime  :-  /application/x-urb-unknown
    %-  as-octt:mimes:html
    %+  rash  text
    (star ;~(pose (cold '\0a' (jest '\0d\0a')) next))
  =-  [%pass /save-wire %arvo %c -]
  :^  %info  `@tas`project-name  %&
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
  |=  project-name=@t
  ^-  card
  :^  %pass  /self-poke  %agent
  :^  [our.bowl %ziggurat]  %poke  %ziggurat-action
  !>(`action:zig`[project-name %run-queue ~])
::
++  convert-contract-hoon-to-jam
  |=  contract-hoon-path=path
  ^-  (unit path)
  ?.  ?=([%con *] contract-hoon-path)  ~
  :-  ~
  %-  snoc
  :_  %jam
  %-  snip
  `path`(welp /con/compiled +.contract-hoon-path)
::
++  save-compiled-contracts
  |=  $:  project-name=@t
          build-results=(list [p=path q=build-result:zig])
      ==
  ^-  [(list card) (list [path @t])]
  =|  cards=(list card)
  =|  errors=(list [path @t])
  |-
  ?~  build-results      [cards errors]
  =*  contract-path       p.i.build-results
  =/  =build-result:zig   q.i.build-results
  =/  save-result=(each card [path @t])
    %^  save-compiled-contract  project-name  contract-path
    build-result
  ?:  ?=(%| -.save-result)
    %=  $
        build-results  t.build-results
        errors         [p.save-result errors]
    ==
  %=  $
      build-results  t.build-results
      cards          [p.save-result cards]
  ==
::
++  save-compiled-contract
  |=  $:  project-name=@t
          contract-path=path
          =build-result:zig
      ==
  ^-  (each card [path @t])
  ?:  ?=(%| -.build-result)
    [%| [contract-path p.build-result]]
  =/  contract-jam-path=path
    (need (convert-contract-hoon-to-jam contract-path))
  :-  %&
  %^  make-save-jam  project-name  contract-jam-path
  p.build-result
::
++  build-contract-projects
  |=  $:  smart-lib=vase
          desk=path
          to-compile=(set path)
      ==
  ^-  (list [path build-result:zig])
  %+  turn  ~(tap in to-compile)
  |=  p=path
  ~&  "building {<p>}..."
  [p (build-contract-project smart-lib desk p)]
::
++  build-contract-project
  |=  [smart-lib=vase desk=path to-compile=path]
  ^-  build-result:zig
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
++  show-test-results
  |=  =test-results:zig
  ^-  shown-test-results:zig
  (turn test-results show-test-result)
::
++  show-test-result
  |=  =test-result:zig
  ^-  shown-test-result:zig
  %+  turn  test-result
  |=  [success=? expected=@t result=vase]
  =/  res-text=@t  (crip (noah result))
  :+  success  expected
  ?:  (lte 1.024 (met 3 res-text))  '<elided>'
  res-text
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
  /+  default-agent, dbug
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
  ++  on-init                     :: [(list card) this]
    `this(state [%0 ~])
  ++  on-save
    ^-  vase
    !>(state)
  ++  on-load                     :: |=(old-state=vase [(list card) this])
    on-load:default
  ++  on-poke   on-poke:default   :: |=(=cage [(list card) this])
  ++  on-watch  on-watch:default  :: |=(=path [(list card) this])
  ++  on-leave  on-leave:default  :: |=(=path [(list card) this])
  ++  on-peek   on-peek:default   :: |=(=path [(list card) this])
  ++  on-agent  on-agent:default  :: |=  [=wire =sign:agent:gall] 
                                  :: [(list card) this]
  ++  on-arvo   on-arvo:default   :: |=([=wire =sign-arvo] [(list card) this])
  ++  on-fail   on-fail:default   :: |=  [=term =tang] 
                                  :: %-  (slog leaf+"{<dap.bowl>}" >term< tang)
                                  :: [(list card) this]
  --
  '''
::
++  get-state
  |=  =project:zig
  ^-  (map @ux chain:eng)
  =/  now-ta=@ta   (scot %da now.bowl)
  %-  ~(gas by *(map @ux chain:eng))
  %+  murn  ~(tap by town-sequencers.project)
  |=  [town-id=@ux who=@p]
  =/  who-ta=@ta   (scot %p who)
  =/  town-ta=@ta  (scot %ux town-id)
  =/  batch-order=update:ui
    %-  fall  :_  ~
    ;;  (unit update:ui)
    .^  noun
        %gx
        ;:  weld
          /(scot %p our.bowl)/pyro/[now-ta]/i/[who-ta]/gx
          /[who-ta]/indexer/[now-ta]/batch-order/[town-ta]
          /noun/noun
    ==  ==
  ?~  batch-order                     ~
  ?.  ?=(%batch-order -.batch-order)  ~
  ?~  batch-order.batch-order         ~
  =*  newest-batch  i.batch-order.batch-order
  =/  batch-chain=update:ui
    %-  fall  :_  ~
    ;;  (unit update:ui)
    .^  noun
        %gx
        ;:  weld
            /(scot %p our.bowl)/pyro/[now-ta]/i/[who-ta]/gx
            /[who-ta]/indexer/[now-ta]/newest/batch-chain
            /[town-ta]/(scot %ux newest-batch)/noun/noun
    ==  ==
  ?~  batch-chain                     ~
  ?.  ?=(%batch-chain -.batch-chain)  ~
  =/  chains=(list batch-chain-update-value:ui)
    ~(val by chains.batch-chain)
  ?.  =(1 (lent chains))              ~
  ?~  chains                          ~  ::  for compiler
  `[town-id chain.i.chains]
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
  |=  p=project:zig
  =,  enjs:format
  ^-  json
  %-  pairs
  :~  ['dir' (dir-to-json dir.p)]
      ['user_files' (dir-to-json ~(tap in user-files.p))]
      ['to_compile' (dir-to-json ~(tap in to-compile.p))]
      ['errors' (errors-to-json errors.p)]
      ['town_sequencers' (town-sequencers-to-json town-sequencers.p)]
      ['tests' (tests-to-json tests.p)]
      ['dbug_dashboards' (dbug-dashboards-to-json dbug-dashboards.p)]
  ==
::
++  state-to-json
  |=  state=(map @ux chain:eng)
  ^-  json
  %-  pairs:enjs:format
  %+  turn  ~(tap by state)
  |=  [town-id=@ux =chain:eng]
  [(scot %ux town-id) (chain:enjs:ui-lib chain)]
::
++  get-state-to-json
  |=  =project:zig
  ^-  json
  ?~  state=(get-state project)  ~
  (state-to-json state)
::
++  tests-to-json
  |=  =tests:zig
  =,  enjs:format
  ^-  json
  %-  pairs
  %+  turn  ~(tap by tests)
  |=  [id=@ux =test:zig]
  [(scot %ux id) (test-to-json test)]
::
++  test-to-json
  |=  =test:zig
  =,  enjs:format
  ^-  json
  %-  pairs
  :~  ['name' %s ?~(name.test '' u.name.test)]
      ['test-steps-file' (path test-steps-file.test)]
      ['test-surs' (test-surs-to-json test-surs.test)]
      ['subject' %s ?:(?=(%& -.subject.test) '' p.subject.test)]
      ['custom-step-definitions' (custom-step-definitions-to-json custom-step-definitions.test)]
      ['steps' (test-steps-to-json steps.test)]
      ['results' (test-results-to-json results.test)]
  ==
::
++  test-surs-to-json
  |=  =test-surs:zig
  ^-  json
  %-  pairs:enjs:format
  %+  turn  ~(tap by test-surs)
  |=  [face=@tas p=path]
  [face (path:enjs:format p)]
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
++  errors-to-json
  |=  errors=(map path @t)
  ^-  json
  %-  pairs:enjs:format
  %+  turn  ~(tap by errors)
  |=  [p=path error=@t]
  [(crip (noah !>(`path`p))) %s error]
::
++  custom-step-definitions-to-json
  |=  =custom-step-definitions:zig
  =,  enjs:format
  ^-  json
  %-  pairs
  %+  turn  ~(tap by custom-step-definitions)
  |=  [id=@tas p=^path com=custom-step-compiled:zig]
  :-  id
  %-  pairs
  :+  ['path' (path p)]
    ['custom-step-compiled' (custom-step-compiled-to-json com)]
  ~
::
++  custom-step-compiled-to-json
  |=  =custom-step-compiled:zig
  =,  enjs:format
  ^-  json
  %-  pairs
  :+  ['compiled-successfully' %b ?=(%& -.custom-step-compiled)]
    ['compile-error' %s ?:(?=(%& -.custom-step-compiled) '' p.custom-step-compiled)]
  ~
::
++  town-sequencers-to-json
  |=  town-sequencers=(map @ux @p)
  =,  enjs:format
  ^-  json
  %-  pairs
  %+  turn  ~(tap by town-sequencers)
  |=  [town-id=@ux who=@p]
  [(scot %ux town-id) %s (scot %p who)]
::
++  test-steps-to-json
  |=  =test-steps:zig
  ^-  json
  :-  %a
  %+  turn  test-steps
  |=([=test-step:zig] (test-step-to-json test-step))
::
++  test-step-to-json
  |=  =test-step:zig
  ^-  json
  ?:  ?=(?(%dojo %poke %subscribe %custom-write) -.test-step)
    (test-write-step-to-json test-step)
  ?>  ?=(?(%scry %read-subscription %wait %custom-read) -.test-step)
  (test-read-step-to-json test-step)
::
++  test-write-step-to-json
  |=  test-step=test-write-step:zig
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
  |=  test-step=test-read-step:zig
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
      %dbug
    %-  pairs
    :+  ['payload' (dbug-payload-to-json payload.test-step)]
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
  |=  payload=scry-payload:zig
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
++  dbug-payload-to-json
  |=  payload=dbug-payload:zig
  =,  enjs:format
  ^-  json
  %-  pairs
  :+  ['who' %s (scot %p who.payload)]
    ['app' %s app.payload]
  ~
::
++  poke-payload-to-json
  |=  payload=poke-payload:zig
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
  |=  payload=dojo-payload:zig
  =,  enjs:format
  ^-  json
  %-  pairs
  :+  ['who' %s (scot %p who.payload)]
    ['payload' %s payload.payload]
  ~
::
++  sub-payload-to-json
  |=  payload=sub-payload:zig
  =,  enjs:format
  ^-  json
  %-  pairs
  :~  ['who' %s (scot %p who.payload)]
      ['to' %s (scot %p to.payload)]
      ['app' %s app.payload]
      ['path' (path path.payload)]
  ==
::
++  write-expected-to-json
  |=  test-read-steps=(list test-read-step:zig)
  =,  enjs:format
  ^-  json
  :-  %a
  %+  turn  test-read-steps
  |=([=test-read-step:zig] (test-read-step-to-json test-read-step))
::
++  test-results-to-json
  |=  =test-results:zig
  =,  enjs:format
  ^-  json
  :-  %a
  %+  turn  test-results
  |=([=test-result:zig] (test-result-to-json test-result))
::
++  test-result-to-json
  |=  =test-result:zig
  =,  enjs:format
  ^-  json
  :-  %a
  %+  turn  test-result
  |=  [success=? expected=@t result=vase]
  %-  pairs
  :^    ['success' %b success]
      ['expected' %s expected]
    ['result' %s (crip (noah result))]
  ~
::
++  dbug-dashboards-to-json
  |=  dashboards=(map @tas dbug-dashboard:zig)
  ^-  json
  %-  pairs:enjs:format
  %+  turn  ~(tap by dashboards)
  |=  [app=@tas d=dbug-dashboard:zig]
  [app (dbug-dashboard-to-json d)]
::
++  dbug-dashboard-to-json
  |=  d=dbug-dashboard:zig
  =,  enjs:format
  ^-  json
  %-  pairs
  :~  [%sur (path sur.d)]
      [%mold-name %s mold-name.d]
      [%mar (path mar.d)]
      [%did-mold-compile %b ?=(%& mold.d)]
      [%did-mar-tube-compile %b ?=(^ mar-tube.d)]
  ==
::
++  json-single-string-object
  |=  [key=@t error=tape]
  =,  enjs:format
  ^-  json
  (frond key [%s (crip error)])
--
