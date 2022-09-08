::  faucet [UQ| DAO]:
::
::  Give out native token on testnet
::
::
::    ##  Pokes
::
::    %faucet-action:
::      Requests from outside.
::      %open: Request native token from faucet,
::             to be sent to given address.
::    %faucet-configure:
::      Change state of %faucet app.
::
::
/-  f=faucet,
    w=wallet
/+  agentio,
    dbug,
    default-agent,
    verb,
    smart=zig-sys-smart
::
|%
+$  card  card:agent:gall
--
::
=|  state-0:f
=*  state  -
::
%-  agent:dbug
%+  verb  |
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    io    ~(. agentio bowl)
::
++  on-init
  :-  ~
  %=  this
      gas               [rate=1 budget=1.000.000]
      timeout-duration  ~h1
      volume            1.000.000.000.000.000.000
  ==
++  on-save  !>(state)
++  on-load
  |=  old-vase=vase
  =/  old  !<(versioned-state:f old-vase)
  ?-    -.old
      %0
      `this(state old(on-timeout ~))
  ==
::
++  on-poke
  |=  [=mark =vase]
  |^  ^-  (quip card _this)
  ?+  mark  (on-poke:def mark vase)
    %faucet-action     (handle-action !<(action:f vase))
    %faucet-configure  (handle-configure !<(configure:f vase))
  ==
  ::
  ++  handle-action
    |=  =action:f
    ^-  (quip card _this)
    ?-    -.action
        %open
      =*  src  src.bowl
      ?~  town-info=(~(get by town-infos) town-id.action)
        ~|("%faucet: invalid town. Valid towns: {<~(key by town-infos)>}" !!)
      ?^  timeout-done=(~(get by on-timeout) src)
        ~|("%faucet: must wait until after {<u.timeout-done>} to acquire more zigs." !!)
      =/  until=@da  (add now.bowl timeout-duration)
      :_  this(on-timeout (~(put by on-timeout) src until))
      :+  %.  until
          %~  wait  pass:io
          /done/(scot %p src)/(scot %da until)
        %+  ~(poke-our pass:io /open-poke-wire)
          %wallet
        :-  %zig-wallet-poke
        !>  ^-  wallet-poke:w
        :*  %submit
            from=address.u.town-info
            to=zigs-wheat.u.town-info
            town=town-id.action
            gas=gas
            :^  %give  to=address.action  amount=volume
            grain=zigs-rice.u.town-info
        ==
      ~
    ==
  ::
  ++  handle-configure
    |=  c=configure:f
    ^-  (quip card _this)
    ?>  =(our.bowl src.bowl)
    ?-    -.c
        %edit-gas     `this(gas gas.c)
        %edit-volume  `this(volume volume.c)
        %edit-timeout-duration
      `this(timeout-duration timeout-duration.c)
    ::
        %put-town
      :-  ~
      %=  this
          town-infos
        (~(put by town-infos) town-id.c town-info.c)
      ==
    ==
  --
::
++  on-arvo
  |=  [=wire =sign-arvo:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-arvo:def wire sign-arvo)
      [%done @ @ ~]
    ?+    sign-arvo  (on-arvo:def wire sign-arvo)
        [%behn %wake *]
      =/  who=@p     (slav %p i.t.wire)
      =/  until=@da  (slav %da i.t.t.wire)
      ?:  (gth until now.bowl)  `this
      `this(on-timeout (~(del by on-timeout) who))
    ==
  ==
::
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent  on-agent:def
++  on-fail   on-fail:def
--
