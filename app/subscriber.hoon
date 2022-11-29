:: This agent will subscribe to an agent and store all past subscriptions
:: solid state subscriptions should obsolete this.
::
/-  *subscriber
/+  dbug, default-agent, *mip
::
|%
+$  state-0  [%0 =facts] :: XX change facts to a set not a queue - tag by timestamp
+$  card  card:agent:gall
+$  sign  sign:agent:gall
--
=|  state-0
=*  state  -
%-  agent:dbug
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
::
++  on-init  `this(state [%0 ~])
++  on-save  !>(state)
++  on-load
  |=  =old=vase
  ^-  (quip card _this)
  =/  old-state  !<(state-0 old-vase)
  `this(state old-state)
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(mark %subscriber-action)
  =/  act  !<(subscriber-action vase)
  =/  paf=path  [(scot %p ship.act) agent.act path.act]
  ?-    -.act
      %sub
    :-  [%pass paf %agent [ship agent]:act %watch path.act]~
    %=    this
        facts.state
      ?^  (~(get bi facts.state) [ship agent]:act paf)
        facts.state
      (~(put bi facts.state) [ship agent]:act path.act ~)
    ==
  ::
      %unsub
    :_  this
    [%pass paf %agent [ship.act agent.act] %leave ~]~
  ::
      %clear
    `this(facts.state (~(put bi facts.state) [ship agent]:act path.act ~))
  ==
++  on-leave  on-leave:def
++  on-watch  on-watch:def
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  (on-peek:def path)
  ::
  ::  next n events
      [%x %next-facts @ @ @ ^]
    =/  n=@ud  (slav %ud i.t.t.path)
    =/  =ship  (slav %p i.t.t.t.path)
    =/  agent  i.t.t.t.t.path
    =/  pafth  t.t.t.t.t.path
    =/  qew  (~(got bi facts.state) [ship agent] pafth)
    =/  res=(list sign)
      =|  i=@ud
      =|  facts=(list sign)
      |-  ^-  (list sign)
      ?:    |(=(n i) =(~ qew))
        facts
      =^  new  qew  ~(get to qew)
      $(i +(i), facts [new facts])
    ``noun+!>(res)
  ::
      [%x %next-fact @ @ ^]
    =/  =ship  (slav %p i.t.t.path)
    =/  agent  i.t.t.t.path
    =/  pafth  t.t.t.t.path
    =/  qew  (~(got bi facts.state) [ship agent] pafth)
    =/  fakt
      ?~  qew  ~
      (head ~(get to qew))
    ``noun+!>(fakt)
  ::
      [%x %all-facts @ @ ^]
    =/  =ship  (slav %p i.t.path)
    =/  agent  i.t.t.path
    =/  pafth  t.t.t.path
    =/  qew  (~(got bi facts.state) [ship agent] pafth)
    =/  fakts  ~(tap to qew)
    ``noun+!>(fakts)
  ==
::
++  on-agent
  |=  [=wire =sign]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [@ @ ^]
    =/  =ship  (slav %p i.wire)
    =/  agent  i.t.wire
    =/  pafth  t.t.wire
    =/  qew  (~(got bi facts) [ship agent] pafth)
    =.  qew  (~(put to qew) sign)
    ~&  >  qew
    `this(facts.state (~(put bi facts.state) [ship agent] pafth qew))
  ==
++  on-arvo  on-arvo:def
++  on-fail  on-fail:def
--