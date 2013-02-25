Installer ss
    project: 'Quaternion';
    addPackage: 'Math-Quaternion';
    addPackage: 'Math-QuaternionTests';
    install.

HDTestReport runPackage: 'Math-QuaternionTests'.

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
