Installer ss3
    project: 'Nutcracker';
    addPackage: 'Either-fbs.9.mcz';
    install.

Installer ss3
    project: 'Zippers';
    addPackage: 'Zippers-fbs.52.mcz';
    install.

HDTestReport runPackage: 'Zippers-Tests'.

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
