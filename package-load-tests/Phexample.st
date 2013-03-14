Installer squeakmap
    update;
    addPackage: 'Phexample (1.2)';
    install.

HDTestReport runPackage: 'Phexample-Test'.

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
