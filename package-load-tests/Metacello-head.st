MetacelloPlatform current authorName: 'testMonkey'. "These tests save code ... need an Author"

"no deprecated messages should be used"
(Deprecation respondsTo: #raiseWarning:)
  ifTrue: [ Deprecation raiseWarning: false].

HDTestReport runPackages: #(
    'Metacello-TestsCore'
    'Metacello-TestsMC-Configurations'
    'Metacello-TestsMC-Gofer'
    'Metacello-TestsMC-Resources'
    'Metacello-TestsPlatform'
    'Metacello-TestsReference'
    'Metacello-TestsTutorial').

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
