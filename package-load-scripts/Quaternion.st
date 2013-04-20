Installer ss
    project: 'Quaternion';
    addPackage: 'Math-Quaternion';
    addPackage: 'Math-QuaternionTests';
    install.

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
