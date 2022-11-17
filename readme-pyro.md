# `%pyro` and `%ziggurat` test suite documentation

Document describes current best practices for use and testing of `%pyro` and `%ziggurat`.
As these projects are in a state of heavy development, this document will likely go out of date unless updated.

Last updated as of 221110.

## Broad overview

`%ziggurat` is the backend for an IDE and testing environment.
`%pyro` is a ship virtualizer used to run a network of virtual ships and used by `%ziggurat`.

`%pyro` requires a pill to initialize virtual ships.
It is paired with `%pyre`, an app that plays the role of the runtime for `%pyro`.
For example, `%pyre` picks up ames packets sent from one virtualship and passes them to the intended recipient.

After `%pyro` has loaded a pill, the initial startup of ships also takes some time.
However, subsequent retarts of those ships takes much less time.

`%pyro` can snapshot and load ship state.

`%ziggurat` must be loaded with a series of `test-steps` before they can be run.
These `test-steps` are sequences of steps, such as `%poke`, `%scry`, `%dojo`, `%subscribe`, and so on.
Each `test-step` may optionally have expectations.

By default we run `~nec` and `~bud` as virtualships.

## Building the `%pyro` pill

A pill can either be freshly built and loaded via
```hoon
:pyro &pill +zig!solid %base %zig
```

or can be output to `.urb/put/pill.pill` using
```hoon
.pill/pill +zig!solid %base %zig
```

It is recommended to build the pill and output to the filesystem, copy it to `ziggurat/lib/py/pill.pill`, and then it will be automatically loaded.
However, because of an Urbit bug, you must
```hoon
|meld
```
before booting any virtualships if you get the pill from the filesystem or your virtualships will boot EXTREMELY slowly.

Only newly created ships will use the most recently-supplied pill, so if you replace an existing pill, you need to restart ships if you want them to use it.

### Other considerations

#### Ames speedboost on fakeships

Ames divides packets into a certain size based on what routers on the internet want.
You can speed up ames by reducing the number (increasing the size) of packets, but only on a fakeship.
When planning to dev on a fakeship, find-and-replace `13` to `23` in arvo/sys/vane/ames.hoon`.
After this change, create your pill.
For large ames sends, this will significantly speed things up.

#### `desk.ship`

The distributor of a desk is specified in `desk.ship`.
When booting from a pill, the new ship will try to contact that ship and ask for a remote install.
To be performant you must have `desk.ship` be one of the ships you are running in the virtual net, or your ships will constantly ping that offline ship.
Deleting `desk.ship` defaults to `~zod`.
A downside of specifying a live ship in `desk.ship` is that your ship will succeed at remote installing your repo, which takes time.
This indicates we should either:
1. Update how we make pills/load in `%zig` desk,
2. Get Tlon to accept an update to `desk.ship` behavior where no `desk.ship` defaults to no remote install on pill boot rather than `~zod`.
3. Load in a `.jam` file `+on-init` that has pre-booted ships, if possible (research TODO).

## Inputs to `%pyro` ships

### `:pyro|dojo`

You can input arbitrary Dojo commands to running `%pyro` ships by:
```hoon
:pyro|dojo ~nec "indexer +dbug"
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
=virtualship ~nec

;;((unit wain) .^(noun %gx /=pyro=/i/(scot %p virtualship)/cx/(scot %p virtualship)/zig/(scot %da now)/desk/bill/noun))

=ui -build-file /=zig=/sur/zig/indexer/hoon
;;((unit update:ui) .^(noun %gx /=pyro=/i/(scot %p virtualship)/gx/(scot %p virtualship)/indexer/(scot %da now)/batch-order/0x0/noun/noun))
```

To avoid the overly-verbose scries, you can also use the `+scry` generator which will automatically format agent scries (care of `%gx`) into pyro-ships.
```
+zig!pyro/scry ~nec %sequencer /status/noun 
```

## Example usage

Setup; add tests to `%ziggurat`; start virtualships (in `%start-pyro-ships`):
```hoon
|meld

=zig -build-file /=zig=/sur/zig/ziggurat/hoon
=rollup-host ~nec
:ziggurat &ziggurat-action [%foo %new-project 0x1234.5678]

=setup-nec `test-steps:zig`~[[%dojo [rollup-host ':rollup|activate'] ~] [%dojo [rollup-host ':sequencer|init our 0x0 0xc9f8.722e.78ae.2e83.0dd9.e8b9.db20.f36a.1bc4.c704.4758.6825.c463.1ab6.daee.e608'] ~] [%poke [rollup-host %indexer %set-sequencer '[our %sequencer]'] ~] [%poke [rollup-host %indexer %set-rollup '[our %rollup]'] ~] [%poke [rollup-host %uqbar %wallet-poke '[%import-seed \'uphold apology rubber cash parade wonder shuffle blast delay differ help priority bleak ugly fragile flip surge shield shed mistake matrix hold foam shove\' \'squid\' \'nickname\']'] ~]]
=setup-bud `test-steps:zig`~[[%poke [~bud %indexer %set-sequencer '[~nec %sequencer]'] ~] [%poke [~bud %indexer %set-rollup '[~nec %rollup]'] ~] [%poke [~bud %indexer %indexer-bootstrap '[~nec %indexer]'] ~] [%poke [~bud %uqbar %wallet-poke '[%import-seed \'post fitness extend exit crack question answer fruit donkey quality emotion draw section width emotion leg settle bulb zero learn solution dutch target kidney\' \'squid\' \'nickname\']'] ~]]
=setup `test-steps:zig`(weld setup-nec setup-bud)
:ziggurat &ziggurat-action [%foo %add-test `%setup setup]
=scry-nec `test-steps:zig`~[[%scry [~nec /zig/sur/zig/indexer/hoon 'update:indexer' %gx %indexer /batch-order/0x0/noun] '[%batch-order batch-order=~[0xd85a.d919.9806.cbc2.b841.eb0d.854d.22af]]']]
:ziggurat &ziggurat-action [%foo %add-test `%scry-nec scry-nec]
=scry-bud `test-steps:zig`~[[%scry [~bud /zig/sur/zig/indexer/hoon 'update:indexer' %gx %indexer /batch-order/0x0/noun] '[%batch-order batch-order=~[0xd85a.d919.9806.cbc2.b841.eb0d.854d.22af]]']]
:ziggurat &ziggurat-action [%foo %add-test `%scry-bud scry-bud]
=scry-clay `test-steps:zig`~[[%scry [~bud ~ 'wain' %cx %base /desk/bill] '<|acme azimuth dbug dojo eth-watcher hood herm lens ping spider|>']]
:ziggurat &ziggurat-action [%foo %add-test `%scry-clay scry-clay]
=send-nec `test-steps:zig`~[[%poke [rollup-host %uqbar %wallet-poke '[%transaction from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 contract=0x74.6361.7274.6e6f.632d.7367.697a town=0x0 action=[%give to=0xd6dc.c8ff.7ec5.4416.6d4e.b701.d1a6.8e97.b464.76de amount=123.456 item=0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6]]'] ~] [%poke [rollup-host %uqbar %wallet-poke '[%submit from=0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70 hash=0xa99c.4c8e.1c8d.abb8.e870.81e8.8c96.2cf5 gas=[rate=1 bud=1.000.000]]'] ~] [%dojo [~nec ':sequencer|batch'] `(list test-read-step:zig)`~[[%scry [~nec /zig/sur/zig/indexer/hoon 'update:indexer' %gx %indexer /newest/item/0x89a0.89d8.dddf.d13a.418c.0d93.d4b4.e7c7.637a.d56c.96c0.7f91.3a14.8174.c7a7.71e6/noun] '']]]]
:ziggurat &ziggurat-action [%foo %add-test `%send-nec send-nec]

=send-nec-id 0x49.6b9f.c2dc.2641.5c66.e64a.848b.80ee
=scry-clay-id 0x29de.35b5.a26d.c49c.a39c.7437.c399.c316
=scry-bud-id 0xddd5.d31d.72c2.dbe0.42fe.7ae1.3d17.8db5
=scry-nec-id 0x9fb7.15f6.364d.dfd0.42ea.540e.57cd.daf8
=setup-id 0xa253.baf1.f666.df41.ab31.fe25.2de6.5d20

:ziggurat &ziggurat-action [%foo %start-pyro-ships ~]
```

Run some stuff on virtualships:
```hoon
:ziggurat &ziggurat-action [%foo %run-test setup-id 1 1.000.000]

:ziggurat &ziggurat-action [%foo %run-test scry-bud-id 1 1.000.000]

:ziggurat &ziggurat-action [%foo %run-test scry-nec-id 1 1.000.000]

:ziggurat &ziggurat-action [%foo %run-test scry-clay-id 1 1.000.000]

:ziggurat &ziggurat-action [%foo %run-test send-nec-id 1 1.000.000]
```

Tell `%indexer` not to run any tests right now.
```hoon
:ziggurat &ziggurat-action [%foo %stop-pyro-ships ~]
```

To reset virtualships to initial state:
```hoon
:ziggurat &ziggurat-action [%foo %stop-pyro-ships ~]
:ziggurat &ziggurat-action [%foo %start-pyro-ships ~]
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
