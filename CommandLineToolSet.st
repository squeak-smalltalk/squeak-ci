'From Squeak4.5 of 16 April 2013 [latest update: #12597] on 21 April 2013 at 4:02:38 pm'!
Object subclass: #CommandLineToolSet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tools-CommandLine'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

CommandLineToolSet class
	instanceVariableNames: ''!

!CommandLineToolSet class methodsFor: 'as yet unclassified' stamp: 'fbs 4/21/2013 16:02'!
debugError: anError
	"Print out a sensible stack trace and bail"
	| problemPlace s |
	problemPlace := anError signalerContext.
	s := FileStream stderr.
	(anError isKindOf: MessageNotUnderstood) ifTrue: [
		s
			nextPutAll: anError messageText;
			nextPutAll: String cr;
			nextPutAll: problemPlace sender sender methodNode printString;
			nextPutAll: String cr].
	(problemPlace stackOfSize: 20) do: [:ctx | s cr. ctx printOn: s].
	s flush.

	SmalltalkImage current snapshot: false andQuit: true! !

!CommandLineToolSet class methodsFor: 'as yet unclassified' stamp: 'fbs 4/21/2013 13:42'!
unload
	ToolSet unregister: self.! !
