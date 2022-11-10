/-  spider
/+  strandio
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
|^
=/  =json  [%o (~(put by *(map @t json)) %height [%n `@ta`'123'])]  ::  TODO: add %iris vane thread and remove this hack
:: ;<  =json  bind:m
::     (fetch-json:strandio "https://api.blockcypher.com/v1/eth/main")
(pure:m !>(`@ud`(pars json)))
::
++  pars
  =,  dejs:format
  %-  ot
  :~  [%height ni]
  ==
--
