::  [UQ| DAO]
::  zigs.hoon v0.9
::
::  /+  *zig-sys-smart
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
        cap=~
        mintable=%.n
        minters=~
        deployer=address  ::  will be 0x0
        salt=@            ::  'zigs'
    ==
  ::
  +$  account
    $:  balance=@ud
        allowances=(map address @ud)
        metadata=id
    ==
  ::
  +$  action
    $%  $:  %give
            budget=@ud
            to=address
            amount=@ud
            from-account=[%grain =id]
            to-account=(unit [%grain =id])
        ==
    ::
        $:  %take
            to=address
            amount=@ud
            from-account=[%grain =id]
            to-account=(unit [%grain =id])
        ==
    ::
        $:  %set-allowance
            who=address
            amount=@ud  ::  (to revoke, call with amount=0)
            account=[%grain =id]
        ==
    ==
  --
::
++  lib
  |%
  --
--
