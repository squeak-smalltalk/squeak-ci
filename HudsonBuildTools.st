Object subclass: #HDReport
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'HudsonBuildTools'!

!HDReport methodsFor: 'private' stamp: 'lr 5/15/2010 14:27'!
convert: aString
	^ (aString asString
		copyReplaceAll: (String with: Character cr with: Character lf) with: (String with: Character lf))
		copyReplaceAll: (String with: Character cr) with: (String with: Character lf)! !

!HDReport methodsFor: 'private' stamp: 'lr 5/14/2010 08:36'!
encode: aString
	^ ((aString asString
		copyReplaceAll: '&' with: '&amp;')
		copyReplaceAll: '"' with: '&quot;')
		copyReplaceAll: '<' with: '&lt;'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

HDReport class
	instanceVariableNames: ''!

!HDReport class methodsFor: 'running' stamp: 'ul 9/5/2012 23:18'!
runCategories: aCollectionOfStrings
	^ aCollectionOfStrings collect: [ :each | self runCategory: each ]! !

!HDReport class methodsFor: 'running' stamp: 'lr 5/14/2010 09:17'!
runCategory: aString
	^ self runClasses: (Smalltalk organization classesInCategory: aString) named: aString! !

!HDReport class methodsFor: 'running' stamp: 'lr 5/14/2010 09:15'!
runClasses: aCollectionOfClasses named: aString
	self subclassResponsibility! !

!HDReport class methodsFor: 'running' stamp: 'lr 5/14/2010 09:16'!
runPackage: aString
	self subclassResponsibility! !

!HDReport class methodsFor: 'running' stamp: 'ul 9/5/2012 23:17'!
runPackages: aCollectionOfStrings
	^ aCollectionOfStrings collect: [ :each |
		Log value: 'Running tests for ', each, '...'.
		self runPackage: each ]! !


HDReport subclass: #HDTestReport
	instanceVariableNames: 'suite stream suitePosition suiteTime suiteFailures suiteErrors originalInitials'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'HudsonBuildTools'!

!HDTestReport methodsFor: 'private' stamp: 'lr 6/6/2010 18:44'!
beginTestCase: aTestCase time: time
	stream tab; nextPutAll: '<testcase classname="'; nextPutAll: (self encode: (aTestCase class category copyReplaceAll: '-' with: '.')); nextPut: $.; nextPutAll: (self encode: aTestCase class name); nextPutAll: '" name="'; nextPutAll: (self encode: aTestCase selector); nextPutAll: '" time="'; print: time / 1000.0; nextPutAll: '">'; nextPut: Character lf! !

!HDTestReport methodsFor: 'private' stamp: 'lr 6/6/2010 18:45'!
endTestCase
	stream tab; nextPutAll: '</testcase>'; nextPut: Character lf! !

!HDTestReport methodsFor: 'private' stamp: 'pmm 6/6/2010 18:13'!
stackTraceString: err of: aTestCase
	^ String streamContents: [ :str |
		| context |
		context := err signalerContext.
		[ context isNil or: [ context receiver == aTestCase and: [ context method selector == #runCase ] ] ] whileFalse: [
			str print: context; nextPut: Character lf.
			context := context sender ] ] ! !

!HDTestReport methodsFor: 'private' stamp: 'lr 6/9/2010 10:32'!
writeError: error stack: stack
	suiteErrors := suiteErrors + 1.
	stream tab; tab; nextPutAll: '<error type="'; nextPutAll: (self encode: error class name); nextPutAll: '" message="'; nextPutAll: (self encode: (error messageText ifNil: [ error description ])); nextPutAll: '">'; nextPutAll: (self encode: stack); nextPutAll: '</error>'; nextPut: Character lf! !

!HDTestReport methodsFor: 'private' stamp: 'lr 6/9/2010 10:33'!
writeFailure: error stack: stack
	suiteFailures := suiteFailures + 1.
	stream tab; tab; nextPutAll: '<failure type="'; nextPutAll: (self encode: error class name); nextPutAll: '" message="'; nextPutAll: (self encode: (error messageText ifNil: [ error description ])); nextPutAll: '">'; nextPutAll: (self encode: stack); nextPutAll: '</failure>'; nextPut: Character lf! !


!HDTestReport methodsFor: 'initialization' stamp: 'lr 1/10/2010 10:22'!
initializeOn: aTestSuite
	suite := aTestSuite.
	suitePosition := suiteTime := suiteFailures := suiteErrors := 0! !


!HDTestReport methodsFor: 'running' stamp: 'ul 9/20/2012 19:31'!
run

	 [
		self setUp.
		suiteTime := [ self runAll ]
			timeToRun ]
				ensure: [ self tearDown ]! !

!HDTestReport methodsFor: 'running' stamp: 'JohanBrichau 10/25/2010 23:05'!
runAll
	suite tests do: [ :each | each run: self ]! !

!HDTestReport methodsFor: 'running' stamp: 'lr 11/24/2010 20:44'!
runCase: aTestCase
	| error time stack |
	time := [ [ aTestCase runCase ]
		on: Halt , Error, TestFailure
		do: [ :err |
			error := err.
			stack := self stackTraceString: err of: aTestCase ] ]
			timeToRun.
	self beginTestCase: aTestCase time: time.
	(error isNil or: [ aTestCase expectedFailures includes: aTestCase selector ]) ifFalse: [
		(error isKindOf: TestFailure)
			ifTrue: [ self writeError: error stack: stack ]
			ifFalse: [ self writeError: error stack: stack ] ].
	self endTestCase! !

!HDTestReport methodsFor: 'running' stamp: 'ul 9/20/2012 19:31'!
setUp

	originalInitials := Utilities authorInitialsPerSe.
	Utilities setAuthorInitials: 'TestRunner'.
	stream := StandardFileStream forceNewFileNamed: suite name , '-Test.xml'.
	stream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'; nextPut: Character lf.
	stream nextPutAll: '<testsuite name="'; nextPutAll: (self encode: suite name); nextPutAll: '" tests="'; print: suite tests size; nextPutAll: '">'.

	"Now this is ugly. We want to update the time and the number of failures and errors, but still at the same time stream a valid XML. So remember this position and add some whitespace, that we can fill later."
	suitePosition := stream position - 1.
	stream nextPutAll: (String new: 100 withAll: $ ); nextPut: Character lf.

	"Initialize the test resources."
	suite resources do: [ :each |
		each isAvailable
			ifFalse: [ each signalInitializationError ] ]! !

!HDTestReport methodsFor: 'running' stamp: 'ul 9/20/2012 19:32'!
tearDown
	suite resources
		do: [ :each | each reset ].

	stream tab; nextPutAll: '<system-out><!![CDATA[]]></system-out>'; nextPut: Character lf.
	stream tab; nextPutAll: '<system-err><!![CDATA[]]></system-err>'; nextPut: Character lf.
	stream nextPutAll: '</testsuite>'.

	stream position: suitePosition.
	stream nextPutAll: ' failures="'; print: suiteFailures; nextPutAll:'" errors="'; print: suiteErrors; nextPutAll: '" time="'; print: suiteTime / 1000.0; nextPutAll: '">'.
	stream close.
	Utilities setAuthorInitials: originalInitials! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

HDTestReport class
	instanceVariableNames: ''!

!HDTestReport class methodsFor: 'running' stamp: 'lr 5/14/2010 09:16'!
runClasses: aCollectionOfClasses named: aString
	| suite classes |
	suite := TestSuite named: aString.
	classes := (aCollectionOfClasses
		select: [ :each | (each includesBehavior: TestCase) and: [ each isAbstract not ] ])
			asSortedCollection: [ :a :b | a name <= b name ].
	classes isEmpty
		ifTrue: [ ^ self ].
	classes
		do: [ :each | each addToSuiteFromSelectors: suite ].
	^ self runSuite: suite! !

!HDTestReport class methodsFor: 'running' stamp: 'lr 5/14/2010 09:16'!
runPackage: aString
	^ self runClasses: (PackageInfo named: aString) classes named: aString! !

!HDTestReport class methodsFor: 'running' stamp: 'lr 5/14/2010 09:16'!
runSuite: aTestSuite
	^ self new
		initializeOn: aTestSuite;
		run! !
