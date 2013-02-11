Installer ss3
    project: 'Control';
    addPackage: 'Control-fbs.19.mcz';
    addPackage: 'ControlTests-fbs.15.mcz';
    install.

HDTestReport runPackage: 'ControlTests'.

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
