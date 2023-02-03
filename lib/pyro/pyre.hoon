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
  =.  url  (slag 6 url)  :: cutting off "/pyro/"
  ?~  loc=(find "/" url)  [(slav %p (crip url)) '']
  :-  (slav %p (crip (scag u.loc url))) :: ~nec
  (crip (slag u.loc url)) :: has /pyro/~nec cut off
::
++  has-cookie
  |=  hed=header-list:http
  |-  ^-  (unit @t)
  ?~  hed  ~
  ?:  =('set-cookie' key.i.hed)
    `value.i.hed
  $(hed t.hed)
::
++  parse-headers
  |=  =header-list:http
  ^-  header-list:http
  %+  murn  header-list
  |=  [key=@t value=@t]
  ?+  key  `[key value]
    %content-length  ~
    %set-cookie      ~
    %location  `[key (crip (weld "/pyro/~nec" (trip value)))]
  == 
--