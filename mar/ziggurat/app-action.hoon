/-  *ziggurat
=,  dejs:format
|_  act=app-action
++  grab
  |%
  ++  noun  app-action
  ++  json
    |=  jon=^json
    ^-  app-action
    %-  app-action
    |^
    (guh jon)
    ++  guh
      %-  ot
      :~  [%project so]
          [%action process]
      ==
    ++  process
      %-  of
      :~  [%new-app-project ul]
          [%delete-project ul]
          [%save-file (ot ~[[%file pa] [%text so]])]
          [%delete-file (ot ~[[%file pa]])]
          [%publish-app parse-docket]
          [%approve-cors-domain (ot ~[[%domain so]])]
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
    --
  --
++  grow
  |%
  ++  noun  act
  --
++  grad  %noun
--
