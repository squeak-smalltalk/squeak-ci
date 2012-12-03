(FileDirectory default readOnlyFileNamed: 'HudsonBuildTools.st') fileIn.

HDTestReport runPackages: (
	MCWorkingCopy allManagers asOrderedCollection
		removeAllSuchThat: [ :each |
			each package packageInfo classes
				noneSatisfy: [ :ea | ea includesBehavior: TestCase ] ];
		replace: [ :each | each packageName ];
		sort).

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
