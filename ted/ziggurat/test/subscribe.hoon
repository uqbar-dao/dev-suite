/-  spider
/+  strandio,
    pyro=zig-pyro
::
=*  strand     strand:spider
=*  take-fact  take-fact:strandio
=*  watch-our  watch-our:strandio
::
=/  m  (strand ,vase)
=|  subject=vase
|^  ted
::
+$  arg-mold
  $:  project-name=@t
      iterations=@ud
  ==
::
++  ted
  ^-  thread:spider
  |=  args-vase=vase
  ^-  form:m
  =/  args  !<((unit arg-mold) args-vase)
  ?~  args
    ~&  >>>  "Usage:"
    ~&  >>>  "-zig!ziggurat-test-subscribe project-name=@t iterations=@ud"
    (pure:m !>(~))
  =*  project-name  project-name.u.args
  =*  iterations    iterations.u.args
  ::
  =|  counter=@ud
  =/  watch-wire=wire  /project/[project-name]
  ;<  ~  bind:m  (watch-our watch-wire %ziggurat watch-wire)
  |-
  ?:  =(iterations counter)  (pure:m !>(~))
  ;<  result=cage  bind:m  (take-fact watch-wire)
  ~&  %zts^p.result^(noah q.result)
  $(counter +(counter))
--
