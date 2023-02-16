::  We do not use the traditional arvo event naming scheme (ova/ovum).
::  Every card is either an `event` or an `effect`.
::  pyro-events are associated withs ships, unix-events are not
::  'timed' events/effects include the time of the event, used for logs
::
|%
::  like unix-event:pill-lib but for all tasks
::
+$  unix-event
  %+  pair  wire
  $%  :: for boot sequence, see $wisp:arvo
      ::
      [%wack p=@]
      [%what p=(list (pair path (cask)))]
      [%whom p=ship]
      [%wyrd p=vere]
      [%verb p=(unit ?)]
      [%boot ? $%($>(%fake task:jael) $>(%dawn task:jael))]
      ::  for all other inputs
      ::  TODO: should we move to note-arvo instead?
      ::
      task-arvo
  ==
::
+$  unix-timed-event  [tym=@da ue=unix-event]
::
+$  unix-effect
  %+  pair  wire
  $%  ::  vere effects (%gifts) that %pyre can handle
      ::
      [%send p=lane:ames q=@]                 ::  ames send packet
      [%doze p=(unit @da)]                    ::  behn set timer
      [%ergo p=@tas q=mode:clay]              ::  clay ???
      [%blit p=(list blit:dill)]              ::  dill console effect
      [%thus p=@ud q=(unit hiss:eyre)]        ::  eyre ???
      [%response =http-event:http]            ::  eyre response
      [%request id=@ud request=request:http]  ::  iris request
      [%poke-ack p=(unit tang)]               ::  gall agent poke-ack
      ::  pyro specific effect
      ::
      [%kill ~]                               :: stop ship
  ==
::
+$  unix-both
  $%  [%event unix-timed-event]
      [%effect unix-effect]
  ==
::
+$  pyro-event    [who=ship ue=unix-event]
+$  pyro-events   [who=ship utes=(list unix-timed-event)]
+$  pyro-effects  [who=ship ufs=(list unix-effect)]
+$  pyro-effect   [who=ship ufs=unix-effect]
+$  pyro-boths    [who=ship ub=(list unix-both)]
::
+$  action
  $%  ::  create or delete a ship
      ::
      [%init-ship who=ship] :: TODO should this be hers=(list ship)?
      [%kill-ships hers=(list ship)]
      ::  snapshot manipulation
      ::
      [%snap-ships =path hers=(list ship)]
      [%restore-snap =path]
      [%delete-snap =path]
      ::  pausing
      ::
      [%unpause-ships hers=(list ship)]
      [%pause-ships hers=(list ship)]
      ::  see +wish in arvo.hoon
      ::
      [%wish her=ship p=@t]
      ::  inject state into a running gall app
      ::
      [%slap-gall her=ship dap=term =vase]
  ==
::
+$  behn-pier  next-timer=(unit @da)
+$  eyre-pier  cookie=(unit @t)
+$  iris-pier  http-requests=(set @ud)
::
++  update
  $@  ~
  $%  [%snaps snap-paths=(list path)]
      [%snap-ships =path ships=(list ship)]
      [%ships ships=(list ship)]
  ==
--
