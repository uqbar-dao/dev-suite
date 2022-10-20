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
::    queried item (e.g., for a `/item` query, the `item-id`).
::    For two arguments, the first is interpreted as the
::    `shard-id` in which to query for the second, the item hash.
::    In other words, two arguments restricts the query to
::    a shard, while one argument queries all indexed shards.
::
::    Scry paths may be prepended with a `/newest`, which
::    will return results only in the most recent batch.
::    For example, the history of all items held by
::    `0xdead.beef` would be queried using the path
::    `/x/holder/0xdead.beef`
::    while only the most recent state of all items held
::    by `0xdead.beef` would be queried using
::    `/x/newest/holder/0xdead.beef`.
::
::    Scry paths may be prepended with a `/json`, which
::    will cause the scry to return JSON rather than an
::    `update:ui` and will attempt to mold the `data` in
::    `item`s and the `yolk` in `txn`s.
::    In order to do so it requires the `source` contracts
::    have properly filled out `interface` and `types`
::    fields, see `lib/jolds.hoon` docstring for the spec
::    and `con/lib/*interface-types.hoon`
::    for examples.
::
::    When used in combination, the `/json` prefix must
::    come before the `/newest` prefix, so a valid example
::    is `/x/json/newest/holder/0xdead.beef`.
::
::    /x/batch/[batch-id=@ux]
::    /x/batch/[shard-id=@ux]/[batch-id=@ux]:
::      An entire batch.
::    /x/batch-order/[shard-id=@ux]
::    /x/batch-order/[shard-id=@ux]/[nth-most-recent=@ud]/[how-many=@ud]:
::      The order of batches for a shard, or a subset thereof.
::    /x/txn/[txn-id=@ux]:
::    /x/txn/[shard-id=@ux]/[txn-id=@ux]:
::      Info about txn (transaction) with the given hash.
::    /x/from/[txn-id=@ux]:
::    /x/from/[shard-id=@ux]/[from-id=@ux]:
::      History of sender with the given hash.
::    /x/item/[item-id=@ux]:
::    /x/item/[shard-id=@ux]/[item-id=@ux]:
::      Historical states of item with given hash.
::    :: /x/item-txns/[item-id=@ux]:  ::  TODO: reenable
::    :: /x/item-txns/[shard-id=@ux]/[item-id=@ux]:
::    ::   txns involving item with given hash.
::    /x/hash/[hash=@ux]:
::    /x/hash/[shard-id=@ux]/[hash=@ux]:
::      Info about hash (queries all indexes for hash).
::    /x/holder/[holder-id=@ux]:
::    /x/holder/[shard-id=@ux]/[holder-id=@ux]:
::      items held by id with given hash.
::    /x/id/[id=@ux]:
::    /x/id/[shard-id=@ux]/[id=@ux]:
::      History of id (queries `from`s and `to`s).
::    /x/source/[source-id=@ux]:
::    /x/source/[shard-id=@ux]/[source-id=@ux]:
::      items ruled by source with given hash.
::    /x/to/[to-id=@ux]:
::    /x/to/[shard-id=@ux]/[to-id=@ux]:
::      History of receiver with the given hash.
::    /x/shard/[shard-id=@ux]:
::    /x/shard/[shard-id=@ux]/[shard-id=@ux]:
::      History of shard: all batches.
::
::
::    ## Subscription paths
::
::    Subscriptions paths must be appended with a unique
::    subscription identifier.
::    The %uqbar app does this automatically.
::    One recommended way to do this is to append
::    ```
::    (scot %ux (cut 5 [0 1] eny.bowl))
::    ```
::    to the path.`
::    The unique identifier is required to return the
::    properly diff'd update to each subscriber.
::
::    Subscription paths do not send anything on-watch.
::    To receive the history on-watch, append `/history`
::    to the end of the subscription path.
::    E.g., `/item/0xdead.beef` will not receive an
::    immediate response, while `/item/0xdead.beef/history`
::    will immediately receive the history of that item.
::
::    Subscription paths, similar to scry paths,
::    may be prepended with a `/json`, which will cause
::    the subscription to return JSON rather than an
::    `update:ui` and will attempt to mold the `data` in
::    `item`s and the `yolk` in `txn`s.
::    In order to do so it requires the `source` contracts
::    have properly filled out `interface` and `types`
::    fields, see `lib/jolds.hoon` docstring for the spec
::    and `con/lib/*interface-types.hoon`
::    for examples.
::
::    /batch-order/[shard-id=@ux]:
::      A stream of batch ids.
::    /item/[item-id=@ux]
::    /item/[shard-id=@ux]/[item-id=@ux]:
::      A stream of changes to given item.
::    /hash/[@ux]:
::      A stream of new activity of given id.
::    /holder/[holder-id=@ux]
::    /holder/[shard-id=@ux]/[holder-id=@ux]:
::      A stream of new activity of given holder.
::      If a held item changes holders, the final update
::      sent for that item will have the updated holder.
::      Thus, applications will need to check the holder
::      field and update their state as appropriate when
::      it has changed; subsequent updates will not include
::      that item.
::      Reply on-watch is entire history of held items.
::    /id/[id=@ux]
::    /id/[shard-id=@ux]/[id=@ux]:
::      A stream of new transactions of given id:
::      specifically transactions where id appears
::      in the `from` or `contract` fields.
::    /source/[source-id=@ux]
::    /source/[shard-id=@ux]/[source-id=@ux]:
::      A stream of new activity of given source.
::    /shard/[shard-id=@ux]
::    /shard/[shard-id=@ux]/[shard-id=@ux]:
::      A stream of each new batch for shard.
::
::
::    ##  Pokes
::
::    %indexer-bootstrap:
::      Copy state from target indexer.
::      WARNING: Overwrites current state, so should
::      only be used when bootstrapping a new indexer.
::
::    %indexer-catchup:
::      Copy state from target indexer
::      from given batch hash onward.
::
::    %set-sequencer:
::      Subscribe to sequencer for new batches.
::
::    %set-rollup:
::      Subscribe to rollup for new batch roots.
::
::
/-  engine=zig-engine,
    uqbar=zig-uqbar,
    seq=zig-sequencer,
    ui=zig-indexer
/+  agentio,
    dbug,
    default-agent,
    verb,
    indexer-lib=zig-indexer,
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
      ui-lib        ~(. indexer-lib bowl)
  ::
  ++  on-init
    ::  Temporary hardcode for ~bacdun testnet
    ::   to allow easier setup.
    ::   TODO: Remove hardcode and add a GUI button/
    ::         input menu to setup.
    =/  testnet-host=@p            ~bacdun
    =/  indexer-bootstrap-host=@p  ~dister-dozzod-bacdun
    =/  rollup-dock=dock           [testnet-host %rollup]
    =/  sequencer-dock=dock        [testnet-host %sequencer]
    =/  indexer-bootstrap-dock=dock
      [indexer-bootstrap-host %indexer]
    :_  this(catchup-indexer indexer-bootstrap-dock)
    :-  %+  ~(poke-our pass:io /set-source-poke)  %uqbar
        :-  %uqbar-action
        !>  ^-  action:uqbar
        :-  %set-sources
        [0x0 (~(gas in *(set dock)) ~[[our dap]:bowl])]~
    ?:  ?|  =(testnet-host our.bowl)
            =(indexer-bootstrap-host our.bowl)
        ==
      ~
    :~  %^    watch-target:ic
            sequencer-wire
          sequencer-dock
        sequencer-path
    ::
        %^    watch-target:ic
            rollup-capitol-wire
          rollup-dock
        rollup-capitol-path
    ::
        %^    watch-target:ic
            rollup-root-wire
          rollup-dock
        rollup-root-path
    ::
        %^    watch-target:ic
            indexer-bootstrap-wire
          indexer-bootstrap-dock
        indexer-bootstrap-path
    ==
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
        %set-catchup-indexer
      `this(catchup-indexer !<(dock vase))
    ::
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
        %indexer-bootstrap
      =+  !<(indexer-bootstrap-dock=dock vase)
      :_  this(catchup-indexer indexer-bootstrap-dock)
      %^    set-watch-target:ic
          indexer-bootstrap-wire
        indexer-bootstrap-dock
      indexer-bootstrap-path
    ::
        %indexer-catchup
      =+  !<([=dock shard=id:smart root=id:smart] vase)
      :_  this(catchup-indexer dock)
      %^    set-watch-target:ic
          (indexer-catchup-wire shard root)
        dock
      (indexer-catchup-path shard root)
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
        [%indexer-bootstrap ~]
      :_  this
      %-  fact-init-kick:io
      :-  %indexer-bootstrap
      !>(`versioned-state:ui`-.state)
    ::
        [%indexer-catchup @ @ ~]
      =/  shard-id=id:smart  (slav %ux i.t.path)
      =/  root=id:smart     (slav %ux i.t.t.path)
      =/  [=batches:ui =batch-order:ui]
        (~(gut by batches-by-shard) shard-id [~ ~])
      =.  batch-order  (flop batch-order)
      :_  this
      %-  fact-init-kick:io
      :-  %indexer-catchup
      !>  ^-  [batches:ui batch-order:ui]
      |-
      ?~  batch-order  [*batches:ui *batch-order:ui]
      ?:  =(root i.batch-order)  [batches (flop batch-order)]
      %=  $
          batches      (~(del by batches) i.batch-order)
          batch-order  t.batch-order
      ==
    ::
        [%capitol-updates @ ~]
      :_  this
      :_  ~
      %-  fact:io
      :_  ~
      :-  %sequencer-capitol-update
      !>(`capitol-update:seq`[%new-capitol capitol])
    ::
        $?  [%batch-order @ @ %history ~]
            [%json @ @ @ %history ~]  [%json @ @ @ @ %history ~]
            [%hash @ @ %history ~]    [%hash @ @ @ %history ~]
            [%id @ @ %history ~]      [%id @ @ @ %history ~]
            [%item @ @ %history ~]   [%item @ @ @ %history ~]
            [%holder @ @ %history ~]  [%holder @ @ @ %history ~]
            [%source @ @ %history ~]    [%source @ @ @ %history ~]
            [%shard @ @ %history ~]    [%shard @ @ @ %history ~]
        ==
      :_  this
      :_  ~
      %-  fact:io
      :_  ~
      ?:  ?=(%json i.path)
        :-  %json
        !>  ^-  json
        .^  json
            %gx
            %+  scry:pass:io  %indexer
            (snoc (snip (snip `(list @ta)`path)) `@ta`%json)
        ==
      :-  %indexer-update
      !>  ^-  update:ui
      .^  update:ui
          %gx
          %+  scry:pass:io  %indexer
          (snoc (snip (snip `(list @ta)`path)) `@ta`%noun)
      ==
    ::
        $?  [%batch-order @ @ ~]
            [%json @ @ @ ~]  [%json @ @ @ @ ~]
            [%hash @ @ ~]    [%hash @ @ @ ~]
            [%id @ @ ~]      [%id @ @ @ ~]
            [%item @ @ ~]   [%item @ @ @ ~]
            [%holder @ @ ~]  [%holder @ @ @ ~]
            [%source @ @ ~]    [%source @ @ @ ~]
            [%shard @ @ ~]    [%shard @ @ @ ~]
        ==
      `this
    ==
  ::
  ++  on-leave
    |=  =path
    ^-  (quip card _this)
    ?+    path  (on-leave:def path)
        $?  [%batch-order *]
            [%item *]
            [%hash *]
            :: [%item-txns *]
            [%holder *]
            [%id *]
            [%json *]
            [%source *]
            [%shard *]
            [%capitol-updates *]
            [%indexer-bootstrap ~]
            [%indexer-catchup @ @ ~]
        ==
      `this
    ==
  ::
  ++  on-peek
    |=  =path
    ^-  (unit (unit cage))
    ?:  =(/x/dbug/state path)
      ``[%noun !>(`_state`state)]
    ?.  ?=  $?  [@ @ @ ~]  [@ @ @ @ @ @ ~]
                [@ @ @ @ ~]  [@ @ @ @ @ ~]
            ==
        path
      :^  ~  ~  %indexer-update
      !>(`update:ui`[%path-does-not-exist ~])
    ::
    =/  is-json=?      ?=(%json i.t.path)
    =/  only-newest=?
      ?.  is-json  ?=(%newest i.t.path)
      ?=(%newest i.t.t.path)
    =/  args=^path
      =/  num=@ud  (add is-json only-newest)
      ?:  =(2 num)  t.path
      ?:  =(1 num)  t.t.path
      ?:  =(0 num)  t.t.t.path
      !!
    |^
    ?+    args  :^  ~  ~  %indexer-update
                !>(`update:ui`[%path-does-not-exist ~])
        ?([%hash @ ~] [%hash @ @ ~])
      =/  query-payload=(unit query-payload:ui)
        read-query-payload-from-args
      %-  make-peek-update
      ?~  query-payload  [%path-does-not-exist ~]
      (get-hashes u.query-payload only-newest %.y)
    ::
        ?([%id @ ~] [%id @ @ ~])
      =/  query-payload=(unit query-payload:ui)
        read-query-payload-from-args
      %-  make-peek-update
      ?~  query-payload  [%path-does-not-exist ~]
      (get-ids u.query-payload only-newest)
    ::
        $?  [%batch @ ~]       [%batch @ @ ~]
            [%txn @ ~]         [%txn @ @ ~]
            [%from @ ~]        [%from @ @ ~]
            [%item @ ~]       [%item @ @ ~]
            :: [%item-txns @ ~]  [%item-txns @ @ ~]
            [%holder @ ~]      [%holder @ @ ~]
            [%source @ ~]        [%source @ @ ~]
            [%to @ ~]          [%to @ @ ~]
            [%shard @ ~]        [%shard @ @ ~]
        ==
      =/  =query-type:ui  ;;(query-type:ui i.args)
      =/  query-payload=(unit query-payload:ui)
        read-query-payload-from-args
      %-  make-peek-update
      ?~  query-payload  [%path-does-not-exist ~]
      %:  serve-update
          query-type
          u.query-payload
          only-newest
          %.y
      ==
    ::
        [%batch-order @ ~]
      =/  shard-id=@ux  (slav %ux i.t.args)
      %-  make-peek-update
      ?~  bs=(~(get by batches-by-shard) shard-id)  ~
      [%batch-order batch-order.u.bs]
    ::
        [%batch-order @ @ @ ~]
      =/  [shard-id=@ux nth-most-recent=@ud how-many=@ud]
        :+  (slav %ux i.t.args)  (slav %ud i.t.t.args)
        (slav %ud i.t.t.t.args)
      %-  make-peek-update
      ?~  bs=(~(get by batches-by-shard) shard-id)  ~
      :-  %batch-order
      (swag [nth-most-recent how-many] batch-order.u.bs)
    ==
    ::
    ++  make-peek-update
      |=  =update:ui
      ?.  is-json
        [~ ~ %indexer-update !>(`update:ui`update)]
      [~ ~ %json !>(`json`(update:enjs:ui-lib update))]
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
          %fact
        =^  cards  state
          %-  consume-rollup-update
          !<(rollup-update:seq q.cage.sign)
        [cards this]
      ::
          %kick
        :_  this
        %^    set-watch-target:ic
            wire
          [src.bowl %rollup]  ::  TODO: remove hardcode
        ?:  ?=(%rollup-root-update -.wire)
          rollup-root-path
        rollup-capitol-path
      ==
    ::
        [%sequencer-update ~]
      ?+    -.sign  (on-agent:def wire sign)
          %fact
        =^  cards  state
          %-  consume-sequencer-update
          !<(indexer-update:seq q.cage.sign)
        [cards this]
      ::
          %kick
        :_  this
        %^    set-watch-target:ic
            sequencer-wire
          [src.bowl %sequencer]  ::  TODO: remove hardcode
        sequencer-path
      ==
    ::
        [%indexer-bootstrap-update ~]
      ?+    -.sign  (on-agent:def wire sign)
          %fact
        ::  Reset state to initial conditions: this happens
        ::   automagically `+on-load`, but not here.
        ::   If don't do this, can get bad state starting
        ::   up a new indexer.
        =:  batches-by-shard         ~
            capitol                 ~
            sequencer-update-queue  ~
            shard-update-queue       ~
            old-sub-paths           ~
            old-sub-updates         ~
            txn-index               ~
            from-index              ~
            item-index             ~
            :: item-txns-index        ~
            holder-index            ~
            source-index              ~
            to-index                ~
            newest-batch-by-shard    ~
        ==
        `this(state (set-state-from-vase q.cage.sign))
      ==
    ::
        [%indexer-catchup-update @ @ ~]
      =/  shard-id=id:smart  (slav %ux i.t.wire)
      =/  root=id:smart     (slav %ux i.t.t.wire)
      ?+    -.sign  (on-agent:def wire sign)
          %fact
        :-  ~
        =+  !<([=batches:ui =batch-order:ui] q.cage.sign)
        =/  old=(unit (pair batches:ui batch-order:ui))
          (~(get by batches-by-shard) shard-id)
        ?~  old
          %=  this
              batches-by-shard
            %+  ~(put by batches-by-shard)  shard-id
            [batches batch-order]
          ==
        =/  root-index=@ud
          ?~(i=(find ~[root] q.u.old) 0 +(u.i))
        =.  batches-by-shard
          %+  ~(put by batches-by-shard)  shard-id
          :-  (~(uni by p.u.old) batches)
          (weld batch-order (slag root-index q.u.old))
        %=  this
            sequencer-update-queue  ~
            shard-update-queue       ~
            +.state
          %-  inflate-state
          ~(tap by batches-by-shard)
        ==
      ==
    ==
    ::
    ++  has-root-already
      |=  [shard-id=id:smart root=id:smart]
      ^-  ?
      =/  [=batches:ui *]
        %+  %~  gut  by  batches-by-shard
        shard-id  [*batches:ui *batches-by-shard:ui]
      (~(has by batches) root)
    ::
    ++  consume-sequencer-update
      |=  update=indexer-update:seq
      ^-  (quip card _state)
      ?-    -.update
          %update
        =*  shard-id  shard-id.hall.update
        =*  root     root.update
        ?:  (has-root-already shard-id root)  `state
        ?.  =(root (sham chain.update))       `state
        =/  timestamp=(unit @da)
          %.  root
          %~  get  by
          %+  ~(gut by shard-update-queue)  shard-id
          *(map @ux @da)
        ?~  timestamp
          :-  ~
          %=  state
              sequencer-update-queue
            %+  ~(put by sequencer-update-queue)  shard-id
            %+  %~  put  by
                %+  ~(gut by sequencer-update-queue)  shard-id
                *(map @ux batch:ui)
              root
            [transactions.update [chain.update hall.update]]
          ==
        =^  cards  state
          %:  consume-batch:ic
              root
              transactions.update
              [chain.update hall.update]
              u.timestamp
              %.y
          ==
        :-  cards
        %=  state
            shard-update-queue
          %+  ~(put by shard-update-queue)  shard-id
          %.  root
          ~(del by (~(got by shard-update-queue) shard-id))
        ==
      ==
    ::
    ++  consume-rollup-update
      |=  update=rollup-update:seq
      |^  ^-  (quip card _state)
      ?-    -.update
          %new-sequencer
        `state
      ::
          %new-capitol
        :_  state(capitol capitol.update)
        :-  %+  fact:io
              :-  %sequencer-capitol-update
              !>(`capitol-update:seq`update)
            :+  rollup-capitol-path
              (snoc rollup-capitol-path %no-init)
            ~
        ?:  (only-missing-newest capitol.update)  ~
        %+  murn  ~(val by capitol.update)
        |=  [shard-id=id:smart @ [@ @] [@ *] @ roots=(list @ux)]
        =/  [* =batch-order:ui]
          %+  ~(gut by batches-by-shard)  shard-id
          [~ batch-order=~]
        =/  needed-list=(list id:smart)
          (find-needed-batches roots batch-order)
        ?~  needed-list  ~
        =*  root  i.needed-list
        :-  ~
        %^    watch-target:ic
            (indexer-catchup-wire shard-id root)
          catchup-indexer
        (indexer-catchup-path shard-id root)
      ::
          %new-peer-root
        =*  shard-id  shard.update
        =*  root     root.update
        ?:  (has-root-already shard-id root)  `state
        =/  sequencer-update
          ^-  (unit [txns=(list [@ux transaction:smart]) =shard:seq])
          %.  root
          %~  get  by
          %+  ~(gut by sequencer-update-queue)  shard-id
          *(map @ux batch:ui)
        ?~  sequencer-update
          :-  ~
          %=  state
              shard-update-queue
            %+  ~(put by shard-update-queue)  shard-id
            %+  %~  put  by
                %+  ~(gut by shard-update-queue)  shard-id
                *(map batch-id=@ux timestamp=@da)
            root  timestamp.update
          ==
        =^  cards  state
          %:  consume-batch:ic
              root
              txns.u.sequencer-update
              shard.u.sequencer-update
              timestamp.update
              %.y
          ==
        :-  cards
        %=  state
            sequencer-update-queue
          %+  ~(jab by sequencer-update-queue)  shard-id
          |=  queue=(map @ux batch:ui)
          (~(del by queue) root)
        ==
      ==
      ::
      ++  find-needed-batches  ::  TODO: only return id where diff begins?
        |=  [capitol=(list id:smart) batch-order=(list id:smart)]
        ^-  (list id:smart)
        =.  batch-order  (flop batch-order)
        ?:  =(capitol batch-order)  ~
        =|  needed=(list id:smart)
        |-
        ?~  capitol  (flop needed)
        ?~  batch-order
          $(capitol t.capitol, needed [i.capitol needed])
        ?:  =(i.capitol i.batch-order)
          $(capitol t.capitol, batch-order t.batch-order)
        %=  $
            capitol      t.capitol
            batch-order  t.batch-order
            needed       [i.capitol needed]
        ==
      ::
      ++  only-missing-newest
        |=  new-capitol=capitol:seq
        ^-  ?
        =/  shard-ids=(list id:smart)
          ~(tap in ~(key by new-capitol))
        |-
        ?~  shard-ids  %.y
        =*  shard-id  i.shard-ids
        =/  old-roots=batch-order:ui
          roots:(~(gut by capitol) shard-id *hall:seq)
        =/  new-roots=batch-order:ui
          roots:(~(gut by new-capitol) shard-id *hall:seq)
        ?~  old-roots  $(shard-ids t.shard-ids)
        ?~  new-roots  %.n
        =/  l-old=@ud  (lent old-roots)
        =/  l-new=@ud  (lent new-roots)
        ?.  |(=(l-old l-new) =(l-old (dec l-new)))  %.n
        $(shard-ids t.shard-ids)
      --
    --
  ::
  ++  on-arvo  on-arvo:def
  ++  on-fail  on-fail:def
  --
::
|_  =bowl:gall
+*  io      ~(. agentio bowl)
    ui-lib  ~(. indexer-lib bowl)
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
++  indexer-bootstrap-wire
  ^-  wire
  /indexer-bootstrap-update
::
++  indexer-catchup-wire
  |=  [shard-id=id:smart root=id:smart]
  ^-  wire
  /indexer-catchup-update/(scot %ux shard-id)/(scot %ux root)
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
++  indexer-bootstrap-path
  ^-  path
  /indexer-bootstrap
::
++  indexer-catchup-path
  |=  [shard-id=id:smart root=id:smart]
  ^-  path
  /indexer-catchup/(scot %ux shard-id)/(scot %ux root)
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
  ?~  leave-card  ~[watch-card]
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
  |=  [shard-id=id:smart batch-root=id:smart]
  ^-  (unit [batch-id=id:smart timestamp=@da =batch:ui])
  ?~  bs=(~(get by batches-by-shard) shard-id)  ~
  ?~  b=(~(get by batches.u.bs) batch-root)   ~
  `[batch-root u.b]
::
++  get-newest-batch
  |=  [shard-id=id:smart expected-root=id:smart]
  ^-  (unit [batch-id=id:smart timestamp=@da =batch:ui])
  ?~  b=(~(get by newest-batch-by-shard) shard-id)  ~
  ?.  =(expected-root batch-id.u.b)               ~
  `u.b
::
++  combine-txn-updates
  |=  updates=(list update:ui)
  ^-  update:ui
  ?~  update=(combine-txn-updates-to-map updates)  ~
  [%txn update]
::
++  get-ids
  |=  [qp=query-payload:ui only-newest=?]
  ^-  update:ui
  =/  from=update:ui  (serve-update %from qp only-newest %.n)
  =/  to=update:ui    (serve-update %to qp only-newest %.n)
  (combine-txn-updates ~[from to])
::
++  get-hashes
  |=  [qp=query-payload:ui only-newest=? should-filter=?]
  ^-  update:ui
  =*  options  [only-newest should-filter]
  =/  batch=update:ui   (serve-update %batch qp options)
  =/  txn=update:ui     (serve-update %txn qp options)
  =/  from=update:ui    (serve-update %from qp options)
  =/  item=update:ui   (serve-update %item qp options)
  =/  holder=update:ui  (serve-update %holder qp options)
  =/  source=update:ui    (serve-update %source qp options)
  =/  to=update:ui      (serve-update %to qp options)
  =/  shard=update:ui    (serve-update %shard qp options)
  :: =/  item-txns=update:ui
  ::   (serve-update %item-txns qp only-newest)
  %^  combine-updates  ~[batch shard]  ~[txn from to]
  ~[item holder source]
::
++  combine-batch-updates-to-map
  |=  updates=(list update:ui)
  ^-  (map id:smart [@da shard-location:ui batch:ui])
  ?~  updates  ~
  %-  %~  gas  by
      *(map id:smart [@da shard-location:ui batch:ui])
  %-  zing
  %+  turn  updates
  |=  =update:ui
  ?~  update  ~
  ?.  ?=(%batch -.update)
    ?.  ?=(%newest-batch -.update)  ~
    [+.update]~
  ~(tap by batches.update)
::
++  combine-txn-updates-to-map
  |=  updates=(list update:ui)
  ^-  (map id:smart [@da txn-location:ui transaction:smart])
  ?~  updates  ~
  %-  %~  gas  by
      *(map id:smart [@da txn-location:ui transaction:smart])
  %-  zing
  %+  turn  updates
  |=  =update:ui
  ?~  update  ~
  ?.  ?=(%txn -.update)
    ?.  ?=(%newest-txn -.update)  ~
    [+.update]~
  ~(tap by txns.update)
::
++  combine-item-updates-to-jar  ::  TODO: can this clobber?
  |=  updates=(list update:ui)
  ^-  (jar id:smart [@da batch-location:ui item:smart])
  ?~  updates  ~
  %-  %~  gas  by
      *(jar id:smart [@da batch-location:ui item:smart])
  %-  zing
  %+  turn  updates
  |=  =update:ui
  ?~  update  ~
  ?.  ?=(%item -.update)
    ?.  ?=(%newest-item -.update)  ~
    :_  ~
    :-  item-id.update
    [timestamp.update location.update item.update]~
  ~(tap by items.update)
::
++  combine-updates
  |=  $:  batch-updates=(list update:ui)
          txn-updates=(list update:ui)
          item-updates=(list update:ui)
      ==
  ^-  update:ui
  ?:  ?&  ?=(~ batch-updates)
          ?=(~ txn-updates)
          ?=(~ item-updates)
      ==
    ~
  =/  combined-batch=(map id:smart [@da shard-location:ui batch:ui])
    (combine-batch-updates-to-map batch-updates)
  =/  combined-txn=(map id:smart [@da txn-location:ui transaction:smart])
    (combine-txn-updates-to-map txn-updates)
  =/  combined-item=(jar id:smart [@da batch-location:ui item:smart])
    (combine-item-updates-to-jar item-updates)
  ?:  ?&  ?=(~ combined-batch)
          ?=(~ combined-txn)
          ?=(~ combined-item)
      ==
    ~
  [%hash combined-batch combined-txn combined-item]
::
++  set-state-from-vase
  |=  state-vase=vase
  ^-  _state
  =+  vs=!<(versioned-state:ui state-vase)
  ?-    -.vs
      %0
    :_  %-  inflate-state
        ~(tap by batches-by-shard.vs)
    %=  vs
      old-sub-paths    ~
      old-sub-updates  ~
      catchup-indexer  catchup-indexer
    ==
  ==
::
++  inflate-state
  |=  batches-by-shard-list=(list [@ux =batches:ui =batch-order:ui])
  ^-  indices-0:ui
  =|  temporary-state=_state
  |^
  ?~  batches-by-shard-list  +.temporary-state
  =/  batches-list=(list [root=@ux timestamp=@da =batch:ui])
    %+  murn  (flop batch-order.i.batches-by-shard-list)
    |=  =id:smart
    ?~  batch=(~(get by batches.i.batches-by-shard-list) id)
      ~
    `[id u.batch]
  %=  $
      batches-by-shard-list  t.batches-by-shard-list
      temporary-state       (inflate-shard batches-list)
  ==
  ::
  ++  inflate-shard
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
    %=  $
        batches-list     t.batches-list
        temporary-state  temporary-state
    ==
  --
::
++  serve-update
  |=  $:  =query-type:ui
          =query-payload:ui
          only-newest=?
          should-filter=?
      ==
  ^-  update:ui
  =/  get-appropriate-batch
    ?.(only-newest get-batch get-newest-batch)
  |^
  ?+    query-type  ~
      %batch
    get-batch-update
  ::
      :: ?(%txn %from %item %item-txns %holder %source %to)
      ?(%txn %from %item %holder %source %to)
    get-from-index
  ::
      %shard
    get-shard
  ==
  ::
  ++  get-shard
    ?.  ?=(@ query-payload)  ~
    =*  shard-id  query-payload
    ?~  bs=(~(get by batches-by-shard) shard-id)  ~
    ?:  only-newest
      ?~  batch-order.u.bs  ~
      =*  batch-id  i.batch-order.u.bs
      ?~  b=(~(get by batches.u.bs) batch-id)  ~
      :-  %newest-batch
      [batch-id timestamp.u.b shard-id batch.u.b]
    :-  %batch
    %-  %~  gas  by
        *(map id:smart [@da shard-location:ui batch:ui])
    %+  turn  ~(tap by batches.u.bs)
    |=  [batch-id=id:smart timestamp=@da =batch:ui]
    [batch-id [timestamp shard-id batch]]
  ::
  ++  get-batch-update
    ?:  ?=([@ @] query-payload)
      =*  shard-id   -.query-payload
      =*  batch-id  +.query-payload
      ?~  b=(get-appropriate-batch shard-id batch-id)  ~
      =*  timestamp  timestamp.u.b
      =*  batch      batch.u.b
      :-  %batch
      %+  %~  put  by
          *(map id:smart [@da shard-location:ui batch:ui])
      batch-id  [timestamp shard-id batch]
    ?.  ?=(@ query-payload)  ~
    =*  batch-id  query-payload
    =/  out=[%batch (map id:smart [@da shard-location:ui batch:ui])]
      %+  roll  ~(tap in ~(key by batches-by-shard))
      |=  $:  shard-id=id:smart
              out=[%batch (map id:smart [@da shard-location:ui batch:ui])]
          ==
      ?~  b=(get-appropriate-batch shard-id batch-id)  out
      =*  timestamp  timestamp.u.b
      =*  batch      batch.u.b
      :-  %batch
      (~(put by +.out) batch-id [timestamp shard-id batch])
    ?~(+.out ~ out)
  ::
  ++  get-from-index
    ^-  update:ui
    ?.  ?=(?(@ [@ @]) query-payload)  ~
    =/  locations=(list location:ui)  get-locations
    |^
    ?+    query-type  ~
        %item
      get-item
    ::
        %txn
      get-txn
    ::
        :: ?(%from %item-txns %holder %source %to)
        ?(%from %holder %source %to)
      get-second-order
    ==
    ::
    ++  get-item
      =/  item-id=id:smart
        ?:  ?=([@ @] query-payload)  +.query-payload
        query-payload
      ?:  only-newest  ::  TODO: DRY
        ?~  locations  ~
        =*  location  i.locations
        ?.  ?=(batch-location:ui location)  ~
        =*  shard-id     shard-id.location
        =*  batch-root  batch-root.location
        ?~  b=(get-appropriate-batch shard-id batch-root)  ~
        ?.  |(!only-newest =(batch-root batch-id.u.b))
          ::  TODO: remove this check if we never see this log
          ~&  >>>  "%indexer: unexpected batch root (item)"
          ~&  >>>  "br, bid: {<batch-root>} {<batch-id.u.b>}"
          ~
        =*  timestamp  timestamp.u.b
        =*  state    p.chain.batch.u.b
        ?~  item=(get:big:engine state item-id)  ~
        [%newest-item item-id timestamp location u.item]
      =|  items=(jar item-id=id:smart [@da batch-location:ui item:smart])
      =.  locations  (flop locations)
      |-
      ?~  locations  ?~(items ~ [%item items])
      =*  location  i.locations
      ?.  ?=(batch-location:ui location)
        $(locations t.locations)
      =*  shard-id     shard-id.location
      =*  batch-root  batch-root.location
      ?~  b=(get-appropriate-batch shard-id batch-root)
        $(locations t.locations)
      ?.  |(!only-newest =(batch-root batch-id.u.b))
        ::  TODO: remove this check if we never see this log
        ~&  >>>  "%indexer: unexpected batch root (item)"
        ~&  >>>  "br, bid: {<batch-root>} {<batch-id.u.b>}"
        $(locations t.locations)
      =*  timestamp  timestamp.u.b
      =*  state    p.chain.batch.u.b
      ?~  item=(get:big:engine state item-id)
        $(locations t.locations)
      %=  $
          locations  t.locations
          items
        %+  ~(add ja items)  item-id
        [timestamp location u.item]
      ==
    ::
    ++  get-txn
      ?:  only-newest  ::  TODO: DRY
        ?~  locations  ~
        =*  location  i.locations
        ?.  ?=(txn-location:ui location)  ~
        =*  shard-id     shard-id.location
        =*  batch-root  batch-root.location
        =*  txn-num     txn-num.location
        ?~  b=(get-appropriate-batch shard-id batch-root)  ~
        ?.  |(!only-newest =(batch-root batch-id.u.b))
          ::  happens for second-order only-newest queries that
          ::   resolve to txns because get-locations does not
          ::   guarantee they are in the newest batch
          ~
        =*  timestamp  timestamp.u.b
        =*  txs        transactions.batch.u.b
        ?.  (lth txn-num (lent txs))  ~
        =+  [hash=@ux txn=transaction:smart]=(snag txn-num txs)
        [%newest-txn hash timestamp location txn]
      =|  txns=(map id:smart [@da txn-location:ui transaction:smart])
      |-
      ?~  locations  ?~(txns ~ [%txn txns])
      =*  location  i.locations
      ?.  ?=(txn-location:ui location)
        $(locations t.locations)
      =*  shard-id     shard-id.location
      =*  batch-root  batch-root.location
      =*  txn-num     txn-num.location
      ?~  b=(get-appropriate-batch shard-id batch-root)
        $(locations t.locations)
      ?.  |(!only-newest =(batch-root batch-id.u.b))
        ::  happens for second-order only-newest queries that
        ::   resolve to txns because get-locations does not
        ::   guarantee they are in the newest batch
        $(locations t.locations)
      =*  timestamp  timestamp.u.b
      =*  txs        transactions.batch.u.b
      ?.  (lth txn-num (lent txs))  $(locations t.locations)
      =+  [hash=@ux txn=transaction:smart]=(snag txn-num txs)
      %=  $
          locations  t.locations
          txns
        (~(put by txns) hash [timestamp location txn])
      ==
    ::
    ++  get-second-order
      =/  first-order-type=?(%txn %item)
        ?:  |(?=(%holder query-type) ?=(%source query-type))
          %item
        %txn
      |^
      =/  =update:ui  create-update
      ?~  update  ~
      ?+    -.update  ~|("indexer: get-second-order unexpected return type" !!)
          %newest-txn  update
          %txn         update
      ::
          %newest-item
        ?.  should-filter  update
        ?.((is-item-hit +.+.update) ~ update)
      ::
          %item
        %=  update
            items
          ?.  should-filter  items.update
          (filter-items items.update)
        ==
      ==
      ::
      ++  is-item-hit
        |=  value=item-update-value:ui
        ^-  ?
        =/  query-hash=id:smart
          ?:  ?=(@ query-payload)  query-payload
          ?>  ?=([@ @] query-payload)
          +.query-payload
        =*  holder  holder.p.item.value
        =*  source    source.p.item.value
        ?|  &(?=(%holder query-type) =(query-hash holder))
            &(?=(%source query-type) =(query-hash source))
        ==
      ::
      ++  filter-items  ::  TODO: generalize w/ `+diff-update-items`
        |=  items=(jar id:smart item-update-value:ui)
        ^-  (jar id:smart item-update-value:ui)
        %-  %~  gas  by
            *(map id:smart (list item-update-value:ui))
        %+  roll  ~(tap by items)
        |=  $:  [item-id=id:smart values=(list item-update-value:ui)]
                out=(list [id:smart (list item-update-value:ui)])
            ==
        =/  filtered-values=(list item-update-value:ui)
          %+  roll  values
          |=  $:  =item-update-value:ui
                  inner-out=(list item-update-value:ui)
              ==
          ?.  (is-item-hit item-update-value)  inner-out
          [item-update-value inner-out]
        ?~  filtered-values  out
        [[item-id (flop filtered-values)] out]
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
            %txn
          ?.  ?=(?(%txn %newest-txn) -.next-update)  out
          %=  out
              txns
            ?:  ?=(%txn -.next-update)
              (~(uni by txns.out) txns.next-update)
            ?>  ?=(%newest-txn -.next-update)
            (~(put by txns.out) +.next-update)
          ==
        ::
            %item
          ?.  ?=(?(%item %newest-item) -.next-update)  out
          %=  out
              items
            ?:  ?=(%item -.next-update)
              (~(uni by items.out) items.next-update)  ::  TODO: can this clobber?
            ?>  ?=(%newest-item -.next-update)
            (~(add ja items.out) +.next-update)
          ==
        ::
            %newest-txn
          ?+    -.next-update  out
              %txn
            %=  next-update
                txns
              (~(put by txns.next-update) +.out)
            ==
          ::
              %newest-txn
            :-  %txn
            %.  ~[+.out +.next-update]
            %~  gas  by
            *(map id:smart [@da txn-location:ui transaction:smart])
          ==
        ::
            %newest-item
          ?+    -.next-update  out
              %item
            %=  next-update
                items
              (~(add ja items.next-update) +.out)  ::  TODO: ordering?
            ==
          ::
              %newest-item
            :-  %item
            %.  +.next-update
            %~  add  ja
            %.  +.out
            %~  add  ja
            *(jar id:smart item-update-value:ui)
          ==
        ==
      --
    --
  ::
  ++  get-locations
    |^  ^-  (list location:ui)
    ?+  query-type  ~|("indexer: get-locations unexpected query-type {<query-type>}" !!)
      %txn         (get-by-get-ja txn-index only-newest)
      %from        (get-by-get-ja from-index %.n)
      %item       (get-by-get-ja item-index only-newest)
      :: %item-txns  (get-by-get-ja item-txns-index %.n)
      %holder      (get-by-get-ja holder-index %.n)
      %source        (get-by-get-ja source-index %.n)
      %to          (get-by-get-ja to-index %.n)
    ==
    ::  always set `only-newest` false for
    ::   second-order indices or will
    ::   throw away unique txns/items.
    ::   Concretely, txn/item indices hold historical
    ::   state for a given hash, while second-order
    ::   indices hold different txns/items that hash
    ::   has appeared in (e.g. different items with a
    ::   given holder).
    ::
    ++  get-by-get-ja
      |=  [index=(map @ux (jar @ux location:ui)) only-newest=?]
      ^-  (list location:ui)
      ?:  ?=([@ @] query-payload)
        =*  shard-id    -.query-payload
        =*  item-hash  +.query-payload
        ?~  shard-index=(~(get by index) shard-id)      ~
        ?~  items=(~(get ja u.shard-index) item-hash)  ~
        ?:(only-newest ~[i.items] items)
      ?.  ?=(@ query-payload)  ~
      =*  item-hash  query-payload
      %+  roll  ~(val by index)
      |=  [shard-index=(jar @ux location:ui) out=(list location:ui)]
      ?~  items=(~(get ja shard-index) item-hash)  out
      ?:  only-newest  [i.items out]
      (weld out (~(get ja shard-index) item-hash))
    --
  --
::
++  consume-batch
  |=  $:  root=@ux
          txns=(list [@ux transaction:smart])
          =shard:seq
          timestamp=@da
          should-update-subs=?
      ==
  =*  shard-id  shard-id.hall.shard
  |^  ^-  (quip card _state)
  =+  ^=  [txn from item holder source to]
      (parse-batch root shard-id txns chain.shard)
  =:  txn-index         (gas-ja-txn txn-index txn shard-id)
      from-index        (gas-ja-second-order from-index from shard-id)
      item-index       (gas-ja-batch item-index item shard-id)
      ::  item-txns-index  (gas-ja-second-order item-txns-index item-txns shard-id)
      holder-index      (gas-ja-second-order holder-index holder shard-id)
      source-index        (gas-ja-second-order source-index source shard-id)
      to-index          (gas-ja-second-order to-index to shard-id)
      newest-batch-by-shard
    ::  only update newest-batch-by-shard with newer batches
    ?:  %+  gth
          ?~  current=(~(get by newest-batch-by-shard) shard-id)
            *@da
          timestamp.u.current
        timestamp
      newest-batch-by-shard
    %+  ~(put by newest-batch-by-shard)  shard-id
    [root timestamp txns shard]
  ::
      batches-by-shard
    %+  ~(put by batches-by-shard)  shard-id
    ?~  b=(~(get by batches-by-shard) shard-id)
      :_  ~[root]
      (malt ~[[root [timestamp txns shard]]])
    :_  [root batch-order.u.b]
    (~(put by batches.u.b) root [timestamp txns shard])
  ==
  ?.  should-update-subs  [~ state]
  =/  all-sub-cards  make-all-sub-cards
  :-  cards.all-sub-cards
  %=  state
      old-sub-paths
    ?~  paths.all-sub-cards  old-sub-paths
    (~(gas by *(map path @ux)) paths.all-sub-cards)
  ::
      old-sub-updates
    ?~  updates.all-sub-cards  old-sub-updates
    (~(gas by *(map @ux update:ui)) updates.all-sub-cards)
  ==
  ::
  ++  gas-ja-txn
    |=  $:  index=txn-index:ui
            new=(list [hash=@ux location=txn-location:ui])
            shard-id=id:smart
        ==
    %+  ~(put by index)  shard-id
    =/  shard-index=(jar @ux txn-location:ui)
      ?~(ti=(~(get by index) shard-id) ~ u.ti)
    |-
    ?~  new  shard-index
    %=  $
        new  t.new
        shard-index
      (~(add ja shard-index) hash.i.new location.i.new)
    ==
  ::
  ++  gas-ja-batch
    |=  $:  index=batch-index:ui
            new=(list [hash=@ux location=batch-location:ui])
            shard-id=id:smart
        ==
    %+  ~(put by index)  shard-id
    =/  shard-index=(jar @ux batch-location:ui)
      ?~(ti=(~(get by index) shard-id) ~ u.ti)
    |-
    ?~  new  shard-index
    %=  $
        new  t.new
        shard-index
      (~(add ja shard-index) hash.i.new location.i.new)
    ==
  ::
  ++  gas-ja-second-order
    |=  $:  index=second-order-index:ui
            new=(list [hash=@ux location=second-order-location:ui])
            shard-id=id:smart
        ==
    %+  ~(put by index)  shard-id
    =/  shard-index=(jar @ux second-order-location:ui)
      (~(gut by index) shard-id ~)
    |-
    ?~  new  shard-index
    %=  $
        new  t.new
        shard-index
      (~(add ja shard-index) hash.i.new location.i.new)
    ==
  ::
  ++  make-sub-paths
    ^-  (jug @tas path)
    %-  ~(gas ju *(jug @tas path))
    %+  murn  ~(val by sup.bowl)
    |=  [ship sub-path=path]
    ^-  (unit [@tas path])
    ?~  sub-path  ~
    ?.  ?=  ?(%batch-order %item %hash %holder %id %json %source %shard)
        i.sub-path
      ~
    `[`@tas`i.sub-path t.sub-path]
  ::
  ++  make-all-sub-cards
    ^-  $:  cards=(list card)
            paths=(list [path @ux])
            updates=(list [@ux update:ui])
        ==
    =/  sub-paths=(jug @tas path)  make-sub-paths
    |^
    =/  out
      %+  roll
        ^-  (list ?(%batch-order %id %json query-type:ui))
        :~  %batch-order
            %item
            %hash
            %holder
            %id
            %json
            %source
            %shard
        ==
      |=  $:  query-type=?(%batch-order %id %json query-type:ui)
              out=[cards=(list (list card)) paths=(list (list [path @ux])) updates=(list (list [@ux update:ui]))]
          ==
      =/  sub-cards  (make-sub-cards query-type)
      :+  [cards.sub-cards cards.out]
        [paths.sub-cards paths.out]
      [updates.sub-cards updates.out]
    [(zing cards.out) (zing paths.out) (zing updates.out)]
    ::
    ++  make-sub-cards
      |=  query-type=?(%batch-order %id %json query-type:ui)
      ^-  $:  cards=(list card)
              paths=(list [path @ux])
              updates=(list [@ux update:ui])
          ==
      =/  is-json=?  ?=(%json query-type)
      %+  roll  ~(tap in (~(get ju sub-paths) query-type))
      |=  $:  sub-path=path
              out=[cards=(list card) paths=(list [path @ux]) updates=(list [@ux update:ui])]
          ==
      ?~  sub-path  out
      =.  query-type
        ?.  is-json  query-type
        ;;(?(%id query-type:ui) i.sub-path)
      =.  sub-path
        ?.  is-json  sub-path
        ?>  ?=([@ ^] sub-path)
        t.sub-path
      =/  payload=?(@ux [@ux @ux])
        ?:  ?=(?([@ @ ~] [@ @ %history ~]) sub-path)
          (slav %ux i.sub-path)
        ?>  ?=(?([@ @ @ ~] [@ @ @ %history ~]) sub-path)
        [(slav %ux i.sub-path) (slav %ux i.t.sub-path)]
      =/  =update:ui
        ?+    query-type  !!
            %batch-order  [%batch-order ~[root]]
            %hash         (get-hashes payload %.y %.n)
            %id           (get-ids payload %.y)
            %holder
          (serve-update query-type payload %.y %.n)
        ::
            ?(%item %source %shard)
          (serve-update query-type payload %.y %.y)
        ==
      ?~  update  out
      =/  total-path=path  [query-type sub-path]
      =/  update-diff=update:ui
        (compute-update-diff update total-path)
      =/  update-hash=@ux  (mug update)
      :_  :-  [[total-path update-hash] paths.out]
          [[update-hash update] updates.out]
      ?~  update-diff  cards.out
      :_  cards.out
      ?.  is-json
        %-  fact:io
        :_  ~[total-path]
        [%indexer-update !>(`update:ui`update-diff)]
      %-  fact:io
      :_  ~[[%json total-path]]
      [%json !>(`json`(update:enjs:ui-lib update-diff))]
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
      =*  query-type  -.sub-path
      =/  old=update:ui
        %.  :_  ~
            %.  [sub-path 0x0]
            %~  gut  by
            old-sub-paths
        ~(gut by old-sub-updates)
      ?~  old             new
      ?.  =(-.old -.new)  ~  ::  require same type updates
      ?+    -.old         ~
      ::  TODO: simplify where we don't need diffs
          %batch
        ?>  ?=(%batch -.new)
        ?~  diff=(diff-update-maps batches.old batches.new)
          ~
        [%batch diff]
      ::
          %batch-order
        ?>  ?=(%batch-order -.new)
        ?~  batch-order.old  ?~(batch-order.new ~ new)
        ?~  batch-order.new  ~
        ?:(=(i.batch-order.old i.batch-order.new) ~ new)
      ::
          %txn
        ?>  ?=(%txn -.new)
        ?~  diff=(diff-update-maps txns.old txns.new)  ~
        [%txn diff]
      ::
          %item
        ?>  ?=(%item -.new)
        ?~  diff=(diff-update-items items.old items.new)
          ~
        :-  %item
        ?.  ?=(%holder query-type)  diff
        (filter-holder-held-in-last-batch diff items.old)
      ::
          %hash
        ?>  ?=(%hash -.new)
        =/  batch-diff=(map id:smart batch-update-value:ui)
          (diff-update-maps batches.old batches.new)
        =/  txn-diff=(map id:smart txn-update-value:ui)
          (diff-update-maps txns.old txns.new)
        =/  item-diff=(jar id:smart item-update-value:ui)
          (diff-update-items items.old items.new)
        =.  item-diff
        ?.  ?=(%holder query-type)  item-diff
        %+  filter-holder-held-in-last-batch  item-diff
        items.old
        ?:  ?&  ?=(~ batch-diff)
                ?=(~ txn-diff)
                ?=(~ item-diff)
            ==
          ~
        :^    %hash
            batches=batch-diff
          txns=txn-diff
        items=item-diff
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
          %newest-txn
        ?>  ?=(%newest-txn -.new)
        ?:  =(txn-id.old txn-id.new)                  ~
        ?~  diff=(diff-update-value +.+.old +.+.new)  ~
        [%newest-txn txn-id.new u.diff]
      ::
          %newest-item
        ?>  ?=(%newest-item -.new)
        ?~  diff=(diff-update-value +.+.old +.+.new)  ~
        [%newest-item item-id.new u.diff]
      ==
      ::
      ++  filter-holder-held-in-last-batch
        |=  $:  diff-items=(jar id:smart item-update-value:ui)
                old-items=(jar id:smart item-update-value:ui)
            ==
        ^-  (jar id:smart item-update-value:ui)
        =/  holder-id=id:smart
          %+  slav  %ux
          ?:  ?=  ?([%holder @ ~] [%holder @ %no-init ~])
              sub-path
            i.t.sub-path
          ?>  ?=  ?([%holder @ @ ~] [%holder @ @ %no-init ~])
              sub-path
          i.t.t.sub-path
        %-  %~  gas  by
            *(map id:smart (list item-update-value:ui))
        %+  roll  ~(tap by diff-items)
        |=  $:  [=id:smart diff-vals=(list item-update-value:ui)]
                out=(list [id:smart (list item-update-value:ui)])
            ==
        ?~  old-vals=(~(get ja old-items) id)
          [[id diff-vals] out]
        ~|  "expected newest"
        ?>  =(1 (lent diff-vals))
        ?>  =(1 (lent old-vals))
        ?.  =(holder-id holder.p.item.i.old-vals)  out
        [[id diff-vals] out]
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
      ++  diff-update-items  ::  TODO: generalize w/ `+filter-items`
        |=  $:  old-items=(jar id:smart item-update-value:ui)
                new-items=(jar id:smart item-update-value:ui)
            ==
        ^-  (jar id:smart item-update-value:ui)
        %-  %~  gas  by
            *(map id:smart (list item-update-value:ui))
        %+  roll  ~(tap by new-items)
        |=  $:  [=id:smart new-vals=(list item-update-value:ui)]
                out=(list [id:smart (list item-update-value:ui)])
            ==
        ?~  old-vals=(~(get ja old-items) id)
          ?~(new-vals out [[id new-vals] out])
        ?:  =(old-vals new-vals)  out
        =/  old-items=(set item:smart)
          %-  ~(gas in *(set item:smart))
          %+  turn  old-vals
          |=(old-val=item-update-value:ui item.old-val)
        =/  filtered-values=(list item-update-value:ui)
          %+  roll  new-vals
          |=  $:  new-val=item-update-value:ui
                  inner-out=(list item-update-value:ui)
              ==
          ?:  (~(has in old-items) item.new-val)  inner-out
          [new-val inner-out]
        ?~  filtered-values  out
        [[id (flop filtered-values)] out]
      --
    --
  ::
  ++  parse-batch
    |=  $:  root=@ux
            shard-id=@ux
            txns=(list [@ux transaction:smart])
            =chain:seq
        ==
    ^-  $:  (list [@ux txn-location:ui])
            (list [@ux second-order-location:ui])
            (list [@ux batch-location:ui])
            (list [@ux second-order-location:ui])
            (list [@ux second-order-location:ui])
            (list [@ux second-order-location:ui])
        ==
    =+  [item holder source]=(parse-state root shard-id p.chain)
    =+  [txn from to]=(parse-transactions root shard-id txns)
    [txn from item holder source to]
  ::
  ++  parse-state
    |=  [root=@ux shard-id=@ux =state:seq]
    ^-  $:  (list [@ux batch-location:ui])
            (list [@ux second-order-location:ui])
            (list [@ux second-order-location:ui])
        ==
    =|  parsed-item=(list [@ux batch-location:ui])
    =|  parsed-holder=(list [@ux second-order-location:ui])
    =|  parsed-source=(list [@ux second-order-location:ui])
    =/  items=(list [@ux [@ux item:smart]])
      ~(tap by state)
    |-
    ?~  items  [parsed-item parsed-holder parsed-source]
    =*  item-id   id.p.+.+.i.items
    =*  holder-id  holder.p.+.+.i.items
    =*  source-id    source.p.+.+.i.items
    %=  $
        items         t.items
    ::
        parsed-holder
      ?:  %+  exists-in-index  shard-id
          [holder-id item-id holder-index]
        parsed-holder
      [[holder-id item-id] parsed-holder]
    ::
        parsed-source
      ?:  %+  exists-in-index  shard-id
          [source-id item-id source-index]
        parsed-source
      [[source-id item-id] parsed-source]
    ::
        parsed-item
      ?:  %+  exists-in-index  shard-id
          [item-id [shard-id root] item-index]
        parsed-item
      :_  parsed-item
      :-  item-id
      [shard-id root]
    ==
  ::
  ++  parse-transactions
    |=  [root=@ux shard-id=@ux txs=(list [@ux transaction:smart])]
    ^-  $:  (list [@ux txn-location:ui])
            (list [@ux second-order-location:ui])
            (list [@ux second-order-location:ui])
        ==
    =|  parsed-txn=(list [@ux txn-location:ui])
    =|  parsed-from=(list [@ux second-order-location:ui])
    =|  parsed-to=(list [@ux second-order-location:ui])
    =/  txn-num=@ud  0
    |-
    ?~  txs  [parsed-txn parsed-from parsed-to]
    =*  txn-hash     -.i.txs
    =*  txn          +.i.txs
    =*  contract     contract.txn
    =*  from         address.caller.txn
    =/  =txn-location:ui  [shard-id root txn-num]
    %=  $
        txn-num      +(txn-num)
        txs          t.txs
        parsed-txn
      ?:  %+  exists-in-index  shard-id
          [txn-hash txn-location txn-index]
        parsed-txn
      [[txn-hash txn-location] parsed-txn]
    ::
        parsed-from
      ?:  %+  exists-in-index  shard-id
          [from txn-hash from-index]
        parsed-from
      [[from txn-hash] parsed-from]
    ::
        parsed-to
      ?:  %+  exists-in-index  shard-id
          [contract txn-hash to-index]
        parsed-to
      [[contract txn-hash] parsed-to]
    ==
  ::
  ++  exists-in-index
    |=  $:  shard-id=@ux
            key=@ux
            val=location:ui
            index=location-index:ui
        ==
    ^-  ?
    ?~  shard-index=(~(get by index) shard-id)  %.n
    %.  val
    %~  has  in
    %-  %~  gas  in  *(set location:ui)
    (~(get ja u.shard-index) key)
  --
--
