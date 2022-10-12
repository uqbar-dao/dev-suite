::  nft.hoon [UQ| DAO]
::
::  NFT standard. Provides abilities similar to ERC-721 tokens, also ability
::  to deploy and mint new sets of tokens.
::
::  /+  *zig-sys-smart
/=  nft  /con/lib/nft
=,  nft
|_  =cart
++  write
  |=  act=action:sur
  ^-  chick
  ?-  -.act
    %give           (give:lib:nft cart act)
    %take           (take:lib:nft cart act)
    %set-allowance  (set-allowance:lib:nft cart act)
    %mint           (mint:lib:nft cart act)
    %deploy         (deploy:lib:nft cart act)
  ==
::
++  read
  |_  =path
  ++  json
    ^-  ^json
    ?+    path  !!
        [%inspect @ ~]
      ?~  g=(scry (slav %ux i.t.path))  ~
      ?.  ?=(%& -.u.g)  ~
      ?^  item=((soft nft:sur:nft) data.p.u.g)
        (nft:enjs:lib:nft u.item)
      ?^  meta=((soft metadata:sur:nft) data.p.u.g)
        (metadata:enjs:lib:nft u.meta)
      ~
    ==
  ::
  ++  noun
    ~
  --
--
