# `%dev-suite` Documentation

The `%dev-suite` is comprised of `%pyro`, a ship virtualizer; `%pyre`, a virtual runtime; and `%ziggurat`, the backend for an [IDE](https://github.com/uqbar-dao/ziggurat-ui) that uses `%pyro` and `%pyre` as a foundation.

## [`%pyro` Contents](#pyro-documentation)
* [`%pyro` Quick Start](#pyro-quick-start)
* [`%pyro` Architecture](#pyro-architecture)
* [`%pyro` Inputs](#pyro-inputs)
* [`%pyro` Outputs](#pyro-outputs)
* [`%pyro` Threads](#pyro-threads)

## [`%ziggurat` Contents](#ziggurat-documentation)
* [Broad overview](#broad-overview)
* [Initial installation](#initial-installation)
* [Example usage](#example-usage)
* [`%pyro` ship I/O](#pyro-ship-io)
* [Test steps](#test-steps)
* [Custom inputs](#custom-inputs)
* [Deploying contracts](#deploying-contracts)
* [Project configuration](#project-configuration)

# `%pyro` Documentation
Last updated as of Feb 07, 2023.

## `%pyro` Quick Start
```
:pyro|init ~nec                     :: initialize fake ~nec
:pyro|init ~bud                     :: initialize fake ~bud
:pyro|commit ~nec %foo              :: copy host desk %foo into ~nec
:pyro|dojo ~nec "|install our %foo" :: install %foo desk into ~nec
:pyro|dojo ~nec "=bar 5"            :: run a dojo command
:pyro|snap /baz ~[~nec ~bud]        :: take a snapshot of ~nec and ~bud named /baz
:pyro|restore /baz                  :: restore ~nec and ~bud to /baz state
:pyro|pause ~nec                    :: stop processing events for ~nec
:pyro|unpause ~nec                  :: resume processing events for ~nec
:pyro|kill ~nec                     :: remove ~nec and all it's state
:pyro|pass ~nec ...                 :: same as |pass - for experts only!
```

## `%pyro` Architecture
`%pyro` simulates individual ships, handles their state, their I/O, and snapshots

`%pyre` is the virtual runtime for %pyro ships. It handles ames sends, behn timers, iris requests, eyre responses, and dojo outputs. Not all runtime functionality is implemented - just the most important pieces.

## `%pyro` inputs
Just like a normal ship, the only interface for interacting with a `%pyro` ship is to pass it `$task-arvo`s. Using raw `$task`s requires a good knowledge of `lull.hoon`, so the most common I/O is implemented in `/lib/pyro/pyro.hoon` and `/gen/pyro/` for your convenience.

## `%pyro` outputs
###  Effects
All `$unix-effect`s can be subscribed to by an app or thread. However, `%pyre` automatically handles the most important `$unix-effects` for you. Handling unix effects by yourself in an app/thread requires a good knowledge of `lull.hoon` - to look for a specific output, look at each vane's `$gift`s.

### Scries
You can scry into a `%pyro` ship. Anthing that you can scry out of a normal ship, you can scry out of a `%pyro` ship.
```hoon
.^(wain %gx /=pyro=/i/~nec/cx/~nec/zig/(scot %da now)/desk/bill/bill)
```
Note:
1. All scries into `%pyro` ships must have a double mark at the end (e.g. `/noun/noun`, `/bill/bill`, etc.)
2. The `%pyro` ship and the [care](https://developers.urbit.org/reference/arvo/concepts/scry) must be specified at the start of the path.

There is also a convenience scry for `%gx` cares into agents running on `%pyro` ships:
```hoon
.^(mold %gx /=pyro=/~nec/myapp/my/path/goes/here/mark/mark)
```

## `%pyro` Threads
`%pyro` tests are meant to be written as threads. Common functions for using threads live in `/lib/pyro/pyro.hoon`
```
;<  ~  bind:m  (reset-ship:pyro ~nec)
;<  ~  bind:m  (reset-ship:pyro ~bud)
;<  ~  bind:m  (commit:pyro ~[~nec ~bud] our %base now)
;<  ~  bind:m  (snap:pyro /my-snapshot ~[~nec~bud]) :: TODO this isn't written
;<  ~  bind:m  (dojo:pyro ~nec "(add 2 2)")
;<  ~  bind:m  (wait-for-output:pyro ~nec "4")
;<  ~  bind:m  (poke:pyro ~nec ~bud %dap %mar !>(%payload))
;<  ~  bind:m  (restore:pyro /my-snapshot) :: TODO this isn't written
```

---
---
---
---
---

# `%ziggurat` documentation

The `%ziggurat` dev suite is built on top of the `%pyro` ship virtualizer and is the backend for the [Ziggurat IDE](https://github.com/uqbar-dao/ziggurat-ui).

Last updated as of Feb 13, 2023.

## Broad overview

`%ziggurat` is the backend for the [Ziggurat IDE](https://github.com/uqbar-dao/ziggurat-ui).
`%pyro` is a ship virtualizer used to run a network of `%pyro` ships and used by `%ziggurat`.

`%pyro` is paired with `%pyre`, an app that plays the role of the runtime for `%pyro`.
For example, `%pyre` picks up ames packets sent from one `%pyro` ship and passes them to the recipient `%pyro` ship.

`%pyro` can snapshot and load `%pyro` ship state.

`%ziggurat` must be loaded with a series of `test-steps` before they can be run.
These `test-steps` are sequences of steps, such as `%poke`, `%scry`, `%dojo`, `%subscribe`, and so on.
Each `test-step` may optionally have expectations.

`%ziggurat` is made to be run in conjunction with [Uqbar Core](https://github.com/uqbar-dao/uqbar-core).
It is specifically designed to make smart contract development easy, but without sacrificing Gall agent development.
As such, `%ziggurat` is the premier development environment for integrated on- and off-chain computing not only on Urbit, but in the world,

By default we run `~nec`, `~bud`, and `~wes` as `%pyro` ships.

##  Initial installation

1. Follow the [Initial Installation instuctions on Uqbar Core](https://github.com/uqbar-dao/uqbar-core#initial-installation).
   Uqbar Core is required for the `%ziggurat` dev suite to work properly.
2. Clone the official Urbit repository and add this repository as a submodule.
   This structure is necessary to resolve symbolic links to other desks like `base-dev` and `garden-dev`.
   ```bash
   cd ~/git/urbit/pkg  # Replace with your urbit pkg directory.
   git submodule add git@github.com:uqbar-dao/dev-suite.git dev-suite
   ```
3. In the Dojo of the fakeship set up in the Uqbar Core installation, set up a `%suite` desk, where we will copy the files in this repo:
   ```hoon
   |new-desk %suite
   ```
5. In a new terminal, copy the files from this repo into the `%suite` desk:
   ```bash
   cd ~/git/urbit/pkg  # Replace with your chosen directory.

   rm -rf zod/suite/*
   cp -RL dev-suite/* zod/suite/
   ```
6. In the Dojo of the fakeship, commit the copied files and install.
   ```hoon
   |commit %suite

   ::  Installing will set up the default `%pyro` ships, ~nec, ~bud, and ~wes,
   ::   with ~nec as host, of a testnet in the same state as following
   ::   the steps here:
   ::   https://github.com/uqbar-dao/uqbar-core#starting-a-fakeship-testnet
   |install our %suite
   ```

## Example usage

The following creates a project called `%foo` and runs a number of `test-steps`.
When `%new-project` is called, `%ziggurat` looks for the project/desk, and if it finds it, looks for a [configuration file](#project-configuration) at `/zig/configs/[project-name]/hoon`.
If found, the project is setup according to that configuration.
Else, a default setup is used.
```hoon
::  Run the subscribe thread to print %ziggurat output to
::   the Dojo -- then press <Backspace> to background it.
-suite!ziggurat-test-subscribe ~

:ziggurat &ziggurat-action [%foo ~ %new-project ~[~bud ~wes]]

:ziggurat &ziggurat-action [%foo ~ %add-and-queue-test-file `%scry-nec /zig/test-steps/scry-nec/hoon]
:ziggurat &ziggurat-action [%foo ~ %add-and-queue-test-file `%scry-bud /zig/test-steps/scry-bud/hoon]
:ziggurat &ziggurat-action [%foo ~ %add-and-queue-test-file `%scry-clay /zig/test-steps/scry-clay/hoon]
:ziggurat &ziggurat-action [%foo ~ %add-and-queue-test-file `%subscribe-nec /zig/test-steps/subscribe-nec/hoon]

::  The same ZIGS send done in two ways:
::   Using a custom-step-definition and pokes,
::   Using Dojo commands.
:ziggurat &ziggurat-action [%foo ~ %add-and-queue-test-file `%send-nec /zig/test-steps/send-nec/hoon]
:ziggurat &ziggurat-action [%foo ~ %add-and-queue-test-file `%send-nec-dojo /zig/test-steps/send-nec-dojo/hoon]

:ziggurat &ziggurat-action [%$ ~ %run-queue ~]

::  Tell `%ziggurat` not to run any more tests right now.
::   Also resets state when `%start-pyro-ships` is called again.
:ziggurat &ziggurat-action [%foo ~ %stop-pyro-ships ~]
```

### Import %pokur, set up a table, and join it

As a more real-world example, import the %pokur project (requires https://github.com/dr-frmr/pokur/pull/29 at least to work).

```hoon
::  Run the subscribe thread to print %ziggurat output to
::   the Dojo -- then press <Backspace> to background it.

-suite!ziggurat-test-subscribe ~
|new-desk %pokur

::  Copy in appropriate files to %pokur, then:
|commit %pokur

::  Set up %pokur, installing on ~nec, ~bud, ~wes, setting up ~nec as host, launching a table on ~bud.
:ziggurat &ziggurat-action [%pokur ~ %new-project ~]

::  Join the ~bud table from ~wes.
:ziggurat &ziggurat-action [%pokur ~ %add-and-queue-test-file `%wes-join-table /zig/test-steps/wes-join-table/hoon]
:ziggurat &ziggurat-action [%$ ~ %run-queue ~]
```

Some other stuff you may want to do:

```hoon
::  Snapshot at any given state to be able to restore to it later:
::   (The `/my-state/0` is an arbitrary `path` that is a label).
:pyro|snap /my-state/0 ~[~nec ~bud ~wes]

::  If you want to restore to pre-%pokur-install state (or any other state, specified by the label `path`):
:pyro|restore /testnet

::  If you want to inspect state of apps:
:pyro|dojo ~bud ":pokur +dbug"
```

### `send-nec` from the `%pyro` ship Dojo

```hoon
:pyro|dojo ~nec ":uqbar &wallet-poke [%transaction from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 contract=0x74.6361.7274.6e6f.632d.7367.697a town=0x0 action=[%give to=0xd6dc.c8ff.7ec5.4416.6d4e.b701.d1a6.8e97.b464.76de amount=123.456 item=0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6]]"
:pyro|dojo ~nec ":uqbar &wallet-poke [%submit from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 hash=0xa99c.4c8e.1c8d.abb8.e870.81e8.8c96.2cf5 gas=[rate=1 bud=1.000.000]]"
:pyro|dojo ~nec ":sequencer|batch"
```

### Alternative `test-steps` input

Test steps can also be added by directly inputting them.
This is useful for commandline testing or for frontends.
For example, an equivalent to adding and queueing `%send-nec` above would be:
```hoon
=test-imports (~(put by *(map @tas path)) %indexer /sur/zig/indexer)
=test-steps ~[[%scry [~nec 'update:indexer' %gx %indexer /batch-order/0x0/noun] '[%batch-order batch-order=~[0xd85a.d919.9806.cbc2.b841.eb0d.854d.22af]]']]
:ziggurat &ziggurat-action [%foo %add-and-queue-test `%scry-nec-direct test-imports test-steps]
```
A `test-steps` added this way is assigned a test id like any other test.
It can be saved to a file by looking up this id.
As of this writing is was `0x3825.4e68.9717.b400.b727.fdee.5c7b.90e0`; look it up using:
```hoon
=zig -build-file /=zig=/sur/zig/ziggurat/hoon
.^(projects:zig %gx /=ziggurat=/projects/noun)
```
Then save via:
```hoon
:ziggurat &ziggurat-action [%foo %save-test-to-file 0x3825.4e68.9717.b400.b727.fdee.5c7b.90e0 /zig/test-steps/my-scry-nec/hoon]
```

### `update:zig`

Many pokes will result in an error or change in state that frontends or other apps need to know about.
`%ziggurat` returns `update`s that specify the changed state or the error that occurred.
Frontends or apps should subscribe to `/project/[project-name]` to receive these `update`s.

In addition, scries will also often return `update:zig`.

`update:zig` takes the form of:
* A tag, indicating the action or scry that triggered the update or the piece of state that changed,
* `update-info:zig`, which itself contains metadata about the state/triggering action:
  * `project-name`,
  * `source`: where did this `update` or error originate from?
  * `request-id`: pokes may include a `(unit @t)`, an optional `request-id` to make finding the resulting update easier; if a poke caused this `update`, and it included a `request-id`, it is copied here.
* `payload`: a piece of data or an error.
  If the `update` is reporting a success this may contain data about the updated state.
  If the `update` is reporting a failure, this includes a:
  * `level`: like a logging level (info, warning, error): how severe was this failure,
  * `message`: an description of the error.
* other optional metadata that should be reported whether a success or a failure.

## Test steps

`test-steps` are sequences of `test-step`s: a command to do something that optionally has an expected result.
E.g., a `test-step` can be a `%poke` or a `%scry`.
A `%scry` `test-step`, an example of a read from state, has an `expected` field that is a `@t`: the expectation of output as a result of completing that scry.
In contract, a `test-step` like a `%poke` that writes to state has an `expected` field that is a `list` of read steps: a single `%poke` can have cascading effects and so it is important to have the ability to query multiple times.

`test-steps` are defined in the `$` arm of a core.
Examples can be seen in the `zig/test-steps/` dir](https://github.com/uqbar-dao/dev-suite/tree/master/zig/test-steps).

The subject of a `test-steps` is defined by the `/=` imports at the top of the `test-steps` file.
In addition, this subject will be applied for [`custom-step-definitions`](#custom-inputs), so those dependencies must be included in `test-steps`.
`test-globals` also includes `our=@p`, `now=@da`, and `project=@tas`.
Finally, some `test-globals` will be accessible by `test-steps` (see sur/zig/ziggurat.hoon):

`configs:test-globals` is a `(map project-name=@t (map [who=@p what=@tas] @)` (or a `(mip project-name=@t [who=@p what=@tas] @)` for short) that stores general data that can be added to with `%add-config`.
It is loaded with some useful items by default, as well:
* The default testnet address associated with that `@p` is stored at `[project-name=~ who=@p what=%address]`,
* The host running the `%sequencer` for a town given by the `map` value is stored at `[project-name=[~ @t] who=@p what=%sequencer]`.

`test-results:test-globals` are also accessible, so that the results of a previous `test-step` is usable in the current one.
Results from previous steps can be accessed more ergonomically by attaching a [`result-face`](https://github.com/uqbar-dao/dev-suite/blob/master/sur/zig/ziggurat.hoon#L77-L96) to them, and can then be accessed using that face in subsequent steps.
See [`zig/custom-step-definitions/send-wallet-transaction.hoon`](https://github.com/uqbar-dao/dev-suite/blob/master/zig/custom-step-definitions/send-wallet-transaction.hoon) for an example.

## Custom inputs

Custom steps are useful for reducing boilerplate when a certain `test-step` is used frequently.
For example, to write to the `%pyro` ship testnet, a transaction is sent with a `%wallet-poke`.
However, the transaction must also be signed, and the sequencer must submit a batch before the transaction is posted.
Thus, the following must occur:
1. Scry current pending transactions in the wallet,
2. Send the transaction,
3. Scry newly updated pending transactions in the wallet,
4. Compute the diff on the pending transaction scries to find the our pending transaction hash,
5. Sign that pending transaction and send it to the sequencer,
6. Tell the sequencer to process the batch.

Rather than requiring every `%pyro` ship testnet write `test-steps` do the common work, use the `custom-write-step` [`zig/custom-step-definitions/send-wallet-transaction.hoon`](https://github.com/uqbar-dao/dev-suite/blob/master/zig/custom-step-definitions/send-wallet-transaction.hoon).
For an example of usage, see [`zig/test-steps/send-nec.hoon`](https://github.com/uqbar-dao/dev-suite/blob/master/zig/test-steps/send-nec.hoon).

More examples can be found in the [`zig/custom-step-definitions/` dir](https://github.com/uqbar-dao/dev-suite/tree/master/zig/custom-step-definitions).

Custom steps are labeled by a `tag=@tas` -- the name of the step that will be referenced when calling it.
A custom step is a core whose `$` arm takes in arguments and an `expected` (either a `@t` if a `custom-read-step` or a `(list test-read-step)` if a `custom-write-step`) and must return a `(list test-step)`.

## Deploying contracts

Contracts can be deployed to the `%pyro` ship testnet for a project using the `%deploy-contract` poke:
```hoon
:ziggurat &ziggurat-action [%foo ~ %deploy-contract town-id=0x0 /con/compiled/nft/jam]
```

## Project configuration

Projects can be configured so that they are in a predictable state when imported.
Configuration is accomplished by a `hoon` file that lives at `/zig/configs/[project-name]/hoon`.
For example, see `/zig/configs/zig/hoon` that ships with this repository.

The configuration file has a specified form.
Imports may be specified using the `/=` rune at the top of the file.
The file is then composed of a core with the following arms:

Arm name                     | Return type                                      | Description
---------------------------- | ------------------------------------------------ | -----------
`+make-config`               | `config:zig`                                     | Set global state for the project, accessible during `test-steps`.
`+make-virtualships-to-sync` | `(list @p)`                                      | Set `%pyro` ships to mirror the project desk on.
`+make-install`              | `?`                                              | Install the mirrored desk on synced `%pyro` ships?
`+make-start-apps`           | `(list @tas)`                                    | Additional apps to start on synced `%pyro` ships (that are not included in the project's `desk.bill`).
`+make-state-views`          | `(list [who=@p app=(unit @tas) file-path=path])` | Default state views, specified in the file path. `app=~` -> chain view, not an agent view.
`+make-setup`                | `(map @p test-steps:zig)`                        | Set the initial state on synced `%pyro` ships by running these `test-steps`.
