::  uqbar [UQ| DAO]
::
::  The agent for interacting with Uqbar. Provides read/write layer for userspace agents.
::
/-  spider,
    u=zig-uqbar,
    ui=zig-indexer,
    w=zig-wallet
/+  agentio,
    default-agent,
    dbug,
    verb,
    s=zig-sequencer,
    smart=zig-sys-smart
|%
+$  card  card:agent:gall
+$  state-0
  $:  %0
      min-ping-time=@dr
      max-ping-time=@dr
      next-ping-time=@da
      ping-tids=(map @ta (pair id:smart dock))
      ping-time-fast-delay=@dr
      ping-timeout=@dr
      pings-timedout=(unit @da)
      indexer-sources=(jug id:smart dock)  ::  set of indexers for each shard
      =indexer-sources-ping-results:u
      sequencers=(map id:smart sequencer:s)  ::  single sequencer for each shard
      wallet-source=@tas
  ==
--
::
=|  state-0
=*  state  -
::
%-  agent:dbug
%+  verb  |
^-  agent:gall
=<
  |_  =bowl:gall
  +*  this        .
      def         ~(. (default-agent this %|) bowl)
      io          ~(. agentio bowl)
      uc          ~(. +> bowl)
  ::
  ++  on-init
    ^-  (quip card _this)
    :-  ~
    %=  this
        min-ping-time         ~m15  ::  TODO: allow user to set?
        max-ping-time         ~h2   ::   Spam risk?
        ping-time-fast-delay  ~s5
        ping-timeout          ~s30
        wallet-source         %wallet  ::  name of locally-installed wallet app
    ==
  ::
  ++  on-save  !>(state)
  ++  on-load
    |=  =old=vase
    ^-  (quip card _this)
    =.  state  !<(state-0 old-vase)
    =.  next-ping-time
      ?:  (gth next-ping-time now.bowl)  next-ping-time
      (make-next-ping-time:uc min-ping-time max-ping-time)
    :_  this
    ?:  (gth next-ping-time now.bowl)  ~
    [(make-ping-wait-card:uc next-ping-time)]~
  ::
  ++  on-watch
    |=  =path
    |^  ^-  (quip card _this)
    ?>  =(src.bowl our.bowl)
    :_  this
    ?+    -.path  !!
        %track  ~
        %wallet
      ::  must be of the form, e.g.,
      ::   /wallet/[requesting-app-name]/[*-updates]
      ?.  ?=([%wallet @ @ ~] path)  ~  ::  TODO: kick
      (watch-wallet /[i.path]/[i.t.path] t.t.path)
    ::
        %indexer
      ::  must be of the form, e.g.,
      ::   /indexer/[requesting-app-name]/batch-order/[shard-id]
      ::   or
      ::   /indexer/[requesting-app-name]/json/batch-order/[shard-id]
      ?.  ?=([%indexer @ @ *] path)  ~  ::  TODO: kick
      =/  shard-id=id:smart              ::  TODO: generalize?
        ?:  ?=([%indexer @ @ @ ~] path)
          (slav %ux i.t.t.t.path)
        ?>  ?=([%indexer @ %json @ @ ~] path)
        (slav %ux i.t.t.t.t.path)
      (watch-indexer shard-id /[i.path]/[i.t.path] t.t.path)
    ==
    ::
    ++  watch-wallet
      |=  [wire-prefix=wire sub-path=^path]
      ^-  (list card)
      :_  ~
      %+  ~(watch-our pass:io (weld wire-prefix sub-path))
      wallet-source  sub-path
    ::
    ++  watch-indexer  ::  TODO: use fallback better?
      |=  [shard=id:smart wire-prefix=wire sub-path=^path]
      ^-  (list card)
      ?~  source=(get-best-source:uc shard ~ %nu)
        ~&  >>>  "%uqbar: subscription failed:"
        ~&  >>>  " do not have indexer source for shard {<shard>}."
        ~&  >>>  " Add indexer source for shard and try again."
        ~
      :_  ~
      %+  ~(watch pass:io (weld wire-prefix sub-path))
      p.u.source  sub-path
    --
  ::
  ++  on-poke
    |=  [=mark =vase]
    ^-  (quip card _this)
    |^
    =^  cards  state
      ?+    mark  ~|("%uqbar: rejecting erroneous poke" !!)
          %uqbar-action  (handle-action !<(action:u vase))
          %uqbar-write   (handle-write !<(write:u vase))
          %wallet-poke   (handle-wallet-poke !<(wallet-poke:w vase))
      ==
    [cards this]
    ::
    ++  make-ping-rest-card
      |=  old-next-ping-time=@da
      ^-  card
      %.  old-next-ping-time
      %~  rest  pass:io
      /start-indexer-ping/(scot %da old-next-ping-time)
    ::
    ++  handle-wallet-poke
      |=  =wallet-poke:w
      ^-  (quip card _state)
      :_  state
      :_  ~
      %+  ~(poke-our pass:io /wallet-poke)  wallet-source
      [%wallet-poke !>(`wallet-poke:w`wallet-poke)]
    ::
    ++  handle-action
      |=  act=action:u
      |^  ^-  (quip card _state)
      ?>  =(src.bowl our.bowl)
      ?-    -.act
          %set-wallet-source
        `state(wallet-source app-name.act)
      ::
          %ping
        =/  faster-next-ping-time=@da
          %+  add  ping-time-fast-delay
          ?~(pings-timedout now.bowl u.pings-timedout)
        :_  state(next-ping-time faster-next-ping-time)
        :+  (make-ping-rest-card next-ping-time)
          (make-ping-wait-card:uc faster-next-ping-time)
        ~
      ::
          %add-source
        :-  :_  ~
            %-  ~(poke-self pass:io /ping-action-poke)
            [%uqbar-action !>(`action:u`[%ping ~])]
        %=  state
            indexer-sources
          (~(put ju indexer-sources) shard.act source.act)
        ==
      ::
          %remove-source
        :-  :_  ~
            %-  ~(poke-self pass:io /ping-action-poke)
            [%uqbar-action !>(`action:u`[%ping ~])]
        %=  state
            indexer-sources-ping-results
          %^    remove-from-ping-results
              shard.act
            source.act
          indexer-sources-ping-results
        ::
            indexer-sources
          (~(del ju indexer-sources) shard.act source.act)
        ==
      ::
          %set-sources
        =/  p=path  /capitol-updates
        :-  :-  %-  ~(poke-self pass:io /ping-action-poke)
                [%uqbar-action !>(`action:u`[%ping ~])]
            %+  murn  shards.act
            |=  [shard=id:smart indexers=(set dock)]
            ?~  indexers  ~
            `(~(watch pass:io p) -.indexers p)  ::  TODO: do better here
        %=  state
            indexer-sources-ping-results
          (set-sources-remove-from-ping-results shards.act)
        ::
            indexer-sources
          (~(gas by *(map id:smart (set dock))) shards.act)
        ==
      ==
      ::
      ++  remove-from-ping-results
        |=  $:  shard=id:smart
                source=dock
                =indexer-sources-ping-results:u
            ==
        ^-  indexer-sources-ping-results:u
        =/  old
          %+  ~(gut by indexer-sources-ping-results)
          shard  [~ ~ ~ ~]
        ?:  ?=([~ ~ ~ ~] old)  indexer-sources-ping-results
        %+  ~(put by indexer-sources-ping-results)
          shard
        :^    (~(del in previous-up.old) source)
            (~(del in previous-down.old) source)
          (~(del in newest-up.old) source)
        (~(del in newest-down.old) source)
      ::
      ++  set-sources-remove-from-ping-results
        |=  shards=(list [shard=id:smart (set dock)])
        ^-  indexer-sources-ping-results:u
        ?~  shards  indexer-sources-ping-results
        =/  docks=(list dock)  ~(tap in +.i.shards)
        %=  $
            shards  t.shards
            indexer-sources-ping-results
          |-
          ?~  docks  indexer-sources-ping-results
          %=  $
              docks  t.docks
              indexer-sources-ping-results
            %^    remove-from-ping-results
                shard.i.shards
              i.docks
            indexer-sources-ping-results
          ==
        ==
      --
    ::
    ++  handle-write
      |=  =write:u
      ^-  (quip card _state)
      ?-    -.write
          %submit
        ::  forward a transaction to sequencer we're tracking
        ::  for the specified shard
        ?>  =(src.bowl our.bowl)
        ?~  seq=(~(get by sequencers.state) `@ux`shard.txn.write)
          ~|("%uqbar: no known sequencer for that shard" !!)
        =/  txn-hash  (scot %ux `@ux`(sham +.txn.write))
        :_  state
        :+  %+  ~(poke pass:io /submit-transaction/txn-hash)
              [q.u.seq %sequencer]
            :-  %sequencer-shard-action
            !>(`shard-action:s`[%receive (silt ~[txn.write])])
          %+  fact:io
            [%write-result !>(`write-result:u`[%sent ~])]
          ~[/track/[txn-hash]]
        ~
      ::
          %receipt
        ::  forward to local watchers, usually wallet
        :_  state
        :_  ~
        %+  fact:io
          [%write-result !>(`write-result:u`write)]
        ~[/track/(scot %ux txn-hash.write)]
      ==
    --
  ::
  ++  on-agent
    |=  [=wire =sign:agent:gall]
    |^  ^-  (quip card _this)
    ?+    -.wire  (on-agent:def wire sign)
        %capitol-updates
      ::  set sequencers based on rollup state, given by indexer
      ?+    -.sign  (on-agent:def wire sign)
          %kick
        [rejoin this]
      ::
          %fact
        =^  cards  state
          (update-sequencers !<(capitol-update:s q.cage.sign))
        [cards this]
      ==
    ::
        %indexer
      ?+  -.sign  (on-agent:def wire sign)
        %kick  [rejoin this]
        %fact  [[(pass-through cage.sign)]~ this]
      ==
    ::
        %submit-transaction
      ::  get receipt from sequencer
      ?.  ?=([@ ~] t.wire)      `this
      ?.  ?=(%poke-ack -.sign)  `this
      =/  path  ~[/track/[i.t.wire]]
      :_  this
      ?~  p.sign  ~
      :_  ~
      %+  fact:io
        :-  %write-result
        !>(`write-result:u`[%rejected src.bowl])
      path
    ::
        %pinger
      ?.  ?=([@ ~] t.wire)
        `this
      =/  tid=@ta  i.t.wire
      ?~  source=(~(get by ping-tids) tid)
        `this
      ?+    -.sign  (on-agent:def wire sign)
          %kick      `this
          %poke-ack  `this
          %fact
        =.  ping-tids  (~(del by ping-tids) tid)
        ?+    p.cage.sign  (on-agent:def wire sign)
            %thread-fail
          ~&  >>>  "%uqbar: pinger failed tid: {<tid>}; source: {<u.source>}"
          `this
        ::
            %thread-done
          ?:  =(*vase q.cage.sign)  `this  ::  thread canceled
          =*  shard    p.u.source
          =*  d        q.u.source
          =/  is-last-ping-tid=?  =(0 ~(wyt by ping-tids))
          =.  indexer-sources-ping-results
            %+  ~(put by indexer-sources-ping-results)  shard
            =/  [pu=(set dock) pd=(set dock) nu=(set dock) nd=(set dock)]
              %+  ~(gut by indexer-sources-ping-results)  shard
              [~ ~ ~ ~]
            =:  nu  ?:(!<(? q.cage.sign) (~(put in nu) d) nu)
                nd  ?:(!<(? q.cage.sign) nd (~(put in nd) d))
            ==
            ?:  is-last-ping-tid  [nu nd ~ ~]
            [pu pd nu nd]
          ?.  is-last-ping-tid  `this
          :_  this(pings-timedout ~)
          ?~  pings-timedout  ~
          :_  ~
          %.  u.pings-timedout
          %~  rest  pass:io
          /ping-timeout/(scot %da u.pings-timedout)
          :: TODO: move current subscriptions if on non-replying indexer?
        ==
      ==
    ==
    ::
    ++  pass-through
      |=  =cage
      ^-  card
      (fact:io cage ~[wire])
    ::
    ++  rejoin  ::  TODO: ping indexers and find responsive one?
      ^-  (list card)
      =/  old-source=(unit [dock path])
        (get-wex-dock-by-wire:uc wire)
      ?~  old-source  ~
      ~[(~(watch pass:io wire) u.old-source)]
    ::
    ++  update-sequencers
      |=  upd=capitol-update:s
      ^-  (quip card _state)
      :-  ~
      %=    state
          sequencers
        %-  ~(run by capitol.upd)
        |=(=hall:s sequencer.hall)
      ==
    --
  ::
  ++  on-arvo
    |=  [=wire =sign-arvo:agent:gall]
    |^  ^-  (quip card _this)
    ?+    wire  (on-arvo:def wire sign-arvo)
        [%start-indexer-ping @ ~]
      ?+    sign-arvo  (on-arvo:def wire sign-arvo)
          [%behn %wake *]
        =/  until=@da  (slav %da i.t.wire)
        ?:  (gth until now.bowl)  `this
        ?^  error.sign-arvo
          ~&  >>>  "%uqbar: error from ping timer: {<u.error.sign-arvo>}"
          `this
        =.  next-ping-time
          %+  make-next-ping-time:uc  min-ping-time
          max-ping-time
        =.  indexer-sources-ping-results
          %-  ~(urn by indexer-sources-ping-results)
          |=  $:  shard=@ux
                  previous-up=(set dock)
                  previous-down=(set dock)
                  newest-up=(set dock)
                  newest-down=(set dock)
              ==
          [newest-up newest-down ~ ~]
        =^  cards  state  make-ping-indexer-cards
        :_  this
        [(make-ping-wait-card:uc next-ping-time) cards]
      ==
    ::
        [%ping-timeout @ ~]
      ?+    sign-arvo  (on-arvo:def wire sign-arvo)
          [%behn %wake *]
        =/  until=@da  (slav %da i.t.wire)
        ?:  (gth until now.bowl)  `this
        =.  indexer-sources-ping-results
          =/  ping-tids-list=(list [@ta shard=id:smart d=dock])
            ~(tap by ping-tids)
          |-
          ?~  ping-tids-list
            %-  ~(gas by *_indexer-sources-ping-results)
            %+  turn  ~(tap by indexer-sources-ping-results)
            |=  $:  shard=id:smart
                    (set dock)
                    (set dock)
                    newest-up=(set dock)
                    newest-down=(set dock)
                ==
            [shard newest-up newest-down ~ ~]
          =*  shard  shard.i.ping-tids-list
          =*  d      d.i.ping-tids-list
          %=  $
              ping-tids-list  t.ping-tids-list
              indexer-sources-ping-results
            =/  [pu=(set dock) pd=(set dock) nu=(set dock) nd=(set dock)]
              %+  ~(gut by indexer-sources-ping-results)
              shard  [~ ~ ~ ~]
            %+  ~(put by indexer-sources-ping-results)
            shard  [pu pd nu (~(put in nd) d)]
          ==
        :-  %-  zing
            :-  move-downed-subscriptions
            %+  turn  ~(tap by ping-tids)
            |=  [tid=@ta id:smart dock]
            :+    %+  ~(poke-our pass:io /pinger/[tid])
                    %spider
                  [%spider-stop !>(`[@ta ?]`[tid %.y])]
              (~(leave-our pass:io /pinger/[tid]) %spider)
            ~
        %=  this
            ping-tids       ~
            pings-timedout  ~
        ==
      ==
    ==
    ::
    ++  move-downed-subscriptions
      ^-  (list card)
      %-  zing
      %+  turn  ~(tap by indexer-sources-ping-results)
      |=  $:  shard=id:smart
              previous-up=(set dock)
              previous-down=(set dock)
              newest-up=(set dock)
              newest-down=(set dock)
          ==
      %+  roll  ~(tap by wex.bowl)
      |=  [[[w=^wire s=ship t=term] a=? p=path] out=(list card)]
      ?.  (~(has in previous-down) [s t])
        out
      ?~  source=(get-best-source:uc shard ~ %nu)  out
      :+  (~(leave pass:io w) [s t])
        %+  ~(watch pass:io w)  p.u.source
        ?.(?=(%history (rear p)) p (snip p))
      out
    ::
    ++  make-ping-indexer-cards
      ^-  (quip card _state)
      =|  cards=(list card)
      =|  tids=(list [@ta (pair id:smart dock)])
      =/  all-indexer-sources=(list (pair id:smart dock))
        %-  zing
        %+  turn  ~(tap by indexer-sources)
        |=  [shard=id:smart docks=(set dock)]
        %+  turn  ~(tap in docks)
        |=(d=dock [shard d])
      |-
      ?~  all-indexer-sources
        =.  pings-timedout  `(add now.bowl ping-timeout)
        :_  state(ping-tids (~(gas by *_ping-tids) tids))
        ?>  ?=(^ pings-timedout)
        :-  %.  u.pings-timedout
            %~  wait  pass:io
            /ping-timeout/(scot %da u.pings-timedout)
        cards
      =*  shard  p.i.all-indexer-sources
      =*  d      q.i.all-indexer-sources
      =/  tid=@ta
        %+  rap  3
        :~  'ted-'
            (scot %uw (sham eny.bowl))
            '-'
            (scot %ux shard)
            '-'
            (scot %p p.d)
        ==
      =/  =start-args:spider
        :-  ~
        :^  `tid  byk.bowl(r da+now.bowl)
        %uqbar-pinger  !>(`dock`d)
      %=  $
          all-indexer-sources  t.all-indexer-sources
          tids  [[tid i.all-indexer-sources] tids]
      ::
          cards
        :+  %+  ~(watch-our pass:io /pinger/[tid])
            %spider  /thread-result/[tid]
          %+  ~(poke-our pass:io /pinger/[tid])  %spider
          [%spider-start !>(`start-args:spider`start-args)]
        cards
      ==
    --
  ::
  ++  on-peek
    |=  =path
    ^-  (unit (unit cage))
    ::  all scrys should return a unit
    ::
    ::  TODO: revisit this when remote scry is a thing..
    ::
    ?.  =(%x -.path)  ~
    ?+    +.path  (on-peek:def path)
        [%indexer @ *]
      =/  is-json=?  ?=(%json i.t.t.path)
      ?.  is-json
        :^  ~  ~  %indexer-update
        !>  ^-  update:ui
        .^(update:ui %gx (scry:io %indexer (snoc t.t.path %noun)))
      :^  ~  ~  %json
      !>  ^-  json
      .^(json %gx (scry:io %indexer (snoc t.t.path %json)))
    ::
    ::  TODO: scry wallet?
    ::   first need unified type to cast with scry
    ::     [%wallet *]
    ::   :^  ~  ~  %noun
    ::   !>  ^-  update:ui
    ::   .^(update:ui %gx (scry:io %indexer (snoc t.t.path %noun)))
    ==
  ::
  ++  on-leave
    |=  =path
    |^  ^-  (quip card _this)
    ?>  =(src.bowl our.bowl)
    :_  this
    ?+    -.path  !!
        %track  ~
        %wallet
      ::  must be of the form, e.g.,
      ::   /wallet/[requesting-app-name]/[*-updates]
      ?.  ?=([%wallet @ @ ~] path)  ~
      leave-wallet
    ::
        %indexer
      ::  must be of the form, e.g.,
      ::   /indexer/[requesting-app-name]/grain/[shard-id]/[grain-id]
      ?.  ?=([%indexer @ @ @ @ ~] path)  ~
      leave-indexer
    ==
    ::
    ++  leave-wallet
      ^-  (list card)
      [(~(leave-our pass:io path) wallet-source)]~
    ::
    ++  leave-indexer
      ^-  (list card)
      ?~  dock-path=(get-wex-dock-by-wire:uc path)  ~
      [(~(leave pass:io path) p.u.dock-path)]~
    --
  ++  on-fail   on-fail:def
  --
::
::  uqbar-core
::
|_  =bowl:gall
+*  io  ~(. agentio bowl)
::
++  make-ping-wait-card
  |=  next-ping-time=@da
  ^-  card
  %.  next-ping-time
  %~  wait  pass:io
  /start-indexer-ping/(scot %da next-ping-time)
::
++  make-next-ping-time
  |=  [min-time=@dr max-time=@dr]
  ^-  @da
  %+  add  now.bowl
  %+  add  min-time
  %-  ~(rad og eny.bowl)
  (sub max-time min-time)
::
++  roll-without-replacement
  |=  [max=@ud seen=(list @ud)]
  ^-  [@ud (list @ud)]
  =/  number-seen=@ud  (lent seen)
  =/  roll=@ud  (~(rad og eny.bowl) (sub max number-seen))
  =|  index=@ud
  |-
  ?:  |(=(number-seen index) (lth roll (snag index seen)))
    =.  roll  (add roll index)
    [roll (into seen index roll)]
  $(index +(index))
::
++  get-wex-dock-by-wire
  |=  =wire
  ^-  (unit (pair dock path))
  ?:  =(0 ~(wyt by wex.bowl))  ~
  =/  wexs=(list [[w=^wire s=ship t=term] a=? p=path])
    ~(tap by wex.bowl)
  |-
  ?~  wexs  ~
  =*  wex  i.wexs
  ?.  =(wire w.wex)  $(wexs t.wexs)
  `[[s.wex t.wex] p.wex]
::
++  get-best-source
  |=  [shard=id:smart seen=(list @ud) level=?(%nu %nd %pu %pd %~)]
  ^-  (unit [p=dock q=(list @ud) r=?(%nu %nd %pu %pd %~)])
  ::  TODO:
  ::   temporary hack to reduce fragility, since the
  ::   complicated fallback logic below is not required
  ::   until remote scry (because all users must host their
  ::   own %indexer anyways). Once remote scry is out,
  ::   revisit the fallback logic below and make it robust.
  `[[our.bowl %indexer] ~ %~]
  :: |^  ^-  (unit [p=dock q=(list @ud) r=?(%nu %nd %pu %pd %~)])
  :: ?:  ?=(%~ level)  ~
  :: =/  best-source  get-best-source-inner
  :: ?~  best-source  ~
  :: ?^  p.u.best-source  `[u.p.u.best-source +.u.best-source]
  :: %=  $
  ::     seen   q.u.best-source
  ::     level  r.u.best-source
  :: ==
  :: ::
  :: ++  get-best-source-inner
  ::   ^-  (unit [p=(unit dock) q=(list @ud) r=?(%nu %nd %pu %pd %~)])
  ::   =+  shard-spr=(~(get by indexer-sources-ping-results) shard-id)
  ::   =+  shard-s=(~(get ju indexer-sources) shard-id)
  ::   ?~  shard-spr
  ::     =/  size-shard-s=@ud  ~(wyt in shard-s)
  ::     ?:  =(0 size-shard-s)  ~
  ::     =^  index  seen
  ::       (roll-without-replacement size-shard-s seen)
  ::     `[`(snag index ~(tap in shard-s)) seen %~]
  ::   =/  [level-shard-spr=(set dock) next-level=?(%nu %nd %pu %pd %~)]
  ::     =*  newest-up    newest-up.u.shard-spr
  ::     =*  newest-down  newest-down.u.shard-spr
  ::     =/  newest-seen-so-far=(set dock)
  ::       (~(uni in newest-up) newest-down)
  ::     ?+    level  !!  ::  TODO: handle better?
  ::         %nu
  ::       :-  newest-up
  ::       ?:  (gth ~(wyt in newest-up) (lent seen))  level
  ::       ?:(=(shard-s newest-seen-so-far) %nd %pu)
  ::     ::
  ::         %pu
  ::       =*  previous-up  previous-up.u.shard-spr
  ::       :-  (~(dif in previous-up) newest-seen-so-far)
  ::       ?:((gth ~(wyt in previous-up) (lent seen)) level %pd)
  ::     ::
  ::         %pd
  ::       =*  previous-down  previous-down.u.shard-spr
  ::       :-  (~(dif in previous-down) newest-seen-so-far)
  ::       ?:((gth ~(wyt in previous-down) (lent seen)) level %nd)
  ::     ::
  ::         %nd
  ::       :-  newest-down
  ::       ?:((gth ~(wyt in newest-down) (lent seen)) level %~)
  ::     ==
  ::   =/  size-level-shard-spr=@ud  ~(wyt in level-shard-spr)
  ::   ?:  =(0 size-level-shard-spr)  `[~ seen next-level]
  ::   =^  index  seen
  ::     (roll-without-replacement size-level-shard-spr seen)
  ::   :^  ~  `(snag index ~(tap in level-shard-spr))
  ::   ?.(=(level next-level) ~ seen)  next-level
  :: --
--
