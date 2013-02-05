(FileDirectory default readOnlyFileNamed: 'Shootout.st') fileIn.
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
