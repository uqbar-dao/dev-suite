/-  *zig-engine
/+  smart=zig-sys-smart, zink=zink-zink, ethereum
|_  [library=vase zink-cax=(map * @) sigs-on=? hints-on=?]
::
::  engine
::
++  engine
  |_  [sequencer=caller:smart shard-id=@ux batch=@ud eth-block-height=@ud]
  ::
  ::  +run: produce a state transition for a given shard and mempool
  ::
  ++  run
    |=  [=chain =mempool passes=@ud]
    ^-  state-transition
    ::  declare initial values
    =/  pending=memlist  (sort-mempool mempool)
    =|  =state-transition
    =.  chain.state-transition chain
    |-
    ?~  pending
      ::  finished execution, return
      state-transition
    ::  execute a single transaction and integrate the diff
    =/  s=single-result  (run-single i.pending)

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