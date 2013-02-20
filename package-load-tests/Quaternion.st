Installer squeakmap
    update;
    addPackage: 'Quaternion (1.0)';
    install.

HDTestReport runPackage: 'Quaternion'.

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
