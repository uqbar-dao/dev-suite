/+  *zink-zink, smart=zig-sys-smart
/*  triv-contract   %noun  /lib/zig/compiled/trivial/noun
/*  triv-txt        %hoon  /lib/zig/contracts/trivial/hoon
|%
::
++  hash
  |=  [n=* cax=cache]
  ^-  phash
  ?@  n
    ?:  (lte n 12)
      =/  ch  (~(get by cax) n)
      ?^  ch  u.ch
      (hash:pedersen n 0)
    (hash:pedersen n 0)
  ?^  ch=(~(get by cax) n)
    u.ch
  =/  hh  $(n -.n)
  =/  ht  $(n +.n)
  (hash:pedersen hh ht)
::
++  build
  |=  [hoonlib-txt=@t smartlib-txt=@t]
  ^-  vase
  ~&  >>  %building
  =/  [raw=(list [face=term =path]) contract-hoon=hoon]  (parse-pile (trip triv-txt))
  =/  smart-lib=vase  (slap (slap !>(~) (ream hoonlib-txt)) (ream smartlib-txt))
  =/  full=hoon  [%clsg ~]
  =/  full-nock=*  q:(~(mint ut p.smart-lib) %noun full)
  =/  payload=vase  (slap smart-lib full)
  (~(mint ut p:(slop smart-lib payload)) %noun contract-hoon)
::
++  conq
  |=  [hoonlib-txt=@t smartlib-txt=@t cax=cache bud=@ud]
  ^-  cax=(map * phash)
  =.  cax
    %-  ~(gas by cax)
    %+  turn  (gulf 0 12)
    |=  n=@
    ^-  [* phash]
    [n (hash n ~)]
  ~&  >>  %compiling-hoon
  =/  hoonlib   (slap !>(~) (ream hoonlib-txt))
  ~&  >>  %compiling-smart
  =/  smartlib  (slap hoonlib (ream smartlib-txt))
  ~&  >>  %hashing-hoon-arms
  =.  cax
    %^  cache-file  hoonlib
      cax
    :~  'add'
        'biff'
        'egcd'
        'po'
    ==
  ~&  >>  %hashing-smart-arms
  =.  cax
    %^  cache-file  smartlib
      cax
    :~  'pedersen'
        'merk'
        'ship'
        'id'
        'husk'
    ==
  ::
  =/  cont  (build hoonlib-txt smartlib-txt)
  =/  gun  (~(mint ut p.cont) %noun (ream '~'))
  =/  =book  (zebra bud cax *granary-scry [q.cont q.gun])
  ~&  p.book
  cax.q.book
::
+$  jet-path
  $@  @tas
  (list @tas)
::
++  get-jets
  |=  [hoonlib-txt=@t smartlib-txt=@t]
  ^-  (list [@ wing])
  =/  cont  (build hoonlib-txt smartlib-txt)
  =/  looking-for=(list wing)
  :~  ::  math  [ADDED TO ZINK]
      ::  %add  %dec  %div  %dvr  %gte  %gth  %lte
      ::  %lth  %max  %min  %mod  %mul  %sub
      ::  ::  tree
      ::  %cap  %mas  %peg
      ::  ::  unit
      ::  %need
      ::  ::  list  [ADDED: lent]
      ::  %fand  %find  %flop  %lent  %levy  %lien
      ::  %murn  %oust  %reap  %rear  %reel  %roll
      ::  %scag  %skid  %skim  %skip  %slag  %snag
      ::  %snip  %sort  %spin  %spun  %turn  %weld
      ::  %snap  %into  %welp  %zing
      ::  ::  bits
      ::  %bex  %can  %cat  %cut  %end  %fil  %lsh
      ::  %met  %rap  %rep  %rev  %rip  %rsh  %run
      ::  %rut  %sew  %swp  %xeb
      ::  ::
      ::  %con  %dis  %mix  
      ::  ::  mug, noun ordering
      ::  %mug  %aor  %dor  %gor  %mor
      ::  ::  powers
      ::  %pow  %sqt
      ::  sets  (how to get stuff inside jet-door?)
      ::  maps
      ::  etc  [ADDED TO ZINK]
      ::  ~[%scot]
      ~[%in]  ::  716.782
      ::  ~[%all [%& 716.782]]   ::  2.398?
    ==
  %+  turn  looking-for
  |=(=wing [(arm-axis cont wing) wing])
::
::
::  parser helpers
::
+$  small-pile
    $:  raw=(list [face=term =path])
        =hoon
    ==
++  parse-pile
  |=  tex=tape
  ^-  small-pile
  =/  [=hair res=(unit [=small-pile =nail])]  (pile-rule [1 1] tex)
  ?^  res  small-pile.u.res
  %-  mean  %-  flop
  =/  lyn  p.hair
  =/  col  q.hair
  :~  leaf+"syntax error at [{<lyn>} {<col>}]"
      leaf+(runt [(dec col) '-'] "^")
      leaf+(trip (snag (dec lyn) (to-wain:format (crip tex))))
  ==
++  pile-rule
  %-  full
  %+  ifix  [gay gay]
  ;~  plug
    %+  rune  tis
    ;~(plug sym ;~(pfix gap stap))
  ::
    %+  stag  %tssg
    (most gap tall:vast)
  ==
++  rune
  |*  [bus=rule fel=rule]
  %-  pant
  %+  mast  gap
  ;~(pfix fas bus gap fel)
++  pant
  |*  fel=rule
  ;~(pose fel (easy ~))
++  mast
  |*  [bus=rule fel=rule]
  ;~(sfix (more bus fel) bus)
::
++  cache-file
  |=  [vax=vase cax=cache layers=(list @t)]
  ^-  cache
  |-
  ?~  layers
    cax
  =/  cor  (slap vax (ream (cat 3 '..' i.layers)))
  ~&  >>  i.layers
  $(layers t.layers, cax (hash-arms cor cax))
::
++  hash-arms
  |=  [vax=vase cax=(map * phash)]
  ^-  (map * phash)
  =/  lis  (sloe p.vax)
  =/  len  (lent lis)
  =/  i  1
  |-
  ?~  lis  cax
  =*  t  i.lis
  ~&  >  %-  crip
         %-  zing
         :~  (trip t)
             (reap (sub 20 (met 3 t)) ' ')
             (trip (rap 3 (scot %ud i) '/' (scot %ud len) ~))
         ==
  =/  n  q:(slot (arm-axis vax ~[t]) vax)
  $(lis t.lis, cax (~(put by cax) n (hash n cax)), i +(i))
::
++  arm-axis
  |=  [vax=vase arm=wing]
  ^-  @
  =/  r=port  (~(find ut p.vax) %read arm)
  ?>  ?=(%& -.r)
  ?>  ?=(%| -.q.p.r)
  p.q.p.r
--
