/-  *zig-engine
/+  smart=zig-sys-smart, zink=zink-zink, ethereum
|_  [library=vase zink-cax=(map * @) sigs-on=? hints-on=?]
::
::  engine
::
++  engine
  |_  [sequencer=caller:smart town-id=@ux batch-num=@ud eth-block-height=@ud]
  ::
  ::  +run: produce a state transition for a given town and mempool
  ::
  ++  run
    |=  [=chain =mempool passes=@ud]
    ^-  state-transition-2
    ::  declare initial values
    =/  pending=memlist  (sort-mempool mempool)
    =|  state-transition=state-transition-2
    =|  gas-reward=@ud
    =.  chain.state-transition  chain
    |-
    ?~  pending
      ::  finished with execution: pay accumulated
      ::  gas to sequencer, then return result
      state-transition(p.chain (~(pay tax p.chain) gas-reward))
    ::  execute a single transaction and integrate the diff
    =*  tx  txn.i.pending
    =/  =output  ~(intake eng chain.state-transition tx)
    =/  priced-gas  (mul gas.output rate.gas.tx)
    %=  $
      pending     t.pending
      gas-reward  (add gas-reward priced-gas)
        state-transition
      %=    state-transition
        modified  (uni:big modified.state-transition modified.output)
        burned    (uni:big burned.state-transition burned.output)
      ::
          processed
        [i.pending(status.txn errorcode.output) processed.state-transition]
      ::
          events
        %+  weld  events.state-transition
        %+  turn  events.output
        |=  i=[@tas json]
        [contract.tx address.caller.tx i]
      ::
          p.chain
        ::  charge gas here
        %.  [caller.tx priced-gas]
        %~  charge  tax
        %+  dif:big
          (uni:big p.chain.state-transition modified.output)
        burned.output
      ::
          q.chain
        ?:  ?=(?(%1 %2) errorcode.output)  q.chain.state-transition
        (put:pig q.chain.state-transition [address nonce]:caller.tx)
      ==
    ==
  ::
  ::  inner handler for processing each transaction
  ::  intake -> combust -> power -> exhaust
  ++  eng
    |_  [=chain tx=transaction:smart]
    +$  move  (quip call:smart diff:smart)
    ::
    ++  intake
      ^-  output
      ::  validate transaction signature,
      ::  validate nonce,
      ::  assert caller can afford gas budget,
      ?.  ?:(sigs-on (verify-sig tx) %.y)
        ~&  >>>  "engine: signature mismatch"
        (exhaust 0 %1 ~)
      ?.  .=  nonce.caller.tx
          +((gut:pig q.chain address.caller.tx 0))
        ~&  >>>  "engine: nonce mismatch"
        (exhaust 0 %2 ~)
      ?.  (~(audit tax p.chain) tx)
        ~&  >>>  "engine: tx failed gas audit"
        (exhaust 0 %3 ~)
      ::
      |-  ::  recursion point for calls
      ::
      ::  check for special burn txns,
      ::  insert budget special for zigs txns,
      ::  get pact from chain state,
      ::
      ?:  &(=(0x0 contract.tx) =(%burn p.calldata.tx))
        ::  special burn tx
        !!
      =?    q.calldata.tx
          ?&  =(contract.tx zigs-contract-id:smart)
              =(p.calldata.tx %give)
          ==
        [bud.gas.tx q.calldata.tx]
      ?~  pac=(get:big p.chain contract.tx)
        ~&  >>>  "engine: call to missing pact"
        (exhaust 0 %4 ~)
      ?.  ?=(%| -.u.pac)
        ~&  >>>  "engine: call to data, not pact"
        (exhaust 0 %5 ~)
      ::
      ::  build context for call,
      ::  call +combust to get move/hints/gas/error
      ::  (exit now if fail)
      ::  (validate this first diff)
      ::
      =/  =context:smart
        [contract.tx [- +<]:caller.tx batch-num eth-block-height town-id]
      =/  [mov=(unit move) gas=@ud =errorcode:smart]
        ::  combust returns amount of gas *remaining*
        (combust code.p.u.pac context calldata.tx bud.gas.tx)
      ::
      ?~  mov  (exhaust gas errorcode ~)
      =*  calls  -.u.mov
      =*  diff   +.u.mov
      =/  all-diffs   (uni:big changed.diff issued.diff)
      =/  all-burns   burned.diff
      =/  all-events  events.diff
      |-  ::  INNER recursion point for continuations
      ?.  (clean diff contract.tx zigs.caller.tx)
        (exhaust gas %7 ~)
      ?~  calls
        ::  diff-only result, finished calling
        (exhaust gas %0 `[all-diffs ~ all-burns all-events])
      =.  p.chain
        %+  dif:big
          %+  uni:big  p.chain
          all-diffs
        burned.diff
      ::  run continuation calls
      =/  inter=output
        %=    ^$
            p.chain
          %+  dif:big
            %+  uni:big  p.chain
            all-diffs
          burned.diff
        ::
            tx
          %=  tx
            bud.gas         gas
            address.caller  contract.tx
            contract        contract.i.calls
            calldata        calldata.i.calls
          ==
        ==
      ::
      ?.  ?=(%0 errorcode.inter)
        (exhaust gas.inter errorcode.inter ~)
      %=  $
        calls       t.calls
        gas         gas.inter
        all-diffs   modified.inter
        all-burns   burned.inter
        all-events  (weld all-events events.inter)
      ==
    ::
    ++  exhaust
      |=  [gas=@ud =errorcode:smart dif=(unit diff:smart)]
      ^-  output
      ::  output returns amount of gas *spent*
      :+  (sub bud.gas.tx gas)
        errorcode
      ?~  dif  [~ ~ ~]
      :+  (uni:big changed.u.dif issued.u.dif)
        burned.u.dif
      events.u.dif
    ::
    ++  combust
      |=  [code=[bat=* pay=*] =context:smart =calldata:smart bud=@ud]
      ^-  [(unit move) gas=@ud =errorcode:smart]
      ~>  %bout
      |^
      ~&  >  "context: {<context>}"
      ~&  >>  "calldata: {<calldata>}"
      =/  dor=vase  (load code)
      =/  gun  (ajar dor %write !>(context) !>(calldata) %$)
      ::  generate ZK-proof hints with zebra
      ::
      =/  =book:zink
        (zebra:zink bud zink-cax search gun hints-on)
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
      ::  +search: scry available inside contract runner
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
          ?~  item=(get:big p.chain item-id)
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
          ?~  item=(get:big p.chain contract-id)
            ~&  >>>  "didn't find it"  rem^~
          ?.  ?=(%| -.u.item)
            ~&  >>>  "wasn't a pact"  rem^~
          =/  dor=vase  (load code.p.u.item)
          =/  gun
            (ajar dor %read !>(context(this contract-id)) !>(read-pith) kind)
          =/  =book:zink  (zebra:zink rem zink-cax search gun hints-on)
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
    ::
    ::  +load: take contract code and combine with smart-lib
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
    ::  +clean: validate a diff
    ::
    ++  clean
      |=  [=diff:smart source=id:smart caller-zigs=id:smart]
      ^-  ?
      ?&
        %-  ~(all in changed.diff)
        |=  [=id:smart @ =item:smart]
        ::  all changed items must already exist AND
        ::  new item must be same type as old item AND
        ::  id in changed map must be equal to id in item AND
        ::  if data, salt must not change AND
        ::  only items that proclaim us source may be changed
        =/  old  (get:big p.chain id)
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
            !(has:big p.chain id.p.item)
            ?:  ?=(%| -.item)
              .=  id
              (hash-pact:smart source holder.p.item town.p.item code.p.item)
            .=  id
            (hash-data:smart source holder.p.item town.p.item salt.p.item)
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
        =/  old  (get:big p.chain id)
        ?&  ?=(^ old)
            =(id id.p.item)
            !(has:big changed.diff id)
            =(source.p.item source.p.u.old)
            =(source source.p.u.old)
            !=(caller-zigs id)
        ==
      ==
    --
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
      |=  tx=transaction:smart
      ^-  ?
      ?~  zigs=(get:big state zigs.caller.tx)        %.n
      ?.  =(address.caller.tx holder.p.u.zigs)       %.n
      ?.  =(zigs-contract-id:smart source.p.u.zigs)  %.n
      ?.  ?=(%& -.u.zigs)                            %.n
      %+  gte  ;;(@ud -.noun.p.u.zigs)
      (mul bud.gas.tx rate.gas.tx)
    ::  +charge: extract gas fee from caller's zigs balance
    ::  cannot crash after audit, as long as zigs contract
    ::  adequately validates balance >= budget+amount.
    ++  charge
      |=  [payee=caller:smart fee=@ud]
      ^-  ^state
      ?:  =(0 fee)  state
      =/  zigs=item:smart  (got:big state zigs.payee)
      ?>  ?=(%& -.zigs)
      =/  balance  ;;(@ud -.noun.p.zigs)
      %+  put:big  state
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
        =/  =id:smart
          (hash-data:smart zigs-contract-id:smart address.sequencer town-id `@`'zigs')
        [%& id zigs-contract-id:smart address.sequencer town-id 'zigs' %account token-account]
      ?.  ?=(%& -.acc)  state
      =/  account  ;;(token-account noun.p.acc)
      ?.  =(`@ux`'zigs-metadata' metadata.account)  state
      =.  balance.account  (add balance.account total)
      =.  noun.p.acc  account
      (put:big state id.p.acc acc)
    --
  --
::
::  +sort-mempool: function used by sequencer to order transactions
::  <put your MEV here?>
::
++  sort-mempool
  |=  =mempool
  ^-  memlist
  %+  sort  ~(tap in mempool)
  |=  [a=[@ux txn=transaction:smart] b=[@ux txn=transaction:smart]]
  ?:  =(address.caller.txn.a address.caller.txn.b)
    (lth nonce.caller.txn.a nonce.caller.txn.b)
  (gth rate.gas.txn.a rate.gas.txn.b)
::
::  utilities
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
--