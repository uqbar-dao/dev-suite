::  /+  *zig-sys-smart
|%
+$  action
  $%  $:  %deploy
          mutable=?
          cont=[bat=* pay=*]
          interface=(map @tas json)
          types=(map @tas json)
      ==
      ::
      $:  %upgrade
          to-upgrade=id
          new-nok=[bat=* pay=*]
      ==
  ==
--
