Installer squeakmap
    update;
    addPackage: 'AndreasSystemProfiler (head)';
    install.

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
