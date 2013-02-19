Installer squeakmap
    update;
    install: 'FFI (head)'.

HDTestReport runPackage: 'FFI-Tests'.

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
