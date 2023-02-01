|%
++  make-resub
  |=  our=ship
  %-  zing
  %+  turn
  :~  [/ames/send /effect/send]
      [/behn/doze /effect/doze]
      [/dill/blit /effect/blit]
      [/eyre/response /effect/response]
      [/iris/request /effect/request]
  ::
      [/behn/kill /effect/kill]
      [/iris/kill /effect/kill]
  ==
  |=  [=wire =path]
  :~  [%pass wire %agent [our %pyro] %leave ~]
      [%pass wire %agent [our %pyro] %watch path]
  ==
::
++  parse-url
  |=  url=tape
  ^-  [ship cord]
  ::  format must be /pyro/~sampel-palnet/...
  =.  url  (slag 6 url)  :: cutting off /pyro/
  =/  sit  (find "/" url)
  ?~  sit  [(slav %p (crip url)) '']
  :-  (slav %p (crip (scag u.sit url)))
  (crip (slag u.sit url))
--