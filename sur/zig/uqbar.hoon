/+  smart=zig-sys-smart
|%
::
::  pokes
::
+$  action
  $%  [%set-sources towns=(list [town-id=id:smart (set dock)])]
      [%add-source town-id=id:smart source=dock]
      [%remove-source town-id=id:smart source=dock]
      [%set-wallet-source app-name=@tas]  ::  to plug in a third-party wallet app
      [%ping ~]
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
+$  indexer-sources-ping-results
  %+  map  id:smart
  $:  previous-up=(set dock)
      previous-down=(set dock)
      newest-up=(set dock)
      newest-down=(set dock)
  ==
--
