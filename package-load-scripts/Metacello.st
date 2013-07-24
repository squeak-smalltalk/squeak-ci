(Installer url: 'http://seaside.gemstone.com/ss/metacello/')
    addPackage: 'ConfigurationOfMetacello-dkh.754.mcz';
    install.

((Smalltalk at: #ConfigurationOfMetacello) project version: '1.0.0-beta.32.9')
    load: 'Tests'.

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: true andQuit: true ].
