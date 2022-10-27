/-  *zig-sequencer
|%
++  transition-state
  |=  [old=(unit town) proposed=[num=@ud =processed-txs =chain diff-hash=@ux root=@ux]]
  ^-  (unit town)
  ?~  old  old
  :-  ~
  %=  u.old
    batch-num.hall         num.proposed
    chain                  chain.proposed
    latest-diff-hash.hall  diff-hash.proposed
    roots.hall             (snoc roots.hall.u.old root.proposed)
  ==
::
++  read-grain
  |=  [=path =state]
  ^-  (unit (unit cage))
  ?>  ?=([%grain @ ~] path)
  =/  id  (slav %ux i.t.path)
  ``noun+!>((get:big state id))
--
