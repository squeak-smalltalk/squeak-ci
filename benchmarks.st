Smalltalk at: #Log put: [:msg | | str |
	str := DateAndTime now printString, ': ', msg.
	FileStream stdout nextPutAll: str; nextPut: Character lf; flush.
	Transcript cr; show: str].


Log value: 'Loading shootout files'.
Log value: 'Loading Shootout tests... from ', (FileDirectory default fullNameFor: 'Shootout.st').
Log value: 'Done loading shootout files'.
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
