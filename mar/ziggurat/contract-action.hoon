/-  *ziggurat
=,  dejs:format
|_  act=contract-action
++  grab
  |%
  ++  noun  contract-action
  ++  json
    |=  jon=^json
    ^-  contract-action
    %-  contract-action
    |^
    (guh jon)
    ++  guh
      %-  ot
      :~  [%project so]
          [%action process]
      ==
    ++  process
      %-  of
      :~  [%new-contract-project (ot ~[[%template (se %tas)] [%user-address (se %ux)]])]
          [%populate-template (ot ~[[%template (se %tas)] [%metadata parse-rice]])]
          [%delete-project ul]
          [%save-file (ot ~[[%name so] [%text so]])]
          [%delete-file (ot ~[[%name so]])]
          [%add-to-state parse-rice-without-id]
          [%delete-from-state (ot ~[[%id (se %ux)]])]
          [%add-test (ot ~[[%name so:dejs-soft:format] [%action so] [%expected-error ni:dejs-soft:format]])]
          [%add-test-expectation (ot ~[[%id (se %ux)] [%expected parse-rice-without-id]])]
          [%delete-test-expectation (ot ~[[%id (se %ux)] [%delete (se %ux)]])]
          [%delete-test (ot ~[[%id (se %ux)]])]
          [%edit-test (ot ~[[%id (se %ux)] [%name so:dejs-soft:format] [%action so] [%expected-error ni:dejs-soft:format]])]
          [%run-test parse-test]
          [%run-tests (ar parse-test)]
          [%deploy-contract parse-deploy]
      ==
    ::
    ++  parse-rice
      %-  ot
      :~  [%salt ni]
          [%label (se %tas)]
          [%data so]  ::  note: reaming to form data noun
          [%id (se %ux)]
          [%lord (se %ux)]
          [%holder (se %ux)]
          [%town-id (se %ux)]
      ==
    ::
    ++  parse-rice-without-id
      %-  ot
      :~  [%salt ni]
          [%label (se %tas)]
          [%data so]
          [%lord (se %ux)]
          [%holder (se %ux)]
          [%town-id (se %ux)]
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
