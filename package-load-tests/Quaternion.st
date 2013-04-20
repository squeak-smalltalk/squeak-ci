HDTestReport runPackage: 'Math-QuaternionTests'.

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
