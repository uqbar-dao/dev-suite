::  Usage: :pyro|commit ~dev %zig
::     or: :pyro|commit ~dev %zig, =files ~[/foo/hoon /bar/hoon]
::   Note:  first run :pyro|dojo ~dev "|mount %zig" once before using commit
::   TODO:  get .docket-0 files working
/-  pyro, *docket
=,  pyro
:-  %say
|=  $:  [* * =beak]
        [who=ship desk=@tas ~]
        files=(list path)
    ==
=/  desk-path  /(scot %p p.beak)/[desk]/(scot r.beak)
=/  to-insert=(list path)
  ?^  files  files
  .^((list path) %ct desk-path)
:-  %action
:^  %insert-files  who  desk
%+  murn  to-insert
|=  =path
^-  (unit [^path @t])
?+  (rear path)  ~&(>>> "can't commit .{(trip (rear path))} files" ~)
  %hoon    `[path .^(@t %cx (weld desk-path path))]
  %ship    `[path (scot %p .^(ship %cx (weld desk-path path)))]
  %bill    `[path (crip (noah !>(.^((list @tas) %cx (weld desk-path path)))))]
  %kelvin  `[path (crip (noah !>(.^([@tas @ud] %cx (weld desk-path path)))))]
  ::   %docket-0
  :: :+  ~  path
  :: (crip (noah !>(.^(docket %cx (weld desk-path path)))))
==
