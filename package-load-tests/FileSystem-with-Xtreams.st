"The other FileSystem tests are run by FileSystem.st."
HDTestReport runPackages: #(
    'Xtreams-TerminalsFileSystemTests'
    'FS-Tests-Xtreams'
).

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
