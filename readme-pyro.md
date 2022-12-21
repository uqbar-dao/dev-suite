# `%pyro` and `%ziggurat` test suite documentation

Document describes current best practices for use and testing of `%pyro` and `%ziggurat`.
As these projects are in a state of heavy development, this document will likely go out of date unless updated.

Last updated as of Dec 2 2022

## Broad overview

`%ziggurat` is the backend for an IDE and testing environment.
`%pyro` is a ship virtualizer used to run a network of virtual ships and used by `%ziggurat`.

`%pyro` requires a pill to initialize virtual ships.
It is paired with `%pyre`, an app that plays the role of the runtime for `%pyro`.
For example, `%pyre` picks up ames packets sent from one virtualship and passes them to the intended recipient.

After `%pyro` has loaded a pill, the initial startup of ships also takes some time.
However, subsequent restarts of those ships takes much less time. Furthermore, you can cache the state of an entire fleet.

`%pyro` can snapshot and load ship state.

`%ziggurat` must be loaded with a series of `test-steps` before they can be run.
These `test-steps` are sequences of steps, such as `%poke`, `%scry`, `%dojo`, `%subscribe`, and so on.
Each `test-step` may optionally have expectations.

By default we run `~nec` and `~bud` as virtualships.

## Building the `%pyro` pill

A pill can either be freshly built and loaded into pyro, or outputted to unix to share around the network
```hoon
:pyro &pill +zig!solid %base %zig

.pill/pill +zig!solid %base %zig
```

The latter is recommended - we store ours in `zig/snapshots/pill.pill`, and ship it with the ziggurat desk.

Only newly created ships will use the most recently-supplied pill, so if you replace an existing pill, you need to restart ships if you want them to use it.

## Other considerations

### Ames speedboost on fakeships

Ames divides packets into ~1kB because that is what routers on the internet handle.
You can speed up virtual ames by increasing the size of packets, but only on a fakeship.
When planning to dev on a fakeship, find-and-replace `13` to `23` in arvo/sys/vane/ames.hoon`.
After this change, create your pill.
For large ames sends (e.g. downloading a desk), this will significantly speed things up.

### `desk.ship`

The distributor of a desk is specified in `desk.ship`.
When booting from a pill, the new ship will try to contact that ship and ask for a remote install.
To be performant you must have `desk.ship` be one of the ships you are running in the virtual net, or your ships will constantly ping that offline ship.
Deleting `desk.ship` defaults to `~zod`.
A downside of specifying a live ship in `desk.ship` is that your ship will succeed at remote installing your repo, which takes time.
This indicates we should either:
1. Update how we make pills/load in `%zig` desk,
2. Get Tlon to accept an update to `desk.ship` behavior where no `desk.ship` defaults to no remote install on pill boot rather than `~zod` (the bring-your-own-boot-sequence (BYOBS) project should eliminate most of this toruble soon)
3. Load in a `.jam` file `+on-init` that has pre-booted ships, if possible (research TODO).

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
1. Output must be as a `noun`; you can subsequently `;;`, but must get a `noun` back at first.
2. The returned `noun` is a `unit`.
3. An additional `/noun` must be appended to the scry path because the path you give is used internally by `%pyro` to do its own scry to the virtualship.
4. The virtualship and the [care](https://developers.urbit.org/reference/arvo/concepts/scry) must be specified at the start of the path.

Here are two examples, the first of a scry to clay for a file, and the second a scry to gall for `%indexer` state:

```hoon
;;((unit wain) .^(noun %gx /=pyro=/i/~nec/cx/~nec/zig/(scot %da now)/desk/bill/noun))

=ui -build-file /=zig=/sur/zig/indexer/hoon
;;((unit update:ui) .^(noun %gx /=pyro=/i/~nec/gx/~nec/indexer/(scot %da now)/batch-order/0x0/noun/noun))
```

To avoid the overly-verbose scries, you can also use the `+scry` generator which will automatically format agent scries (care of `%gx`) into pyro-ships.
```
+zig!pyro/scry ~nec %sequencer /status/noun 
```

##  Test steps

`test-steps` are sequences of `test-step`s: a command to do something that optionally has an expected result.
E.g., a `test-step` can be a `%poke` or a `%scry`.
A `%scry` `test-step`, an example of a read from state, has an `expected` field that is a `@t`: the expectation of output as a result of completing that scry.
In contract, a `test-step` like a `%poke` that writes to state has an `expected` field that is a `list` of read steps: a single `%poke` can have cascading effects and so it is important to have the ability to query multiple times.

`test-steps` are defined in the `$` arm of a core.
Examples can be seen in the `zig/test-steps/` dir](https://github.com/uqbar-dao/uqbar-core/tree/067f1552bbcc335db32550733b99338b33c6ed5d/zig/test-steps).

The subject of a `test-steps` is defined by the `/=` imports at the top of the `test-steps` file.
In addition, this subject will be applied for [`custom-step-definitions`](#custom-inputs), so those dependencies must be included in `test-steps`.
Finally, some `test-globals` will be accessible by `test-steps`.
`addresses:test-globals` is the `(map @p @ux)` defined in `%ziggurat` app state and set with the `%set-virtualnet-addresses` action.
The `addresses:test-globals` map is useful for easy access and pairing between virtualships and their testnet addresses.
`test-results:` are also accessible, so that the results of a previous `test-step` is usable in the current one (TODO).
`test-globals` also includes `our`, `now`, and `project`.

## Deploying contracts

Contracts can be deployed to the virtualship testnet for a project using the `%deploy-contract` poke:
```hoon
:ziggurat &ziggurat-action [%foo %deploy-contract town-id=0x0 /con/compiled/nft/jam]
```

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

## `dbug` dashboard

TODO

## Example usage

Setup; add tests to `%ziggurat`; start virtualships (in `%start-pyro-ships`):
```hoon
:ziggurat &ziggurat-action [%foo %new-project ~]

::  Setup virtaulship testnet, like following [README](https://github.com/uqbar-dao/uqbar-core/blob/master/readme.md).
:ziggurat &ziggurat-action [%foo %add-and-queue-test `%setup /zig/test-steps/setup/hoon]

:ziggurat &ziggurat-action [%foo %add-and-queue-test `%scry-nec /zig/test-steps/scry-nec/hoon]
:ziggurat &ziggurat-action [%foo %add-and-queue-test `%scry-bud /zig/test-steps/scry-bud/hoon]
:ziggurat &ziggurat-action [%foo %add-and-queue-test `%scry-clay /zig/test-steps/scry-clay/hoon]

:ziggurat &ziggurat-action [%foo %add-and-queue-test `%subscribe-nec /zig/test-steps/subscribe-nec/hoon]

::  The same ZIGS send done in two ways:
::   Using a custom-step-definition and pokes,
::   Using Dojo commands.
:ziggurat &ziggurat-action [%foo %add-and-queue-test `%send-nec /zig/test-steps/send-nec/hoon]
:ziggurat &ziggurat-action [%foo %add-and-queue-test `%send-nec-dojo /zig/test-steps/send-nec-dojo/hoon]

:ziggurat &ziggurat-action [%foo %start-pyro-ships ~[~nec ~bud]]
:ziggurat &ziggurat-action [%$ %run-queue ~]

::  Tell `%ziggurat` not to run any more tests right now.
::   Also resets state when `%start-pyro-ships` is called again.
:ziggurat &ziggurat-action [%foo %stop-pyro-ships ~]
```

An alternative to `send-nec`:
```hoon
:pyro|dojo ~nec ":uqbar &wallet-poke [%transaction from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 contract=0x74.6361.7274.6e6f.632d.7367.697a town=0x0 action=[%give to=0xd6dc.c8ff.7ec5.4416.6d4e.b701.d1a6.8e97.b464.76de amount=123.456 item=0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6]]"
:pyro|dojo ~nec ":uqbar &wallet-poke [%submit from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 hash=0xa99c.4c8e.1c8d.abb8.e870.81e8.8c96.2cf5 gas=[rate=1 bud=1.000.000]]"
:pyro|dojo ~nec ":sequencer|batch"
```

To interact with snapshots:
```hoon
:pyro &action [%snap-ships /my-snapshot/0 ~[~nec ~bud]]
:pyro &action [%restore-snap /my-snapshot/0]
:pyro &action [%clear-snap /my-snapshot/0]
```
where the `/my-snapshot/0` here is just a `path` label of the snapshot.

We pre-cache a special `/testnet` snapshot which loads a virtual testnet for you.
Disclaimer: these currently have a bunch of jet mismatches when you boot them.
May be super slow!
This is getting fixed in an OTA soon.
To activate it use
```
:ziggurat &ziggurat-action [%foo %start-pyro-snap /testnet]
```

The following makes use of the `addresses` test global, which maps from virtualships to their corresponding virtualnet addresses:
```hoon
:ziggurat &ziggurat-action [%foo %add-and-run-test `%send-nec ~[/zig/sur/zig/indexer/hoon] send-nec:help]
```

However, here it does not yet work because `%poke-wallet-transaction` passes in the `transaction` as an `@t` and it is never properly transformed (TODO):
```hoon
:ziggurat &ziggurat-action [%foo %add-and-run-test `%send-nec-custom ~[/zig/sur/zig/indexer/hoon] send-nec-custom:help]
```

It also does not yet work for transforming `%dojo` arguments: another TODO.

## Configuring Testnet Snapshot For Quick-Boot

Testnet snap last updated: Dec 6 2022

Note that this will create a bunch of jet mismatch errors because jetted code is not currently portable (easily).
If you find that the ships are running slowly, and can't figure out why, repeating the steps below to recreate the default testnet state is a good idea.
TODO: turn this into a thread

First go into ames - ctrl+F "13" and replace with "23" to boost the packet size (see [above](#ames-speedboost-on-fakeships) for more details), then:

```hoon
|commit %base
:pyro &pill +zig!solid %base %zig
:pyro|init ~nec
:pyro|dojo ~nec ":rollup|activate"
:pyro|dojo ~nec ":sequencer|init our 0x0 0xc9f8.722e.78ae.2e83.0dd9.e8b9.db20.f36a.1bc4.c704.4758.6825.c463.1ab6.daee.e608"
:pyro|dojo ~nec ":indexer &set-sequencer [our %sequencer]"
:pyro|dojo ~nec ":indexer &set-rollup [our %rollup]"
:pyro|dojo ~nec ":uqbar &wallet-poke [%import-seed 'uphold apology rubber cash parade wonder shuffle blast delay differ help priority bleak ugly fragile flip surge shield shed mistake matrix hold foam shove' 'squid' 'nickname]"

:pyro|init ~bud
:pyro|dojo ~bud ":indexer &set-sequencer [~nec %sequencer]"
:pyro|dojo ~bud ":indexer &set-rollup [~nec %rollup]"
:pyro|dojo ~bud ":indexer &indexer-bootstrap [~nec %indexer]"
:pyro|dojo ~nec ":uqbar &wallet-poke [%import-seed 'post fitness extend exit crack question answer fruit donkey quality emotion draw section width emotion leg settle bulb zero learn solution dutch target kidney' 'squid' 'nickname]"

:pyro &action [%snap-ships /testnet ~[~nec ~bud]]
:pyro &action [%export-snap /testnet]
|unmount %zig
|mount %zig
```
then move `zig/snapshots/testnet.jam` into this repo
