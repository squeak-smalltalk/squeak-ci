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

HDTestReport runPackages: #('WebClient-Tests' "'SqueakSSL-Tests'").

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
