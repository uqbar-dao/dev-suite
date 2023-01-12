/+  smart=zig-sys-smart
|%
::
::  pokes
::
+$  action
  $%  [%set-sources towns=(list [town=id:smart (set dock)])]
      [%add-source town=id:smart source=dock]
      [%remove-source town=id:smart source=dock]
      [%set-wallet-source app-name=@tas]  ::  to plug in a third-party wallet app
      [%open-faucet town=id:smart send-to=address:smart]
      [%ping ~]
  ==
::
+$  write
  $%  [%submit =transaction:smart]
      [%receipt transaction-hash=@ux ship-sig=[p=@ux q=ship r=life] uqbar-sig=sig:smart]
  ==
::
::  updates
::
+$  write-result
  $%  [%sent ~]
      [%receipt transaction-hash=@ux ship-sig=[p=@ux q=ship r=life] uqbar-sig=sig:smart]
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
