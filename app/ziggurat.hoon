::  ziggurat [UQ| DAO]
::
::  Contract Playground
::
/-  *ziggurat
/+  smart=zig-sys-smart, templates=zig-templates, sequencer,
    default-agent, dbug, verb
/*  smart-lib-noun  %noun  /lib/zig/compiled/smart-lib/noun
/*  zink-cax-noun   %noun  /lib/zig/compiled/hash-cache/noun
::
|%
+$  card  card:agent:gall
+$  state-0
  $:  %0
      xx=@t
  ==
+$  inflated-state-0  [state-0 =mil smart-lib-vase=vase]
+$  mil  $_  ~(mill mill:sequencer !>(0) *(map * @) %.y)
--
::
=|  inflated-state-0
=*  state  -
::
%-  agent:dbug
%+  verb  |
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
::
++  on-init
  =/  smart-lib=vase  ;;(vase (cue q.q.smart-lib-noun))
  =/  mil
    %~  mill  mill:sequencer
    [smart-lib ;;((map * @) (cue q.q.zink-cax-noun)) %.y]
  :-  ~
  %_    this
      state
    [[%0 'XX'] mil smart-lib]
  ==
++  on-save  !>(-.state)
++  on-load
  |=  =old=vase
  ::  on-load: pre-cue our compiled smart contract library
  =/  smart-lib=vase  ;;(vase (cue q.q.smart-lib-noun))
  =/  mil
    %~  mill  mill:sequencer
    [smart-lib ;;((map * @) (cue q.q.zink-cax-noun)) %.y]
  `this(state [!<(state-0 old-vase) mil smart-lib])
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  !!
      [%path-name ~]
    :_  this
    [%give %fact ~ [%update !>('XX')]]~
  ::
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^
  =^  cards  state
    (handle-poke !<(action vase))
  [cards this]
  ::
  ++  handle-poke
    |=  act=action
    ^-  (quip card _state)
    ?+    -.act  !!
        %new-project
      !!
    ::
    ==
  --
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  (on-agent:def wire sign)
::
++  on-arvo
  |=  [=wire =sign-arvo:agent:gall]
  ^-  (quip card _this)
  (on-arvo:def wire sign-arvo)
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?.  =(%x -.path)  ~
  ?+    +.path  (on-peek:def path)
      [%path ~]
    ``noun+!>(~)
  ==
::
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--
