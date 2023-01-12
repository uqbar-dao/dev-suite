::  Traditionally, ovo refers to an ovum -- (pair wire card) -- and ova
::  refers to a list of them.  We have several versions of each of these
::  depending on context, so we do away with that naming scheme and use
::  the following naming scheme.
::
::  Every card is either an `event` or an `effect`.  Prepended to this
::  is `unix` if it has no ship associated with it, or `aqua` if it
::  does.  `timed` is added if it includes the time of the event.
::
|%
::
+$  unix-event  :: like unix-event:pill-lib but for all tasks
  %+  pair  wire
  $%  [%wack p=@]
      [%what p=(list (pair path (cask)))]
      [%whom p=ship]
      [%boot ? $%($>(%fake task:jael) $>(%dawn task:jael))]
      [%wyrd p=vere]
      [%verb p=(unit ?)]
      task-arvo
  ==
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
      [%delete-snap =path]
      [%clear-snaps ~]
      ::  snapshot import/exports
      ::
      [%export-snap =path]
      [%import-snap jam-file-path=path snap-label=path]
      [%export-fresh-piers ~]
      [%import-fresh-piers jam-file-path=path]
      ::  ship management
      ::
      [%swap-files des=@tas]
      [%wish hers=(list ship) p=@t]
      [%kill-ships hers=(list ship)]
      [%unpause-events hers=(list ship)]
      [%pause-events hers=(list ship)]  ::  TODO: do we need this at events And 
      [%commit =desk hers=(list ship)]
  ==
::
++  update
  $@  ~
  $%  [%snaps snap-paths=(set path)]
      [%snap-ships =path ships=(set ship)]
      [%ships ships=(set ship)]
      [%fresh-piers ships=(set ship)]
  ==
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
+$  behn-pier  next-timer=(unit @da)
+$  iris-pier  http-requests=(set @ud)
::
--
