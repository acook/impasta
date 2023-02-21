Impasta Rewrite TODO
====================

 - [ ] Spy for an instance (provide the instance)
    - disguise should probably take on this functionality?
 - [ ] Spy for a class (provide a class, don't have to instantiate it)
    - infiltrate instantiates for you, disguise doesn't instantiate
    - which is better in practice? probably infiltrate?
 - [X] Spy which passes methods to instance and returns (proxy/wiretap)
 - [X] Spy which always returns self (dummy/decoy)
 - [X] Spy which always returns nil or raises (null/ghoul)
 - [X] Spy which raises for everything except allowed methods (fake/cobbler)
 - [X] should be able to call #forge on any spy secret and have it work?
 - [ ] reduce duplicate functionality, combine spies where it makes sense

FIXME
-----

 - [ ] Test method missing with keyword args
 - [ ] Test forge with keyword args
 - [ ] Spy#initialize should take `aka` and `target` as args
 - [ ] Block initialize should execute in a safe DSL
 - [ ] Verify that Ghoul is side effect free

Mabye
-----

 - [ ] Check arity of method_missing?
 - [ ] Forge-like ability which verifies that it matches a method signature on the original?
