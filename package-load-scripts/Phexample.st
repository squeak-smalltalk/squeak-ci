Installer squeakmap
    update;
    addPackage: 'Phexample (1.2)';
    install.

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: true andQuit: true ].
