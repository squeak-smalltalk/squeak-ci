Installer squeaksource
    project: 'RoelTyper';
    addPackage: 'RoelTyper';
    install.

HDTestReport runPackage: 'RoelTyper-Tests'.

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
