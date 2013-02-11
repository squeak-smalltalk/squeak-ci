Smalltalk at: #Log put: [:msg | | str |
	str := DateAndTime now printString, ': ', msg.
	FileStream stdout nextPutAll: str; nextPut: Character lf; flush.
	Transcript cr; show: str].

Log value: 'Loading Hudson build tools... from ', (FileDirectory default fullNameFor: 'HudsonBuildTools.st').
(FileDirectory default readOnlyFileNamed: 'HudsonBuildTools.st') fileIn.

Log value: 'Running tests...'.
Utilities setAuthorInitials: 'TestRunner'.

Installer ss
    addPackage: 'FFI-Kernel-tbn.25.mcz';
    addPackage: 'FFI-Pools-eem.3.mcz';
    addPackage: 'FFI-Unix-mtf.4.mcz';
    addPackage: 'OSProcess-dtl.73.mcz';
    install.

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: true andQuit: true ].
