|%
++  types-json
  |^  ^-  (map @tas json)
  %-  ~(gas by *(map @tas json))
  :^    [%metadata (need (de-json:html metadata-cord))]
      [%nft (need (de-json:html nft-cord))]
    [%nft-contents (need (de-json:html nft-contents-cord))]
  ~
  ::
  ++  metadata-cord
    ^-  cord
    '''
    [
      {"name": "@t"},
      {"symbol": "@t"},
      {"properties": ["@ud"]},
      {"supply": "@ud"},
      {"cap": "(unit @ud)"},
      {"mintable": "?"},
      {"minters": "[@ux]"},
      {"deployer": "@ux"},
      {"salt": "@"}
    ]
    '''
  ::
  ++  nft-cord
    ^-  cord
    '''
    [
      {"id": "@ud"},
      {"uri": "@t"},
      {"metadata": "@ux"},
      {"allowances": ["@ux"]},
      {"properties": {"map": {"key": "@tas", "val": "@t"}}},
      {"transferrable": "?"}
    ]
    '''
  ::
  ++  nft-contents-cord
    ^-  cord
    (rap 3 '[' inner-nft-contents-cord ']' ~)
  --
++  interface-json
  |^  ^-  (map @tas json)
  %-  ~(gas by *(map @tas json))
  :~  [%give (need (de-json:html give-cord))]
      [%take (need (de-json:html take-cord))]
      [%set-allowance (need (de-json:html set-allowance-cord))]
      [%mint (need (de-json:html mint-cord))]
      [%deploy (need (de-json:html deploy-cord))]
  ==
  ::
  ++  give-cord
    ^-  cord
    '''
    [
      {"to": "@ux"},
      {"grain-id": "@ux"}
    ]
    '''
  ::
  ++  take-cord
    ^-  cord
    '''
    [
      {"to": "@ux"},
      {"grain-id": "@ux"}
    ]
    '''
  ::
  ++  set-allowance-cord
    ^-  cord
    '''
    [
      {
        "items": [
          {"who": "@ux"},
          {"grain": "@ux"},
          {"allowed": "?"}
        ]
      }
    ]
    '''
  ::
  ++  mint-cord
    ^-  cord
    %:  rap
        3
        '''
        [
          {"token": "@ux"},
          {
            "mints": [
              {"to": "@ux"},
        '''
        inner-nft-contents-cord
        ']}]'
        ~
    ==
  ::
  ++  deploy-cord
    ^-  cord
    %:  rap
        3
        '''
        [
          {"name": "@t"},
          {"symbol": "@t"},
          {"salt": "@"},
          {"properties": ["@tas"]},
          {"cap": "(unit @ud)"},
          {"minters": ["@ux"]},
          {
            "initial-distribution": [
              {"to": "@ux"},
        '''
        inner-nft-contents-cord
        ']}]'
        ~
    ==
  --

++  inner-nft-contents-cord
  ^-  cord
  '''
  {"uri": "@t"},
  {"properties": {"map": {"key": "@tas", "val": "@t"}}},
  {"transferrable": "?"}
  '''
--
