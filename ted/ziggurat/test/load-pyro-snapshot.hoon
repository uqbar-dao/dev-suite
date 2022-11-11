/-  spider,
    zig=zig-ziggurat
/+  strandio,
    pyio=py-io
::
=*  strand  strand:spider
=*  get-our    get-our:strandio
=*  poke-our   poke-our:strandio
=*  watch-one  watch-one:strandio
=*  watch-our  watch-our:strandio
::
=/  m  (strand ,vase)
|^  ted
::
+$  arg-mold  [project=@t =path]
::
++  init-ships
  |=  ships=(list @p)
  =/  m  (strand ,~)
  ^-  form:m
  |-
  ?~  ships  (pure:m ~)
  ;<  ~  bind:m  (init-ship:pyio i.ships)
  $(ships t.ships)
::
++  ted
  ^-  thread:spider
  |=  args-vase=vase
  ^-  form:m
  =/  args  !<((unit arg-mold) args-vase)
  ?~  args
    ~&  >>>  "Usage:"
    ~&  >>>  "-zig!ziggurat-test-load-pyro-snapshot project=@t path"
    (pure:m !>(~))
  =*  project  project.u.args
  =*  path     p.u.args
  ::
  ;<  our=@p  bind:m  get-our
  ;<  ~  bind:m  (poke-our %pyro [%pyro-action !>([%restore-snap path])])
  ;<  ~  bind:m
    %+  poke-our  %ziggurat
    :-  %ziggurat-action
    !>(`action:zig`project^[%ready-pyro-ships ~])
  ;<  =cage  bind:m
    (watch-one /pyro-done [our %ziggurat] /pyro-done)
  (pure:m !>(`~`~))
--
