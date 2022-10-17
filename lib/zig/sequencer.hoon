/-  *sequencer
/+  mill=zig-mill
|%
++  transition-state
  |=  [old=(unit town) proposed=[num=@ud =carton =land diff-hash=@ux root=@ux]]
  ^-  (unit town)
  ?~  old  old
  :-  ~
  %=  u.old
    batch-num.hall         num.proposed
    land                   land.proposed
    latest-diff-hash.hall  diff-hash.proposed
    roots.hall             (snoc roots.hall.u.old root.proposed)
  ==
::
++  read-grain
  |=  [=path =granary]
  ^-  (unit (unit cage))
  ?>  ?=([%grain @ ~] path)
  =/  id  (slav %ux i.t.path)
  ``noun+!>((get:big:mill granary id))
--
