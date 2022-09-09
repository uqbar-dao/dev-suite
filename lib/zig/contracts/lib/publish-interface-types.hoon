|%
++  interface-json
  |^  ^-  (map @tas json)
  %-  ~(gas by *(map @tas json))
  :+  [%deploy (need (de-json:html deploy-cord))]
    [%upgrade (need (de-json:html upgrade-cord))]
  ~
  ::
  ++  deploy-cord
    ^-  cord
    '''
    [
      {"mutable": "?"},
      {"cont": "~"},
      {"interface": {"map": {"key": "@tas", "val": "json"}}},
      {"types": {"map": {"key": "@tas", "val": "json"}}}
    ]
    '''
  ::
  ++  upgrade-cord
    ^-  cord
    '''
    [
      {"to-update": "@ux"},
      {"new-nok": "~"}
    ]
    '''
  --
--
