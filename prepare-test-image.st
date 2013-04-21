Smalltalk at: #Log put: [:msg | | str |
	str := DateAndTime now printString, ': ', msg.
	FileStream stdout nextPutAll: str; nextPut: Character lf; flush.
	Transcript cr; show: str].

Log value: 'Loading Hudson build tools... from ', (FileDirectory default fullNameFor: 'HudsonBuildTools.st').
(FileDirectory default readOnlyFileNamed: 'HudsonBuildTools.st') fileIn.
((FileDirectory default / '..') readOnlyFileNamed: 'CommandLineToolSet.st') fileIn.
ToolSet default: (Smalltalk at: #CommandLineToolSet).

WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: true andQuit: true ].
