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
++  conq
  |=  [hoonlib-txt=@t smartlib-txt=@t cax=cache bud=@ud]
  ^-  [cax=(map * phash) jetmap=(map @ @tas)]
  |^
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
  ~&  >>  %core-hashing
  ::  =/  con  (slop (slot 2 !>(*contract:smart)) (slop !>(*cart:smart) smartlib))
  =/  [raw=(list [face=term =path]) contract-hoon=hoon]  (parse-pile (trip triv-txt))
  =/  smart-lib=vase  (slap (slap !>(~) (ream hoonlib-txt)) (ream smartlib-txt))
  =/  full=hoon  [%clsg ~]
  =/  full-nock=*  q:(~(mint ut p.smart-lib) %noun full)
  =/  payload=vase  (slap smart-lib full)
  =/  cont  (~(mint ut p:(slop smart-lib payload)) %noun contract-hoon)
  ::
  =/  gun  (~(mint ut p.cont) %noun (ream '~'))
  =/  =book  (zebra bud cax *granary-scry [q.cont q.gun])
  ~&  p.book
  ::
  :-  cax.q.book
  =/  jets
    :~  ::  math  [ADDED TO ZINK]
        %add  %dec  %div  %dvr  %gte  %gth  %lte
        %lth  %max  %min  %mod  %mul  %sub
        ::  tree

        ::  list

        ::  bits

        ::  sets

        ::  maps

        ::  etc  [ADDED TO ZINK]
        %scot
    ==
  %-  ~(gas by *(map @ @tas))
  %+  turn  `(list @tas)`jets
  |=(name=@tas [(arm-axis cont name) name])
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
    =/  n  q:(slot (arm-axis vax t) vax)
    $(lis t.lis, cax (~(put by cax) n (hash n cax)), i +(i))
  ::
  ++  arm-axis
    |=  [vax=vase arm=term]
    ^-  @
    =/  r  (~(find ut p.vax) %read ~[arm])
    ?>  ?=(%& -.r)
    ?>  ?=(%| -.q.p.r)
    p.q.p.r
  --
--
