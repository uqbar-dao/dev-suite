/-  spider,
    zig=zig-ziggurat
/+  strandio,
    pyio=py-io
::
=*  strand  strand:spider
=*  get-our    get-our:strandio
=*  poke-our   poke-our:strandio
=*  watch-one  watch-one:strandio
::
=/  m  (strand ,vase)
|^  ted
::
+$  arg-mold  [project=@t ships=(list @p)]
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
    ~&  >>>  "-zig!ziggurat-test-master project=@t (list ship)"
    (pure:m !>(~))
  =*  project  project.u.args
  =*  ships    ships.u.args
  ::
  ;<  our=@p  bind:m  get-our
  ;<  ~  bind:m  start-simple:pyio
  ;<  ~  bind:m  (init-ships ships)
  ;<  ~  bind:m  (send-hi:pyio ~nec ~bud)
  ;<  ~  bind:m
    %+  poke-our  %ziggurat
    :-  %ziggurat-action
    !>(`action:zig`project^[%ready-test-master ~])
  ;<  =cage  bind:m
    (watch-one /pyro-done [our %ziggurat] /pyro-done)
  ;<  ~  bind:m  end:pyio
  (pure:m !>(`~`~))
--
