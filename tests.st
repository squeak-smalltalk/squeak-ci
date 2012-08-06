(FileDirectory default fileNamed: 'HudsonBuildTools.st') fileIn.

HDTestReport runPackages:    #(
	'ST80'
	'SystemChangeNotification'
	'Compression'
	'Tests'
	'TraitsTests'
	'GraphicsTests'
	'ToolsTests'
	'ToolBuilder'
	'CollectionsTests'
	'SUnit'
	'BalloonTests'
	'NetworkTests'
	'XML'
	'Etoys'
	'Nebraska'
	'MorphicTests'
	'KernelTests'
	'HelpSystem'
	'Universes'
	'SMBase'
	'VersionNumberTests'
	'MultilingualTests'
).

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].