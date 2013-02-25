Smalltalk at: #Log put: [:msg | | str |
	str := DateAndTime now printString, ': ', msg.
	FileStream stdout nextPutAll: str; nextPut: Character lf; flush.
	Transcript cr; show: str].

benchmarksRepo := MCHttpRepository location: 'http://ss3.gemstone.com/ss/Shootout' user: '' password: ''.
highest := benchmarksRepo highestNumberedVersionNameForPackageNamed: 'Shootout'.
version := benchmarksRepo versionNamed: highest.
version load.

ciRepo := MCHttpRepository location: 'http://ss3.gemstone.com/ss/SqueakCI-Benchmarking' user: '' password: ''.
highest := ciRepo highestNumberedVersionNameForPackageNamed: 'SqueakCI-Benchmarking'.
version := ciRepo versionNamed: highest.
version load.

Log value: 'starting benchmarks'.
ShootoutTests outputBenchmarkResults. 
Log value: 'benchmarking completed'.
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
