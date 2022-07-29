/+  conq=zink-conq
:-  %say
|=  [[now=@da eny=@uvJ bek=beak] [gas=@ud ~] ~]
=*  our        p.bek
=/  hash-cache-file  .^(* %cx /(scot %p our)/zig/(scot %da now)/lib/zig/compiled/hash-cache/noun)
?>  ?=((pair * (pair * @)) hash-cache-file)
=/  smart-txt        .^(@t %cx /(scot %p our)/zig/(scot %da now)/lib/zig/sys/smart/hoon)
=/  hoon-txt         .^(@t %cx /(scot %p our)/zig/(scot %da now)/lib/zig/sys/hoon/hoon)
=/  cax              ;;(cache:conq (cue q.q.hash-cache-file))
:-  %noun
(conq:conq hoon-txt smart-txt cax gas)