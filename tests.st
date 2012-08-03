| config |
Utilities setAuthorInitials: 'TestRunner'.

MCMcmUpdater defaultUpdateURL: 'http://source.squeak.org/trunk'.

"This comes from Utilities class >> #updateFromServer, but leaves off the #inform: call, which puts up a modal dialog. When running headless there's still a MorphicUIManager running"

"Update the image by loading all pending updates from the server."
"Flush all caches. If a previous download failed this is often helpful"
MCFileBasedRepository flushAllCaches.
config := MCMcmUpdater updateFromDefaultRepository.
config ifNil: [^self inform: 'Unable to retrieve updates from remote repository.' translated].
Utilities setSystemVersionFromConfig: config.

(FileDirectory default fileNamed: 'HudsonBuildTools.st') fileIn.

HDTestReport runPackages: #(
	#'BalloonTests-Fills'
	#'CollectionsTests-Abstract'
	#'CollectionsTests-Arrayed'
	#'CollectionsTests-Sequenceable'
	#'CollectionsTests-Stack'
	#'CollectionsTests-Streams'
	#'CollectionsTests-Support'
	#'CollectionsTests-Text'
	#'CollectionsTests-Unordered'
	#'CollectionsTests-Weak'
	#'Compression-Archives'
	#'Compression-Streams'
	#'Etoys-Tests'
	#'GraphicsTests-Files'
	#'GraphicsTests-Primitives'
	#'GraphicsTests-Text'
	#'HelpSystem-Tests'
	#'HelpSystem-Tests-Builders'
	#'HelpSystem-Tests-Core-Model'
	#'HelpSystem-Tests-Core-UI'
	#'KernelTests-Chronology'
	#'KernelTests-Classes'
	#'KernelTests-Methods'
	#'KernelTests-Numbers'
	#'KernelTests-Objects'
	#'KernelTests-Processes'
	#'MorphicTests-Basic'
	#'MorphicTests-Kernel'
	#'MorphicTests-Layouts'
	#'MorphicTests-Support'
	#'MorphicTests-Text Support'
	#'MorphicTests-Widgets'
	#'MorphicTests-Worlds'
	#'MultilingualTests-Display'
	#'MultilingualTests-TextConversion'
	#'Nebraska-Network-ObjectSocket'
	#'NetworkTests-Kernel'
	#'NetworkTests-Protocols'
	#'NetworkTests-RFC822'
	#'NetworkTests-URI'
	#'NetworkTests-UUID'
	#'NetworkTests-Url'
	#'SMBase-domain'
	#'ST80-Menus-Tests'
	#'ST80-Support-Tests'
	#'SUnit-Extensions'
	#'SUnit-Kernel'
	#'SUnit-Tests'
	#'SystemChangeNotification-Tests'
	#'Tests-Bugs'
	#'Tests-Compiler'
	#'Tests-Dependencies'
	#'Tests-Digital Signatures'
	#'Tests-Environments'
	#'Tests-Exceptions'
	#'Tests-FilePackage'
	#'Tests-Files'
	#'Tests-Finalization'
	#'Tests-Hex'
	#'Tests-Localization'
	#'Tests-Monticello'
	#'Tests-Object Events'
	#'Tests-ObjectsAsMethods'
	#'Tests-PrimCallController'
	#'Tests-Release'
	#'Tests-System-Support'
	#'Tests-Utilities'
	#'Tests-VM'
	#'ToolBuilder-Kernel'
	#'ToolBuilder-MVC'
	#'ToolBuilder-Morphic'
	#'ToolBuilder-SUnit'
	#'ToolsTest-Browser'
	#'ToolsTest-Browser'
	#'ToolsTest-Debugger'
	#'ToolsTest-FileList'
	#'ToolsTest-Inspector'
	#'ToolsTests-Browser'
	#'ToolsTests-Debugger'
	#'ToolsTests-FileList'
	#'ToolsTests-Inspector'
	#'TraitsTests-Kernel'
	#'Universes-Tests'
	#'XML-Parser'
	#VersionNumberTests
).

"Save and Quit"
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: true andQuit: true ].