HDTestReport runPackages: #(

	'HelpSystem-Tests'
	'ToolsTest-Browser'
	
).

"Save and Quit"
WorldState addDeferredUIMessage: [
	SmalltalkImage current snapshot: true andQuit: true ].