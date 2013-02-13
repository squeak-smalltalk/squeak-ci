Installer installUrl: 'http://source.squeak.org/trunk/XML-Parser-ael.35.mcz'.

HDTestReport runPackage: 'XML-Parser'.

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
