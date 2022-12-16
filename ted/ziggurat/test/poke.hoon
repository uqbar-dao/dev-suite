/-  spider
/+  pyro=zig-pyro
::
=*  strand     strand:spider
::
=/  m  (strand ,vase)
=|  subject=vase
|^  ted
::
+$  arg-mold
  $:  who=@p
      to=@p
      app=@tas
      mark=@tas
      payload=*
  ==
::
++  ted
  ^-  thread:spider
  |=  args-vase=vase
  ^-  form:m
  =/  args  !<((unit arg-mold) args-vase)
  ?~  args
    ~&  >>>  "Usage:"
    ~&  >>>  "-zig!ziggurat-test-poke who=@p to=@p app=@tas mark=@tas payload=*"
    (pure:m !>(~))
  ;<  ~  bind:m  (poke:pyro [who to app mark payload]:u.args)
  (pure:m !>(~))
--
