::  indexer [UQ| DAO]:
::
::  Index batches
::
::    Receive new batches, index them,
::    and update subscribers with full batches
::    or with hashes of interest.
::    Additionally, accept scries: one-time queries.
::
::
::    ## Scry paths
::
::    Most scry paths accept one or two `@ux` arguments.
::    A single argument is interpreted as the hash of the
::    queried item (e.g., for a `/grain` query, the `grain-id`).
::    For two arguments, the first is interpreted as the
::    `town-id` in which to query for the second, the item hash.
::    In other words, two arguments restricts the query to
::    a town, while one argument queries all indexed towns.
::
::    Scry paths may be prepended with a `/newest`, which
::    will return results only in the most recent batch.
::    For example, the history of all grains held by
::    `0xdead.beef` would be queried using the path
::    `/x/holder/0xdead.beef`
::    while only the most recent state of all grains held
::    by `0xdead.beef` would be queried using
::    `/x/newest/holder/0xdead.beef`.
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
::    :: /x/grain-eggs/[grain-id=@ux]:  ::  TODO: reenable
::    :: /x/grain-eggs/[town-id=@ux]/[grain-id=@ux]:
::    ::   Eggs involving grain with given hash.
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
::    /batch-order/[town-id=@ux]:
::      A stream of batch ids.
::      Reply on-watch in historical batch-order.
::    /grain/[grain-id=@ux]
::    /grain/[town-id=@ux]/[grain-id=@ux]:
::      A stream of changes to given grain.
::      Reply on-watch is entire grain history.
::    /hash/[@ux]:
::      A stream of new activity of given id.
::    /holder/[holder-id=@ux]
::    /holder/[town-id=@ux]/[holder-id=@ux]:
::      A stream of new activity of given holder.
::      Reply on-watch is entire history of held grains.
::    /id/[id=@ux]
::    /id/[town-id=@ux]/[id=@ux]:
::      A stream of new transactions of given id.
::      Reply on-watch is all historical
::      transactions `from` or `to` id.
::    /lord/[lord-id=@ux]
::    /lord/[town-id=@ux]/[lord-id=@ux]:
::      A stream of new activity of given lord.
::      Reply on-watch is entire history of ruled grains.
::    /town/[town-id=@ux]
::    /town/[town-id=@ux]/[town-id=@ux]:
::      A stream of each new batch for town.
::      Reply on-watch is history of batches in town.
::
::
::    ##  Pokes
::
::    %indexer-catchup:
::      Copy state from target indexer.
::      WARNING: Overwrites current state, so should
::      only be used when bootstrapping a new indexer.
::
::    %set-sequencer:
::      Subscribe to sequencer for new batches.
::
::    %set-rollup:
::      Subscribe to rollup for new batch roots.
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
--
::
=|  inflated-state-0:ui
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
    |=  old-vase=vase
    `this(state (set-state-from-vase old-vase))
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
    ==
  ::
  ++  on-watch
    |=  =path
    ^-  (quip card _this)
    ?+    path  (on-watch:def path)
        [%ping ~]
      :_  this
      %-  fact-init-kick:io
      :-  %loob
      !>(`?`%.y)
    ::
        $?  [%batch-order @ %no-init ~]
            [%capitol-updates %no-init ~]
            [%hash @ %no-init ~]    [%hash @ @ %no-init ~]
            [%id @ %no-init ~]      [%id @ @ %no-init ~]
            [%grain @ %no-init ~]   [%grain @ @ %no-init ~]
            [%holder @ %no-init ~]  [%holder @ @ %no-init ~]
            [%lord @ %no-init ~]    [%lord @ @ %no-init ~]
            [%town @ %no-init ~]    [%town @ @ %no-init ~]
        ==
      `this
    ::
        [%indexer-catchup ~]
      :_  this
      %-  fact-init-kick:io
      :-  %indexer-catchup
      !>(`versioned-state:ui`-.state)
    ::
        [%batch-order @ ~]
      :_  this
      =/  town-id=@ux  (slav %ux i.t.path)
      :_  ~
      %-  fact:io
      :_  ~
      :-  %indexer-update
      ?~  bs=(~(get by batches-by-town) town-id)  !>(~)
      !>(`update:ui`[%batch-order batch-order.u.bs])
    ::
        [%capitol-updates ~]
      :_  this
      :_  ~
      %-  fact:io
      :_  ~
      :-  %sequencer-capitol-update
      !>(`capitol-update:seq`[%new-capitol capitol])
    ::
        ?([%hash @ ~] [%hash @ @ ~])
      :_  this
      =/  =query-payload:ui
        ?:  ?=([@ @ ~] path)  (slav %ux i.t.path)
        ?>  ?=([@ @ @ ~] path)
        [(slav %ux i.t.path) (slav %ux i.t.t.path)]
      ?~  update=(get-hashes query-payload %.n)  ~
      :_  ~
      %-  fact:io
      :_  ~
      [%indexer-update !>(`update:ui`update)]
    ::
        ?([%id @ ~] [%id @ @ ~])
      :_  this
      =/  =query-payload:ui
        ?:  ?=([@ @ ~] path)  (slav %ux i.t.path)
        ?>  ?=([@ @ @ ~] path)
        [(slav %ux i.t.path) (slav %ux i.t.t.path)]
      ?~  update=(get-ids query-payload %.n)  ~
      :_  ~
      %-  fact:io
      :_  ~
      [%indexer-update !>(`update:ui`update)]
    ::
        $?  [%grain @ ~]       [%grain @ @ ~]
            :: [%grain-eggs @ ~]  [%grain-eggs @ @ ~]
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
      ?~  update=(serve-update query-type query-payload %.n)  ~
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
        $?  [%batch-order *]
            [%grain *]
            [%hash *]
            :: [%grain-eggs *]
            [%holder *]
            [%id *]
            [%lord *]
            [%town *]
            [%capitol-updates *]
            [%indexer-catchup ~]
        ==
      `this
    ==
  ::
  ++  on-peek
    |=  =path
    ^-  (unit (unit cage))
    ?:  =(/x/dbug/state path)
      ~  ::  Don't send :indexer +dbug %path-does-not-exist.
    ?.  ?=(?([@ @ @ ~] [@ @ @ @ ~] [@ @ @ @ @ ~]) path)
      :^  ~  ~  %indexer-update
      !>(`update:ui`[%path-does-not-exist ~])
    =/  only-newest=?  ?=(%newest i.t.path)
    =/  args=^path  ?.(only-newest t.path t.t.path)
    |^
    ?+    args  :^  ~  ~  %indexer-update
                !>(`update:ui`[%path-does-not-exist ~])
        ?([%hash @ ~] [%hash @ @ ~])
      =/  query-payload=(unit query-payload:ui)
        read-query-payload-from-args
      ?~  query-payload
        :^  ~  ~  %indexer-update
        !>(`update:ui`[%path-does-not-exist ~])
      :^  ~  ~  %indexer-update
      !>(`update:ui`(get-hashes u.query-payload only-newest))
    ::
        ?([%id @ ~] [%id @ @ ~])
      =/  query-payload=(unit query-payload:ui)
        read-query-payload-from-args
      ?~  query-payload
        :^  ~  ~  %indexer-update
        !>(`update:ui`[%path-does-not-exist ~])
      :^  ~  ~  %indexer-update
      !>(`update:ui`(get-ids u.query-payload only-newest))
    ::
        $?  [%batch @ ~]       [%batch @ @ ~]
            [%egg @ ~]         [%egg @ @ ~]
            [%from @ ~]        [%from @ @ ~]
            [%grain @ ~]       [%grain @ @ ~]
            :: [%grain-eggs @ ~]  [%grain-eggs @ @ ~]
            [%holder @ ~]      [%holder @ @ ~]
            [%lord @ ~]        [%lord @ @ ~]
            [%to @ ~]          [%to @ @ ~]
            [%town @ ~]        [%town @ @ ~]
        ==
      =/  =query-type:ui  ;;(query-type:ui i.args)
      =/  query-payload=(unit query-payload:ui)
        read-query-payload-from-args
      ?~  query-payload
        :^  ~  ~  %indexer-update
        !>(`update:ui`[%path-does-not-exist ~])
      :^  ~  ~  %indexer-update
      !>  ^-  update:ui
      (serve-update query-type u.query-payload only-newest)
    ::
        [%batch-order @ ~]
      =/  town-id=@ux  (slav %ux i.t.args)
      :^  ~  ~  %indexer-update
      ?~  bs=(~(get by batches-by-town) town-id)  !>(~)
      !>(`update:ui`[%batch-order batch-order.u.bs])
    ::
        [%batch-order @ @ @ ~]
      =/  [town-id=@ux nth-most-recent=@ud how-many=@ud]
        :+  (slav %ux i.t.args)  (slav %ud i.t.t.args)
        (slav %ud i.t.t.t.args)
      :^  ~  ~  %indexer-update
      ?~  bs=(~(get by batches-by-town) town-id)  !>(~)
      !>  ^-  update:ui
      :-  %batch-order
      (swag [nth-most-recent how-many] batch-order.u.bs)
    ==
    ::
    ++  read-query-payload-from-args
      ^-  (unit query-payload:ui)
      ?:  ?=([@ @ ~] args)  `(slav %ux i.t.args)
      ?.  ?=([@ @ @ ~] args)  ~
      `[(slav %ux i.t.args) (slav %ux i.t.t.args)]
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
        `this(state (set-state-from-vase q.cage.sign))
      ==
    ==
    ::
    ++  has-root-already
      |=  [town-id=id:smart root=id:smart]
      ^-  ?
      =/  [=batches:ui *]
        %+  %~  gut  by  batches-by-town
        town-id  [*batches:ui *batches-by-town:ui]
      (~(has by batches) root)
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
        :+  rollup-capitol-path
          (snoc rollup-capitol-path %no-init)
        ~
      ::
          %new-peer-root
        =*  town-id  town-id.update
        =*  root     root.update
        ?:  (has-root-already town-id root)  `state
        =/  sequencer-update
          ^-  (unit [eggs=(list [@ux egg:smart]) =town:seq])
          %.  root
          %~  get  by
          %+  ~(gut by sequencer-update-queue)  town-id
          *(map @ux batch:ui)
        ?~  sequencer-update
          :-  ~
          %=  state
              town-update-queue
            %+  ~(put by town-update-queue)  town-id
            %+  %~  put  by
                %+  ~(gut by town-update-queue)  town-id
                *(map batch-id=@ux timestamp=@da)
            root  timestamp.update
          ==
        =^  cards  state
          %:  consume-batch:ic
              root
              eggs.u.sequencer-update
              town.u.sequencer-update
              timestamp.update
              %.y
          ==
        :-  cards
        %=  state
            sequencer-update-queue
          %+  ~(jab by sequencer-update-queue)  town-id
          |=  queue=(map @ux batch:ui)
          (~(del by queue) root)
        ==
      ==
    ::
    ++  consume-sequencer-update
      |=  update=indexer-update:seq
      ^-  (quip card _state)
      ?-    -.update
          %update
        =*  town-id  town-id.hall.update
        =*  root     root.update
        ?:  (has-root-already town-id root)  `state
        ?.  =(root (sham land.update))       `state
        =/  timestamp=(unit @da)
          %.  root
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
                *(map @ux batch:ui)
              root
            [transactions.update [land.update hall.update]]
          ==
        =^  cards  state
          %:  consume-batch:ic
              root
              transactions.update
              [land.update hall.update]
              u.timestamp
              %.y
          ==
        :-  cards
        %=  state
            town-update-queue
          %+  ~(put by town-update-queue)  town-id
          %.  root
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
  ^-  (unit [batch-id=id:smart timestamp=@da =batch:ui])
  ?~  bs=(~(get by batches-by-town) town-id)  ~
  ?~  b=(~(get by batches.u.bs) batch-root)   ~
  `[batch-root u.b]
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
  |=  [qp=query-payload:ui only-newest=?]
  ^-  update:ui
  =/  from=update:ui  (serve-update %from qp only-newest)
  =/  to=update:ui    (serve-update %to qp only-newest)
  (combine-egg-updates ~[from to])
::
++  get-hashes
  |=  [qp=query-payload:ui only-newest=?]
  ^-  update:ui
  =/  batch=update:ui   (serve-update %batch qp only-newest)
  =/  egg=update:ui     (serve-update %egg qp only-newest)
  =/  from=update:ui    (serve-update %from qp only-newest)
  =/  grain=update:ui   (serve-update %grain qp only-newest)
  =/  holder=update:ui  (serve-update %holder qp only-newest)
  =/  lord=update:ui    (serve-update %lord qp only-newest)
  =/  to=update:ui      (serve-update %to qp only-newest)
  =/  town=update:ui    (serve-update %town qp only-newest)
  :: =/  grain-eggs=update:ui
  ::   (serve-update %grain-eggs qp only-newest)
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
  ?~  update  ~
  ?.  ?=(%batch -.update)
    ?.  ?=(%newest-batch -.update)  ~
    [+.update]~
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
  ?~  update  ~
  ?.  ?=(%egg -.update)
    ?.  ?=(%newest-egg -.update)  ~
    [+.update]~
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
  ?~  update  ~
  ?.  ?=(%grain -.update)
    ?.  ?=(%newest-grain -.update)  ~
    :_  ~
    :-  grain-id.update
    [timestamp.update location.update grain.update]~
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
++  set-state-from-vase
  |=  state-vase=vase
  ^-  _state
  =/  new-base-state  !<(versioned-state:ui state-vase)
  ?-    -.new-base-state
      %0
    :-  new-base-state(old-sub-updates ~)
    %-  inflate-state
    ~(tap by batches-by-town.new-base-state)
  ==
::
++  inflate-state
  |=  batches-by-town-list=(list [@ux =batches:ui =batch-order:ui])
  ^-  indices-0:ui
  =|  temporary-state=_state
  |^
  ?~  batches-by-town-list  +.temporary-state
  =/  batches-list=(list [root=@ux timestamp=@da =batch:ui])
    %+  murn  (flop batch-order.i.batches-by-town-list)
    |=  =id:smart
    ?~  batch=(~(get by batches.i.batches-by-town-list) id)
      ~
    `[id u.batch]
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
++  serve-update
  |=  [=query-type:ui =query-payload:ui only-newest=?]
  ^-  update:ui
  =/  get-appropriate-batch
    ?.  only-newest  get-batch
    |=([town-id=id:smart @] (get-newest-batch town-id))
  |^
  ?+    query-type  ~
      %batch
    get-batch-update
  ::
      :: ?(%egg %from %grain %grain-eggs %holder %lord %to)
      ?(%egg %from %grain %holder %lord %to)
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
    ?:  only-newest
      ?~  batch-order.u.bs  ~
      =*  batch-id  i.batch-order.u.bs
      ?~  b=(~(get by batches.u.bs) batch-id)  ~
      :-  %newest-batch
      [batch-id timestamp.u.b town-id batch.u.b]
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
      ?~  b=(get-appropriate-batch town-id batch-id)  ~
      =*  timestamp  timestamp.u.b
      =*  batch      batch.u.b
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
      =*  timestamp  timestamp.u.b
      =*  batch      batch.u.b
      :-  %batch
      (~(put by +.out) batch-id [timestamp town-id batch])
    ?~(+.out ~ out)
  ::
  ++  get-from-index
    ^-  update:ui
    ?.  ?=(?(@ [@ @]) query-payload)  ~
    =/  locations=(list location:ui)  get-locations
    |^
    ?+    query-type  ~
        %grain
      get-grain
    ::
        %egg
      get-egg
    ::
        :: ?(%from %grain-eggs %holder %lord %to)
        ?(%from %holder %lord %to)
      get-second-order
    ==
    ::
    ++  get-grain
      =/  grain-id=id:smart
        ?:  ?=([@ @] query-payload)  +.query-payload
        query-payload
      ?:  only-newest  ::  TODO: DRY
        ?~  locations  ~
        =*  location  i.locations
        ?.  ?=(batch-location:ui location)  ~
        =*  town-id     town-id.location
        =*  batch-root  batch-root.location
        ?~  b=(get-appropriate-batch town-id batch-root)  ~
        ?.  |(!only-newest =(batch-root batch-id.u.b))
          ::  TODO: remove this check if we never see this log
          ~&  >>>  "%indexer: unexpected batch root (grain)"
          ~&  >>>  "br, bid: {<batch-root>} {<batch-id.u.b>}"
          ~
        =*  timestamp  timestamp.u.b
        =*  granary    p.land.batch.u.b
        ?~  grain=(get:big:mill granary grain-id)  ~
        [%newest-grain grain-id timestamp location u.grain]
      =|  grains=(jar grain-id=id:smart [@da batch-location:ui grain:smart])
      =.  locations  (flop locations)
      |-
      ?~  locations  ?~(grains ~ [%grain grains])
      =*  location  i.locations
      ?.  ?=(batch-location:ui location)
        $(locations t.locations)
      =*  town-id     town-id.location
      =*  batch-root  batch-root.location
      ?~  b=(get-appropriate-batch town-id batch-root)
        $(locations t.locations)
      ?.  |(!only-newest =(batch-root batch-id.u.b))
        ::  TODO: remove this check if we never see this log
        ~&  >>>  "%indexer: unexpected batch root (grain)"
        ~&  >>>  "br, bid: {<batch-root>} {<batch-id.u.b>}"
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
      ?:  only-newest  ::  TODO: DRY
        ?~  locations  ~
        =*  location  i.locations
        ?.  ?=(egg-location:ui location)  ~
        =*  town-id     town-id.location
        =*  batch-root  batch-root.location
        =*  egg-num     egg-num.location
        ?~  b=(get-appropriate-batch town-id batch-root)  ~
        ?.  |(!only-newest =(batch-root batch-id.u.b))
          ::  happens for second-order only-newest queries that
          ::   resolve to eggs because get-locations does not
          ::   guarantee they are in the newest batch
          ~
        =*  timestamp  timestamp.u.b
        =*  txs        transactions.batch.u.b
        ?.  (lth egg-num (lent txs))  ~
        =+  [hash=@ux =egg:smart]=(snag egg-num txs)
        [%newest-egg hash timestamp location egg]
      =|  eggs=(map id:smart [@da egg-location:ui egg:smart])
      |-
      ?~  locations  ?~(eggs ~ [%egg eggs])
      =*  location  i.locations
      ?.  ?=(egg-location:ui location)
        $(locations t.locations)
      =*  town-id     town-id.location
      =*  batch-root  batch-root.location
      =*  egg-num     egg-num.location
      ?~  b=(get-appropriate-batch town-id batch-root)
        $(locations t.locations)
      ?.  |(!only-newest =(batch-root batch-id.u.b))
        ::  happens for second-order only-newest queries that
        ::   resolve to eggs because get-locations does not
        ::   guarantee they are in the newest batch
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
      =/  first-order-type=?(%egg %grain)
        ?:  |(?=(%holder query-type) ?=(%lord query-type))
          %grain
        %egg
      |^
      =/  =update:ui  create-update
      ?~  update  ~
      ?+    -.update  ~|("indexer: get-second-order unexpected return type" !!)
          %egg    update(eggs (filter-eggs eggs.update))
          %grain  update(grains (filter-grains grains.update))
          %newest-egg    ?.((is-egg-hit +.+.update) ~ update)
          %newest-grain  ?.((is-grain-hit +.+.update) ~ update)
      ==
      ::
      ++  is-egg-hit
        |=  value=egg-update-value:ui
        ^-  ?
        =/  query-hash=id:smart
          ?:  ?=(@ query-payload)  query-payload
          ?>  ?=([@ @] query-payload)
          +.query-payload
        ?|  ?&  ?=(%from query-type)
                =(query-hash id.from.shell.egg.value)
            ==
            ?&  ?=(%to query-type)
                =(query-hash contract.shell.egg.value)
            ==
        ==
      ::
      ++  is-grain-hit
        |=  value=grain-update-value:ui
        ^-  ?
        =/  query-hash=id:smart
          ?:  ?=(@ query-payload)  query-payload
          ?>  ?=([@ @] query-payload)
          +.query-payload
        ::  hack to get around grain's `each`
        =/  [holder=id:smart lord=id:smart]
          ?:  -.grain.value
            [holder.p.grain.value lord.p.grain.value]
          [holder.p.grain.value lord.p.grain.value]
        ?|  &(?=(%holder query-type) =(query-hash holder))
            &(?=(%lord query-type) =(query-hash lord))
        ==
      ::
      ++  filter-eggs
        |=  eggs=(map id:smart egg-update-value:ui)
        ^-  (map id:smart egg-update-value:ui)
        %-  ~(gas by *(map id:smart egg-update-value:ui))
        %+  roll  ~(tap by eggs)
        |=  $:  [egg-id=id:smart =egg-update-value:ui]
                out=(list [id:smart egg-update-value:ui])
            ==
        ?.  (is-egg-hit egg-update-value)  out
        [[egg-id egg-update-value] out]
      ::
      ++  filter-grains  ::  TODO: generalize w/ `+diff-update-grains`
        |=  grains=(jar id:smart grain-update-value:ui)
        ^-  (jar id:smart grain-update-value:ui)
        %-  %~  gas  by
            *(map id:smart (list grain-update-value:ui))
        %+  roll  ~(tap by grains)
        |=  $:  [grain-id=id:smart values=(list grain-update-value:ui)]
                out=(list [id:smart (list grain-update-value:ui)])
            ==
        =/  filtered-values=(list grain-update-value:ui)
          %+  roll  values
          |=  $:  =grain-update-value:ui
                  inner-out=(list grain-update-value:ui)
              ==
          ?.  (is-grain-hit grain-update-value)  inner-out
          [grain-update-value inner-out]
        ?~  filtered-values  out
        [[grain-id (flop filtered-values)] out]
      ::
      ++  create-update
        ^-  update:ui
        %+  roll  locations
        |=  $:  second-order-id=location:ui
                out=update:ui
            ==
        =/  next-update=update:ui
          %=  get-from-index
              query-payload  second-order-id
              query-type     first-order-type
          ==
        ?~  next-update  out
        ?~  out          next-update
        ?+    -.out  ~|("indexer: get-second-order unexpected update type {<-.out>}" !!)
            %egg
          ?.  ?=(?(%egg %newest-egg) -.next-update)  out
          %=  out
              eggs
            ?:  ?=(%egg -.next-update)
              (~(uni by eggs.out) eggs.next-update)
            ?>  ?=(%newest-egg -.next-update)
            ?.  (is-egg-hit +.+.next-update)  eggs.out
            (~(put by eggs.out) +.next-update)
          ==
        ::
            %grain
          ?.  ?=(?(%grain %newest-grain) -.next-update)  out
          %=  out
              grains
            ?:  ?=(%grain -.next-update)
              (~(uni by grains.out) grains.next-update)  ::  TODO: can this clobber?
            ?>  ?=(%newest-grain -.next-update)
            ?.  (is-grain-hit +.+.next-update)  grains.out
            (~(add ja grains.out) +.next-update)
          ==
        ::
            %newest-egg
          ?+    -.next-update  out
              %egg
            %=  next-update
                eggs
              ?.  (is-egg-hit +.+.out)  eggs.next-update
              (~(put by eggs.next-update) +.out)
            ==
          ::
              %newest-egg
            :-  %egg
            %.  ~[+.out +.next-update]
            %~  gas  by
            *(map id:smart [@da egg-location:ui egg:smart])
          ==
        ::
            %newest-grain
          ?+    -.next-update  out
              %grain
            %=  next-update
                grains
              ?.  (is-grain-hit +.+.out)  grains.next-update
              (~(add ja grains.next-update) +.out)  ::  TODO: ordering?
            ==
          ::
              %newest-grain
            :-  %grain
            %.  +.next-update
            %~  add  ja
            %.  +.out
            %~  add  ja
            ^*  %+  jar  id:smart
            [@da batch-location:ui grain:smart]
          ==
        ==
      --
    --
  ::
  ++  get-locations
    |^  ^-  (list location:ui)
    ?+  query-type  ~|("indexer: get-locations unexpected query-type {<query-type>}" !!)
      %egg         (get-by-get-ja egg-index only-newest)
      %from        (get-by-get-ja from-index %.n)
      %grain       (get-by-get-ja grain-index only-newest)
      :: %grain-eggs  (get-by-get-ja grain-eggs-index %.n)
      %holder      (get-by-get-ja holder-index %.n)
      %lord        (get-by-get-ja lord-index %.n)
      %to          (get-by-get-ja to-index %.n)
    ==
    ::  always set `only-newest` false for
    ::   second-order indices or will
    ::   throw away unique eggs/grains.
    ::   Concretely, egg/grain indices hold historical
    ::   state for a given hash, while second-order
    ::   indices hold different eggs/grains that hash
    ::   has appeared in (e.g. different grains with a
    ::   given holder).
    ::
    ++  get-by-get-ja
      |=  [index=(map @ux (jar @ux location:ui)) only-newest=?]
      ^-  (list location:ui)
      ?:  ?=([@ @] query-payload)
        =*  town-id    -.query-payload
        =*  item-hash  +.query-payload
        ?~  town-index=(~(get by index) town-id)      ~
        ?~  items=(~(get ja u.town-index) item-hash)  ~
        ?:(only-newest ~[i.items] items)
      ?.  ?=(@ query-payload)  ~
      =*  item-hash  query-payload
      %+  roll  ~(val by index)
      |=  [town-index=(jar @ux location:ui) out=(list location:ui)]
      ?~  items=(~(get ja town-index) item-hash)  out
      ?:  only-newest  [i.items out]
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
  =*  town-id  town-id.hall.town
  |^  ^-  (quip card _state)
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
    ::  only update newest-batch-by-town with newer batches
    ?:  %+  gth
          ?~  current=(~(get by newest-batch-by-town) town-id)
            *@da
          timestamp.u.current
        timestamp
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
  ?.  should-update-subs  [~ state]
  =/  [cards=(list card) new-osus=(list [path update:ui])]
    make-all-sub-cards
  :-  cards
  %=  state
      old-sub-updates
    ?~  new-osus  old-sub-updates
    (~(gas by *_old-sub-updates) new-osus)
  ==
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
    %+  murn  ~(val by sup.bowl)
    |=  [ship sub-path=path]
    ^-  (unit [@tas path])
    ?~  sub-path  ~
    ?.  ?=(?(%hash %id %grain %holder %lord %town) i.sub-path)
      ~
    `[`@tas`i.sub-path t.sub-path]
  ::
  ++  make-all-sub-cards
    ^-  [(list card) (list [path update:ui])]
    =/  sub-paths=(jug @tas path)
      make-sub-paths
    |^
    =/  out=(pair (list (list card)) (list (list [path update:ui])))
      %+  roll
        ^-  (list ?(%id query-type:ui))
        ~[%grain %hash %holder %id %lord %town]
      |=  $:  query-type=?(%id query-type:ui)
              out=(pair (list (list card)) (list (list [path update:ui])))
          ==
      =/  [p=(list card) q=(list [path update:ui])]
        (make-sub-cards query-type)
      [[p p.out] [q q.out]]
    :_  (zing q.out)
    :-  %+  fact:io
          :-  %indexer-update
          !>(`update:ui`[%batch-order ~[root]])
        %+  expand-paths  %no-init
        ~[/batch-order/(scot %ux town-id)]
    (zing p.out)
    ::
    ++  make-sub-cards
      |=  query-type=?(%id query-type:ui)
      ^-  [(list card) (list [path update:ui])]
      %+  roll  ~(tap in (~(get ju sub-paths) query-type))
      |=  $:  sub-path=path
              out=(pair (list card) (list [path update:ui]))
          ==
      =/  payload=?(@ux [@ux @ux])
        ?:  ?=(?([@ ~] [@ %no-init ~]) sub-path)
          (slav %ux i.sub-path)
        ?>  ?=(?([@ @ ~] [@ @ %no-init ~]) sub-path)
        [(slav %ux i.sub-path) (slav %ux i.t.sub-path)]
      =/  =update:ui
        ?+    query-type  !!
            %hash  (get-hashes payload %.y)
            %id    (get-ids payload %.y)
            ?(%grain %holder %lord %town)
          (serve-update query-type payload %.y)
        ==
      ?~  update  out
      =/  total-path=path  [query-type sub-path]
      =/  update-diff=update:ui
        (compute-update-diff update total-path)
      ?~  update-diff  out
      :_  [[total-path update] q.out]
      :_  p.out
      %+  fact:io
        [%indexer-update !>(`update:ui`update-diff)]
      (expand-paths %no-init ~[total-path])
    ::
    ++  expand-paths
      |=  [appendend=@tas paths=(list path)]
      ^-  (list path)
      %+  roll  paths
      |=  [p=path out=(list path)]
      ?:  =(appendend (rear p))
        ?~  snipped=(snip p)  [p out]
        [snipped [p out]]
      [p [(snoc p appendend) out]]
    ::
    ++  compute-update-diff
      |=  [new=update:ui sub-path=path]
      |^  ^-  update:ui
      =/  old=update:ui
        (~(gut by old-sub-updates) sub-path ~)
      ?~  old             new
      ?.  =(-.old -.new)  ~  ::  require same type updates
      ?+    -.old         ~
          %batch
        ?>  ?=(%batch -.new)
        ?~  diff=(diff-update-maps batches.old batches.new)
          ~
        [%batch diff]
          %batch-order
        ?>  ?=(%batch-order -.new)
        ?~  batch-order.old  ?~(batch-order.new ~ new)
        ?~  batch-order.new  ~
        ?:(=(i.batch-order.old i.batch-order.new) ~ new)
      ::
          %egg
        ?>  ?=(%egg -.new)
        ?~  diff=(diff-update-maps eggs.old eggs.new)  ~
        [%egg diff]
      ::
          %grain
        ?>  ?=(%grain -.new)
        ?~  diff=(diff-update-grains grains.old grains.new)
          ~
        [%grain diff]
      ::
          %hash
        ?>  ?=(%hash -.new)
        =/  batch-diff=(map id:smart batch-update-value:ui)
          (diff-update-maps batches.old batches.new)
        =/  egg-diff=(map id:smart egg-update-value:ui)
          (diff-update-maps eggs.old eggs.new)
        =/  grain-diff=(jar id:smart grain-update-value:ui)
          (diff-update-grains grains.old grains.new)
        ?:  ?&  ?=(~ batch-diff)
                ?=(~ egg-diff)
                ?=(~ grain-diff)
            ==
          ~
        :^    %hash
            batches=batch-diff
          eggs=egg-diff
        grains=grain-diff
      ::
          %newest-batch-order
        ?>  ?=(%newest-batch-order -.new)
        ?:(=(batch-id.old batch-id.new) ~ new)
      ::
          %newest-batch
        ?>  ?=(%newest-batch -.new)
        ?:  =(batch-id.old batch-id.new)              ~
        ?~  diff=(diff-update-value +.+.old +.+.new)  ~
        [%newest-batch batch-id.new u.diff]
      ::
          %newest-egg
        ?>  ?=(%newest-egg -.new)
        ?:  =(egg-id.old egg-id.new)                  ~
        ?~  diff=(diff-update-value +.+.old +.+.new)  ~
        [%newest-egg egg-id.new u.diff]
      ::
          %newest-grain
        ?>  ?=(%newest-grain -.new)
        ?~  diff=(diff-update-value +.+.old +.+.new)  ~
        [%newest-grain grain-id.new u.diff]
      ==
      ::
      ++  diff-update-value
        |*  [old-val=[@da * *] new-val=[@da * *]]
        ^-  (unit _new-val)
        ?:(=(+.+.old-val +.+.new-val) ~ `new-val)
      ::
      ++  diff-update-maps
        |*  $:  old-vals=(map id:smart [@ * *])
                new-vals=(map id:smart [@ * *])
            ==
        ^-  _new-vals
        ?~  new-vals-list=~(val by new-vals)  ~
        =/  val-type  _i.new-vals-list
        %-  ~(gas by *_new-vals)
        %+  roll  ~(tap by new-vals)
        |=  $:  [=id:smart new-val=val-type]
                out=(list [id:smart val-type])
            ==
        ?~  old-val=(~(get by old-vals) id)
          [[id new-val] out]
        ?~  diff=(diff-update-value u.old-val new-val)  out
        [[id new-val] out]
      ::
      ++  diff-update-grains  ::  TODO: generalize w/ `+filter-grains`
        |=  $:  old-grains=(jar id:smart grain-update-value:ui)
                new-grains=(jar id:smart grain-update-value:ui)
            ==
        ^-  (jar id:smart grain-update-value:ui)
        %-  %~  gas  by
            *(map id:smart (list grain-update-value:ui))
        %+  roll  ~(tap by new-grains)
        |=  $:  [=id:smart new-vals=(list grain-update-value:ui)]
                out=(list [id:smart (list grain-update-value:ui)])
            ==
        ?~  old-vals=(~(get ja old-grains) id)
          ?~(new-vals out [[id new-vals] out])
        ?:  =(old-vals new-vals)  out
        =/  old-grains=(set grain:smart)
          %-  ~(gas in *(set grain:smart))
          %+  turn  old-vals
          |=(old-val=grain-update-value:ui grain.old-val)
        =/  filtered-values=(list grain-update-value:ui)
          %+  roll  new-vals
          |=  $:  new-val=grain-update-value:ui
                  inner-out=(list grain-update-value:ui)
              ==
          ?:  (~(has in old-grains) grain.new-val)  inner-out
          [new-val inner-out]
        ?~  filtered-values  out
        [[id (flop filtered-values)] out]
      --
    --
  ::
  ++  parse-batch
    |=  $:  root=@ux
            town-id=@ux
            eggs=(list [@ux egg:smart])
            =land:seq
        ==
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
    ?~  txs  [parsed-egg parsed-from parsed-to]
    =*  egg-hash     -.i.txs
    =*  egg          +.i.txs
    =*  to           contract.shell.egg
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
