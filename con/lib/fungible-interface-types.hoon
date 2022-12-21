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
      {"cap": ["unit", "ud"]},
      {"mintable": "?"},
      {"minters": ["set", "ux"]},
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
  ::
  ++  approval-cord
    ^-  cord
    '''
    [
      {"from": "ux"},
      {"to": "ux"},
      {"amount": "ud"},
      {"nonce": "ud"},
      {"deadline": "ud"}
    ]
    '''
  --
++  interface-json
  |^  ^-  (map @tas json)
  %-  ~(gas by *(map @tas json))
  :~  [%give (need (de-json:html give-cord))]
      [%take (need (de-json:html take-cord))]
      [%push (need (de-json:html push-cord))]
      [%pull (need (de-json:html pull-cord))]
      [%set-allowance (need (de-json:html set-allowance-cord))]
      [%mint (need (de-json:html mint-cord))]
      [%deploy (need (de-json:html deploy-cord))]
  ==
  ::
  ++  give-cord
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
  ::
  ++  mint-cord
    ^-  cord
    '''
    [
      {"token-metadata": "ux"},
      {
        "mints": [
          "list",
          [
            {"to": "ux"},
            {"amount": "ud"}
          ]
        ]
      }
    ]
    '''
  ::
  ++  deploy-cord
    ^-  cord
    '''
    [
      {"name": "t"},
      {"symbol": "t"},
      {"salt": "ux"},
      {"cap": ["unit", "ud"]},
      {"minters": ["set", "ux"]},
      {
        "initial-distribution": [
          "list",
          [
            {"to": "ux"},
            {"amount": "ud"}
          ]
        ]
      }
    ]
    '''
  --
--
