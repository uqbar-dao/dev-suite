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
:: TODO broken
++  reset-ship
  |=  who=ship
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m
    %^  poke-our  %pyro  %pyro-action
    !>([%init-ship who])
  (pure:m ~)
::
++  ue-to-ae
  |=  [who=ship what=(list unix-event)]
  ^-  (list aqua-event)
  %+  turn  what
  |=  ue=unix-event
  [who ue]
::
++  dojo
  |=  [who=ship =tape]
  (send-events (dojo-events who tape))
::
++  dojo-events
  |=  [who=ship =tape]
  %+  ue-to-ae  who
  ^-  (list unix-event)
  :~  [/d/term/1 %belt %mod %ctl `@c`%e]
      [/d/term/1 %belt %mod %ctl `@c`%u]
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
          ?.  ?=(%put -.blit)
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
  ::  TODO move to note-arvo?
  |=  [who=@p v=?(%a %b %c %d %e %g %i %j %k) =task-arvo]
  %-  send-events
  %+  ue-to-ae  who
  ^-  (list unix-event)
  [/[v] task-arvo]~ 
::
++  subscribe
  |=  [who=@p to=@p app=@tas =path]
  (poke who who %subscriber %subscriber-action [%sub to app path])
::
++  park
  |=  [=ship =desk =case]
  ^-  $>(%park task:clay)
  ::
  =/  maps  (park-maps ship desk case)
  =*  path-to-lobe  p.maps
  =*  lobe-to-page  q.maps
  ::
  :^  %park  desk
    ^-  yoki:clay
    :-  %&  ::  yuki:clay
    :-  *(list tako:clay)
    %-  ~(gas by *(map path [%| lobe:clay])) :: lobes hit cache, pages don't
    %+  turn  ~(tap by path-to-lobe)
    |=([=path =lobe:clay] [path %|^lobe])
  `rang:clay``lobe-to-page
::
::  TODO might refactor this back into +park, less code...
++  park-maps
  |=  [=ship =desk =case]
  ^-  (pair (map path lobe:clay) (map lobe:clay page))
  =/  desk-path=path  /(scot %p ship)/[desk]/(scot case)
  =/  =dome:clay  .^(dome:clay %cv desk-path)
  =/  =tako:clay  (~(got by hit.dome) let.dome)
  =/  path-to-lobe  q:.^(yaki:clay %cs (weld desk-path /yaki/(scot %uv tako)))
  :-  path-to-lobe
  %-  ~(gas by *(map lobe:clay page))
  %+  turn  ~(tap by path-to-lobe)
  |=  [=path =lobe:clay]
  ::  TODO: can we scry these out in bulk? Massive speed boost
  [lobe (rear path) .^(* %cx (weld desk-path path))]
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
      (frond -.update (list-ships ships.update))
    ::
        %snap-ships
      (frond -.update (snap-ships [path ships]:update))
    ==
  ::
  ++  fleets
    |=  snap-paths=(list ^path)
    ^-  json
    (frond %snap-paths (list-paths snap-paths))
  ::
  ++  snap-ships
    |=  [p=^path ships=(list @p)]
    ^-  json
    %-  pairs
    :+  [%path (path p)]
      [%ships (list-ships ships)]
    ~
  ::
  ++  list-ships
    |=  ships=(list @p)
    ^-  json
    :-  %a
    %+  turn  ships
    |=(who=@p [%s (scot %p who)])
  ::
  ++  list-paths
    |=  paths=(list ^path)
    ^-  json
    :-  %a
    %+  turn  paths
    |=(p=^path (path p))
  --
::
++  dejs
  =,  dejs:format
  |%
  ++  action
    %-  of
    :~  [%init-ship (se %p)]
        [%kill-ships (ot ~[[%hers (se %p)]])]
        [%snap-ships (ot ~[[%path pa] [%hers (ar (se %p))]])]
        [%restore-snap (ot ~[[%path pa]])]
        [%delete-snap (ot ~[[%path pa]])]
        [%clear-snaps ul]
        [%unpause-ships (ot ~[[%hers (ar (se %p))]])]
        [%pause-ships (ot ~[[%hers (ar (se %p))]])]
        [%wish (ot ~[[%hers (ar (se %p))] [%p so]])]
    ==
  --
--
