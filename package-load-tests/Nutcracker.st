Installer ss3
    project: 'Nutcracker';
    addPackage: 'ConfigurationOfNutcracker-fbs.6.mcz';
    install.

(Smalltalk at: #ConfigurationOfNutcracker) loadDevelopment.

HDTestReport runPackages: #('EitherTests' 'MaybeTests' 'MonadTests' 'UnificationTests')

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
