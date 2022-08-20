::  nft.hoon [UQ| DAO]
::
::  NFT standard. Provides abilities similar to ERC-721 tokens, also ability
::  to deploy and mint new sets of tokens.
::
::  /+  *zig-sys-smart
/=  nft  /lib/zig/contracts/lib/nft
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
        [%nft @ ~]
      =+  (need (scry (slav %ux i.t.path)))
      =+  (husk nft:sur - ~ ~)
      (nft:enjs:lib data.-)
    ::
        [%metadata @ ~]
      =+  (need (scry (slav %ux i.t.path)))
      =+  (husk metadata:sur - ~ ~)
      (metadata:enjs:lib data.-)
    ==
  ::
  ++  noun
    ~
  --
--
