Installer squeakmap
    update;
    install: 'FFI (head)'.

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: true andQuit: true ].
