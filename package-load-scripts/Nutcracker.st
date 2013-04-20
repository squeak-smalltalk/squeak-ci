Installer ss3
    project: 'Nutcracker';
    addPackage: 'ConfigurationOfNutcracker-fbs.7.mcz';
    install.

(Smalltalk at: #ConfigurationOfNutcracker) loadDevelopment.

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: true andQuit: true ].
