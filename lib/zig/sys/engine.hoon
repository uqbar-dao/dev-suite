/-  *zig-engine
/+  smart=zig-sys-smart, zink=zink-zink, ethereum
|_  [library=vase zink-cax=(map * @) sigs-on=? hints-on=?]
::
::  +engine: the execution engine for Uqbar.
::
++  engine
  |_  [sequencer=caller:smart town-id=@ux batch-num=@ud eth-block-height=@ud]
  ::
  ::  +run: produce a state transition for a given town and mempool
  ::
  ++  run
    |=  [=chain =mempool]
    ^-  state-transition
    =/  pending=memlist  (sort-mempool mempool)
    =|  st=state-transition
    =|  gas-reward=@ud
    =.  chain.st  chain
    |-
    ?~  pending
      ::  finished with execution:
      ::  pay accumulated gas to sequencer
      ?~  paid=(~(pay tax p.chain.st) gas-reward)
        st
      %=  st
        p.chain   (put:big p.chain.st u.paid)
        modified  (put:big modified.st u.paid)
      ==
    ::  execute a single transaction and integrate the diff
    =*  tx  tx.i.pending
    =/  =output  ~(intake eng chain.st tx)
    =/  priced-gas  (mul gas.output rate.gas.tx)
    =?  modified.output  (gth priced-gas 0)
      %+  put:big  modified.output
      %+  ~(charge tax p.chain.st)
        modified.output
      [caller.tx priced-gas]
    %=  $
      pending     t.pending
      gas-reward  (add gas-reward priced-gas)
        st
      %=    st
        modified  (uni:big modified.st modified.output)
        burned    (uni:big burned.st burned.output)
      ::
          processed
        :_  processed.st
        :+  hash.i.pending
          tx.i.pending(status errorcode.output)
        output
      ::
          chain
        :-  %+  dif:big
              (uni:big p.chain.st modified.output)
            burned.output
        ?:  ?=(?(%1 %2) errorcode.output)  q.chain.st
        (put:pig q.chain.st [address nonce]:caller.tx)
      ==
    ==
  ::
  ::  +eng: inner handler for processing each transaction
  ::  intake -> combust -> power -> exhaust
  ::
  ++  eng
    |_  [=chain tx=transaction:smart]
    +$  move  (quip call:smart diff:smart)
    ::
    ++  intake
      ^-  output
      ~>  %bout
      ?.  ?:(sigs-on (verify-sig tx) %.y)
        ~&  >>>  "engine: signature mismatch"
        (exhaust bud.gas.tx %1 ~)
      ?.  .=  nonce.caller.tx
          +((gut:pig q.chain address.caller.tx 0))
        ~&  >>>  "engine: nonce mismatch"
        (exhaust bud.gas.tx %2 ~)
      ?.  (~(audit tax p.chain) tx)
        ~&  >>>  "engine: tx failed gas audit"
        (exhaust bud.gas.tx %3 ~)
      ::
      =/  gas-payer  address.caller.tx
      |-  ::  recursion point for calls
      ::
      ?:  &(=(0x0 contract.tx) =(%burn p.calldata.tx))
        ::  special burn tx
        =/  fail  (exhaust bud.gas.tx %9 ~)
        ?.  ?=([id=@ux town=@ux] q.calldata.tx)         fail
        ?~  to-burn=(get:big p.chain id.q.calldata.tx)  fail
        ?.  ?|  =(source.p.u.to-burn address.caller.tx)
                =(holder.p.u.to-burn address.caller.tx)
            ==                                          fail
        ?:  =(id.p.u.to-burn zigs.caller.tx)            fail
        =-  (exhaust (sub bud.gas.tx 1.000) %0 `[~ - ~])
        (gas:big *state ~[id.p.u.to-burn^u.to-burn])
      ::  normal tx
      =?    q.calldata.tx
          ?&  =(contract.tx zigs-contract-id:smart)
              =(p.calldata.tx %give)
          ==
        ::  only assert budget check when gas-payer is interacting
        ?.  =(address.caller.tx gas-payer)
          [0 q.calldata.tx]
        [bud.gas.tx q.calldata.tx]
      ?~  pac=(get:big p.chain contract.tx)
        ~&  >>>  "engine: call to missing pact"
        (exhaust bud.gas.tx %4 ~)
      ?.  ?=(%| -.u.pac)
        ~&  >>>  "engine: call to data, not pact"
        (exhaust bud.gas.tx %5 ~)
      ::
      ::  build context for call,
      ::  call +combust to get move/hints/gas/error
      ::
      =/  =context:smart
        [contract.tx [- +<]:caller.tx batch-num eth-block-height town-id]
      =/  [mov=(unit move) gas-remaining=@ud =errorcode:smart]
        (combust code.p.u.pac context calldata.tx bud.gas.tx)
      ::
      ?~  mov  (exhaust gas-remaining errorcode ~)
      =*  calls  -.u.mov
      =*  diff   +.u.mov
      ?.  (clean diff contract.tx zigs.caller.tx)
        (exhaust gas-remaining %7 ~)
      =/  all-diffs   (uni:big changed.diff issued.diff)
      =/  all-burns   burned.diff
      =/  all-events=(list contract-event)
        %+  turn  events.diff
        |=  i=[@tas json]
        [contract.tx i]
      |-  ::  INNER loop for handling continuations
      ?~  calls
        ::  diff-only result, finished calling
        (exhaust gas-remaining %0 `[all-diffs all-burns all-events])
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
            bud.gas         gas-remaining
            address.caller  contract.tx
            contract        contract.i.calls
            calldata        calldata.i.calls
          ==
        ==
      ::
      ?.  ?=(%0 errorcode.inter)
        (exhaust (sub gas-remaining gas.inter) errorcode.inter ~)
      %=  $
        calls          t.calls
        gas-remaining  (sub gas-remaining gas.inter)
        all-diffs      (uni:big all-diffs modified.inter)
        all-burns      (uni:big all-burns burned.inter)
        all-events     (weld all-events events.inter)
      ==
    ::
    ::  +exhaust: prepare final diff for entire call, including all
    ::  subsequent calls created. subtract gas remaining from budget
    ::  to get total spend.
    ::
    ++  exhaust
      |=  $:  gas=@ud
              =errorcode:smart
              dif=(unit [=state =state e=(list contract-event)])
          ==
      ^-  output
      ~&  >  "gas cost: {<(sub bud.gas.tx gas)>}"
      :+  (sub bud.gas.tx gas)
        errorcode
      ?~  dif  [~ ~ ~]
      u.dif
    ::
    ::  +combust: prime contract code for execution, then run using
    ::  ZK-hint-generating virtualized interpreter +zebra. return
    ::  the diff and calls generated, if any, plus gas remaining and error
    ::
    ++  combust
      |=  [code=[bat=* pay=*] =context:smart =calldata:smart bud=@ud]
      ^-  [(unit move) gas=@ud =errorcode:smart]
      |^
      =/  dor=vase  (load code)
      =/  gun  (ajar dor %write !>(context) !>(calldata) %$)
      =/  =book:zink
        (zebra:zink bud zink-cax search gun !hints-on)
      ?:  ?=(%| -.p.book)
        ::  error in contract execution
        [~ gas.q.book %6]
      ?~  p.p.book
        ~&  >>>  "engine: ran out of gas"
        [~ 0 %8]
      ?~  m=((soft (unit move)) p.p.book)
        ::  error in contract execution
        [~ gas.q.book %6]
      ::  useful debug prints
      ::  ~&  "context: {<context>}"
      ::  ~&  >  "calldata: {<calldata>}"
      ::  ~&  >>  u.m
      [u.m gas.q.book %0]
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
            gas.q.book^~
          ?~  p.p.book
            ~&  >>>  "engine: ran out of gas inside read"
            gas.q.book^~
          gas.q.book^p.p.book
        ==
      --
    ::
    ::  +clean: validate a diff's changed, issued, and burned items
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
              (hash-pact:smart [source holder town code]:p.item)
            .=  id
            (hash-data:smart [source holder town salt]:p.item)
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
        ::  NOTE: you *can* modify an item in-contract before burning it.
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
  ::  +tax: manage payment for transactions in zigs
  ::
  ++  tax
    |_  =state
    ::  store a copy of the zigs account mold used in zigs.hoon
    +$  token-account
      $:  balance=@ud
          allowances=(pmap:smart sender=address:smart @ud)
          metadata=id:smart
          nonces=(pmap:smart taker=address:smart @ud)
      ==
    ::  +audit: evaluate whether a caller can afford gas
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
    ::  +charge: extract gas fee from caller's zigs balance.
    ::  cannot crash after audit, as long as zigs contract
    ::  adequately validates balance >= budget+amount.
    ++  charge
      |=  [modified=^state payee=caller:smart fee=@ud]
      ^-  [id:smart item:smart]
      ::  if zigs are in modified, use that, otherwise get from state
      =/  zigs=item:smart
        ?^  hav=(get:big modified zigs.payee)  u.hav
        (got:big state zigs.payee)
      ?>  ?=(%& -.zigs)
      =/  balance  ;;(@ud -.noun.p.zigs)
      =-  [zigs.payee zigs(noun.p -)]
      [(sub balance fee) +.noun.p.zigs]
    ::  +pay: give fees from transactions to sequencer
    ++  pay
      |=  total=@ud
      ^-  (unit [id.smart item:smart])
      ?:  =(0 total)  ~
      ::  if sequencer doesn't have zigs account, make one for them
      ?~  acc=(get:big state zigs.sequencer)
        =*  zc  zigs-contract-id:smart
        =/  =id:smart
          %-  hash-data:smart
          [zc address.sequencer town-id `@`'zigs']
        :-  ~  :-  id
        =+  [total ~ `@ux`'zigs-metadata' ~]
        [%& id zc address.sequencer town-id `@`'zigs' %account -]
      ?.  ?=(%& -.u.acc)  ~
      =/  account  ;;(token-account noun.p.u.acc)
      ?.  =(`@ux`'zigs-metadata' metadata.account)  ~
      =.  balance.account  (add balance.account total)
      =.  noun.p.u.acc  account
      `[id.p.u.acc u.acc]
    --
  --
::
::  +sort-mempool: order transactions by gas rate, and transactions
::  from same caller by nonce
::
++  sort-mempool
  |=  =mempool
  ^-  memlist
  %+  sort  ~(tap in mempool)
  |=  [a=[@ux tx=transaction:smart] b=[@ux tx=transaction:smart]]
  ?:  =(address.caller.tx.a address.caller.tx.b)
    (lth nonce.caller.tx.a nonce.caller.tx.b)
  (gth rate.gas.tx.a rate.gas.tx.b)
::
::  utilities
::
++  verify-sig
  |=  tx=transaction:smart
  ^-  ?
  =/  hash=@
    ?~  eth-hash.tx
      (sham +.tx)
    u.eth-hash.tx
  =?  v.sig.tx  (gte v.sig.tx 27)  (sub v.sig.tx 27)
  .=  address.caller.tx
  %-  address-from-pub:key:ethereum
  %-  serialize-point:secp256k1:secp:crypto
  %+  ecdsa-raw-recover:secp256k1:secp:crypto
  hash  sig.tx
::
::  +ajar: partial shut. builds nock to call inner arm of door with sample,
::  without executing the formula. used to feed computation into zebra
::
++  ajar
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
::  +shut: slam arm in door with sample. only shown for reference,
::  not used in engine.
::  TODO: figure out where to move this, still useful elsewhere
::
++  shut
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
--