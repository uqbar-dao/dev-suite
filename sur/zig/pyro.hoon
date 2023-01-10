::  Traditionally, ovo refers to an ovum -- (pair wire card) -- and ova
::  refers to a list of them.  We have several versions of each of these
::  depending on context, so we do away with that naming scheme and use
::  the following naming scheme.
::
::  Every card is either an `event` or an `effect`.  Prepended to this
::  is `unix` if it has no ship associated with it, or `aqua` if it
::  does.  `timed` is added if it includes the time of the event.
::
::  Short names are simply the first letter of each word plus `s` if
::  it's a list.
::
/+  pill
=,  pill-lib=pill
|%
++  ph-event
  $%  [%test-done p=?]
      aqua-event
  ==
::
+$  unix-event  ::NOTE  like unix-event:pill-lib but for all tasks
  %+  pair  wire
  $%  [%wack p=@]
      [%what p=(list (pair path (cask)))]
      [%whom p=ship]
      [%boot ? $%($>(%fake task:jael) $>(%dawn task:jael))]
      [%wyrd p=vere]
      [%verb p=(unit ?)]
      task-arvo
  ==
+$  pill        pill:pill-lib
::
+$  aqua-event
  $%  [%init-ship who=ship]
      [%event who=ship ue=unix-event]
  ==
::
+$  action
  $%  ::  snapshot pokes
      ::
      [%snap-ships =path hers=(list ship)]
      [%restore-snap =path]
      [%clear-snap =path]
      [%export-snap =path]
      [%import-snap jam-file-path=path snap-label=path]
      [%export-fresh-piers ~]
      [%import-fresh-piers jam-file-path=path]
      [%clear-snaps ~]
      ::  pill
      ::
      [%pill =pill]
      ::  ship management
      ::
      [%swap-files des=@tas]
      [%wish hers=(list ship) p=@t]
      [%remove-ship who=ship]
      [%unpause-events hers=(list ship)]
      [%pause-events hers=(list ship)]  ::  TODO: do we need this at events And 
      [%commit =desk hers=(list ship)]
  ==
::
++  update
  $@  ~
  $%  [%fleet-snap =path has-path=?]
      [%fleets snap-paths=(set path)]
      [%ships ships=(set ship)]
      [%fresh-pier-keys ships=(set ship)]
      [%fleet-sizes =path events=(map ship [events-done=@ud events-qued=@ud])]
      [%events events=(map ship [events-done=@ud events-qued=@ud])]
      [%fleet-ships =path ships=(set ship)]
  ==
::
+$  vane  ?(%a %b %c %d %e %g %i %j %k)
::
+$  aqua-effects
  [who=ship ufs=(list unix-effect)]
::
+$  aqua-effect
  [who=ship ufs=unix-effect]
::
+$  aqua-events
  [who=ship utes=(list unix-timed-event)]
::
+$  aqua-boths
  [who=ship ub=(list unix-both)]
::
+$  unix-both
  $%  [%event unix-timed-event]
      [%effect unix-effect]
  ==
::
+$  unix-timed-event  [tym=@da ue=unix-event]
::
+$  unix-effect
  %+  pair  wire
  $%  ::  vere effects (%gifts) that %pyre can handle
      [%send p=lane:ames q=@]                 ::  ames send packet
      [%doze p=(unit @da)]                    ::  behn set timer
      [%ergo p=@tas q=mode:clay]              ::  clay ???
      [%blit p=(list blit:dill)]              ::  dill console effect
      [%thus p=@ud q=(unit hiss:eyre)]        ::  eyre ???
      [%request id=@ud request=request:http]  ::  iris request
      [%poke-ack p=(unit tang)]               ::  gall agent poke-ack
      ::  pyro specific effects
      [%sleep ~]                              :: reset runtime
      [%restore ~]                            :: restore snap
      [%kill ~]                               :: stop ship
      [%init ~]                               :: start ship
  ==
::
:: TODO this should be a set for multiple timers per ship
+$  behn-pier  next-timer=(unit @da)
+$  iris-pier  http-requests=(set @ud)
::
--
