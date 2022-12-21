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
/-  f=zig-faucet,
    w=zig-wallet
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
  :_  %=  this
          gas               [rate=1 budget=1.000.000]
          timeout-duration  ~h1
          volume            1.000.000.000.000.000.000
      ==
  :_  ~
  :*  %pass  /faucet-wallet-poke
      %agent  [our.bowl %uqbar]
      %poke  %wallet-poke
      !>([%approve-origin [%faucet /gifts] [1 1.000.000]])
  ==
::
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
    ::  can safely ignore updates from wallet about status of transactions
    %wallet-update     `this
  ==
  ::
  ++  handle-action
    |=  =action:f
    ^-  (quip card _this)
    =,  bowl
    ?:  =(%pawn (clan:title src))
      ~|("%faucet: comets cannot use the faucet! get a planet!" !!)
    =/  par
      ?:  =(%earl (clan:title src))
        (sein:title our now src)
      src
    ?~  town-info=(~(get by town-infos) town-id.action)
      ~|("%faucet: invalid town. Valid towns: {<~(key by town-infos)>}" !!)
    =/  [unlock=@da count=@ud]
      (~(gut by on-timeout) par [*@da 0])
    ?:  (gth unlock now)
      ~|("%faucet: must wait until after {<unlock>} to acquire more zigs." !!)
    =/  until=@da  (add now.bowl (mul timeout-duration (pow 2 count)))
    :_  %=    this
            on-timeout
          %+  ~(put by on-timeout)  par
          [until ?:((gte count 12) count +(count))]
        ==
    =-  [%pass /transaction-poke %agent [our.bowl %wallet] %poke -]~
    :-  %wallet-poke
    !>  ^-  wallet-poke:w
        :*  %transaction
            origin=`[%faucet /gifts]
            from=address.u.town-info
            contract=zigs-contract.u.town-info
            town=town-id.action
            :^    %give
                to=address.action
              amount=volume
            grain=zigs-account.u.town-info
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
++  on-arvo  on-arvo:def
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent  on-agent:def
++  on-fail   on-fail:def
--
