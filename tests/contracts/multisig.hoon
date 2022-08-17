::
::  Tests for multisig.hoon
::
/-  zink
/+  *test, smart=zig-sys-smart, *sequencer, merk
/*  smart-lib-noun     %noun  /lib/zig/compiled/smart-lib/noun
/*  zink-cax-noun      %noun  /lib/zig/compiled/hash-cache/noun
/*  multisig-contract  %noun  /lib/zig/compiled/multisig/noun
|%
::
::  constants / dummy info for mill
::
++  big  (bi:merk id:smart grain:smart)  ::  merkle engine for granary
++  pig  (bi:merk id:smart @ud)          ::                for populace
++  town-id   0x0
++  fake-sig  [0 0 0]
++  mil
  %~  mill  mill
  :+    ;;(vase (cue q.q.smart-lib-noun))
    ;;((map * @) (cue q.q.zink-cax-noun))
  %.y
::
+$  mill-result
  [fee=@ud =land burned=granary =errorcode:smart hits=(list hints:zink) =crow:smart]
::
::  fake data
::
++  miller  ^-  caller:smart
  [0x24c.23b9.8535.cd5a.0645.5486.69fb.afbf.095e.fcc0 1 0x0]  ::  zigs account not used
++  holder-1  0xd387.95ec.b77f.b88e.c577.6c20.d470.d13c.8d53.2169
++  holder-2  0xface.face.face.face.face.face.face.face.face.face
++  caller-1  ^-  caller:smart  [holder-1 1 (make-id:zigs holder-1)]
++  caller-2  ^-  caller:smart  [holder-2 1 (make-id:zigs holder-2)]
::
++  zigs
  |%
  ++  make-id
    |=  holder=id:smart
    (fry-rice:smart zigs-wheat-id:smart holder town-id `@`'zigs')
  ++  make-account
    |=  [holder=id:smart amt=@ud]
    ^-  grain:smart
    :*  %&  `@`'zigs'  %account
        [amt ~ `@ux`'zigs-metadata-id']
        (make-id holder)
        zigs-wheat-id:smart
        holder
        town-id
    ==
  --
::
++  multisig-wheat
  ^-  grain:smart
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
::
++  fake-granary
  ^-  granary
  %+  gas:big  *(merk:merk id:smart grain:smart)
  %+  turn
    :~  multisig-wheat
        (make-account:zigs holder-1 300.000.000)
        (make-account:zigs holder-2 300.000.000)
    ==
  |=(=grain:smart [id.p.grain grain])
::
++  fake-populace
  ^-  populace
  %+  gas:pig  *(merk:merk id:smart @ud)
  ~[[id:caller-1 0]]
++  fake-land
  ^-  land
  [fake-granary fake-populace]
::
::  begin tests
::
++  test-mill-create-multisig
  =/  member-set  (~(gas pn:smart *(pset:smart address:smart)) ~[id:caller-1])
  =/  =yolk:smart  [%create 1 member-set]
  =/  shel=shell:smart
    [caller-1 ~ id.p:multisig-wheat 1 1.000.000 town-id 0]
  =/  res=mill-result
    %+  ~(mill mil miller town-id 1)
      fake-land
    `egg:smart`[fake-sig shel yolk]
  ::
  =/  correct-salt  (shag:smart (cat 3 id:caller-1 1))
  =/  correct-id
    (fry-rice:smart id.p:multisig-wheat id.p:multisig-wheat town-id correct-salt)
  =/  correct
    ^-  grain:smart
    :*  %&
        correct-salt
        %multisig
        [member-set 1 ~]
        correct-id
        id.p:multisig-wheat
        id.p:multisig-wheat
        town-id
    ==
  ::
  ~&  >  "fee: {<fee.res>}"
  ~&  p.land.res
  ;:  weld
  ::  assert that our call went through
    %+  expect-eq
    !>(%0)  !>(errorcode.res)
  ::  assert new contract grain was created properly
    %+  expect-eq
      !>(correct)
    !>((got:big p.land.res correct-id))
  ==
--