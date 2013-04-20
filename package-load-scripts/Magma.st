Installer squeakmap
    update;
    install: 'Magma (head)'.

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: true andQuit: true ].

