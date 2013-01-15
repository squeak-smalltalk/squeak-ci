Smalltalk at: #Log put: [:msg | | str |
	str := DateAndTime now printString, ': ', msg.
	FileStream stdout nextPutAll: str; nextPut: Character lf; flush.
	Transcript cr; show: str].

Log value: 'Loading Hudson build tools... from ', (FileDirectory default fullNameFor: 'HudsonBuildTools.st').
(FileDirectory default readOnlyFileNamed: 'HudsonBuildTools.st') fileIn.

Log value: 'Running tests...'.
HDTestReport runPackages: (
	MCWorkingCopy allManagers asOrderedCollection
		removeAllSuchThat: [ :each |
			each package packageInfo classes
				noneSatisfy: [ :ea | ea includesBehavior: TestCase ] ];
		replace: [ :each | each packageName ];
		sort).

Log value: 'Test run complete'.
"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
