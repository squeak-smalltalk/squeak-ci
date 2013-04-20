Installer ss3
    project: 'Fuel';
    addPackage: 'ConfigurationOfFuel';
    install.

(Smalltalk at: #ConfigurationOfFuel) loadBleedingEdge.

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: true andQuit: true ].
