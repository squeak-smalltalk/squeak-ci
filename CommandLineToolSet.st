StandardToolSet subclass: #CommandLineToolSet
	instanceVariableNames: ''
	classVariableNames: 'SaveSnapshotOnError'
	poolDictionaries: ''
	category: 'CommandLine-Tools'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

CommandLineToolSet class
	instanceVariableNames: ''!

!CommandLineToolSet class methodsFor: 'preferences' stamp: 'fbs 10/8/2013 13:37'!
saveSnapshotOnError
	<preference: 'Save snapshot of image on failure'
	category: 'debug'
	description: 'If true, saves a snapshot of the failing image to the current directory.'
	type: #Boolean>
	^ SaveSnapshotOnError ifNil: [SaveSnapshotOnError := false].! !

!CommandLineToolSet class methodsFor: 'preferences' stamp: 'fbs 10/8/2013 13:34'!
saveSnapshotOnError: aBoolean
	SaveSnapshotOnError := aBoolean.! !


!CommandLineToolSet class methodsFor: 'debugging' stamp: 'fbs 10/8/2013 14:11'!
debugError: anError
	"Print out a sensible stack trace and bail"
	| problemPlace s |
	self saveSnapshotOnError
		ifTrue: [Smalltalk saveAs: 'Debug-' , (Smalltalk imageName subStrings: '/') last].
	problemPlace := anError signalerContext.
	s := FileStream stderr.
	(anError isKindOf: MessageNotUnderstood) ifTrue: [
		s
			nextPutAll: anError messageText; cr;
			nextPutAll: problemPlace sender methodNode printString; cr].
	(problemPlace stackOfSize: 20) do: [:ctx | s cr. ctx printOn: s].
	s flush.

	SmalltalkImage current snapshot: false andQuit: true! !

!CommandLineToolSet class methodsFor: 'debugging' stamp: 'fbs 5/08/2013 09:04'!
debugSyntaxError: anError
	| s |
	s := FileStream stderr.
	s nextPutAll: '----- Syntax error -----'; cr.
	s nextPutAll: anError errorCode; cr.
	s nextPutAll: '----- Syntax error -----'; cr.

	self debugError: anError! !


!CommandLineToolSet class methodsFor: 'class initialization' stamp: 'fbs 4/21/2013 13:42'!
unload
	ToolSet unregister: self.! !
