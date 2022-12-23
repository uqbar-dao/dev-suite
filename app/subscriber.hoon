:: This agent will subscribe to an agent and store all past subscriptions
:: solid state subscriptions should obsolete this.
::
/-  *zig-subscriber
/+  dbug, default-agent
::
|%
+$  state-0  [%0 =facts =signs]
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
++  on-init  `this(state [%0 ~ ~])
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
  =/  paf=path  [(scot %p ship.act) app.act path.act]
  ?-    -.act
      %sub
    ?:  (~(has by wex.bowl) [paf [ship app]:act])  `this
    :-  [%pass paf %agent [ship app]:act %watch path.act]~
    %_  this
      facts  (~(put by facts) [ship app path]:act ~)
      signs  (~(put by signs) [ship app path]:act ~)
    ==
  ::
      %unsub
    :_  this
    [%pass paf %agent [ship.act app.act] %leave ~]~
  ::
      %clear
    :-  ~
    %_  this
      facts  (~(put by facts) [ship app path]:act ~)
      signs  (~(put by signs) [ship app path]:act ~)
    ==
  ==
++  on-leave  on-leave:def
++  on-watch  on-watch:def
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  (on-peek:def path)
      [%x %facts @ @ ^]
    =/  =ship  (slav %p i.t.t.path)
    =*  app  i.t.t.t.path
    =*  paf  t.t.t.t.path
    :^  ~  ~  %noun
    =+  (~(get by facts) [ship app paf])
    ?@  -  !>(~)  !>((need -))  
  ::
      [%x %signs @ @ ^]
    =/  =ship  (slav %p i.t.t.path)
    =*  app  i.t.t.t.path
    =*  paf  t.t.t.t.path
    :^  ~  ~  %noun
    =+  (~(get by signs) [ship app paf])
    ?~  -  !>(~)  !>((need -))
  ==
::
++  on-agent
  |=  [=wire =sign]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [@ @ ^]
    =/  =ship  (slav %p i.wire)
    =*  app  i.t.wire
    =*  paf  t.t.wire
    ~&  >  "{<our.bowl>}/subscriber: subscription received from {<ship>} for {<`@tas`app>} on wire {<`path`paf>}"
    |^  :: TODO this code is extremely ugly
    ?+    -.sign  (default sign)
        %fact
      =/  fact-set  (~(got by facts) [ship app paf])
      =.  fact-set  (~(put in fact-set) (crip (noah q.cage.sign)))
      `this(facts (~(put by facts) [ship app paf] fact-set))
    ==
    ::
    ++  default
      |=  =^sign
      ^-  (quip card _this)
      =/  sign-set  (~(got by signs) [ship app paf])
      =.  sign-set  (~(put in sign-set) sign)
      `this(signs (~(put by signs) [ship app paf] sign-set))
    --
  ==
++  on-arvo  on-arvo:def
++  on-fail  on-fail:def
--
