Installer squeakmap
    update;
    addPackage: 'Control (head)';
    install.

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
