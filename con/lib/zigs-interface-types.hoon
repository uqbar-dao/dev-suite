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
      {"allowances": ["map", "ux", "ud"]},
      {"metadata": "ux"},
      {"nonces": ["map", "ux", "ud"]}
    ]
    '''
  --
::
++  interface-json
  |^  ^-  (map @tas json)
  %-  ~(gas by *(map @tas json))
  :~  [%give (need (de-json:html give-cord))]
      [%take (need (de-json:html take-cord))]
      [%push (need (de-json:html push-cord))]
      [%pull (need (de-json:html pull-cord))]
      [%set-allowance (need (de-json:html set-allowance-cord))]
  ==
  ::
  ++  give-cord
    ::  TODO: add back in `{"budget": "ud"},` field
    ^-  cord
    '''
    [
      {"to": "ux"},
      {"amount": "ud"},
      {"from-account": "ux"}
    ]
    '''
  ::
  ++  take-cord
    ^-  cord
    '''
    [
      {"to": "ux"},
      {"amount": "ud"},
      {"from-account": "ux"}
    ]
    '''
  ::
  ++  push-cord
    ^-  cord
    '''
    [
      {"to": "ux"},
      {"amount": "ud"},
      {"from-account": "ux"},
      {"calldata": "*"}
    ]
    '''
  ::
  ++  pull-cord
    ^-  cord
    '''
    [
      {"from": "ux"},
      {"to": "ux"},
      {"amount": "ud"},
      {"from-account": "ux"},
      {"nonce": "ud"},
      {"deadline": "ud"},
      {
        "sig": [
          {"v": "ux"},
          {"r": "ux"},
          {"s": "ux"}
        ]
      }
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
