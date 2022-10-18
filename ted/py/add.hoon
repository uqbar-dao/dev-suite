/-  spider
/+  *py-io
=,  strand=strand:spider
^-  thread:spider
|=  args=vase
=/  m  (strand ,vase)
;<  ~  bind:m  start-simple
;<  ~  bind:m  (init-ship ~dev &)
;<  ~  bind:m  (dojo ~dev "(add 2 3)")
;<  ~  bind:m  (wait-for-output ~dev "5")
;<  ~  bind:m  (dojo ~dev ".^((list @t) %gx /=azimuth=/dns/noun)")
;<  ~  bind:m  (wait-for-output ~dev "<||>")
;<  ~  bind:m  end
(pure:m *vase)
