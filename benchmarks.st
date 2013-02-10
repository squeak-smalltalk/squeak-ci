Smalltalk at: #Log put: [:msg | | str |
	str := DateAndTime now printString, ': ', msg.
	FileStream stdout nextPutAll: str; nextPut: Character lf; flush.
	Transcript cr; show: str].

repo := MCHttpRepository location: 'http://ss3.gemstone.com/ss/shooutout-benchmarks' user: '' password: ''.
highest := repo highestNumberedVersionNameForPackageNamed: 'Shootout'.
version := repo versionNamed: highest.
version load.
ShootoutTests outputBenchmarkResults. 
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
