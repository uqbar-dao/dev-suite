::  Test suite for multisig.hoon
::
/+  *test, cont=zig-contracts-multisig, *zig-sys-smart
=>  ::  test data
    |%
    +$  address   @ux 
    ::
    ::  XX import these when /= drops
    +$  tx-hash   @ux
    +$  proposal  [=egg votes=(set id)]
    +$  multisig-state
      $:  members=(set id)
          threshold=@ud
          pending=(map tx-hash proposal)
      ==
    ::
    ++  town-id  1
    ::
    ++  account-1
      ^-  grain
      :*  id=0x1.beef
          lord=`@ux`'zigs'
          holder=0xbeef
          town-id
          [%& salt=`@`'zigs' data=[50 ~ `@ux`'zigs']]
      ==
    ++  owner-1
      ^-  account
      [id=0xbeef nonce=0 zigs=0x1234.5678]
    ::
    ++  account-2
      ^-  grain
      :*  0x1.dead
          `@ux`'zigs'
          0xdead
          town-id
          [%& `@`'zigs' [30 ~ `@ux`'zigs']]
      ==
    ++  owner-2
      ^-  account
      [0xdead 0 0x1234.5678]
    ::
    ++  account-3
      ^-  grain
      :*  0x1.cafe
          `@ux`'zigs'
          0xcafe
          town-id
          [%& `@`'zigs' [20 ~ `@ux`'zigs']]
      ==
    ++  owner-3
      ^-  account
      [0xcafe 0 0x1234.5678]
    ::
    ::
    ++  multisig-wheat-id  0x2222.2222
    ++  multisig-state-1
      ::  base state
      ^-  multisig-state
      [members=(silt ~[id:owner-1]) threshold=1 pending=~]
    ++  multisig-state-2
      ^-  multisig-state
      :*  members:multisig-state-1
          threshold:multisig-state-1
          pending=(malt ~[[(mug egg-add-member) [egg-add-member votes=~]]])
      ==
    ++  multisig-state-3
      ^-  multisig-state
      :*  members:multisig-state-2
          threshold:multisig-state-2
          pending=~  :: tx has passed
      ==
    ++  multisig-state-4
      ^-  multisig-state
      :*  (~(put in members:multisig-state-3) id:owner-2)
          threshold:multisig-state-3
          pending:multisig-state-3
      ==
    ::
    :: for our specific case, id and salt were pre-calculated by calling the contract
    ++  multisig-grain-id    0x2cf5.9fbd.b2bd.49c3.7524.50a3.ddbb.2248
    ++  multisig-salt        0xdfa.acb2.58c6.5735.f9b1.f3f8.017b.f0f7  
    ++  multisig-grain-1
      ^-  grain
      :*  id=multisig-grain-id
          lord=multisig-wheat-id
          holder=multisig-wheat-id
          town-id
          germ=[%& salt=multisig-salt data=multisig-state-1]
      ==
    ++  multisig-grain-2
      ^-  grain
      :*  id:multisig-grain-1
          lord:multisig-grain-1
          holder:multisig-grain-1
          town-id:multisig-grain-1
          germ=[%& salt=multisig-salt data=multisig-state-2]
      ==
    ++  multisig-grain-3
      ^-  grain
      :*  id:multisig-grain-1
          lord:multisig-grain-1
          holder:multisig-grain-1
          town-id:multisig-grain-1
          germ=[%& salt=multisig-salt data=multisig-state-3]
      ==
    ++  multisig-grain-4
      ^-  grain
      :*  id:multisig-grain-1
          lord:multisig-grain-1
          holder:multisig-grain-1
          town-id:multisig-grain-1
          germ=[%& salt=multisig-salt data=multisig-state-4]
      ==
    ++  egg-add-member
      =|  =egg
      =.  p.egg
        %=  p.egg
          from     multisig-wheat-id
          to       multisig-wheat-id
          rate     10
          budget   100.000
          town-id  town-id
        ==
      =.  q.egg
        %=  q.egg
          caller     multisig-wheat-id
          args       `[%add-member id:owner-2]
          cont-grains  (silt ~[multisig-grain-id])
        ==
      egg
    --
::  testing arms
|%
++  test-contract-typechecks  ^-  tang
  =/  valid  (mule |.(;;(contract cont)))
  (expect-eq !>(%.y) !>(-.valid))
::
++  test-create-multisig
  ^-  tang
  ::  TODO why do we have to do id:owner-1 and why cant we just do id.owner-1
  ::~!  id.owner-1 (gives unexpected type)
  ::  This also prevents us from doing things like multisig-state-1(threshold 2)
  =/  =embryo
    :*  caller=owner-1
        args=`[%create-multisig threshold=1 members=(silt ~[id:owner-1])]
        grains=~
    ==
  =/  =cart  [multisig-wheat-id block=0 town-id owns=~]
  =/  res=chick  (~(write cont cart) embryo)
  =*  expected-grain  multisig-grain-1
  =/  grain  ?>(?=(%.y -.res) (snag 0 ~(val by issued.p.res)))
  (expect-eq !>(expected-grain) !>(grain))
::
++  test-submit-tx
  ^-  tang
  ::  setting up the tx to propose
  ::  creating the execution context by hand
  =/  =embryo
    :*  caller=owner-1
        args=`[%submit-tx egg-add-member]
        grains=~
    ==
  =/  =cart  [me=multisig-wheat-id block=0 town-id owns=(malt ~[[id:multisig-grain-1 multisig-grain-1]])]
  ::  executing the contract call with the context
  =/  res=chick  (~(write cont cart) embryo)
  ::
  =*  expected-grain  multisig-grain-2
  =/  grain  ?>(?=(%.y -.res) (snag 0 ~(val by changed.p.res)))
  (expect-eq !>(expected-grain) !>(grain))
++  test-vote-1
  ^-  tang
  =/  =embryo
    :*  caller=owner-1
        args=`[%vote (mug egg-add-member)]
        grains=~
    ==
  =/  =cart  [me=multisig-wheat-id block=0 town-id owns=(malt ~[[id:multisig-grain-2 multisig-grain-2]])]
  ::
  =/  res=chick  (~(write cont cart) embryo)
  ::
  =*  expected-grain  multisig-grain-3
  =/  [=grain next=_next:*hen]
    ?>  ?=(%.n -.res)
    [(snag 0 ~(val by changed.roost.p.res)) next.p.res]
  ::
  ;:  weld
    (expect-eq !>(expected-grain) !>(grain))
    ::
    ::  elementwise comparison of next and submitted egg
    (expect-eq !>(to.next) !>(to.p:egg-add-member))
    (expect-eq !>(town-id.next) !>(town-id.p:egg-add-member))
    (expect-eq !>(caller.args.next) !>(caller.q:egg-add-member))
    (expect-eq !>(args.args.next) !>(args.q:egg-add-member))
    (expect-eq !>(args.args.next) !>(args.q:egg-add-member))
    (expect-eq !>(cont-grains.args.next) !>(cont-grains.q:egg-add-member))
  ==
++  test-add-member
  ^-  tang
  =/  =embryo
    :*  caller=from.p:egg-add-member
        args=args.q:egg-add-member
        grains=~
    ==
  =/  =cart  [me=multisig-wheat-id block=0 town-id owns=(malt ~[[id:multisig-grain-3 multisig-grain-3]])]
  =/  res=chick  (~(write cont cart) embryo)
  ::
  =*  expected-grain  multisig-grain-4
  =/  grain  ?>(?=(%.y -.res) (snag 0 ~(val by changed.p.res)))
  (expect-eq !>(expected-grain) !>(grain))
++  test-set-threshold
  ^-  tang
  ~
++  test-remove-member
  ^-  tang
  ~
--