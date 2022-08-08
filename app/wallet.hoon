::  wallet [UQ| DAO]
::
::  UQ| wallet agent. Stores private key and facilitates signing
::  transactions, holding nonce values, and keeping track of owned data.
::
/-  ui=indexer
/+  *wallet-util, wallet-parsing, uqbar, ethereum, default-agent, dbug, verb, bip32, bip39
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
      ::  signatures tracks any signed calls we've made but not submitted
      signatures=(list [=typed-message:smart =sig:smart])
      ::  tokens tracked for each address we're handling
      tokens=(map address:smart =book)
      ::  metadata for tokens we track
      =metadata-store
      ::  transactions we've sent and received
      =transaction-store
      ::  a single transaction that we've sent to a sequencer but not recieved the receipt for
      pending=(unit [yolk-hash=@ =egg:smart args=supported-args])
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
    ~[[%give %fact ~ %zig-wallet-update !>([%new-book tokens.state])]]
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
      ::  keep any addresses not generated by our hot wallet, ie imported HW addresses
      =+  %-  ~(gas by *(map @ux [(unit @ux) @t]))
          %+  murn  ~(tap by keys.state)
          |=  [pub=@ux [priv=(unit @ux) nick=@t]]
          ?^  priv  ~
          `[pub [~ nick]]
      :-  %+  weld  (clear-all-holder-and-id-subs wex.bowl)
          %+  create-holder-and-id-subs
            ~(key by (~(put by -) addr [`private-key:core nick.act]))
          our.bowl
      ::  clear all existing state, except for public keys imported from HW wallets
      ::  TODO save nonces/tokens from HW wallets too
      ::  for now treat %import-seed as a nuke of the wallet
      %=  state
        nonces             ~
        signatures         ~
        tokens             ~
        metadata-store     ~
        transaction-store  ~
        seed  [mnemonic.act password.act 0]
        keys  (~(put by -) addr [`private-key:core nick.act])
      ==
    ::
        %generate-hot-wallet
      ::  will lose seed in current wallet, should warn on frontend!
      ::  creates a new wallet from entropy derived on-urbit
      =+  mnem=(from-entropy:bip39 [32 eny.bowl])
      =+  core=(from-seed:bip32 [64 (to-seed:bip39 mnem (trip password.act))])
      =+  addr=(address-from-prv:key:ethereum private-key:core)
      ::  keep any addresses not generated by our hot wallet, ie imported HW addresses
      =+  %-  ~(gas by *(map @ux [(unit @ux) @t]))
          %+  murn  ~(tap by keys.state)
          |=  [pub=@ux [priv=(unit @ux) nick=@t]]
          ?^  priv  ~
          `[pub [~ nick]]
      :-  %+  weld  (clear-all-holder-and-id-subs wex.bowl)
          %+  create-holder-and-id-subs
            ~(key by (~(put by -) addr [`private-key:core nick.act]))
          our.bowl
      ::  clear all existing state, except for public keys imported from HW wallets
      ::  TODO save nonces/tokens from HW wallets too
      ::  for now treat %import-seed as a nuke of the wallet
      %=  state
        nonces             ~
        signatures         ~
        tokens             ~
        metadata-store     ~
        transaction-store  ~
        seed  [(crip mnem) password.act 0]
        keys  (~(put by -) addr [`private-key:core nick.act])
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
      :-  (create-holder-and-id-subs (silt ~[addr]) our.bowl)
      %=  state
        seed  seed(address-index +(address-index.seed))
        keys  (~(put by keys) addr [`prv:core nick.act])
      ==
    ::
        %add-tracked-address
      :-  (create-holder-and-id-subs (silt ~[address.act]) our.bowl)
      state(keys (~(put by keys) address.act [~ nick.act]))
    ::
        %delete-address
      ::  can recover by re-deriving same path
      :-  (clear-holder-and-id-sub address.act wex.bowl)
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
      =+  acc=(~(got by nonces.state) address.act)
      `state(nonces (~(put by nonces) address.act (~(put by acc) town.act new.act)))
    ::
        %submit-signed
      ::  TODO refactor
      ?~  pending.state  !!
      =*  p  u.pending.state
      ?>  =(hash.act yolk-hash.p)
      =:  sig.egg.p  sig.act
          eth-hash.shell.egg.p  `eth-hash.act
      ==
      =*  from   id.from.shell.egg.p
      =*  nonce  nonce.from.shell.egg.p
      =+  hash=(hash-egg [shell yolk]:egg.p)
      =/  our-txs
        ?~  o=(~(get by transaction-store) from)
          [(malt ~[[hash [egg.p args.p]]]) ~]
        u.o(sent (~(put by sent.u.o) hash [egg.p args.p]))
      ~&  >>  "%wallet: submitting self-signed tx"
      ~&  >>  "with eth-hash {<eth-hash.act>}"
      ~&  >>  "with signature {<v.sig.act^r.sig.act^s.sig.act>}"
      :_  %=  state
            pending  ~
            transaction-store  (~(put by transaction-store) from our-txs)
          ==
      :~  (tx-update-card hash egg.p `args.p)
          :*  %pass  /submit-tx/(scot %ux hash)
              %agent  [our.bowl %uqbar]
              %poke  %uqbar-write
              !>(`write:uqbar`[%submit egg.p])
          ==
      ==
    ::
        %submit-custom
      ::  submit a transaction, with frontend-defined everything
      =/  our-nonces     (~(gut by nonces.state) from.act ~)
      =/  nonce=@ud      (~(gut by our-nonces) town.act 0)
      =/  =caller:smart
        :+  from.act  +(nonce)
        ::  generate our zigs token account ID
        (fry-rice:smart zigs-wheat-id:smart from.act town.act `@`'zigs')
      =+  q:(slap !>(+:(cue q.q.smart-lib)) (ream yolk.act))
      =/  =yolk:smart  [;;(@tas -.-) +.-]
      =/  keypair  (~(got by keys.state) from.act)
      =/  =shell:smart
        :*  caller
            ~
            to.act
            rate.gas.act
            bud.gas.act
            town.act
            status=%100
        ==
      =/  hash  (hash-egg shell yolk)
      =/  =sig:smart
        ?~  priv.keypair
          [0 0 0]
        %+  ecdsa-raw-sign:secp256k1:secp:crypto
        `@uvI`hash  u.priv.keypair
      =/  =egg:smart  [sig shell yolk]
      =/  formed=supported-args
        [%custom yolk.act]
      ?~  priv.keypair
        ::  if we don't have private key for this address, set as pending
        ::  and allow frontend to sign with HW wallet or otherwise
        ~&  >>  "%wallet: storing unsigned tx"
        `state(pending `[hash egg formed])
      ::  if we have key, use signature and submit
      =/  our-txs
        ?~  o=(~(get by transaction-store) from.act)
          [(malt ~[[hash [egg formed]]]) ~]
        u.o(sent (~(put by sent.u.o) hash [egg formed]))
      ~&  >>  "%wallet: submitting tx"
      :_  %=  state
            transaction-store  (~(put by transaction-store) from.act our-txs)
            nonces  (~(put by nonces) from.act (~(put by our-nonces) town.act +(nonce)))
          ==
      :~  (tx-update-card hash egg `formed)
          :*  %pass  /submit-tx/(scot %ux from.act)/(scot %ux hash)
              %agent  [our.bowl %uqbar]
              %poke  %uqbar-write
              !>(`write:uqbar`[%submit egg])
          ==
      ==
    ::
        %submit
      ::  submit a transaction
      ::  create an egg and sign it, then poke a sequencer
      ::
      ?:  ?=(%custom -.args.act)
        ~|("%wallet: error: %submit must use known argument pattern" !!)
      =/  our-nonces     (~(gut by nonces.state) from.act ~)
      =/  nonce=@ud      (~(gut by our-nonces) town.act 0)
      =/  =caller:smart
        :+  from.act  +(nonce)
        ::  generate our zigs token account ID
        (fry-rice:smart zigs-wheat-id:smart from.act town.act `@`'zigs')
      ::  generate yolk based on supported-args
      ::
      =/  =yolk:smart
        =/  from=asset
          %.  account.args.act
          ~(got by `book`(~(got by tokens.state) from.act))
        ::
        ?<  ?=(%unknown -.from)
        =/  =asset-metadata
          (~(got by metadata-store.state) metadata.from)
        =/  to-id
          (fry-rice:smart zigs-wheat-id:smart to.args.act town.act salt.asset-metadata)
        =/  exists
          =-  ?~(- ~ `to-id)
          .^((unit grain:smart) %gx /(scot %p our.bowl)/uqbar/(scot %da now.bowl)/grain/(scot %ux town.act)/(scot %ux to-id)/noun)
        ::  this switch statement written verbosely in order to
        ::  easily support new formats of arguments in future.
        ?-    -.args.act
            %give
          [%give to.args.act amount.args.act account.args.act -]
        ::
            %give-nft
          [%give to.args.act item-id.args.act account.args.act -]
        ==
      ::
      =/  keypair  (~(got by keys.state) from.act)
      =/  =shell:smart
        :*  caller
            ~
            to.act
            rate.gas.act
            bud.gas.act
            town.act
            status=%100
        ==
      =/  hash  (hash-egg shell yolk)
      =/  =sig:smart
        ?~  priv.keypair
          [0 0 0]
        %+  ecdsa-raw-sign:secp256k1:secp:crypto
        `@uvI`hash  u.priv.keypair
      =/  =egg:smart  [sig shell yolk]
      ?~  priv.keypair
        ::  if we don't have private key for this address, set as pending
        ::  and allow frontend to sign with HW wallet or otherwise
        ~&  >>  "%wallet: storing unsigned tx"
        `state(pending `[hash egg args.act])
      ::  if we have key, use signature and submit
      =/  our-txs
        ?~  o=(~(get by transaction-store) from.act)
          [(malt ~[[hash [egg args.act]]]) ~]
        u.o(sent (~(put by sent.u.o) hash [egg args.act]))
      ~&  >>  "%wallet: submitting tx"
      :_  %=  state
            transaction-store  (~(put by transaction-store) from.act our-txs)
            nonces  (~(put by nonces) from.act (~(put by our-nonces) town.act +(nonce)))
          ==
      :~  (tx-update-card hash egg `args.act)
          :*  %pass  /submit-tx/(scot %ux from.act)/(scot %ux hash)
              %agent  [our.bowl %uqbar]
              %poke  %uqbar-write
              !>(`write:uqbar`[%submit egg])
          ==
      ==
    ==
  --
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
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
      :-  ~[(tx-update-card hash egg.this-tx `args.this-tx)]
      %=    this
          transaction-store
        %-  ~(put by transaction-store)
        [from our-txs(sent (~(put by sent.our-txs) hash this-tx))]
      ::
          nonces
        ?:  =(status.shell.egg.this-tx %101)
          nonces
        ::  dec nonce on this town, tx was rejected
        (~(put by nonces) from (~(jab by (~(got by nonces) from)) town-id.shell.egg.this-tx |=(n=@ud (dec n))))
      ==
    `this
  ::
      ?([%holder @ ~] [%holder @ @ ~])
    ?:  ?=(%watch-ack -.sign)  (on-agent:def wire sign)
    ?.  ?=(%fact -.sign)       (on-agent:def wire sign)
    ?.  ?=(%indexer-update p.cage.sign)  (on-agent:def wire sign)
    =+  pub=?:(?=([@ @ ~] wire) (slav %ux i.t.wire) (slav %ux i.t.t.wire))
    =/  =update:ui  !<(update:ui q.cage.sign)
    ~&  >>  "WALLET: got our holder update"
    =/  old-book=book  (~(gut by tokens.state) pub ~)
    =/  new-book=book
      (indexer-update-to-books update pub metadata-store.state)
    =+  %+  ~(put by tokens.state)  pub
        (~(uni by old-book) new-book)
    :-  ~[[%give %fact ~[/book-updates] %zig-wallet-update !>([%new-book -])]]
    %=  this
      tokens  -
      ::
        metadata-store
      (update-metadata-store new-book our.bowl metadata-store.state [our now]:bowl)
    ==
  ::
      ?([%id @ ~] [%id @ @ ~])
    ::  update to a transaction from a tracked account
    ?:  ?=(%watch-ack -.sign)  (on-agent:def wire sign)
    ?.  ?=(%fact -.sign)       (on-agent:def wire sign)
    ?.  ?=(%indexer-update p.cage.sign)  (on-agent:def wire sign)
    =/  =update:ui  !<(=update:ui q.cage.sign)
    ?.  ?=(%egg -.update)  `this
    ~&  >>  "WALLET: got our egg update"
    ::  todo make status update work
    =/  our-id=@ux  ?:(?=([@ @ ~] wire) (slav %ux i.t.wire) (slav %ux i.t.t.wire))
    =+  our-txs=(~(gut by transaction-store.state) our-id [sent=~ received=~])
    =/  eggs=(list [@ux =egg:smart])
      %+  turn  ~(val by eggs.update)
      |=  [@da =egg-location:ui =egg:smart]
      [(hash-egg [shell yolk]:egg) egg]
    =^  tx-status-cards=(list card)  our-txs
      %^  spin  eggs  our-txs
      |=  [[hash=@ux =egg:smart] _our-txs]
      ::  update status code and send to frontend
      ::  following error code spec in smart.hoon
      ^-  [card _our-txs]
      :-  ?~  this-tx=(~(get by sent.our-txs) hash)
            (tx-update-card hash egg ~)
          (tx-update-card hash egg `args.u.this-tx)
      %=    our-txs
          sent
        ?.  (~(has by sent.our-txs) hash)  sent
        %+  ~(jab by sent.our-txs)  hash
        |=([p=egg:smart q=supported-args] [p(status.shell status.shell.egg) q])
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
  ?+    +.path  (on-peek:def path)
      [%seed ~]
    =;  =json  ``json+!>(json)
    =,  enjs:format
    %-  pairs
    :~  ['mnemonic' [%s mnem.seed.state]]
        ['password' [%s pass.seed.state]]
    ==
  ::
      [%accounts ~]
    =;  =json  ``json+!>(json)
    =,  enjs:format
    %-  pairs
    %+  turn  ~(tap by keys.state)
    |=  [pub=@ux [priv=(unit @ux) nick=@t]]
    :-  (scot %ux pub)
    %-  pairs
    :~  ['pubkey' [%s (scot %ux pub)]]
        ['privkey' ?~(priv [%s ''] [%s (scot %ux u.priv)])]
        ['nick' [%s nick]]
        :-  'nonces'
        %-  pairs
        %+  turn  ~(tap by (~(gut by nonces.state) pub ~))
        |=  [town=@ux nonce=@ud]
        [(scot %ux town) (numb nonce)]
    ==
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
    ::  return entire book map for wallet frontend
    =;  =json  ``json+!>(json)
    =,  enjs:format
    %-  pairs
    %+  turn  ~(tap by tokens.state)
    |=  [pub=@ux =book]
    :-  (scot %ux pub)
    %-  pairs
    %+  turn  ~(tap by book)
    |=  [=id:smart =asset]
    (parse-asset:wallet-parsing id asset)
  ::
      [%token-metadata ~]
    ::  return entire metadata-store
    =;  =json  ``json+!>(json)
    =,  enjs:format
    %-  pairs
    %+  turn  ~(tap by metadata-store.state)
    |=  [=id:smart d=asset-metadata]
    :-  (scot %ud id)
    %-  pairs
    :~  ['name' [%s name.d]]
        ['symbol' [%s symbol.d]]
        ?-  -.d
          %token  ['decimals' (numb decimals.d)]
          %nft  ['attributes' [%s 'TODO...']]
        ==
        ['supply' (numb supply.d)]
        ['cap' (numb (fall cap.d 0))]
        ['mintable' [%b mintable.d]]
        ['deployer' [%s (scot %ux deployer.d)]]
        ['salt' [%s (scot %ux salt.d)]]
    ==
  ::
      [%transactions @ ~]
    ::  return transaction store for given pubkey
    =/  pub  (slav %ux i.t.t.path)
    =/  our-txs=[sent=(map @ux [=egg:smart args=supported-args]) received=(map @ux =egg:smart)]
      (~(gut by transaction-store.state) pub [~ ~])
    =;  =json  ``json+!>(json)
    =,  enjs:format
    %-  pairs
    %+  weld
      %+  turn  ~(tap by sent.our-txs)
      |=  [hash=@ux [t=egg:smart args=supported-args]]
      (parse-transaction:wallet-parsing hash t `args)
    %+  turn  ~(tap by received.our-txs)
    |=  [hash=@ux t=egg:smart]
    (parse-transaction:wallet-parsing hash t ~)
  ::
      [%signatures ~]
    ``noun+!>(signatures.state)
  ::
      [%pending ~]
    ?~  pending.state  [~ ~]
    =*  p  u.pending.state
    =;  =json  ``json+!>(json)
    =,  enjs:format
    %-  pairs
    :~  ['hash' [%s (scot %ux yolk-hash.p)]]
        ['egg' +:(parse-transaction:wallet-parsing 0x0 egg.p `args.p)]
    ==
  ==
::
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--