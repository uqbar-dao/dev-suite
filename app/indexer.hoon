::  indexer [UQ| DAO]:
::
::  Index blocks
::
::    Receive new blocks, index them,
::    and update subscribers with full blocks
::    or with hashes of interest
::
::
::    ## Scry paths
::
::    Most scry paths accepts one or two @ux arguments.
::    A single argument is interpreted as the hash of the
::    queried item (e.g., for a /grain query, the grain-id).
::    For two arguments, the first is interpreted as the
::    town-id in which to query for the second, the item hash.
::    In other words, two arguments restricts the query to
::    a town, while one argument queries all indexed towns.
::
::
::    /x/batch/[batch-id=@ux]
::    /x/batch/[town-id=@ux]/[batch-id=@ux]:
::      An entire batch.
::    /x/batch-order/[town-id=@ux]
::    /x/batch-order/[town-id=@ux]/[nth-most-recent=@ud]/[how-many=@ud]:
::      The order of batches for a town, or a subset thereof.
::    /x/egg/[egg-id=@ux]:
::    /x/egg/[town-id=@ux]/[egg-id=@ux]:
::      Info about egg (transaction) with the given hash.
::    /x/from/[egg-id=@ux]:
::    /x/from/[town-id=@ux]/[from-id=@ux]:
::      History of sender with the given hash.
::    /x/grain/[grain-id=@ux]:
::    /x/grain/[town-id=@ux]/[grain-id=@ux]:
::      Historical states of grain with given hash.
::    /x/grain-eggs/[grain-id=@ux]:
::    /x/grain-eggs/[town-id=@ux]/[grain-id=@ux]:
::      Eggs involving grain with given hash.
::    /x/hash/[hash=@ux]:
::    /x/hash/[town-id=@ux]/[hash=@ux]:
::      Info about hash (queries all indexes for hash).
::    /x/holder/[holder-id=@ux]:
::    /x/holder/[town-id=@ux]/[holder-id=@ux]:
::      Grains held by id with given hash.
::    /x/id/[id=@ux]:
::    /x/id/[town-id=@ux]/[id=@ux]:
::      History of id (queries `from`s and `to`s).
::    /x/lord/[lord-id=@ux]:
::    /x/lord/[town-id=@ux]/[lord-id=@ux]:
::      Grains ruled by lord with given hash.
::    /x/to/[to-id=@ux]:
::    /x/to/[town-id=@ux]/[to-id=@ux]:
::      History of receiver with the given hash.
::    /x/town/[town-id=@ux]:
::    /x/town/[town-id=@ux]/[town-id=@ux]:
::      History of town: all batches.
::
::
::    ## Subscription paths
::
::    /grain/[grain-id=@ux]
::    /grain/[town-id=@ux]/[grain-id=@ux]:
::      A stream of changes to given grain.
::      Reply on-watch is entire grain history.
::
::    :: /hash/[@ux]:  ::  TODO: implement
::    ::   A stream of new activity of given id.
::
::    /holder/[holder-id=@ux]
::    /holder/[town-id=@ux]/[holder-id=@ux]:
::      A stream of new activity of given holder.
::      Reply on-watch is entire history of held grains.
::
::    /id/[id=@ux]
::    /id/[town-id=@ux]/[id=@ux]:
::      A stream of new transactions of given id.
::      Reply on-watch is all historical
::      transactions `from` or `to` id.
::
::    /lord/[lord-id=@ux]
::    /lord/[town-id=@ux]/[lord-id=@ux]:
::      A stream of new activity of given lord.
::      Reply on-watch is entire history of ruled grains.
::
::    /town/[town-id=@ux]
::    /town/[town-id=@ux]/[town-id=@ux]:
::      A stream of each new batch for town.
::      Reply on-watch is history of batches in town.
::
::
::    ##  Pokes
::
::    %indexer-catchup:
::      Get historical state from target indexer.
::      WARNING: Overwrites current state, so should
::      only be used when bootstrapping a new indexer.
::
::    %set-sequencer:
::      Subscribe to sequencer for new batches.
::
::    %set-rollup:
::      Subscribe to rollup for new batch roots.
::
::    :: %consume-indexer-update:  ::  TODO: implement
::    ::   Add a block or chunk to the index.
::
::    :: %serve-update:
::
::
/-  ui=indexer,
    seq=sequencer,
    mill
/+  agentio,
    dbug,
    default-agent,
    verb,
    smart=zig-sys-smart
::
|%
+$  card  card:agent:gall
::
+$  versioned-state
  $%  base-state-0
  ==
::
+$  base-state-0
  $:  %0
      =batches-by-town:ui
      =capitol:seq
      =sequencer-update-queue:ui
      =town-update-queue:ui
  ==
+$  indices-0
  $:  =egg-index:ui
      from-index=second-order-index:ui
      grain-index=batch-index:ui
      grain-eggs-index=second-order-index:ui
      holder-index=second-order-index:ui
      lord-index=second-order-index:ui
      to-index=second-order-index:ui
      =newest-batch-by-town:ui
  ==
+$  inflated-state-0  [base-state-0 indices-0]
::
--
::
=|  inflated-state-0
=*  state  -
::
%-  agent:dbug
%+  verb  |
^-  agent:gall
=<
  |_  =bowl:gall
  +*  this          .
      def           ~(. (default-agent this %|) bowl)
      io            ~(. agentio bowl)
      indexer-core  +>
      ic            ~(. indexer-core bowl)
  ::
  ++  on-init  `this
  ++  on-save  !>(-.state)
  ++  on-load
    |=  =old=vase
    =/  old  !<(versioned-state old-vase)
    ?-    -.old
        %0
      :-  ~
      %=  this
          state
        :-  old
        (inflate-state ~(tap by batches-by-town.old))
      ==
    ==
  ::
  ++  on-poke
    |=  [=mark =vase]
    ^-  (quip card _this)
    ?>  (team:title our.bowl src.bowl)
    ?+    mark  (on-poke:def mark vase)
        %set-sequencer
      :_  this
      %^    set-watch-target:ic
          sequencer-wire
        !<(dock vase)
      sequencer-path
    ::
        %set-rollup
      :_  this
      %+  weld
        %^    set-watch-target:ic
            rollup-capitol-wire
          !<(dock vase)
        rollup-capitol-path
      %^    set-watch-target:ic
          rollup-root-wire
        !<(dock vase)
      rollup-root-path
    ::
        %indexer-catchup
      :_  this
      %^    set-watch-target:ic
          indexer-catchup-wire
        !<(dock vase)
      indexer-catchup-path
    ::
    ::  TODO: add %consume-update and %serve-update pokes
    ::  https://github.com/uqbar-dao/ziggurat/blob/da1d37adf538ee908945557a68387d3c87e1c32e/app/uqbar-indexer.hoon#L138
    ==
  ::
  ++  on-watch
    |=  =path
    ^-  (quip card _this)
    ?+    path  (on-watch:def path)
      ::   [%hash @ ~]
      :: :_  this
      :: =/  hash=@ux  (slav %ux i.t.path)
      :: ?~  update=(get-hashes hash)  ~
      :: :_  ~
      :: %-  fact:io
      :: :_  ~
      :: [%indexer-update !>(`update:ui`update)]
    ::
        [%indexer-catchup ~]
      :_  this
      %-  fact-init-kick:io
      :-  %indexer-catchup
      !>(`batches-by-town:ui`batches-by-town)
    ::
        [%capitol-updates ~]
      :_  this
      :_  ~
      %-  fact:io
      :_  ~
      :-  %sequencer-capitol-update
      !>(`capitol-update:seq`[%new-capitol capitol])
    ::
        ?([%id @ ~] [%id @ @ ~])
      :_  this
      =/  =query-payload:ui
        ?:  ?=([@ @ ~] path)  (slav %ux i.t.path)
        ?>  ?=([@ @ @ ~] path)
        [(slav %ux i.t.path) (slav %ux i.t.t.path)]
      ?~  update=(get-ids query-payload)  ~
      :_  ~
      %-  fact:io
      :_  ~
      [%indexer-update !>(`update:ui`update)]
    ::
        $?  [%grain @ ~]       [%grain @ @ ~]
            [%grain-eggs @ ~]  [%grain-eggs @ @ ~]
            [%holder @ ~]      [%holder @ @ ~]
            [%lord @ ~]        [%lord @ @ ~]
            [%town @ ~]        [%town @ @ ~]
        ==
      :_  this
      =/  =query-type:ui  i.path
      =/  =query-payload:ui
        ?:  ?=([@ @ ~] path)  (slav %ux i.t.path)
        ?>  ?=([@ @ @ ~] path)
        [(slav %ux i.t.path) (slav %ux i.t.t.path)]
      ?~  update=(serve-update query-type query-payload)  ~
      :_  ~
      %-  fact:io
      :_  ~
      [%indexer-update !>(`update:ui`update)]
    ==
  ::
  ++  on-leave
    |=  =path
    ^-  (quip card _this)
    ?+    path  (on-leave:def path)
        $?  [%grain *]
            :: [%hash @ ~]
            [%grain-eggs *]
            [%holder *]
            [%id *]
            [%lord *]
            [%town *]
            [%capitol-updates ~]
            [%indexer-catchup ~]
        ==
      `this
    ==
  ::
  ++  on-peek
    |=  =path
    ^-  (unit (unit cage))
    |^
    ?+    path  (on-peek:def path)
        ?([%x %hash @ ~] [%x %hash @ @ ~])
      =/  =query-payload:ui
        ?:  ?=([@ @ @ ~] path)  (slav %ux i.t.t.path)
        read-two-hashes-from-path
      :^  ~  ~  %indexer-update
      !>(`update:ui`(get-hashes query-payload))
    ::
        ?([%x %id @ ~] [%x %id @ @ ~])
      =/  =query-payload:ui
        ?:  ?=([@ @ @ ~] path)  (slav %ux i.t.t.path)
        read-two-hashes-from-path
      :^  ~  ~  %indexer-update
      !>(`update:ui`(get-ids query-payload))
    ::
        $?  [%x %batch @ ~]       [%x %batch @ @ ~]
            [%x %egg @ ~]         [%x %egg @ @ ~]
            [%x %from @ ~]        [%x %from @ @ ~]
            [%x %grain @ ~]       [%x %grain @ @ ~]
            [%x %grain-eggs @ ~]  [%x %grain-eggs @ @ ~]
            [%x %holder @ ~]      [%x %holder @ @ ~]
            [%x %lord @ ~]        [%x %lord @ @ ~]
            [%x %to @ ~]          [%x %to @ @ ~]
            [%x %town @ ~]        [%x %town @ @ ~]
        ==
      =/  =query-type:ui  ;;(query-type:ui i.t.path)
      =/  =query-payload:ui
        ?:  ?=([@ @ @ ~] path)  (slav %ux i.t.t.path)
        read-two-hashes-from-path
      :^  ~  ~  %indexer-update
      !>(`update:ui`(serve-update query-type query-payload))
    ::
        $?  [%x %newest-egg @ ~]
            [%x %newest-from @ ~]
            [%x %newest-grain @ ~]
            [%x %newest-grain-eggs @ ~]
            [%x %newest-holder @ ~]
            [%x %newest-lord @ ~]
            [%x %newest-to @ ~]
            [%x %newest-egg @ @ ~]
            [%x %newest-from @ @ ~]
            [%x %newest-grain @ @ ~]
            [%x %newest-grain-eggs @ @ ~]
            [%x %newest-holder @ @ ~]
            [%x %newest-lord @ @ ~]
            [%x %newest-to @ @ ~]
        ==
      =/  =query-type:ui
        ;;(query-type:ui (crip (slag 7 (trip i.t.path))))
      =/  =query-payload:ui
        ?:  ?=([@ @ @ ~] path)  (slav %ux i.t.t.path)
        read-two-hashes-from-path
      :^  ~  ~  %indexer-update
      !>  ^-  update:ui
      (get-newest-update-from-index query-type query-payload)
    ::
        [%x %batch-order @ ~]
      =/  town-id=@ux  (slav %ux i.t.t.path)
      :^  ~  ~  %indexer-batch-order
      ?~  bs=(~(get by batches-by-town) town-id)  !>(~)
      !>(`batch-order:ui`batch-order.u.bs)
    ::
        [%x %batch-order @ @ @ ~]
      =/  [town-id=@ux nth-most-recent=@ud how-many=@ud]
        :+  (slav %ux i.t.t.path)  (slav %ud i.t.t.t.path)
        (slav %ud i.t.t.t.t.path)
      :^  ~  ~  %indexer-batch-order
      ?~  bs=(~(get by batches-by-town) town-id)  !>(~)
      !>  ^-  batch-order:ui
      (swag [nth-most-recent how-many] batch-order.u.bs)
    ==
    ::
    ++  read-two-hashes-from-path
      ^-  [@ux @ux]
      ?>  ?=([@ @ @ @ ~] path)
      [(slav %ux i.t.t.path) (slav %ux i.t.t.t.path)]
    --
  ::
  ++  on-agent
    |=  [=wire =sign:agent:gall]
    |^  ^-  (quip card _this)
    ?+    wire  (on-agent:def wire sign)
        ?([%rollup-capitol-update ~] [%rollup-root-update ~])
      ?+    -.sign  (on-agent:def wire sign)
          %kick
        :_  this
        =/  old-source=(unit dock)
          (get-wex-dock-by-wire:ic wire)
        ?~  old-source  ~
        :_  ~
        %^    watch-target:ic
            wire
          u.old-source
        ?:  ?=(%rollup-capitol-update -.wire)
          rollup-capitol-path
        rollup-root-path
      ::
          %fact
        =^  cards  state
          %-  consume-rollup-update
          !<(rollup-update:seq q.cage.sign)
        [cards this]
      ==
    ::
        [%sequencer-update ~]
      ?+    -.sign  (on-agent:def wire sign)
          %kick
        :_  this
        =/  old-source=(unit dock)
          (get-wex-dock-by-wire:ic wire)
        ?~  old-source  ~
        :_  ~
        %^    watch-target:ic
            sequencer-wire
          u.old-source
        sequencer-path
      ::
          %fact
        =^  cards  state
          %-  consume-sequencer-update
          !<(indexer-update:seq q.cage.sign)
        [cards this]
      ==
    ::
        [%indexer-catchup-update ~]
      ?+    -.sign  (on-agent:def wire sign)
          %fact
        =.  town-update-queue
          %-  ~(gas by town-update-queue)
          %+  turn  ~(tap by capitol)
          |=  [town-id=id:smart =hall:seq]
          :-  town-id
          %-  %~  gas  by
              (~(gut by town-update-queue) town-id *(map @ux @da))
          %+  turn  roots.hall
          |=  root=@ux
          [root now.bowl]  ::  TODO: improve initial timestamping
        =.  batches-by-town
          !<(batches-by-town:ui q.cage.sign)
        :-  ~
        %=  this
            +.state
          (inflate-state ~(tap by batches-by-town))
        ==
      ==
    ==
    ::
    :: +consume-indexer-update:
    :: https://github.com/uqbar-dao/ziggurat/blob/da1d37adf538ee908945557a68387d3c87e1c32e/app/uqbar-indexer.hoon#L697
    ::
    ++  consume-rollup-update
      |=  update=rollup-update:seq
      ^-  (quip card _state)
      ?-    -.update
          %new-sequencer
        `state
      ::
          %new-capitol
        :_  state(capitol capitol.update)
        :_  ~
        %+  fact:io
          :-  %sequencer-capitol-update
          !>(`capitol-update:seq`update)
        ~[rollup-capitol-path]
      ::
          %new-peer-root
        =*  town-id  town-id.update
        =/  indexer-update
          ^-  (unit [eggs=(list [@ux egg:smart]) =town:seq])
          %.  root.update
          %~  get  by
          %+  ~(gut by sequencer-update-queue)  town-id
          *(map @ux [(list [@ux egg:smart]) town:seq])
        ?~  indexer-update
          :-  ~
          %=  state
              town-update-queue
            %+  ~(put by town-update-queue)  town-id
            %+  %~  put  by
                %+  ~(gut by town-update-queue)  town-id
                *(map batch-id=@ux timestamp=@da)
            root.update  timestamp.update
          ==
        =^  cards  state
          %:  consume-batch
              root.update
              eggs.u.indexer-update
              town.u.indexer-update
              timestamp.update
              %.y
          ==
        :-  cards
        %=  state
            sequencer-update-queue
          %+  ~(jab by sequencer-update-queue)  town-id
          |=  town-queue=(map @ux [(list [@ux egg:smart]) town:seq])
          (~(del by town-queue) root.update)
        ==
      ==
    ::
    ++  consume-sequencer-update
      |=  update=indexer-update:seq
      ^-  (quip card _state)
      ?-    -.update
          %update
        ?>  =(root.update (sham land.town.update))
        =*  town-id  town-id.hall.town.update
        =/  timestamp=(unit @da)
          %.  root.update
          %~  get  by
          %+  ~(gut by town-update-queue)  town-id
          *(map @ux @da)
        ?~  timestamp
          :-  ~
          %=  state
              sequencer-update-queue
            %+  ~(put by sequencer-update-queue)  town-id
            %+  %~  put  by
                %+  ~(gut by sequencer-update-queue)  town-id
                *(map @ux [(list [@ux egg:smart]) town:seq])
              root.update
            [eggs.update town.update]
          ==
        =^  cards  state
          %:  consume-batch
              root.update
              eggs.update
              town.update
              u.timestamp
              %.y
          ==
        :-  cards
        %=  state
            town-update-queue
          %+  ~(put by town-update-queue)  town-id
          %.  root.update
          ~(del by (~(got by town-update-queue) town-id))
        ==
      ==
    --
  ::
  ++  on-arvo  on-arvo:def
  ++  on-fail  on-fail:def
  --
::
|_  =bowl:gall
+*  io  ~(. agentio bowl)
::
++  rollup-capitol-wire
  ^-  wire
  /rollup-capitol-update
::
++  rollup-root-wire
  ^-  wire
  /rollup-root-update
::
++  sequencer-wire
  ^-  wire
  /sequencer-update
::
++  indexer-catchup-wire
  ^-  wire
  /indexer-catchup-update
::
++  rollup-capitol-path
  ^-  path
  /capitol-updates
::
++  rollup-root-path
  ^-  path
  /peer-root-updates
::
++  sequencer-path
  ^-  path
  /indexer/updates
::
++  indexer-catchup-path
  ^-  path
  /indexer-catchup
::
++  watch-target
  |=  [w=wire d=dock p=path]
  ^-  card
  (~(watch pass:io w) d p)
::
++  leave-wire
  |=  w=wire
  ^-  (unit card)
  =/  old-source=(unit dock)
    (get-wex-dock-by-wire w)
  ?~  old-source  ~
  :-  ~
  %-  ~(leave pass:io w)
  u.old-source
::
++  set-watch-target
  |=  [w=wire d=dock p=path]
  ^-  (list card)
  =/  watch-card=card  (watch-target w d p)
  =/  leave-card=(unit card)  (leave-wire w)
  ?~  leave-card
    ~[watch-card]
  ~[u.leave-card watch-card]
::
++  get-wex-dock-by-wire
  |=  w=wire
  ^-  (unit dock)
  ?:  =(0 ~(wyt by wex.bowl))  ~
  =/  wexs=(list [w=wire s=ship t=term])
    ~(tap in ~(key by wex.bowl))
  |-
  ?~  wexs  ~
  =*  wex  i.wexs
  ?.  =(w w.wex)
    $(wexs t.wexs)
  :-  ~
  [s.wex t.wex]
::
++  get-batch
  |=  [town-id=id:smart batch-root=id:smart]
  ^-  (unit [@da batch:ui])
  ?~  bs=(~(get by batches-by-town) town-id)  ~
  ?~  b=(~(get by batches.u.bs) batch-root)   ~
  `u.b
::
++  get-newest-batch
  |=  town-id=id:smart
  ^-  (unit [batch-id=id:smart timestamp=@da =batch:ui])
  ?~  b=(~(get by newest-batch-by-town) town-id)  ~
  `u.b
::
++  combine-egg-updates
  |=  updates=(list update:ui)
  ^-  update:ui
  ?~  update=(combine-egg-updates-to-map updates)  ~
  [%egg update]
::
++  get-ids
  |=  =query-payload:ui
  ^-  update:ui
  =/  from=update:ui  (serve-update %from query-payload)
  =/  to=update:ui    (serve-update %to query-payload)
  (combine-egg-updates ~[from to])
::
++  get-hashes
  |=  =query-payload:ui
  ^-  update:ui
  =/  batch=update:ui       (serve-update %batch query-payload)
  =/  egg=update:ui         (serve-update %egg query-payload)
  =/  from=update:ui        (serve-update %from query-payload)
  =/  grain=update:ui       (serve-update %grain query-payload)
  =/  grain-eggs=update:ui  (serve-update %grain-eggs query-payload)
  =/  holder=update:ui      (serve-update %holder query-payload)
  =/  lord=update:ui        (serve-update %lord query-payload)
  =/  to=update:ui          (serve-update %to query-payload)
  =/  town=update:ui        (serve-update %town query-payload)
  %^  combine-updates  ~[batch town]  ~[egg from to]
  ~[grain holder lord]
::
++  combine-batch-updates-to-map
  |=  updates=(list update:ui)
  ^-  (map id:smart [@da town-location:ui batch:ui])
  ?~  updates  ~
  %-  %~  gas  by
      *(map id:smart [@da town-location:ui batch:ui])
  %-  zing
  %+  turn  updates
  |=  =update:ui
  ?~  update               ~
  ?.  ?=(%batch -.update)  ~
  ~(tap by batches.update)
::
++  combine-egg-updates-to-map
  |=  updates=(list update:ui)
  ^-  (map id:smart [@da egg-location:ui egg:smart])
  ?~  updates  ~
  %-  %~  gas  by
      *(map id:smart [@da egg-location:ui egg:smart])
  %-  zing
  %+  turn  updates
  |=  =update:ui
  ?~  update             ~
  ?.  ?=(%egg -.update)  ~
  ~(tap by eggs.update)
::
++  combine-grain-updates-to-jar  ::  TODO: can this clobber?
  |=  updates=(list update:ui)
  ^-  (jar id:smart [@da batch-location:ui grain:smart])
  ?~  updates  ~
  %-  %~  gas  by
      *(jar id:smart [@da batch-location:ui grain:smart])
  %-  zing
  %+  turn  updates
  |=  =update:ui
  ?~  update               ~
  ?.  ?=(%grain -.update)  ~
  ~(tap by grains.update)
::
++  combine-updates
  |=  $:  batch-updates=(list update:ui)
          egg-updates=(list update:ui)
          grain-updates=(list update:ui)
      ==
  ^-  update:ui
  ?:  ?&  ?=(~ batch-updates)
          ?=(~ egg-updates)
          ?=(~ grain-updates)
      ==
    ~
  =/  combined-batch=(map id:smart [@da town-location:ui batch:ui])
    (combine-batch-updates-to-map batch-updates)
  =/  combined-egg=(map id:smart [@da egg-location:ui egg:smart])
    (combine-egg-updates-to-map egg-updates)
  =/  combined-grain=(jar id:smart [@da batch-location:ui grain:smart])
    (combine-grain-updates-to-jar grain-updates)
  ?:  ?&  ?=(~ combined-batch)
          ?=(~ combined-egg)
          ?=(~ combined-grain)
      ==
    ~
  [%hash combined-batch combined-egg combined-grain]
::
++  inflate-state
  |=  batches-by-town-list=(list [@ux =batches:ui batch-order:ui])
  ^-  indices-0
  =|  temporary-state=_state
  |^
  ?~  batches-by-town-list  +.temporary-state
  =/  batches-list=(list [root=@ux timestamp=@da =batch:ui])
    ~(tap by batches.i.batches-by-town-list)
  %=  $
      batches-by-town-list  t.batches-by-town-list
      temporary-state       (inflate-town batches-list)
  ==
  ::
  ++  inflate-town
    |=  batches-list=(list [root=@ux timestamp=@da =batch:ui])
    ^-  _state
    |-
    ?~  batches-list  temporary-state
    =^  cards  temporary-state  ::  throw away cards (empty)
      %:  consume-batch(state temporary-state)
          root.i.batches-list
          transactions.batch.i.batches-list
          +.batch.i.batches-list
          timestamp.i.batches-list
          %.n
      ==
    $(batches-list t.batches-list)
  --
::
++  get-newest-update-from-index
  ::  TODO: combine with `+serve-update`?
  |=  [=query-type:ui =query-payload:ui]
  ^-  update:ui
  ?.  ?=(?(@ [@ @]) query-payload)  ~
  |^
  ?+    query-type  !!
      %grain
    get-grain
  ::
      %egg
    get-egg
  ::
      ?(%from %grain-eggs %holder %lord %to)
    get-second-order
  ==
  ::
  ++  get-grain
    =/  locations=(list location:ui)  get-newest-locations
    =|  grains=(jar grain-id=id:smart [@da batch-location:ui grain:smart])
    =/  grain-id=id:smart
      ?:  ?=([@ @] query-payload)  +.query-payload
      ?>  ?=(@ query-payload)
      query-payload
    |-
    ?~  locations  ?~(grains ~ [%grain grains])
    =*  location  i.locations
    ?.  ?=(batch-location:ui location)
      $(locations t.locations)
    =*  town-id     town-id.location
    =*  batch-root  batch-root.location
    ?~  b=(get-newest-batch town-id)
      $(locations t.locations)
    ?.  =(batch-root batch-id.u.b)
      $(locations t.locations)
    =*  timestamp  timestamp.u.b
    =*  granary    p.land.batch.u.b
    ?~  grain=(get:big:mill granary grain-id)
      $(locations t.locations)
    %=  $
        locations  t.locations
        grains
      %+  ~(add ja grains)  grain-id
      [timestamp location u.grain]
    ==
  ::
  ++  get-egg
    =/  locations=(list location:ui)  get-newest-locations
    =|  eggs=(map id:smart [@da egg-location:ui egg:smart])
    |-
    ?~  locations  ?~(eggs ~ [%egg eggs])
    =*  location  i.locations
    ?.  ?=(egg-location:ui location)
      $(locations t.locations)
    =*  town-id     town-id.location
    =*  batch-root  batch-root.location
    =*  egg-num     egg-num.location
    ?~  b=(get-newest-batch town-id)
      $(locations t.locations)
    ?.  =(batch-root batch-id.u.b)
      $(locations t.locations)
    =*  timestamp  timestamp.u.b
    =*  txs        transactions.batch.u.b
    ?.  (lth egg-num (lent txs))  $(locations t.locations)
    =+  [hash=@ux =egg:smart]=(snag egg-num txs)
    %=  $
        locations  t.locations
        eggs
      (~(put by eggs) hash [timestamp location egg])
    ==
  ::
  ++  get-second-order
    =/  locations=(list location:ui)  get-newest-locations
    %+  roll  locations
    |=  $:  second-order-id=location:ui
            out=update:ui
        ==
    =/  next-update=update:ui
      %+  get-newest-update-from-index
        ?:  |(?=(%holder query-type) ?=(%lord query-type))
          %grain
        %egg
      second-order-id
    ?~  next-update  out
    ?~  out          next-update
    ?+  -.out  ~|("indexer: get-second-order unexpected update type {<-.out>}" !!)
        %egg
      ?.  ?=(%egg -.next-update)  out
      %=  out
          eggs
        (~(uni by eggs.out) eggs.next-update)
      ==
    ::
        %grain
      ?.  ?=(%grain -.next-update)  out
      %=  out
          grains
        (~(uni by grains.out) grains.next-update)  ::  TODO: can this clobber?
      ==
    ==
  ::
  ++  get-newest-locations
    |^  ^-  (list location:ui)
    ?+  query-type  ~|("indexer: get-newest-locations unexpected query-type {<query-type>}" !!)
      %egg         (get-by-get-ja-first-order egg-index)
      %from        (get-by-get-ja from-index)
      %grain       (get-by-get-ja-first-order grain-index)
      %grain-eggs  (get-by-get-ja grain-eggs-index)
      %holder      (get-by-get-ja holder-index)
      %lord        (get-by-get-ja lord-index)
      %to          (get-by-get-ja to-index)
    ==
    ::
    ++  get-by-get-ja-first-order
      |=  [index=(map @ux (jar @ux location:ui))]
      ^-  (list location:ui)
      ?:  ?=([@ @] query-payload)
        =*  town-id    -.query-payload
        =*  item-hash  +.query-payload
        ?~  town-index=(~(get by index) town-id)      ~
        ?~  items=(~(get ja u.town-index) item-hash)  ~
        ~[i.items]  ::  only return newest
      =*  item-hash  query-payload
      %+  roll  ~(val by index)
      |=  [town-index=(jar @ux location:ui) out=(list location:ui)]
      ?~  items=(~(get ja town-index) item-hash)  out
      [i.items out]  ::  only return newest
    ::
    ++  get-by-get-ja
      |=  [index=(map @ux (jar @ux location:ui))]
      ^-  (list location:ui)
      ?:  ?=([@ @] query-payload)
        =*  town-id    -.query-payload
        =*  item-hash  +.query-payload
        ?~  town-index=(~(get by index) town-id)      ~
        (~(get ja u.town-index) item-hash)
      =*  item-hash  query-payload
      %+  roll  ~(val by index)
      |=  [town-index=(jar @ux location:ui) out=(list location:ui)]
      (weld out (~(get ja town-index) item-hash))
    --
  --
::
++  serve-update
  |=  [=query-type:ui =query-payload:ui]
  |^  ^-  update:ui
  ?+    query-type  !!
      %batch
    get-batch-update
  ::
      ?(%egg %from %grain %grain-eggs %holder %lord %to)
    get-from-index
  ::
      %town
    get-town
  ==
  ::
  ++  get-town
    ?.  ?=(@ query-payload)  ~
    =*  town-id  query-payload
    ?~  bs=(~(get by batches-by-town) town-id)  ~
    :-  %batch
    %-  %~  gas  by
        *(map id:smart [@da town-location:ui batch:ui])
    %+  turn  ~(tap by batches.u.bs)
    |=  [batch-id=id:smart timestamp=@da =batch:ui]
    [batch-id [timestamp town-id batch]]
  ::
  ++  get-batch-update
    ?:  ?=([@ @] query-payload)
      =*  town-id   -.query-payload
      =*  batch-id  +.query-payload
      ?~  b=(get-batch town-id batch-id)  ~
      =*  timestamp  -.u.b
      =*  batch      +.u.b
      :-  %batch
      %+  %~  put  by
          *(map id:smart [@da town-location:ui batch:ui])
      batch-id  [timestamp town-id batch]
    ?.  ?=(@ query-payload)  ~
    =*  batch-id  query-payload
    =/  out=[%batch (map id:smart [@da town-location:ui batch:ui])]
      %+  roll  ~(tap by batches-by-town)
      |=  $:  [town-id=id:smart =batches:ui batch-order:ui]
              out=[%batch (map id:smart [@da town-location:ui batch:ui])]
          ==
      ?~  b=(~(get by batches) batch-id)  out
      =*  timestamp  -.u.b
      =*  batch      +.u.b
      :-  %batch
      (~(put by +.out) batch-id [timestamp town-id batch])
    ?~(+.out ~ out)
  ::
  ++  get-from-index
    ^-  update:ui
    ?.  ?=(?(@ [@ @]) query-payload)  ~
    =/  locations=(list location:ui)  get-locations
    |^
    ?+    query-type  !!
        %grain
      get-grain
    ::
        %egg
      get-egg
    ::
        ?(%from %grain-eggs %holder %lord %to)
      get-second-order
    ==
    ::
    ++  get-grain
      =|  grains=(jar grain-id=id:smart [@da batch-location:ui grain:smart])
      =/  grain-id=id:smart
        ?:  ?=([@ @] query-payload)  +.query-payload
        ?>  ?=(@ query-payload)
        query-payload
      =.  locations  (flop locations)
      |-
      ?~  locations  ?~(grains ~ [%grain grains])
      =*  location  i.locations
      ?.  ?=(batch-location:ui location)
        $(locations t.locations)
      =*  town-id     town-id.location
      =*  batch-root  batch-root.location
      ?~  b=(get-batch town-id batch-root)
        $(locations t.locations)
      =*  timestamp  -.u.b
      =*  granary    p.land.+.u.b
      ?~  grain=(get:big:mill granary grain-id)
        $(locations t.locations)
      %=  $
          locations  t.locations
          grains
        %+  ~(add ja grains)  grain-id
        [timestamp location u.grain]
      ==
    ::
    ++  get-egg
      =|  eggs=(map id:smart [@da egg-location:ui egg:smart])
      |-
      ?~  locations  ?~(eggs ~ [%egg eggs])
      =*  location  i.locations
      ?.  ?=(egg-location:ui location)
        $(locations t.locations)
      =*  town-id     town-id.location
      =*  batch-root  batch-root.location
      =*  egg-num     egg-num.location
      ?~  b=(get-batch town-id batch-root)
        $(locations t.locations)
      =*  timestamp  -.u.b
      =*  txs        transactions.+.u.b
      ?.  (lth egg-num (lent txs))  $(locations t.locations)
      =+  [hash=@ux =egg:smart]=(snag egg-num txs)
      %=  $
          locations  t.locations
          eggs
        (~(put by eggs) hash [timestamp location egg])
      ==
    ::
    ++  get-second-order
      %+  roll  locations
      |=  $:  second-order-id=location:ui
              out=update:ui
          ==
      =/  next-update=update:ui
        %=  get-from-index
            query-payload  second-order-id
            query-type
          ?:  |(?=(%holder query-type) ?=(%lord query-type))
            %grain
          %egg
        ==
      ?~  next-update  out
      ?~  out          next-update
      ?+  -.out  ~|("indexer: get-second-order unexpected update type {<-.out>}" !!)
          %egg
        ?.  ?=(%egg -.next-update)  out
        %=  out
            eggs
          (~(uni by eggs.out) eggs.next-update)
        ==
      ::
          %grain
        ?.  ?=(%grain -.next-update)  out
        %=  out
            grains
          (~(uni by grains.out) grains.next-update)  ::  TODO: can this clobber?
        ==
      ==
    --
  ::
  ++  get-locations
    |^  ^-  (list location:ui)
    ?+  query-type  ~|("indexer: get-locations unexpected query-type {<query-type>}" !!)
      %egg         (get-by-get-ja egg-index)
      %from        (get-by-get-ja from-index)
      %grain       (get-by-get-ja grain-index)
      %grain-eggs  (get-by-get-ja grain-eggs-index)
      %holder      (get-by-get-ja holder-index)
      %lord        (get-by-get-ja lord-index)
      %to          (get-by-get-ja to-index)
    ==
    ::
    ++  get-by-get-ja
      |=  index=(map @ux (jar @ux location:ui))
      ^-  (list location:ui)
      ?:  ?=([@ @] query-payload)
        =*  town-id    -.query-payload
        =*  item-hash  +.query-payload
        ?~  town-index=(~(get by index) town-id)  ~
        (~(get ja u.town-index) item-hash)
      ?.  ?=(@ query-payload)  ~
      =*  item-hash  query-payload
      %+  roll  ~(val by index)
      |=  [town-index=(jar @ux location:ui) out=(list location:ui)]
      (weld out (~(get ja town-index) item-hash))
    --
  --
::
++  consume-batch
  |=  $:  root=@ux
          eggs=(list [@ux egg:smart])
          =town:seq
          timestamp=@da
          should-update-subs=?
      ==
  |^  ^-  (quip card _state)
  =*  town-id  town-id.hall.town
  =+  ^=  [egg from grain holder lord to]
      (parse-batch root town-id eggs land.town)
  =:  egg-index         (gas-ja-egg egg-index egg town-id)
      from-index        (gas-ja-second-order from-index from town-id)
      grain-index       (gas-ja-batch grain-index grain town-id)
      ::  grain-eggs-index  (gas-ja-second-order grain-eggs-index grain-eggs town-id)
      holder-index      (gas-ja-second-order holder-index holder town-id)
      lord-index        (gas-ja-second-order lord-index lord town-id)
      to-index          (gas-ja-second-order to-index to town-id)
      newest-batch-by-town
    %+  ~(put by newest-batch-by-town)  town-id
    [root timestamp eggs town]
  ::
      batches-by-town
    %+  ~(put by batches-by-town)  town-id
    ?~  b=(~(get by batches-by-town) town-id)
      :_  ~[root]
      (malt ~[[root [timestamp eggs town]]])
    :_  [root batch-order.u.b]
    (~(put by batches.u.b) root [timestamp eggs town])
  ==
  :_  state
  ?.(should-update-subs ~ make-all-sub-cards)
  ::
  ++  gas-ja-egg
    |=  $:  index=egg-index:ui
            new=(list [hash=@ux location=egg-location:ui])
            town-id=id:smart
        ==
    %+  ~(put by index)  town-id
    =/  town-index=(jar @ux egg-location:ui)
      ?~(ti=(~(get by index) town-id) ~ u.ti)
    |-
    ?~  new  town-index
    %=  $
        new  t.new
        town-index
      (~(add ja town-index) hash.i.new location.i.new)
    ==
  ::
  ++  gas-ja-batch
    |=  $:  index=batch-index:ui
            new=(list [hash=@ux location=batch-location:ui])
            town-id=id:smart
        ==
    %+  ~(put by index)  town-id
    =/  town-index=(jar @ux batch-location:ui)
      ?~(ti=(~(get by index) town-id) ~ u.ti)
    |-
    ?~  new  town-index
    %=  $
        new  t.new
        town-index
      (~(add ja town-index) hash.i.new location.i.new)
    ==
  ::
  ++  gas-ja-second-order
    |=  $:  index=second-order-index:ui
            new=(list [hash=@ux location=second-order-location:ui])
            town-id=id:smart
        ==
    %+  ~(put by index)  town-id
    =/  town-index=(jar @ux second-order-location:ui)
      (~(gut by index) town-id ~)
    |-
    ?~  new  town-index
    %=  $
        new  t.new
        town-index
      (~(add ja town-index) hash.i.new location.i.new)
    ==
  ::
  ++  make-sub-paths
    ^-  (jug @tas path)
    %-  ~(gas ju *(jug @tas path))
    %+  turn  ~(val by sup.bowl)
    |=  [ship sub-path=path]
    ^-  [@tas path]
    ?>  ?=(^ sub-path)
    [`@tas`i.sub-path t.sub-path]
  ::
  ++  make-all-sub-cards
    ^-  (list card)
    =/  sub-paths=(jug @tas path)
      make-sub-paths
    |^
    %-  zing
    :~  :: (make-sub-cards %batch %batch)
        (make-sub-cards %from %id)
        (make-sub-cards %to %id)
        (make-sub-cards %grain %grain)
        (make-sub-cards %holder %holder)
        (make-sub-cards %lord %lord)
        (make-sub-cards %town %town)
    ==
    ::
    ++  make-sub-cards
      |=  [=query-type:ui path-type=@tas]
      ^-  (list card)
      %+  murn  ~(tap in (~(get ju sub-paths) path-type))
      |=  sub-path=path
      =/  payload=?(@ux [@ux @ux])
        ?:  ?=([@ ~] sub-path)  (slav %ux i.sub-path)
        ?>  ?=([@ @ ~] sub-path)
        [(slav %ux i.sub-path) (slav %ux i.t.sub-path)]
      =/  =update:ui
        (get-newest-update-from-index query-type payload)
      ?~  update  ~
      ?:  ?=(?(%batch %egg) -.update)
        :-  ~
        %+  fact:io  [%indexer-update !>(`update:ui`update)]
        ~[[path-type sub-path]]
      ?.  ?=(%grain -.update)  ~
      =.  grains.update
        %-  ~(gas by *(jar id:smart [@da batch-location:ui grain:smart]))
        %+  murn  ~(tap by grains.update)
        |=  [=id:smart gs=(list [@da batch-location:ui grain:smart])]
        ?~(gs ~ `[id ~[i.gs]])
      :-  ~
      %+  fact:io  [%indexer-update !>(`update:ui`update)]
      ~[[path-type sub-path]]
    --
  ::
  ++  parse-batch
    |=  [root=@ux town-id=@ux eggs=(list [@ux egg:smart]) =land:seq]
    ^-  $:  (list [@ux egg-location:ui])
            (list [@ux second-order-location:ui])
            (list [@ux batch-location:ui])
            (list [@ux second-order-location:ui])
            (list [@ux second-order-location:ui])
            (list [@ux second-order-location:ui])
        ==
    =*  granary  p.land
    =+  [grain holder lord]=(parse-granary root town-id granary)
    =+  [egg from to]=(parse-transactions root town-id eggs)
    [egg from grain holder lord to]
  ::
  ++  parse-granary
    |=  [root=@ux town-id=@ux =granary:seq]
    ^-  $:  (list [@ux batch-location:ui])
            (list [@ux second-order-location:ui])
            (list [@ux second-order-location:ui])
        ==
    =|  parsed-grain=(list [@ux batch-location:ui])
    =|  parsed-holder=(list [@ux second-order-location:ui])
    =|  parsed-lord=(list [@ux second-order-location:ui])
    =/  grains=(list [@ux [@ux grain:smart]])
      ~(tap by granary)
    |-
    ?~  grains  [parsed-grain parsed-holder parsed-lord]
    =*  grain-id   id.p.+.+.i.grains
    =*  holder-id  holder.p.+.+.i.grains
    =*  lord-id    lord.p.+.+.i.grains
    %=  $
        grains         t.grains
    ::
        parsed-holder
      ?:  %+  exists-in-index  town-id
          [holder-id grain-id holder-index]
        parsed-holder
      [[holder-id grain-id] parsed-holder]
    ::
        parsed-lord
      ?:  %+  exists-in-index  town-id
          [lord-id grain-id lord-index]
        parsed-lord
      [[lord-id grain-id] parsed-lord]
    ::
        parsed-grain
      ?:  %+  exists-in-index  town-id
          [grain-id [town-id root] grain-index]
        parsed-grain
      :_  parsed-grain
      :-  grain-id
      [town-id root]
    ==
  ::
  ++  parse-transactions
    |=  [root=@ux town-id=@ux txs=(list [@ux egg:smart])]
    ^-  $:  (list [@ux egg-location:ui])
            (list [@ux second-order-location:ui])
            (list [@ux second-order-location:ui])
        ==
    =|  parsed-egg=(list [@ux egg-location:ui])
    =|  parsed-from=(list [@ux second-order-location:ui])
    =|  parsed-to=(list [@ux second-order-location:ui])
    =/  egg-num=@ud  0
    |-
    ?~  txs
      [parsed-egg parsed-from parsed-to]
    =*  egg-hash     -.i.txs
    =*  egg          +.i.txs
    =*  to           to.shell.egg
    =*  from         id.from.shell.egg
    =/  =egg-location:ui  [town-id root egg-num]
    %=  $
        egg-num      +(egg-num)
        txs          t.txs
        parsed-egg
      ?:  %+  exists-in-index  town-id
          [egg-hash egg-location egg-index]
        parsed-egg
      [[egg-hash egg-location] parsed-egg]
    ::
        parsed-from
      ?:  %+  exists-in-index  town-id
          [from egg-hash from-index]
        parsed-from
      [[from egg-hash] parsed-from]
    ::
        parsed-to
      ?:  %+  exists-in-index  town-id
          [to egg-hash to-index]
        parsed-to
      [[to egg-hash] parsed-to]
    ==
  ::
  ++  exists-in-index
    |=  $:  town-id=@ux
            key=@ux
            val=location:ui
            index=location-index:ui
        ==
    ^-  ?
    ?~  town-index=(~(get by index) town-id)  %.n
    %.  val
    %~  has  in
    %-  %~  gas  in  *(set location:ui)
    (~(get ja u.town-index) key)
  --
--
