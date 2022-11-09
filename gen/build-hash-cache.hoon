/+  conq=zink-conq
:-  %say
|=  [[now=@da eny=@uvJ bek=beak] [gas=@ud ~] ~]
::  a good number for gas is 100
=*  our  p.bek
=/  hash-cache-file  .^(* %cx /(scot %p our)/zig/(scot %da now)/lib/zig/sys/hash-cache/noun)
?>  ?=((pair * (pair * @)) hash-cache-file)
=/  smart-txt        .^(@t %cx /(scot %p our)/zig/(scot %da now)/lib/zig/sys/smart/hoon)
=/  hoon-txt         .^(@t %cx /(scot %p our)/zig/(scot %da now)/lib/zig/sys/hoon/hoon)
=/  cax              ;;(cache:conq (cue +.+:;;([* * @] hash-cache-file)))
=/  new              (conq:conq hoon-txt smart-txt cax gas)
~&  >>  "new hash cache size: {<(met 3 (jam new))>}, with {<~(wyt by new)>} items"
[%noun new]