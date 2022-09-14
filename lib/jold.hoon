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
::  helper function to wrap `+json-full-tuple`
::   that gives nicer output for frontends
::   (transforms array of single-pair objects
::   to a single multi-pair object)
++  jold-full-tuple-to-object
  |=  [jolds=json data=*]
  ^-  json
  =/  array=json  (jold-full-tuple jolds data)
  ?.  ?=(%a -.array)  array
  =/  jsons=(list json)  p.array
  =|  object=(map @t json)
  |-
  ?~  jsons  [%o object]
  ?.  ?=(%o -.i.jsons)          array
  ?.  =(1 ~(wyt by p.i.jsons))  array
  %=  $
      jsons   t.jsons
      object  (~(uni by object) p.i.jsons)
  ==
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
  ==
::
++  compute-multiword
  |=  [jolds=(list json) data=*]
  ^-  json
  ?~  jolds  [%s (crip (noah !>(data)))]
  ?>  ?=(%s -.i.jolds)
  %.  [t.jolds data]
  ?+  p.i.jolds  |=(* [%s (crip (noah !>(data)))])
    %list  compute-list
    %unit  compute-unit
    %set   compute-set
    %map   compute-map
  ==
::
++  compute-map
  ::  simplfied, only recursive for value types;
  ::   key types must be atoms
  |=  [jolds=(list json) data=*]
  ^-  json
  ?~  jolds  [%s (crip (noah !>(data)))]
  =|  jout=(list [@t json])
  ?.  ?=([^ ^ ~] jolds)
    ?.  ?=(%s -.i.jolds)  [%s (crip (noah !>(data)))]
    =*  key-type  p.i.jolds
    =.  data  (tree-noun-to-list data)
    |-
    ?:  &(?=(@ data) =(0 data))
      [%o (~(gas by *(map @t json)) jout)]
    %=  $
        data  +.data
        jout
      ?.  ?=([@ *] -.data)  jout  ::  TODO: can we do better?
      ?~  key=(prefix-and-mold-atom key-type -.-.data)  jout
      ?.  ?=(?(%n %s) -.key)  jout  ::  TODO: can we do better?
      =/  val=json  (compute-multiword t.jolds +.-.data)
      [[p.key val] jout]
    ==

  ::
  ?.  &(?=(%s -.i.jolds) ?=(?(%a %s) -.i.t.jolds))
    [%s (crip (noah !>(data)))]
  =*  key-type  p.i.jolds
  =*  val-type  p.i.t.jolds
  =.  data  (tree-noun-to-list data)
  |-
  ?:  &(?=(@ data) =(0 data))
    [%o (~(gas by *(map @t json)) jout)]
  %=  $
      data  +.data
      jout
    ?.  ?=([@ *] -.data)  jout  ::  TODO: can we do better?
    ?~  key=(prefix-and-mold-atom key-type -.-.data)  jout
    ?.  ?=(?(%n %s) -.key)  jout  ::  TODO: can we do better?
    =/  val=json
      ?:  ?=(%a -.i.t.jolds)
        (jold-full-tuple-to-object i.t.jolds +.-.data)
        :: (jold-full-tuple i.t.jolds +.-.data)
      ?.  ?=(@ +.-.data)  [%s (crip (noah !>(data)))]
      (prefix-and-mold-atom val-type +.-.data)
    [[p.key val] jout]
  ==
::
++  compute-set
  |=  [jolds=(list json) data=*]
  ^-  json
  (compute-list jolds (tree-noun-to-list data))
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
      (jold-full-tuple-to-object i.jolds -.data)
      :: (jold-full-tuple i.jolds -.data)
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
::  source:
::   https://github.com/urbit/urbit/blob/master/pkg/arvo/lib/pprint.hoon#L709-L717
::
++  tree-noun-to-list
  |=  n=*
  ^-  (list *)
  ?@  n  ~
  :-  -.n
  %-  zing
  :~  (tree-noun-to-list +.+.n)
      (tree-noun-to-list -.+.n)
  ==
--
