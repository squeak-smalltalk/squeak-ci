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

!HDReport class methodsFor: 'running' stamp: 'lr 5/14/2010 09:17'!
runCategories: aCollectionOfStrings
	^ aCollectionOfStrings do: [ :each | self runCategory: each ]! !

!HDReport class methodsFor: 'running' stamp: 'lr 5/14/2010 09:17'!
runCategory: aString
	^ self runClasses: (Smalltalk organization classesInCategory: aString) named: aString! !

!HDReport class methodsFor: 'running' stamp: 'lr 5/14/2010 09:15'!
runClasses: aCollectionOfClasses named: aString
	self subclassResponsibility! !

!HDReport class methodsFor: 'running' stamp: 'lr 5/14/2010 09:16'!
runPackage: aString
	self subclassResponsibility! !

!HDReport class methodsFor: 'running' stamp: 'lr 5/14/2010 09:17'!
runPackages: aCollectionOfStrings
	^ aCollectionOfStrings do: [ :each | self runPackage: each ]! !


HDReport subclass: #HDChangeReport
	instanceVariableNames: 'gofer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'HudsonBuildTools'!

!HDChangeReport methodsFor: 'accessing' stamp: 'lr 9/29/2010 13:42'!
changesFor: aResolvedVersion
	| references patch |
	references := gofer allResolved
		select: [ :each | each packageName = aResolvedVersion packageName ].
	patch := MCPatch 
		fromBase: (references size > 1 
			ifTrue: [ (references at: references size - 1) version snapshot ]
			ifFalse: [ MCSnapshot empty ])
		target: aResolvedVersion version snapshot.
	^ patch operations asSortedCollection! !

!HDChangeReport methodsFor: 'accessing' stamp: 'lr 9/29/2010 13:27'!
resolved
	^ gofer resolved! !


!HDChangeReport methodsFor: 'generating' stamp: 'lr 9/29/2010 13:35'!
generateChange: aPatch on: aStream
	aPatch isAddition
		ifTrue: [ ^ self generateChangeAddition: aPatch on: aStream ].
	aPatch isModification
		ifTrue: [ ^ self generateChangeModification: aPatch on: aStream ].
	aPatch isRemoval
		ifTrue: [ ^ self generateChangeRemoval: aPatch on: aStream ]! !

!HDChangeReport methodsFor: 'generating' stamp: 'lr 9/29/2010 13:42'!
generateChangeAddition: aPatch on: aStream
	aStream tab; tab; tab; nextPutAll: '<item action="add">'; nextPutAll: (self encode: (self convert: aPatch summary)); nextPutAll: '</item>'; nextPut: Character lf! !

!HDChangeReport methodsFor: 'generating' stamp: 'lr 9/29/2010 13:42'!
generateChangeModification: aPatch on: aStream
	aStream tab; tab; tab; nextPutAll: '<item action="change">'; nextPutAll: (self encode: (self convert: aPatch summary)); nextPutAll: '</item>'; nextPut: Character lf! !

!HDChangeReport methodsFor: 'generating' stamp: 'lr 9/29/2010 13:41'!
generateChangeRemoval: aPatch on: aStream
	aStream tab; tab; tab; nextPutAll: '<item action="remove">'; nextPutAll: (self encode: (self convert: aPatch summary)); nextPutAll: '</item>'; nextPut: Character lf! !

!HDChangeReport methodsFor: 'generating' stamp: 'lr 9/29/2010 14:07'!
generateChangeSet: aResolvedVersion on: aStream
	| info |
	info := aResolvedVersion version info.
	aStream tab; nextPutAll: '<logentry version="'; nextPutAll: (self encode: info name); nextPutAll: '">'; nextPut: Character lf.
	aStream tab; tab; nextPutAll: '<date>'; nextPutAll: (self encode: info date yyyymmdd); space; nextPutAll: (self encode: info time print24); nextPutAll: '</date>'; nextPut: Character lf.
	aStream tab; tab; nextPutAll: '<author>'; nextPutAll: (self encode: info author); nextPutAll: '</author>'; nextPut: Character lf.
	aStream tab; tab; nextPutAll: '<msg>'; nextPutAll: (self encode: (self convert: info message)); nextPutAll: '</msg>'; nextPut: Character lf.
	"aStream tab; tab; nextPutAll: '<items>'; nextPut: Character lf.
	(self changesFor: aResolvedVersion)
		do: [ :each | self generateChange: each on: aStream ].
	aStream tab; tab; nextPutAll: '</items>'; nextPut: Character lf."
	aStream tab; nextPutAll: '</logentry>'; nextPut: Character lf! !

!HDChangeReport methodsFor: 'generating' stamp: 'lr 9/29/2010 13:29'!
generateOn: aStream
	aStream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'; nextPut: Character lf.
	aStream nextPutAll: '<changelog>'; nextPut: Character lf.
	self resolved
		do: [ :each | self generateChangeSet: each on: aStream ].
	aStream nextPutAll: '<changelog>'! !


!HDChangeReport methodsFor: 'initialization' stamp: 'lr 9/29/2010 11:22'!
initializeOn: aCollection
	gofer := Gofer new.
	aCollection do: [ :each | gofer package: each ]! !


!HDChangeReport methodsFor: 'running' stamp: 'lr 9/29/2010 11:47'!
run
	| stream |
	stream := FileDirectory default containingDirectory
		forceNewFileNamed: 'changelog.xml'.
	[ self generateOn: stream ]
		ensure: [ stream close ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

HDChangeReport class
	instanceVariableNames: ''!

!HDChangeReport class methodsFor: 'running' stamp: 'lr 9/29/2010 11:13'!
runClasses: aCollectionOfClasses named: aString
	self error: 'The change report is only runnable on packages.'! !

!HDChangeReport class methodsFor: 'running' stamp: 'lr 9/29/2010 11:14'!
runPackage: aString
	^ self runPackages: (Array with: aString)! !

!HDChangeReport class methodsFor: 'running' stamp: 'lr 9/29/2010 11:14'!
runPackages: aCollectionOfStrings
	^ (self new initializeOn: aCollectionOfStrings) run! !


HDReport subclass: #HDLintReport
	instanceVariableNames: 'environment rules'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'HudsonBuildTools'!

!HDLintReport methodsFor: 'generating' stamp: 'lr 7/4/2010 22:36'!
generateClass: aClass on: aStream
	| sourceStream sourceName |
	sourceStream := WriteStream on: String new.
	sourceName := environment name , '-' , aClass name , '.st'.
	aStream tab; nextPutAll: '<file name="'; nextPutAll: (self encode: sourceName); nextPutAll: '">'; nextPut: Character lf.
	self generateClass: aClass source: sourceStream on: aStream.
	self generateClass: aClass class source: sourceStream on: aStream.
	aStream tab; nextPutAll: '</file>'; nextPut: Character lf.
	FileDirectory default 
		forceNewFileNamed: sourceName
		do: [ :stream | stream nextPutAll: sourceStream contents ]! !

!HDLintReport methodsFor: 'generating' stamp: 'lr 7/4/2010 20:46'!
generateClass: aClass selector: aSelector source: sourceStream on: aStream
	| offset source matching |
	offset := self
		lineAndColumn: sourceStream contents
		at: sourceStream position.
	sourceStream
		nextPutAll: (source := self convert: (aClass sourceCodeAt: aSelector));
		nextPut: Character lf; nextPut: Character lf.
	matching := rules select: [ :each | 
		(self isSelectorEnvironment: each result)
			and: [ each result includesSelector: aSelector in: aClass ] ].
	self generateViolations: matching source: source offset: offset on: aStream! !

!HDLintReport methodsFor: 'generating' stamp: 'lr 7/4/2010 21:08'!
generateClass: aClass source: sourceStream on: aStream
	| offset source matching selectors |
	offset := self
		lineAndColumn: sourceStream contents
		at: sourceStream position.
	sourceStream
		nextPutAll: (source := self convert: aClass definition);
		nextPut: Character lf; nextPut: Character lf.
	(environment definesClass: aClass) ifTrue: [
		matching := rules select: [ :rule |
			(self isClassEnvironment: rule result)
				and: [ rule result includesClass: aClass ] ].
		self generateViolations: matching source: source offset: offset on: aStream ].
	(environment selectorsForClass: aClass) asSortedCollection
		do: [ :selector | self generateClass: aClass selector: selector source: sourceStream on: aStream ]! !

!HDLintReport methodsFor: 'generating' stamp: 'lr 7/4/2010 21:17'!
generateOn: aStream
	aStream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'; nextPut: Character lf.
	aStream nextPutAll: '<checkstyle version="5.2">'; nextPut: Character lf.
	(environment allClasses asSortedCollection: [ :a :b | a name <= b name ])
		do: [ :class | self generateClass: class on: aStream ].
	aStream nextPutAll: '</checkstyle>'! !

!HDLintReport methodsFor: 'generating' stamp: 'lr 2/12/2012 13:48'!
generateViolations: aCollection source: aString offset: aPoint on: aStream
	aCollection do: [ :rule |
		| interval start |
		interval := (rule result selectionIntervalFor: aString)
			ifNil: [ 1 to: aString size ].
		start := self lineAndColumn: aString at: interval first.
		aStream tab; tab; nextPutAll: '<error source="SmallLint.'; nextPutAll: (self encode: rule group); nextPut: $.; nextPutAll: (self encode: rule class name); nextPut: $".
		aStream nextPutAll: ' message="'; nextPutAll: (self encode: rule group); nextPutAll: ' - '; nextPutAll: (self encode: rule name); nextPut: $".
		aStream nextPutAll: ' severity="'; nextPutAll: (rule
			severity = #information 
				ifTrue: [ 'info' ]
				ifFalse: [ 
					rule severity = #warning
						ifTrue: [ 'warning' ]
						ifFalse: [ 'error' ] ]); nextPut: $".
		aStream nextPutAll: ' line="'; print: aPoint x + start x; nextPut: $".
		aPoint y + start y - 1 <= 1
			ifFalse: [ aStream nextPutAll: ' column="'; print: aPoint y + start y - 1; nextPut: $" ].
		aStream nextPutAll: '/>'; nextPut: Character lf ]! !


!HDLintReport methodsFor: 'initialization' stamp: 'lr 7/4/2010 22:34'!
initializeOn: anEnvironment
	environment := anEnvironment.
	rules := (RBCompositeLintRule rulesFor: RBBasicLintRule)
		reject: [ :each | each class name endsWith: 'SpellingRule' ]! !


!HDLintReport methodsFor: 'testing' stamp: 'lr 9/8/2011 23:41'!
isClassEnvironment: anEnvironment
	^ #(RBCategoryEnvironment RBClassEnvironment RBVariableEnvironment) includes: anEnvironment class name! !

!HDLintReport methodsFor: 'testing' stamp: 'lr 9/8/2011 23:41'!
isSelectorEnvironment: anEnvironment
	^ #(RBSelectorEnvironment RBParseTreeEnvironment RBVariableEnvironment) includes: anEnvironment class name! !


!HDLintReport methodsFor: 'private' stamp: 'lr 5/14/2010 22:29'!
lineAndColumn: aString at: anInteger
	| line last stream |
	line := 1.
	last := 0.
	stream := aString readStream.
	[ (stream nextLine isNil or: [ anInteger <= stream position ])
		ifTrue: [ ^ line @ (anInteger - last) ].
	last := stream position.
	line := line + 1 ]
		repeat! !


!HDLintReport methodsFor: 'running' stamp: 'lr 9/8/2011 23:42'!
run
	| stream |
	RBSmalllintChecker 
		runRule: (RBCompositeLintRule rules: rules)
		onEnvironment: environment.
	stream := FileDirectory default
		forceNewFileNamed: environment name , '-Lint.xml'.
	[ self generateOn: stream ]
		ensure: [ stream close ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

HDLintReport class
	instanceVariableNames: ''!

!HDLintReport class methodsFor: 'running' stamp: 'lr 9/8/2011 23:40'!
runClasses: aCollectionOfClasses named: aString
	| classEnvironment |
	classEnvironment := RBBrowserEnvironment new
		forClasses: aCollectionOfClasses.
	classEnvironment label: aString.
	^ self runEnvironment: classEnvironment! !

!HDLintReport class methodsFor: 'running' stamp: 'lr 5/14/2010 09:20'!
runEnvironment: anEnvironment
	^ self new 
		initializeOn: anEnvironment; 
		run! !

!HDLintReport class methodsFor: 'running' stamp: 'lr 9/8/2011 23:40'!
runPackage: aString
	| packageEnvironment |
	packageEnvironment := RBBrowserEnvironment new
		forPackageNames: (Array with: aString).
	packageEnvironment label: aString.
	^ self runEnvironment: packageEnvironment! !


ProtoObject subclass: #HDTestCoverage
	instanceVariableNames: 'hasRun reference method'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'HudsonBuildTools'!

!HDTestCoverage methodsFor: 'private' stamp: 'lr 7/6/2010 11:16'!
doesNotUnderstand: aMessage
	^ method perform: aMessage selector withArguments: aMessage arguments! !

!HDTestCoverage methodsFor: 'private' stamp: 'lr 11/5/2011 13:14'!
flushCache
	reference methodSymbol flushCache! !

!HDTestCoverage methodsFor: 'private' stamp: 'lr 7/6/2010 11:16'!
mark
	hasRun := true! !


!HDTestCoverage methodsFor: 'testing' stamp: 'lr 7/6/2010 11:16'!
hasRun
	^ hasRun! !


!HDTestCoverage methodsFor: 'initialization' stamp: 'lr 7/6/2010 11:16'!
initializeOn: aMethodReference
	hasRun := false.
	reference := aMethodReference.
	method := reference compiledMethod! !


!HDTestCoverage methodsFor: 'actions' stamp: 'lr 3/30/2011 08:30'!
install
	reference actualClass methodDictionary
		at: reference methodSymbol
		put: self.
	self flushCache! !

!HDTestCoverage methodsFor: 'actions' stamp: 'lr 3/30/2011 08:30'!
uninstall
	reference actualClass methodDictionary
		at: reference methodSymbol
		put: method.
	self flushCache! !


!HDTestCoverage methodsFor: 'accessing' stamp: 'lr 7/5/2010 08:23'!
method
	^ method! !

!HDTestCoverage methodsFor: 'accessing' stamp: 'lr 7/5/2010 08:24'!
reference
	^ reference! !


!HDTestCoverage methodsFor: 'evaluation' stamp: 'lr 7/6/2010 11:15'!
run: aSelector with: anArray in: aReceiver
	self mark; uninstall.
	^ aReceiver withArgs: anArray executeMethod: method! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

HDTestCoverage class
	instanceVariableNames: ''!

!HDTestCoverage class methodsFor: 'instance creation' stamp: 'lr 6/9/2010 11:05'!
on: aMethodReference
	^ self new initializeOn: aMethodReference! !


HDReport subclass: #HDTestReport
	instanceVariableNames: 'suite stream suitePosition suiteTime suiteFailures suiteErrors'
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
		[ context isNil or: [ context receiver == aTestCase and: [ context methodSelector == #runCase ] ] ] whileFalse: [
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


!HDTestReport methodsFor: 'running' stamp: 'chc 5/19/2012 14:02'!
run
	"Author uniqueInstance
		ifUnknownAuthorUse: 'hudson'
		during: [" [ 
			self setUp.
			suiteTime := [ self runAll ]
				timeToRun ]
					ensure: [ self tearDown ] "]"! !

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

!HDTestReport methodsFor: 'running' stamp: 'lr 5/15/2010 14:47'!
setUp
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

!HDTestReport methodsFor: 'running' stamp: 'lr 5/15/2010 14:47'!
tearDown
	suite resources 
		do: [ :each | each reset ].
		
	stream tab; nextPutAll: '<system-out><!![CDATA[]]></system-out>'; nextPut: Character lf.
	stream tab; nextPutAll: '<system-err><!![CDATA[]]></system-err>'; nextPut: Character lf.
	stream nextPutAll: '</testsuite>'.
	
	stream position: suitePosition.
	stream nextPutAll: ' failures="'; print: suiteFailures; nextPutAll:'" errors="'; print: suiteErrors; nextPutAll: '" time="'; print: suiteTime / 1000.0; nextPutAll: '">'.
	stream close! !

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


HDTestReport subclass: #HDCoverageReport
	instanceVariableNames: 'packages wrappers covered'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'HudsonBuildTools'!

!HDCoverageReport methodsFor: 'private' stamp: 'lr 6/9/2010 11:04'!
addTestsIn: aTestAsserter to: aSet
	(aTestAsserter isKindOf: TestSuite) ifTrue: [
		aTestAsserter tests
			do: [ :each | self addTestsIn: each to: aSet ] ].
	(aTestAsserter isKindOf: TestCase) ifTrue: [
		(aTestAsserter class respondsTo: #packageNamesUnderTest) ifTrue: [
			aTestAsserter class packageNamesUnderTest
				do: [ :each | aSet add: (PackageInfo named: each) ] ] ].
	^ aSet! !

!HDCoverageReport methodsFor: 'private' stamp: 'lr 6/9/2010 10:58'!
ignoredSelectors
	^ #(packageNamesUnderTest classNamesNotUnderTest)! !

!HDCoverageReport methodsFor: 'private' stamp: 'lr 6/9/2010 11:01'!
methodsIn: aPackage
	aPackage isNil ifTrue: [ ^ #() ].
	^ aPackage methods reject: [ :method | 
		(self ignoredSelectors includes: method methodSymbol)
			or: [ method compiledMethod isAbstract
			or: [ method compiledMethod refersToLiteral: #ignoreForCoverage ] ] ]! !

!HDCoverageReport methodsFor: 'private' stamp: 'lr 6/9/2010 10:51'!
packagesIn: aTestAsserter
	^ self addTestsIn: aTestAsserter to: Set new! !


!HDCoverageReport methodsFor: 'generating' stamp: 'lr 7/5/2010 08:24'!
generate
	| coverage |
	covered := (wrappers select: [ :each | each hasRun ])
		collect: [ :each | each reference ].
	coverage := StandardFileStream 
		forceNewFileNamed: suite name , '-Coverage.xml'.
	[ self generateOn: coverage ]
		ensure: [ coverage close ]! !

!HDCoverageReport methodsFor: 'generating' stamp: 'lr 7/5/2010 13:30'!
generateDataOn: aStream
	| items |
	aStream tab; nextPutAll: '<data>'; nextPut: Character lf.
	aStream tab; tab; nextPutAll: '<all name="all classes">'; nextPut: Character lf.
	self
		generateType: 'class' indent: 3
		total: (items := (packages gather: [ :each | each classes ]) asSet) size
		actual: ((covered collect: [ :each | each actualClass theNonMetaClass ]) asSet
			count: [ :each | items includes: each ])
		on: aStream.
	self
		generateType: 'method' indent: 3
		total: (items := (packages gather: [ :each | each methods ]) asSet) size 
		actual: (covered count: [ :each | items includes: each ])
		on: aStream.
	packages do: [ :each | self generatePackage: each on: aStream ].
	aStream tab; tab; nextPutAll: '</all>'; nextPut: Character lf.
	aStream tab; nextPutAll: '</data>'; nextPut: Character lf! !

!HDCoverageReport methodsFor: 'generating' stamp: 'lr 7/5/2010 13:09'!
generateOn: aStream
	aStream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'; nextPut: Character lf.
	aStream nextPutAll: '<report>'; nextPut: Character lf.
	self generateStatsOn: aStream.
	self generateDataOn: aStream.
	aStream nextPutAll: '</report>'; nextPut: Character lf! !

!HDCoverageReport methodsFor: 'generating' stamp: 'lr 7/5/2010 13:26'!
generatePackage: aPackage class: aClass on: aStream
	| items |
	aStream tab: 4; nextPutAll: '<class name="'; nextPutAll: (self encode: aClass name); nextPutAll: '">'; nextPut: Character lf.
	self
		generateType: 'class' indent: 5
		total: 1
		actual: ((covered anySatisfy: [ :each | each actualClass theNonMetaClass = aClass ])
			ifTrue: [ 1 ] ifFalse: [ 0 ])
		on: aStream.
	self
		generateType: 'method' indent: 5
		total: (items := aPackage coreMethodsForClass: aClass) size
		actual: (covered count: [ :each | items includes: each ])
		on: aStream.
	items do: [ :each | self generatePackage: each method: each on: aStream ].	
	aStream tab: 4; nextPutAll: '</class>'; nextPut: Character lf! !

!HDCoverageReport methodsFor: 'generating' stamp: 'lr 7/5/2010 13:28'!
generatePackage: aPackage method: aReference on: aStream
	| items |
	aStream tab: 5; nextPutAll: '<method name="'; nextPutAll: (self encode: aReference selector); nextPutAll: '">'; nextPut: Character lf.
	self
		generateType: 'method' indent: 6
		total: 1
		actual: ((covered includes: aReference) ifTrue: [ 1 ] ifFalse: [ 0 ])
		on: aStream.
	aStream tab: 5; nextPutAll: '</method>'; nextPut: Character lf! !

!HDCoverageReport methodsFor: 'generating' stamp: 'lr 7/5/2010 13:30'!
generatePackage: aPackage on: aStream
	| items |
	aStream tab: 3; nextPutAll: '<package name="'; nextPutAll: (self encode: (aPackage packageName copyReplaceAll: '-' with: '.')); nextPutAll: '">'; nextPut: Character lf.
	self
		generateType: 'class' indent: 4
		total: (items := aPackage classes asSet) size
		actual: ((covered collect: [ :each | each actualClass theNonMetaClass ]) asSet
			count: [ :each | items includes: each ])
		on: aStream.
	self
		generateType: 'method' indent: 4
		total: (items := aPackage methods asSet) size
		actual: (covered count: [ :each | items includes: each ])
		on: aStream.
	aPackage classes 
		do: [ :class | self generatePackage: aPackage class: class on: aStream ].
	aStream tab: 3; nextPutAll: '</package>'; nextPut: Character lf! !

!HDCoverageReport methodsFor: 'generating' stamp: 'lr 7/5/2010 13:08'!
generateStatsOn: aStream
	aStream tab; nextPutAll: '<stats>'; nextPut: Character lf.
	aStream tab; tab; nextPutAll: '<packages value="'; print: (packages size); nextPutAll: '"/>'; nextPut: Character lf.
	aStream tab; tab; nextPutAll: '<classes value="'; print: (packages detectSum: [ :each | each classes size ]); nextPutAll: '"/>'; nextPut: Character lf.
	aStream tab; tab; nextPutAll: '<methods value="'; print: (packages detectSum: [ :each | each methods size ]); nextPutAll: '"/>'; nextPut: Character lf.
	aStream tab; nextPutAll: '</stats>'; nextPut: Character lf.! !

!HDCoverageReport methodsFor: 'generating' stamp: 'lr 7/5/2010 13:15'!
generateType: aString indent: anInteger total: totalInteger actual: actualInteger on: aStream
	aStream tab: anInteger; nextPutAll: '<coverage type="'; nextPutAll: aString; nextPutAll: ', %" value="'; print: (totalInteger = 0 ifTrue: [ 0 ] ifFalse: [ (100.0 * actualInteger / totalInteger) rounded ]); nextPutAll: '% ('; print: actualInteger; nextPut: $/; print: totalInteger; nextPutAll: ')"/>'; nextPut: Character lf! !


!HDCoverageReport methodsFor: 'running' stamp: 'lr 6/9/2010 19:30'!
setUp
	super setUp.
	wrappers := ((packages := self packagesIn: suite)
		gather: [ :package | self methodsIn: package ])
		collect: [ :each | HDTestCoverage on: each ].
	wrappers do: [ :each | each install ]! !

!HDCoverageReport methodsFor: 'running' stamp: 'lr 7/5/2010 08:22'!
tearDown
	wrappers do: [ :each | each uninstall ].
	super tearDown.
	self generate! !
