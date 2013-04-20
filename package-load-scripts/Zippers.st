Installer ss3
    project: 'Nutcracker';
    addPackage: 'Either-fbs.9.mcz';
    install.

Installer ss3
    project: 'Zippers';
    addPackage: 'Zippers-fbs.52.mcz';
    install.

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: true andQuit: true ].
