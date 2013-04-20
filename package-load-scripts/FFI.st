Installer squeakmap
    update;
    install: 'FFI (head)'.

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
