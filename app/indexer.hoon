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
::    Scry paths may be prepended with a `/json`, which
::    will cause the scry to return JSON rather than an
::    `update:ui` and will attempt to mold the `data` in
::    `grain`s and the `yolk` in `egg`s.
::    In order to do so it requires the `lord` contracts
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
::    E.g., `/grain/0xdead.beef` will not receive an
::    immediate response, while `/grain/0xdead.beef/history`
::    will immediately receive the history of that grain.
::
::    Subscription paths, similar to scry paths,
::    may be prepended with a `/json`, which will cause
::    the subscription to return JSON rather than an
::    `update:ui` and will attempt to mold the `data` in
::    `grain`s and the `yolk` in `egg`s.
::    In order to do so it requires the `lord` contracts
::    have properly filled out `interface` and `types`
::    fields, see `lib/jolds.hoon` docstring for the spec
::    and `con/lib/*interface-types.hoon`
::    for examples.
::
::    /batch-order/[town-id=@ux]:
::      A stream of batch ids.
::    /grain/[grain-id=@ux]
::    /grain/[town-id=@ux]/[grain-id=@ux]:
::      A stream of changes to given grain.
::    /hash/[@ux]:
::      A stream of new activity of given id.
::    /holder/[holder-id=@ux]
::    /holder/[town-id=@ux]/[holder-id=@ux]:
::      A stream of new activity of given holder.
::      If a held grain changes holders, the final update
::      sent for that grain will have the updated holder.
::      Thus, applications will need to check the holder
::      field and update their state as appropriate when
::      it has changed; subsequent updates will not include
::      that grain.
::      Reply on-watch is entire history of held grains.
::    /id/[id=@ux]
::    /id/[town-id=@ux]/[id=@ux]:
::      A stream of new transactions of given id:
::      specifically transactions where id appears
::      in the `from` or `contract` fields.
::    /lord/[lord-id=@ux]
::    /lord/[town-id=@ux]/[lord-id=@ux]:
::      A stream of new activity of given lord.
::    /town/[town-id=@ux]
::    /town/[town-id=@ux]/[town-id=@ux]:
::      A stream of each new batch for town.
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
/-  mill,
    uqbar,
    seq=sequencer,
    ui=indexer
/+  agentio,
    dbug,
    default-agent,
    verb,
    indexer-lib=indexer,
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
      =+  !<([=dock town=id:smart root=id:smart] vase)
      :_  this(catchup-indexer dock)
      %^    set-watch-target:ic
          (indexer-catchup-wire town root)
        dock
      (indexer-catchup-path town root)
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
      =/  town-id=id:smart  (slav %ux i.t.path)
      =/  root=id:smart     (slav %ux i.t.t.path)
      =/  [=batches:ui =batch-order:ui]
        (~(gut by batches-by-town) town-id [~ ~])
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
            [%grain @ @ %history ~]   [%grain @ @ @ %history ~]
            [%holder @ @ %history ~]  [%holder @ @ @ %history ~]
            [%lord @ @ %history ~]    [%lord @ @ @ %history ~]
            [%town @ @ %history ~]    [%town @ @ @ %history ~]
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
            [%grain @ @ ~]   [%grain @ @ @ ~]
            [%holder @ @ ~]  [%holder @ @ @ ~]
            [%lord @ @ ~]    [%lord @ @ @ ~]
            [%town @ @ ~]    [%town @ @ @ ~]
        ==
      `this
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
            [%json *]
            [%lord *]
            [%town *]
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
      =/  town-id=@ux  (slav %ux i.t.args)
      %-  make-peek-update
      ?~  bs=(~(get by batches-by-town) town-id)  ~
      [%batch-order batch-order.u.bs]
    ::
        [%batch-order @ @ @ ~]
      =/  [town-id=@ux nth-most-recent=@ud how-many=@ud]
        :+  (slav %ux i.t.args)  (slav %ud i.t.t.args)
        (slav %ud i.t.t.t.args)
      %-  make-peek-update
      ?~  bs=(~(get by batches-by-town) town-id)  ~
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
        =:  batches-by-town         ~
            capitol                 ~
            sequencer-update-queue  ~
            town-update-queue       ~
            old-sub-paths           ~
            old-sub-updates         ~
            egg-index               ~
            from-index              ~
            grain-index             ~
            :: grain-eggs-index        ~
            holder-index            ~
            lord-index              ~
            to-index                ~
            newest-batch-by-town    ~
        ==
        `this(state (set-state-from-vase q.cage.sign))
      ==
    ::
        [%indexer-catchup-update @ @ ~]
      =/  town-id=id:smart  (slav %ux i.t.wire)
      =/  root=id:smart     (slav %ux i.t.t.wire)
      ?+    -.sign  (on-agent:def wire sign)
          %fact
        :-  ~
        =+  !<([=batches:ui =batch-order:ui] q.cage.sign)
        =/  old=(unit (pair batches:ui batch-order:ui))
          (~(get by batches-by-town) town-id)
        ?~  old
          %=  this
              batches-by-town
            %+  ~(put by batches-by-town)  town-id
            [batches batch-order]
          ==
        =/  root-index=@ud
          ?~(i=(find ~[root] q.u.old) 0 +(u.i))
        =.  batches-by-town
          %+  ~(put by batches-by-town)  town-id
          :-  (~(uni by p.u.old) batches)
          (weld batch-order (slag root-index q.u.old))
        %=  this
            sequencer-update-queue  ~
            town-update-queue       ~
            +.state
          %-  inflate-state
          ~(tap by batches-by-town)
        ==
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
        |=  [town-id=id:smart @ [@ @] [@ *] @ roots=(list @ux)]
        =/  [* =batch-order:ui]
          %+  ~(gut by batches-by-town)  town-id
          [~ batch-order=~]
        =/  needed-list=(list id:smart)
          (find-needed-batches roots batch-order)
        ?~  needed-list  ~
        =*  root  i.needed-list
        :-  ~
        %^    watch-target:ic
            (indexer-catchup-wire town-id root)
          catchup-indexer
        (indexer-catchup-path town-id root)
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
        =/  town-ids=(list id:smart)
          ~(tap in ~(key by new-capitol))
        |-
        ?~  town-ids  %.y
        =*  town-id  i.town-ids
        =/  old-roots=batch-order:ui
          roots:(~(gut by capitol) town-id *hall:seq)
        =/  new-roots=batch-order:ui
          roots:(~(gut by new-capitol) town-id *hall:seq)
        ?~  old-roots  $(town-ids t.town-ids)
        ?~  new-roots  %.n
        =/  l-old=@ud  (lent old-roots)
        =/  l-new=@ud  (lent new-roots)
        ?.  |(=(l-old l-new) =(l-old (dec l-new)))  %.n
        $(town-ids t.town-ids)
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
  |=  [town-id=id:smart root=id:smart]
  ^-  wire
  /indexer-catchup-update/(scot %ux town-id)/(scot %ux root)
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
  |=  [town-id=id:smart root=id:smart]
  ^-  path
  /indexer-catchup/(scot %ux town-id)/(scot %ux root)
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
  |=  [town-id=id:smart batch-root=id:smart]
  ^-  (unit [batch-id=id:smart timestamp=@da =batch:ui])
  ?~  bs=(~(get by batches-by-town) town-id)  ~
  ?~  b=(~(get by batches.u.bs) batch-root)   ~
  `[batch-root u.b]
::
++  get-newest-batch
  |=  [town-id=id:smart expected-root=id:smart]
  ^-  (unit [batch-id=id:smart timestamp=@da =batch:ui])
  ?~  b=(~(get by newest-batch-by-town) town-id)  ~
  ?.  =(expected-root batch-id.u.b)               ~
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
  =/  from=update:ui  (serve-update %from qp only-newest %.n)
  =/  to=update:ui    (serve-update %to qp only-newest %.n)
  (combine-egg-updates ~[from to])
::
++  get-hashes
  |=  [qp=query-payload:ui only-newest=? should-filter=?]
  ^-  update:ui
  =*  options  [only-newest should-filter]
  =/  batch=update:ui   (serve-update %batch qp options)
  =/  egg=update:ui     (serve-update %egg qp options)
  =/  from=update:ui    (serve-update %from qp options)
  =/  grain=update:ui   (serve-update %grain qp options)
  =/  holder=update:ui  (serve-update %holder qp options)
  =/  lord=update:ui    (serve-update %lord qp options)
  =/  to=update:ui      (serve-update %to qp options)
  =/  town=update:ui    (serve-update %town qp options)
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
  =+  !<(=versioned-state:ui state-vase)
  ?-    -.versioned-state
      %0
    :_  %-  inflate-state
        ~(tap by batches-by-town.versioned-state)
    %=  versioned-state
        old-sub-paths    ~
        old-sub-updates  ~
        catchup-indexer  catchup-indexer
    ==
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
      %+  roll  ~(tap in ~(key by batches-by-town))
      |=  $:  town-id=id:smart
              out=[%batch (map id:smart [@da town-location:ui batch:ui])]
          ==
      ?~  b=(get-appropriate-batch town-id batch-id)  out
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
          %newest-egg  update
          %egg         update
      ::
          %newest-grain
        ?.  should-filter  update
        ?.((is-grain-hit +.+.update) ~ update)
      ::
          %grain
        %=  update
            grains
          ?.  should-filter  grains.update
          (filter-grains grains.update)
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
        =*  holder  holder.p.grain.value
        =*  lord    lord.p.grain.value
        ?|  &(?=(%holder query-type) =(query-hash holder))
            &(?=(%lord query-type) =(query-hash lord))
        ==
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
            (~(add ja grains.out) +.next-update)
          ==
        ::
            %newest-egg
          ?+    -.next-update  out
              %egg
            %=  next-update
                eggs
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
              (~(add ja grains.next-update) +.out)  ::  TODO: ordering?
            ==
          ::
              %newest-grain
            :-  %grain
            %.  +.next-update
            %~  add  ja
            %.  +.out
            %~  add  ja
            *(jar id:smart grain-update-value:ui)
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
    ?.  ?=  ?(%batch-order %grain %hash %holder %id %json %lord %town)
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
            %grain
            %hash
            %holder
            %id
            %json
            %lord
            %town
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
            ?(%grain %lord %town)
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
          %egg
        ?>  ?=(%egg -.new)
        ?~  diff=(diff-update-maps eggs.old eggs.new)  ~
        [%egg diff]
      ::
          %grain
        ?>  ?=(%grain -.new)
        ?~  diff=(diff-update-grains grains.old grains.new)
          ~
        :-  %grain
        ?.  ?=(%holder query-type)  diff
        (filter-holder-held-in-last-batch diff grains.old)
      ::
          %hash
        ?>  ?=(%hash -.new)
        =/  batch-diff=(map id:smart batch-update-value:ui)
          (diff-update-maps batches.old batches.new)
        =/  egg-diff=(map id:smart egg-update-value:ui)
          (diff-update-maps eggs.old eggs.new)
        =/  grain-diff=(jar id:smart grain-update-value:ui)
          (diff-update-grains grains.old grains.new)
        =.  grain-diff
        ?.  ?=(%holder query-type)  grain-diff
        %+  filter-holder-held-in-last-batch  grain-diff
        grains.old
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
      ++  filter-holder-held-in-last-batch
        |=  $:  diff-grains=(jar id:smart grain-update-value:ui)
                old-grains=(jar id:smart grain-update-value:ui)
            ==
        ^-  (jar id:smart grain-update-value:ui)
        =/  holder-id=id:smart
          %+  slav  %ux
          ?:  ?=  ?([%holder @ ~] [%holder @ %no-init ~])
              sub-path
            i.t.sub-path
          ?>  ?=  ?([%holder @ @ ~] [%holder @ @ %no-init ~])
              sub-path
          i.t.t.sub-path
        %-  %~  gas  by
            *(map id:smart (list grain-update-value:ui))
        %+  roll  ~(tap by diff-grains)
        |=  $:  [=id:smart diff-vals=(list grain-update-value:ui)]
                out=(list [id:smart (list grain-update-value:ui)])
            ==
        ?~  old-vals=(~(get ja old-grains) id)
          [[id diff-vals] out]
        ~|  "expected newest"
        ?>  =(1 (lent diff-vals))
        ?>  =(1 (lent old-vals))
        ?.  =(holder-id holder.p.grain.i.old-vals)  out
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
    =*  contract     contract.shell.egg
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
          [contract egg-hash to-index]
        parsed-to
      [[contract egg-hash] parsed-to]
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
