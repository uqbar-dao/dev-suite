/-  *zig-pyro,
    spider
/+  *strandio
::
=*  strand    strand:spider
::
|%
++  send-events
  |=  events=(list aqua-event)
  =/  m  (strand ,~)
  ^-  form:m
  (poke-our %pyro %aqua-events !>(events))
::
++  take-unix-effect
  =/  m  (strand ,[ship unix-effect])
  ^-  form:m
  ;<  [=path =cage]  bind:m  (take-fact-prefix /effect)
  ?>  ?=(%aqua-effect p.cage)
  (pure:m !<([aqua-effect] q.cage))
::
++  reset-ships
  |=  hers=(list ship)
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m
    %^  poke-our  %pyro  %pyro-action
    !>([%kill-ships hers])
  ;<  ~  bind:m
    %^  poke-our  %pyro  %aqua-events
    !>((zing (turn hers |=(=ship [%event ship %init-ship ~]~))))
  (pure:m ~)
::
++  ue-to-ae
  |=  [who=ship what=(list unix-event)]
  ^-  (list aqua-event)
  %+  turn  what
  |=  ue=unix-event
  [%event who ue]
::
++  dojo
  |=  [who=ship =tape]
  (send-events (dojo-events who tape))
::
++  dojo-events
  |=  [who=ship =tape]
  %+  ue-to-ae  who
  ^-  (list unix-event)
  :~  [/d/term/1 %belt %ctl `@c`%e]
      [/d/term/1 %belt %ctl `@c`%u]
      [/d/term/1 %belt %txt ((list @c) tape)]
      [/d/term/1 %belt %ret ~]
  ==
::
++  wait-for-output
  |=  [=ship =tape]
  =/  m  (strand ,~)
  ^-  form:m
  ~&  >  "waiting for output: {tape}"
  |-  ^-  form:m
  ;<  [her=^ship uf=unix-effect]  bind:m  take-unix-effect
  ?:  ?&  =(ship her)
          ?=(%blit -.q.uf)
        ::
          %+  lien  p.q.uf
          |=  =blit:dill
          ?.  ?=(%lin -.blit)
            |
          !=(~ (find tape p.blit))
      ==
    (pure:m ~)
  $
::
++  poke
  |=  $:  who=@p
          to=@p
          app=@tas
          mark=@tas
          payload=*
      ==
  %-  send-events
  %+  ue-to-ae  who
  ^-  (list unix-event)
  :_  ~
  :*  /g
      %deal  [who to]  app
      %raw-poke  mark  payload
  ==
::
++  task
  |=  [who=@p =care:clay =task-arvo]
  %-  send-events
  %+  ue-to-ae  who
  ^-  (list unix-event)
  [[care]~ task-arvo]~ 
::
++  subscribe
  |=  [who=@p to=@p app=@tas =path]
  (poke who who %subscriber %subscriber-action [%sub to app path])
::
++  park
  |=  [=ship =desk =case]
  ^-  $>(%park task:clay)
  =*  page  page:clay
  =*  lobe  lobe:clay
  =*  dome  dome:clay
  =*  tako  tako:clay
  ::
  =/  desk-path  /(scot %p ship)/[desk]/(scot case)
  =/  =dome  .^(dome:clay %cv desk-path)
  =/  =tako  (~(got by hit.dome) let.dome)
  =/  pol=(map path lobe)
    q:.^(yaki:clay %cs (weld desk-path /yaki/(scot %uv tako)))
  ::
  :*  %park  desk
      ^-  yoki:clay
      :-  %&
      ^-  yuki:clay
      :-  *(list tako:clay)
      %-  ~(gas by *(map path [%| lobe])) :: lobes hit cache, pages don't
      %+  turn  ~(tap by pol)
      |=  [=path =lobe]
      [path %|^lobe]
  ::
      ^-  rang:clay
      :-  *(map tako:clay yaki:clay)
      %-  ~(gas by *(map lobe page))
      %+  turn  ~(tap by pol)
      |=  [=path =lobe]
      :: TODO: can we scry these out in bulk? Massive speed boost
      [lobe (rear path) .^(* %cx (weld desk-path path))]
  ==
::
++  enjs
  =,  enjs:format
  |%
  ++  update
    |=  =^update
    ^-  json
    ?~  update  ~
    ?-    -.update
        %snaps
      (frond -.update (fleets snap-paths.update))
    ::
        %ships
      (frond -.update (set-ships ships.update))
    ::
        %fresh-piers
      (frond -.update (frond %ships (set-ships ships.update)))
    ::
        %snap-ships
      (frond -.update (snap-ships [path ships]:update))
    ==
  ::
  ++  fleets
    |=  snap-paths=(set ^path)
    ^-  json
    (frond %snap-paths (set-paths snap-paths))
  ::
  ++  snap-ships
    |=  [p=^path ships=(set @p)]
    ^-  json
    %-  pairs
    :+  [%path (path p)]
      [%ships (set-ships ships)]
    ~
  ::
  ++  set-ships
    |=  ships=(set @p)
    ^-  json
    :-  %a
    %+  turn  ~(tap in ships)
    |=(who=@p [%s (scot %p who)])
  ::
  ++  set-paths
    |=  paths=(set ^path)
    ^-  json
    :-  %a
    %+  turn  ~(tap in paths)
    |=(p=^path (path p))
  --
::
++  dejs
  =,  dejs:format
  |%
  ++  action
    %-  of
    :~  [%remove-ship (ot ~[[%who (se %p)]])]
        [%snap-ships (ot ~[[%path pa] [%hers (ar (se %p))]])]
        [%restore-snap (ot ~[[%path pa]])]
        [%clear-snap (ot ~[[%path pa]])]
        [%export-snap (ot ~[[%path pa]])]
        [%import-snap (ot ~[[%jam-file-path pa] [%snap-label pa]])]
        [%export-fresh-piers ul]
        [%import-fresh-piers (ot ~[[%jam-file-path pa]])]
        [%clear-snaps ul]
        :: [%pill ]
        [%swap-files (ot ~[[%des (se %tas)]])]
        [%wish (ot ~[[%hers (ar (se %p))] [%p so]])]
        [%unpause-events (ot ~[[%hers (ar (se %p))]])]
        [%pause-events (ot ~[[%hers (ar (se %p))]])]
    ==
  --
--
