::  Usage: :pyro|dojo ~dev "|start %zig %sequencer"
::
/-  aquarium
=,  aquarium
:-  %say
|=  [* [her=ship command=tape ~] ~]
:-  %aqua-events
%+  turn
  ^-  (list unix-event)
  :~  [/d/term/1 %belt %ctl `@c`%e]
      [/d/term/1 %belt %ctl `@c`%u]
      [/d/term/1 %belt %txt ((list @c) command)]
      [/d/term/1 %belt %ret ~]
  ==
|=  ue=unix-event
[%event her ue]
