|%
::
++  en-vase
  |=  [typ=type arg=*]
  ^-  json
  ?-    typ
      %void
    !!
      %noun
    !!  ::  (en-noun arg)
  ::
      [%atom *]
    ~&  >  typ
    (en-dime p.typ ;;(@ arg))
  ::
      [%cell *]
    ~&  >  typ
    =/  hed=json  $(typ p.typ, arg -.arg)
    =/  tal=json  $(typ q.typ, arg +.arg)
    ::
    ?~  hed  tal
    ?:  ?=([%a *] tal)
      [%a hed p.tal]
    ::
    ?~  tal  [%a hed ~]
    [%a hed tal ~]
  ::
      [%core *]
    !!
  ::
      [%face *]
    ~&  >  typ
    ::  use face as key in json dict
    [%o `(map @t json)`[[;;(@t p.typ) $(typ q.typ)] ~ ~]]
  ::
      [%fork *]
    ~&  >  typ
    ::  determine unit, list, set, map, here
    =/  lis  (mule |.((levi -:!>(*(list)) typ)))
    ?:  ?=(%& -.lis)
      =/  se  (mule |.((levi -:!>(*(tree)) typ)))
      ?:  ?=(%& -.se)
        ::  it's a tree of some kind
        =/  stri  ~(ram re (skol typ))
        [%o `(map @t json)`[['tree' [%s (crip (swag [5 (sub (lent stri) 6)] stri))]] ~ ~]]
      :: it's a list
      =/  stri  ~(ram re (skol typ))
      [%o `(map @t json)`[['list' [%s (crip (swag [5 (sub (lent stri) 6)] stri))]] ~ ~]]
    =/  un  (mule |.((levi -:!>(*(unit)) typ)))
    ?:  ?=(%& -.un)
      ::  it's a unit
      =/  stri  ~(ram re (skol typ))
      [%o `(map @t json)`[['unit' [%s (crip (swag [2 (sub (lent stri) 3)] stri))]] ~ ~]]
    ::  it's an unknown
    [%o `(map @t json)`[['unknown' [%s (crip ~(ram re (skol typ)))]] ~ ~]]
  ::
      [%hint *]
    ::  ignore hints
    $(typ q.typ)
  ::
      [%hold *]
    ::  step into lazy eval
    $(typ (~(play ut p.typ) q.typ))
  ==
::  +peel: recursively unwrap type
::
++  peel
  |=  [typ=type]
  =|  [cos=(unit term)]
  ^-  type
  |-   =*  loop  $
  ?+  typ  typ
    [%atom *]  ?~  cos  typ  ;;(type [%face u.cos typ])
    ::
    %void      !!
    ::
    [%cell *]
      ?^  cos
        =/  coll  [%cell loop(typ p.typ) loop(typ q.typ)]
        ;;(type [%face u.cos coll])
      [%cell loop(typ p.typ) loop(typ q.typ)]
    ::
    [%face *]
      ?~  cos  q.typ
      ?:  =(-.q.typ %hold)  loop(typ q.typ)
      loop(typ q.typ, cos ~)
    ::
    [%hint *]
      =/  =note  q.p.typ
      ?+    -.note  loop(typ q.typ)
          %made
        ?^  q.note  loop(typ q.typ)
        ::  disable for now, too slow
        loop(typ q.typ, cos ~)
      ==
    ::
    [%hold *]  loop(typ (~(play ut p.typ) q.typ))
  ==
::
++  en-noun
  |=  arg=*
  ^-  json
   ?@  arg
     %+  frond:enjs:format  ;;(@t arg)  ~
   [%a ~[$(arg -.arg) $(arg +.arg)]]
::
++  en-dime
  |=  [aura=@tas dat=@]
  ^-  json
  ~&  >>  [aura dat]
  s+(crip (weld "@" (trip `@t`aura)))
--