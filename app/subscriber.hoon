:: This agent will subscribe to an agent and store all past subscriptions
:: solid state subscriptions should obsolete this.
::
/-  *subscriber
/+  default-agent
::
|%
+$  card  card:agent:gall
+$  state-0  [%0 facts=(map ship (jar wire sign:agent:gall))]
+$  versioned-state
  $%  state-0
  ==
--
=|  state-0
=*  state  -
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
::
++  on-init  on-init:def
++  on-save  on-save:def
++  on-load  on-load:def
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(mark %subscriber-action)
  =/  act  !<(subscriber-action vase)
  =/  paf=path  [(scot %p ship.act) path.act]
  ?-    act
      %sub
    :_  ?^  (~(get by facts) ship.act)  this
        this(facts (~(put by facts) ship.act *(jar wire sign:agent:gall)))
    [%pass paf %agent [ship.act agent.act] %watch path.act]
  ::
      %unsub
    :_  ?^  (~(get by facts) ship.act)  this
        this(facts (~(put by facts) ship.act *(jar wire sign:agent:gall)))
    [%pass paf %agent [ship.act agent.act] %leave ~]
  ==
++  on-leave  on-leave:def
++  on-watch  on-watch:def
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  (on-peek:def path)
      [@ *]
    ``noun+!>(~)
    :: =/  =ship  (slav %p i.path)
    :: =/  wyre=wire  t.path
    :: =/  jur=(jar wire sign:agent:gall)  (~(get by facts.state) ship)
    :: =/  factz  (~(get ja jur) /) :: wyre
    :: ``!>(factz)
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [@ * ~]
    =/  =ship  (slav %p i.wire)
    =/  wyre=wire  t.wire
    =/  jur  (~(get by facts) ship) 
    =.  jur  (~(add ja jur) wyre sign)
    `this(facts (~(put by facts) ship jur))
  ==
++  on-arvo  on-arvo:def
++  on-fail  on-fail:def
--