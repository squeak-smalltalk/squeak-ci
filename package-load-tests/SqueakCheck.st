Utilities setAuthorInitials: 'TestRunner'.

Installer ss
    project: 'SqueakCheck';
    install: 'ConfigurationOfSqueakCheck-fbs.11.mcz'.

(Smalltalk at: #ConfigurationOfSqueakCheck) loadDevelopment.

HDTestReport runPackages: #('SqueakCheck-Generators-Tests' 'SqueakCheck-Runners-Tests').

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
