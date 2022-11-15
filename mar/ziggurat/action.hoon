/-  *zig-ziggurat
=,  dejs:format
|_  act=action
++  grab
  |%
  ++  noun  action
  ++  json
    |=  jon=^json
    ^-  action
    %-  action
    |^
    (guh jon)
    ++  guh
      %-  ot
      :~  [%project so]
          [%action process]
      ==
    ++  process
      %-  of
      :~  [%new-project (ot ~[[%user-address (se %ux)]])]
          [%populate-template (ot ~[[%template (se %tas)] [%metadata parse-data]])]
          [%delete-project ul]
          [%save-file (ot ~[[%file pa] [%text so]])]
          [%delete-file (ot ~[[%file pa]])]
          [%register-contract-for-compilation (ot ~[[%file pa]])]
          [%compile-contracts ul]
          [%read-desk ul]
          [%add-item parse-data-without-id]
          [%update-item parse-data]
          [%delete-item (ot ~[[%id (se %ux)]])]
          [%add-test (ot ~[[%name so:dejs-soft:format] [%for-contract (se %ux)] [%action so] [%expected-error ni:dejs-soft:format]])]
          [%add-test-expectation (ot ~[[%test-id (se %ux)] [%expected parse-data-without-id]])]
          [%delete-test-expectation (ot ~[[%id (se %ux)] [%delete (se %ux)]])]
          [%delete-test (ot ~[[%id (se %ux)]])]
          [%edit-test (ot ~[[%id (se %ux)] [%name so:dejs-soft:format] [%for-contract (se %ux)] [%action so] [%expected-error ni:dejs-soft:format]])]
          [%run-test parse-test]
          [%run-tests (ar parse-test)]
          [%deploy-contract parse-deploy]
          [%publish-app parse-docket]
      ==
    ::
    ++  parse-docket
      %-  ot
      :~  [%title so]
          [%info so]
          [%color (se %ux)]
          [%image so]
          [%version (at ~[ni ni ni])]
          [%website so]
          [%license so]
      ==
    ::
    ++  parse-data
      %-  ot
      :~  [%id (se %ux)]
          [%source (se %ux)]
          [%holder (se %ux)]
          [%town (se %ux)]
          [%salt ni]
          [%label (se %tas)]
          [%noun so]  ::  note: reaming to form noun
      ==
    ::
    ++  parse-data-without-id
      %-  ot
      :~  [%source (se %ux)]
          [%holder (se %ux)]
          [%town (se %ux)]
          [%salt ni]
          [%label (se %tas)]
          [%noun so]
      ==
    ::
    ++  parse-test
      %-  ot
      :~  [%id (se %ux)]
          [%rate ni]
          [%bud ni]
      ==
    ::
    ++  parse-deploy
      %-  ot
      :~  [%address (se %ux)]
          [%rate ni]
          [%bud ni]
          [%deploy-location (se %tas)]
          [%town-id (se %ux)]
          [%upgradable bo]
      ==
    --
  --
++  grow
  |%
  ++  noun  act
  --
++  grad  %noun
--
