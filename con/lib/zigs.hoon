::  lib/zigs.hoon [UQ| DAO]
::
/+  *zig-sys-smart
|%
++  sur
  |%
  +$  token-metadata
    ::  will be automatically inserted into town state
    ::  at instantiation, along with this contract
    ::  hardcoded values included to match token standard
    $:  name=@t
        symbol=@t
        decimals=@ud
        supply=@ud
        cap=~  ::  no pre-set supply cap
        mintable=%.n
        minters=~
        deployer=address  ::  will be 0x0
        salt=@            ::  'zigs'
    ==
  ::
  +$  account
    $:  balance=@ud
        allowances=(pmap address @ud)
        metadata=id
        nonces=(pmap address @ud)
    ==
  ::
  +$  action
    $%  $:  %give
            budget=@ud
            to=address
            amount=@ud
            from-account=id
        ==
    ::
        $:  %take
            to=address
            amount=@ud
            from-account=id
        ==
    ::
        $:  %push
            to=address
            amount=@ud
            from-account=id
            calldata=*
        ==
    ::
        $:  %pull
            from=address
            to=address
            amount=@ud
            from-account=id
            nonce=@ud
            deadline=@ud
            =sig
        ==
    ::
        $:  %set-allowance
            who=address
            amount=@ud  ::  (to revoke, call with amount=0)
            account=id
        ==
    ==
  --
::
++  lib
  |%
  ::  see lib/fungible.hoon
  ++  pull-jold-hash  0x8a0c.ebea.b35e.84a1.1729.7c78.f677.f39a
  --
--
