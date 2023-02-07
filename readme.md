# `%pyro` and `%ziggurat` test suite documentation

Document describes current best practices for use and testing of `%pyro` and `%ziggurat`.
As these projects are in a state of heavy development, this document will likely go out of date unless updated.

Last updated as of Feb 07, 2023.

##  Contents

* [Broad overview](#broad-overview)
* [Example usage](#example-usage)
* [`%pyro` ship I/O](#pyro-ship-io)
* [Test steps](#test-steps)
* [Custom inputs](#custom-inputs)
* [Deploying contracts](#deploying-contracts)
* [Project configuration](#project-configuration)

## Broad overview

`%ziggurat` is the backend for an IDE and testing environment.
`%pyro` is a ship virtualizer used to run a network of virtual ships and used by `%ziggurat`.

`%pyro` is paired with `%pyre`, an app that plays the role of the runtime for `%pyro`.
For example, `%pyre` picks up ames packets sent from one virtualship and passes them to the recipient virtualship.

`%pyro` can snapshot and load ship state.

`%ziggurat` must be loaded with a series of `test-steps` before they can be run.
These `test-steps` are sequences of steps, such as `%poke`, `%scry`, `%dojo`, `%subscribe`, and so on.
Each `test-step` may optionally have expectations.

By default we run `~nec` and `~bud` as virtualships.

## Example usage

Setup; add tests to `%ziggurat`; start virtualships (in `%start-pyro-ships`):
The following starts virtualships and sets up the `%zig` desk on them.
When `%new-project` is called, `%ziggurat` looks for the project/desk, and if it finds it, looks for a [configuration file](#project-configuration) at `/zig/configs/[project-name]/hoon`.
If found, the project is setup according to that configuration.
Else, a default setup is used.
```hoon
:ziggurat &ziggurat-action [%$ ~ %start-pyro-ships ~[~nec ~bud ~wes]]
:ziggurat &ziggurat-action [%zig ~ %new-project ~]

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

As a more real-world example, import the %pokur project (requires https://github.com/dr-frmr/pokur/pull/26 at least to work).

```hoon
|merge %zig our %base
|mount %zig
|merge %pokur our %base
|mount %pokur

::  copy in appropriate files to %zig and %pokur
::  note that we have the proper escrow.jam and gen/sequencer/init.hoon in %ziggurat now, so do not need to do that nonsense

|commit %zig
|commit %pokur

|install our %zig

:ziggurat &ziggurat-action [%$ ~ %start-pyro-ships ~[~nec ~bud ~wes]]
:ziggurat &ziggurat-action [%zig ~ %new-project ~]
-zig!ziggurat-test-subscribe %pokur 1.000

::  after ships are started and %zig dir is installed on them, hit the Backspace key to detatch the ziggurat-test-subscribe thread

::  snapshot in case we want to restore to pre-%pokur-install state
:pyro &pyro-action [%snap-ships /zig-setup-done ~[~nec ~bud ~wes]]

::  set up %pokur, installing on ~nec, ~bud, ~wes, setting up ~nec as host, launching a table on ~bud
:ziggurat &ziggurat-action [%pokur ~ %new-project ~]

::  join the ~bud table from ~wes
:ziggurat &ziggurat-action [%pokur ~ %add-and-queue-test-file `%wes-join-table /zig/test-steps/wes-join-table/hoon]
:ziggurat &ziggurat-action [%$ ~ %run-queue ~]
```

Some other stuff you may want to do:

```hoon
::  if you want to restore to pre-%pokur-install state:
:pyro &pyro-action [%restore-snap /zig-setup-done]

::  if you want to inspect state of apps:
:pyro|dojo ~bud ":pokur +dbug"

::  if you want to join table with wes (you will have to plug in the actual id here):
:pyro|dojo ~wes ":pokur &pokur-player-action [%join-table id=~2023.1.12..01.52.54..382a.0000.0000.0003 buy-in=1.000.000.000.000.000.000 public=%.y]"
:pyro|dojo ~wes ":uqbar &wallet-poke [%submit from=0x5da4.4219.e382.ad70.db07.0a82.12d2.0559.cf8c.b44d hash=[yourhash] gas=[rate=1 bud=1.000.000]]"
:pyro|dojo ~nec ":sequencer|batch"
```


### `send-nec` from the virtualship Dojo

```hoon
:pyro|dojo ~nec ":uqbar &wallet-poke [%transaction from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 contract=0x74.6361.7274.6e6f.632d.7367.697a town=0x0 action=[%give to=0xd6dc.c8ff.7ec5.4416.6d4e.b701.d1a6.8e97.b464.76de amount=123.456 item=0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6]]"
:pyro|dojo ~nec ":uqbar &wallet-poke [%submit from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 hash=0xa99c.4c8e.1c8d.abb8.e870.81e8.8c96.2cf5 gas=[rate=1 bud=1.000.000]]"
:pyro|dojo ~nec ":sequencer|batch"
```

### Interaction with snapshots

```hoon
:pyro &action [%snap-ships /my-snapshot/0 ~[~nec ~bud ~wes]]
:pyro &action [%restore-snap /my-snapshot/0]
:pyro &action [%clear-snap /my-snapshot/0]
```
where the `/my-snapshot/0` here is just a `path` label of the snapshot.

We pre-cache a special `/testnet` snapshot which loads a virtual testnet for you.
Disclaimer: these currently have a bunch of jet mismatches when you boot them.
May be super slow!
This is getting fixed in an OTA soon.
To activate it use
```hoon
:ziggurat &ziggurat-action [%foo %start-pyro-snap /testnet]
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

## `%pyro` ship I/O

### `:pyro|dojo`

You can input arbitrary Dojo commands to running `%pyro` ships by:
```hoon
:pyro|dojo ~nec ":indexer +dbug"
```
and output will be printed to your screen.
The virtual ship operates like a normal ship, so you can maintain Dojo state therein, e.g.,
```hoon
:pyro|dojo ~bud "=ui -build-file /=zig=/sur/zig/indexer/hoon"
:pyro|dojo ~bud ".^(update:ui %gx /=indexer=/batch-order/0x0/noun)"
```

### Scrying

You can also scry into a virtualized ship app by scrying `%pyro`.
There are some weird things about this:
1. All `%i` scries must have a double mark at the end (e.g. `/noun/noun`) must be appended to the scry path because the path you give is used internally by `%pyro` to do its own scry to the virtualship. The doubled marks must match or you must have a `/mar` files with the appropriate arm to transition the inner mark to the outer.
2. The virtualship and the [care](https://developers.urbit.org/reference/arvo/concepts/scry) must be specified at the start of the path.

Here are two examples, the first of a scry to clay for a file, and the second a scry to gall for `%indexer` state:

```hoon
.^(wain %gx /=pyro=/i/~nec/cx/~nec/zig/(scot %da now)/desk/bill/bill)

=ui -build-file /=zig=/sur/zig/indexer/hoon
.^(update:ui %gx /=pyro=/i/~nec/gx/~nec/indexer/(scot %da now)/batch-order/0x0/noun/noun)
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
Examples can be seen in the `zig/test-steps/` dir](https://github.com/uqbar-dao/uqbar-core/tree/067f1552bbcc335db32550733b99338b33c6ed5d/zig/test-steps).

The subject of a `test-steps` is defined by the `/=` imports at the top of the `test-steps` file.
In addition, this subject will be applied for [`custom-step-definitions`](#custom-inputs), so those dependencies must be included in `test-steps`.
Finally, some `test-globals` will be accessible by `test-steps` (see sur/zig/ziggurat.hoon):

`configs:test-globals` is a `(map project-name=@t (map [who=@p what=@tas] @)` (or a `(mip project-name=@t [who=@p what=@tas] @)` for short) that stores general data that can be added to with `%add-config`.
It is loaded with some useful items by default, as well:
* The default testnet address associated with that `@p` is stored at `[project-name=~ who=@p what=%address]`,
* The host running the `%sequencer` for a town given by the `map` value is stored at `[project-name=[~ @t] who=@p what=%sequencer]`.

`test-results:test-globals` are also accessible, so that the results of a previous `test-step` is usable in the current one.
See zig/custom-step-definitions/send-wallet-transaction.hoon for an example of how `test-results:test-globals` can be used.
`test-globals` also includes `our=@p`, `now=@da`, and `project=@tas`.

## Custom inputs

Custom steps are useful for reducing boilerplate when a certain `test-step` is used frequently.
For example, to write to the virtualship testnet, a transaction is sent with a `%wallet-poke`.
However, the transaction must also be signed, and the sequencer must submit a batch before the transaction is posted.
Thus, the following must occur:
1. Scry current pending transactions in the wallet,
2. Send the transaction,
3. Scry newly updated pending transactions in the wallet,
4. Compute the diff on the pending transaction scries to find the our pending transaction hash,
5. Sign that pending transaction and send it to the sequencer,
6. Tell the sequencer to process the batch.

Rather than requiring every virtualship testnet write `test-steps` do the common work, use the `custom-write-step` [`zig/custom-step-definitions/send-wallet-transaction.hoon`](https://github.com/uqbar-dao/uqbar-core/blob/077403cc2eef02baea59f3d6f8b0e08fb7fd78a3/zig/custom-step-definitions/send-wallet-transaction.hoon).
For an example of usage, see [`zig/test-steps/send-nec.hoon`](https://github.com/uqbar-dao/uqbar-core/blob/077403cc2eef02baea59f3d6f8b0e08fb7fd78a3/zig/test-steps/send-nec.hoon)

More examples can be found in the [`zig/custom-step-definitions/` dir](https://github.com/uqbar-dao/uqbar-core/tree/077403cc2eef02baea59f3d6f8b0e08fb7fd78a3/zig/custom-step-definitions).

Custom steps are labeled by a `tag=@tas` -- the name of the step that will be referenced when calling it.
A custom step is a core whose `$` arm takes in arguments and an `expected` (either a `@t` if a `custom-read-step` or a `(list test-read-step)` if a `custom-write-step`) and must return a `(list test-step)`.

## Deploying contracts

Contracts can be deployed to the virtualship testnet for a project using the `%deploy-contract` poke:
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

Arm name                     | Return type               | Description
---------------------------- | ------------------------- | -----------
`+make-config`               | `config:zig`              | Set global state for the project, accessible during `test-steps`.
`+make-virtualships-to-sync` | `(list @p)`               | Set virtualships to mirror the project desk on.
`+make-install`              | `?`                       | Install the mirrored desk on synced virtualships?
`+make-start-apps`           | `(list @tas)`             | Additionaly apps to start in the project on synced ships (that are not included in the project's `desk.bill`).
`+make-setup`                | `(map @p test-steps:zig)` | Set the initial state on synced virtualships by running these `test-steps`.
