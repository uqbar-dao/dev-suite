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
      {"name": "t"},
      {"symbol": "t"},
      {"properties": ["set", "tas"]},
      {"supply": "ud"},
      {"cap": ["unit", "ud"]},
      {"mintable": "?"},
      {"minters": ["set", "ux"]},
      {"deployer": "ux"},
      {"salt": "ux"}
    ]
    '''
  ::
  ++  nft-cord
    ^-  cord
    '''
    [
      {"id": "ud"},
      {"uri": "t"},
      {"metadata": "ux"},
      {"allowances": ["set", "ux"]},
      {"properties": ["map", "tas", "t"]},
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
      {"to": "ux"},
      {"item-id": "ux"}
    ]
    '''
  ::
  ++  take-cord
    ^-  cord
    '''
    [
      {"to": "ux"},
      {"item-id": "ux"}
    ]
    '''
  ::
  ++  set-allowance-cord
    ^-  cord
    '''
    [
      {
        "items": [
          {"who": "ux"},
          {"item": "ux"},
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
          {"token": "ux"},
          {
            "mints": [
              "list",
              [
                {"to": "ux"},
        '''
        inner-nft-contents-cord
        ']]}]'
        ~
    ==
  ::
  ++  deploy-cord
    ^-  cord
    %:  rap
        3
        '''
        [
          {"name": "t"},
          {"symbol": "t"},
          {"salt": "ux"},
          {"properties": ["set", "tas"]},
          {"cap": ["unit", "ud"]},
          {"minters": ["set", "ux"]},
          {
            "initial-distribution": [
              "list",
              [
                {"to": "ux"},
        '''
        inner-nft-contents-cord
        ']]}]'
        ~
    ==
  --

++  inner-nft-contents-cord
  ^-  cord
  '''
  {"uri": "t"},
  {"properties": ["map", "tas", "t"]},
  {"transferrable": "?"}
  '''
--
