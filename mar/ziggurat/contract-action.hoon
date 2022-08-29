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
      :~  [%new-contract-project (ot ~[[%template (se %tas)]])]
          [%populate-template (ot ~[[%template (se %tas)] [%metadata parse-rice]])]
          [%delete-project ul]
          [%save-file (ot ~[[%name so] [%text so]])]
          [%delete-file (ot ~[[%name so]])]
          [%add-to-state parse-rice]
          [%delete-from-state (ot ~[[%id (se %ux)]])]
          [%add-test (ot ~[[%name so:dejs-soft:format] [%action so]])]
          [%add-test-expectations (ot ~[[%id (se %ux)] [%expected (as parse-rice)]])]
          [%delete-test (ot ~[[%id (se %ux)]])]
          [%edit-test (ot ~[[%id (se %ux)] [%name so:dejs-soft:format] [%action so]])]
          [%run-test parse-test]
          [%run-tests (ar parse-test)]
          [%deploy-contract parse-deploy-location]
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
    ++  parse-test
      %-  ot
      :~  [%id (se %ux)]
          [%rate ni]
          [%bud ni]
      ==
    ::
    ++  parse-deploy-location
      %-  ot
      :~  [%deploy-location (se %tas)]
          [%town-id (se %ux)]
      ==
    --
  --
++  grow
  |%
  ++  noun  act
  --
++  grad  %noun
--
