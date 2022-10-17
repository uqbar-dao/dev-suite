::  UQ| non-fungible token standard v0.1
::  last updated: 2022/08/20
::
::  TODO: add gasless signing for %takes like in fungible
::
::  Basic NFT standard. In this model, each NFT is located in its own
::  rice. This rice contains the NFT's ID within its collection, a URI,
::  the ID of the metadata for the collection, allowances, whether
::  the NFT is transferrable, and a map of arbitrary properties to their
::  values for this particular NFT. The properties are defined in the
::  collection metadata -- each item in a collection must share that
::  set of properties.
::
::  Transfer of an NFT from one address to another is simply changing
::  the rice holder. Note that the collection that an NFT belongs to is
::  defined by its metadata ID, not the issuing contract. Like with the
::  fungible token standard, a contract that includes this standard's
::  logic can be completely generic.
::
::  /+  *zig-sys-smart
|%
++  sur
  |%
  +$  metadata
    $:  name=@t
        symbol=@t
        properties=(pset @tas)
        supply=@ud
        cap=(unit @ud)  ::  (~ if no cap)
        mintable=?      ::  automatically set to %.n if supply == cap
        minters=(pset address)
        deployer=id
        salt=@
    ==
  ::
  +$  nft  ::  a non-fungible token
    $:  id=@ud
        uri=@t
        metadata=id
        allowances=(pset address)
        properties=(pmap @tas @t)
        transferrable=?
    ==
  ::
  +$  nft-contents  ::  used for minting new NFTs
    [uri=@t properties=(pmap @tas @t) transferrable=?]
  ::
  +$  action
    $%  give
        take
        set-allowance
        mint
        deploy
    ==
  ::
  +$  give
    $:  %give
        to=address
        grain-id=id
    ==
  +$  take
    $:  %take
        to=address
        grain-id=id
    ==
  +$  set-allowance
    $:  %set-allowance
        items=(list [who=address grain=id allowed=?])
    ==
  +$  mint
    $:  %mint
        token=id  ::  id of metadata
        mints=(list [to=address nft-contents])
    ==
  +$  deploy
    $:  %deploy
        name=@t
        symbol=@t
        salt=@
        properties=(pset @tas)
        cap=(unit @ud)         ::  if ~, no cap (fr fr)
        minters=(pset address)  ::  if ~, mintable becomes %.n, otherwise %.y
        initial-distribution=(list [to=address nft-contents])
    ==
  --
::
++  lib
  |%
  ++  give
    |=  [=cart act=give:sur]
    ^-  chick
    =+  (need (scry-granary grain-id.act))
    ::  caller must hold NFT, this contract must be lord
    =/  gift  (husk nft:sur - `me.cart `id.from.cart)
    ::  NFT must be transferrable
    ?>  transferrable.data.gift
    ::  change holder to reflect new ownership
    ::  clear allowances
    =:  holder.gift  to.act
        allowances.data.gift  ~
    ==
    (result [[%& gift] ~] ~ ~ ~)
  ::
  ++  take
    |=  [=cart act=take:sur]
    ^-  chick
    =+  (need (scry-granary grain-id.act))
    ::  this contract must be lord
    =/  gift  (husk nft:sur - `me.cart ~)
    ::  caller must be in allowances set
    ?>  (~(has pn allowances.data.gift) id.from.cart)
    ::  NFT must be transferrable
    ?>  transferrable.data.gift
    ::  change holder to reflect new ownership
    ::  clear allowances
    =:  holder.gift  to.act
        allowances.data.gift  ~
    ==
    (result [[%& gift] ~] ~ ~ ~)
  ::
  ++  set-allowance
    |=  [=cart act=set-allowance:sur]
    ^-  chick
    ::  can set many allowances in single call
    =|  changed=(list grain)
    |-
    ?~  items.act
      ::  finished
      (result changed ~ ~ ~)
    ::  can optimize repeats here by storing these all in pmap at start
    =+  (need (scry-granary grain.i.items.act))
    ::  must hold any NFT we set allowance for
    =/  nft  (husk nft:sur - `me.cart `id.from.cart)
    =.  allowances.data.nft
      ?:  allowed.i.items.act
        (~(put pn allowances.data.nft) who.i.items.act)
      (~(del pn allowances.data.nft) who.i.items.act)
    %=  $
      items.act  t.items.act
      changed    [[%& nft] changed]
    ==
  ::
  ++  mint
    |=  [=cart act=mint:sur]
    ^-  chick
    =+  `grain`(need (scry-granary token.act))
    =/  meta  (husk metadata:sur - `me.cart ~)
    ::  ensure NFT is mintable
    ?>  mintable.data.meta
    ::  ensure caller is in minter-set
    ?>  (~(has pn minters.data.meta) id.from.cart)
    ::  set id of next possible item in collection
    =/  next-item-id  +(supply.data.meta)
    ::  check if mint will surpass supply cap
    =/  new-supply  (add supply.data.meta (lent mints.act))
    ?>  ?~  cap.data.meta  %.y
        (gte u.cap.data.meta new-supply)
    =.  supply.data.meta  new-supply
    ::  iterate through mints
    =|  issued=(list grain)
    |-
    ?~  mints.act
      ::  finished minting
      (result [[%& meta] ~] issued ~ ~)
    ::  create new grain for NFT
    ::  unique salt for each item in collection
    =*  m  i.mints.act
    =/  salt    (cat 3 salt.meta (scot %ud next-item-id))
    =/  new-id  (fry-rice me.cart to.m town-id.cart salt)
    ::  properties must match those in metadata spec!
    ?>  =(properties.data.meta ~(key py properties.m))
    =/  data    [next-item-id uri.m id.meta ~ properties.m transferrable.m]
    =/  =rice   [salt %nft data new-id me.cart to.m town-id.cart]
    %=  $
      mints.act     t.mints.act
      next-item-id  +(next-item-id)
      issued        [[%& rice] issued]
    ==
  ::
  ++  deploy
    |=  [=cart act=deploy:sur]
    ^-  chick
    ::  create new NFT collection with a metadata grain
    ::  and optional initial mint
    =/  =metadata:sur
      :*  name.act
          symbol.act
          properties.act
          (lent initial-distribution.act)
          cap.act
          ?~(minters.act %.n %.y)
          minters.act
          id.from.cart
          salt.act
      ==
    =/  =id    (fry-rice me.cart me.cart town-id.cart salt.act)
    =/  =rice  [salt.act %metadata metadata id me.cart me.cart town-id.cart]
    ?~  initial-distribution.act
      (result ~ [[%& rice] ~] ~ ~)
    ::  perform optional mint
    =/  next  [%mint id initial-distribution.act]
    %+  continuation
      [me.cart town-id.cart next]^~
    (result ~ [[%& rice] ~] ~ ~)
  ::
  ::
  ++  enjs
    =,  enjs:format
    |%
    ++  nft
      |=  =nft:sur
      ^-  json
      %-  pairs
      :~  ['id' (numb id.nft)]
          ['uri' [%s uri.nft]]
          ['metadata' [%s (scot %ux metadata.nft)]]
          ['allowances' (address-set allowances.nft)]
          ['properties' (properties properties.nft)]
          ['transferrable' [%b transferrable.nft]]
      ==
    ::
    ++  metadata
      |=  md=metadata:sur
      ^-  json
      %-  pairs
      :~  ['name' %s name.md]
          ['symbol' %s symbol.md]
          ['properties' (properties-set properties.md)]
          ['supply' (numb supply.md)]
          ['cap' ?~(cap.md ~ (numb u.cap.md))]
          ['mintable' %b mintable.md]
          ['minters' (address-set minters.md)]
          ['deployer' %s (scot %ux deployer.md)]
          ['salt' (numb salt.md)]
      ==
    ::
    ++  address-set
      |=  a=(set address)
      ^-  json
      :-  %a
      %+  turn  ~(tap pn a)
      |=(a=address [%s (scot %ux a)])
    ::
    ++  properties-set
      |=  p=(set @tas)
      ^-  json
      :-  %a
      %+  turn  ~(tap pn p)
      |=(prop=@tas [%s (scot %tas prop)])
    ::
    ++  properties
      |=  p=(map @tas @t)
      ^-  json
      %-  pairs
      %+  turn  ~(tap py p)
      |=([prop=@tas val=@t] [prop [%s val]])
    --
  --
--
