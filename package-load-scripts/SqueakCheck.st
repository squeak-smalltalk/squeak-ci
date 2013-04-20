Utilities setAuthorInitials: 'TestRunner'.

Installer ss
    project: 'SqueakCheck';
    install: 'ConfigurationOfSqueakCheck-fbs.11.mcz'.

(Smalltalk at: #ConfigurationOfSqueakCheck) loadDevelopment.

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
