::  A jold is a json-mold.
::  A jace is a json-face.
::  Take a jold and a piece of data of the proper shape
::  and give back json with the data properly jolded.
::  For example, in the trivial case
::    jold -> [%o p={[p=%foo q=[%s p='ud']]}]
::    data -> 5
::  the result should be
::    json -> [%o p={[p=%foo q=[%n p=5]]}]
::  because the object represents a number with a face,
::  i.e. foo=5.
::
::  Specification of jolds:
::  1. Top level is always an array (%a) of objects (%o) (i.e. a Hoon tuple).
::  2. Objects (%o) contain a single key-value pair.
::     An object represents a face and a type: the key is the face, the value is the type.
::     The type may be a string (%s) or an array (%a).
::  3. Arrays may contain either objects or strings+arrays.
::     An array containing objects contains only objects.
::     An array containing strings may also contain arrays.
::     An array containing strings+arrays will always start with a string.
::     a. If the array contains objects, it represents a Hoon tuple.
::     b. If the array contains strings+arrays, it represents a multi-word type.
::        Arrays here are Hoon tuples.
::  4. Multiword types are, e.g.,
::     ```
::     ["unit", "ud"]
::     ["map", "tas", "ux"]
::     ["list", "map", "tas", "set", "ux"]
::     ["list", [{"to": "ux"}, {"amount": "ud"}]]
::     ```
::
|%
::  jold of full tuple
++  jold-full-tuple
  |=  [jolds=json data=*]
  ^-  json
  ?.  ?=(%a -.jolds)  [%s (crip (noah !>(data)))]
  =|  jout=(list json)
  |-
  ?~  p.jolds  [%a (flop jout)]
  ?.  ?=(%o -.i.p.jolds)  [%s (crip (noah !>(data)))]
  =/  is-last=?  =(1 (lent p.jolds))
  =*  datum      ?:(is-last data -.data)
  =*  next-data  ?:(is-last ~ +.data)
  %=  $
      p.jolds  t.p.jolds
      data     next-data
      jout     [(jold-object i.p.jolds datum) jout]
  ==
::
::  jold of full object
++  jold-object
  |=  [jold=json data=*]
  ^-  json
  ?.  ?=(%o -.jold)  [%s (crip (noah !>(data)))]
  =/  jolds=(list [p=@t q=json])  ~(tap by p.jold)
  ?.  ?=([[@ ^] ~] jolds)  [%s (crip (noah !>(data)))]
  :-  %o
  =*  jace       p.i.jolds
  =*  jold-type  q.i.jolds
  %+  ~(put by *(map @t json))  jace
  ?+    -.jold-type
        ~&  >>>  "jold-object: type must be %s, %a, not {<-.jold-type>}"
        [%s (crip (noah !>(data)))]
      %s
    ?.  ?=(@ data)  [%s (crip (noah !>(data)))]
    (prefix-and-mold-atom p.jold-type data)
  ::
      %a
    (compute-multiword p.jold-type data)
    ::  TODO:
    ::  * case %a %s:
    ::    * implement recursive types
    ::    * implement non-recursive, but multi-word types, like (unit ..)
    ::  * case %a %o:
    ::    * implement recursion to +jold-full-tuple in case %a %o
    :: [%s (crip (noah !>(data)))]
  ==
::
++  compute-multiword
  |=  [jolds=(list json) data=*]
  ^-  json
  ?~  jolds  !!  ::  ?
  ?>  ?=(%s -.i.jolds)
  %.  [t.jolds data]
  ?+  p.i.jolds  |=(* [%s (crip (noah !>(data)))])
    %list  compute-list
    %unit  compute-unit
    :: %set   compute-set
    :: %map   compute-map
  ==
::
++  compute-unit
  |=  [jolds=(list json) data=*]
  ^-  json
  ?~  jolds  [%s (crip (noah !>(data)))]
  ?.  =(1 (lent jolds))
    ?.  ?=(^ data)  [%s (crip (noah !>(data)))]
    (compute-multiword t.jolds +.data)
  ?.  ?=(%s -.i.jolds)  [%s (crip (noah !>(data)))]
  ?:  &(?=(@ data) =(0 data))  ~
  ?.  ?=([@ @] data)  [%s (crip (noah !>(data)))]
  (prefix-and-mold-atom p.i.jolds +.data)
::
++  compute-list
  |=  [jolds=(list json) data=*]
  ^-  json
  ?~  jolds  [%s (crip (noah !>(data)))]
  =|  jout=(list json)
  ?.  =(1 (lent jolds))
    ?.  ?=(%s -.i.jolds)  [%s (crip (noah !>(data)))]
    |-
    ?:  &(?=(@ data) =(0 data))  [%a (flop jout)]
    %=  $
        data  +.data
        jout
      [(compute-multiword t.jolds -.data) jout]
    ==
  ?.  ?=(?(%a %s) -.i.jolds)  [%s (crip (noah !>(data)))]
  |-
  ?:  &(?=(@ data) =(0 data))  [%a (flop jout)]
  %=  $
      data  +.data
      jout
    :_  jout
    ?:  ?=(%a -.i.jolds)
      (jold-full-tuple i.jolds -.data)
    ?.  ?=(@ -.data)  [%s (crip (noah !>(data)))]
    (prefix-and-mold-atom p.i.jolds -.data)
  ==
::
++  prefix-and-mold-atom
  |=  [type-tas=@tas datum=@]
  ^-  json
  ?+  type-tas
      ~&  >>>  "jold: prefix-and-mold {<type-tas>} not yet implemented"
      [%s (crip (noah !>(datum)))]
    %'~'  ~
    %'?'  [%b ;;(? datum)]
    %ud   (numb:enjs:format ;;(@ud datum))
    %da   [%s (scot %da ;;(@da datum))]
    %p    [%s (scot %p ;;(@p datum))]
    %ux   [%s (scot %ux ;;(@ux datum))]
    %t    [%s `@t`datum]
    %ta   [%s (scot %ta ;;(@ta datum))]
    %tas  [%s (scot %tas ;;(@tas datum))]
  ==
::
++  select-json-prefix
  |=  type-tas=@tas
  ^-  ?(%a %b %n %o %s)
  :: ^-  @tas ::?(%a %b %n %o %s)
  ?+  type-tas  ~|("jold: select-json-prefix {<type-tas>} not yet implemented" !!)
    %'?'  %b
    %ud   %n
    ?(%da %p %ux %uv %ta %tas)  %s
    :: ?(%da %ud)   %n
    :: ?(%p %ux %uv %ta %tas)  %s
    :: ::   ?()  %a
    ::   %'?'  %b
    ::   ?(%'@u' %'@ud' %'@ui')  %n
    :: ::   ?()  %o
    ::   $?  %'@da'  %'@dr'
    ::       %'@rd'  %'@rh'  %'@rq'  %'@rs'
    ::       %'@sb'  %'@sc'  %'@sd'  %'@si'  %'@sv'  %'@sw'  %'@sx'
    ::       %'@t'   %'@ta'  %'@tas'
    ::       %'@ub'  %'@uc'  %'@uv'  %'@uw'  %'@ux'
    ::   ==
    :: %s
  ==
::
++  select-mold
  |=  type-tas=@tas
  ?+  type-tas  ~|("jold: select-mold {<type-tas>} not yet implemented" !!)
    %'?'  ?
    %ud   @ud
    %da   @da
    %p    @p
    %ux   @ux
    %uv   @uv
    %ta   @ta
    %tas  @tas
    :: %'?'     ?
    :: %'@da'   @da
    :: %'@dr'   @dr
    :: %'@rd'   @rd
    :: %'@rh'   @rh
    :: %'@rq'   @rq
    :: %'@rs'   @rs
    :: %'@sb'   @sb
    :: %'@sc'   @sc
    :: %'@sd'   @sd
    :: %'@si'   @si
    :: %'@sv'   @sv
    :: %'@sw'   @sw
    :: %'@sx'   @sx
    :: %'@t'    @t
    :: %'@ta'   @ta
    :: %'@tas'  @tas
    :: %'@u'    @u
    :: %'@ub'   @ub
    :: %'@uc'   @uc
    :: %'@ud'   @ud
    :: %'@ui'   @ui
    :: %'@uv'   @uv
    :: %'@uw'   @uw
    :: %'@ux'   @ux
  ==
--
