/-  *zig-engine
/+  smart=zig-sys-smart, zink=zink-zink, ethereum, merk
|_  [library=vase zink-cax=(map * @) test-mode=?]
::
++  verify-sig
  |=  txn=transaction:smart
  ^-  ?
  =/  hash=@
    ?~  eth-hash.txn
      (sham +.txn)
    u.eth-hash.txn
  =?  v.sig.txn  (gte v.sig.txn 27)  (sub v.sig.txn 27)
  .=  address.caller.txn
  %-  address-from-pub:key:ethereum
  %-  serialize-point:secp256k1:secp:crypto
  %+  ecdsa-raw-recover:secp256k1:secp:crypto
  hash  sig.txn
::
++  shut                                               ::  slam a door
  |=  [dor=vase arm=@tas dor-sam=vase arm-sam=vase inner-arm=@tas]
  ^-  vase
  %+  slap
    (slop dor (slop dor-sam arm-sam))
  ^-  hoon
  :-  %cnsg
  :^    [inner-arm ~]
      [%cnsg [arm ~] [%$ 2] [%$ 6] ~]  ::  replace sample
    [%$ 7]
  ~
::
++  ajar                                               ::  partial shut
  |=  [dor=vase arm=@tas dor-sam=vase arm-sam=vase inner-arm=@tas]
  ^-  (pair)
  =/  typ=type
    [%cell p.dor [%cell p.dor-sam p.arm-sam]]
  =/  gen=hoon
    :-  %cnsg
    :^    [inner-arm ~]
        [%cnsg [arm ~] [%$ 2] [%$ 6] ~]
      [%$ 7]
    ~
  =/  gun  (~(mint ut typ) %noun gen)
  [[q.dor [q.dor-sam q.arm-sam]] q.gun]
::
++  engine
  |_  [sequencer=caller:smart town-id=@ux batch=@ud eth-block-height=@ud]
  ::
  ::  +mill-all
  ::
  ::  All calls must be run through mill in parallel -- they should all operate against
  ::  the same starting state passed through `chain` at the beginning. Each run of mill
  ::  should create a (validated) diff set, which can then be compared with an
  ::  accumulated set of diffs. If there is overlap, that call should be discarded or
  ::  pushed into the next parallel "pass", depending on sequencer parameters.
  ::
  ++  run
    |=  [=chain =mempool passes=@ud]
    ^-  [state-transition rejected=memlist]
    |^
    =/  pending
      ::  sort in REVERSE since each pass will reconstruct by appending
      ::  rejected to front, so need to +flop before each pass
      %+  sort  ~(tap in mempool)
      |=  [a=[@ux txn=transaction:smart] b=[@ux txn=transaction:smart]]
      ::  sort by rate, unless caller is same, in which case order by nonce
      ?:  =(address.caller.txn.a address.caller.txn.b)
        (gth nonce.caller.txn.a nonce.caller.txn.b)
      (lth rate.gas.txn.a rate.gas.txn.b)
    ::
    =|  final=state-transition
    =|  reward=@ud
    |-
    ?:  ?|  ?=(~ pending)
            =(0 passes)
        ==
      ::  create final state transition
      ::  mark any remaining transactions as rejected
      :-  final(chain chain)
      %+  turn  pending
      |=  [hash=@ux =transaction:smart]
      [hash transaction(status %9)]
    ::  otherwise, perform a pass
    =/  [passed=state-transition rejected=memlist]
      (pass chain (flop pending))
    %=  $
      chain             chain.passed
      pending           rejected
      hits.final        (weld hits.passed hits.final)
      events.final      (weld events.passed events.final)
      burned.final      (uni:big burned.final burned.passed)
      processed.final   (weld processed.passed processed.final)
      state-diff.final  (uni:big state-diff.final state-diff.passed)
    ==
    ::
    ++  pass
      |=  [=^chain pending=memlist]
      ^-  [state-transition rejected=memlist]
      ::  we immediately send repeat callers to next pass
      =|  callers=(set address:smart)
      =|  processed=memlist
      =|  rejected=memlist
      =|  all-diffs=state
      =|  lis-hits=(list (list hints:zink))
      =|  all-events=(list contract-event)
      =|  all-burned=state
      =|  reward=@ud
      |-  ::  TODO: make this a +turn
      ?~  pending
        :_  rejected
        :*  [(~(pay tax (uni:big p.chain all-diffs)) reward) q.chain]
            processed
            (flop lis-hits)
            all-diffs
            all-events
            all-burned
        ==
      ::
      ?:  (~(has in callers) address.caller.txn.i.pending)
        %=  $
          pending   t.pending
          rejected  [i.pending rejected]
        ==
      ::
      =/  [fee=@ud [diff=state =nonces] burned=state =errorcode:smart hits=(list hints:zink) events=(list contract-event)]
        (run-single chain txn.i.pending)
      =/  diff-and-burned  (uni:big diff burned)
      ?.  ?&  ?=(~ (int:big all-diffs diff-and-burned))
              ?=(~ (int:big all-burned diff-and-burned))
          ==
        ?.  =(%0 errorcode)
          ::  invalid transaction -- do not send to next pass,
          ::  but do increment nonce
          %=  $
            pending    t.pending
            processed  [i.pending(status.txn errorcode) processed]
            q.chain    nonces
            callers    (~(put in callers) address.caller.txn.i.pending)
            reward     (add reward fee)
            lis-hits   [hits lis-hits]
          ==
        ::  valid, but diff or burned contains collision. re-mill in next pass
        ::
        %=  $
          pending   t.pending
          rejected  [i.pending rejected]
        ==
      ::  diff is isolated, proceed
      ::  increment nonce
      ::
      %=  $
        pending     t.pending
        processed   [i.pending(status.txn errorcode) processed]
        q.chain     nonces
        reward      (add reward fee)
        lis-hits    [hits lis-hits]
        all-events  (weld events all-events)
        callers     (~(put in callers) address.caller.txn.i.pending)
        all-diffs   (uni:big all-diffs diff)
        all-burned  (uni:big all-burned burned)
      ==
    --
  ::
  ::  +mill: processes a single transaction and returns map of modified grains + updated nonce
  ::
  ++  run-single
    |=  [=chain txn=transaction:smart]
    ^-  [fee=@ud ^chain burned=state =errorcode:smart hits=(list hints:zink) (list contract-event)]
    ::  validate transaction signature
    ?.  ?:(!test-mode (verify-sig txn) %.y)
      ~&  >>>  "mill: signature mismatch"
      [0 [~ q.chain] ~ %2 ~ ~]  ::  signed tx doesn't match account
    ::
    =/  expected-nonce  +((gut:pig q.chain address.caller.txn 0))
    ?.  =(nonce.caller.txn expected-nonce)
      ~&  >>>  "mill: expected nonce={<expected-nonce>}, got {<nonce.caller.txn>}"
      [0 [~ q.chain] ~ %3 ~ ~]  ::  bad nonce
    ::
    ?.  (~(audit tax p.chain) txn)
      ~&  >>>  "mill: tx rejected; account balance less than budget"
      [0 [~ q.chain] ~ %4 ~ ~]  ::  can't afford gas
    ::
    =/  res      (~(entry work p.chain) txn)
    =/  fee=@ud  (sub bud.gas.txn rem.res)
    :+  fee
      :_  (put:pig q.chain address.caller.txn nonce.caller.txn)
      ::  charge gas fee by including their designated zigs data inside the diff
      ?:  =(0 fee)  ~
      %+  put:big  (fall state-diff.res ~)
      (~(charge tax p.chain) (fall state-diff.res ~) caller.txn fee)
    [burned errorcode hits events]:res
  ::
  ::  +tax: manage payment for transaction in zigs
  ::
  ++  tax
    |_  =state
    +$  token-account
      $:  balance=@ud
          allowances=(pmap:smart sender=id:smart @ud)
          metadata=id:smart
          nonce=@ud
      ==
    ::  +audit: evaluate whether a caller can afford gas,
    ::  and appropriately set budget for any zigs transactions
    ::  maximum possible charge is full budget * rate
    ++  audit
      |=  txn=transaction:smart
      ^-  ?
      ?~  zigs=(get:big state zigs.caller.txn)       %.n
      ?.  =(address.caller.txn holder.p.u.zigs)      %.n
      ?.  =(zigs-contract-id:smart source.p.u.zigs)  %.n
      ?.  ?=(%& -.u.zigs)                            %.n
      %+  gte  ;;(@ud -.noun.p.u.zigs)
      (mul bud.gas.txn rate.gas.txn)
    ::  +charge: extract gas fee from caller's zigs balance
    ::  returns a single modified grain to be inserted into a diff
    ::  cannot crash after audit, as long as zigs contract adequately
    ::  validates balance >= budget+amount.
    ++  charge
      |=  [diff=^state payee=caller:smart fee=@ud]
      ^-  [id:smart item:smart]
      =/  zigs=item:smart
        ::  find item in diff, or fall back to full state
        ::  got will never crash since +audit proved existence
        %^  gut:big  diff  zigs.payee
        (got:big state zigs.payee)
      ?>  ?=(%& -.zigs)
      =/  balance  ;;(@ud -.noun.p.zigs)
      =-  [zigs.payee zigs(noun.p -)]
      [(sub balance fee) +.noun.p.zigs]
    ::  +pay: give fees from transactions to sequencer
    ++  pay
      |=  total=@ud
      ^-  ^state
      =/  acc=item:smart
        %^  gut:big  state  zigs.sequencer
        ::  create a new account rice for the sequencer if needed
        =/  =token-account  [total ~ `@ux`'zigs-metadata' 0]
        =/  =id:smart  (hash-data:smart zigs-contract-id:smart address.sequencer town-id `@`'zigs')
        [%& id zigs-contract-id:smart address.sequencer town-id 'zigs' %account token-account]
      ?.  ?=(%& -.acc)  state
      =/  account  ;;(token-account noun.p.acc)
      ?.  =(`@ux`'zigs-metadata' metadata.account)  state
      =.  balance.account  (add balance.account total)
      =.  noun.p.acc  account
      (put:big state id.p.acc acc)
    --
  ::
  ::  +farm: execute a call to a contract
  ::
  ++  work
    |_  =state
    +$  move  (quip call:smart diff:smart)
    ::  +work: take transaction and return diff state, remaining budget,
    ::  and errorcode (0=success)
    ++  entry
      |=  =transaction:smart
      ^-  hatchling
      =/  res  (process transaction ~ ~)
      res(hits (flop hits.res))
    ::  +incubate: fertilize and germinate, then grow
    ++  process
      |=  [txn=transaction:smart hits=(list hints:zink) burned=^state]
      ^-  hatchling
      ::  check for grain burn txn
      ?:  &(=(0x0 contract.txn) =(%burn p.calldata.txn))
        (exec-burn txn)
      ::  insert budget argument if txn is %give-ing zigs
      =?    q.calldata.txn
          ?&  =(contract.txn zigs-contract-id:smart)
              =(p.calldata.txn %give)
          ==
        [bud.gas.txn q.calldata.txn]
      ?~  item=(get:big state contract.txn)
        ::  can't find contract to call
        [~ ~ ~ ~ bud.gas.txn %5]
      ?.  ?=(%| -.u.item)
        ::  contract id found data, not pact
        [~ ~ ~ ~ bud.gas.txn %5]
      (handle p.u.item txn hits burned)
    ::  +grow: recursively apply any calls stemming from transaction,
    ::  return on rooster or failure
    ++  handle
      |=  [=pact:smart txn=transaction:smart hits=(list hints:zink) burned=^state]
      ^-  hatchling
      |^
      =/  =context:smart  [contract.txn [- +<]:caller.txn batch eth-block-height town-id]
      =+  [hit move rem err]=(exec bud.gas.txn context)
      ?~  move  [hit^hits ~ ~ ~ rem err]
      =*  calls  -.u.move
      =*  diff   +.u.move
      =|  events=(list contract-event)
      =|  all-diffs=^state
      =/  all-burned  burned.diff
      =.  hits  hit^hits
      =/  validated-diffs  (validate-diff diff contract.txn caller.txn)
      |-
      ?~  validated-diffs
        ::  diff from last call failed validation
        [hit^hits ~ ~ ~ rem %7]
      =.  all-diffs  (dif:big (uni:big all-diffs u.validated-diffs) all-burned)
      ?~  calls
        ::  diff-only result, finished calling
        =-  [hits `all-diffs all-burned - rem %0]
        %+  weld  events
        %+  turn  events.diff
        |=  i=[@tas json]
        [contract.txn -.caller.txn i]
      ::  run continuation calls
      =/  inter=hatchling
        %+  ~(process work (dif:big (uni:big state all-diffs) all-burned))
          %=  txn
            bud.gas         rem
            address.caller  contract.txn
            contract        contract.i.calls
            calldata        calldata.i.calls
          ==
        [hits all-burned]
      ?.  =(%0 errorcode.inter)
        [(weld hits.inter hits) ~ ~ ~ rem.inter errorcode.inter]
      %=  $
        calls       t.calls
        rem        rem.inter
        validated-diffs  state-diff.inter
        all-burned  (uni:big all-burned burned.inter)
        hits       (weld hits.inter hits)
          events  (weld events events.inter)

      ==
      ::
      ::  +weed: run contract formula with arguments and memory, bounded by bud
      ::
      ++  exec
        |=  [gas=@ud =context:smart]
        ^-  [hints:zink (unit move) gas=@ud =errorcode:smart]
        ~>  %bout
        |^
        ~&  >  "context: {<context>}"
        ~&  >>  "calldata: {<calldata.txn>}"
        =/  dor=vase  (load code.pact)
        =/  gun  (ajar dor %write !>(context) !>(calldata.txn) %$)
        ::
        ::  generate ZK-proof hints with zebra
        ::
        =/  =book:zink
          (zebra:zink gas zink-cax search gun test-mode)
        :-  hit.q.book
        ?:  ?=(%| -.p.book)
          ::  error in contract execution
          ~&  >>>  p.book
          [~ gas.q.book %6]
        ::  chick result
        ?~  p.p.book
          ~&  >>>  "engine: ran out of gas"
          [~ 0 %8]
        [;;((unit move) p.p.book) gas.q.book %0]
        ::
        ++  load
          |=  code=[bat=* pay=*]
          ^-  vase
          :-  -:!>(*contract:smart)
          =/  payload  (mink [q.library pay.code] ,~)
          ?.  ?=(%0 -.payload)  +:!>(*contract:smart)
          =/  cor  (mink [[q.library product.payload] bat.code] ,~)
          ?.  ?=(%0 -.cor)  +:!>(*contract:smart)
          product.cor
        ::
        ::  +search: our chain-state-scry
        ::  to handle item gets and contract reads
        ::
        ++  search
          |=  [gas=@ud pit=^]
          ::  TODO make search return hints
          ^-  [gas=@ud product=(unit *)]
          =/  rem  (sub gas 100)  ::  fixed scry cost
          ?+    +.pit  rem^~
            ::  TODO when typed paths are included in core:
            ::  convert these matching types to good syntax
              [%0 %state [%ux @ux] ~]
            ::  /state/[item-id]
            =/  item-id=id:smart  +.-.+.+.+.pit
            ~&  >>  "looking for item: {<item-id>}"
            ?~  item=(get:big state item-id)
              ~&  >>>  "didn't find it"  rem^~
            rem^item
          ::
              [%0 %contract ?(%noun %json) [%ux @ux] ^]
            ::  /contract/[%noun or %json]/[contract-id]/pith/in/contract
            =/  kind                      -.+.+.+.pit
            =/  contract-id=id:smart  +.-.+.+.+.+.pit
            ::  pith includes fee, as it must match fee in contract
            =/  read-pith=pith:smart  ;;(pith:smart +.+.+.+.+.pit)
            ~&  >>  "looking for pact: {<contract-id>}"
            ?~  item=(get:big state contract-id)
              ~&  >>>  "didn't find it"  rem^~
            ?.  ?=(%| -.u.item)
              ~&  >>>  "wasn't a pact"  rem^~
            =/  dor=vase  (load code.p.u.item)
            =/  gun
              (ajar dor %read !>(context(this contract-id)) !>(read-pith) kind)
            =/  =book:zink  (zebra:zink rem zink-cax search gun test-mode)
            ?:  ?=(%| -.p.book)
              ::  error in contract execution
              ~&  >>>  p.book
              gas.q.book^~
            ::  chick result
            ?~  p.p.book
              ~&  >>>  "engine: ran out of gas inside read"
              gas.q.book^~
            gas.q.book^p.p.book
          ==
        --
      --
    ::
    ::  +harvest: take a completed execution and validate all changes
    ::  and additions to state state
    ::
    ++  validate-diff
      |=  [=diff:smart source=id:smart =caller:smart]
      ^-  (unit ^state)
      =-  ?.  -
            ~&  >>>  "harvest checks failed"
            ~
          `(uni:big changed.diff issued.diff)
      ?&  %-  ~(all in changed.diff)
          |=  [=id:smart @ =item:smart]
          ::  all changed items must already exist AND
          ::  new item must be same type as old item AND
          ::  id in changed map must be equal to id in item AND
          ::  if data, salt must not change AND
          ::  only items that proclaim us source may be changed
          =/  old  (get:big state id)
          ?&  ?=(^ old)
              ?:  ?=(%& -.u.old)
                &(?=(%& -.item) =(salt.p.u.old salt.p.item))
              =(%| -.item)
              =(id id.p.item)
              =(source.p.item source.p.u.old)
              =(source source.p.u.old)
          ==
        ::
          %-  ~(all in issued.diff)
          |=  [=id:smart @ =item:smart]
          ::  id in issued map must be equal to id in item AND
          ::  source of item must either be contract issuing it or 0x0 AND
          ::  item must not yet exist at that id AND
          ::  item IDs must match defined hashing functions
          ?&  =(id id.p.item)
              |(=(source source.p.item) =(0x0 source.p.item))
              !(has:big state id.p.item)
              ?:  ?=(%| -.item)
                =(id (hash-pact:smart source holder.p.item town.p.item code.p.item))
              =(id (hash-data:smart source holder.p.item town.p.item salt.p.item))
          ==
        ::
          %-  ~(all in burned.diff)
          |=  [=id:smart @ =item:smart]
          ::  all burned items must already exist AND
          ::  id in burned map must be equal to id in item AND
          ::  no burned items may also have been changed at same time AND
          ::  only items that proclaim us source may be burned AND
          ::  burned cannot contain item used to pay for gas
          ::
          ::  NOTE: you *can* modify a item in-contract before burning it.
          ::  the town-id of a burned item marks the town which can REDEEM it.
          ::
          =/  old  (get:big state id)
          ?&  ?=(^ old)
              =(id id.p.item)
              !(has:big changed.diff id)
              =(source.p.item source.p.u.old)
              =(source source.p.u.old)
              !=(zigs.caller id)
          ==
      ==
    ::
    ::  +exec-burn: handle special burn-only transactions, used for manually
    ::  escaping some item from a town. must be EITHER holder or source to burn.
    ::  if town-id is the same as the source town, the item is burned permanently.
    ::  otherwise, it can be reinstantiated on the specified town.
    ::
    ++  exec-burn
      |=  txn=transaction:smart
      ^-  hatchling
      ::  TODO provide new error codes for these things
      ::  TODO assign reasonable fixed cost for a burn
      =/  fixed-burn-cost  1.000
      ::  charge fixed cost for failed transactions too
      ::  TODO should do this everywhere that we can inside +farm
      =/  fail  [~ ~ ~ ~ (sub bud.gas.txn fixed-burn-cost) %6]
      ::  argument for %burn must be a grain ID and town ID
      ?.  ?=([id=@ux town=@ux] q.calldata.txn)      fail
      ::  item must exist in state
      ?~  to-burn=(get:big state id.q.calldata.txn)  fail
      ::  caller must be source OR holder
      ?.  ?|  =(source.p.u.to-burn address.caller.txn)
              =(holder.p.u.to-burn address.caller.txn)
          ==                                         fail
      ::  produce hatchling
      :*  ~  [~ ~]  ::  TODO hints
          (gas:big *^state ~[[id.p.u.to-burn u.to-burn]])
          ~[[0x0 address.caller.txn %burn `json`[%s (scot %ux id.p.u.to-burn)]]]
          (sub bud.gas.txn (mul fixed-burn-cost rate.gas.txn))
          %0
      ==
    --
  --
--
