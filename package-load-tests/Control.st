Installer squeakmap
    update;
    addPackage: 'Control (1.2.dev)';
    install.

HDTestReport runPackage: 'ControlTests'.

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
