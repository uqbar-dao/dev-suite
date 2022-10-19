::  Scry an agent inside of a pyro ship
::  Usage: +zig!pyro/scry ~dev %sequencer /status/noun
::
/-  pyro
=,  pyro
:-  %say
|=  [[now=@da * =beak] [her=ship app=@tas =path ~] ~]
:-  %noun
.^  noun
    %gx
    %+  weld
      :~  (scot %p p.beak)  %pyro  (scot %da now)  ::  /=pyro=
          %i  (scot %p her)  %gx                   ::  /i/~dev/gx
          (scot %p her)  app  (scot %da *@da)      ::  /=sequencer=
      ==
    (weld path /noun)
==
