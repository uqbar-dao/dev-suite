/-  pyro,
    spider
/+  strandio
|%
::
++  take-snapshot
  |=  $:  step=@ud
          for-snapshot=(unit [project=@t ships=(list @p)])
      ==
  =/  m  (strand:spider ,~)
  ^-  form:m
  ?~  for-snapshot  (pure:m ~)
  =*  project  project.u.for-snapshot
  =*  ships    ships.u.for-snapshot
  ;<  ~  bind:m
    %+  poke-our:strandio  %pyro
    :-  %action
    !>  ^-  pyro-action:pyro
    [%snap-ships /[project]/(scot %ud step) ships]
  (pure:m ~)
::
++  block-on-previous-step
  |=  [loop-duration=@dr done-duration=@dr]
  =/  m  (strand:spider ,~)
  ^-  form:m
  |-
  ;<  is-next-events-empty=?  bind:m
    (scry:strandio ? /gx/pyro/is-next-events-empty/noun)
  ;<  soonest-timer=(unit @da)  bind:m
    (scry:strandio (unit @da) /gx/pyre/soonest-timer/noun)
  ;<  now=@da  bind:m  get-time:strandio
  ?.  is-next-events-empty
    ;<  ~  bind:m  (wait:strandio (add now loop-duration))
    $
  ?~  soonest-timer                                  (pure:m)
  ?:  (lth (add now done-duration) u.soonest-timer)  (pure:m)
  ;<  ~  bind:m  (wait:strandio (add u.soonest-timer 1))  :: TODO: is this a good heuristic or should we wait longer?
  $
--
