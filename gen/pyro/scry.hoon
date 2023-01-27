::  Scry into a pyro ship
::  Usage: +zig!pyro/scry json /~dev/gx/sequencer/status/noun/noun
::  Note:  double /mark needed at the end of %gx scries, e.g. /noun/noun
::  TODO:  for some reason the mold doesn't work: json prints as noun
::
:-  %say
|=  [[now=@da * =beak] [=mold =path ~] ~]
:-  %noun
?>  ?=([@ @ @ ^] path) :: her/care/path
=*  her   i.path
=*  care  i.t.path
=*  app   i.t.t.path
=*  paf   t.t.t.path
.^  mold
    %gx
    %-  zing
    :~  /(scot %p p.beak)/pyro/(scot %da now)  ::  /=pyro=
        /i/[her]/[care]                        ::  /i/~dev/gx
        /[her]/[app]/(scot %da *@da)           ::  /=sequencer=
        paf                                    ::  /status/noun/noun
    ==
==
