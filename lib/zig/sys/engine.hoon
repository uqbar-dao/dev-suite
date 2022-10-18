/-  *zig-engine
/+  *zink-zink, smart=zig-sys-smart, ethereum, merk
|_  [library=vase zink-cax=(map * @) test-mode=?]
::
++  verify-sig
  |=  txn=transaction:smart
  ^-  ?
  =/  hash=@
    ?~  eth-hash.txn
      (sham [shell calldata]:txn)
    u.eth-hash.txn
  =?  v.sig.txn  (gte v.sig.txn 27)  (sub v.sig.txn 27)
  .=  id.from.txn
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
++  mill
  |_  [miller=caller:smart shard-id=@ux batch=@ud eth-block-height=@ud]
  ::
  ::  +mill-all
  ::
  ::  All calls must be run through mill in parallel -- they should all operate against
  ::  the same starting state passed through `chain` at the beginning. Each run of mill
  ::  should create a (validated) diff set, which can then be compared with an
  ::  accumulated set of diffs. If there is overlap, that call should be discarded or
  ::  pushed into the next parallel "pass", depending on sequencer parameters.
  ::
  ++  mill-all
    |=  [=chain =mempool passes=@ud]
    ^-  [state-transition rejected=memlist]
    |^
    =/  pending
      ::  sort in REVERSE since each pass will reconstruct by appending
      ::  rejected to front, so need to +flop before each pass
      %+  sort  ~(tap in mempool)
      |=  [a=[@ux txn=transaction:smart] b=[@ux txn=transaction:smart]]
      ::  sort by rate, unless caller is same, in which case order by nonce
      ?:  =(id.from.txn.a id.from.txn.b)
        (gth nonce.from.txn.a nonce.from.txn.b)
      (lth rate.txn.a rate.txn.b)
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
      [hash transaction(status.shell %9)]
    ::  otherwise, perform a pass
    =/  [passed=state-transition rejected=memlist]
      (pass chain (flop pending))
    %=  $
      chain             chain.passed
      pending           rejected
      hits.final        (weld hits.passed hits.final)
      events.final      (weld events.passed events.final)
      burns.final       (uni:big burns.final burns.passed)
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
      =|  lis-hits=(list (list hints))
      =|  all-events=(list events:smart)
      =|  all-burns=state
      =|  reward=@ud
      |-  ::  TODO: make this a +turn
      ?~  pending
        :_  rejected
        :*  [(~(pay tax (uni:big p.chain all-diffs)) reward) q.chain]
            processed
            (flop lis-hits)
            all-diffs
            events
            all-burns
        ==
      ::
      =/  caller-id  id.from.transaction.i.pending
      ?:  (~(has in callers) caller-id)
        %=  $
          pending   t.pending
          rejected  [i.pending rejected]
        ==
      ::
      =/  [fee=@ud [diff=state =nonces] burned=state =errorcode:smart hits=(list hints) =events:smart]
        (mill chain transaction.i.pending)
      =/  diff-and-burned  (uni:big diff burned)
      ?.  ?&  ?=(~ (int:big all-diffs diff-and-burned))
              ?=(~ (int:big all-burns diff-and-burned))
          ==
        ?.  =(%0 errorcode)
          ::  invalid transaction -- do not send to next pass,
          ::  but do increment nonce
          %=  $
            pending    t.pending
            processed  [i.pending(status.transaction errorcode) processed]
            q.chain    nonces
            callers    (~(put in callers) caller-id)
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
        processed   [i.pending(status.transaction errorcode) processed]
        q.chain     nonces
        reward      (add reward fee)
        lis-hits    [hits lis-hits]
        all-events  [events all-events]
        callers     (~(put in callers) caller-id)
        all-diffs   (uni:big all-diffs diff)
        all-burns   (uni:big all-burns burned)
      ==
    --
  ::
  ::  +mill: processes a single transaction and returns map of modified grains + updated nonce
  ::
  ++  mill
    |=  [=chain =transaction:smart]
    ^-  [fee=@ud ^chain burned=state =errorcode:smart hits=(list hints) =events:smart]
    ::  validate transaction signature
    ?.  ?:(!test-mode (verify-sig transaction) %.y)
      ~&  >>>  "mill: signature mismatch"
      [0 [~ q.chain] ~ %2 ~ ~]  ::  signed tx doesn't match account
    ::
    =/  expected-nonce  +((gut:pig q.chain id.from.transaction 0))
    ?.  =(nonce.from.transaction expected-nonce)
      ~&  >>>  "mill: expected nonce={<expected-nonce>}, got {<nonce.from.transaction>}"
      [0 [~ q.chain] ~ %3 ~ ~]  ::  bad nonce
    ::
    ?.  (~(audit tax p.chain) transaction)
      ~&  >>>  "mill: tx rejected; account balance less than budget"
      [0 [~ q.chain] ~ %4 ~ ~]  ::  can't afford gas
    ::
    =/  res      (~(work farm p.chain) transaction)
    =/  fee=@ud  (sub budget.transaction rem.res)
    :+  fee
      :_  (put:pig q.chain id.from.transaction nonce.from.transaction)
      ::  charge gas fee by including their designated zigs grain inside the diff
      ?:  =(0 fee)  ~
      %+  put:big  (fall diff.res ~)
      (~(charge tax p.chain) (fall diff.res ~) from.transaction fee)
    [burned errorcode hits events]:res
  ::
  ::  +tax: manage payment for transaction in zigs
  ::
  ++  tax
    |_  =state
    +$  token-account
      $:  balance=@ud
          allowances=(map sender=id:smart @ud)
          metadata=id:smart
          nonce=@ud
      ==
    ::  +audit: evaluate whether a caller can afford gas,
    ::  and appropriately set budget for any zigs transactions
    ::  maximum possible charge is full budget * rate
    ++  audit
      |=  =transaction:smart
      ^-  ?
      ?~  zigs=(get:big state zigs.from.transaction)  %.n
      ?.  =(id.from.transaction holder.p.u.zigs)        %.n
      ?.  =(zigs-wheat-id:smart lord.p.u.zigs)        %.n
      ?.  ?=(%& -.u.zigs)                             %.n
      =/  balance  ;;(@ud -.data.p.u.zigs)
      (gte balance (mul budget.transaction rate.transaction))
    ::  +charge: extract gas fee from caller's zigs balance
    ::  returns a single modified grain to be inserted into a diff
    ::  cannot crash after audit, as long as zigs contract adequately
    ::  validates balance >= budget+amount.
    ++  charge
      |=  [diff=^state payee=caller:smart fee=@ud]
      ^-  [id:smart grain:smart]
      =/  zigs=grain:smart
        ::  find grain in diff, or fall back to full state
        ::  got will never crash since +audit proved existence
        %^  gut:big  diff  zigs.payee
        (got:big state zigs.payee)
      ?>  ?=(%& -.zigs)
      =/  balance  ;;(@ud -.data.p.zigs)
      =-  [zigs.payee zigs(data.p -)]
      [(sub balance fee) +.data.p.zigs]
    ::  +pay: give fees from transactions to miller
    ++  pay
      |=  total=@ud
      ^-  ^state
      =/  acc=grain:smart
        %^  gut:big  state  zigs.miller
        ::  create a new account rice for the sequencer if needed
        =/  =token-account  [total ~ `@ux`'zigs-metadata' 0]
        =/  =id:smart  (fry-rice:smart zigs-wheat-id:smart id.miller town-id `@`'zigs')
        [%& 'zigs' %account token-account id zigs-wheat-id:smart id.miller town-id]
      ?.  ?=(%& -.acc)  state
      =/  account  ;;(token-account data.p.acc)
      ?.  =(`@ux`'zigs-metadata' metadata.account)  state
      =.  balance.account  (add balance.account total)
      =.  data.p.acc  account
      (put:big state id.p.acc acc)
    --
  ::
  ::  +farm: execute a call to a contract
  ::
  ++  farm
    |_  =state
    ::  +work: take transaction and return diff state, remaining budget,
    ::  and errorcode (0=success)
    ++  work
      |=  =transaction:smart
      ^-  hatchling
      =/  res  (incubate transaction ~ ~)
      res(hits (flop hits.res))
    ::  +incubate: fertilize and germinate, then grow
    ++  incubate
      |=  [=transaction:smart hits=(list hints) burned=^state]
      ^-  hatchling
      =/  from  [id.from.transaction nonce.from.transaction]
      ::  check for grain burn transaction
      ?:  &(=(0x0 contract.transaction) =(%burn p.yolk.transaction))
        (poach transaction)
      ::  insert budget argument if transaction is %give-ing zigs
      =?  q.yolk.transaction  &(=(contract.transaction zigs-wheat-id:smart) =(p.yolk.transaction %give))
        [budget.transaction q.yolk.transaction]
      ?~  gra=(get:big state contract.transaction)
        ::  can't find contract to call
        [~ ~ ~ ~ budget.transaction %5]
      ?.  ?=(%| -.u.gra)
        ::  contract id found a rice
        [~ ~ ~ ~ budget.transaction %5]
      (grow from p.u.gra transaction hits burned)
    ::  +grow: recursively apply any calls stemming from transaction,
    ::  return on rooster or failure
    ++  grow
      |=  [from=[=id:smart nonce=@ud] =wheat:smart =transaction:smart hits=(list hints) burned=^state]
      ^-  hatchling
      |^
      =/  =context:smart  [contract.transaction from batch eth-block-height town-id]
      =+  [hit chick rem err]=(weed budget.transaction context)
      ?~  chick  [hit^hits ~ ~ ~ rem err]
      ?:  ?=(%& -.u.chick)
        ::  rooster result, finished growing
        ?~  diff=(harvest p.u.chick contract.transaction from.transaction)
          ::  failed validation
          [hit^hits ~ ~ ~ rem %7]
        ::  harvest passed
        [hit^hits diff burned.p.u.chick crow.p.u.chick rem err]
      ::  hen result, continuation
      =|  events=events:smart
      =|  all-diffs=^state
      =/  all-burns  burned.rooster.p.u.chick
      =*  next  next.p.u.chick
      =.  hits  hit^hits
      =/  last-diff  (harvest rooster.p.u.chick contract.transaction from.transaction)
      |-
      ?~  last-diff
        ::  diff from last call failed validation
        [hits ~ ~ ~ rem %7]
      =.  all-diffs  (dif:big (uni:big all-diffs u.last-diff) all-burns)
      ?~  next
        ::  all continuations complete
        [hits `all-diffs all-burns (weld events crow.rooster.p.u.chick) rem %0]
      ::  continue continuing
      =/  inter=hatchling
        %+  ~(incubate farm (dif:big (uni:big state all-diffs) all-burns))
          %=  transaction
            id.from.shell   contract.transaction
            contract.shell  contract.i.next
            budget.shell    rem
            yolk            yolk.i.next
          ==
        [hits all-burns]
      ?.  =(%0 errorcode.inter)
        [(weld hits.inter hits) ~ ~ ~ rem.inter errorcode.inter]
      %=  $
        next       t.next
        rem        rem.inter
        last-diff  diff.inter
        all-burns  (uni:big all-burns burned.inter)
        hits       (weld hits.inter hits)
        events      (weld events crow.inter)
      ==
      ::
      ::  +weed: run contract formula with arguments and memory, bounded by bud
      ::
      ++  weed
        |=  [budget=@ud =context:smart]
        ^-  [hints (unit chick:smart) rem=@ud =errorcode:smart]
        ~>  %bout
        |^
        ?~  cont.wheat   [~ ~ budget %6]
        =/  dor=vase  (load u.cont.wheat)
        =/  gun  (ajar dor %write !>(context) !>(yolk.transaction) %$)
        ::
        ::  generate ZK-proof hints with zebra
        ::
        =/  =book
          (zebra budget zink-cax search gun test-mode)
        :-  hit.q.book
        ?:  ?=(%| -.p.book)
          ::  error in contract execution
          ~&  >>>  p.book
          [~ bud.q.book %6]
        ::  chick result
        ?~  p.p.book
          ~&  >>>  "mill: ran out of gas"
          [~ 0 %8]
        [;;((unit chick:smart) p.p.book) bud.q.book %0]
        ::
        ++  load
          |=  cont=[bat=* pay=*]
          ^-  vase
          =/  payload   .*(q.library pay.cont)
          =/  cor       .*([q.library payload] bat.cont)
          [-:!>(*contract:smart) cor]
        ::
        ++  search
          |=  [bud=@ud pat=^]
          ::  TODO make search return [hints product]
          ^-  [bud=@ud product=(unit *)]
          ::  custom scry to handle grain reads and contract reads
          =/  rem  (sub bud 100)
          ?+    +.pat  rem^~
              [%0 %state @ ~]
            ::  /state/[grain-id]
            ?~  id=(slaw %ux -.+.+.+.pat)  rem^~
            ~&  >>  "looking for grain: {<`@ux`u.id>}"
            ?~  grain=(get:big state u.id)
              ~&  >>>  "didn't find it"  rem^~
            rem^grain
          ::
              [%0 %contract @ @ ^]
              ::  /contract/[%noun or %json]/[contract-id]/path/defined/in/contract
            =/  rem  (sub bud 100)  ::  base cost
            =/  kind  `@tas`-.+.+.+.pat
            ?.  ?=(?(%noun %json) kind)  rem^~
            ?~  id=(slaw %ux -.+.+.+.+.pat)  rem^~
            ::  path includes fee, as it must match fee in contract
            =/  read-path=path  ;;(path +.+.+.+.+.pat)
            ~&  >>  "looking for contract wheat: {<`@ux`u.id>}"
            ?~  grain=(get:big state u.id)
              ~&  >>>  "didn't find it"  rem^~
            ?.  ?=(%| -.u.grain)
              ~&  >>>  "wasn't wheat"  rem^~
            ?~  cont.p.u.grain
              ~&  >>>  "nok was empty"  rem^~
            =/  dor=vase  (load u.cont.p.u.grain)
            =/  gun    (ajar dor %read !>(context(me u.id)) !>(read-path) kind)
            =/  =book  (zebra rem zink-cax search gun test-mode)
            ?:  ?=(%| -.p.book)
              ::  error in contract execution
              ~&  >>>  p.book
              bud.q.book^~
            ::  chick result
            ?~  p.p.book
              ~&  >>>  "mill: ran out of gas inside read"
              bud.q.book^~
            bud.q.book^p.p.book
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
                =(id (hash-pact:smart source holder.p.item shard.p.item code.p.item))
              =(id (hash-data:smart source holder.p.item shard.p.item salt.p.item))
          ==
        ::
          %-  ~(all in burned.diff)
          |=  [=id:smart @ =item:smart]
          ::  all burned items must already exist AND
          ::  id in burned map must be equal to id in item AND
          ::  no burned items may also have been changed at same time AND
          ::  only items that proclaim us lord may be burned AND
          ::  burned cannot contain item used to pay for gas
          ::
          ::  NOTE: you *can* modify a item in-contract before burning it.
          ::  the shard of a burned item marks the town which can REDEEM it.
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
    ::  escaping some item from a shard. must be EITHER holder or source to burn.
    ::  if shard is the same as the source shard, the item is burned permanently.
    ::  otherwise, it can be reinstantiated on the specified shard.
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
      ?.  ?=([id=@ux shard=@ux] q.calldata.txn)      fail
      ::  item must exist in state
      ?~  to-burn=(get:big state id.q.calldata.txn)  fail
      ::  caller must be lord OR holder
      ?.  ?|  =(source.p.u.to-burn id.caller.txn)
              =(holder.p.u.to-burn id.caller.txn)
          ==                                         fail
      ::  produce hatchling
      :*  ~  [~ ~]
          (gas:big *^state ~[[id.p.u.to-burn u.to-burn]])
          ~[[%burn `json`[%s (scot %ux id.p.u.to-burn)]]]
          (sub bud.gas.txn (mul fixed-burn-cost rate.gas.txn))
          %0
      ==
    --
  --
--
