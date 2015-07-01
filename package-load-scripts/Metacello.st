(Installer url: 'http://seaside.gemtalksystems.com/ss/metacello/')
    addPackage: 'ConfigurationOfMetacello-topa.802.mcz';
    install.

((Smalltalk at: #ConfigurationOfMetacello) project version: '1.0-beta.32.1')
    load: 'Tests'.

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: true andQuit: true ].
