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
