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
  %-  send-events
  %+  ue-to-ae  who
  ^-  (list unix-event)
  :~  [/d/term/1 %belt %ctl `@c`%e]
      [/d/term/1 %belt %ctl `@c`%u]
      [/d/term/1 %belt %txt ((list @c) tape)]
      [/d/term/1 %belt %ret ~]
  ==
::
++  poke
  |=  $:  who=@p  to=@p
          app=@tas  mark=@tas
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
++  subscribe
  |=  $:  who=@p  to=@p
          app=@tas  =path
      ==
  %-  send-events
  %+  ue-to-ae  who
  ^-  (list unix-event)
  :_  ~
  :*  /g
      %deal  [who who]  %subscriber
      %raw-poke  %noun
      %sub  to  app  path
  ==
--
