/-  *pyro,
    spider
/+  strandio
::
=*  strand    strand:spider
=*  poke-our  poke-our:strandio
::
|%
++  send-events-to
  |=  [who=ship what=(list unix-event)]
  ^-  (list aqua-event)
  %+  turn  what
  |=  ue=unix-event
  [%event who ue]
::
++  dojo-events
  |=  [who=ship what=tape]
  ^-  (list aqua-event)
  %+  send-events-to  who
  ^-  (list unix-event)
  :~
    [/d/term/1 %belt %ctl `@c`%e]
    [/d/term/1 %belt %ctl `@c`%u]
    [/d/term/1 %belt %txt ((list @c) what)]
    [/d/term/1 %belt %ret ~]
  ==
::
++  send-events
  |=  events=(list aqua-event)
  =/  m  (strand ,~)
  ^-  form:m
  (poke-our %pyro %aqua-events !>(events))
::
++  dojo
  |=  [=ship =tape]
  =/  m  (strand ,~)
  ^-  form:m
  :: ~&  >  "dojo: {tape}"
  (send-events (dojo-events ship tape))
--
