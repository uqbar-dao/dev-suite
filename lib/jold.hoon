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
|%
++  jold-data
  |=  [jold=json data=*]
  ^-  json
  ~
::
::  jold of tuple with faces
::  [%a ~[[%o p={[p=%foo q=[%s p='ud']]}] [%o p={[p=%bar q=[%s p='tas']]}]]]
++  jold-tuple
  |=  [jolds=json data=*]
  ^-  json
  ?>  ?=(%a -.jolds)
  :-  %a
  =|  jout=(list json)
  |-
  ?~  p.jolds  (flop jout)
  =/  is-last=?  ?=(@ data)
  =*  datum  ?:(is-last data -.data)
  %=  $
      p.jolds  t.p.jolds
      data     ?:(is-last ~ +.data)
      jout     [(jold-single-jace i.p.jolds `@`datum) jout]
  ==
::
::  jold of atom with a face
::  [%o p={[p=%foo q=[%s p='@ud']]}]
++  jold-single-jace
  |=  [jold=json data=@]
  ^-  json
  ?>  ?=(%o -.jold)
  =/  jolds=(list [p=@t q=json])  ~(tap by p.jold)
  ?>  ?=([[@ ^] ~] jolds)
  =*  jace         p.i.jolds
  =*  single-jold  q.i.jolds
  ?>  ?=(%s -.single-jold)
  :-  %o
  %+  ~(put by *(map @t json))  jace
  (prefix-and-mold-atom p.single-jold data)
::
++  prefix-and-mold-atom
  |=  [type-tas=@tas data=@]
  ?+  type-tas  ~|("jold: prefix-and-mold {<type-tas>} not yet implemented" !!)
    %'?'  [%b ;;(? data)]
    %ud   [%n (scot %ud ;;(@ud data))]
    %da   [%s (scot %da ;;(@da data))]
    %p    [%s (scot %p ;;(@p data))]
    %ux   [%s (scot %ux ;;(@ux data))]
    %ta   [%s (scot %ta ;;(@ta data))]
    %tas  [%s (scot %tas ;;(@tas data))]
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
