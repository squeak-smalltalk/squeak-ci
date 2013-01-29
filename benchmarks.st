(FileDirectory default readOnlyFileNamed: 'Shootout.st') fileIn.
ShootoutTests outputBenchmarkResults.
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
