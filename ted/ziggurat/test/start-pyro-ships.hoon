/-  spider,
    zig=zig-ziggurat
/+  strandio,
    pyio=py-io,
    test=zig-ziggurat-test
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
    ~&  >>>  "-zig!ziggurat-test-start-pyro-ships project=@t (list ship)"
    (pure:m !>(~))
  =*  project  project.u.args
  =*  ships    ships.u.args
  ::
  ;<  our=@p  bind:m  get-our
  ;<  ~  bind:m  (watch-our /effect %pyro /effect)
  ;<  ~  bind:m  (init-ships ships)
  ;<  ~  bind:m  (block-on-previous-step:test ~s1 ~m1)  :: TODO: unhardcode; are these good numbers?
  ;<  ~  bind:m
    (take-snapshot:test 0 `[%initial-ships ships])
  ;<  ~  bind:m
    %+  poke-our  %ziggurat
    :-  %ziggurat-action
    !>(`action:zig`project^[%ready-pyro-ships ~])
  ;<  =cage  bind:m
    (watch-one /pyro-done [our %ziggurat] /pyro-done)
  (pure:m !>(`~`~))
--
