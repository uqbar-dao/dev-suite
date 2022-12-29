/-  *zig-pyro,
    spider
/+  strandio
::
=*  strand    strand:spider
=*  poke-our  poke-our:strandio
::
|%
++  send-events
  |=  events=(list aqua-event)
  =/  m  (strand ,~)
  ^-  form:m
  (poke-our %pyro %aqua-events !>(events))
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
  |=  [who=@p =vane =task-arvo]
  %-  send-events
  %+  ue-to-ae  who
  ^-  (list unix-event)
  [[vane]~ task-arvo]~ 
::
++  subscribe
  |=  [who=@p to=@p app=@tas =path]
  (poke who who %subscriber %subscriber-action [%sub to app path])
::
++  enjs
  =,  enjs:format
  |%
  ++  update
    |=  =^update
    ^-  json
    ?-    -.update
        %fleet-snap
      (frond -.update (fleet-snap [path has-path]:update))
    ::
        %fleets
      (frond -.update (fleets snap-paths.update))
    ::
        %ships
      (frond -.update (set-ships ships.update))
    ::
        %fresh-pier-keys
      (frond -.update (frond %ships (set-ships ships.update)))
    ::
        %fleet-sizes
      (frond -.update (events events.update))
    ::
        %events
      (events events.update)
    ::
        %fleet-ships
      (frond -.update (fleet-ships [path ships]:update))
    ==
  ::
  ++  fleet-snap
    |=  [p=^path has-path=?]
    ^-  json
    %-  pairs
    :+  [%path (path p)]
      [%has-path [%b has-path]]
    ~
  ::
  ++  fleets
    |=  snap-paths=(set ^path)
    ^-  json
    (frond %snap-paths (set-paths snap-paths))
  ::
  ++  events
    |=  events=(map @p [events-done=@ud events-qued=@ud])
    ^-  json
    %+  frond  %events
    %-  pairs
    %+  turn  ~(tap by events)
    |=  [who=@p events-done=@ud events-qued=@ud]
    :-  (scot %p who)
    %-  pairs
    :+  [%events-done (numb events-done)]
      [%events-qued (numb events-qued)]
    ~
  ::
  ++  fleet-ships
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
