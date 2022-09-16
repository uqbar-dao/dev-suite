::  wallet [UQ| DAO]
::
::  UQ| wallet agent. Stores private key and facilitates signing
::  transactions, holding nonce values, and keeping track of owned data.
::
/-  ui=indexer
/+  *wallet-util, wallet-parsing, uqbar, ethereum, zink=zink-zink,
    default-agent, dbug, verb, bip32, bip39, ui-lib=indexer
/*  smart-lib  %noun  /lib/zig/compiled/smart-lib/noun
|%
+$  card  card:agent:gall
+$  state-0
  $:  %0
      ::  wallet holds a single seed at once
      ::  address-index notes where we are in derivation path
      seed=[mnem=@t pass=@t address-index=@ud]
      ::  many keys can be derived or imported
      ::  if the private key is ~, that means it's a hardware wallet import
      keys=(map address:smart [priv=(unit @ux) nick=@t])
      ::  we track the nonce of each address we're handling
      ::  TODO: introduce a poke to check nonce from chain and re-align
      nonces=(map address:smart (map town=@ux nonce=@ud))
      ::  signatures tracks any signed calls we've made
      signatures=(list [=typed-message:smart =sig:smart])
      ::  tokens tracked for each address we're handling
      tokens=(map address:smart =book)
      ::  metadata for tokens we track
      =metadata-store
      ::  transactions we've sent and received
      =transaction-store
      ::  transactions we've been asked to sign, keyed by hash
      =pending-store
  ==
--
::
=|  state-0
=*  state  -
::
%-  agent:dbug
%+  verb  |
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
::
++  on-init  `this(state [%0 ['' '' 0] ~ ~ ~ ~ ~ ~ ~])
::
++  on-save  !>(state)
++  on-load
  |=  =old=vase
  ^-  (quip card _this)
  =/  old-state  !<(state-0 old-vase)
  `this(state old-state)
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  !!
      [%book-updates ~]
    ?>  =(src.bowl our.bowl)
    ::  send frontend updates along this path
    :_  this
    =-  ~[[%give %fact ~ %zig-wallet-update -]]
    !>(`wallet-update`[%new-book tokens.state])
  ::
      [%metadata-updates ~]
    ?>  =(src.bowl our.bowl)
    ::  send frontend updates along this path
    :_  this
    =-  ~[[%give %fact ~ %zig-wallet-update -]]
    !>(`wallet-update`[%new-metadata metadata-store.state])
  ::
      [%tx-updates ~]
    ?>  =(src.bowl our.bowl)
    ::  provide updates about submitted transactions
    ::  any local app can watch this to send things through
    `this
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^
  ?+    mark  !!
      %zig-wallet-poke
    =^  cards  state
      (poke-wallet !<(wallet-poke vase))
    [cards this]
  ==
  ::
  ++  poke-wallet
    |=  act=wallet-poke
    ^-  (quip card _state)
    ?>  =(src.bowl our.bowl)
    ?-    -.act
        %import-seed
      ::  will lose seed in current wallet, should warn on frontend!
      ::  stores the default keypair in map
      ::  import takes in a seed phrase and password to encrypt with
      =+  seed=(to-seed:bip39 (trip mnemonic.act) (trip password.act))
      =+  core=(from-seed:bip32 [64 seed])
      =+  addr=(address-from-prv:key:ethereum private-key:core)
      ::  get txn history for this new address
      =/  sent  (get-sent-history addr [our now]:bowl)
      ::  sub to batch updates
      :-  (watch-for-batches our.bowl 0x0)  ::  TODO remove town-id hardcode
      ::  clear all existing state, except for public keys imported from HW wallets
      ::  TODO save nonces/tokens from HW wallets too
      ::  for now treat this as a nuke of the wallet
      %=  state
        nonces             ~
        signatures         ~
        tokens             ~
        metadata-store     ~
        pending-store      ~
        seed  [mnemonic.act password.act 0]
        transaction-store  [[addr [sent ~]] ~ ~]
        keys  (~(put by *_keys) addr [`private-key:core nick.act])
      ==
    ::
        %generate-hot-wallet
      ::  will lose seed in current wallet, should warn on frontend!
      ::  creates a new wallet from entropy derived on-urbit
      =+  mnem=(from-entropy:bip39 [32 eny.bowl])
      =+  core=(from-seed:bip32 [64 (to-seed:bip39 mnem (trip password.act))])
      =+  addr=(address-from-prv:key:ethereum private-key:core)
      ::  get txn history for this new address
      =/  sent  (get-sent-history addr [our now]:bowl)
      ::  sub to batch updates
      :-  (watch-for-batches our.bowl 0x0)  ::  TODO remove town-id hardcode
      ::  clear all existing state, except for public keys imported from HW wallets
      ::  TODO save nonces/tokens from HW wallets too
      ::  for now treat this as a nuke of the wallet
      %=  state
        nonces             ~
        signatures         ~
        tokens             ~
        metadata-store     ~
        pending-store      ~
        seed  [(crip mnem) password.act 0]
        transaction-store  [[addr [sent ~]] ~ ~]
        keys  (~(put by *_keys) addr [`private-key:core nick.act])
      ==
    ::
        %derive-new-address
      ::  if hdpath input is empty, use address-index+1 to get next
      =/  new-seed  (to-seed:bip39 (trip mnem.seed.state) (trip pass.seed.state))
      =/  core
        %-  derive-path:(from-seed:bip32 [64 new-seed])
        ?:  !=("" hdpath.act)  hdpath.act
        (weld "m/44'/60'/0'/0/" (scow %ud address-index.seed.state))
      =+  addr=(address-from-prv:key:ethereum prv:core)
      ::  get txn history for this new address
      =/  sent  (get-sent-history addr [our now]:bowl)
      :-  ~
      %=  state
        seed  seed(address-index +(address-index.seed))
        keys  (~(put by keys) addr [`prv:core nick.act])
        transaction-store  (~(put by transaction-store) addr [sent ~])
      ==
    ::
        %add-tracked-address
      ::  get txn history for this new address
      =/  sent  (get-sent-history address.act [our now]:bowl)
      :-  ~
      %=  state
        keys  (~(put by keys) address.act [~ nick.act])
        transaction-store  (~(put by transaction-store) address.act [sent ~])
      ==
    ::
        %delete-address
      ::  can recover by re-deriving same path
      :-  ~
      %=  state
        keys    (~(del by keys) address.act)
        nonces  (~(del by nonces) address.act)
        tokens  (~(del by tokens) address.act)
        transaction-store  (~(del by transaction-store) address.act)
      ==
    ::
        %edit-nickname
      =+  -:(~(got by keys.state) address.act)
      `state(keys (~(put by keys) address.act [- nick.act]))
    ::
        %sign-typed-message
      =/  keypair  (~(got by keys.state) from.act)
      =/  hash     (sham typed-message.act)
      =/  signature
        ?~  priv.keypair
          !!  ::  put it into some temporary thing for cold storage. Make it pending
        %+  ecdsa-raw-sign:secp256k1:secp:crypto
          hash
        u.priv.keypair
      `state(signatures [[typed-message.act signature] signatures])
    ::
        %set-nonce  ::  for testing/debugging
      =+  acc=(~(gut by nonces.state) address.act ~)
      `state(nonces (~(put by nonces) address.act (~(put by acc) town.act new.act)))
    ::
        %submit-signed
      ::  sign a pending transaction from an attached hardware wallet
      ~|  "%wallet: no pending transactions from that address"
      =/  my-pending  (~(got by pending-store) from.act)
      ?~  txn=(~(get by my-pending) hash.act)
        ~|("%wallet: can't find pending transaction with that hash" !!)
      =*  egg  egg.u.txn
      ::  get our nonce
      =/  our-nonces  (~(gut by nonces.state) from.act ~)
      =/  nonce=@ud   (~(gut by our-nonces) town-id.shell.egg 0)
      ::  update egg with sig, nonce, and gas
      =:  sig.egg               sig.act
          nonce.from.shell.egg  +(nonce)
          rate.shell.egg        rate.gas.act
          budget.shell.egg      bud.gas.act
          eth-hash.shell.egg    `eth-hash.act
          status.shell.egg      %101
      ==
      ::  update hash of egg with new values
      =/  hash  (hash-egg [shell yolk]:egg)
      ::  update our transaction-store
      =/  our-txns
        ?~  o=(~(get by transaction-store) from.act)
          [(malt ~[[hash [egg action.u.txn]]]) ~]
        u.o(sent (~(put by sent.u.o) hash [egg action.u.txn]))
      ~&  >>  "%wallet: submitting externally-signed txn"
      ~&  >>  "with signature {<v.sig.act^r.sig.act^s.sig.act>}"
      ::  update stores
      :_  %=    state
              pending-store
            (~(put by pending-store) from.act (~(del by my-pending) hash.act))
          ::
              transaction-store
            (~(put by transaction-store) from.act our-txns)
          ::
              nonces
            (~(put by nonces) from.act (~(put by our-nonces) town-id.shell.egg +(nonce)))
          ==
      :~  (tx-update-card hash egg action.u.txn)
          :*  %pass  /submit-tx/(scot %ux hash)
              %agent  [our.bowl %uqbar]
              %poke  %uqbar-write
              !>(`write:uqbar`[%submit egg])
          ==
      ==
    ::
        %submit
      ::  sign a pending transaction from this hot wallet
      ~|  "%wallet: no pending transactions from that address"
      =/  my-pending  (~(got by pending-store) from.act)
      ?~  txn=(~(get by my-pending) hash.act)
        ~|("%wallet: can't find pending transaction with that hash" !!)
      ?~  keypair=(~(get by keys.state) from.act)
        ~|("%wallet: don't have knowledge of that address" !!)
      =*  egg  egg.u.txn
      ::  get our nonce
      =/  our-nonces  (~(gut by nonces.state) from.act ~)
      =/  nonce=@ud   (~(gut by our-nonces) town-id.shell.egg 0)
      ::  update egg with sig, nonce, and gas
      =:  rate.shell.egg        rate.gas.act
          nonce.from.shell.egg  +(nonce)
          budget.shell.egg      bud.gas.act
          status.shell.egg      %101
      ==
      ::  update hash of egg with new values
      =/  hash  (hash-egg [shell yolk]:egg)
      ::  produce our signature
      =.  sig.egg
        ?~  priv.u.keypair
          ~|("%wallet: don't have private key for that address" !!)
        %+  ecdsa-raw-sign:secp256k1:secp:crypto
        `@uvI`hash  u.priv.u.keypair
      ::  update our transaction-store
      =/  our-txns
        ?~  o=(~(get by transaction-store) from.act)
          [(malt ~[[hash [egg action.u.txn]]]) ~]
        u.o(sent (~(put by sent.u.o) hash [egg action.u.txn]))
      ~&  >>  "%wallet: submitting signed txn"
      ~&  >>  "with signature {<v.sig.egg^r.sig.egg^s.sig.egg>}"
      ::  update stores
      :_  %=    state
              pending-store
            (~(put by pending-store) from.act (~(del by my-pending) hash.act))
          ::
              transaction-store
            (~(put by transaction-store) from.act our-txns)
          ::
              nonces
            (~(put by nonces) from.act (~(put by our-nonces) town-id.shell.egg +(nonce)))
          ==
      :~  (tx-update-card hash egg action.u.txn)
          :*  %pass  /submit-tx/(scot %ux hash)
              %agent  [our.bowl %uqbar]
              %poke  %uqbar-write
              !>(`write:uqbar`[%submit egg])
          ==
      ==
    ::
        %delete-pending
      ~|  "%wallet: no pending transactions from that address"
      =/  my-pending  (~(got by pending-store) from.act)
      ?~  txn=(~(get by my-pending) hash.act)
        ~|("%wallet: can't find pending transaction with that hash" !!)
      ::  remove without signing
      :-  ~
      %=    state
          pending-store
        (~(put by pending-store) from.act (~(del by my-pending) hash.act))
      ==
    ::
        %transaction
      ::  take in a new pending transaction
      =/  =caller:smart
        :+  from.act
          0  ::  we fill in *correct* nonce upon submission
        ::  generate our zigs token account ID
        (fry-rice:smart zigs-wheat-id:smart from.act town.act `@`'zigs')
      ::  build yolk of transaction, depending on argument type
      =/  =yolk:smart
        ?-    -.action.act
            %give
          ::  Standard fungible token %give
          =/  from=asset  (~(got by `book`(~(got by tokens.state) from.act)) grain.action.act)
          ?>  ?=(%token -.from)
          =/  =asset-metadata  (~(got by metadata-store.state) metadata.from)
          =/  to-id  (fry-rice:smart zigs-wheat-id:smart to.action.act town.act salt.asset-metadata)
          =/  scry-res
            .^  update:ui  %gx
                /(scot %p our.bowl)/uqbar/(scot %da now.bowl)/indexer/newest/grain/(scot %ux town.act)/(scot %ux to-id)/noun
            ==
          =+  ?~  scry-res  ~
              ?.  ?=(%newest-grain -.scry-res)  ~
              `grain.scry-res
          [%give to.action.act amount.action.act grain.action.act ?~(- ~ `to-id)]
        ::
            %give-nft
          ::  Standard NFT %give
          [%give to.action.act grain.action.act]
        ::
            %text
          =/  smart-lib-vase  ;;(^vase (cue +.+:;;([* * @] smart-lib)))
          =/  data-hoon  (ream ;;(@t +.action.act))
          =+  gun=(~(mint ut p.smart-lib-vase) %noun data-hoon)
          =/  res=book:zink
            (zebra:zink 200.000 ~ *granary-scry:zink [q.smart-lib-vase q.gun] %.y)
          ?.  ?=(%& -.p.res)
            ~|("wallet: failed to compile custom action!" !!)
          =+  noun=(need p.p.res)
          [;;(@tas -.noun) +.noun]
        ::
            %noun
          ;;(yolk:smart +.action.act)
        ==
      ::  build *incomplete* shell of transaction
      =/  =shell:smart
        :*  caller
            eth-hash=~
            to=contract.act
            rate=0
            budget=0
            town.act
            status=%100
        ==
      ::  generate hash
      =/  hash  (hash-egg shell yolk)
      =/  =egg:smart  [[0 0 0] shell yolk]
      ~&  >>  "%wallet: transaction pending with hash {<hash>}"
      ::  add to our pending-store with empty signature
      =/  my-pending
        %+  ~(put by (~(gut by pending-store) from.act ~))
        hash  [egg action.act]
      :-  (tx-update-card hash egg action.act)^~
      %=  state
        pending-store  (~(put by pending-store) from.act my-pending)
      ==
    ==
  --
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [%new-batch ~]
    ?:  ?=(%kick -.sign)
      :_  this  ::  attempt to re-sub
      (watch-for-batches our.bowl 0x0)
    ?:  ?=(%watch-ack -.sign)  (on-agent:def wire sign)
    ?.  ?=(%fact -.sign)       (on-agent:def wire sign)
    ::  new batch -- scry to indexer for latest tokens and nfts held
    =/  addrs=(list address:smart)  ~(tap in ~(key by keys))
    =/  new-tokens
      (make-tokens addrs [our now]:bowl)
    =/  new-metadata
      (update-metadata-store new-tokens metadata-store [our now]:bowl)
    :_  this(tokens new-tokens, metadata-store new-metadata)
    :~  [%give %fact ~[/book-updates] %zig-wallet-update !>(`wallet-update`[%new-book new-tokens])]
        [%give %fact ~[/metadata-updates] %zig-wallet-update !>(`wallet-update`[%new-metadata new-metadata])]
    ==
  ::
      [%submit-tx @ @ ~]
    ::  check to see if our tx was received by sequencer
    =/  from=@ux  (slav %ux i.t.wire)
    =/  hash=@ux  (slav %ux i.t.t.wire)
    ?:  ?=(%poke-ack -.sign)
      =/  our-txs  (~(got by transaction-store) from)
      =/  this-tx  (~(got by sent.our-txs) hash)
      =.  this-tx
        ?~  p.sign
          ::  got it
          ~&  >>  "wallet: tx was received by sequencer"
          this-tx(status.shell.egg %101)
        ::  failed
        ~&  >>>  "wallet: tx was rejected by sequencer"
        this-tx(status.shell.egg %103)
      :-  ~[(tx-update-card hash egg.this-tx action.this-tx)]
      %=    this
          transaction-store
        %-  ~(put by transaction-store)
        [from our-txs(sent (~(put by sent.our-txs) hash this-tx))]
      ::
          nonces
        ?:  =(status.shell.egg.this-tx %101)
          nonces
        ::  dec nonce on this town, tx was rejected
        %+  ~(put by nonces)  from
        %+  ~(jab by (~(got by nonces) from))
          town-id.shell.egg.this-tx
        |=(n=@ud (dec n))
      ==
    `this
  ::
      ?([%indexer %wallet %id @ ~] [%indexer %wallet %id @ @ ~])
    ::  update to a transaction from a tracked account
    ?:  ?=(%watch-ack -.sign)  (on-agent:def wire sign)
    ?.  ?=(%fact -.sign)       (on-agent:def wire sign)
    ?.  ?=(%indexer-update p.cage.sign)  (on-agent:def wire sign)
    =/  =update:ui  !<(=update:ui q.cage.sign)
    ?~  update             `this
    ?.  ?=(%egg -.update)  `this
    =/  our-id=@ux  ?:(?=([@ @ @ @ ~] wire) (slav %ux i.t.t.t.wire) (slav %ux i.t.t.t.t.wire))
    =+  our-txs=(~(gut by transaction-store.state) our-id [sent=~ received=~])
    =^  tx-status-cards=(list card)  our-txs
      %^  spin  ~(tap by eggs.update)  our-txs
      |=  [[hash=@ux [@da =egg-location:ui =egg:smart]] txs=_our-txs]
      ::  update status code and send to frontend
      ::  following error code spec in sur/wallet
      =/  status  (add 200 `@`status.shell.egg)
      ?>  ?=(transaction-status-code status)
      ^-  [card _our-txs]
      :-  ?~  this-tx=(~(get by sent.txs) hash)
            (tx-update-card hash egg [%noun (crip (noah !>(yolk.egg)))])
          (tx-update-card hash egg(status.shell status) action.u.this-tx)
      %=    txs
          sent
        ?.  (~(has by sent.txs) hash)  sent.txs
        %+  ~(jab by sent.txs)  hash
        |=  [p=egg:smart q=supported-actions]
        [p(status.shell status) q]
      ::
          ::  TODO update nonce for town if tx was rejected for bad nonce (code 3)
          ::  or for lack of budget (code 4)
      ==
    :-  tx-status-cards
    this(transaction-store (~(put by transaction-store) our-id our-txs))
  ==
::
++  on-arvo  on-arvo:def
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?.  =(%x -.path)  ~
  =,  format
  ?+    +.path  (on-peek:def path)
      [%seed ~]
    =;  =json  ``json+!>(json)
    %-  pairs:enjs
    :~  ['mnemonic' [%s mnem.seed.state]]
        ['password' [%s pass.seed.state]]
    ==
  ::
      [%accounts ~]
    =;  =json  ``json+!>(json)
    %-  pairs:enjs
    %+  turn  ~(tap by keys.state)
    |=  [pub=@ux [priv=(unit @ux) nick=@t]]
    :-  (scot %ux pub)
    %-  pairs:enjs
    :~  ['pubkey' [%s (scot %ux pub)]]
        ['privkey' ?~(priv [%s ''] [%s (scot %ux u.priv)])]
        ['nick' [%s nick]]
        :-  'nonces'
        %-  pairs:enjs
        %+  turn  ~(tap by (~(gut by nonces.state) pub ~))
        |=  [town=@ux nonce=@ud]
        [(scot %ux town) (numb:enjs nonce)]
    ==
  ::
      [%keys ~]
    ``noun+!>(~(key by keys.state))
  ::
      [%account @ @ ~]
    ::  returns our account for the pubkey and town-id given
    ::  for validator & sequencer use, to execute mill
    =/  pub  (slav %ux i.t.t.path)
    =/  town-id  (slav %ux i.t.t.t.path)
    =/  nonce  (~(gut by (~(gut by nonces.state) pub ~)) town-id 0)
    =+  (fry-rice:smart `@ux`'zigs-contract' pub town-id `@`'zigs')
    ``noun+!>(`caller:smart`[pub nonce -])
  ::
      [%book ~]
    =;  =json  ``json+!>(json)
    ::  return entire book map for wallet frontend
    %-  pairs:enjs
    %+  turn  ~(tap by tokens.state)
    |=  [pub=@ux =book]
    :-  (scot %ux pub)
    %-  pairs:enjs
    %+  turn  ~(tap by book)
    |=  [=id:smart =asset]
    (parse-asset:wallet-parsing id asset)
  ::
      [%token-metadata ~]
    =;  =json  ``json+!>(json)
    ::  return entire metadata-store
    %-  pairs:enjs
    %+  turn  ~(tap by metadata-store.state)
    |=  [=id:smart d=asset-metadata]
    (parse-metadata:wallet-parsing id d)
  ::
      [%transactions @ ~]
    ::  return transaction store for given pubkey
    =/  pub  (slav %ux i.t.t.path)
    =/  our-txs=[sent=(map @ux [egg:smart supported-actions]) received=(map @ux egg:smart)]
      (~(gut by transaction-store.state) pub [~ ~])
    ::
    =;  =json  ``json+!>(json)
    %-  pairs:enjs
    %+  turn  ~(tap by sent.our-txs)
    |=  [hash=@ux [t=egg:smart action=supported-actions]]
    (parse-transaction:wallet-parsing hash t action)
  ::
      [%signatures ~]
    ``noun+!>(signatures.state)
  ::
      [%pending @ ~]
    ::  return pending store for given pubkey
    =/  pub  (slav %ux i.t.t.path)
    =/  our=(map @ux [egg:smart supported-actions])
      (~(gut by pending-store) pub ~)
    ::
    =;  =json  ``json+!>(json)
    %-  pairs:enjs
    %+  turn  ~(tap by our)
    |=  [hash=@ux [t=egg:smart action=supported-actions]]
    (parse-transaction:wallet-parsing hash t action)
  ::
      [%pending-noun @ ~]
    ::  return pending store for given pubkey, noun format
    =/  pub  (slav %ux i.t.t.path)
    =/  our=(map @ux [egg:smart supported-actions])
      (~(gut by pending-store) pub ~)
    ::
    ``noun+!>(`(map @ux [egg:smart supported-actions])`our)
  ==
::
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--
