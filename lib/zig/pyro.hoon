/-  *pyro,
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
  (poke who who app %subscriber-action [%sub to app path])
--
