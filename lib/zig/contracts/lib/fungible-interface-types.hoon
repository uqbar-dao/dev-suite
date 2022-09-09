|%
++  types-json
  |^  ^-  (map @tas json)
  %-  ~(gas by *(map @tas json))
  :^    [%token-metadata (need (de-json:html token-metadata-cord))]
      [%account (need (de-json:html account-cord))]
    [%approval (need (de-json:html approval-cord))]
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
      {"cap": "unit-ud"},
      {"mintable": "?"},
      {"minters": ["ux"]},
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
  ::
  ++  approval-cord
    ^-  cord
    '''
    [
      {"from": "ux"},
      {"to": "ux"},
      {"amount": "ud"},
      {"nonce": "ud"},
      {"deadline": "da"}
    ]
    '''
  --
++  interface-json
  |^  ^-  (map @tas json)
  %-  ~(gas by *(map @tas json))
  :~  [%give (need (de-json:html give-cord))]
      [%take (need (de-json:html take-cord))]
      [%take-with-sig (need (de-json:html take-with-sig-cord))]
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
  ++  take-with-sig-cord
    ^-  cord  :: TODO: Sig
    '''
    [
      {"to": "ux"},
      {"from-account": "ux"},
      {"to-account": "unit-ux"},
      {"amount": "ud"},
      {"nonce": "ud"},
      {"deadline": "da"},
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
      {"token": "ux"},
      {
        "mints": [
          {"to": "ux"},
          {"account": "unit-ux"},
          {"amount": "ud"}
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
      {"salt": ""},
      {"cap": "unit-ud"},
      {"minters": ["ux"]},
      {
        "initial-distribution": [
          {"to": "ux"},
          {"amount": "ud"}
        ]
      }
    ]
    '''
  --
--
