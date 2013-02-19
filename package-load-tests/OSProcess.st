Installer squeakmap
    update;
    addPackage: 'OSProcess (head)';
    install.

[(Smalltalk at: #AioEventHandler) aioPluginPresent]
    on: Warning
    do: [ "ignore the one-time warning dialog" ].

HDTestReport runPackage: 'OSProcess-Tests'.

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
