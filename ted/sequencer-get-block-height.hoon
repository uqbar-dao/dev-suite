/-  spider
/+  strandio
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
|^
;<  =json  bind:m
    ::  TODO FIX! THIS ENDPOINT SUCKS!
    (fetch-json:strandio "https://api.blockcypher.com/v1/eth/main")
(pure:m !>(`@ud`(pars json)))
::
++  pars
  =,  dejs:format
  %-  ot
  :~  [%height ni]
  ==
--