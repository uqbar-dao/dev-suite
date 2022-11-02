::
::  Tests for multisig.hoon
::
/-  zink, mill
/+  *test, smart=zig-sys-smart, *sequencer, merk
/*  smart-lib-noun     %noun  /lib/zig/sys/smart-lib/noun
/*  zink-cax-noun      %noun  /lib/zig/sys/hash-cache/noun
/*  multisig-contract  %noun  /con/compiled/multisig/noun
/*  zigs-contract      %noun  /con/compiled/zigs/noun
|%
::
::  constants / dummy info for mill
::
++  big  (bi:merk id:smart item:smart)  ::  merkle engine for granary
++  pig  (bi:merk id:smart @ud)          ::                for populace
++  town-id   0x0
++  batch-num  1
++  fake-sig  [0 0 0]
++  mil
  %~  mill  mill
  :+    ;;(vase (cue q.q.smart-lib-noun))
    ;;((map * @) (cue q.q.zink-cax-noun))
  %.y
::
+$  single-result
  [fee=@ud =land burned=granary =errorcode:smart hits=(list hints:zink) =crow:smart]
::
::  fake data
::
++  miller  ^-  caller:smart
  [0x24c.23b9.8535.cd5a.0645.5486.69fb.afbf.095e.fcc0 1 0x0]  ::  zigs account not used
++  holder-1  0xd387.95ec.b77f.b88e.c577.6c20.d470.d13c.8d53.2169
++  holder-2  0xface.face.face.face.face.face.face.face.face.face
++  holder-3  0x1c9b.638f.9e4e.c79f.e0da.fa2f.296c.54be.5092.e47a
++  caller-1  ^-  caller:smart  [holder-1 1 (make-id:zigs holder-1)]
++  caller-2  ^-  caller:smart  [holder-2 1 (make-id:zigs holder-2)]
++  caller-3  ^-  caller:smart  [holder-3 1 (make-id:zigs holder-3)]
::
++  zigs
  |%
  ++  wheat
    ^-  item:smart
    =/  cont  ;;([bat=* pay=*] (cue q.q.zigs-contract))
    =/  interface=lumps:smart  ~
    =/  types=lumps:smart  ~
    :*  %|
        `cont
        interface
        types
        zigs-contract-id:smart  ::  id
        zigs-contract-id:smart  ::  lord
        zigs-contract-id:smart  ::  holder
        town-id
    ==
  ++  make-id
    |=  holder=id:smart
    (fry-data:smart zigs-contract-id:smart holder town-id `@`'zigs')
  ++  make-account
    |=  [holder=id:smart amt=@ud]
    ^-  item:smart
    :*  %&  `@`'zigs'  %account
        [amt ~ `@ux`'zigs-metadata-id']
        (make-id holder)
        zigs-contract-id:smart
        holder
        town-id
    ==
  --
::
++  multisig
  |%
  ++  wheat
    ^-  item:smart
    =/  cont  ;;([bat=* pay=*] (cue q.q.multisig-contract))
    =/  interface=lumps:smart  ~
    =/  types=lumps:smart  ~
    :*  %|
        `cont
        interface
        types
        0xdada.dada  ::  id
        0xdada.dada  ::  lord
        0xdada.dada  ::  holder
        town-id
    ==
  ++  id
    (fry-data:smart id.p:wheat:multisig id.p:wheat:multisig town-id 0)
  ++  proposal-1
    :^  [id.p:wheat:multisig town-id [%add-member id holder-3]]^~
    ~  0  0
  ++  proposal-2
    :^  [id.p:wheat:multisig town-id [%remove-member id holder-3]]^~
    ~  0  0
  ++  proposal-3
    :^  [id.p:wheat:multisig town-id [%set-threshold id 2]]^~
    ~  0  0
  ++  proposal-4
    :^  [id.p:wheat:zigs town-id [%give 0xdead.beef 123.456 (make-id:zigs 0xdada.dada) ~]]^~
    ~  0  0
  ++  grain
    ^-  item:smart
    =/  members
      %-  ~(gas pn:smart *(pset:smart address:smart))
      ~[holder-1 holder-2]
    =/  pending
      %-  ~(gas py:smart *(pmap:smart @ux proposal))
      :~  [0x1 proposal-1]
          [0x2 proposal-2]
          [0x3 proposal-3]
          [0x4 proposal-4]
      ==
    :*  %&  0  %multisig
        [members 2 pending]
        id
        id.p:wheat:multisig
        id.p:wheat:multisig
        town-id
    ==
  --
::
++  fake-granary
  ^-  granary
  %+  gas:big  *(merk:merk id:smart item:smart)
  %+  turn
    :~  wheat:zigs
        wheat:multisig
        grain:multisig
        (make-account:zigs holder-1 300.000.000)
        (make-account:zigs holder-2 300.000.000)
        (make-account:zigs holder-3 300.000.000)
        (make-account:zigs 0xdada.dada 300.000.000)
    ==
  |=(=item:smart [id.p.grain grain])
::
++  fake-populace
  ^-  populace
  %+  gas:pig  *(merk:merk id:smart @ud)
  ~[[id:caller-1 0]]
++  fake-land
  ^-  land
  [fake-granary fake-populace]
::
::  types
::
+$  proposal
  $:  calls=(list [to=id:smart town=id:smart =calldata:smart])
      votes=(pmap:smart address:smart ?)
      ayes=@ud
      nays=@ud
  ==
::
+$  multisig-state
  $:  members=(pset:smart address:smart)
      threshold=@ud
      pending=(pmap:smart @ux proposal)
  ==
::
::  begin tests
::
::  tests for %create
::
++  test-create-already-exists
  =/  member-set  (~(gas pn:smart *(pset:smart address:smart)) ~[id:caller-1])
  =/  =calldata:smart  [%create 1 member-set]
  =/  shel=shell:smart
    [caller-1 ~ id.p:wheat:multisig 1 1.000.000 town-id 0]
  =/  res=single-result
    %+  ~(mill mil miller town-id batch-num)
      fake-land
    `transaction:smart`[fake-sig shel yolk]
  ::
  %+  expect-eq
  !>(%7)  !>(errorcode.res)
::
++  test-create-no-members
  =/  =calldata:smart  [%create 0 ~]
  =/  shel=shell:smart
    [caller-1 ~ id.p:wheat:multisig 1 1.000.000 town-id 0]
  =/  res=single-result
    %+  ~(mill mil miller town-id batch-num)
      [(del:big fake-granary id:multisig) fake-populace]
    `transaction:smart`[fake-sig shel yolk]
  ::
  %+  expect-eq
  !>(%6)  !>(errorcode.res)
::
++  test-create-high-threshold
  =/  member-set  (~(gas pn:smart *(pset:smart address:smart)) ~[id:caller-1])
  =/  =calldata:smart  [%create 2 ~]
  =/  shel=shell:smart
    [caller-1 ~ id.p:wheat:multisig 1 1.000.000 town-id 0]
  =/  res=single-result
    %+  ~(mill mil miller town-id batch-num)
      [(del:big fake-granary id:multisig) fake-populace]
    `transaction:smart`[fake-sig shel yolk]
  ::
  %+  expect-eq
  !>(%6)  !>(errorcode.res)
::
++  test-create-many-members
  =/  member-set
    %-  ~(gas pn:smart *(pset:smart address:smart))
    ~[id:caller-1 id:caller-2 id:caller-3 0xdead 0xbeef 0xcafe 0xbabe]
  =/  =calldata:smart  [%create 4 member-set]
  =/  shel=shell:smart
    [caller-1 ~ id.p:wheat:multisig 1 1.000.000 town-id 0]
  =/  res=single-result
    %+  ~(mill mil miller town-id batch-num)
      [(del:big fake-granary id:multisig) fake-populace]
    `transaction:smart`[fake-sig shel yolk]
  ::
  =/  correct-id
    (fry-data:smart id.p:wheat:multisig id.p:wheat:multisig town-id 0)
  =/  correct
    ^-  item:smart
    :*  %&  0  %multisig
        [member-set 4 ~]
        correct-id
        id.p:wheat:multisig
        id.p:wheat:multisig
        town-id
    ==
  ::
  ;:  weld
  ::  assert that our call went through
    %+  expect-eq
    !>(%0)  !>(errorcode.res)
  ::  assert new contract grain was created properly
    %+  expect-eq
      !>(correct)
    !>((got:big p.land.res correct-id))
  ==
::
::  tests for %vote
::
++  test-vote-not-member
  =/  =calldata:smart  [%vote id:multisig 0x1 %.y]
  =/  shel=shell:smart
    [caller-3 ~ id.p:wheat:multisig 1 1.000.000 town-id 0]
  =/  res=single-result
    %+  ~(mill mil miller town-id batch-num)
      fake-land
    `transaction:smart`[fake-sig shel yolk]
  ::
  %+  expect-eq
  !>(%6)  !>(errorcode.res)
::
++  test-vote-no-proposal
  =/  =calldata:smart  [%vote id:multisig 0x6789 %.y]
  =/  shel=shell:smart
    [caller-1 ~ id.p:wheat:multisig 1 1.000.000 town-id 0]
  =/  res=single-result
    %+  ~(mill mil miller town-id batch-num)
      fake-land
    `transaction:smart`[fake-sig shel yolk]
  ::
  %+  expect-eq
  !>(%6)  !>(errorcode.res)
::
++  test-vote-aye
  =/  =calldata:smart  [%vote id:multisig 0x1 %.y]
  =/  shel=shell:smart
    [caller-1 ~ id.p:wheat:multisig 1 1.000.000 town-id 0]
  =/  res=single-result
    %+  ~(mill mil miller town-id batch-num)
      fake-land
    `transaction:smart`[fake-sig shel yolk]
  =/  correct-proposal
    :^  [id.p:wheat:multisig town-id [%add-member id:multisig holder-3]]^~
      %-  ~(gas py:smart *(pmap:smart address:smart ?))
      [holder-1 %.y]^~
    1  0
  ::
  ;:  weld
    %+  expect-eq
    !>(%0)  !>(errorcode.res)
  ::
    %+  expect-eq
      !>(correct-proposal)
    !>  =+  (got:big p.land.res id:multisig)
        =+  data:(husk:smart multisig-state - ~ ~)
        (~(got py:smart pending.-) 0x1)
  ==
::
++  test-vote-nay
  =/  =calldata:smart  [%vote id:multisig 0x1 %.n]
  =/  shel=shell:smart
    [caller-1 ~ id.p:wheat:multisig 1 1.000.000 town-id 0]
  =/  res=single-result
    %+  ~(mill mil miller town-id batch-num)
      fake-land
    `transaction:smart`[fake-sig shel yolk]
  ::  proposal will be removed
  ;:  weld
    %+  expect-eq
    !>(%0)  !>(errorcode.res)
  ::
    %+  expect-eq
      !>(%.n)
    !>  =+  (got:big p.land.res id:multisig)
        =+  data:(husk:smart multisig-state - ~ ~)
        (~(has py:smart pending.-) 0x1)
  ==
::
++  test-vote-run
  =/  =calldata:smart  [%vote id:multisig 0x1 %.y]
  =/  shel-1=shell:smart
    [caller-1 ~ id.p:wheat:multisig 1 1.000.000 town-id 0]
  =/  shel-2=shell:smart
    [caller-2 ~ id.p:wheat:multisig 1 1.000.000 town-id 0]
  =/  =basket:mill
    %-  silt
    :~  [(shag:smart [shel-1 yolk]) [fake-sig shel-1 yolk]]
        [(shag:smart [shel-2 yolk]) [fake-sig shel-2 yolk]]
    ==
  =/  res=[state-transition:mill rejected=carton:mill]
    %-  ~(mill-all mil miller town-id batch-num)
    [fake-land basket 256]
  ::
  =/  correct
    ^-  item:smart
    :*  %&  0  %multisig
        :+  (~(gas pn:smart *(pset:smart address:smart)) ~[holder-1 holder-2 holder-3])
          2
        %-  ~(gas py:smart *(pmap:smart @ux proposal))
        :~  [0x2 proposal-2:multisig]
            [0x3 proposal-3:multisig]
            [0x4 proposal-4:multisig]
        ==
        id:multisig
        id.p:wheat:multisig
        id.p:wheat:multisig
        town-id
    ==
  ::
  %+  expect-eq
    !>(correct)
  !>((got:big p.land.res id:multisig))
::
::  tests for %propose
::
++  test-propose
  =/  my-proposal
    [id.p:wheat:multisig town-id [%add-member id:multisig 0xdead.beef]]^~
  =/  proposal-hash
    (shag:smart my-proposal)
  =/  =calldata:smart
    [%propose id:multisig my-proposal]
  =/  shel=shell:smart
    [caller-1 ~ id.p:wheat:multisig 1 1.000.000 town-id 0]
  =/  res=single-result
    %+  ~(mill mil miller town-id batch-num)
      fake-land
    `transaction:smart`[fake-sig shel yolk]
  =/  correct-proposal
    :^  my-proposal
      %-  ~(gas py:smart *(pmap:smart address:smart ?))
      [id:caller-1 %.y]^~
    1  0
  ::
  ;:  weld
    %+  expect-eq
    !>(%0)  !>(errorcode.res)
  ::
    %+  expect-eq
      !>(correct-proposal)
    !>  =+  (got:big p.land.res id:multisig)
        =+  data:(husk:smart multisig-state - ~ ~)
        (~(got py:smart pending.-) proposal-hash)
  ==
::
++  test-propose-not-member
  =/  my-proposal
    [id.p:wheat:multisig town-id [%add-member id:multisig 0xdead.beef]]^~
  =/  =calldata:smart  [%propose id:multisig my-proposal]
  =/  shel=shell:smart
    [caller-3 ~ id.p:wheat:multisig 1 1.000.000 town-id 0]
  =/  res=single-result
    %+  ~(mill mil miller town-id batch-num)
      fake-land
    `transaction:smart`[fake-sig shel yolk]
  ::
  %+  expect-eq
  !>(%6)  !>(errorcode.res)
::
++  test-proposal-4
  =/  =calldata:smart  [%vote id:multisig 0x4 %.y]
  =/  shel-1=shell:smart
    [caller-1 ~ id.p:wheat:multisig 1 1.000.000 town-id 0]
  =/  shel-2=shell:smart
    [caller-2 ~ id.p:wheat:multisig 1 1.000.000 town-id 0]
  =/  =basket:mill
    %-  silt
    :~  [(shag:smart [shel-1 yolk]) [fake-sig shel-1 yolk]]
        [(shag:smart [shel-2 yolk]) [fake-sig shel-2 yolk]]
    ==
  =/  res=[state-transition:mill rejected=carton:mill]
    %-  ~(mill-all mil miller town-id batch-num)
    [fake-land basket 256]
  ::
  =/  correct
    ^-  item:smart
    :*  %&  0  %multisig
        :+  (~(gas pn:smart *(pset:smart address:smart)) ~[holder-1 holder-2])
          2
        %-  ~(gas py:smart *(pmap:smart @ux proposal))
        :~  [0x1 proposal-1:multisig]
            [0x2 proposal-2:multisig]
            [0x3 proposal-3:multisig]
        ==
        id:multisig
        id.p:wheat:multisig
        id.p:wheat:multisig
        town-id
    ==
  ::
  %+  expect-eq
    !>(correct)
  !>((got:big p.land.res id:multisig))
--