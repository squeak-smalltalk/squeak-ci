Installer installUrl: 'http://source.squeak.org/trunk/Universes-nice.45.mcz'.

HDTestReport runPackage: 'Universes-Tests'.

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
