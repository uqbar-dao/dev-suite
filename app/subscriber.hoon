:: This agent will subscribe to an agent and store all past subscriptions
:: solid state subscriptions should obsolete this.
::
/-  *subscriber
/+  dbug, default-agent
::
|%
+$  state-0  [%0 facts=(map ship (jar (pair term wire) sign:agent:gall))] :: qeu might be better
+$  card  card:agent:gall
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
    :-  [%pass paf %agent [ship.act agent.act] %watch path.act]~
    %=    this
        facts.state
      ?^  (~(get by facts.state) ship.act)
        facts.state
      (~(put by facts.state) ship.act ~)
    ==
  ::
      %unsub
    :_  this
    [%pass paf %agent [ship.act agent.act] %leave ~]~
  ==
++  on-leave  on-leave:def
++  on-watch  on-watch:def
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  (on-peek:def path)
      [%x @ @ ^]
    =/  =ship  (slav %p i.t.path)
    =/  agent  i.t.t.path
    =/  wyre  t.t.t.path
    =/  jur  (~(got by facts.state) ship)
    =/  factz  (~(get ja jur) [agent wyre])
    ``noun+!>(factz)
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [@ @ ^]
    =/  =ship  (slav %p i.wire)
    =/  agent  i.t.wire
    =/  wyre  t.t.wire
    =/  jur  (~(got by facts) ship)
    =.  jur  (~(add ja jur) [agent wyre] sign)
    ~&  >  jur
    `this(facts.state (~(put by facts.state) ship jur))
  ==
++  on-arvo  on-arvo:def
++  on-fail  on-fail:def
--