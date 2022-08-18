/+  smart=zig-sys-smart
|%
::
::  pokes
::
+$  action
  $%  [%set-sources towns=(list [town-id=id:smart (set dock)])]
      [%add-source town-id=id:smart source=dock]
      [%remove-source town-id=id:smart source=dock]
  ==
::
+$  write
  $%  [%submit =egg:smart]
      [%receipt egg-hash=@ux ship-sig=[p=@ux q=ship r=life] uqbar-sig=sig:smart]
  ==
::
::  updates
::
+$  write-result
  $%  [%sent ~]
      [%receipt egg-hash=@ux ship-sig=[p=@ux q=ship r=life] uqbar-sig=sig:smart]
      [%rejected =ship]
      [%executed result=errorcode:smart]
      [%nonce value=@ud]
  ==
::
+$  sources-ping-results
  %+  map  id:smart
  $:  newest-up=(set dock)
      newest-down=(set dock)
      previous-up=(set dock)
      previous-down=(set dock)
  ==
--
