/-  pyro,
    spider
/+  strandio
|%
::
++  take-snapshot
  |=  $:  project-id=@t
          test-id=(unit @ux)
          step=@ud
          snapshot-ships=(list @p)
      ==
  =/  m  (strand:spider ,~)
  ^-  form:m
  ?~  snapshot-ships  (pure:m ~)
  ;<  ~  bind:m
    %+  poke-our:strandio  %pyro
    :-  %action
    !>  ^-  pyro-action:pyro
    :+  %snap-ships
      ?~  test-id  /[project-id]/(scot %ud step)
      /[project-id]/(scot %ux u.test-id)/(scot %ud step)
    snapshot-ships
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
