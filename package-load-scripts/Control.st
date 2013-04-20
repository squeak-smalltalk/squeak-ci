Installer squeakmap
    update;
    addPackage: 'Control (head)';
    install.

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: true andQuit: true ].
