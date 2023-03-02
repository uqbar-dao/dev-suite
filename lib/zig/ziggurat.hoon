/-  spider,
    eng=zig-engine,
    pyro=zig-pyro,
    seq=zig-sequencer,
    ui=zig-indexer,
    zig=zig-ziggurat
/+  agentio,
    mip,
    strandio,
    conq=zink-conq,
    dock=docket,
    pyro-lib=pyro-pyro,
    smart=zig-sys-smart,
    ui-lib=zig-indexer,
    zink=zink-zink
|_  [=bowl:gall =settings:zig]
+*  this    .
    io      ~(. agentio bowl)
    strand  strand:spider
::
+$  card  card:agent:gall
::
::  utilities
::
++  default-ships
  ^-  (list @p)
  ~[~nec ~wes ~bud]
::
++  default-ships-set
  ^-  (set @p)
  (~(gas in *(set @p)) default-ships)
::
++  default-snap-path
  ^-  path
  /testnet
::
++  make-compile-contracts
  |=  [project-name=@t request-id=(unit @t)]
  ^-  card
  %-  ~(poke-self pass:io /self-wire)
  :-  %ziggurat-action
  !>(`action:zig`project-name^request-id^[%compile-contracts ~])
::
++  make-watch-for-file-changes
  |=  project-name=@tas
  ^-  card
  %-  ~(warp-our pass:io /clay/[project-name])
  [project-name ~ %next %v da+now.bowl /]
::
++  make-cancel-watch-for-file-changes
  |=  project-name=@tas
  ^-  card
  %-  ~(warp-our pass:io /clay/[project-name])
  [project-name ~]
::
++  make-read-desk
  |=  [project-name=@t request-id=(unit @t)]
  ^-  card
  %-  ~(poke-self pass:io /self-wire)
  :-  %ziggurat-action
  !>(`action:zig`project-name^request-id^[%read-desk ~])
::
++  make-save-jam
  |=  [project-name=@t file=path non=*]
  ^-  card
  ?>  ?=(%jam (rear file))
  %-  ~(arvo pass:io /save-wire)
  :+  %c  %info
  [`@tas`project-name %& [file %ins %noun !>(`@`(jam non))]~]
::
++  make-save-file
  |=  [=update-info:zig file=path text=@t]
  ^-  card
  =*  project-name  project-name.update-info
  =/  file-type=@tas  (rear file)
  |^
  =/  supported-file-types=(set @tas)
    %-  ~(gas in *(set @tas))
    ~[%hoon %ship %bill %kelvin %docket-0]
  ?:  (~(has in supported-file-types) file-type)  make-card
  =/  is-mark-found=?
    .^  ?
        %cu
        %+  weld  /(scot %p our.bowl)/[project-name]
        /(scot %da now.bowl)/mar/[file-type]/hoon
    ==
  ?:  is-mark-found                               make-card
  %-  update-vase-to-card
  %-  %~  save-file  make-error-vase
      [update-info %error]
  %-  crip
  ;:  weld
      "cannot save file with mark {<`@tas`file-type>}."
      " supported file marks are"
      " {<`(set @tas)`supported-file-types>}"
      " and marks with %mime grow arms in"
      " {<`path`/[project-name]/mar>}"
  ==
  ::
  ++  make-card
    ^-  card
    =.  text  ?.(=('' text) text (make-template file))
    =/  mym=mime
      :-  /application/x-urb-unknown
      %-  as-octt:mimes:html
      %+  rash  text
      (star ;~(pose (cold '\0a' (jest '\0d\0a')) next))
    %-  ~(arvo pass:io /save-wire)
    :-  %c
    :^  %info  `@tas`project-name  %&
    :_  ~  :+  file  %ins
    =*  reamed-text  q:(slap !>(~) (ream text))  ::  =* in case text unreamable
    ?+    file-type  [%mime !>(mym)] :: don't need to know mar if we have bytes :^)
        %hoon        [%hoon !>(text)]
        %ship        [%ship !>(;;(@p reamed-text))]
        %bill        [%bill !>(;;((list @tas) reamed-text))]
        %kelvin      [%kelvin !>(;;([@tas @ud] reamed-text))]
        %docket-0
      =-  [%docket-0 !>((need (from-clauses:mime:dock -)))]
      ;;((list clause:dock) reamed-text)
    ==
  --
::
++  make-run-queue
  |=  [project-name=@t request-id=(unit @t)]
  ^-  card
  %-  ~(poke-self pass:io /self-wire)
  :-  %ziggurat-action
  !>(`action:zig`project-name^request-id^[%run-queue ~])
::
++  make-delete-test
  |=  [id=@ux project-name=@t request-id=(unit @t)]
  ^-  card
  %-  ~(poke-self pass:io /self-wire)
  :-  %ziggurat-action
  !>(`action:zig`project-name^request-id^[%delete-test id])
::
++  make-test-steps-file
  |=  =test:zig
  ^-  @t
  %+  rap  3
  :~
  ::  imports
    %+  roll  ~(tap by test-imports.test)
    |=  [[face=@tas file=path] imports=@t]
    %+  rap  3
    :~  imports
        '/=  '
        face
        '  '
        (crip (noah !>(file)))
        '\0a'
    ==
  ::  infix
    '''
    ::
    |%
    ++  $
      ^-  test-steps:zig
      :~

    '''
  ::  test-steps
    %+  roll  steps.test
    |=  [=test-step:zig test-steps-text=@t]
    %+  rap  3
    :~  test-steps-text
        '  ::\0a'
        '    '
        (crip (noah !>(test-step)))
        '\0a'
    ==
  ::  suffix
    '''
      ==
    --

    '''
  ==
::
++  make-configs-file
  |=  $:  =config:zig
          vships-to-sync=(list @p)
          install=?
          start-apps=(list @tas)
          state-views=(list [@p (unit @tas) path])
          setup=(map @p test-steps:zig)
          imports-list=(list [@tas path])
      ==
  |^  ^-  @t
  %+  rap  3
  :~
  ::  imports
    %+  roll  imports-list
    |=  [[face=@tas file=path] imports=@t]
    %+  rap  3
    :~  imports
        '/=  '
        face
        '  '
        (crip (noah !>(file)))
        '\0a'
    ==
  ::  infix
    '''
    ::
    |%
    ++  make-config
      ^-  config:zig
      %-  ~(gas by *config:zig)

    '''
    '  '
    (crip (noah !>(`(list [[@p @tas] @])`~(tap by config))))
    '\0a'
    '''
    ::
    ++  make-virtualships-to-sync
      ^-  (list @p)

    '''
    '  '
    (crip (noah !>(`(list @p)`vships-to-sync)))
    '\0a'
    '''
    ::
    ++  make-install
      ^-  ?

    '''
    '  '
    (crip (noah !>(`?`install)))
    '\0a'
    '''
    ::
    ++  make-start-apps
      ^-  (list @tas)

    '''
    '  '
    (crip (noah !>(`(list @tas)`start-apps)))
    '\0a'
    '''
    ++  make-state-views
      ^-  (list [who=@p app=(unit @tas) file-path=path])
      ::  app=~ -> chain view, not an agent view

    '''
    '  '
    %-  crip
    (noah !>(`(list [@p (unit @tas) path])`state-views))
    '\0a'
    make-make-setup
  ::  suffix
    '''
    --

    '''
  ==
  ::
  ++  make-make-setup
    ^-  @t
    ?:  =(0 ~(wyt by setup))
      '''
      ::
      ++  make-setup
        ^-  (map @p test-steps:zig)
        ~

      '''
    ~&  "TODO: bother ~hosted-fornet to finish implementing non-null setup case! Just needs a roll to add arms for ++make-setup-* and testing"
    !!
    :: %+  rap  3
    :: :~
    ::   '''
    ::   \0a::
    ::   ++  make-setup
    ::     |^  ^-  (map @p test-steps:zig)
    ::     %-  ~(gas by *(map @p test-steps:zig))
    ::     :~

    ::   '''
    :: ::  [~zod make-setup-zod] pairs
    ::   %+  roll  vships-to-sync
    ::   |=  [who=@p test-steps-text=@t]
    ::   =/  noah-who=tape  (noah !>(`@p`who))
    ::   %+  rap  3
    ::   :~  test-steps-text
    ::       '    ['
    ::       (crip noah-who)
    ::       ' make-setup-'
    ::       (crip (slag 1 noah-who))
    ::       ']\0a'
    ::   ==
    :: ::  suffix of main
    ::   '''
    ::   ==
    ::   ::
    ::  ::  test-steps
    ::    %+  roll  test-steps
    ::    |=  [=test-step:zig test-steps-text=@t]
    ::    %+  rap  3
    ::    :~  test-steps-text
    ::        '  ::\0a'
    ::        '    '
    ::        (crip (noah !>(test-step)))
    ::        '\0a'
    ::    ==
    ::   '''
    :: ==
  --
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
  !.
  |=  [smart-lib=vase desk=path to-compile=path]
  ^-  build-result:zig
  ::
  ::  adapted from compile-contract:conq
  ::  this wacky design is to get a more helpful error print
  ::
  |^
  =/  first  (mule |.(parse-main))
  ?:  ?=(%| -.first)
    :-  %|
    %-  reformat-compiler-error
    (snoc p.first 'error parsing main:')
    :: (snoc (scag 4 p.first) 'error parsing main:')
  ?:  ?=(%| -.p.first)  [%| p.p.first]
  =/  second  (mule |.((parse-imports raw.p.p.first)))
  ?:  ?=(%| -.second)
    :-  %|
    %-  reformat-compiler-error
    (snoc p.second 'error parsing import:')
    :: (snoc (scag 3 p.second) 'error parsing import:')
  ?:  ?=(%| -.p.second)  [%| p.p.second]
  =/  third  (mule |.((build-imports p.p.second)))
  ?:  ?=(%| -.third)
    %|^(reformat-compiler-error (snoc p.third 'error building imports:'))
    :: %|^(reformat-compiler-error (snoc (scag 2 p.third) 'error building imports:'))
  =/  fourth  (mule |.((build-main vase.p.third contract-hoon.p.p.first)))
  ?:  ?=(%| -.fourth)
    :-  %|
    %-  reformat-compiler-error
    (snoc p.fourth 'error building main:')
    :: (snoc (scag 2 p.fourth) 'error building main:')
  %&^[bat=p.fourth pay=nok.p.third]
  ::
  ++  parse-main  ::  first
    ^-  (each [raw=(list [face=term =path]) contract-hoon=hoon] @t)
    =/  p=path  (welp desk to-compile)
    ?.  .^(? %cu p)
      :-  %|
      %-  crip
      %+  weld  "did not find contract at {<to-compile>}"
      " in desk {<`@tas`(snag 1 desk)>}"
    [%& (parse-pile:conq p (trip .^(@t %cx p)))]
  ::
  ++  parse-imports  ::  second
    |=  raw=(list [face=term p=path])
    ^-  (each (list hoon) @t)
    =/  non-existent-libs=(list path)
      %+  murn  raw
      |=  [face=term p=path]
      =/  hp=path  (welp p /hoon)
      =/  tp=path  (welp desk hp)
      ?:  .^(? %cu tp)  ~  `hp
    ?^  non-existent-libs
      :-  %|
      %-  crip
      %+  weld  "did not find imports for {<to-compile>} at"
      " {<`(list path)`non-existent-libs>} in desk {<`@tas`(snag 1 desk)>}"
    :-  %&
    %+  turn  raw
    |=  [face=term p=path]
    =/  tp=path  (welp desk (welp p /hoon))
    ^-  hoon
    :+  %ktts  face
    +:(parse-pile:conq tp (trip .^(@t %cx tp)))
  ::
  ++  build-imports  ::  third
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
++  reformat-compiler-error
  |=  e=(list tank)
  ^-  @t
  %-  crip
  %-  zing
  %+  turn  (flop e)
  |=  =tank
  =/  raw-wall=wall  (wash [0 80] tank)
  ?~  raw-wall  (of-wall:format raw-wall)
  ?+    `@tas`(crip i.raw-wall)  (of-wall:format raw-wall)
      %mint-nice
    "mint-nice error: cannot nest `have` type within `need` type\0a"
  ::
      %mint-vain
    "mint-vain error: hoon is never reached in execution\0a"
  ::
      %mint-lost
    "mint-lost error: ?- conditional missing possible branch\0a"
  ::
      %nest-fail
    "nest-fail error: cannot nest `have` type within `need` type\0a"
  ::
      %fish-loop
    %+  weld  "fish-loop error:"
    " cannot match noun to a recursively-defined type\0a"
  ::
      %fuse-loop
    "fuse-loop error: type definition produces infinite loop\0a"
  ::
      ?(%'- need' %'- have')
    ?:  (gte compiler-error-num-lines.settings (lent raw-wall))
      (of-wall:format raw-wall)
    (weld i.raw-wall "\0a<long type elided>\0a")
  ::
      %'-find.$'
    %+  weld  "-find.$ error: face is used like a gate but"
    " is not a gate (try `^face`?)\0a"
  ::
      %rest-loop
    %+  weld  "rest-loop error: cannot cast arm return"
    " value to that arm"
  ==
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
++  show-projects
  |=  =projects:zig
  ^-  shown-projects:zig
  %-  ~(gas by *shown-projects:zig)
  %+  turn  ~(tap by projects)
  |=  [project-name=@t =project:zig]
  [project-name (show-project project)]
::
++  show-project
  |=  =project:zig
  ^-  shown-project:zig
  :*  dir=dir.project
      user-files=user-files.project
      to-compile=to-compile.project
      tests=(show-tests tests.project)
  ==
::
++  show-tests
  |=  =tests:zig
  ^-  shown-tests:zig
  %-  ~(gas by *shown-tests:zig)
  %+  turn  ~(tap by tests)
  |=  [test-id=@ux =test:zig]
  [test-id (show-test test test-id)]
::
++  show-test
  |=  [=test:zig test-id=@ux]
  ^-  shown-test:zig
  :*  name=name.test
      test-steps-file=test-steps-file.test
      test-imports=test-imports.test
      subject=?:(?=(%& -.subject.test) [%& *vase] subject.test)
      custom-step-definitions=(show-custom-step-definitions custom-step-definitions.test)
      steps=steps.test
      results=(show-test-results results.test)
      test-id=test-id
  ==
::
++  show-custom-step-definitions
  |=  =custom-step-definitions:zig
  ^-  custom-step-definitions:zig
  %-  ~(run by custom-step-definitions)
  |=  [p=path c=custom-step-compiled:zig]
  :-  p
  ?:  ?=(%& -.c)  [%& *vase]  c
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
  ?:  (lte test-result-num-characters.settings (met 3 res-text))
    '<elided>'
  res-text
::
++  show-state
  |=  state=vase
  ^-  @t
  =/  max-print-size=@ud
    ?:  =(*@ud state-num-characters.settings)  10.000
    state-num-characters.settings
  =/  noah-state=tape  (noah state)
  ?:  (lth max-print-size (lent noah-state))
    (crip noah-state)
  (get-formatted-error (sell state) ~)
::
++  show-state-update
  |=  =update:zig
  ^-  (unit shown-agent-state:zig)
  ?.  ?=(%pyro-agent-state -.update)  ~
  ?:  ?=(%| -.payload.update)         ~
  :-  ~
  :~  -.update
      [project-name source request-id]:update
      :^    %&
          (show-state agent-state.p.payload.update)
        wex.p.payload.update
      sup.p.payload.update
  ==
::
++  mule-slam-transform
  |=  [transform=vase payload=vase]
  ^-  (each vase @t)
  !.
  =/  slam-result
    (mule |.((slam transform payload)))
  ?:  ?=(%& -.slam-result)  slam-result
  [%| (reformat-compiler-error p.slam-result)]
::
++  mule-slap-subject
  |=  [subject=vase payload=hoon]
  ^-  (each vase @t)
  !.
  =/  compilation-result
    (mule |.((slap subject payload)))
  ?:  ?=(%& -.compilation-result)  compilation-result
  [%| (reformat-compiler-error p.compilation-result)]
::
++  compile-and-call-arm
  |=  [arm=@tas subject=vase payload=hoon]
  ^-  (each vase @t)
  =/  hoon-compilation-result
    (mule-slap-subject subject payload)
  ?:  ?=(%| -.hoon-compilation-result)
    hoon-compilation-result
  (mule-slap-subject p.hoon-compilation-result (ream arm))
::
++  make-recompile-custom-steps-cards
  |=  $:  project-name=@t
          test-id=@ux
          =custom-step-definitions:zig
          request-id=(unit @t)
      ==
  ^-  (list card)
  %+  turn  ~(tap by custom-step-definitions)
  |=  [tag=@tas [p=path *]]
  :^  %pass  /self-wire  %agent
  :^  [our dap]:bowl  %poke  %ziggurat-action
  !>  ^-  action:zig
  project-name^request-id^[%add-custom-step test-id tag p]
::
++  add-custom-step
  |=  $:  =test:zig
          project-name=@tas
          tag=@tas
          p=path
          request-id=(unit @t)
      ==
  ^-  [(list card) test:zig]
  =/  add-custom-error
    %~  add-custom-step  make-error-vase
    [[project-name %add-custom-step request-id] %error]
  =/  file-scry-path=path
    :-  (scot %p our.bowl)
    (weld /[project-name]/(scot %da now.bowl) p)
  ?.  .^(? %cu file-scry-path)
    :_  test
    :_  ~
    %-  update-vase-to-card
    %+  add-custom-error(level %warning)
      [`@ux`(sham test) tag]
    (crip "file {<`path`p>} not found")
  =/  file-cord=@t  .^(@t %cx file-scry-path)
  =/  [imports=(list [face=@tas =path]) payload=hoon]
    (parse-pile:conq file-scry-path (trip file-cord))
  ?:  ?=(%| -.subject.test)
    :_  test
    :_  ~
    %-  update-vase-to-card
    %+  add-custom-error  [`@ux`(sham test) tag]
    %^  cat  3  'subject must compile from imports before'
    ' adding custom step'
  =/  compilation-result=(each vase @t)
    (compile-and-call-arm '$' p.subject.test payload)
    :: %-  of-wain:format
    :: (slag (dec p.hair) (to-wain:format file-cord))
  ?:  ?=(%| -.compilation-result)
    :_  test
    :_  ~
    %-  update-vase-to-card
    %+  add-custom-error  [`@ux`(sham test) tag]
    %^  cat  3
      'custom-step compilation failed with error:\0a'
    p.compilation-result
  :-  ~
  %=  test
      custom-step-definitions
    %+  ~(put by custom-step-definitions.test)  tag
    [p compilation-result]
  ==
::
++  get-chain-state
  |=  [project-name=@t =configs:zig]
  ^-  (each (map @ux batch:ui) @t)
  =/  now=@ta   (scot %da now.bowl)
  =/  sequencers=(list [town-id=@ux who=@p])
    %~  tap  by
    (get-town-id-to-sequencer-map project-name configs)
  =|  town-states=(list [@ux batch:ui])
  |-
  ?~  sequencers
    [%& (~(gas by *(map @ux batch:ui)) town-states)]
  =*  town-id  town-id.i.sequencers
  =/  who=@ta   (scot %p who.i.sequencers)
  =/  town-ta=@ta  (scot %ux town-id)
  ?.  .^  ?
          %gx
          :+  (scot %p our.bowl)  %pyro
          /[now]/i/[who]/gu/[who]/indexer/[now]/noun
      ==
    :-  %|
    %-  crip
    "%pyro ship {<who.i.sequencers>} not running %indexer"
  =/  batch-order=update:ui
    .^  update:ui
        %gx
        %+  weld
          /(scot %p our.bowl)/pyro/[now]/[who]/indexer
        /batch-order/[town-ta]/noun/noun
    ==
  ?~  batch-order              $(sequencers t.sequencers)
  ?.  ?=(%batch-order -.batch-order)
    $(sequencers t.sequencers)
  ?~  batch-order.batch-order  $(sequencers t.sequencers)
  =*  newest-batch  i.batch-order.batch-order
  =/  batch-update=update:ui
    .^  update:ui
        %gx
        ;:  weld
            /(scot %p our.bowl)/pyro/[now]/[who]
            /indexer/newest/batch/[town-ta]
            /(scot %ux newest-batch)/noun/noun
    ==  ==
  ?~  batch-update               $(sequencers t.sequencers)
  ?.  ?=(%batch -.batch-update)  $(sequencers t.sequencers)
  ?~  batch=(~(get by batches.batch-update) newest-batch)
    $(sequencers t.sequencers)
  %=  $
      sequencers  t.sequencers
      town-states
    :_  town-states
    [town-id (snip-batch-code batch.u.batch)]
  ==
::
++  snip-batch-code
  |=  =batch:ui
  |^  ^-  batch:ui
  :+  transactions.batch
    snip-chain-code
  hall.batch
  ::
  ++  snip-chain-code
    ^-  chain:eng
    =*  chain  chain.batch
    :_  q.chain
    %+  gas:big:seq  *_p.chain
    %+  turn  ~(tap by p.chain)
    |=  [id=@ux @ =item:smart]
    ?:  ?=(%& -.item)  [id item]
    =/  max-print-size=@ud
      ?:  =(*@ud code-max-characters.settings)  200
      code-max-characters.settings
    =/  noah-code-size=@ud  (lent (noah !>(code.p.item)))
    ?:  (gth max-print-size noah-code-size)  [id item]
    [id item(code.p [0 0])]
  --
::  scry %ca or fetch from local cache
::
++  scry-or-cache-ca
  |=  [project-desk=@tas p=path =ca-scry-cache:zig]
  |^  ^-  (unit [vase ca-scry-cache:zig])
  =/  scry-path=path
    :-  (scot %p our.bowl)
    (weld /[project-desk]/(scot %da now.bowl) p)
  ?~  cache=(~(get by ca-scry-cache) [project-desk p])
    scry-and-cache-ca
  ?.  =(p.u.cache .^(@ %cz scry-path))  scry-and-cache-ca
  `[q.u.cache ca-scry-cache]
  ::
  ++  scry-and-cache-ca
    ^-  (unit [vase ca-scry-cache:zig])
    =/  scry-result
      %-  mule
      |.
      =/  scry-path=path
        :-  (scot %p our.bowl)
        (weld /[project-desk]/(scot %da now.bowl) p)
      =/  scry-vase=vase  .^(vase %ca scry-path)
      :-  scry-vase
      %+  ~(put by ca-scry-cache)  [project-desk p]
      [`@ux`.^(@ %cz scry-path) scry-vase]
    ?:  ?=(%& -.scry-result)  `p.scry-result
    ~&  %ziggurat^%scry-and-cache-ca-fail
    ~
  --
::
++  town-id-to-sequencer-host
  |=  [project-name=@t town-id=@ux =configs:zig]
  ^-  (unit @p)
  %.  town-id
  %~  get  by
  (get-town-id-to-sequencer-map project-name configs)
::
++  get-town-id-to-sequencer-map
  |=  [project-name=@t =configs:zig]
  ^-  (map @ux @p)
  =/  town-id-to-sequencer=(map @ux @p)
    %-  ~(gas by *(map @ux @p))
    %+  murn  ~(tap bi:mip configs)
    |=  [pn=@t [who=@p what=@tas] item=@]
    ?.  =(project-name pn)   ~
    ?.  ?=(%sequencer what)  ~
    `[`@ux`item who]
  ?.  &(?=(~ town-id-to-sequencer) !=('global' project-name))
    town-id-to-sequencer
  (get-town-id-to-sequencer-map 'global' configs)
::
++  scry-virtualship-desks
  |=  [virtualship=@p now-da=@da]
  ^-  (set @tas)
  =/  now=@ta  (scot %da now-da)
  =/  who=@ta  (scot %p virtualship)
  .^  (set @tas)
      %gx
      :-  (scot %p our.bowl)
      /pyro/[now]/i/[who]/cd/[who]/base/[now]/noun
  ==
::
++  virtualship-desk-exists
  |=  [virtualship=@p now=@da desk=@tas]
  ^-  ?
  (~(has in (scry-virtualship-desks virtualship now)) desk)
::
++  virtualship-is-running-app
  |=  [virtualship=@p app=@tas now-da=@da]
  ^-  ?
  =/  now=@ta  (scot %da now-da)
  =/  who=@ta  (scot %p virtualship)
  .^  ?
      %gx
      :-  (scot %p our.bowl)
      /pyro/[now]/i/[who]/gu/[who]/[app]/[now]/noun
  ==
::
++  sync-all-desks-cards
  |=  =sync-desk-to-vship:zig
  ^-  (list card)
  %-  zing
  %+  turn  ~(tap by sync-desk-to-vship)
  |=  [desk=@tas whos=(set @p)]
  %+  turn  ~(tap in whos)
  |=(who=@p (sync-desk-to-virtualship-card who desk))
::
++  sync-desk-to-virtualship-card
  |=  [who=@p project-name=@tas]
  ^-  card
  %+  %~  poke-our  pass:io
      /sync/(scot %da now.bowl)/[project-name]/(scot %p who)
    %pyro
  (sync-desk-to-virtualship-cage who project-name)
::
++  sync-desk-to-virtualship-cage
  |=  [who=@p project-name=@tas]
  ^-  cage
  :-  %pyro-events
  !>  ^-  (list pyro-event:pyro)
  :_  ~
  :+  who  /c/commit/(scot %p who)
  (park:pyro-lib our.bowl project-name %da now.bowl)
::
++  send-pyro-dojo-card
  |=  [who=@p command=tape]
  ^-  card
  %+  %~  poke-our  pass:io
      /dojo/(scot %p who)/(scot %ux `@ux`(jam command))
    %pyro
  (send-pyro-dojo-cage who command)
::
++  send-pyro-dojo-cage
  |=  [who=@p command=tape]
  ^-  cage
  :-  %pyro-events
  !>  ^-  (list pyro-event:pyro)
  (dojo-events:pyro-lib who command)
::
++  make-cis-running
  |=  [ships=(list @p) project-name=@t]
  ^-  (map @p [@t ?])
  %-  ~(gas by *(map @p [@t ?]))
  %+  turn  ships
  |=  who=@p
  :-  who
  :_  %.n
  (rap 3 'setup-' project-name '-' (scot %p who) ~)
::
++  get-final-app-to-install
  |=  [desk=@tas now=@da]
  ^-  @tas
  =/  bill-path=path
    :-  (scot %p our.bowl)
    /[desk]/(scot %da now)/desk/bill
  (rear .^((list @tas) %cx bill-path))
::
++  read-test-file
  |=  [project-name=@tas p=path state=inflated-state-0:zig]
  ^-  $:  (each (trel (list [@tas path]) vase test-steps:zig) @t)
          inflated-state-0:zig
      ==
  =/  file-scry-path=path
    :-  (scot %p our.bowl)
    (weld /[project-name]/(scot %da now.bowl) p)
  =/  file-cord=@t  .^(@t %cx file-scry-path)
  =/  [imports=(list [face=@tas =path]) payload=hoon]
    (parse-pile:conq file-scry-path (trip file-cord))
  =^  subject=(each vase @t)  state
    (compile-test-imports project-name imports state)
  :_  state
  ?:  ?=(%| -.subject)
    :-  %|
    %^  cat  3  'compilation of test-imports failed:\0a'
    p.subject
  =/  test-steps-compilation-result=(each vase @t)
    (compile-and-call-arm '$' p.subject payload)
  ?:  ?=(%| -.test-steps-compilation-result)
    :-  %|
    %-  crip
    ;:  weld
        "test-steps compilation failed for"
        " {<`path`p>} with error:\0a"
        (trip p.test-steps-compilation-result)
    ==
  :^  %&  imports  p.subject
  !<(test-steps:zig p.test-steps-compilation-result)
::
++  cis-thread
  |=  $:  w=wire
          who=@p
          desk=@tas
          install=?
          start-apps=(list @tas)
          =status:zig
      ==
  =/  commit-poll-duration=@dr   ~s1
  =/  install-poll-duration=@dr  ~s1
  =/  start-poll-duration=@dr    (div ~s1 10)
  |^  ^-  card
  %-  ~(arvo pass:io w)
  :^  %k  %lard  q.byk.bowl
  =/  m  (strand ,vase)
  ^-  form:m
  ;<  ~  bind:m
    %+  poke-our:strandio  %pyro
    (sync-desk-to-virtualship-cage who desk)
  ;<  ~  bind:m  block-on-commit
  ?.  install  finish
  ;<  ~  bind:m
    %+  poke-our:strandio  %pyro
    (send-pyro-dojo-cage who "|install our {<desk>}")
  ;<  ~  bind:m  block-on-install
  ;<  ~  bind:m  do-start-apps
  finish
  ::
  ++  block-on-commit
    =/  m  (strand ,~)
    ^-  form:m
    |-
    ;<  ~  bind:m  (sleep:strandio commit-poll-duration)
    ;<  now=@da  bind:m  get-time:strandio
    ?.  (virtualship-desk-exists who now desk)  $
    (pure:m ~)
  ::
  ++  block-on-install
    =/  m  (strand ,~)
    ^-  form:m
    |-
    ;<  ~  bind:m  (sleep:strandio install-poll-duration)
    ;<  now=@da  bind:m  get-time:strandio
    =/  app=@tas  (get-final-app-to-install desk now)
    ::  if the final app is installed -> install done
    ?.  (virtualship-is-running-app who app now)  $
    (pure:m ~)
  ::
  ++  do-start-apps
    =/  m  (strand ,~)
    ^-  form:m
    |-
    ?~  start-apps  (pure:m ~)
    =*  next-app  i.start-apps
    ;<  ~  bind:m
      %+  poke-our:strandio  %pyro
      %+  send-pyro-dojo-cage  who
      "|start {<`@tas`desk>} {<`@tas`next-app>}"
    ;<  ~  bind:m  (block-on-start next-app)
    $(start-apps t.start-apps)
  ::
  ++  block-on-start
    |=  next-app=@tas
    =/  m  (strand ,~)
    ^-  form:m
    |-
    ;<  ~  bind:m  (sleep:strandio start-poll-duration)
    ;<  now=@da  bind:m  get-time:strandio
    ?.  (virtualship-is-running-app who next-app now)  $
    (pure:m ~)
  ::
  ++  finish
    =/  m  (strand ,vase)
    ^-  form:m
    ;<  =status:zig  bind:m  get-status
    ?:  ?=(%commit-install-starting -.status)
      =.  cis-running.status
        %+  ~(jab by cis-running.status)  who
        |=([cis-running=@t is-done=?] [cis-running %.y])
      (pure:m !>(`status:zig`status))
    ?>  ?=(%changing-project-links -.status)
    =.  project-cis-running.status
      %+  ~(put by project-cis-running.status)  desk
      %+  %~  jab  by
          (~(got by project-cis-running.status) desk)
        who
      |=([cis-running=@t is-done=?] [cis-running %.y])
    (pure:m !>(`status:zig`status))
  ::
  ++  get-status
    =/  m  (strand ,status:zig)
    ^-  form:m
    ;<  =update:zig  bind:m
      (scry:strandio update:zig /gx/ziggurat/status/noun)
    ?>  &(?=(%status -.update) ?=(%& -.payload.update))  ::  TODO: better error handling?
    (pure:m p.payload.update)
  --
::
++  make-status-card
  |=  [=status:zig desk=@tas]
  ^-  card
  %-  update-vase-to-card
  %.  status
  %~  status  make-update-vase
  [desk %cis ~]
::
++  make-done-cards
  |=  [=status:zig desk=@tas]
  |^  ^-  (list card)
  :^    (make-status-card status desk)
      make-watch-cis-setup-done-card
    make-run-card
  ~
  ::
  ++  make-run-card
    ^-  card
    %-  ~(poke-self pass:io /self-wire)
    :-  %ziggurat-action
    !>(`action:zig`desk^~^[%run-queue ~])
  ::
  ++  make-watch-cis-setup-done-card
    ^-  card
    %.  [%ziggurat /project]
    ~(watch-our pass:io /cis-setup-done/[desk])
  --
::
++  loud-ream
  |=  [txt=@ error-path=path]
  |^  ^-  hoon
  (rash txt loud-vest)
  ::
  ++  loud-vest
    |=  tub=nail
    ^-  (like hoon)
    %.  tub
    %-  full
    (ifix [gay gay] tall:(vang %.y error-path))
  --
::
++  compile-test-imports
  |=  $:  project-desk=@tas
          imports=(list [face=@tas =path])
          state=inflated-state-0:zig
      ==
  ^-  [(each vase @t) inflated-state-0:zig]
  =^  subject=(each vase @t)  state
    (compile-imports project-desk imports state)
  :_  state
  ?:  ?=(%| -.subject)  subject
  =/  initial-test-globals=vase
    !>  ^-  test-globals:zig
    :^  our.bowl  now.bowl  *test-results:zig
    [project-desk configs:state]
  :-  %&
  %+  slop
    %=  initial-test-globals
      p  [%face %test-globals p.initial-test-globals]
    ==
  p.subject
::
++  compile-imports
  |=  $:  project-desk=@tas
          imports=(list [face=@tas =path])
          state=inflated-state-0:zig
      ==
  ^-  [(each vase @t) inflated-state-0:zig]
  =/  compilation-result
    %-  mule
    |.
    =/  [subject=vase c=ca-scry-cache:zig]
      %+  roll  imports
      |:  [[face=`@tas`%$ sur=`path`/] [subject=`vase`!>(..zuse) ca-scry-cache=ca-scry-cache:state]]
      ?:  =(%test-globals face)
        !!  ::  TODO: do better  [[%| '%test-globals face is reserved'] state]
      =^  sur-hoon=vase  ca-scry-cache
        %-  need  ::  TODO: handle error
        %^  scry-or-cache-ca  project-desk
        (snoc sur %hoon)  ca-scry-cache
      :_  ca-scry-cache
      %-  slop  :_  subject
      sur-hoon(p [%face face p.sur-hoon])
    [subject c]
  ?:  ?=(%& -.compilation-result)
    :-  [%& -.p.compilation-result]
    state(ca-scry-cache +.p.compilation-result)
  :_  state
  :-  %|
  %-  crip
  %+  roll  p.compilation-result
  |=  [in=tank out=tape]
  :(weld ~(ram re in) "\0a" out)
::
++  build-default-configuration
  |=  =config:zig
  ^-  configuration-file-output:zig
  =*  ships  default-ships
  :*  config
      ships
      %.y
      ~
      ~
      ~
      [%zig /sur/zig/ziggurat]~
  ==
::
++  load-configuration-file
  !.
  |=  [=update-info:zig state=inflated-state-0:zig]
  ^-  [(list card) (unit configuration-file-output:zig) inflated-state-0:zig]
  =*  project-name  project-name.update-info
  =/  new-project-error
    %~  new-project  make-error-vase
    [update-info(source %load-configuration-file) %error]
  =/  config-file-path=path
    %+  weld  /(scot %p our.bowl)/[project-name]
    /(scot %da now.bowl)/zig/configs/[project-name]/hoon
  |^
  ?.  .^(? %cu config-file-path)
    =/  =configuration-file-output:zig
      (build-default-configuration ~)
    =^  cards=(list card)  state
      (build-cards-and-state configuration-file-output)
    [cards `configuration-file-output state]
  =/  result  get-configuration-from-file
  ?:  ?=(%| -.result)  [-.p.result ~ +.p.result]
  =*  configuration-file-output  p.result
  =^  cards=(list card)  state
    (build-cards-and-state configuration-file-output)
  [cards `configuration-file-output state]
  ::
  ++  get-configuration-from-file
    |^  ^-  (each configuration-file-output:zig [(list card) inflated-state-0:zig])
    =/  file-cord=@t  .^(@t %cx config-file-path)
    =/  [imports=(list [face=@tas =path]) payload=hoon]
      (parse-pile:conq config-file-path (trip file-cord))
    =^  subject=(each vase @t)  state
      (compile-test-imports project-name imports state)
    ?:  ?=(%| -.subject)
      %+  make-error  p.subject
      'config imports compilation failed with error:\0a'
    =/  config-core
      (mule-slap-subject p.subject payload)
    ?:  ?=(%| -.config-core)
      %+  make-error  p.config-core
      'config compilation failed with:\0a'
    ::
    =/  config-result
      (mule-slap-subject p.config-core (ream %make-config))
    ?:  ?=(%| -.config-result)
      %+  make-error  p.config-result
      'failed to call +make-config arm:\0a'
    ::
    =/  virtualships-to-sync-result
      %+  mule-slap-subject  p.config-core
      (ream %make-virtualships-to-sync)
    ?:  ?=(%| -.virtualships-to-sync-result)
      %+  make-error  p.virtualships-to-sync-result
      'failed to call +make-virtualships-to-sync arm:\0a'
    ::
    =/  install-result
      (mule-slap-subject p.config-core (ream %make-install))
    ?:  ?=(%| -.install-result)
      %+  make-error  p.install-result
      'failed to call +make-install arm:\0a'
    ::
    =/  start-apps-result
      %+  mule-slap-subject  p.config-core
      (ream %make-start-apps)
    ?:  ?=(%| -.start-apps-result)
      %+  make-error  p.start-apps-result
      'failed to call +make-start-apps arm:\0a'
    ::
    =/  state-views-result
      %+  mule-slap-subject  p.config-core
      (ream %make-state-views)
    ?:  ?=(%| -.state-views-result)
      %+  make-error  p.state-views-result
      'failed to call +make-state-views arm:\0a'
    ::
    =/  setup-result
      (mule-slap-subject p.config-core (ream %make-setup))
    ?:  ?=(%| -.setup-result)
      %+  make-error  p.setup-result
      'failed to call +make-setup arm:\0a'
    ::
    :*  %&
        !<(config:zig p.config-result)
        !<((list @p) p.virtualships-to-sync-result)
        !<(? p.install-result)
        !<((list @tas) p.start-apps-result)
        !<((list [@p (unit @tas) path]) p.state-views-result)
        !<((map @p test-steps:zig) p.setup-result)
        imports
    ==
    ::
    ++  make-error
      |=  [error=@t message=@t]
      ^-  (each configuration-file-output:zig [(list card) inflated-state-0:zig])
      :-  %|
      :_  state
      :_  ~
      %-  update-vase-to-card
      (new-project-error (cat 3 message error))
    --
  ::
  ++  build-cards-and-state
    |=  $:  =config:zig
            virtualships-to-sync=(list @p)
            install=?
            start-apps=(list @tas)
            state-views=(list [who=@p app=(unit @tas) file=path])
            setups=(map @p test-steps:zig)
            imports=(list [@tas path])
        ==
    ^-  [(list card) inflated-state-0:zig]
    =/  setups-not-run=(set @p)
      %-  ~(dif in ~(key by setups))
      (~(gas in *(set @p)) virtualships-to-sync)
    =/  cards=(list card)
      ?:  =(0 ~(wyt in setups-not-run))  ~
      =/  message=tape
        ;:  weld
          "+make-setup will only run for virtualships that"
          " are set to sync. The following will not be run:"
          " {<setups-not-run>}. To have them run, add to"
          " +make-virtualships-to-sync in /zig/configs"
          "/{<project-name>} and run %new-project again"
        ==
      :_  ~
      %-  update-vase-to-card
      (new-project-error(level %warning) (crip message))
    ::  use new-status rather than modifying status.state
    ::   in place to satisfy compiler
    =/  new-status=status:zig
      :-  %commit-install-starting
      (make-cis-running virtualships-to-sync project-name)
    ?>  ?=(%commit-install-starting -.new-status)
    =*  cis-running  cis-running.new-status
    =.  cards
      %+  weld  cards
      %+  murn  virtualships-to-sync
      |=  who=@p
      ?~  setup=(~(get by setups) who)  ~
      =/  [cis-name=@t ?]  (~(got by cis-running) who)
      :-  ~
      %-  ~(poke-self pass:io /self-wire)
      :-  %ziggurat-action
      !>  ^-  action:zig
      :*  project-name
          `cis-name
          %add-and-queue-test
          `cis-name
          (~(gas by *test-imports:zig) imports)
          u.setup
      ==
    =.  cards
      |-
      ?~  virtualships-to-sync  cards
      =*  who   i.virtualships-to-sync
      =*  desk  project-name
      =/  cis-cards=(list card)
        :_  ~
        %+  cis-thread  /cis-done/(scot %p who)/[desk]
        [who desk install start-apps new-status]
      %=  $
          virtualships-to-sync  t.virtualships-to-sync
          cards                 (weld cards cis-cards)
      ==
    =.  cards
      :_  cards
      %-  fact:io  :_  ~[/project]
      :-  %json
      !>  ^-  json
      %-  update:enjs
      !<  update:zig
      %.  state-views
      %~  state-views  make-update-vase
      [project-name %load-configuration-file ~]
    :-  :_  cards
        %-  update-vase-to-card
        %.  new-status
        %~  status  make-update-vase
        [project-name %load-configuration-file ~]
    =.  projects.state
      %+  ~(put by projects.state)  project-name
      =/  =project:zig
        (~(gut by projects.state) project-name *project:zig)
      project(pyro-ships virtualships-to-sync)
    =.  state
      %^  change-state-linked-projects
        focused-project.state  state
      |=  =project:zig
      project(saved-test-queue test-queue.state)
    %=  state
        test-queue   ~
        status       new-status
    ::
        sync-desk-to-vship
      %-  ~(gas ju sync-desk-to-vship.state)
      %+  turn  virtualships-to-sync
      |=(who=@p [project-name who])
    ::
        configs
      %+  ~(put by configs.state)  project-name
      %.  ~(tap by config)
      ~(gas by (~(gut by configs.state) project-name ~))
    ==
  --
::
++  change-state-linked-projects
  |=  $:  project-name=@t
          state=inflated-state-0:zig
          transition=$-(project:zig project:zig)
      ==
  ^-  _state
  ::  linked-projects is, at a minimum, project-name
  =/  linked-projects=(list @t)
    %~  tap  in
    %.  project-name
    ~(put in (~(get ju linked-projects.state) project-name))
  |-
  ?~  linked-projects  state
  ?~  next=(~(get by projects.state) i.linked-projects)
    $(linked-projects t.linked-projects)
  =.  projects.state
    %+  ~(put by projects.state)  i.linked-projects
    (transition u.next)
  $(linked-projects t.linked-projects, state state)
::
++  add-test-error-to-edit-test
  |=  add-test-card=card
  ^-  card
  ?.  ?=(%give -.add-test-card)    add-test-card
  ?.  ?=(%fact -.p.add-test-card)  add-test-card
  %=  add-test-card
      cage.p
    =*  cage  cage.p.add-test-card
    :-  p.cage
    !>  ^-  update:zig
    =+  !<(=update:zig q.cage)
    ?~  update  ~
    ?.  ?=(%add-test -.update)  update
    :-  %edit-test  +.update
  ==
::
++  uni-configs
  |=  [olds=configs:zig news=configs:zig]
  ^-  configs:zig
  %-  ~(gas by *configs:zig)
  %+  turn  ~(tap by olds)
  |=  [project-name=@t old=config:zig]
  :-  project-name
  ?~  new=(~(get by news) project-name)  old
  (~(uni by old) u.new)
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
      [/app/[name]/hoon %ins hoon+!>((make-template /app/[name]/hoon))]
  ==
::
++  make-template
  |=  file-path=path
  |^  ^-  @t
  ?~  file-path          ''
  ?+  `@tas`i.file-path  ''
    %app    app
    %con    con
    %gen    gen
    %lib    lib
    %mar    mar
    %sur    sur
    %ted    ted
    %tests  tests
    %zig    zig
  ==
  ::
  ++  app
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
  ++  con
    |^  ^-  @t
    ?~  file-path      ''
    ?~  t.file-path    ''
    ?.(?=(%lib `@tas`i.t.file-path) con con-lib)
    ::
    ++  con
      ^-  @t
      '''
      /+  *zig-sys-smart
      /=  my-con-lib  /con/lib/my-lib  ::  your lib here
      |_  =context
      ++  write
        |=  act=action:sur
        ^-  ((list call) diff)
        ?-    -.act
            %action-0  ::  your action tags here
            ::  ...
        ==
      ::
      ++  read
        |_  =pith
        ++  json
          ~
        ++  noun
          ~
        --
      --
      '''
    ::
    ++  con-lib
      ^-  @t
      '''
      /+  *zig-sys-smart
      |%
      ++  sur
        |%
        +$  action
          %$  [%action-0 my-arg-0=@ud]  ::  your actions here
              ::  ...
          --
        ::
        +$  my-type-0  ::  your types here
          ~
        --
      ++  lib
        |%
        ++  my-helper-0
          ~  ::  do stuff
        --
      --
      '''
    --
  ::
  ++  gen
    ^-  @t
    '''
    :-  %say
    |=  [[now=@da eny=@uvJ bec=beak] ~[addend=@ud] ~[base=(unit @ud)]]
    ?~  base  (add 2 addend)
    (add u.base addend)
    '''
  ::
  ++  lib
    ^-  @t
    '''
    |%
    ++  my-arm
      ~  ::  do stuff
    --
    '''
  ::
  ++  mar
    ^-  @t
    '''
    ::  template based on dev-suite/mar/zig/ziggurat.hoon
    /-  zig=zig-ziggurat
    /+  zig-lib=zig-ziggurat
    |_  =action:zig
    ++  grab
      |%
      ++  noun  action:zig
      ++  json  uber-action:dejs:zig-lib
      --
    ::
    ++  grow
      |%
      ++  noun  action
      --
    ++  grad  %noun
    '''
  ::
  ++  sur
    ^-  @t
    '''
    |%
    +$  my-type
      ~  ::  define type
    --
    '''
  ::
  ++  ted
    ^-  @t
    '''
    /-  spider
    /+  strandio
    ::
    =*  strand  strand:spider
    ::
    =/  m  (strand ,vase)
    |^  ted
    ::
    +$  arg-mold
      $:  thread-arg-0=@ud  ::  your args here
          :: thread-arg-1=@ux
      ==
    ::
    ++  helper-core  ::  your helper cores here
      ~  ::  do stuff
    ::
    ::  main
    ::
    ++  ted
      ^-  thread:spider
      |=  args-vase=vase
      ^-  form:m
      =/  args  !<((unit arg-mold) args-vase)
      ?~  args
        ~&  >>>  "Usage:"
        ~&  >>>  "-<thread-name> <thread-arg-0> <thread-arg-1> ..."
        (pure:m !>(~))
      ::  do stuff
      (pure:m !>(~))
    --
    '''
  ::
  ++  tests
    ^-  @t
    '''
    ::  see https://medium.com/dcspark/writing-robust-hoon-a-guide-to-urbit-unit-testing-82b2631fe20a
    |%
    ++  my-test
      ~  ::  do test
    --
    '''
  ::
  ++  zig
    |^  ^-  @t
    ?~  file-path               ''
    ?~  t.file-path             ''
    ?+  `@tas`i.t.file-path     ''
      %configs                  configs
      %custom-step-definitions  custom-step-definitions
      %test-steps               test-steps
    ==
    ::
    ++  configs
      ^-  @t
      '''
      /=  zig  /sur/zig/ziggurat
      ::
      /=  mip  /lib/mip
      ::
      |%
      ++  make-config
        ^-  config:zig
        *config:zig
      ::
      ++  make-virtualships-to-sync
        ^-  (list @p)
        ~[~nec ~bud ~wes]
      ::
      ++  make-install
        ^-  ?
        ^.y
      ::
      ++  make-start-apps
        ^-  (list @tas)
        ~
      ::
      ++  make-setup
        |^  ^-  (map @p test-steps:zig)
        %-  ~(gas by *(map @p test-steps:zig))
        :^    [~nec make-setup-nec]
            [~bud make-setup-bud]
          [~wes make-setup-wes]
        ~
        ::
        ++  make-setup-nec
          ^-  test-steps:zig
          =/  who=@p  ~nec
          ~
        ::
        ++  make-setup-bud
          ^-  test-steps:zig
          =/  who=@p  ~bud
          ~
        ::
        ++  make-setup-wes
          ^-  test-steps:zig
          =/  who=@p  ~wes
          ~
        --
      --
      '''
    ::
    ++  custom-step-definitions
      ^-  @t
      .^  @t
          %cx
          :-  (scot %p our.bowl)
          %+  weld  /[q.byk.bowl]/(scot %da now.bowl)/zig
          /custom-step-definitions/deploy-contract/hoon
      ==
    ::
    ++  test-steps
      ^-  @t
      .^  @t
          %cx
          %+  weld  /(scot %p our.bowl)/[q.byk.bowl]
          /(scot %da now.bowl)/zig/test-steps/send-nec/hoon
      ==
    --
  --
::
++  update-vase-to-card
  |=  v=vase
  ^-  card
  (fact:io [%ziggurat-update v] ~[/project])
::
++  make-update-vase
  |_  =update-info:zig
  ++  project-names
    |=  project-names=(set @t)
    ^-  vase
    !>  ^-  update:zig
    [%project-names update-info [%& ~] project-names]
  ::
  ++  projects
    |=  =projects:zig
    ^-  vase
    !>  ^-  update:zig
    [%projects update-info [%& ~] (show-projects projects)]
  ::
  ++  project
    |=  =project:zig
    ^-  vase
    !>  ^-  update:zig
    [%project update-info [%& ~] (show-project project)]
  ::
  ++  new-project
    |=  =sync-desk-to-vship:zig
    ^-  vase
    !>  ^-  update:zig
    [%new-project update-info [%& sync-desk-to-vship] ~]
  ::
  ++  add-config
    |=  [who=@p what=@tas item=@]
    ^-  vase
    !>  ^-  update:zig
    [%add-config update-info [%& who what item] ~]
  ::
  ++  delete-config
    |=  [who=@p what=@tas]
    ^-  vase
    !>  ^-  update:zig
    [%delete-config update-info [%& who what] ~]
  ::
  ++  add-test
    |=  [=test:zig test-id=@ux]
    ^-  vase
    !>  ^-  update:zig
    :^  %add-test  update-info
    [%& (show-test test test-id)]  test-id
  ::
  ++  compile-contract
    ^-  vase
    !>  ^-  update:zig
    [%compile-contract update-info [%& ~] ~]
  ::
  ++  edit-test
    |=  [=test:zig test-id=@ux]
    ^-  vase
    !>  ^-  update:zig
    :^  %edit-test  update-info
    [%& (show-test test test-id)]  test-id
  ::
  ++  delete-test
    |=  test-id=@ux
    ^-  vase
    !>  ^-  update:zig
    [%delete-test update-info [%& ~] test-id]
  ::
  ++  run-queue
    ^-  vase
    !>  ^-  update:zig
    [%run-queue update-info [%& ~] ~]
  ::
  ++  add-custom-step
    |=  [test-id=@ux tag=@tas]
    ^-  vase
    !>  ^-  update:zig
    [%add-custom-step update-info [%& ~] test-id tag]
  ::
  ++  delete-custom-step
    |=  [test-id=@ux tag=@tas]
    ^-  vase
    !>  ^-  update:zig
    [%delete-custom-step update-info [%& ~] test-id tag]
  ::
  ++  add-user-file
    |=  file=path
    ^-  vase
    !>  ^-  update:zig
    [%add-user-file update-info [%& ~] file]
  ::
  ++  delete-user-file
    |=  file=path
    ^-  vase
    !>  ^-  update:zig
    [%delete-user-file update-info [%& ~] file]
  ::
  ++  custom-step-compiled
    |=  [test-id=@ux tag=@tas]
    ^-  vase
    !>  ^-  update:zig
    [%custom-step-compiled update-info [%& ~] test-id tag]
  ::
  ++  test-results
    |=  [=shown-test-results:zig test-id=@ux thread-id=@t =test-steps:zig]
    ^-  vase
    !>  ^-  update:zig
    :^  %test-results  update-info  [%& shown-test-results]
    [test-id thread-id test-steps]
  ::
  ++  dir
    |=  dir=(list path)
    ^-  vase
    !>  ^-  update:zig
    [%dir update-info [%& dir] ~]
  ::
  ++  poke
    ^-  vase
    !>  ^-  update:zig
    [%poke update-info [%& ~] ~]
  ::
  ++  test-queue
    |=  queue=(qeu [@t @ux])
    ^-  vase
    !>  ^-  update:zig
    [%test-queue update-info [%& queue] ~]
  ::
  ++  pyro-agent-state
    |=  [agent-state=vase wex=boat:gall sup=bitt:gall]
    ^-  vase
    !>  ^-  update:zig
    :^  %pyro-agent-state  update-info
    [%& agent-state wex sup]  ~
  ::
  ++  shown-pyro-agent-state
    |=  [agent-state=@t wex=boat:gall sup=bitt:gall]
    ^-  vase
    !>  ^-  update:zig
    :^  %shown-pyro-agent-state  update-info
    [%& agent-state wex sup]  ~
  ::
  ++  pyro-chain-state
    |=  state=(map @ux batch:ui)
    ^-  vase
    !>  ^-  update:zig
    [%pyro-chain-state update-info [%& state] ~]
  ::
  ++  shown-pyro-chain-state
    |=  chain-state=@t
    ^-  vase
    !>  ^-  update:zig
    :^  %shown-pyro-chain-state  update-info
    [%& chain-state]  ~
  ::
  ++  sync-desk-to-vship
    |=  =sync-desk-to-vship:zig
    ^-  vase
    !>  ^-  update:zig
    :^  %sync-desk-to-vship  update-info
    [%& sync-desk-to-vship]  ~
  ::
  ++  cis-setup-done
    ^-  vase
    !>  ^-  update:zig
    [%cis-setup-done update-info [%& ~] ~]
  ::
  ++  status
    |=  =status:zig
    ^-  vase
    !>  ^-  update:zig
    [%status update-info [%& status] ~]
  ::
  ++  focused-linked
    |=  data=focused-linked-data:zig
    ^-  vase
    !>  ^-  update:zig
    [%focused-linked update-info [%& data] ~]
  ::
  ++  settings
    |=  =settings:zig
    ^-  vase
    !>  ^-  update:zig
    [%settings update-info [%& settings] ~]
  ::
  ++  state-views
    |=  state-views=(list [@p (unit @tas) path])
    ^-  vase
    !>  ^-  update:zig
    [%state-views update-info [%& state-views] ~]
  --
::
++  make-error-vase
  |_  [=update-info:zig level=error-level:zig]
  ::
  ::  more arms at
  ::   https://github.com/uqbar-dao/dev-suite/blob/313baeb2532fecb35502239aa2bcea3255bd7232/lib/zig/ziggurat.hoon#L1397-L1555
  ::
  ++  new-project
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%new-project update-info [%| level message] ~]
  ::
  ++  add-test
    |=  [test-id=@ux message=@t]
    ^-  vase
    !>  ^-  update:zig
    [%add-test update-info [%| level message] test-id]
  ::
  ++  compile-contract
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%compile-contract update-info [%| level message] ~]
  ::
  ++  run-queue
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%run-queue update-info [%| level message] ~]
  ::
  ++  add-custom-step
    |=  [[test-id=@ux tag=@tas] message=@t]
    ^-  vase
    !>  ^-  update:zig
    [%add-custom-step update-info [%| level message] test-id tag]
  ::
  ++  custom-step-compiled
    |=  [[test-id=@ux tag=@tas] message=@t]
    ^-  vase
    !>  ^-  update:zig
    [%custom-step-compiled update-info [%| level message] test-id tag]
  ::
  ++  test-results
    |=  [[test-id=@ux thread-id=@t =test-steps:zig] message=@t]
    ^-  vase
    !>  ^-  update:zig
    :^  %test-results  update-info  [%| level message]
    [test-id thread-id test-steps]
  ::
  ++  poke
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%poke update-info [%| level message] ~]
  ::
  ++  sync-desk-to-vship
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%sync-desk-to-vship update-info [%| level message] ~]
  ::
  ++  pyro-agent-state
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%pyro-agent-state update-info [%| level message] ~]
  ::
  ++  pyro-chain-state
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%pyro-agent-state update-info [%| level message] ~]
  ::
  ++  save-file
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%save-file update-info [%| level message] ~]
  --
::
::  json
::
++  enjs
  =,  enjs:format
  |%
  ++  update
    |=  =update:zig
    ^-  json
    ?~  update  ~
    =/  update-info=(list [@t json])
      :-  [%type %s -.update]
      :^    ['project_name' %s project-name.update]
          ['source' %s source.update]
        :-  'request_id'
        ?~(request-id.update ~ [%s u.request-id.update])
      ~
    %-  pairs
    %+  weld  update-info
    ?:  ?=(%| -.payload.update)  (error p.payload.update)
    ?-    -.update
        %project-names
      :+  ['project_names' (set-cords project-names.update)]
        [%data ~]
      ~
    ::
        %projects
      :+  ['projects' (shown-projects projects.update)]
        [%data ~]
      ~
    ::
        %project
      :+  ['project' (shown-project +.+.+.update)]
        [%data ~]
      ~
    ::
        %new-project
      :_  ~
      :-  'data'
      %-  sync-desk-to-vship
      sync-desk-to-vship.p.payload.update
    ::
        ?(%compile-contract %run-queue)
      ['data' ~]~
    ::
        %add-config
      :_  ~
      :-  'data'
      %-  pairs
      :^    ['who' %s (scot %p who.p.payload.update)]
          ['what' %s what.p.payload.update]
        ['item' (numb item.p.payload.update)]
      ~
    ::
        %delete-config
      :_  ~
      :-  'data'
      %-  pairs
      :+  ['who' %s (scot %p who.p.payload.update)]
        ['what' %s what.p.payload.update]
      ~
    ::
        %add-test
      :+  ['test_id' %s (scot %ux test-id.update)]
        :-  'data'
        (frond %test (shown-test [p.payload test-id]:update))
      ~
    ::
        %edit-test
      :+  ['test_id' %s (scot %ux test-id.update)]
        :-  'data'
        (frond %test (shown-test [p.payload test-id]:update))
      ~
    ::
        %delete-test
      :+  ['test_id' %s (scot %ux test-id.update)]
        ['data' ~]
      ~
    ::
        ?(%add-custom-step %delete-custom-step %custom-step-compiled)
      :^    ['tag' %s tag.update]
          ['test_id' %s (scot %ux test-id.update)]
        ['data' ~]
      ~
    ::
        ?(%add-user-file %delete-user-file)
      :+  ['file' (path file.update)]
        ['data' ~]
      ~
    ::
        %test-results
      :~  ['test_id' %s (scot %ux test-id.update)]
          ['thread_id' %s thread-id.update]
          ['test_steps' (test-steps test-steps.update)]
      ::
          :-  'data'
          %+  frond  %test-results
          (shown-test-results p.payload.update)
      ==
    ::
        %dir
      `(list [@t json])`['data' (frond %dir (dir p.payload.update))]~
    ::
        %poke
      ['data' ~]~
    ::
        %test-queue
      :_  ~
      :-  'data'
      %+  frond  %test-queue
      (test-queue p.payload.update)
    ::
        %pyro-agent-state
      :_  ~
      :-  'data'
      %-  pairs
      :^    :+  %pyro-agent-state  %s
            (show-state agent-state.p.payload.update)
          ['outgoing' (boat wex.p.payload.update)]
        ['incoming' (bitt sup.p.payload.update)]
      ~
    ::
        %shown-pyro-agent-state
      :_  ~
      :-  'data'
      %-  pairs
      :^    :+  %pyro-agent-state  %s
            agent-state.p.payload.update
          ['outgoing' (boat wex.p.payload.update)]
        ['incoming' (bitt sup.p.payload.update)]
      ~
    ::
        %pyro-chain-state
      [%data (pyro-chain-state p.payload.update)]~
    ::
        %shown-pyro-chain-state
      [%data %s p.payload.update]~
    ::
        %sync-desk-to-vship
      :_  ~
      :-  'data'
      %+  frond  %sync-desk-to-vship
      (sync-desk-to-vship p.payload.update)
    ::
        %cis-setup-done
      ['data' ~]~
    ::
        %status
      :_  ~
      :-  'data'
      (frond %status (status p.payload.update))
    ::
        %focused-linked
      =*  up  p.payload.update
      :_  ~
      :-  'data'
      %-  pairs
      :^    [%focused-project %s focused-project.up]
          :-  %linked-projects
          (linked-projects linked-projects.up)
        :-  %unfocused-project-snaps
        (unfocused-project-snaps unfocused-project-snaps.up)
      ~
    ::
        %save-file
      ['data' (path p.payload.update)]~
    ::
        %settings
      ['data' (settings p.payload.update)]~
    ::
        %state-views
      :_  ~
      :-  'data'
      (state-views project-name.update p.payload.update)
    ==
  ::
  ++  settings
    |=  s=settings:zig
    ^-  json
    %-  pairs
    :~  :-  %test-result-num-characters
        (numb test-result-num-characters.s)
    ::
        :-  %state-num-characters
        (numb state-num-characters.s)
    ::
        :-  %compiler-error-num-lines
        (numb compiler-error-num-lines.s)
    ::
        :-  %code-max-characters
        (numb code-max-characters.s)
    ==
  ::
  ++  linked-projects
    |=  linked-projects=(jug @t @t)
    ^-  json
    %-  pairs
    %+  turn  ~(tap by linked-projects)
    |=  [project-name=@t links=(set @t)]
    :-  project-name
    :-  %a
    %+  turn  ~(tap in links)
    |=(link=@t [%s link])
  ::
  ++  unfocused-project-snaps
    |=  unfocused-project-snaps=(map (set @t) ^path)
    ^-  json
    %-  pairs
    %+  turn  ~(tap by unfocused-project-snaps)
    |=  [links=(set @t) p=^path]
    :-  (spat p)
    :-  %a
    %+  turn  ~(tap in links)
    |=(link=@t [%s link])
  ::
  ++  status
    |=  =status:zig
    ^-  json
    ?-    -.status
        %running-test-steps  [%s -.status]
        %ready               [%s -.status]
        %uninitialized       [%s -.status]
        %commit-install-starting
      %-  pairs
      %+  turn  ~(tap by cis-running.status)
      |=  [who=@p cis-done=@t is-done=?]
      :-  (scot %p who)
      %-  pairs
      :+  [%cis-done %s cis-done]
        [%is-done %b is-done]
      ~
    ::
        %changing-project-links
      %-  pairs
      %+  turn  ~(tap by project-cis-running.status)
      |=  [project-name=@t cis-running=(map @p [@t ?])]
      :-  project-name
      %-  pairs
      %+  turn  ~(tap by cis-running)
      |=  [who=@p cis-done=@t is-done=?]
      :-  (scot %p who)
      %-  pairs
      :+  [%cis-done %s cis-done]
        [%is-done %b is-done]
      ~
    ==
  ::
  ++  error
    |=  [level=error-level:zig message=@t]
    ^-  (list [@t json])
    :+  ['level' %s `@tas`level]
      ['message' %s message]
    ~
  ::
  ++  projects
    |=  ps=projects:zig
    ^-  json
    %-  pairs
    %+  turn  ~(tap by ps)
    |=([p-name=@t p=project:zig] [p-name (project p)])
  ::
  ++  project
    |=  p=project:zig
    ^-  json
    %-  pairs
    :~  ['dir' (dir dir.p)]
        ['user_files' (dir ~(tap in user-files.p))]
        ['to_compile' (dir ~(tap in to-compile.p))]
        ['tests' (tests tests.p)]
    ==
  ::
  ++  shown-projects
    |=  ps=shown-projects:zig
    ^-  json
    %-  pairs
    %+  turn  ~(tap by ps)
    |=  [p-name=@t p=shown-project:zig]
    [p-name (shown-project p)]
  ::
  ++  shown-project
    |=  p=shown-project:zig
    ^-  json
    %-  pairs
    :~  ['dir' (dir dir.p)]
        ['user_files' (dir ~(tap in user-files.p))]
        ['to_compile' (dir ~(tap in to-compile.p))]
        ['tests' (shown-tests tests.p)]
    ==
  ::
  ++  pyro-chain-state
    |=  state=(map @ux batch:ui)
    ^-  json
    %-  pairs
    %+  turn  ~(tap by state)
    |=  [town-id=@ux =batch:ui]
    [(scot %ux town-id) (batch:enjs:ui-lib batch)]
  ::
  ++  tests
    |=  =tests:zig
    ^-  json
    %-  pairs
    %+  turn  ~(tap by tests)
    |=  [id=@ux t=test:zig]
    [(scot %ux id) (test t)]
  ::
  ++  test
    |=  =test:zig
    ^-  json
    %-  pairs
    :~  ['name' %s ?~(name.test '' u.name.test)]
        ['test_steps_file' (path test-steps-file.test)]
        ['test_imports' (test-imports test-imports.test)]
        ['subject' %s ?:(?=(%& -.subject.test) '' p.subject.test)]
        ['custom_step_definitions' (custom-step-definitions custom-step-definitions.test)]
        ['test_steps' (test-steps steps.test)]
        ['test_results' (test-results results.test)]
    ==
  ::
  ++  shown-tests
    |=  tests=shown-tests:zig
    ^-  json
    %-  pairs
    %+  turn  ~(tap by tests)
    |=  [id=@ux t=shown-test:zig]
    [(scot %ux id) (shown-test t id)]
  ::
  ++  shown-test
    |=  [test=shown-test:zig test-id=@ux]
    ^-  json
    %-  pairs
    :~  ['name' %s ?~(name.test '' u.name.test)]
        ['test_steps_file' (path test-steps-file.test)]
        ['test_imports' (test-imports test-imports.test)]
        ['subject' %s ?:(?=(%& -.subject.test) '' p.subject.test)]
        ['custom_step_definitions' (custom-step-definitions custom-step-definitions.test)]
        ['test_steps' (test-steps steps.test)]
        ['test_results' (shown-test-results results.test)]
        ['test_id' %s (scot %ux test-id)]
    ==
  ::
  ++  test-imports
    |=  =test-imports:zig
    ^-  json
    %-  pairs
    %+  turn  ~(tap by test-imports)
    |=  [face=@tas p=^path]
    [face (path p)]
  ::
  ++  dir
    |=  dir=(list ^path)
    ^-  json
    :-  %a
    %+  turn  dir
    |=(p=^path (path p))
  ::
  ++  custom-step-definitions
    |=  =custom-step-definitions:zig
    ^-  json
    %-  pairs
    %+  turn  ~(tap by custom-step-definitions)
    |=  [id=@tas p=^path com=custom-step-compiled:zig]
    :-  id
    %-  pairs
    :+  ['path' (path p)]
      ['custom_step_compiled' (custom-step-compiled com)]
    ~
  ::
  ++  custom-step-compiled
    |=  =custom-step-compiled:zig
    ^-  json
    %-  pairs
    :+  ['compiled_successfully' %b ?=(%& -.custom-step-compiled)]
      ['compile_error' %s ?:(?=(%& -.custom-step-compiled) '' p.custom-step-compiled)]
    ~
  ::
  ++  test-steps
    |=  =test-steps:zig
    ^-  json
    :-  %a
    %+  turn  test-steps
    |=([ts=test-step:zig] (test-step ts))
  ::
  ++  test-step
    |=  =test-step:zig
    ^-  json
    ?:  ?=(?(%dojo %poke %subscribe %custom-write) -.test-step)
      (test-write-step test-step)
    ?>  ?=(?(%scry %read-subscription %wait %custom-read) -.test-step)
    (test-read-step test-step)
  ::
  ++  test-write-step
    |=  test-step=test-write-step:zig
    ^-  json
    ?-    -.test-step
        %dojo
      %-  pairs
      :~  ['type' %s -.test-step]
          ['result-face' (result-face result-face.test-step)]
          ['payload' (dojo-payload payload.test-step)]
          ['expected' (write-expected expected.test-step)]
      ==
    ::
        %poke
      %-  pairs
      :~  ['type' %s -.test-step]
          ['result-face' (result-face result-face.test-step)]
          ['payload' (poke-payload payload.test-step)]
          ['expected' (write-expected expected.test-step)]
      ==
    ::
        %subscribe
      %-  pairs
      :~  ['type' %s -.test-step]
          ['result-face' (result-face result-face.test-step)]
          ['payload' (sub-payload payload.test-step)]
          ['expected' (write-expected expected.test-step)]
      ==
    ::
        %custom-write
      %-  pairs
      :~  ['type' %s -.test-step]
          ['tag' %s tag.test-step]
          ['result-face' (result-face result-face.test-step)]
          ['payload' %s payload.test-step]
          ['expected' (write-expected expected.test-step)]
      ==
    ==
  ::
  ++  test-read-step
    |=  test-step=test-read-step:zig
    ^-  json
    ?-    -.test-step
        %scry
      %-  pairs
      :~  ['type' %s -.test-step]
          ['result-face' (result-face result-face.test-step)]
          ['payload' (scry-payload payload.test-step)]
          ['expected' %s expected.test-step]
      ==
    ::
        %read-subscription
      %-  pairs
      :~  ['type' %s -.test-step]
          ['result-face' (result-face result-face.test-step)]
          ['payload' (sub-payload payload.test-step)]
          ['expected' %s expected.test-step]
      ==
    ::
        %wait
      %-  pairs
      :+  ['type' %s -.test-step]
        ['until' %s (scot %dr until.test-step)]
      ~
    ::
        %custom-read
      %-  pairs
      :~  ['type' %s -.test-step]
          ['tag' %s tag.test-step]
          ['result-face' (result-face result-face.test-step)]
          ['payload' %s payload.test-step]
          ['expected' %s expected.test-step]
      ==
    ==
  ::
  ++  result-face
    |=  =result-face:zig
    ^-  json
    ?~  result-face  ~  [%s u.result-face]
  ::
  ++  scry-payload
    |=  payload=scry-payload:zig
    ^-  json
    %-  pairs
    :~  ['who' %s (scot %p who.payload)]
        ['mold-name' %s mold-name.payload]
        ['care' %s care.payload]
        ['app' %s app.payload]
        ['path' %s path.payload]
    ==
  ::
  ++  poke-payload
    |=  payload=poke-payload:zig
    ^-  json
    %-  pairs
    :~  ['who' %s (scot %p who.payload)]
        ['to' %s (scot %p to.payload)]
        ['app' %s app.payload]
        ['mark' %s mark.payload]
        ['payload' %s payload.payload]
    ==
  ::
  ++  dojo-payload
    |=  payload=dojo-payload:zig
    ^-  json
    %-  pairs
    :+  ['who' %s (scot %p who.payload)]
      ['payload' %s payload.payload]
    ~
  ::
  ++  sub-payload
    |=  payload=sub-payload:zig
    ^-  json
    %-  pairs
    :~  ['who' %s (scot %p who.payload)]
        ['to' %s (scot %p to.payload)]
        ['app' %s app.payload]
        ['path' (path path.payload)]
    ==
  ::
  ++  write-expected
    |=  test-read-steps=(list test-read-step:zig)
    ^-  json
    :-  %a
    %+  turn  test-read-steps
    |=  [trs=test-read-step:zig]
    (test-read-step trs)
  ::
  ++  test-results
    |=  =test-results:zig
    ^-  json
    :-  %a
    %+  turn  test-results
    |=([tr=test-result:zig] (test-result tr))
  ::
  ++  test-result
    |=  =test-result:zig
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
  ++  shown-test-results
    |=  =shown-test-results:zig
    ^-  json
    :-  %a
    %+  turn  shown-test-results
    |=([str=shown-test-result:zig] (shown-test-result str))
  ::
  ++  shown-test-result
    |=  =shown-test-result:zig
    ^-  json
    :-  %a
    %+  turn  shown-test-result
    |=  [success=? expected=@t result=@t]
    %-  pairs
    :^    ['success' %b success]
        ['expected' %s expected]
      ['result' %s result]
    ~
  ::
  ++  set-cords
    |=  cords=(set @t)
    ^-  json
    :-  %a
    %+  turn  ~(tap in cords)
    |=([cord=@t] [%s cord])
  ::
  ++  sync-desk-to-vship
    |=  =sync-desk-to-vship:zig
    ^-  json
    %-  pairs
    %+  turn  ~(tap by sync-desk-to-vship)
    |=  [desk=@tas ships=(set @p)]
    :+  desk  %a
    %+  turn  ~(tap in ships)
    |=(who=@p [%s (scot %p who)])
  ::
  ++  test-queue
    |=  test-queue=(qeu [@t @ux])
    ^-  json
    :-  %a
    %+  turn  ~(tap to test-queue)
    |=  [project=@t test-id=@ux]
    %-  pairs
    :+  [%project-name %s project]
      [%test-id %s (scot %ux test-id)]
    ~
  ::
  ++  boat
    |=  =boat:gall
    ^-  json
    :-  %a
    %+  turn  ~(tap by boat)
    |=  [[w=wire who=@p app=@tas] [ack=? p=^path]]
    %-  pairs
    :~  [%wire (path w)]
        [%ship %s (scot %p who)]
        [%term %s app]
        [%acked %b ack]
        [%path (path p)]
    ==
  ::
  ++  bitt
    |=  =bitt:gall
    ^-  json
    :-  %a
    %+  turn  ~(tap by bitt)
    |=  [d=duct who=@p p=^path]
    %-  pairs
    :~  [%duct %a (turn d |=(w=wire (path w)))]
        [%ship %s (scot %p who)]
        [%path (path p)]
    ==
  ::
  ++  state-views
    |=  $:  project-name=@tas
            state-views=(list [@p (unit @tas) ^path])
        ==
    ^-  json
    :-  %a
    %+  murn  state-views
    |=  [who=@p app=(unit @tas) file-path=^path]
    =/  file-scry-path=^path
      %-  weld  :_  file-path
      /(scot %p our.bowl)/[project-name]/(scot %da now.bowl)
    =+  .^(is-file-found=? %cu file-scry-path)
    ?.  is-file-found  ~
    =+  .^(file-contents=@t %cx file-scry-path)
    =/  [imports=(list [@tas ^path]) =hair]
      (parse-start-of-pile:conq (trip file-contents))
    =/  json-pairs=(list [@tas json])
      :~  [%who %s (scot %p who)]
          [%what %s ?~(app %chain %agent)]
      ::
          :+  %body  %s
          %-  of-wain:format
          (slag (dec p.hair) (to-wain:format file-contents))
      ::
          :-  %imports
          %-  pairs
          %+  turn  imports
          |=([face=@tas import=^path] [face (path import)])
      ==
    :-  ~
    %-  pairs
    ?~(app json-pairs [[%app %s u.app] json-pairs])
  --
++  dejs
  =,  dejs:format
  |%
  ++  uber-action
    ^-  $-(json action:zig)
    %-  ot
    :~  [%project so]
        [%request-id so:dejs-soft:format]
        [%action action]
    ==
  ::
  ++  action
    %-  of
    :~  [%new-project (ot ~[[%sync-ships (ar (se %p))]])]
        [%delete-project ul]
        [%save-config-to-file ul]
    ::
        [%add-sync-desk-vships add-sync-desk-vships]
        [%delete-sync-desk-vships (ot ~[[%ships (ar (se %p))]])]
    ::
        [%save-file (ot ~[[%file pa] [%text so]])]
        [%delete-file (ot ~[[%file pa]])]
    ::
        [%register-contract-for-compilation (ot ~[[%file pa]])]
        [%unregister-contract-for-compilation (ot ~[[%file pa]])]
        [%deploy-contract deploy]
    ::
        [%compile-contracts ul]
        [%compile-contract (ot ~[[%path pa]])]
        [%read-desk ul]
    ::
        [%add-config (ot ~[[%who (se %p)] [%what (se %tas)] [%item ni]])]
        [%delete-config (ot ~[[%who (se %p)] [%what (se %tas)]])]
    ::
        [%add-test add-test]
        [%add-and-run-test add-test]
        [%add-and-queue-test add-test]
        [%edit-test edit-test]
        [%save-test-to-file (ot ~[[%id (se %ux)] [%path pa]])]
    ::
        [%add-test-file add-test-file]
        [%add-and-run-test-file add-test-file]
        [%add-and-queue-test-file add-test-file]
    ::
        [%delete-test (ot ~[[%id (se %ux)]])]
        [%run-test (ot ~[[%id (se %ux)]])]
        [%run-queue ul]
        [%clear-queue ul]
        [%queue-test (ot ~[[%id (se %ux)]])]
    ::
        [%add-custom-step add-custom-step]
        [%delete-custom-step (ot ~[[%test-id (se %ux)] [%tag (se %tas)]])]
    ::
        [%stop-pyro-ships ul]
        [%start-pyro-ships (ot ~[[%ships (ar (se %p))]])]
        [%start-pyro-snap (ot ~[[%snap pa]])]
    ::
        [%take-snapshot (ot ~[[%update-project-snaps (mu pa)]])]
    ::
        [%publish-app docket]
    ::
        [%add-user-file (ot ~[[%file pa]])]
        [%delete-user-file (ot ~[[%file pa]])]
    ::
        [%send-pyro-dojo (ot ~[[%who (se %p)] [%command sa]])]
    ::
        [%pyro-agent-state pyro-agent-state]
        [%pyro-chain-state pyro-chain-state]
    ::
        [%change-focus ul]
        [%add-project-link ul]
        [%delete-project-link ul]
    ::
        [%cis-panic ul]
    ::
        [%change-settings change-settings]
    ==
  ::
  ++  change-settings
    ^-  $-(json settings:zig)
    %-  ot
    :~  [%test-result-num-characters ni]
        [%state-num-characters ni]
        [%compiler-error-num-lines ni]
        [%code-max-characters ni]
    ==
  ::
  ++  docket
    ^-  $-(json [@t @t @ux @t [@ud @ud @ud] @t @t])
    %-  ot
    :~  [%title so]
        [%info so]
        [%color (se %ux)]
        [%image so]
        [%version (at ~[ni ni ni])]
        [%website so]
        [%license so]
    ==
  ::
  ++  deploy
    ^-  $-(json [town-id=@ux contract-jam=path])
    %-  ot
    :~  [%town-id (se %ux)]
        [%path pa]
    ==
  ::
  ++  add-sync-desk-vships
    ^-  $-(json [(list @p) ? (list @tas)])
    %-  ot
    :^    [%ships (ar (se %p))]
        [%install bo]
      [%start-apps (ar (se %tas))]
    ~
  ::
  ++  add-test
    ^-  $-(json [(unit @t) test-imports:zig test-steps:zig])
    %-  ot
    :^    [%name so:dejs-soft:format]
        [%test-imports (om pa)]
      [%test-steps (ar test-step)]
    ~
  ::
  ++  edit-test
    ^-  $-(json [@ux (unit @t) test-imports:zig test-steps:zig])
    %-  ot
    :*  [%id (se %ux)]
        [%name so:dejs-soft:format]
        [%test-imports (om pa)]
        [%test-steps (ar test-step)]
        ~
    ==
  ::
  ++  add-test-file
    ^-  $-(json [name=(unit @t) test-steps-path=path])
    %-  ot
    :+  [%name so:dejs-soft:format]
      [%path pa]
    ~
  ::
  ++  test-step
    ^-  $-(json test-step:zig)
    %-  of
    (welp test-read-step-inner test-write-step-inner)
  ::
  ++  test-read-step
    ^-  $-(json test-read-step:zig)
    (of test-read-step-inner)
  ::
  ++  test-read-step-inner
    :~  [%scry (ot ~[[%result-face result-face] [%payload scry-payload] [%expected so]])]
        [%read-subscription (ot ~[[%result-face result-face] [%payload read-sub-payload] [%expected so]])]
        [%wait (ot ~[[%until (se %dr)]])]
        [%custom-read (ot ~[[%tag (se %tas)] [%result-face result-face] [%payload so] [%expected so]])]
    ==
  ::
  ++  scry-payload
    ^-  $-(json scry-payload:zig)
    %-  ot
    :~  [%who (se %p)]
        [%mold-name so]
        [%care (se %tas)]
        [%app (se %tas)]
        [%path so]
    ==
  ::
  ++  read-sub-payload
    ^-  $-(json read-sub-payload:zig)
    %-  ot
    :~  [%who (se %p)]
        [%to (se %p)]
        [%app (se %tas)]
        [%path pa]
    ==
  ::
  ++  test-write-step
    ^-  $-(json test-write-step:zig)
    (of test-write-step-inner)
  ::
  ++  test-write-step-inner
    :~  [%dojo (ot ~[[%result-face result-face] [%payload dojo-payload] [%expected (ar test-read-step)]])]
        [%poke (ot ~[[%result-face result-face] [%payload poke-payload] [%expected (ar test-read-step)]])]
        [%subscribe (ot ~[[%result-face result-face] [%payload subscribe-payload] [%expected (ar test-read-step)]])]
        [%custom-write (ot ~[[%tag (se %tas)] [%result-face result-face] [%payload so] [%expected (ar test-read-step)]])]
    ==
  ::
  ++  result-face
    ^-  $-(json (unit @tas))
    so:dejs-soft:format
  ::
  ++  dojo-payload
    ^-  $-(json dojo-payload:zig)
    %-  ot
    :+  [%who (se %p)]
      [%payload so]
    ~
  ::
  ++  poke-payload
    ^-  $-(json poke-payload:zig)
    %-  ot
    :~  [%who (se %p)]
        [%to (se %p)]
        [%app (se %tas)]
        [%mark (se %tas)]
        [%payload so]
    ==
  ::
  ++  subscribe-payload
    ^-  $-(json sub-payload:zig)
    %-  ot
    :~  [%who (se %p)]
        [%to (se %p)]
        [%app (se %tas)]
        [%path pa]
    ==
  ::
  ++  add-custom-step
    ^-  $-(json [test-id=@ux tag=@tas custom-step-file=path])
    %-  ot
    :^    [%test-id (se %ux)]
        [%tag (se %tas)]
      [%path pa]
    ~
  ::
  ++  pyro-agent-state
    ^-  $-(json [who=@p app=@tas =test-imports:zig grab=@t])
    %-  ot
    :~  [%who (se %p)]
        [%app (se %tas)]
        [%test-imports (om pa)]
        [%grab so]
    ==
  ::
  ++  pyro-chain-state
    ^-  $-(json [=test-imports:zig grab=@t])
    (ot ~[[%test-imports (om pa)] [%grab so]])
  --
--
