/+  *zink-zink, smart=zig-sys-smart, engine=zig-sys-engine
/*  smart-lib-noun  %noun  /lib/zig/sys/smart-lib/noun
/*  triv-txt        %hoon  /con/trivial/hoon
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
++  compile-path
  !.
  |=  pax=path
  ^-  [bat=* pay=*]
  =/  desk=path  (swag [0 3] pax)
  (compile-contract pax desk .^(@t %cx pax))
::
++  compile-contract
  !.
  |=  [pax=path desk=path txt=@t]
  ^-  [bat=* pay=*]
  ::
  ::  goal flow:
  ::  - take main file, parse to find libs
  ::  - for each lib, parse to find any libs there
  ::  - if an import is already present in that stack
  ::    (circular), crash
  ::  - once a file with no imports is reached, (rain ) it
  ::  - compose against this back up the stack
  ::
  ::  old stuff:
  ::
  ::  parse contract code
  =/  [raw=(list [face=term =path]) contract-hoon=hoon]
    (parse-pile pax (trip txt))
  ::  generate initial subject containing uHoon
  =/  smart-lib=vase  ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
  ::  compose libraries against uHoon subject
  =/  libraries=hoon
    :-  %clsg
    %+  turn  raw
    |=  [face=term =path]
    =/  pax  (weld desk path)
    ^-  hoon
    :+  %ktts  face
    =/  lib-txt  .^(@t %cx (welp pax /hoon))
    ::  CURRENTLY IGNORING IMPORTS INSIDE LIBRARIES
    +:(parse-pile pax (trip lib-txt))
  =/  pay=*  q:(~(mint ut p.smart-lib) %noun libraries)
  =/  payload=vase  (slap smart-lib libraries)
  =/  cont
    %+  ~(mint ut p:(slop smart-lib payload))
    %noun  contract-hoon
  ::
  [bat=q.cont pay]
::
++  compile-trivial
  |=  [pax=path hoonlib-txt=@t smartlib-txt=@t]
  ^-  vase
  =/  [raw=(list [face=term =path]) contract-hoon=hoon]
    (parse-pile /con/trivial/hoon (trip triv-txt))
  =/  smart-lib=vase
    ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
  =/  libraries=hoon  [%clsg ~]
  =/  full-nock=*     q:(~(mint ut p.smart-lib) %noun libraries)
  =/  payload=vase    (slap smart-lib libraries)
  ::
  (slap (slop smart-lib payload) contract-hoon)
::
++  conq
  |=  [pax=path hoonlib-txt=@t smartlib-txt=@t cax=cache bud=@ud]
  ^-  (map * phash)
  |^
  =.  cax
    %-  ~(gas by cax)
    %+  turn  (gulf 0 12)
    |=  n=@
    ^-  [* phash]
    [n (hash n ~)]
  ~&  >>  %compiling
  =/  built-contract  (compile-trivial pax hoonlib-txt smartlib-txt)
  ~&  >>  %hashing-arms
  =.  cax
    %^  cache-file  built-contract
      cax
    :~  ::  hoon
        ::  four layers
        'add'
        'biff'
        'egcd'
        'po'
        ::  inner layers
        'dif:fe'
        'all:in'
        'all:by'
        'get:ja'
        'del:ju'
        'apt:to'
        'le:nl'
        'abs:si'
        'sb:ff'
        ::  smart
        ::  five layers
        'pedersen'
        'hash'
        'ship'
        'id'
        'big'
        ::  inner layers (reverse order)
        'as-octs:secp:crypto'
        'hmac-sha1:hmac:crypto'
        'keccak-224:keccak:crypto'
        'as:crub:crypto'
        'sal:scr:crypto'
        'ahem:aes:crypto'
        'aes:crypto'
        'as-octs:mimes:html'
        'mimes:html'
        'fu:number'
        'pass:ames'
        'hash:pedersen'
        't:pedersen'
        ::  'bif:bi'
        'frond:enjs:format'
    ==
  ~&  >>  %hashing-trivial-core
  ::
  ::  =/  [raw=(list [face=term =path]) contract-hoon=hoon]  (parse-pile /con/trivial/hoon (trip triv-txt))
  ::  =/  smart-lib=vase  ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
  ::  =/  libraries=hoon  [%clsg ~]
  ::  =/  full-nock=*  q:(~(mint ut p.smart-lib) %noun libraries)
  ::  =/  payload=vase  (slap smart-lib libraries)
  ::  =/  cont  (~(mint ut p:(slop smart-lib payload)) %noun contract-hoon)
  ::  ::
  ::  =/  gun  (~(mint ut p.cont) %noun (ream '~'))
  ::  =/  =book  (zebra bud cax *chain-state-scry [q.cont q.gun] %.n)
  ::  ~&  p.book
  ::  cax.q.book
  ::
  =/  smart-lib=vase  ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
  =/  code=[bat=* pay=*]  (compile-contract /con/trivial/hoon /zig triv-txt)
  =/  cor  .*([q.smart-lib pay.code] bat.code)
  =/  dor  [-:!>(*contract:smart) cor]
  =/  gun  (ajar:engine dor %write !>(*context:smart) !>(*calldata:smart) %$)
  =/  =book  (zebra bud cax jets *chain-state-scry gun %.n)
  ~&  p.book
  cax.q.book
  ::
  ++  cache-file
    |=  [vax=vase cax=cache layers=(list @t)]
    ^-  cache
    |-
    ?~  layers
      cax
    =/  cor  (slap vax (ream (cat 3 '..' i.layers)))
    =/  min  (~(mint ut p.vax) %noun (ream (cat 3 '..' i.layers)))
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
  --
::  conq helpers
++  arm-axis
  |=  [vax=vase arm=term]
  ^-  @
  =/  r  (~(find ut p.vax) %read ~[arm])
  ?>  ?=(%& -.r)
  ?>  ?=(%| -.q.p.r)
  p.q.p.r
::
::  parser helpers
::
+$  small-pile
    $:  raw=(list [face=term =path])
        =hoon
    ==
+$  taut  [face=(unit term) pax=term]
++  parse-pile
  !.
  |=  [pax=path tex=tape]
  ^-  small-pile
  =/  [=hair res=(unit [=small-pile =nail])]  ((pile-rule pax) [1 1] tex)
  ?^  res  small-pile.u.res
  %-  mean  %-  flop
  =/  lyn  p.hair
  =/  col  q.hair
  =/  lyns=wain  (to-wain:format (crip tex))
  =/  prev-lyn=@ud  (dec lyn)
  ?:  (gth (lent lyns) prev-lyn)
    :~  leaf+"syntax error at [{<lyn>} {<col>}] in {<`path`(slag 3 pax)>}"
        leaf+(runt [(dec col) '-'] "^")
        leaf+(trip (snag prev-lyn lyns))
    ==
  :~  leaf+"syntax error at [{<lyn>} {<col>}] in {<`path`(slag 3 pax)>}"
      leaf+"file missing a terminator"
  ==
++  pile-rule
  |=  pax=path
  %-  full
  %+  ifix
    :_  gay
    ::  parse optional smart library import and ignore
    ;~(plug gay (punt ;~(plug fas lus gap taut-rule gap)))
  ;~  plug
  ::  only accept /= imports for contract libraries
    %+  rune  tis
    ;~(plug sym ;~(pfix gap stap))
  ::
    %+  stag  %tssg
    (most gap tall:(vang & (slag 3 pax)))
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
++  taut-rule
  %+  cook  |=(taut +<)
  ;~  pose
    (stag ~ ;~(pfix tar sym))
    ;~(plug (stag ~ sym) ;~(pfix tis sym))
    (cook |=(a=term [`a a]) sym)
  ==
::
::  abbreviated parser from lib/zink/conq.hoon:
::   parse to end of imports, start of hoon.
::   used to find start of hoon for compilation and to find
::   proper line error number in case of error
::   (see +mule-slap-subject)
::
+$  small-start-of-pile  (list [face=term =path])
::
++  parse-start-of-pile
  |=  tex=tape
  ^-  [small-start-of-pile hair]
  =/  [=hair res=(unit [=small-start-of-pile =nail])]
    (start-of-pile-rule [1 1] tex)
  ?^  res  [small-start-of-pile.u.res hair]
  %-  mean  %-  flop
  =/  lyn  p.hair
  =/  col  q.hair
  :~  leaf+"syntax error"
      leaf+"\{{<lyn>} {<col>}}"
      leaf+(runt [(dec col) '-'] "^")
      leaf+(trip (snag (dec lyn) (to-wain:format (crip tex))))
  ==
::
++  start-of-pile-rule
  %+  ifix
    :_  gay
    ::  parse optional smart library import and ignore
    ;~(plug gay (punt ;~(plug fas lus gap taut-rule:conq gap)))
  ;~  plug
  ::  only accept /= imports for contract libraries
    %+  rune:conq  tis
    ;~(plug sym ;~(pfix gap stap))
  ==
--
