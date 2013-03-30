Smalltalk at: #Log put: [:msg | | str |
	str := DateAndTime now printString, ': ', msg.
	FileStream stdout nextPutAll: str; nextPut: Character lf; flush.
	Transcript cr; show: str].

Installer installUrl: 'http://source.squeak.org/trunk/XML-Parser-ael.35.mcz'.
(Installer ss3 project: 'Shootout') install: 'Shootout-nice.15.mcz'.
(Installer ss3 project: 'SqueakCI-Benchmarking') install: 'SqueakCI-Benchmarking-JMG.3.mcz'.

Log value: 'starting benchmarks'.
ShootoutTests outputBenchmarkResults. 
Log value: 'benchmarking completed'.
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].
