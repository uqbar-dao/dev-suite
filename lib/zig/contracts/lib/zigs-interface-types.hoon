::  [UQ| DAO]
::  zigs.hoon v1.0
::
|%
++  types-json
  |^  ^-  (map @tas json)
  %-  ~(gas by *(map @tas json))
  :+  [%token-metadata (need (de-json:html token-metadata-cord))]
    [%account (need (de-json:html account-cord))]
  ~
  ::
  ++  token-metadata-cord
    ^-  cord
    '''
    [
      {"name": "t"},
      {"symbol": "t"},
      {"decimals": "ud"},
      {"supply": "ud"},
      {"cap": "~"},
      {"mintable": "?"},
      {"minters": "~"},
      {"deployer-address": "ux"},
      {"salt": "ux"}
    ]
    '''
  ::
  ++  account-cord
    ^-  cord
    '''
    [
      {"balance": "ud"},
      {"allowances": {"map": {"key": "ux", "val": "ud"}}},
      {"metadata": "ux"},
      {"nonce": "ud"}
    ]
    '''
  --
::
++  interface-json
  |^  ^-  (map @tas json)
  %-  ~(gas by *(map @tas json))
  :^    [%give (need (de-json:html give-cord))]
      [%take (need (de-json:html take-cord))]
    [%set-allowance (need (de-json:html set-allowance-cord))]
  ~
  ::
  ++  give-cord
    ^-  cord
    '''
    [
      {"budget": "ud"},
      {"to": "ux"},
      {"amount": "ud"},
      {"from-account": "ux"},
      {"to-account": "unit-ux"}
    ]
    '''
  ::
  ++  take-cord
    ^-  cord
    '''
    [
      {"to": "ux"},
      {"amount": "ud"},
      {"from-account": "ux"},
      {"to-account": "unit-ux"}
    ]
    '''
  ::
  ++  set-allowance-cord
    ^-  cord
    '''
    [
      {"who": "ux"},
      {"amount": "ud"},
      {"account": "ux"}
    ]
    '''
  --
--
