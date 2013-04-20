Installer ss
    project: 'WebClient';
    addPackage: 'WebClient-Core';
    addPackage: 'WebClient-Tests';
    install.

Installer ss
    project: 'SqueakSSL';
    addPackage: 'SqueakSSL-Core';
    addPackage: 'SqueakSSL-Tests';
    install.

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
