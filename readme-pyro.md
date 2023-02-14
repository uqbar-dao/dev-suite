# `%pyro` Documentation
Last updated as of Feb 07, 2023.

##  Contents
* [Quick Start](#quick-start)
* [Architecture](#architecture)
* [`%pyro` inputs](#pyro-inputs)
* [`%pyro` outputs](#pyro-outputs)
* [`%pyro` threads](#pyro-threads)

## Quick Start
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

## Architecture
`%pyro` simulates individual ships, handles their state, their I/O, and snapshots

`%pyre` is the virtual runtime for %pyro ships. It handles ames sends, behn timers, iris requests, eyre responses, and dojo outputs. Not all runtime functionality is implemented - just the most important pieces.

## `%pyro` inputs
Just like a normal ship, the only interface for interacting with a `%pyro` ship is to pass it `$task-arvo`s. Using raw `$task`s requires a good knowledge of `lull.hoon`, so the most common I/O is implemented in `/lib/pyro/pyro.hoon` and `/gen/pyro/` for your convenience.

## `%pyro` outputs
###  `$unix-effect`s
All `$unix-effect`s can be subscribed to by an app or thread. However, `%pyre` automatically handles the most important `$unix-effects` for you. Handling unix effects by yourself in an app/thread requires a good knowledge of `lull.hoon` - to look for a specific output, look at each vane's `$gift`s.
### Scries
You can scry into a `%pyro` ship. Anthing that you can scry out of a normal ship, you can scry out of a `%pyro` ship.
```hoon
.^(wain %gx /=pyro=/i/~nec/cx/~nec/zig/(scot %da now)/desk/bill/bill)
```
Note:
1. All scries into `%pyro` ships must have a double mark at the end (e.g. `/noun/noun`, `/bill/bill`, etc.)
2. The virtualship and the [care](https://developers.urbit.org/reference/arvo/concepts/scry) must be specified at the start of the path.

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