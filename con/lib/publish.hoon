/+  *zig-sys-smart
|%
+$  action
  $%  $:  %deploy
          mutable=?
          code=[bat=* pay=*]
          interface=(map @tas json)
          types=(map @tas json)
      ==
      ::  TODO add initialization call option?
      ::  $:  %deploy-and-init
      ::  ==
      ::
      $:  %upgrade
          to-upgrade=id
          new-code=[bat=* pay=*]
      ==
  ==
--
