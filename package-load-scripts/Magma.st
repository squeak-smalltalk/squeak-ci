Installer squeakmap
    update;
    install: 'Magma (head)'.

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].

