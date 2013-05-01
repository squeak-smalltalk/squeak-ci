HDTestReport runPackages: #('WebClient-Tests' 'SqueakSSL-Tests').

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
