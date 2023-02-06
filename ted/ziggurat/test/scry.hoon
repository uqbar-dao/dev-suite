/-  spider
/+  strandio,
    pyro=zig-pyro
::
=*  strand   strand:spider
=*  get-bowl  get-bowl:strandio
::
=/  m  (strand ,vase)
=|  subject=vase
|^  ted
::
++  ted
  ^-  thread:spider
  |=  args-vase=vase
  ^-  form:m
   ;<  =bowl:strand  bind:m  get-bowl
   =/  our=@ta  (scot %p our.bowl)
   =/  who=@ta  (scot %p ~nec) ::(scot %p who.payload)
   =/  now=@ta  (scot %da now.bowl)
   =/  desks-scry=(set @tas)
     ;;  (set @tas)
     .^  *
         %gx
         /[our]/pyro/[now]/i/[who]/cd/[who]/base/[now]/noun
     ==
  (pure:m !>(desks-scry))
--
