/-  eng=zig-engine,
    pyro=zig-pyro,
    ui=zig-indexer,
    zig=zig-ziggurat
/+  agentio,
    mip,
    conq=zink-conq,
    dock=docket,
    pyro-lib=zig-pyro,
    smart=zig-sys-smart,
    ui-lib=zig-indexer,
    zink=zink-zink
|_  =bowl:gall
+*  this  .
    io    ~(. agentio bowl)
::
+$  card  card:agent:gall
::
::  utilities
::
++  make-project-update
  |=  [=update-info:zig =project:zig]
  ^-  card
  %-  fact:io  :_  ~[/project/[project-name.update-info]]
  :-  %ziggurat-update
  !>  ^-  update:zig
  [%project update-info [%& ~] (show-project project)]
::
++  make-state-update
  |=  [=update-info:zig =project:zig =configs:zig]
  =*  project-name  project-name.update-info
  ^-  card
  %-  fact:io  :_  ~[/project/[project-name]]
  :-  %ziggurat-update
  !>  ^-  update:zig
  :^  %state  update-info  [%& ~]
  (get-state project-name project configs)
::
++  update-vase-to-card
  |=  [project-name=@t v=vase]
  ^-  card
  (fact:io [%ziggurat-update v] ~[/project/[project-name]])
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
  ++  state
    |=  state=(map @ux chain:eng)
    ^-  vase
    !>  ^-  update:zig
    [%state update-info [%& ~] state]
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
    [%add-test update-info [%& (show-test test)] test-id]
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
    [%edit-test update-info [%& (show-test test)] test-id]
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
  ++  pyro-ships-ready
    |=  pyro-ships-ready=(map @p ?)
    ^-  vase
    !>  ^-  update:zig
    [%pyro-ships-ready update-info [%& pyro-ships-ready] ~]
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
    |=  agent-state=@t
    ^-  vase
    !>  ^-  update:zig
    [%pyro-agent-state update-info [%& agent-state] ~]
  --
::
++  make-error-vase
  |_  [=update-info:zig level=error-level:zig]
  ++  project-names
    |=  [message=@t project-names=(set @t)]
    ^-  vase
    !>  ^-  update:zig
    [%project-names update-info [%| level message] project-names]
  ::
  ++  projects
    |=  [message=@t =projects:zig]
    ^-  vase
    !>  ^-  update:zig
    [%projects update-info [%| level message] (show-projects projects)]
  ::
  ++  project
    |=  [message=@t =project:zig]
    ^-  vase
    !>  ^-  update:zig
    [%project update-info [%| level message] (show-project project)]
  ::
  ++  state
    |=  [message=@t state=(map @ux chain:eng)]
    ^-  vase
    !>  ^-  update:zig
    [%state update-info [%| level message] state]
  ::
  ++  add-config
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%add-config update-info [%| level message] ~]
  ::
  ++  delete-config
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%delete-config update-info [%| level message] ~]
  ::
  ++  new-project
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%new-project update-info [%| level message] ~]
  ::
  ++  add-test
    |=  [message=@t test-id=@ux]
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
  ++  edit-test
    |=  [message=@t test-id=@ux]
    ^-  vase
    !>  ^-  update:zig
    [%edit-test update-info [%| level message] test-id]
  ::
  ++  delete-test
    |=  [message=@t test-id=@ux]
    ^-  vase
    !>  ^-  update:zig
    [%delete-test update-info [%| level message] test-id]
  ::
  ++  run-queue
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%run-queue update-info [%| level message] ~]
  ::
  ++  add-custom-step
    |=  [message=@t test-id=@ux tag=@tas]
    ^-  vase
    !>  ^-  update:zig
    [%add-custom-step update-info [%| level message] test-id tag]
  ::
  ++  delete-custom-step
    |=  [message=@t test-id=@ux tag=@tas]
    ^-  vase
    !>  ^-  update:zig
    [%delete-custom-step update-info [%| level message] test-id tag]
  ::
  ++  add-user-file
    |=  [message=@t file=path]
    ^-  vase
    !>  ^-  update:zig
    [%add-user-file update-info [%| level message] file]
  ::
  ++  delete-user-file
    |=  [message=@t file=path]
    ^-  vase
    !>  ^-  update:zig
    [%delete-user-file update-info [%| level message] file]
  ::
  ++  custom-step-compiled
    |=  [message=@t test-id=@ux tag=@tas]
    ^-  vase
    !>  ^-  update:zig
    [%custom-step-compiled update-info [%| level message] test-id tag]
  ::
  ++  test-results
    |=  [message=@t test-id=@ux thread-id=@t =test-steps:zig]
    ^-  vase
    !>  ^-  update:zig
    :^  %test-results  update-info  [%| level message]
    [test-id thread-id test-steps]
  ::
  ++  dir
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%dir update-info [%| level message] ~]
  ::
  ++  pyro-ships-ready
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%pyro-ships-ready update-info [%| level message] ~]
  ::
  ++  poke
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%poke update-info [%| level message] ~]
  ::
  ++  test-queue
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%test-queue update-info [%| level message] ~]
  ::
  ++  pyro-agent-state
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%pyro-agent-state update-info [%| level message] ~]
  --
::
++  make-compile-contracts
  |=  [project-name=@t request-id=(unit @t)]
  ^-  card
  %-  ~(poke-self pass:io /self-wire)
  :-  %ziggurat-action
  !>(`action:zig`project-name^request-id^[%compile-contracts ~])
::
++  make-compile-contract
  |=  [project-name=@t file=path request-id=(unit @t)]
  ^-  card
  %-  ~(poke-self pass:io /self-wire)
  :-  %ziggurat-action
  !>(`action:zig`project-name^request-id^[%compile-contract file])
::
++  make-watch-for-file-changes
  |=  [project-name=@tas files=(list path)]
  ^-  card
  %-  ~(warp-our pass:io /clay/[project-name])
  :-  project-name
  :^  ~  %mult  da+now.bowl
  %-  ~(gas in *(set [care:clay path]))
  (turn files |=(p=path [%x p]))
::
++  make-cancel-watch-for-file-changes
  |=  project-name=@tas
  ^-  card
  %-  ~(warp-our pass:io /clay/[project-name])
  :-  project-name
  ~
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
  |=  [project-name=@t file=path text=@t]
  ^-  card
  =/  file-type  (rear file)
  =/  mym=mime  :-  /application/x-urb-unknown
    %-  as-octt:mimes:html
    %+  rash  text
    (star ;~(pose (cold '\0a' (jest '\0d\0a')) next))
  %-  ~(arvo pass:io /save-wire)
  :-  %c
  :: =-  [%pass /save-wire %arvo %c -]
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
  |=  [project-name=@t request-id=(unit @t)]
  ^-  card
  %-  ~(poke-self pass:io /self-wire)
  :-  %ziggurat-action
  !>(`action:zig`project-name^request-id^[%run-queue ~])
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
  [test-id (show-test test)]
::
++  show-test
  |=  =test:zig
  ^-  shown-test:zig
  :*  name=name.test
      test-steps-file=test-steps-file.test
      test-imports=test-imports.test
      subject=?:(?=(%& -.subject.test) [%& *vase] subject.test)
      custom-step-definitions=(show-custom-step-definitions custom-step-definitions.test)
      steps=steps.test
      results=(show-test-results results.test)
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
  ?:  (lte 1.024 (met 3 res-text))  '<elided>'  ::  TODO: unhardcode
  res-text
::
++  noah-slap-ream
  |=  [number-sur-lines=@ud subject=vase payload=@t]
  ^-  tape
  =/  compilation-result
    (mule-slap-subject number-sur-lines subject payload)
  ?:  ?=(%| -.compilation-result)  (trip payload)
  (noah p.compilation-result)
::
++  mule-slap-subject
  |=  [number-sur-lines=@ud subject=vase payload=@t]
  ^-  (each vase @t)
  =/  compilation-result
    (mule |.((slap subject (ream payload))))
  ?:  ?=(%& -.compilation-result)  compilation-result
  =/  error-tanks=(list tank)  (scag 2 p.compilation-result)
  ?.  ?=([^ [%leaf ^] ~] error-tanks)
    :-  %|
    (get-formatted-error (scag 2 p.compilation-result))
  =/  [error-line-number=@ud col=@ud]
    (parse-error-line-col p.i.t.error-tanks)
  =/  real-line-number=@ud
    (dec (add number-sur-lines error-line-number))
  =/  modified-error-tanks=(list tank)
    ~[i.error-tanks [%leaf "\{{<real-line-number>} {<col>}}"]]
  :-  %|
  (get-formatted-error (scag 2 modified-error-tanks))
::
++  parse-error-line-col
  |=  line-col=tape
  ^-  [@ud @ud]
  =/  [=hair res=(unit [line-col=[@ud @ud] =nail])]
    %.  [[1 1] line-col]
    %-  full
    %+  ifix  [kel ker]
    ;~(plug dem:ag ;~(pfix ace dem:ag))
  ?^  res  line-col.u.res
  %-  mean  %-  flop
  =/  lyn  p.hair
  =/  col  q.hair
  :~  leaf+"syntax error"
      leaf+"\{{<lyn>} {<col>}}"
      leaf+(runt [(dec col) '-'] "^")
      leaf+(trip (snag (dec lyn) (to-wain:format (crip line-col))))
  ==
::
++  compile-and-call-arm
  |=  [arm=@tas number-sur-lines=@ud subject=vase payload=@t]
  ^-  (each vase @t)
  =/  hoon-compilation-result
    (mule-slap-subject number-sur-lines subject payload)
  ?:  ?=(%| -.hoon-compilation-result)
    hoon-compilation-result
  %^  mule-slap-subject  number-sur-lines
  p.hoon-compilation-result  arm
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
    =/  message=tape  "file {<`path`p>} not found"
    :_  test
    :_  ~
    %+  update-vase-to-card  project-name
    (add-custom-error (crip message) [`@ux`(sham test) tag])
  =/  file-cord=@t  .^(@t %cx file-scry-path)
  =/  [imports=(list [face=@tas =path]) =hair]
    (parse-start-of-pile (trip file-cord))
  ?:  ?=(%| -.subject.test)
    =/  message=tape
      %+  weld  "subject must compile from imports before"
      " adding custom step"
    :_  test
    :_  ~
    %+  update-vase-to-card  project-name
    (add-custom-error (crip message) [`@ux`(sham test) tag])
  =/  compilation-result=(each vase @t)
    %-  compile-and-call-arm
    :^  '$'  p.hair  p.subject.test
    %-  of-wain:format
    (slag (dec p.hair) (to-wain:format file-cord))
  ?:  ?=(%| -.compilation-result)
    =/  message=tape
      %+  weld  "compilation failed with error:"
      " {<p.compilation-result>}"
    :_  test
    :_  ~
    %+  update-vase-to-card  project-name
    (add-custom-error (crip message) [`@ux`(sham test) tag])
  :-  ~
  %=  test
      custom-step-definitions
    %+  ~(put by custom-step-definitions.test)  tag
    [p compilation-result]
  ==
::
++  get-state
  |=  [project-name=@t =project:zig =configs:zig]
  ^-  (map @ux chain:eng)
  =/  now-ta=@ta   (scot %da now.bowl)
  %-  ~(gas by *(map @ux chain:eng))
  %+  murn
    %~  tap  by
    (get-town-id-to-sequencer-map project-name configs)
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
::  abbreviated parser from lib/zink/conq.hoon:
::   parse to end of imports, start of hoon.
::   used to find start of hoon for compilation and to find
::   proper line error number in case of error
::   (see +mule-slap-subject)
::
+$  small-start-of-pile  (list [face=term =path])
::
++  parse-start-of-pile
  |=  tex=tape
  ^-  [small-start-of-pile hair]
  =/  [=hair res=(unit [=small-start-of-pile =nail])]
    (start-of-pile-rule [1 1] tex)
  ?^  res  [small-start-of-pile.u.res hair]
  %-  mean  %-  flop
  =/  lyn  p.hair
  =/  col  q.hair
  :~  leaf+"syntax error"
      leaf+"\{{<lyn>} {<col>}}"
      leaf+(runt [(dec col) '-'] "^")
      leaf+(trip (snag (dec lyn) (to-wain:format (crip tex))))
  ==
::
++  start-of-pile-rule
  %+  ifix
    :_  gay
    ::  parse optional smart library import and ignore
    ;~(plug gay (punt ;~(plug fas lus gap taut-rule:conq gap)))
  ;~  plug
  ::  only accept /= imports for contract libraries
    %+  rune:conq  tis
    ;~(plug sym ;~(pfix gap stap))
  ==
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
  %-  ~(gas by *(map @ux @p))
  %+  murn  ~(tap bi:mip configs)
  |=  [pn=@t [who=@p what=@tas] item=@]
  ?.  =(project-name pn)   ~
  ?.  ?=(%sequencer what)  ~
  `[`@ux`item who]
::
++  scry-virtualship-desks
  |=  virtualship=@p
  ^-  (set @tas)
  =/  now=@ta  (scot %da now.bowl)
  =/  who=@ta  (scot %p virtualship)
  =/  desks=*
    .^  *
        %gx
        :-  (scot %p our.bowl)
        /pyro/[now]/i/[who]/cd/[who]/base/[now]/noun
    ==
  (fall ;;((unit (set @tas)) desks) ~)
::
++  virtualship-desk-exists
  |=  [virtualship=@p desk=@tas]
  ^-  ?
  (~(has in (scry-virtualship-desks virtualship)) desk)
::
++  virtualship-is-running-app
  |=  [virtualship=@p app=@tas]
  ^-  ?
  =/  now=@ta  (scot %da now.bowl)
  =/  who=@ta  (scot %p virtualship)
  =/  is-app-running=*
    .^  *
        %gx
        :-  (scot %p our.bowl)
        /pyro/[now]/i/[who]/gu/[who]/[app]/[now]/noun
    ==
  (fall ;;((unit ?) is-app-running) %.n)
::
++  sync-desk-to-virtualship
  |=  [who=@p project-name=@tas]
  ^-  card
  %+  %~  poke-our  pass:io
      /sync/(scot %da now.bowl)/[project-name]/(scot %p who)
      %pyro
  :-  %aqua-events
  !>  ^-  (list aqua-event:pyro)
  :_  ~
  :^  %event  who  /c/commit/(scot %p who)
  (park:pyro-lib our.bowl project-name %da now.bowl)
::
++  send-pyro-dojo
  |=  [who=@p command=tape]
  ^-  card
  %+  %~  poke-our  pass:io
      /dojo/(scot %p who)/(scot %ux `@ux`(jam command))
    %pyro
  :-  %aqua-events
  !>  ^-  (list aqua-event:pyro)
  (dojo-events:pyro-lib who command)
::
++  cis
  |_  $:  who=@p
          desk=@tas
          install=?
          start-apps=(list @tas)
          cis-running=(map @p @t)
      ==
  ++  commit-poll-duration   ~s1
  ++  install-poll-duration  ~s1
  ++  start-poll-duration    (div ~s1 10)
  ++  commit-wait   (add now.bowl commit-poll-duration)
  ++  install-wait  (add now.bowl install-poll-duration)
  ++  start-wait    (add now.bowl start-poll-duration)
  ++  committing-wire  `wire`[%committing base-wire]
  ++  installing-wire  `wire`[%installing base-wire]
  ++  starting-wire    `wire`[%starting base-wire]
  ::
  ++  base-wire
    ^-  wire
    %+  weld  /(scot %p who)/[desk]/(scot %ud install)
    /(scot %ud (jam start-apps))
  ::
  ++  get-final-app-to-install
    ^-  @tas
    =/  bill-path=path
      :-  (scot %p our.bowl)
      /[desk]/(scot %da now.bowl)/desk/bill
    (rear .^((list @tas) %cx bill-path))
  ::
  ++  run-queue
    ^-  [(list card) (map @p @t)]
    :_  (~(del by cis-running) who)
    :_  ~
    %-  ~(poke-self pass:io /self-wire)
    [%ziggurat-action !>(`action:zig`''^~^[%run-queue ~])]
  ::
  ++  commit
    ^-  [(list card) (map @p @t)]
    :_  cis-running
    :+  (~(wait pass:io committing-wire) commit-wait)
      (sync-desk-to-virtualship who desk)
    ~
  ::
  ++  on-wake-commit
    ^-  [(list card) (map @p @t)]
    ?.  (virtualship-desk-exists who desk)
      ::  not done: keep waiting
      :_  cis-running
      ~[(~(wait pass:io committing-wire) commit-wait)]
    ::  done: install if desired, else %run-queue
    ?.  install  run-queue
    :_  cis-running
    :+  (~(wait pass:io installing-wire) install-wait)
      (send-pyro-dojo who "|install our {<desk>}")
    ~
  ::
  ++  on-wake-install
    ^-  [(list card) (map @p @t)]
    ::  if the final app is installed -> install done
    =/  app=@tas  get-final-app-to-install
    ?.  (virtualship-is-running-app who app)
      ::  not done: keep waiting
      :_  cis-running
      ~[(~(wait pass:io installing-wire) install-wait)]
    ::  done: start apps if desired, else %run-queue
    ?~  start-apps  run-queue
    =*  app   i.start-apps
    :_  cis-running
    :+  (~(wait pass:io starting-wire) start-wait)
      %+  send-pyro-dojo  who
      "|start {<`@tas`desk>} {<`@tas`app>}"
    ~
  ::
  ++  on-wake-start
    ^-  [(list card) (map @p @t)]
    ?~  start-apps  run-queue  ::  no more apps to start: %run-queue
    =*  starting-app  i.start-apps
    =*  rest-of-apps  t.start-apps
    ?.  (virtualship-is-running-app who starting-app)
      ::  not done: keep waiting
      :_  cis-running
      ~[(~(wait pass:io starting-wire) start-wait)]
    ::  done: start next app if more, else %run-queue
    ?~  rest-of-apps  run-queue
    =*  next-app   i.rest-of-apps
    :_  cis-running
    :+  %.  start-wait
        %~  wait  pass:io
        starting-wire(start-apps rest-of-apps)
      %+  send-pyro-dojo  who
      "|start {<`@tas`desk>} {<`@tas`next-app>}"
    ~
  --
::
++  compile-test-imports
  |=  $:  project-desk=@tas
          imports=(list [face=@tas =path])
          state=inflated-state-0:zig
      ==
  ^-  [(each vase @t) inflated-state-0:zig]
  =/  compilation-result
    %-  mule
    |.
    =/  initial-test-globals=vase
      !>  ^-  test-globals:zig
      :^  our.bowl  now.bowl  *test-results:zig
      [project-desk configs:state]
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
    :_  c
    %+  slop
      %=  initial-test-globals
        p  [%face %test-globals p.initial-test-globals]
      ==
    subject
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
++  build-default-config
  |=  =config:zig
  ^-  $:  config:zig
          (list @p)
          ?
          (list @tas)
          (map @p test-steps:zig)
          (list [@tas path])
      ==
  =+  .^  =update:zig
          %gx
          (scry:io %ziggurat /pyro-ships-ready/noun)
      ==
  =/  ships=(list @p)
    ?~  update                          ~
    ?.  ?=(%pyro-ships-ready -.update)  ~
    ?.  ?=(%& -.payload.update)         ~
    %-  sort  :_  lth
    ~(tap in ~(key by p.payload.update))
  :*  config
      ships
      %.y
      ~
      ~
      [%zig /sur/zig/ziggurat]~
  ==
::
++  load-config
  |=  [=update-info:zig state=inflated-state-0:zig]
  ^-  [(list card) inflated-state-0:zig]
  =*  project-name  project-name.update-info
  =/  new-project-error
    %~  new-project  make-error-vase
    [update-info(source %load-config) %error]
  =/  config-file-path=path
    %+  weld  /(scot %p our.bowl)/[project-name]
    /(scot %da now.bowl)/zig/configs/[project-name]/hoon
  |^
  ?.  .^(? %cu config-file-path)
    (build-cards-and-state (build-default-config ~))
  =/  result  get-config-from-file
  ?:  ?=(%| -.result)  p.result
  (build-cards-and-state p.result)
  ::
  ++  get-config-from-file
    ^-  (each [config:zig (list @p) ? (list @tas) (map @p test-steps:zig) (list [@tas path])] [(list card) inflated-state-0:zig])
    =/  file-cord=@t  .^(@t %cx config-file-path)
    =/  [imports=(list [face=@tas =path]) =hair]
      (parse-start-of-pile (trip file-cord))
    =^  subject=(each vase @t)  state
      (compile-test-imports project-name imports state)
    ?:  ?=(%| -.subject)
      =/  message=tape
        %+  weld  "config imports conpilation failed with"
        " error: {<p.subject>}"
      :-  %|
      :_  state
      :_  ~
      %+  update-vase-to-card  project-name
      (new-project-error (crip message))
    =/  config-core
      %^  mule-slap-subject  p.hair  p.subject
      %-  of-wain:format
      (slag (dec p.hair) (to-wain:format file-cord))
    ?:  ?=(%| -.config-core)
      =/  message=tape
        "config compilation failed with: {<p.config-core>}"
      :-  %|
      :_  state
      :_  ~
      %+  update-vase-to-card  project-name
      (new-project-error (crip message))
    ::
    =/  config-result
      (mule-slap-subject p.hair p.config-core %make-config)
    ?:  ?=(%| -.config-result)
      =/  message=tape
        "failed to call +make-config arm: {<p.config-result>}"
      :-  %|
      :_  state
      :_  ~
      %+  update-vase-to-card  project-name
      (new-project-error (crip message))
    ::
    =/  virtualships-to-sync-result
      %^  mule-slap-subject  p.hair  p.config-core
      %make-virtualships-to-sync
    ?:  ?=(%| -.virtualships-to-sync-result)
      =/  message=tape
        %+  weld  "failed to call +make-virtualships-to-sync"
        " arm: {<p.virtualships-to-sync-result>}"
      :-  %|
      :_  state
      :_  ~
      %+  update-vase-to-card  project-name
      (new-project-error (crip message))
    ::
    =/  install-result
      %^  mule-slap-subject  p.hair  p.config-core
      %make-install
    ?:  ?=(%| -.install-result)
      =/  message=tape
        "failed to call +make-install arm: {<p.install-result>}"
      :-  %|
      :_  state
      :_  ~
      %+  update-vase-to-card  project-name
      (new-project-error (crip message))
    ::
    =/  start-apps-result
      %^  mule-slap-subject  p.hair  p.config-core
      %make-start-apps
    ?:  ?=(%| -.start-apps-result)
      =/  message=tape
        %+  weld  "failed to call +make-start-apps arm:"
        " {<p.start-apps-result>}"
      :-  %|
      :_  state
      :_  ~
      %+  update-vase-to-card  project-name
      (new-project-error (crip message))
    ::
    =/  setup-result
      %^  mule-slap-subject  p.hair  p.config-core
      %make-setup
    ?:  ?=(%| -.setup-result)
      =/  message=tape
        "failed to call +make-setup arm: {<p.setup-result>}"
      :-  %|
      :_  state
      :_  ~
      %+  update-vase-to-card  project-name
      (new-project-error (crip message))
    ::
    :*  %&
        !<(config:zig p.config-result)
        !<((list @p) p.virtualships-to-sync-result)
        !<(? p.install-result)
        !<((list @tas) p.start-apps-result)
        !<((map @p test-steps:zig) p.setup-result)
        imports
    ==
  ::
  ++  build-cards-and-state
    |=  $:  =config:zig
            virtualships-to-sync=(list @p)
            install=?
            start-apps=(list @tas)
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
      %+  update-vase-to-card  project-name
      (new-project-error(level %warning) (crip message))
    =/  cis-running=(map @p @t)
      %-  ~(gas by *(map @p @t))
      %+  turn  virtualships-to-sync
      |=  who=@p
      :-  who
      (rap 3 'setup-' project-name '-' (scot %p who) ~)
    =.  cards
      %+  weld  cards
      %+  murn  virtualships-to-sync
      |=  who=@p
      ?~  setup=(~(get by setups) who)  ~
      =/  cis-name=@t  (~(got by cis-running) who)
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
      =^  cis-cards  cis-running.state
        ~(commit cis who desk install start-apps cis-running)
      %=  $
          virtualships-to-sync  t.virtualships-to-sync
      ::
          cards
        %+  weld  cards  cis-cards
      ==
    :-  cards
    %=  state
        test-queue   ~  ::  TODO: save and restore after? Check for running?
        cis-running  cis-running
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
    =*  payload  -.+.+.update  ::  TODO: remove this hack
    ?>  ?=([@ *] payload)
    ?:  ?=(%| -.payload)  (error +.payload)
    ~!  update
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
        %state
      :+  ['state' (state state.update)]
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
        (frond %test (shown-test p.payload.update))
      ~
    ::
        %edit-test
      :+  ['test_id' %s (scot %ux test-id.update)]
        :-  'data'
        (frond %test (shown-test p.payload.update))
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
        %pyro-ships-ready
      :_  ~
      :-  'data'
      %+  frond  %pyro-ships-ready
      (pyro-ships-ready p.payload.update)
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
      (frond %pyro-agent-state [%s p.payload.update])
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
  ++  state
    |=  state=(map @ux chain:eng)
    ^-  json
    %-  pairs
    %+  turn  ~(tap by state)
    |=  [town-id=@ux =chain:eng]
    [(scot %ux town-id) (chain:enjs:ui-lib chain)]
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
    [(scot %ux id) (shown-test t)]
  ::
  ++  shown-test
    |=  test=shown-test:zig
    ^-  json
    %-  pairs
    :~  ['name' %s ?~(name.test '' u.name.test)]
        ['test_steps_file' (path test-steps-file.test)]
        ['test_imports' (test-imports test-imports.test)]
        ['subject' %s ?:(?=(%& -.subject.test) '' p.subject.test)]
        ['custom_step_definitions' (custom-step-definitions custom-step-definitions.test)]
        ['test_steps' (test-steps steps.test)]
        ['test_results' (shown-test-results results.test)]
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
      :^    ['type' %s -.test-step]
          ['payload' (dojo-payload payload.test-step)]
        ['expected' (write-expected expected.test-step)]
      ~
    ::
        %poke
      %-  pairs
      :^    ['type' %s -.test-step]
          ['payload' (poke-payload payload.test-step)]
        ['expected' (write-expected expected.test-step)]
      ~
    ::
        %subscribe
      %-  pairs
      :^    ['type' %s -.test-step]
          ['payload' (sub-payload payload.test-step)]
        ['expected' (write-expected expected.test-step)]
      ~
    ::
        %custom-write
      %-  pairs
      :~  ['type' %s -.test-step]
          ['tag' %s tag.test-step]
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
      :^    ['type' %s -.test-step]
          ['payload' (scry-payload payload.test-step)]
        ['expected' %s expected.test-step]
      ~
    ::
        %dbug
      %-  pairs
      :^    ['type' %s -.test-step]
          ['payload' (dbug-payload payload.test-step)]
        ['expected' %s expected.test-step]
      ~
    ::
        %read-subscription
      %-  pairs
      :^    ['type' %s -.test-step]
          ['payload' (sub-payload payload.test-step)]
        ['expected' %s expected.test-step]
      ~
    ::
        %wait
      %-  pairs
      :+  ['type' %s -.test-step]
        ['until' %s (scot %dr until.test-step)]
      ~
    ::
        %custom-read
      %+  frond  tag.test-step
      %-  pairs
      :~  ['type' %s -.test-step]
          ['tag' %s tag.test-step]
          ['payload' %s payload.test-step]
          ['expected' %s expected.test-step]
      ==
    ==
  ::
  ++  scry-payload
    |=  payload=scry-payload:zig
    ^-  json
    %-  pairs
    :~  ['who' %s (scot %p who.payload)]
        ['mold-name' %s mold-name.payload]
        ['care' %s care.payload]
        ['app' %s app.payload]
        ['path' (path path.payload)]
    ==
  ::
  ++  dbug-payload
    |=  payload=dbug-payload:zig
    ^-  json
    %-  pairs
    :^    ['who' %s (scot %p who.payload)]
        ['mold-name' %s mold-name.payload]
      ['app' %s app.payload]
    ~
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
  ++  pyro-ships-ready
    |=  pyro-ships-ready=(map @p ?)
    ^-  json
    %-  pairs
    %+  turn  ~(tap by pyro-ships-ready)
    |=  [who=@p is-ready=?]
    [(scot %p who) [%b is-ready]]
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
    :-  %a
    %+  turn  ~(tap to test-queue)
    |=  [project=@t test-id=@ux]
    %-  pairs
    :+  [%project-name %s project]
      [%test-id %s (scot %ux test-id)]
    ~
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
        [%save-file (ot ~[[%file pa] [%text so]])]
        [%delete-file (ot ~[[%file pa]])]
    ::
        [%register-contract-for-compilation (ot ~[[%file pa]])]
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
        [%publish-app docket]
        [%add-user-file (ot ~[[%file pa]])]
        [%delete-user-file (ot ~[[%file pa]])]
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
    :~  [%scry (ot ~[[%payload scry-payload] [%expected so]])]
        [%dbug (ot ~[[%payload dbug-payload] [%expected so]])]
        [%read-subscription (ot ~[[%payload read-sub-payload] [%expected so]])]
        [%wait (ot ~[[%until (se %dr)]])]
        [%custom-read (ot ~[[%tag (se %tas)] [%payload so] [%expected so]])]
    ==
  ::
  ++  scry-payload
    ^-  $-(json scry-payload:zig)
    %-  ot
    :~  [%who (se %p)]
        [%mold-name so]
        [%care (se %tas)]
        [%app (se %tas)]
        [%path pa]
    ==
  ::
  ++  dbug-payload
    ^-  $-(json dbug-payload:zig)
    %-  ot
    :^    [%who (se %p)]
        [%mold-name so]
      [%app (se %tas)]
    ~
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
    :~  [%dojo (ot ~[[%payload dojo-payload] [%expected (ar test-read-step)]])]
        [%poke (ot ~[[%payload poke-payload] [%expected (ar test-read-step)]])]
        [%subscribe (ot ~[[%payload subscribe-payload] [%expected (ar test-read-step)]])]
        [%custom-write (ot ~[[%tag (se %tas)] [%payload so] [%expected (ar test-read-step)]])]
    ==
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
  --
--
