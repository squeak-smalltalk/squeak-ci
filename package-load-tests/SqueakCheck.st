HDTestReport runPackages: #('SqueakCheck-Generators-Tests' 'SqueakCheck-Runners-Tests' 'SqueakCheck-SUnit').

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
