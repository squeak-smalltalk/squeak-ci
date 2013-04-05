(Installer url: 'http://seaside.gemstone.com/ss/metacello/')
    addPackage: 'ConfigurationOfMetacello';
    install.

((Smalltalk at: #ConfigurationOfMetacello) project version: '1.0-beta.32')
    load: 'Tests'.

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
