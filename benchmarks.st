Smalltalk at: #Log put: [:msg | | str |
	str := DateAndTime now printString, ': ', msg.
	FileStream stdout nextPutAll: str; nextPut: Character lf; flush.
	Transcript cr; show: str].

Utilities setAuthorInitials: 'TestRunner'.
Log value: 'Initials Set'.
repo := MCHttpRepository location: 'http://ss3.gemstone.com/ss/shooutout-benchmarks' user: '' password: ''.
Log value: 'Repo created'.
highest := repo highestNumberedVersionNameForPackageNamed: 'Shootout'.
Log value: 'Highest version number name grabbed'.
version := repo versionNamed: highest.
Log value: 'version created'.
version load.
Log value: 'version loaded, benchmarking'.
ShootoutTests outputBenchmarkResults. 
Log value: 'benchmarking completed'.
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
