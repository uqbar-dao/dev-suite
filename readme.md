# Ziggurat

Ziggurat is the Uqbar developer suite.
It contains code for the Gall apps required to simulate the ZK-rollup to Ethereum, to sequence transactions in order to run a town, and the user application suite: the `%wallet` for chain writes, the `%indexer` for chain reads, and `%uqbar`, a unified read-write interface.


## Contents

* [Project Structure](#project-structure)
* [Initial Installation](#initial-installation)
* [Starting a Fakeship Testnet](#starting-a-fakeship-testnet)
* [Joining an Existing Testnet](#joining-an-existing-testnet)
* [Compiling Contracts and the Standard Library](#compiling-contracts-and-the-standard-library)
* [Additional Wallet Pokes](#additional-wallet-pokes)
* [Indexer](#indexer)
* [Testing Zink](#testing-zink)


## Project Structure

![Project Structure](/assets/220901-project-structure.png)

The `%rollup` app simulates the ZK rollup to the Ethereum L1.
The `%sequencer` app runs a town, receiving transactions from users and batching them up to send to the `%rollup`.
The user suite of apps include:
* `%wallet`: manages key pairs, tracks assets, handles writes to chain
* `%indexer`: indexes batches, provides a scry interface for chain state, sends subscription updates
* `%uqbar`: wraps `%wallet` and `%indexer` to provide a unified read/write interface

The user suite of apps interact with the `%rollup` and `%sequencer` apps, and provide interfaces for use by Urbit apps that need to read or write to the chain.

A single `%rollup` app will be run on a single ship.
One `%sequencer` app will run each town.
Any ship that interacts with the chain will run the `%wallet`, `%indexer`, and `%uqbar` apps.

In the future, multiple `%sequencer`s may take turns sequencing a single town.
In the future, with remote scry, users will not need to run their own `%indexer`, and will instead be able to point their `%uqbar` app at a remote `%indexer`.


## Initial Installation

1. Clone & build the custom Urbit runtime with Pedersen jets, and set env var `URBIT_BIN` to point to the resulting binary.
   Sequencers must use the Pedersen-jetted binary for Uqbar code to run at reasonable speed.
   Building requires the Nix package manager, see [install instructions](https://nixos.org/download.html).
   ```bash
   mkdir ~/git && cd ~/git  # Replace with your chosen directory.

   git clone -b mb/local-jet git@github.com:martyr-binbex/urbit.git urbit-jet
   cd urbit-jet
   nix-build -A urbit
   export URBIT_BIN=$(realpath ./result/bin/urbit)
   ```
2. Clone the official Urbit repository & add this repository as a submodule.
   This structure is necessary to resolve symbolic links to other desks like base-dev and garden-dev.
   ```bash
   cd ~/git  # Replace with your chosen directory.

   git clone git@github.com:urbit/urbit.git
   cd urbit/pkg
   git submodule add git@github.com:uqbar-dao/ziggurat.git ziggurat
   ```
3. Boot a development fakeship:
   ```bash
   $URBIT_BIN -F zod
   ```
4. In the Dojo of the fakeship, set up a `%zig` desk, where we will copy the files in this repo:
   ```hoon
   |merge %zig our %base
   |mount %zig
   ```
5. In a new terminal, copy the files from this repo into the `%zig` desk:
   ```bash
   cd ~/git/urbit/pkg  # Replace with your chosen directory.

   rm -rf zod/zig/*
   cp -RL ziggurat/* zod/zig/
   ```
6. In the Dojo of the fakeship, commit the copied files and install.
   ```hoon
   |commit %zig
   |install our %zig
   ```
7. Run tests if desired in the Dojo.
   ```hoon
   ::  Run all tests.
   -test ~[/=zig=/tests]

   ::  Run only contract tests.
   -test ~[/=zig=/tests/contracts]
   ```


## Starting a Fakeship Testnet

*Note: make sure the ship you're using is in the [whitelist](https://github.com/uqbar-dao/ziggurat/blob/master/lib/rollup.hoon)*


### Starting up a new testnet

Uqbar provides a generator to set up a fakeship testnet for local development.
That generator, used as a poke to the `%sequencer` app as `:sequencer|init`, populates a new town with some `grain`s: `wheat` (contract code) and `rice` (owned data).
Specifically, contracts for zigs tokens, NFTs, and publishing new contracts are pre-deployed.
After [initial installation](#initial-installation), start the `%rollup`, initialize the `%sequencer`, set up the `%uqbar` middleware, and configure the `%wallet` to point to some pre-set assets, minted in the `:sequencer|init` poke:
```hoon
:rollup|activate
:sequencer|init our 0x0 0xc9f8.722e.78ae.2e83.0dd9.e8b9.db20.f36a.1bc4.c704.4758.6825.c463.1ab6.daee.e608
:indexer &set-sequencer [our %sequencer]
:indexer &set-rollup [our %rollup]
:uqbar|set-sources 0x0 ~[our]
:uqbar &zig-wallet-poke [%import-seed 'uphold apology rubber cash parade wonder shuffle blast delay differ help priority bleak ugly fragile flip surge shield shed mistake matrix hold foam shove' 'squid' 'nickname']
```


### Example: writing to chain with `%wallet`

After [starting the testnet](#starting-up-a-new-testnet), send transactions using the `%wallet`.
Note that pokes here are to `%uqbar`.
Pokes with the `%zig-wallet-poke` mark are routed through `%uqbar` to `%wallet`, so the pokes below could just as easily be sent to `%wallet`.

```hoon
::  Send zigs tokens.
:uqbar &zig-wallet-poke [%submit from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 to=0x74.6361.7274.6e6f.632d.7367.697a town=0x0 gas=[1 1.000.000] [%give to=0xd6dc.c8ff.7ec5.4416.6d4e.b701.d1a6.8e97.b464.76de amount=123.456 grain=0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6]]

::  Send an NFT.
:uqbar &zig-wallet-poke [%submit from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 to=0xcafe.babe town=0x0 gas=[1 1.000.000] [%give-nft to=0xd6dc.c8ff.7ec5.4416.6d4e.b701.d1a6.8e97.b464.76de grain=0x7e21.2812.bfae.4d2e.6b3d.9941.b776.3c0f.33bc.fb6d.c759.2d80.be02.a7b2.48a8.da97]]

::  Use the custom transaction interface to send zigs tokens.
:uqbar &zig-wallet-poke [%submit-custom from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 to=0x74.6361.7274.6e6f.632d.7367.697a town=0x0 gas=[1 1.000.000] yolk='[%give to=0xd6dc.c8ff.7ec5.4416.6d4e.b701.d1a6.8e97.b464.76de amount=69.000 from-account=0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6 to-account=`0xd79b.98fc.7d3b.d71b.4ac9.9135.ffba.cc6c.6c98.9d3b.8aca.92f8.b07e.a0a5.3d8f.a26c]']
```

Each transaction sent will be stored in the `%sequencer`s `basket` -- analogous to a mempool.
To execute the transactions, create the new batch with updated town state, and send it to the `%rollup`, poke the `%sequencer`:
```hoon
:sequencer|batch
```


### Example: reading chain state with `%indexer`:

Chain state can be scried inside Urbit or from outside Urbit using the HTTP API.
Consult the docstring of `app/indexer.hoon` for a complete listing of scry paths.

1. Scrying from the Dojo.
   ```hoon
   =ui -build-file /=zig=/sur/indexer/hoon

   ::  Query all fields for the given hash.
   .^(update:ui %gx /=indexer=/hash/0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70/noun)

   ::  Query for the history of the given grain.
   .^(update:ui %gx /=indexer=/grain/0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6/noun)

   ::  Query for the current state of the given grain.
   .^(update:ui %gx /=indexer=/newest/grain/0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6/noun)
   ```

2. Scrying from outside Urbit using the HTTP API.
   The following examples assume `~zod` is running on `localhost:8080`.
   ```bash
   export ZOD_COOKIE=$(curl -i -X POST localhost:8080/~/login -d 'password=lidlut-tabwed-pillex-ridrup' | grep set-cookie | awk '{print $2}' | awk -F ';' '{print $1}')

   # Query all fields for the given hash.
   curl --cookie "$ZOD_COOKIE" localhost:8080/~/scry/uqbar/indexer/hash/0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70.json | jq

   # Query for the history of the given grain.
   curl --cookie "$ZOD_COOKIE" localhost:8080/~/scry/uqbar/indexer/grain/0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6.json | jq

   # Query for the current state of the given grain.
   curl --cookie "$ZOD_COOKIE" localhost:8080/~/scry/uqbar/indexer/newest/grain/0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6.json | jq
   ```

### Accounts initialized by init script

Below are listed the seed phrases, encryption passwords, and key pairs initialized by the `:sequencer|init` call [above](#starting-a-new-testnet).
Note in that section we make use of the first of these accounts to set up the `%wallet` (and `%sequencer`) on `~zod`.

```hoon
::  Account holding a rice with 300 zigs.
::  Seed, password, private key, public key:
uphold apology rubber cash parade wonder shuffle blast delay differ help priority bleak ugly fragile flip surge shield shed mistake matrix hold foam shove
squid
0xc9f8.722e.78ae.2e83.0dd9.e8b9.db20.f36a.1bc4.c704.4758.6825.c463.1ab6.daee.e608
0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70

::  Account holding a rice with 200 zigs:
::  Seed, password, private key, public key:
post fitness extend exit crack question answer fruit donkey quality emotion draw section width emotion leg settle bulb zero learn solution dutch target kidney
squid
0x38b7.e413.7f0d.9d05.ae1e.382d.debd.cc79.3f3a.6be3.912b.1eea.33e2.dd94.bd1c.d330
0xd6dc.c8ff.7ec5.4416.6d4e.b701.d1a6.8e97.b464.76de

::  Account holding a rice with 100 zigs:
::  Seed, password, private key, public key:
flee alter erode parrot turkey harvest pass combine casual interest receive album coyote shrug envelope turtle broken purity wear else fluid egg theme buyer
squid
0x3163.45c7.9265.36bd.6a32.d317.87c0.c961.8df2.8d91.4c07.1a04.b929.baf6.cfd2.b4e8
0x25a8.eb63.a5e7.3111.c173.639b.68ce.091d.d3fc.f139
```


## Joining an Existing Testnet

First make sure you're on the [whitelist](https://github.com/uqbar-dao/ziggurat/blob/master/lib/rollup.hoon) for the ship hosting the rollup simulator.
The following two examples assume `~zod` is the host:


### Indexing on an existing testnet
```hoon
:indexer &indexer-catchup [~zod %indexer]
:indexer &set-sequencer [~zod %sequencer]
:indexer &set-rollup [~zod %rollup]
:uqbar|set-sources 0x0 ~[our]
```
In this example, not all the hosts need be the same ship.
To give a specific example, `~zod` might be running the `%rollup`, while `~bus` runs the `%sequencer` for town `0x0` and also the `%indexer`.
Every user who wishes to interact with the chain must currently run their own `%indexer`, so there will likely be many options to `%indexer-catchup` from.


### Sequencing on an existing testnet

To start sequencing a new town:
```hoon
:sequencer|init ~zod <YOUR_TOWN_ID> <YOUR_PRIVATE_KEY>
```


## Compiling Contracts and the Standard Library


The following line compiles the `dao.hoon` contract. In general, you can replace `dao` with the name of any other contract.
```hoon
.dao/noun +zig!deploy /=zig=/lib/zig/contracts/dao/hoon
```

Run the following if you've made changes to the standard library and want to recompile it.
```hoon
.smart-lib/noun +zig!mk-smart
```

The above instructions output their content into the `put` directory of your pier, located at e.g. `nec/.urb/put`.

To include the compiled contracts into the git tree, run the following:

```bash
cp ./<fakezod_pier>/.urb/put/*.noun ./<urbit-git-dir>/pkg/ziggurat/lib/zig/compiled/
```

(This assumes you've cloned this repo (ziggurat) as a submodule into the pkg folder as instructed above.)


## Additional Wallet Pokes
(only those with JSON support shown)

```
{import-seed: {mnemonic: "12-24 word phrase", password: "password", nick: "nickname for the first address in this wallet"}}
{generate-hot-wallet: {password: "password", nick: "nickname"}}
# leave hdpath empty ("") to let wallet auto-increment from 0 on main path
{derive-new-address: {hdpath: "m/44'/60'/0'/0/0", nick: "nickname"}}
# use this to save a hardware wallet account
{add-tracked-address: {address: "0x1234.5678" nick: "nickname"}}
{delete-address: {address: "0x1234.5678"}}
{edit-nickname: {address: "0x1234.5678", nick: "nickname"}}
{set-node: {town: 1, ship: "~zod"}}  # set the sequencer to send txs to, per town
{set-indexer: {ship: "~zod"}}
{submit-custom: {from: "0x1234", to: "0x5678", town: 1, gas: {rate: 1, bud: 10000}, args: "[%give ... .. (this is HOON)]", my-grains: {"0x1111", "0x2222"}, cont-grains: {"0x3333", "0x4444"}}}
# for TOKEN and NFT transactions
# 'from' is our address
# 'to' is the address of the smart contract
# 'town' is the number ID of the town on which the contract&rice are deployed
# 'gas' rate and bud are amounts of zigs to spend on tx
# 'args' will eventually cover many types of transactions,
# currently only concerned with token sends following this format,
# where 'token' is address of token metadata rice, 'to' is address receiving tokens.
{submit:
  {from: "0x3.e87b.0cbb.431d.0e8a.2ee2.ac42.d9da.cab8.063d.6bb6.2ff9.b2aa.e1b9.0f56.9c3f.3423",
   to: "0x74.6361.7274.6e6f.632d.7367.697a",
   town: 1,
   gas: {rate: 1, bud: 10000},
   args: {give: {salt: "1.936.157.050", to: "0x2.eaea.cffd.2bbe.e0c0.02dd.b5f8.dd04.e63f.297f.14cf.d809.b616.2137.126c.da9e.8d3d", amount: 777}}
   }
}
```


## Indexer

The indexer exposes a variety of scry and subscription paths.
A few are discussed below with examples.
Please see the docstring at the top of `app/indexer.hoon` for a fuller set of available paths.


### Indexer scries

Four example scries will be shown below for a user scrying from the Dojo; externally using the Curl commandline tool; and using the Urbit HTTP API.

For simplicity, the following is assumed:

I. The `%indexer` app is running on the `%zig` desk on a fakezod.
II. The fakezod is running at `localhost:8080`.

Examples:

1. The most recent 5 block headers.

```
::  inside Urbit
=z -build-file /=zig=/sur/ziggurat/hoon
.^((list [epoch-num=@ud =block-header:z]) %gx /=indexer=/headers/5/noun)

# using Curl
curl -i -X POST localhost:8080/~/login -d 'password=lidlut-tabwed-pillex-ridrup'
# record cookie from above and use below
curl --cookie "urbauth-~zod=$ZOD_COOKIE" localhost:8080/~/scry/indexer/headers/5.json

# using HTTP API
await api.scry({app: "indexer", path: "/headers/5"});
```

2. All data in a chunk with epoch number, block number, and chunk/town number as `1`, `2`, and `3`, respectively (these should, of course, be substituted for variables appropriate).

```
::  inside Urbit
::  TODO

# using Curl
# TODO

# using HTTP API
await api.scry({app: "indexer", path: "/chunk-num/1/2/3"});
```

3. A given transaction with hash `0xdead.beef` (this should, of course, be substituted for a variable as appropriate).

```
::  inside Urbit
::  TODO

# using Curl
# TODO

# using HTTP API
await api.scry({app: "indexer", path: "/egg/0xdead.beef"});
```

4. All transactions for a given address with hash `0xcafe.babe` (this should, of course, be substituted for a variable as appropriate) (TODO: add start/end times to retrieve subset of transactions).

```
::  inside Urbit
::  TODO

# using Curl
# TODO

# using HTTP API
await api.scry({app: "indexer", path: "/from/0xcafe.babe"});
```


### Indexer subscriptions

One example subscription will be discussed: subscribing to receive each new block (or "slot") that is processed by the indexer. (TODO)
Please see the docstring at the top of `app/indexer.hoon` for a fuller set of available paths.

For the HTTP API, the app to subscribe to is `"indexer"`, and the path is `"/slot"`.


## Testing Zink

```
=z -build-file /=zig=/lib/zink/zink/hoon
=r (~(eval-hoon zink:z ~) /=zig=/lib/zink/stdlib/hoon /=zig=/lib/zink/test/hoon %test '3')
-.r     # product
+<.r    # json hints
+>.r    # pedersen hash cache
# once you've run this once so you have a cache you should pass it in every time
# You can pass ~ for library if you don't have one
> =r (~(eval-hoon zink:z +>.r) ~ /=zig=/lib/zink/fib/hoon %fib '5')
# +<.r is the hint json. You need to write it out to disk so you can pass it to cairo.
@fib-5/json +<.r
# Now fib-5.json is in PIER/.urb/put and you can pass it to cairo.
# hash-noun will give you just a hash
> =r (~(hash-noun zink:z +>.r) [1 2 3])
```


## Precomputing Hashes for Zink

```
.hash-cache/noun +zig!build-hash-cache 100
```
