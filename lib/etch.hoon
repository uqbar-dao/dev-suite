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
    [%o `(map @t json)`[[;;(@t p.typ) $(typ q.typ)] ~ ~]]
  ::
      [%fork *]
    ~&  >  typ
    =/  tyz=(list type)  (turn ~(tap in p.typ) peel)
    =.  tyz
      %-  zing
      %+  turn  tyz
      |=  tep=type
      ^-  (list type)
      ?:(?=(%fork -.tep) ~(tap in p.tep) ~[tep])
    ::
    ?:  =(1 (lent tyz))
      $(typ (head tyz))
    ::  $?
    ::
    ?:  (levy tyz |=([t=type] ?=(%atom -.t)))
      =/  aura
      ::
        =/  hid  (head tyz)
        ?>(?=([%atom @ *] hid) p.hid)
      ?>  (levy tyz |=([t=type] ?>(?=([%atom * *] t) =(aura p.t))))
      (en-dime aura ;;(@ arg))
    ::  $%
    ::
    ?:  (levy tyz |=([t=type] ?=([%cell [%atom * ^] *] t)))
      =/  aura
        =/  hid  (head tyz)
        ?>(?=([%cell [%atom @ ^] *] hid) p.p.hid)
      ::
      =/  hid  (head tyz)
      =/  val  ;;(@ -.arg)
      ?>  ((sane aura) val)
      ::
      =/  tag  ?:(?=(?(%t %ta %tas) aura) val (scot aura val))
      =/  tin=type
        |-
        ^-  type
        ?~  tyz  !!
        =/  ty=type  i.tyz
        ?>  ?=([%cell [%atom @ ^] *] ty)
        ?:  =(val u.q.p.ty)  q.ty
        $(tyz t.tyz)
      %+  frond:enjs:format  tag  $(typ tin, arg +.arg)
    ::  non-$% fork of cells
    ::
    ?:  (levy tyz |=([t=type] ?=([%cell *] t)))
      ~|  cell-fork/tyz
      ~!  tyz  !!
    ::  $@
    ::
    =/  [atoms=(list type) cells=(list type)]
      (skid tyz |=([t=type] ?=(%atom -.t)))
    ?@  arg
      $(p.typ (sy atoms))
    $(p.typ (sy cells))
  ::
      [%hint *]
    ~&  >  typ
    $(typ q.typ)
  ::
      [%hold *]
    ~&  >  typ
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