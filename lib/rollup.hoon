/-  *rollup
|%
::
::  +allowed-participant: grades whether a ship is permitted to participate
::  in UQ| sequencing. currently using hardcoded whitelist
::
++  allowed-participant
  |=  [=ship our=ship now=@da]
  ^-  ?
  (~(has in whitelist) ship)
++  whitelist
  ^-  (set ship)
  %-  ~(gas in *(set ship))
  :~  ::  fakeships for localhost testnets
      ::  edit this locally on your own rollup.hoon host
      ~zod  ~bus  ~nec  ~wet  ~rys
  ==
--
