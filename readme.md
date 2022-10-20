# Ziggurat

Ziggurat is the Uqbar developer suite.
It contains code for the Gall apps required to simulate the ZK rollup to Ethereum, to sequence transactions in order to run a shard, and the user application suite: the `%wallet` for chain writes, the `%indexer` for chain reads, and `%uqbar`, a unified read-write interface.


## Contents

* [Project Structure](#project-structure)
* [Initial Installation](#initial-installation)
* [Starting a Fakeship Testnet](#starting-a-fakeship-testnet)
* [Joining an Existing Testnet](#joining-an-existing-testnet)
* [Why Route Reads and Writes Through `%uqbar`](#why-route-reads-and-writes-through-uqbar)
* [Compiling Contracts and the Standard Library](#compiling-contracts-and-the-standard-library)
* [Deploying Contracts to a Running Testnet](#deploying-contracts-to-a-running-testnet)
* [Glossary](#glossary)


## Project Structure

![Project Structure](/assets/220901-project-structure.png)

The `%rollup` app simulates the ZK rollup to Ethereum L1.
The `%sequencer` app runs a shard, receiving transactions from users and batching them up to send to the `%rollup`.
The user suite of apps include:
* `%wallet`: manages key pairs, tracks assets, handles writes to chain
* `%indexer`: indexes batches, provides a scry interface for chain state, sends subscription updates
* [`%uqbar`](#why-route-reads-and-writes-through-uqbar): wraps `%wallet` and `%indexer` to provide a unified read/write interface

The user suite of apps interact with the `%rollup` and `%sequencer` apps, and provide interfaces for use by Urbit apps that need to read or write to the chain.

A single `%rollup` app will be run on a single ship.
One `%sequencer` app will run each shard.
Any ship that interacts with the chain will run the `%wallet`, `%indexer`, and `%uqbar` apps.

In the future, multiple `%sequencer`s may take turns sequencing a single shard.
In the future, with remote scry, users will not need to run their own `%indexer`, and will instead be able to point their `%uqbar` app at a remote `%indexer`.


## Initial Installation

1. Clone the official Urbit repository and add this repository as a submodule.
   This structure is necessary to resolve symbolic links to other desks like `base-dev` and `garden-dev`.
   ```bash
   cd ~/git  # Replace with your chosen directory.

   git clone git@github.com:urbit/urbit.git
   cd urbit/pkg
   git submodule add git@github.com:uqbar-dao/ziggurat.git ziggurat
   ```
2. Boot a development fakeship:
   ```bash
   urbit -F zod
   ```
3. In the Dojo of the fakeship, set up a `%zig` desk, where we will copy the files in this repo:
   ```hoon
   |merge %zig our %base
   |mount %zig
   ```
4. In a new terminal, copy the files from this repo into the `%zig` desk:
   ```bash
   cd ~/git/urbit/pkg  # Replace with your chosen directory.

   rm -rf zod/zig/*
   cp -RL ziggurat/* zod/zig/
   ```
5. In the Dojo of the fakeship, commit the copied files and install.
   ```hoon
   |commit %zig
   |install our %zig
   ```
6. Run tests, if desired, in the Dojo.
   ```hoon
   ::  Run all tests.
   -test ~[/=zig=/tests]

   ::  Run only contract tests.
   -test ~[/=zig=/tests/contracts]
   ```


## Starting a Fakeship Testnet

To develop this repo or new contracts, it is convenient to start with a fakeship testnet.
First, make sure the fakeship you're using is in the [whitelist](https://github.com/uqbar-dao/ziggurat/blob/master/lib/rollup.hoon).

Uqbar provides a generator to set up a fakeship testnet for local development.
That generator, used as a poke to the `%sequencer` app as `:sequencer|init`, populates a new shard with some [`item`](#item)s: [`pact`](#pact) (contract code) and [`data`](#data) (contract data).
Specifically, contracts for zigs tokens, NFTs, and publishing new contracts are pre-deployed.
After [initial installation](#initial-installation), start the `%rollup`, initialize the `%sequencer`, set up the `%uqbar` read-write interface, and configure the `%wallet` to point to some [pre-set assets](#accounts-initialized-by-init-script), minted in the `:sequencer|init` poke:
```hoon
:rollup|activate
:sequencer|init our 0x0 0xc9f8.722e.78ae.2e83.0dd9.e8b9.db20.f36a.1bc4.c704.4758.6825.c463.1ab6.daee.e608
:indexer &set-sequencer [our %sequencer]
:indexer &set-rollup [our %rollup]
:uqbar|set-sources 0x0 ~[our]
:uqbar &wallet-poke [%import-seed 'uphold apology rubber cash parade wonder shuffle blast delay differ help priority bleak ugly fragile flip surge shield shed mistake matrix hold foam shove' 'squid' 'nickname']
```


### Example: writing to chain with `%wallet`

After [starting the testnet](#starting-up-a-new-testnet), send transactions using the `%wallet`.
Note that pokes here are to `%uqbar`.
Pokes with the `%wallet-poke` mark are [routed through `%uqbar`](#why-route-reads-and-writes-through-uqbar) to `%wallet`; the pokes below could just as easily be sent to `%wallet`.

First, create a pending transaction.
The `%wallet` will send the transaction hash on a subscription wire as well as print it in the Dojo.
```hoon
::  Send zigs tokens.
:uqbar &wallet-poke [%transaction from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 contract=0x74.6361.7274.6e6f.632d.7367.697a shard=0x0 action=[%give to=0xd6dc.c8ff.7ec5.4416.6d4e.b701.d1a6.8e97.b464.76de amount=123.456 item=0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6]]

::  Send an NFT.
:uqbar &wallet-poke [%transaction from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 contract=0xc9fb.6b1b.e8b2.7b73.65e4.700f.9665.24c8.9388.2cde.fadd.c422.eb9a.3624.ca5d.014d shard=0x0 action=[%give-nft to=0xd6dc.c8ff.7ec5.4416.6d4e.b701.d1a6.8e97.b464.76de item=0x7b61.8ce0.26ec.f2b9.3bc9.5800.ba7f.164e.89ba.817b.e0d9.5cfd.96bc.c12a.5c29.00a1]]

::  Use the custom transaction interface to send zigs tokens.
:uqbar &wallet-poke [%transaction from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 contract=0x74.6361.7274.6e6f.632d.7367.697a shard=0x0 action=[%noun [%give to=0xd6dc.c8ff.7ec5.4416.6d4e.b701.d1a6.8e97.b464.76de amount=69.000 from-account=0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6 to-account=`0xd79b.98fc.7d3b.d71b.4ac9.9135.ffba.cc6c.6c98.9d3b.8aca.92f8.b07e.a0a5.3d8f.a26c]]]
```

Then, sign the transaction and assign it a gas budget.
For example, for the zigs token transaction above:
```hoon
::  Sign with hot wallet.
:uqbar &wallet-poke [%submit from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 hash=[yourhash] gas=[rate=1 bud=1.000.000]]
```
Transactions can also be signed using a hardware wallet, via `%submit-signed`.


### Submitting a `%batch`

Each signed transaction sent to the `%sequencer` will be stored in the `%sequencer`s `basket` (analogous to a mempool).
To run the transactions, create the new batch with updated shard state, and send it to the `%rollup`, poke the `%sequencer`:
```hoon
:sequencer|batch
```

Alternatively, use `%batcher-interval` or `%batcher-threshold` to automatically create batches.


#### `%batcher-interval`

`%batcher-interval` creates batches after some time period has passed.
However, if `%sequencer` has not received any transactions, it will not create a batch for that period.
```hoon
|rein %zig [& %batcher-interval]

::  Batch every 30 seconds.
:batcher-interval `~s30

::  Stop periodic batching.
:batcher-interval ~
```


#### `%batcher-threshold`

`%batcher-threshold` creates batches after some number of transactions has been received by `%sequencer`.
```hoon
|rein %zig [& %batcher-threshold]

::  Batch every 10 transactions.
:batcher-threshold `10

::  Stop automatic batching.
:batcher-threshold ~
```

### Example: reading chain state with `%indexer`:

Chain state can be scried inside Urbit or from outside Urbit using the HTTP API.
Consult the docstring of `app/indexer.hoon` for a complete listing of scry paths.
The scries below could instead be directed directly to `%indexer`, but [routing them through `%uqbar` has some advantages](#why-route-reads-and-writes-through-uqbar).
When routed through `%uqbar`, as below, `/indexer` must be prepended to the path.

1. Scrying from the Dojo.
   ```hoon
   =ui -build-file /=zig=/sur/indexer/hoon

   ::  Query all fields for the given hash.
   .^(update:ui %gx /=uqbar=/indexer/hash/0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70/noun)

   ::  Query for the history of the given item.
   .^(update:ui %gx /=uqbar=/indexer/item/0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6/noun)

   ::  Query for the current state of the given item.
   .^(update:ui %gx /=uqbar=/indexer/newest/item/0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6/noun)
   ```

2. Scrying from outside Urbit using the HTTP API.
   The following examples assume `~zod` is running on `localhost:8080`.
   ```bash
   export ZOD_COOKIE=$(curl -i -X POST localhost:8080/~/login -d 'password=lidlut-tabwed-pillex-ridrup' | grep set-cookie | awk '{print $2}' | awk -F ';' '{print $1}')

   # Query all fields for the given hash.
   curl --cookie "$ZOD_COOKIE" localhost:8080/~/scry/uqbar/indexer/hash/0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70.json | jq

   # Query for the history of the given item.
   curl --cookie "$ZOD_COOKIE" localhost:8080/~/scry/uqbar/indexer/item/0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6.json | jq

   # Query for the current state of the given item.
   curl --cookie "$ZOD_COOKIE" localhost:8080/~/scry/uqbar/indexer/newest/item/0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6.json | jq
   ```

### Accounts initialized by init script

Below are listed the seed phrases, encryption passwords, and key pairs initialized by the `:sequencer|init` call [above](#starting-a-fakeship-testnet).
Note in that section we make use of the first of these accounts to set up the `%wallet` (and `%sequencer`) on `~zod`.

```hoon
::  Account holding a data with 300 zigs.
::  Seed, password, private key, public key:
uphold apology rubber cash parade wonder shuffle blast delay differ help priority bleak ugly fragile flip surge shield shed mistake matrix hold foam shove
squid
0xc9f8.722e.78ae.2e83.0dd9.e8b9.db20.f36a.1bc4.c704.4758.6825.c463.1ab6.daee.e608
0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70

::  Account holding a data with 200 zigs:
::  Seed, password, private key, public key:
post fitness extend exit crack question answer fruit donkey quality emotion draw section width emotion leg settle bulb zero learn solution dutch target kidney
squid
0x38b7.e413.7f0d.9d05.ae1e.382d.debd.cc79.3f3a.6be3.912b.1eea.33e2.dd94.bd1c.d330
0xd6dc.c8ff.7ec5.4416.6d4e.b701.d1a6.8e97.b464.76de

::  Account holding a data with 100 zigs:
::  Seed, password, private key, public key:
flee alter erode parrot turkey harvest pass combine casual interest receive album coyote shrug envelope turtle broken purity wear else fluid transaction theme buyer
squid
0x3163.45c7.9265.36bd.6a32.d317.87c0.c961.8df2.8d91.4c07.1a04.b929.baf6.cfd2.b4e8
0x25a8.eb63.a5e7.3111.c173.639b.68ce.091d.d3fc.f139
```


## Joining an Existing Testnet

To add a new ship to a fakeship testnet or to a live testnet, follow these instructions.
First make sure your ship is on the [whitelist](https://github.com/uqbar-dao/ziggurat/blob/master/lib/rollup.hoon) of the ship hosting the rollup simulator.
The following two examples assume `~zod` is the host:


### Indexing on an existing testnet
```hoon
:indexer &set-sequencer [~zod %sequencer]
:indexer &set-rollup [~zod %rollup]
:indexer &indexer-bootstrap [~zod %indexer]
:uqbar|set-sources 0x0 ~[our]
```
In this example, not all the hosts need be the same ship.
To give a specific example, `~zod` might be running the `%rollup`, while `~bus` runs the `%sequencer` for shard `0x0` and also the `%indexer`.
Every user who wishes to interact with the chain must currently run their own `%indexer`, so there will likely be many options to `%indexer-bootstrap` from.


### Sequencing on an existing testnet

To start sequencing a new shard:
```hoon
:sequencer|init ~zod <YOUR_shard_ID> <YOUR_PRIVATE_KEY>
```

`%sequencer` does not create batches automatically unless configured to do so.
Instructions for how to manually or automatically create batches are [here](#submitting-a-batch).


## Why Route Reads and Writes Through `%uqbar`

The `%uqbar` Gall app serves as a unified read-write interface to the Uqbar chain.
It routes writes to `%wallet`, and reads to either `%indexer` or `%wallet`.

There are two main benefits to this "middleman":
1. Extensibility.
   Gall apps that access the chain using `%uqbar` make it easy for third-party developers to create `%indexer` and `%wallet` variants.
   Rather than requiring every chain-enabled Gall app to change to, say, `%orbis-tertius-indexer`, a single change can be made in the state of `%uqbar`, and requests will be routed to Orbis Tertius' third-party indexer.
   A similar argument holds for the `%wallet`.
2. Robustness & simplicity for chain-enabled Gall app developers.
   With remote scry, users will no longer have to run an `%indexer` themselves.
   Users input where to route reads and writes to in `%uqbar` once.
   Then all chain-enabled Gall apps can simply send requests to `%uqbar`.
   Further, the logic for fallbacks in case one `%indexer` provider is down can all live in `%uqbar`, rather than having to be rewritten in every chain-enabled Gall app.

Therefore, we strongly recommend devs to route read/write requests through `%uqbar`, rather than directly to `%indexer` or `%wallet`.


## Compiling Contracts and the Standard Library

Contracts and the standard library must be compiled before they can be used.
Compilation makes use of generators that can be easily run in the Dojo.
The compiled `.noun` files can be found in the `put` directory of your pier.
For example, if you compile using a fakezod, the `noun` files can be found within `zod/.urb/put`.

To recompile the standard library, use
```hoon
.smart-lib/noun +zig!mk-smart
```

Contracts can be compiled using variations of the following command.
Here, the `zigs` contract is compiled.
In general, replace `zigs` with the name of any other contract.
```hoon
.zigs/noun +zig!compile /=zig=/con/zigs/hoon
```


## Deploying Contracts to a Running Testnet

Contracts are deployed using the `publish` contract found in this repo at `con/publish.hoon`.
The `publish` contract is usually deployed on `shard`s in the `pact` with ID `0x1111.1111`.
For example, to deploy the `multisig` contract, first [compile it](#compiling-contracts-and-the-standard-library).
Then place it at `con/compiled/multisig.noun`.
To deploy on shard `0x0`, in the Dojo:
```hoon
=contract-path /=zig=/con/compiled/multisig/noun
=contract-noun .^(* %cx contract-path)
=contract ;;([bat=* pay=*] contract-noun)
:uqbar &wallet-poke [%transaction from=[youraddress] contract=0x1111.1111 shard=0x0 action=[%noun [%deploy mutable=%.n cont=contract interface=~ types=~]]]
```


## Glossary

### `batch`
A `batch` in a rollup is analogous to a block in a blockchain.
`batch`es have a definite order, and are produced by a `%sequencer` for a given `shard`.


### `transaction`

A transaction consists of three parts, a signature, calldata, and a `shell`.
The `shell` is the same for all `transaction`s, and contains information about who the transaction is from, what contract it called, what gas budget was allocated and so on.
`calldata` is a `(pair @tas noun)` that has a form depending on the target contract.


### `item`

An `item` is either a piece of data (a `data`) or a piece of code (a `pact`).


### `data`

A `data` is a piece of data associated with a specific `pact` that is `lord` over it.
For example, a `data` of the `zigs` `pact` might be an `account`, holding some number of tokens.
Or a `data` of the `nft` `pact` might be a particular `nft` with certain characteristics.


### `pact`

A `pact` is a piece of code: it is a contract.
For example, the `zigs` contract that governs the base rollup tokens is a `pact`, and the `nft` contract that enables NFTs to be held and sent is another.


### `shard`

A segment of chain-state within the Uqbar rollup.
A `%sequencer` runs a `shard`, receiving transactions from users, executing them, and then sending the updated state to the `%rollup`.
