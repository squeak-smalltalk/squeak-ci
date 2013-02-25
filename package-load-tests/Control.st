Installer squeakmap
    update;
    addPackage: 'Control (head)';
    install.

HDTestReport runPackage: 'ControlTests'.

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
